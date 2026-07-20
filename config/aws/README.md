# AWS Deployment

This directory contains the AWS infrastructure needed to run the MCP Helm charts
on Amazon EKS.

| File | Purpose |
| ---- | ------- |
| `mcp-vpc.cloudformation.json` | CloudFormation template that builds the `mcp-vpc` network: 3 public + 3 private subnets across `eu-west-2a/b/c`, an internet gateway, a NAT gateway and the associated route tables. |
| `mcp-cluster.yaml` | `eksctl` cluster config: the `mcp` EKS cluster and its `mcp-nodes` managed node group, wired to the pre-existing cluster and node IAM roles. |

The template was reconstructed from the live `mcp-vpc` VPC
(`vpc-0b75a97743d9bca29`, account `322828184358`, region `eu-west-2`) and then
adjusted so that the network is actually usable by EKS. See
[Differences from the live VPC](#differences-from-the-live-vpc) below.

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
* `eksctl`, `kubectl` and `helm`.
* Permission to create VPC, EKS and IAM resources.

Confirm which account and region you are pointed at before you start, since
everything below is region scoped:

```bash
aws sts get-caller-identity
aws configure get region
```

## 1. Deploy the network

```bash
aws cloudformation deploy \
    --template-file config/aws/mcp-vpc.cloudformation.json \
    --stack-name mcp-vpc \
    --parameter-overrides ClusterName=mcp
```

IMPORTANT: this creates a **new** VPC. It does not adopt the existing
`mcp-vpc`, and the CIDRs of the two will overlap. That is legal between
separate VPCs, but if you intend to replace the original rather than run both,
delete the old one first. If you only want to keep using the VPC that is
already there, skip this step and go to
[Using the existing VPC](#using-the-existing-vpc).

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

## 2. Create the EKS cluster

The cluster is defined by [`mcp-cluster.yaml`](mcp-cluster.yaml). It reuses the
IAM roles that already exist in the account rather than letting `eksctl` create
its own — neither can be passed as a command line flag, which is why the
cluster is described in a config file:

| Role | Purpose |
| ---- | ------- |
| `AmazonEKSMCPClusterRole` | Cluster IAM role, set as `iam.serviceRoleARN` |
| `AmazonEKSMCPNodeRole` | Node IAM role, set as the node group's `iam.instanceRoleARN` |

Fill in the `<vpc id>` and `<... subnet id>` placeholders from the stack
outputs, then create the cluster:

```bash
eksctl create cluster -f config/aws/mcp-cluster.yaml
```

Note that this operation **can take a while** to complete (usually more that 15 mins) so be patient.

`privateNetworking: true` on the node group keeps the workers in the private
subnets, which is the point of the split layout. Adjust `instanceType` and
`desiredCapacity` to the workload; the MCP platform runs a Keycloak, a
PostgreSQL and several Spring services, so `t3.medium` is generally too small.

Both roles need the right policies and trust relationships attached or the
create will fail well into the run — the required ones are listed in the
comments in the config file. Check them first:

```bash
aws iam get-role --role-name AmazonEKSMCPClusterRole
aws iam list-attached-role-policies --role-name AmazonEKSMCPClusterRole

aws iam get-role --role-name AmazonEKSMCPNodeRole
aws iam list-attached-role-policies --role-name AmazonEKSMCPNodeRole
```

## 3. Connect to kubectl

Normally kubectl picks a cluster by context. Initially the EKS cluster isn't in your kubeconfig yet — you add it, then switch back and forth.

Step 1: Add the EKS cluster as a context (once, after it's created):

    aws eks update-kubeconfig --name mcp --region eu-west-2

This appends an EKS entry to ~/.kube/config and switches to it. It names the context after the cluster ARN — long and ugly — so give it an alias while you're there:


    aws eks update-kubeconfig --name mcp --region eu-west-2 --alias mcp-eks


Step 2: Switch between them:

    kubectl config use-context kubernetes-admin@kubernetes   # local
    kubectl config use-context mcp-eks                        # EKS

*use-context* changes the default for every later kubectl and helm command, and it persists across shells — this is the main footgun, since a helm install you meant for local silently hits EKS if you forgot to switch back.

***Safer for one-off commands*** — target a context per-command without changing the default:

kubectl --context mcp-eks get pods
    helm --kube-context mcp-eks install grad mcp-charts/mcp -n mcp -f config/values.yaml ...

***Always check before you install anything:***

    kubectl config current-context

## 4. Install the ingress controller

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

## 5. Install the MCP charts

Follow the main [README](../../README.md) for the full `helm install`
invocation and the keystore and truststore files it expects. Two values need
changing from the defaults before anything is reachable from outside the
cluster:

* `ingress.hosts[0].host` — defaults to `localhost`. Set this to the DNS name
  pointed at the load balancer.
* The `*_url` entries under `global` — these also default to `localhost` and
  need to match the public hostname, otherwise Keycloak will issue redirects
  back to the pod.

Point a CNAME at the load balancer hostname from step 3, then install as
described in the main README.

## Using the existing VPC

To deploy onto the VPC that is already in the account rather than a fresh one,
skip step 1 and put the existing ids into `mcp-cluster.yaml`
(`vpc.id: vpc-0b75a97743d9bca29`):

```
public:  subnet-04b37201ce0bf6a9d subnet-098809ed39f6b7850 subnet-034ccbe3d852586e1
private: subnet-00f9ac4dd9174409f subnet-0e471a2b8acecc38c subnet-0cd7d26fad82a9b6d
```

The three fixes listed below then have to be applied by hand, because the live
VPC does not currently have them:

```bash
# EKS cannot register worker nodes without this
aws ec2 modify-vpc-attribute --vpc-id vpc-0b75a97743d9bca29 --enable-dns-hostnames

# Load balancer subnet discovery
aws ec2 create-tags --resources subnet-04b37201ce0bf6a9d subnet-098809ed39f6b7850 subnet-034ccbe3d852586e1 \
    --tags Key=kubernetes.io/role/elb,Value=1 Key=kubernetes.io/cluster/mcp,Value=shared
aws ec2 create-tags --resources subnet-00f9ac4dd9174409f subnet-0e471a2b8acecc38c subnet-0cd7d26fad82a9b6d \
    --tags Key=kubernetes.io/role/internal-elb,Value=1 Key=kubernetes.io/cluster/mcp,Value=shared

# Public subnets need to hand out public IPs
for s in subnet-04b37201ce0bf6a9d subnet-098809ed39f6b7850 subnet-034ccbe3d852586e1; do
    aws ec2 modify-subnet-attribute --subnet-id "$s" --map-public-ip-on-launch
done
```

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

```bash
eksctl delete cluster --name mcp --region eu-west-2
aws cloudformation delete-stack --stack-name mcp-vpc
```

Delete the cluster first. The stack cannot be removed while EKS still holds
network interfaces in its subnets.
