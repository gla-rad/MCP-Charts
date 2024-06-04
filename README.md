# MCP-Charts
Kubernetes Helm Charts for deploying the Maritime Connectivity Platform (MCP)

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

## Chart Values
| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.keycloak_admin | string | `"admin"` |  |
| global.keycloak_admin_password | string | `"changeit"` |  |
| global.keycloak_admin_url | string | `"http://localhost/mcp/auth"` |  |
| global.keycloak_auth_url | string | `"http://localhost/mcp/auth"` |  |
| global.keycloak_db_password | string | `"changeit"` |  |
| global.keycloak_db_type | string | `"postgres"` |  |
| global.keycloak_db_url | string | `"jdbc:postgresql://localhost/keycloak_mcp"` |  |
| global.keycloak_db_username | string | `"admin"` |  |
| global.keycloak_keystore_password | string | `"changeit"` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_truststore_password | string | `"changeit\""` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
| global.mcp_identity_register_api_url | string | `"http://localhost/mcp/mir/oidc/api"` |  |
| global.mcp_identity_register_url | string | `"http://localhost/mcp/mir"` |  |
| global.mcp_portal_identify_registry_email | string | `"test@email.org"` |  |
| global.mcp_portal_identify_registry_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_portal_identify_registry_url | string | `"https://localhost/mcp/mir"` |  |
| global.mcp_portal_identity_provider_mrn_namespace | string | `"mcp"` |  |
| global.mcp_portal_management_portal_email | string | `"test@email.org"` |  |
| global.mcp_portal_management_portal_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_portal_name | string | `"MCP Testbed"` |  |
| global.mcp_portal_service_registry_email | string | `"test@email.org"` |  |
| global.mcp_portal_service_registry_provider | string | `"Maritime Connectivity Platform"` |  |
| global.mcp_portal_service_registry_url | string | `"https://mcp.grad-rrnav.pub/mcp/msr"` |  |
| global.mcp_portal_title | string | `"MCP Testbed - Test Environment"` |  |
| global.msr_database_host | string | `"localhost"` |  |
| global.msr_database_password | string | `"changeit"` |  |
| global.msr_database_port | int | `5432` |  |
| global.msr_database_type | string | `"postgresql"` |  |
| global.msr_database_username | string | `"admin"` |  |
| global.msr_keycloak_client_id | string | `"mcpsvreg"` |  |
| global.msr_keycloak_client_secret | string | `"changeit"` |  |
| global.msr_ledger_address | string | `"0x000000000000000000000000000000000000000"` |  |
| global.msr_ledger_credentials | string | `"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"` |  |
| global.msr_ledger_host | string | `"mc-msr-ledger.mcp"` |  |
| global.msr_ledger_port | int | `8546` |  |
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
