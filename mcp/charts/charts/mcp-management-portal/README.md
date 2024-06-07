# mcp-management-portal

A Helm chart for the MCP Management Portal

![Version: 0.0.4](https://img.shields.io/badge/Version-0.0.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Description
Management Portal is an interface to manage resources registered in
[Maritime Identity Registry](https://github.com/maritimeconnectivity/IdentityRegistry)
and
[Maritime Service Registry](https://github.com/maritimeconnectivity/ServiceRegistry),
which are core components of
[Maritime Connectivity Platform](https://maritimeconnectivity.net/). The
starting foundation of this project has been build from the
[ngx-admin from Akveo](https://github.com/akveo/ngx-admin). The spin-off
implementation of Management Portal under the Apache 2.0 License.

## Live demo
You can experience a live demo from
[our public demonstrator environment](https://management.maritimeconnectivity.net).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"ENVIRONMENT_TITLE"` |  |
| env[0].valueFrom.configMapKeyRef.key | string | `"mcp_portal_title"` |  |
| env[0].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[10].name | string | `"MANAGEMENT_PORTAL_PROVIDER"` |  |
| env[10].valueFrom.configMapKeyRef.key | string | `"mcp_portal_management_portal_provider"` |  |
| env[10].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[11].name | string | `"MANAGEMENT_PORTAL_EMAIL"` |  |
| env[11].valueFrom.configMapKeyRef.key | string | `"mcp_portal_management_portal_email"` |  |
| env[11].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[12].name | string | `"APP_BASE_HREF"` |  |
| env[12].value | string | `"/mcp/portal/"` |  |
| env[1].name | string | `"MANAGEMENT_PORTAL_NAME"` |  |
| env[1].valueFrom.configMapKeyRef.key | string | `"mcp_portal_name"` |  |
| env[1].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[2].name | string | `"IDENTITY_PROVIDER_MRN_NAMESPACE"` |  |
| env[2].valueFrom.configMapKeyRef.key | string | `"mcp_portal_identity_provider_mrn_namespace"` |  |
| env[2].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[3].name | string | `"KEYCLOAK_SERVER_URL"` |  |
| env[3].valueFrom.configMapKeyRef.key | string | `"mcp_portal_keycloak_url"` |  |
| env[3].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[4].name | string | `"IDENTITY_REGISTRY_URL"` |  |
| env[4].valueFrom.configMapKeyRef.key | string | `"mcp_portal_identity_registry_url"` |  |
| env[4].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[5].name | string | `"IDENTITY_REGISTRY_PROVIDER"` |  |
| env[5].valueFrom.configMapKeyRef.key | string | `"mcp_portal_identity_registry_provider"` |  |
| env[5].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[6].name | string | `"IDENTITY_REGISTRY_EMAIL"` |  |
| env[6].valueFrom.configMapKeyRef.key | string | `"mcp_portal_identity_registry_email"` |  |
| env[6].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[7].name | string | `"SERVICE_REGISTRY_URL"` |  |
| env[7].valueFrom.configMapKeyRef.key | string | `"mcp_portal_service_registry_url"` |  |
| env[7].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[8].name | string | `"SERVICE_REGISTRY_PROVIDER"` |  |
| env[8].valueFrom.configMapKeyRef.key | string | `"mcp_portal_service_registry_provider"` |  |
| env[8].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| env[9].name | string | `"SERVICE_REGISTRY_EMAIL"` |  |
| env[9].valueFrom.configMapKeyRef.key | string | `"mcp_portal_service_registry_email"` |  |
| env[9].valueFrom.configMapKeyRef.name | string | `"mcp-management-portal-config"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
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
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"glarad/mcp-management-portal"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"mcp-management-portal.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `4200` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `"mcp-admin"` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
| waitForServices[0].serviceName | string | `"mc-identity-registry"` |  |
| waitForServices[0].servicePort | int | `8443` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)