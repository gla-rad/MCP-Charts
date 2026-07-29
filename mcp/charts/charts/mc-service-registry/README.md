# mc-service-registry

A Helm chart for the MCP MSR service

![Version: 0.0.10](https://img.shields.io/badge/Version-0.0.10-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

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
| env[10].name | string | `"MCP_MIR_URL"` |  |
| env[10].valueFrom.configMapKeyRef.key | string | `"mcp_identity_registry_api_url"` |  |
| env[10].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[11].name | string | `"MIR_TRUSTSTORE_PATH"` |  |
| env[11].value | string | `"/conf/secom_truststore.jks"` |  |
| env[12].name | string | `"MIR_TRUSTSTORE_PASSWORD"` |  |
| env[12].valueFrom.secretKeyRef.key | string | `"secom_truststore_password"` |  |
| env[12].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[13].name | string | `"MIR_ROOT_CA_ALIAS"` |  |
| env[13].valueFrom.configMapKeyRef.key | string | `"mir-root-ca-alias"` |  |
| env[13].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[14].name | string | `"OWN_EDGE_ROUTER_KEYSTORE_PATH"` |  |
| env[14].value | string | `"/conf/own_edge_router_keystore.jks"` |  |
| env[15].name | string | `"OWN_EDGE_ROUTER_KEYSTORE_PASSWORD"` |  |
| env[15].valueFrom.secretKeyRef.key | string | `"own_edge_router_keystore_password"` |  |
| env[15].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[16].name | string | `"SECOM_SIGNING_IDENTITY_PATH"` |  |
| env[16].value | string | `"/conf/signing_identity_keystore.jks"` |  |
| env[17].name | string | `"SECOM_SIGNING_IDENTITY_PASSWORD"` |  |
| env[17].valueFrom.secretKeyRef.key | string | `"secom_signing_identity_keystore_password"` |  |
| env[17].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[18].name | string | `"CONTEXT_PATH"` |  |
| env[18].value | string | `"/msr"` |  |
| env[1].name | string | `"DATABASE_SERVER_HOST"` |  |
| env[1].valueFrom.configMapKeyRef.key | string | `"msr_database_host"` |  |
| env[1].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[2].name | string | `"DATABASE_SERVER_PORT"` |  |
| env[2].valueFrom.configMapKeyRef.key | string | `"msr_database_port"` |  |
| env[2].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[3].name | string | `"DATABASE_NAME"` |  |
| env[3].valueFrom.configMapKeyRef.key | string | `"msr_database_name"` |  |
| env[3].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[4].name | string | `"DATABASE_USERNAME"` |  |
| env[4].valueFrom.secretKeyRef.key | string | `"msr_database_username"` |  |
| env[4].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[5].name | string | `"DATABASE_PASSWORD"` |  |
| env[5].valueFrom.secretKeyRef.key | string | `"msr_database_password"` |  |
| env[5].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| env[6].name | string | `"KEYCLOAK_SERVER_URL"` |  |
| env[6].valueFrom.configMapKeyRef.key | string | `"keycloak_url"` |  |
| env[6].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[7].name | string | `"KEYCLOAK_CLIENT_REALM"` |  |
| env[7].valueFrom.configMapKeyRef.key | string | `"keycloak_realm"` |  |
| env[7].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[8].name | string | `"KEYCLOAK_CLIENT_ID"` |  |
| env[8].valueFrom.configMapKeyRef.key | string | `"msr_keycloak_client_id"` |  |
| env[8].valueFrom.configMapKeyRef.name | string | `"mc-service-registry-config"` |  |
| env[9].name | string | `"KEYCLOAK_CLIENT_SECRET"` |  |
| env[9].valueFrom.secretKeyRef.key | string | `"msr_keycloak_client_secret"` |  |
| env[9].valueFrom.secretKeyRef.name | string | `"mc-service-registry-secrets"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost"` |  |
| global.mc_service_registry.db_host | string | `"localhost"` |  |
| global.mc_service_registry.db_name | string | `"mcp_service_registry"` |  |
| global.mc_service_registry.db_password | string | `"changeit"` |  |
| global.mc_service_registry.db_port | int | `5432` |  |
| global.mc_service_registry.db_type | string | `"postgresql"` |  |
| global.mc_service_registry.db_username | string | `"admin"` |  |
| global.mc_service_registry.keycloak_client_id | string | `"mcpsvreg"` |  |
| global.mc_service_registry.keycloak_client_secret | string | `"changeit"` |  |
| global.mc_service_registry.mir_root_ca_alias | string | `"mcp-root"` |  |
| global.mc_service_registry.own_edge_router_keystore | string | `""` |  |
| global.mc_service_registry.own_edge_router_keystore_password | string | `"changeit"` |  |
| global.mc_service_registry.secom_signing_identity_keystore | string | `""` |  |
| global.mc_service_registry.secom_signing_identity_keystore_password | string | `"changeit"` |  |
| global.mc_service_registry.secom_truststore | string | `""` |  |
| global.mc_service_registry.secom_truststore_password | string | `"changeit"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"glarad/mc-service-registry"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"mc-service-registry.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.failureThreshold | int | `12` |  |
| livenessProbe.httpGet.path | string | `"/msr/actuator/health/liveness"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `30` |  |
| livenessProbe.periodSeconds | int | `10` |  |
| livenessProbe.timeoutSeconds | int | `5` |  |
| nameOverride | string | `""` |  |
| nodeSelector."kubernetes.io/os" | string | `"linux"` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.failureThreshold | int | `12` |  |
| readinessProbe.httpGet.path | string | `"/msr/actuator/health/readiness"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `30` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.timeoutSeconds | int | `5` |  |
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
| volumeMounts[0].mountPath | string | `"/conf"` |  |
| volumeMounts[0].name | string | `"config-volume"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumes[0].name | string | `"config-volume"` |  |
| volumes[0].projected.sources[0].secret.items[0].key | string | `"secom_truststore"` |  |
| volumes[0].projected.sources[0].secret.items[0].path | string | `"secom_truststore.jks"` |  |
| volumes[0].projected.sources[0].secret.name | string | `"mc-service-registry-secrets"` |  |
| volumes[0].projected.sources[1].secret.items[0].key | string | `"own_edge_router_keystore"` |  |
| volumes[0].projected.sources[1].secret.items[0].path | string | `"own_edge_router_keystore.jks"` |  |
| volumes[0].projected.sources[1].secret.name | string | `"mc-service-registry-secrets"` |  |
| volumes[0].projected.sources[2].secret.items[0].key | string | `"secom_signing_identity_keystore"` |  |
| volumes[0].projected.sources[2].secret.items[0].path | string | `"signing_identity_keystore.jks"` |  |
| volumes[0].projected.sources[2].secret.name | string | `"mc-service-registry-secrets"` |  |
| waitForServices[0].serviceName | string | `"mc-keycloak"` |  |
| waitForServices[0].servicePort | int | `8090` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)