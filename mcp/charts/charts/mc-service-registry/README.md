# mc-service-registry

A Helm chart for the MCP MSR service

![Version: 0.0.5](https://img.shields.io/badge/Version-0.0.5-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Description
The MSR does not provide actual maritime information but a specification of
various services, the information that they carry, and the technical means to
obtain it. An MSR instance contains service specifications according to a
Service Specification Standard (which is identical to
[IALA Guideline 1128](https://www.iala-aism.org/product/g1128/)) and
provisioned service instances implemented according to these service
specifications.

The functionality of the MSR is twofold: service discovery and service
management. It enables service providers to register their services in the MCP
and allows an end-user to discover those services. Services and service
instances can be searched via different criteria such as keywords,
organizations, locations, or combinations, and more. The management of a service
encapsulates the functions to publish a service specification and
register/publish a service instance.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"DATABASE_SERVER_TYPE"` |  |
| env[0].valueFrom.configMapKeyRef.key | string | `"msr_database_type"` |  |
| env[0].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[10].name | string | `"MCP_LEDGER_HOST"` |  |
| env[10].valueFrom.configMapKeyRef.key | string | `"msr_ledger_host"` |  |
| env[10].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[11].name | string | `"MCP_LEDGER_PORT"` |  |
| env[11].valueFrom.configMapKeyRef.key | string | `"msr_ledger_port"` |  |
| env[11].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[12].name | string | `"MCP_LEDGER_ADDRESS"` |  |
| env[12].valueFrom.secretKeyRef.key | string | `"msr_ledger_address"` |  |
| env[12].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[13].name | string | `"MCP_LEDGER_CREDENTIALS"` |  |
| env[13].valueFrom.secretKeyRef.key | string | `"msr_ledger_credentials"` |  |
| env[13].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[14].name | string | `"CONTEXT_PATH"` |  |
| env[14].value | string | `"/mcp/msr"` |  |
| env[1].name | string | `"DATABASE_SERVER_HOST"` |  |
| env[1].valueFrom.configMapKeyRef.key | string | `"msr_database_host"` |  |
| env[1].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[2].name | string | `"DATABASE_SERVER_PORT"` |  |
| env[2].valueFrom.configMapKeyRef.key | string | `"msr_database_port"` |  |
| env[2].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[3].name | string | `"DATABASE_USERNAME"` |  |
| env[3].valueFrom.secretKeyRef.key | string | `"msr_database_username"` |  |
| env[3].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[4].name | string | `"DATABASE_PASSWORD"` |  |
| env[4].valueFrom.secretKeyRef.key | string | `"msr_database_password"` |  |
| env[4].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[5].name | string | `"KEYCLOAK_SERVER_URL"` |  |
| env[5].valueFrom.configMapKeyRef.key | string | `"keycloak_url"` |  |
| env[5].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[6].name | string | `"KEYCLOAK_CLIENT_REALM"` |  |
| env[6].valueFrom.configMapKeyRef.key | string | `"keycloak_realm"` |  |
| env[6].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[7].name | string | `"KEYCLOAK_CLIENT_ID"` |  |
| env[7].valueFrom.configMapKeyRef.key | string | `"msr_keycloak_client_id"` |  |
| env[7].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[8].name | string | `"KEYCLOAK_CLIENT_SECRET"` |  |
| env[8].valueFrom.secretKeyRef.key | string | `"msr_keycloak_client_secret"` |  |
| env[8].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[9].name | string | `"MCP_MIR_URL"` |  |
| env[9].valueFrom.configMapKeyRef.key | string | `"mcp_identity_register_api_url"` |  |
| env[9].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
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
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/maritimeconnectivity/serviceregistry"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"mc-service-registry.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/mcp/msr/actuator/health/liveness"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| nameOverride | string | `""` |  |
| nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.httpGet.path | string | `"/mcp/msr/actuator/health/readiness"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `8444` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `"mcp-admin"` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |
| waitForServices[0].serviceName | string | `"mc-keycloak"` |  |
| waitForServices[0].servicePort | int | `8090` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)