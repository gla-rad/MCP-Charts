
[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/mcp-charts)](https://artifacthub.io/packages/search?repo=mcp-charts)

# MCP-Charts
Kubernetes Helm Charts for deploying the Maritime Connectivity Platform (MCP)

These Helm charts are also published and available throu the Helm
[Artifact Hub](https://artifacthub.io) package manager. To access it please use
the badge available on the top of this page.

## Description 
This is a repository generated and currently maintened by the Research and
Development Directorate (GRAD) of the General LIghthouse Authorities of the UK
and Ireland (GLA). The main purpose is to provide an easy way to deploy the
[Maritime Connectivity Platform (MCP)](https://maritimeconnectivity.net/)
services into a Kubernetes environemnt using Helm charts.

## Workflows
This project is based on github workflows to build and publish the charts
as a Helm Chart repository using the Github pages. The main guides to do 
this were the official
[Helm documentation](https://helm.sh/docs/howto/chart_releaser_action/)
as well an other online resources such as
[this](https://dev.to/jamiemagee/how-to-host-your-helm-chart-repository-on-github-3kd).

The are two scripts included in the workflows:
* The **helm-docs** script: This can be used to generate the documentation for
  the helm charts included automatically.
* The **kubeconform** script: This can be used to easily test that the charts
  conforms to the a given kubernetes schema. The **KUBERNETES_VERSION**
  environment parameter is requiered for this action.

Just run the two scripts from the top level directory are follows:

```
$ .github/helm-docs.sh
```

and 

```
$ .github/kubeconform.sh
```

## How to install
To install the whole MCP platform in your kubernetes cluster you can use this
helm script.

First you will need to install the MCP-Charts Helm repository:

```bash
helm repo add mcp-charts https://gla-rad.github.io/MCP-Charts/
```

And the you can install it as follows. Note that you will need to provide
a certain configuration files. First there is the **values.yaml** which contains
all the configuration parameters for all childern charts, but also a set of
keystores and truststores, mainly for the keycloak and the MIR modules.

IMPORTANT: All binary files need to be encoded into Base64 beforehand since
helm will not be able to load the otherwise. Plain text configuration files
however can be provided as they are. Also the private keys provided, need to
be PEM encoded ECDSA keys, in PKCS1 format.

```bash
helm install grad mcp-charts/mcp -n mcp -f config/values.yaml \
    --set-file global.mc_keycloak.keystore=config/idbroker-updater.jks.b64 \
    --set-file global.mc_keycloak.truststore=config/root-ca-keystore.jks.b64 \
    --set-file global.mc_identity_registry.configuration=config/application.yaml \
    --set-file global.mc_identity_registry.keycloak_json=config/keycloak.json \
    --set-file global.mc_identity_registry.keystore=config/subca-keystore.jks.b64 \
    --set-file global.mc_identity_registry.truststore=config/mcp-truststore.jks.b64 \
    --set-file global.mc_mms_router.private_key=config/router-cert-key.pkcs \
    --set-file global.mc_mms_router.certificate=config/router-cert.pem \
    --set-file global.mc_mms_router.certificate_key=config/router-cert-key.pkcs  \
    --set-file global.mc_mms_router.client_ca=config/ca-chain.pem \
    --set-file global.mc_mms_router.beacons=config/beacons.txt \
    --set-file global.mc_mms_edge_router.certificate=config/edge-router-cert.pem \
    --set-file global.mc_mms_edge_router.certificate_key=config/edge-router-cert-key.pkcs  \
    --set-file global.mc_mms_edge_router.client_certificate=config/edge-router-cert.pem \
    --set-file global.mc_mms_edge_router.client_certificate_key=config/edge-router-cert-key.pkcs \
    --set-file global.mc_mms_edge_router.client_ca=config/ca-chain.pem
```

## Configuration Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
| global.mc_identity_registry.configuration | string | `""` |  |
| global.mc_identity_registry.keycloak_json | string | `""` |  |
| global.mc_identity_registry.keystore | string | `""` |  |
| global.mc_identity_registry.truststore | string | `""` |  |
| global.mc_keycloak.admin_password | string | `"changeit"` |  |
| global.mc_keycloak.admin_url | string | `"http://localhost/mcp/auth"` |  |
| global.mc_keycloak.admin_username | string | `"admin"` |  |
| global.mc_keycloak.auth_url | string | `"http://localhost/mcp/auth"` |  |
| global.mc_keycloak.db_password | string | `"changeit"` |  |
| global.mc_keycloak.db_type | string | `"postgres"` |  |
| global.mc_keycloak.db_url | string | `"jdbc:postgresql://localhost/keycloak_mcp"` |  |
| global.mc_keycloak.db_username | string | `"admin"` |  |
| global.mc_keycloak.keystore | string | `""` |  |
| global.mc_keycloak.keystore_password | string | `"changeit"` |  |
| global.mc_keycloak.mir_url | string | `"http://localhost/mcp/mir"` |  |
| global.mc_keycloak.truststore | string | `""` |  |
| global.mc_keycloak.truststore_password | string | `"changeit\""` |  |
| global.mc_mms_edge_router | string | `nil` |  |
| global.mc_mms_router | string | `nil` |  |
| global.mc_msr_ledger | string | `nil` |  |
| global.mc_service_registry.db_host | string | `"localhost"` |  |
| global.mc_service_registry.db_password | string | `"changeit"` |  |
| global.mc_service_registry.db_port | int | `5432` |  |
| global.mc_service_registry.db_type | string | `"postgresql"` |  |
| global.mc_service_registry.db_username | string | `"admin"` |  |
| global.mc_service_registry.keycloak_client_id | string | `"mcpsvreg"` |  |
| global.mc_service_registry.keycloak_client_secret | string | `"changeit"` |  |
| global.mc_service_registry.ledger_address | string | `"0x000000000000000000000000000000000000000"` |  |
| global.mc_service_registry.ledger_credentials | string | `"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"` |  |
| global.mc_service_registry.ledger_host | string | `"mc-msr-ledger.mcp"` |  |
| global.mc_service_registry.ledger_port | int | `8546` |  |
| global.mc_service_registry.mir_api_url | string | `"http://localhost/mcp/mir/oidc/api"` |  |
| global.mcp_management_portal.identity_provider_mrn_namespace | string | `"mcp"` |  |
| global.mcp_management_portal.identity_registry_email | string | `"test@email.org"` |  |
| global.mcp_management_portal.identity_registry_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_management_portal.identity_registry_url | string | `"https://localhost/mcp/mir"` |  |
| global.mcp_management_portal.management_portal_email | string | `"test@email.org"` |  |
| global.mcp_management_portal.management_portal_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_management_portal.name | string | `"MCP Testbed"` |  |
| global.mcp_management_portal.service_registry_email | string | `"test@email.org"` |  |
| global.mcp_management_portal.service_registry_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_management_portal.service_registry_url | string | `"https://mcp.grad-rrnav.pub/mcp/msr"` |  |
| global.mcp_management_portal.title | string | `"MCP Testbed - Test Environment"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/rewrite-target" | string | `"/$1$2"` |  |
| ingress.annotations."nginx.ingress.kubernetes.io/use-regex" | string | `"true"` |  |
| ingress.className | string | `"nginx"` |  |
| ingress.enabled | bool | `true` |  |
| ingress.hosts[0].host | string | `"localhost"` |  |
| ingress.hosts[0].paths[0].path | string | `"/mcp/(auth)(.*)"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.hosts[0].paths[0].serviceName | string | `"mc-keycloak"` |  |
| ingress.hosts[0].paths[0].servicePort | int | `8090` |  |
| ingress.hosts[0].paths[1].path | string | `"/(mcp/mir)(.*)"` |  |
| ingress.hosts[0].paths[1].pathType | string | `"ImplementationSpecific"` |  |
| ingress.hosts[0].paths[1].serviceName | string | `"mc-identity-registry"` |  |
| ingress.hosts[0].paths[1].servicePort | int | `8443` |  |
| ingress.hosts[0].paths[2].path | string | `"/(mcp/msr)(.*)"` |  |
| ingress.hosts[0].paths[2].pathType | string | `"ImplementationSpecific"` |  |
| ingress.hosts[0].paths[2].serviceName | string | `"mc-service-registry"` |  |
| ingress.hosts[0].paths[2].servicePort | int | `8444` |  |
| ingress.hosts[0].paths[3].path | string | `"/mcp/ledger()(.*)"` |  |
| ingress.hosts[0].paths[3].pathType | string | `"ImplementationSpecific"` |  |
| ingress.hosts[0].paths[3].serviceName | string | `"mc-msr-ledger"` |  |
| ingress.hosts[0].paths[3].servicePort | int | `8545` |  |
| ingress.hosts[0].paths[4].path | string | `"/mcp/portal()(.*)"` |  |
| ingress.hosts[0].paths[4].pathType | string | `"ImplementationSpecific"` |  |
| ingress.hosts[0].paths[4].serviceName | string | `"mcp-management-portal"` |  |
| ingress.hosts[0].paths[4].servicePort | int | `4200` |  |
| ingress.name | string | `"mcp-ingress"` |  |
| ingress.tls | list | `[]` |  |

## Contributing
Pull requests are welcome. For major changes, please open an issue first to
discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
Distributed under the Apache License. See [LICENSE](./LICENSE) for more
information.

## Contact
Nikolaos Vastardis - Nikolaos.Vastardis@gla-rad.org
