# mcp

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

A Helm chart for deploying the Maritime Connectivity Platform (MCP) in Kubernetes

## Values

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
| global.keycloak_idbroker_updater | string | `""` |  |
| global.keycloak_keystore_password | string | `"changeit"` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_truststore | string | `""` |  |
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
| global.mir_api_config | string | `""` |  |
| global.mir_api_keycloak_json | string | `""` |  |
| global.mir_api_subca_keystore | string | `""` |  |
| global.mir_api_truststore | string | `""` |  |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
