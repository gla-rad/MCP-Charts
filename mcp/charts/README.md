# mcp

A Helm chart for deploying the Maritime Connectivity Platform (MCP) in Kubernetes

![Version: 0.0.6](https://img.shields.io/badge/Version-0.0.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Description
The the Maritime Connectivity Platform (MCP) is a decentralised platform that
facilitates secure and reliable information exchange within the maritime domain
and beyond. Beyond – because the maritime world isn’t isolated, but need to
exchange information with other domain – for instance with other transport
domains.

The information exchanged can be almost of any nature, ranging from private
confidential information between a vessel and the shore office of the shipowner,
to public information provided by authorities, such as the provision of
navigational warnings.

As a decentralised platform, there is no single entity operating this. Several
organisations are MCP service providers, and collectively they form “the
Maritime Connectivity Platform”.

## Values

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
| global.mc_keycloak.truststore_password | string | `"changeit"` |  |
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

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)