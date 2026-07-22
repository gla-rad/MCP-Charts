# AWS Deployment

This directory contains the AWS infrastructure needed to run the MCP Helm charts
on Amazon EKS.

| File | Purpose |
| ---- | ------- |
| `mcp-vpc.cloudformation.json` | CloudFormation template that builds the `mcp-vpc` network: 3 public + 3 private subnets across `eu-west-2a/b/c`, an internet gateway, a NAT gateway and the associated route tables. |
| `mcp-rds.cloudformation.json` | CloudFormation template that builds the `mcp-rds` PostgreSQL instance in the private subnets, holding the Keycloak, Identity Registry and Service Registry databases. |
| `mcp-cluster.yaml` | `eksctl` cluster config template: the EKS cluster and its `mcp-nodes` managed node group, wired to the pre-existing cluster and node IAM roles. The cluster name and network ids are substituted at call time. |
| `create-cluster.sh` | Renders `mcp-cluster.yaml` from the VPC stack outputs and hands it to `eksctl`. Takes the VPC stack name and the cluster name. |
| `cert-manager-issuers.yaml` | Let's Encrypt staging and production `ClusterIssuer`s for the ingress certificate. |

## Network layout

| Subnet | CIDR | AZ | Egress |
| ------ | ---- | -- | ------ |
| MCP Public Subnet 1 | `10.1.0.0/20` | `eu-west-2a` | Internet Gateway |
| MCP Public Subnet 2 | `10.1.16.0/20` | `eu-west-2b` | Internet Gateway |
| MCP Public Subnet 3 | `10.1.32.0/20` | `eu-west-2c` | Internet Gateway |
| MCP Private Subnet 1 | `10.1.128.0/19` | `eu-west-2a` | NAT Gateway |
| MCP Private Subnet 2 | `10.1.160.0/19` | `eu-west-2b` | NAT Gateway |
| MCP Private Subnet 3 | `10.1.192.0/19` | `eu-west-2c` | NAT Gateway |

Worker nodes belong in the private subnets. The public subnets exist only to
host the load balancers and the NAT gateway.

## Prerequisites

* The AWS CLI, configured with credentials for the target account.
* `eksctl`, `kubectl`, `helm` and `envsubst` (part of GNU gettext).
* Permission to create VPC, EKS, RDS and IAM resources.
* Control of a DNS zone, to point a name at the load balancer in step 6. The
  platform is unusable without one — see that step for why the raw load
  balancer hostname is not a substitute.

Confirm which account and region you are pointed at before you start, since
everything below is region scoped:

```bash
aws sts get-caller-identity
aws configure get region
```

The commands below refer to the cluster by `$CLUSTER_NAME` throughout. Set it
once, and use the same value for the `ClusterName` parameter in step 1 — the
two must agree, for the reason given there:

```bash
export CLUSTER_NAME=mcp-cluster-<instance-id>
```

## 1. Deploy the network

```bash
aws cloudformation deploy \
    --template-file config/aws/mcp-vpc.cloudformation.json \
    --stack-name mcp-vpc \
    --parameter-overrides ClusterName="$CLUSTER_NAME"
```

IMPORTANT: `ClusterName` is not cosmetic. It builds the
`kubernetes.io/cluster/<name>` tags on the subnets, and it **must** equal the
`CLUSTER_NAME` used for the cluster in step 3. If the two disagree the cluster
still builds and the nodes still join, but every `Service` of type
`LoadBalancer` sits at `<pending>` forever because the cloud controller treats
a subnet tagged for a different cluster as belonging to that cluster and skips
it. Confirm the two agree with:

```bash
aws ec2 describe-tags --filters "Name=key,Values=kubernetes.io/cluster/$CLUSTER_NAME" \
    --query 'length(Tags[?ResourceType==`subnet`])'
```

Six is the answer you want. Zero means the tags name a different cluster; fix
it by redeploying this stack with the right `ClusterName` — the tag update is
in place and does not disturb a running cluster.

The subnet CIDRs are all template parameters, so a second isolated environment
can be built from the same file:

```bash
aws cloudformation deploy \
    --template-file config/aws/mcp-vpc.cloudformation.json \
    --stack-name mcp-vpc-staging \
    --parameter-overrides ClusterName=mcp-staging \
        VpcCidr=10.2.0.0/16 \
        PublicSubnet1Cidr=10.2.0.0/20 \
        PublicSubnet2Cidr=10.2.16.0/20 \
        PublicSubnet3Cidr=10.2.32.0/20 \
        PrivateSubnet1Cidr=10.2.128.0/19 \
        PrivateSubnet2Cidr=10.2.160.0/19 \
        PrivateSubnet3Cidr=10.2.192.0/19
```

Read the resulting subnet ids back out of the stack outputs:

```bash
aws cloudformation describe-stacks --stack-name mcp-vpc \
    --query 'Stacks[0].Outputs' --output table
```

`PublicSubnetIds`, `PrivateSubnetIds`, `VpcId` and `NatGatewayPublicIp` are all
exported, so sibling stacks can import them with `Fn::ImportValue`.

`NatGatewayPublicIp` is the single egress address for everything in the private
subnets. This is the address to hand over when an external service needs an IP
allowlist entry.

## 2. Deploy the databases

The platform needs three PostgreSQL databases. They live on one shared RDS
instance in the private subnets, described by
[`mcp-rds.cloudformation.json`](mcp-rds.cloudformation.json):

| Database | Consumer | Wired through |
| -------- | -------- | ------------- |
| `keycloak_mcp` | Keycloak | `global.mc_keycloak.db_url` |
| `mcp_identity_registry` | Identity Registry | `global.mc_identity_registry.db_url` |
| `mcp_service_registry` | Service Registry | `global.mc_service_registry.db_host` + `.db_name` |

This is a separate stack rather than part of `mcp-vpc` on purpose. The instance
carries `DeletionPolicy: Snapshot`, so it must not share a lifecycle with a
network stack you may want to delete outright.

Deploy it after the network and before the cluster — RDS takes about ten
minutes, which overlaps with nothing else:

```bash
aws cloudformation deploy \
    --template-file config/aws/mcp-rds.cloudformation.json \
    --stack-name mcp-rds \
    --parameter-overrides VpcStackName=mcp-vpc
```

The VPC id and private subnet ids are pulled from the `mcp-vpc` exports with
`Fn::ImportValue`, so there is nothing to copy by hand. Everything else is a
parameter — `DbInstanceClass` (default `db.t4g.medium`), `AllocatedStorage`,
`MultiAz`, `BackupRetentionPeriod` and `DeletionProtection`.

The master password is generated into Secrets Manager rather than passed on the
command line, and the security group admits `5432` from `DbAccessCidr`, which
defaults to the VPC CIDR. Nothing outside the VPC can reach the instance, and
`PubliclyAccessible` is false, so there is no route in from the internet.

Note that `DeletionProtection` defaults to `true`. Deleting the stack fails
until it is turned off with a stack update.

### Create the per-service databases and roles

CloudFormation's `DBName` only creates the first database, so `keycloak_mcp`
comes up with the stack and the other two have to be created once by hand.
Read the endpoint and the master password out first:

```bash
aws cloudformation describe-stacks --stack-name mcp-rds \
    --query 'Stacks[0].Outputs' --output table

aws secretsmanager get-secret-value \
    --secret-id "$(aws cloudformation describe-stacks --stack-name mcp-rds \
        --query 'Stacks[0].Outputs[?OutputKey==`DbSecretArn`].OutputValue' --output text)" \
    --query SecretString --output text
```

The secret's name is generated rather than fixed, so it is always looked up
through the `DbSecretArn` output. A fixed name would be friendlier to type but
would make the stack undeployable for 30 days after a teardown — see
[Teardown](#teardown).

The instance is not reachable from a laptop, so run `psql` from inside the
cluster. This needs the cluster from step 3, so come back to it after the
cluster exists:

```bash
kubectl run pg-bootstrap --rm -it --restart=Never --image=postgres:16 -- \
    psql "postgresql://mcpadmin:<master password>@<endpoint>:5432/postgres"
```

Then, at the prompt — pick real passwords, these are the ones that go into the
Helm values:

```sql
CREATE ROLE keycloak_mcp LOGIN PASSWORD '<keycloak password>';
CREATE ROLE mir_admin    LOGIN PASSWORD '<mir password>';
CREATE ROLE msr_admin    LOGIN PASSWORD '<msr password>';

ALTER DATABASE keycloak_mcp OWNER TO keycloak_mcp;
CREATE DATABASE mcp_identity_registry OWNER mir_admin;
CREATE DATABASE mcp_service_registry  OWNER msr_admin;
```

Each service owns its own database and cannot touch the others. All three
applications run their own schema migrations on first start — Keycloak
natively, and both registries through Flyway — so no schema needs loading.

Note that you also need to create the `postgis` extension inside the MSR
database as such:

```sql
\c mcp_service_registry
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Point the charts at it

Four values in `config/values.yaml` change, using the stack outputs. The
`KeycloakJdbcUrl` and `IdentityRegistryJdbcUrl` outputs are pre-assembled for
exactly this:

```yaml
global:
  mc_keycloak:
    db_username: "keycloak_mcp"
    db_password: "<keycloak password>"
    db_url: "jdbc:postgresql://<endpoint>:5432/keycloak_mcp"

  mc_identity_registry:
    db_username: "mir_admin"
    db_password: "<mir password>"
    db_url: "jdbc:postgresql://<endpoint>:5432/mcp_identity_registry"

  mc_service_registry:
    db_username: "msr_admin"
    db_password: "<msr password>"
    db_host: "<endpoint>"
    db_port: 5432
    db_name: "mcp_service_registry"
```

The Service Registry is the one that takes its datasource in pieces rather than
as a JDBC URL — its image assembles the URL from `DATABASE_SERVER_TYPE`,
`DATABASE_SERVER_HOST`, `DATABASE_SERVER_PORT` and `DATABASE_NAME` in the
bundled `bootstrap.yaml`. That is why the stack exports a `KeycloakJdbcUrl` and
an `IdentityRegistryJdbcUrl` but no equivalent for MSR: it would have nothing to
consume it. Use the plain `DbEndpoint` and `DbPort` outputs instead.

The Identity Registry is the odd one of the three. Its datasource is normally
baked into the `spring.datasource` block of the mounted `application.yaml`
rather than templated, so the chart exports the three `mc_identity_registry`
values above as `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME` and
`SPRING_DATASOURCE_PASSWORD`. Environment variables outrank the config file in
Spring, so these win. Leave them empty and the keys are never written at all,
and the mounted `application.yaml` applies unchanged — existing deployments are
unaffected.

## 3. Create the EKS cluster

The cluster is defined by [`mcp-cluster.yaml`](mcp-cluster.yaml). It reuses the
IAM roles that already exist in the account rather than letting `eksctl` create
its own — neither can be passed as a command line flag, which is why the
cluster is described in a config file:

| Role | Purpose |
| ---- | ------- |
| `AmazonEKSMCPClusterRole` | Cluster IAM role, set as `iam.serviceRoleARN` |
| `AmazonEKSMCPNodeRole` | Node IAM role, set as the node group's `iam.instanceRoleARN` |

The file is a template, not a ready to run config.

[`create-cluster.sh`](create-cluster.sh) does the substitution, reading every
id straight out of the VPC stack outputs so nothing is copied by hand. It
takes the stack name and the cluster name:

```bash
./config/aws/create-cluster.sh mcp-vpc "$CLUSTER_NAME"
```

Check what will be built before committing 20 minutes to it. Any extra
arguments are passed through to `eksctl create cluster`, so `--dry-run`
resolves and validates the whole config without creating anything:

```bash
./config/aws/create-cluster.sh mcp-vpc "$CLUSTER_NAME" --dry-run
```

Note that the real operation **can take a while** to complete (usually more
that 15 mins) so be patient.

Before it starts, the script refuses the `ClusterName` mismatch described in
step 1. `--skip-tag-check` overrides it, which is only useful against a VPC
that mcp-vpc did not build.

Because both names are arguments, a second environment needs no edits to any
file — point the script at the staging pair from step 1:

```bash
./config/aws/create-cluster.sh mcp-vpc-staging mcp-staging
```

`privateNetworking: true` on the node group keeps the workers in the private
subnets, which is the point of the split layout. Adjust `instanceType` and
`desiredCapacity` to the workload; the MCP platform runs a Keycloak and several
Spring services, so `t3.medium` is generally too small. The databases are not
part of this — they sit on RDS from step 2, off the nodes entirely.

Both roles need the right policies and trust relationships attached or the
create will fail well into the run — the required ones are listed in the
comments in the config file. Check them first:

```bash
aws iam get-role --role-name AmazonEKSMCPClusterRole
aws iam list-attached-role-policies --role-name AmazonEKSMCPClusterRole

aws iam get-role --role-name AmazonEKSMCPNodeRole
aws iam list-attached-role-policies --role-name AmazonEKSMCPNodeRole
```

## 4. Connect to kubectl

Normally kubectl picks a cluster by context. Initially the EKS cluster isn't
in your kubeconfig yet — you add it, then switch back and forth.

Step 1: Add the EKS cluster as a context (once, after it's created):

    aws eks update-kubeconfig --name "$CLUSTER_NAME" --region eu-west-2

This appends an EKS entry to ~/.kube/config and switches to it. It names the
context after the cluster ARN — long and ugly — so give it an alias
while you're there:


    aws eks update-kubeconfig --name "$CLUSTER_NAME" --region eu-west-2 --alias mcp-eks

The `mcp-eks` alias is deliberately independent of the cluster name, so the
commands below keep working whatever the cluster is called.


Step 2: Switch between them:

    kubectl config use-context kubernetes-admin@kubernetes   # local
    kubectl config use-context mcp-eks                        # EKS

*use-context* changes the default for every later kubectl and helm command, and
it persists across shells — this is the main footgun, since a helm install you
meant for local silently hits EKS if you forgot to switch back.

***Safer for one-off commands*** — target a context per-command without changingthe default:

    kubectl --context mcp-eks get pods
    helm --kube-context mcp-eks install grad mcp-charts/mcp -n mcp -f config/values.yaml ...

***Always check before you install anything:***

    kubectl config current-context

## 5. Install the ingress controller

The chart's ingress is defined with `className: nginx` (see `ingress` in
`config/values.yaml`), so the cluster needs the **ingress-nginx** controller
rather than the AWS Load Balancer Controller:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx --create-namespace \
    --set controller.service.type=LoadBalancer \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"=nlb
```

The controller's `Service` is what provisions the AWS load balancer. It is
placed into the public subnets by way of the `kubernetes.io/role/elb` tags the
template applies, which is why those tags matter. Wait for the external address
before continuing:

```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller -w
```

`EXTERNAL-IP` will show a **DNS hostname**, not an address — an NLB has no
static IP. That hostname is the external entry point; nothing else has to be
allocated. If it stays `<pending>`, check the subnet tags from step 1.

## 6. Point DNS at the load balancer

Every URL in the platform derives from one hostname, and it has to be chosen
before anything is deployed rather than read back afterwards. Keycloak stamps
the issuer into every token from `KC_HOSTNAME`, and the registries validate it
against `issuer-uri`; if the two do not match exactly, every token is rejected.
So the hostname is an input, not something Keycloak decides.

Point it at the load balancer from step 5:

```
mcp.gla-rad.org   CNAME   <the EXTERNAL-IP hostname>
```

Do not use the raw load balancer hostname as the platform address. No
certificate can be issued for a domain you do not own, and the name changes if
the ingress `Service` is ever recreated, which would invalidate every URL and
token issuer at once.

Confirm before continuing, since certificate issuance depends on it:

```bash
dig +short mcp.gla-rad.org
```

## 7. Issue the TLS certificate

The URLs are all `https`, and nothing sits in front of the cluster to terminate
TLS, so a certificate is needed. It is issued by **cert-manager** and terminated
at ingress-nginx.

Terminating at the NLB with an ACM certificate is possible but is the wrong
choice here: an NLB is layer 4, so it forwards decrypted traffic as raw TCP
with no `X-Forwarded-Proto`. nginx would read the request as plain HTTP and
Keycloak would issue `http://` redirects. Terminating at nginx sets the
forwarded headers correctly.

```bash
helm repo add jetstack https://charts.jetstack.io
helm install cert-manager jetstack/cert-manager \
    -n cert-manager --create-namespace --set crds.enabled=true

kubectl apply -f config/aws/cert-manager-issuers.yaml
```

No Let's Encrypt account has to be created first — cert-manager generates an
ACME account key and registers it on first use. Both issuers should report
`READY  True` within seconds, which happens without DNS:

```bash
kubectl get clusterissuer
```

`config/values.yaml` already carries the annotation and the `tls` block:

```yaml
ingress:
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-staging
  tls:
    - secretName: mcp-tls
      hosts:
        - mcp.gla-rad.org
```

The certificate is requested when the chart is installed in step 8. Follow it
with:

```bash
kubectl get certificate,order,challenge -A
```

**Start on staging, then move to production.** Production allows only 5 failed
validations per hour, which is easy to exhaust on a DNS or ingress path
problem. Once a staging certificate issues cleanly, switch the annotation to
`letsencrypt-prod` and delete the secret so a trusted certificate is requested:

```bash
kubectl delete secret mcp-tls -n <namespace>
```

Staging certificates chain to an untrusted root. Browsers warn, and more
importantly the Java services reject the chain with `PKIX path building
failed` when they call Keycloak over HTTPS. Staging proves the plumbing —
DNS, challenge routing, issuance — but the platform will not work end to end
until the annotation is on `letsencrypt-prod`.

## 8. Install the MCP charts

Follow the main [README](../../README.md) for the full `helm install`
invocation and the keystore and truststore files it expects.

`config/values.yaml` is already set for `mcp.gla-rad.org`. Deploying under a
different name means changing every one of these, since they must all agree
with the certificate and with each other:

| File | Fields |
| ---- | ------ |
| `config/values.yaml` | `keycloak_url`, `auth_url`, `admin_url`, `mir_url`, `mir_api_url`, `identity_registry_url`, `service_registry_url`, `ingress.hosts[0].host`, `ingress.tls[0].hosts` |
| `config/application.yaml` | 3 × `keycloak-*-base-url`, `issuer-uri`, `base-crl-ocsp-path`, `portal-url`, 2 × `openapi` paths |
| `config/keycloak.json` | `auth-server-url` |

Keycloak is configured for this topology with `KC_PROXY_HEADERS=xforwarded` and
`KC_HTTP_ENABLED=true`, since TLS terminates at the ingress rather than in the
pod. Without them Keycloak reads the scheme from the plain HTTP connection out
of nginx and issues `http://` redirects and token issuers, which then fail
validation against the `https` `issuer-uri` the registries use.


## Differences from the live VPC

The template is not a byte for byte copy of what is in the account. Three
settings were changed because EKS does not work without them:

1. **`enableDnsHostnames`** was `false` on the live VPC and is `true` in the
   template. Worker nodes cannot join the cluster without it.
2. **`kubernetes.io/role/elb` and `kubernetes.io/role/internal-elb` subnet
   tags** were absent and are now set. Ingress load balancer provisioning fails
   with a subnet discovery error when they are missing.
3. **`MapPublicIpOnLaunch`** was `false` on the public subnets and is `true` in
   the template.

## Known issues

* **NAT gateway placement is unverified.** `describe-nat-gateways` returns no
  `SubnetId` for `nat-1b7f749f37f95f1cd`, and reports three EIP allocation ids
  against what the API describes as a single gateway. The template places the
  NAT in Public Subnet 1, which is the conventional choice, but this should be
  confirmed against the console before the template is relied on as an accurate
  record of the live network.
* **`rtb-0c01e566c09090b48` is orphaned** in the live VPC. It carries a default
  route to the internet gateway but has no subnet associations, and looks like
  a leftover. It is deliberately not reproduced in the template.
* **Single NAT gateway, no AZ redundancy.** All three private subnets egress
  through one NAT in a single AZ. This is roughly £90/month cheaper than one
  per AZ, but the loss of that AZ takes out egress for the whole cluster. For
  production, add a NAT and a route table per AZ.

## Teardown

Deletion protection **must** come off before you call `delete-stack`, not
after. Getting this order wrong is not harmful, but it is annoying to undo —
see [Recovering a DELETE_FAILED RDS stack](#recovering-a-delete_failed-rds-stack).

```bash
eksctl delete cluster --name "$CLUSTER_NAME" --region eu-west-2

# Step 1: take deletion protection off while the stack is still updatable
aws cloudformation deploy \
    --template-file config/aws/mcp-rds.cloudformation.json \
    --stack-name mcp-rds \
    --parameter-overrides DeletionProtection=false

# Step 2: only then delete
aws cloudformation delete-stack --stack-name mcp-rds
aws cloudformation wait stack-delete-complete --stack-name mcp-rds

aws cloudformation delete-stack --stack-name mcp-vpc
```

Order matters in both directions. Delete the cluster first, since the VPC stack
cannot be removed while EKS still holds network interfaces in its subnets, and
delete `mcp-rds` before `mcp-vpc`, since the RDS stack imports the VPC's
exports and CloudFormation refuses to delete a stack whose exports are in use.

The database is `DeletionPolicy: Snapshot`, so deleting the stack leaves a
final snapshot behind. That is deliberate, but it is not free — remove it
explicitly once you are certain:

```bash
aws rds describe-db-snapshots --db-instance-identifier mcp-rds \
    --query 'DBSnapshots[].DBSnapshotIdentifier'
```

## Recovering a DELETE_FAILED RDS stack

If `delete-stack` was called while `DeletionProtection` was still `true`, RDS
refuses the delete and the stack lands in `DELETE_FAILED`:

```
The following resource(s) failed to delete: [DbInstance].
```

Nothing has been destroyed at this point — the instance is still `available`
and the protection flag did its job. But a `DELETE_FAILED` stack **cannot be
updated**, only deleted again, so the `aws cloudformation deploy` above no
longer works:

```
Stack ... is in DELETE_FAILED state and can not be updated.
```

Clear the flag on the instance directly through the RDS API instead, then
re-run the delete:

```bash
aws rds modify-db-instance --db-instance-identifier mcp-rds --no-deletion-protection
aws cloudformation delete-stack --stack-name mcp-rds
aws cloudformation wait stack-delete-complete --stack-name mcp-rds
```

To keep the database instead, delete the stack with `--retain-resources`. Note
that this takes two passes, because CloudFormation only accepts logical ids
that are already in `DELETE_FAILED`, and the security group and subnet group
reach that state only once they are found to be in use by the retained
instance. The resources are then orphaned until a resource import adopts them
into a new stack.
