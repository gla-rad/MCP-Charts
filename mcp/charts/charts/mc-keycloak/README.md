# mc-keycloak

A Helm chart for the MCP keycloak service

![Version: 0.0.6](https://img.shields.io/badge/Version-0.0.6-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Description
Although the MIR has its own database, for its user authentication it actually
uses an OIDC Keycloak service. This service can be deployed using this chart.

The chart will spawn a keycloak service which will  involve three realms:
* MCP: The core realm of the MIR
* Users: A realm to control the users of the MCP
* Certificates: A realm to control the generated certificates of the MIR

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"KC_HOSTNAME_URL"` |  |
| env[0].valueFrom.configMapKeyRef.key | string | `"keycloak_auth_url"` |  |
| env[0].valueFrom.configMapKeyRef.name | string | `"mc-keycloak-config"` |  |
| env[10].name | string | `"KC_SPI_EVENTS_LISTENER_MCP_EVENT_LISTENER_KEYSTORE_PASSWORD"` |  |
| env[10].valueFrom.secretKeyRef.key | string | `"keycloak_keystore_password"` |  |
| env[10].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[11].name | string | `"KC_SPI_EVENTS_LISTENER_MCP_EVENT_LISTENER_TRUSTSTORE_PATH"` |  |
| env[11].value | string | `"/mc-eventprovider-conf/truststore.jks"` |  |
| env[12].name | string | `"KC_SPI_EVENTS_LISTENER_MCP_EVENT_LISTENER_TRUSTSTORE_PASSWORD"` |  |
| env[12].valueFrom.secretKeyRef.key | string | `"keycloak_truststore_password"` |  |
| env[12].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[1].name | string | `"KC_HOSTNAME_ADMIN_URL"` |  |
| env[1].valueFrom.configMapKeyRef.key | string | `"keycloak_admin_url"` |  |
| env[1].valueFrom.configMapKeyRef.name | string | `"mc-keycloak-config"` |  |
| env[2].name | string | `"KC_DB"` |  |
| env[2].valueFrom.configMapKeyRef.key | string | `"keycloak_db_type"` |  |
| env[2].valueFrom.configMapKeyRef.name | string | `"mc-keycloak-config"` |  |
| env[3].name | string | `"KC_DB_URL"` |  |
| env[3].valueFrom.configMapKeyRef.key | string | `"keycloak_db_url"` |  |
| env[3].valueFrom.configMapKeyRef.name | string | `"mc-keycloak-config"` |  |
| env[4].name | string | `"KC_DB_USERNAME"` |  |
| env[4].valueFrom.secretKeyRef.key | string | `"keycloak_db_username"` |  |
| env[4].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[5].name | string | `"KC_DB_PASSWORD"` |  |
| env[5].valueFrom.secretKeyRef.key | string | `"keycloak_db_password"` |  |
| env[5].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[6].name | string | `"KEYCLOAK_ADMIN"` |  |
| env[6].valueFrom.secretKeyRef.key | string | `"keycloak_admin"` |  |
| env[6].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[7].name | string | `"KEYCLOAK_ADMIN_PASSWORD"` |  |
| env[7].valueFrom.secretKeyRef.key | string | `"keycloak_admin_password"` |  |
| env[7].valueFrom.secretKeyRef.name | string | `"mc-keycloak-secrets"` |  |
| env[8].name | string | `"KC_SPI_EVENTS_LISTENER_MCP_EVENT_LISTENER_SERVER_ROOT"` |  |
| env[8].valueFrom.configMapKeyRef.key | string | `"mcp_identity_registry_url"` |  |
| env[8].valueFrom.configMapKeyRef.name | string | `"mc-keycloak-config"` |  |
| env[9].name | string | `"KC_SPI_EVENTS_LISTENER_MCP_EVENT_LISTENER_KEYSTORE_PATH"` |  |
| env[9].value | string | `"/mc-eventprovider-conf/idbroker-updater.jks"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
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
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/maritimeconnectivity/mcpkeycloakspi"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"mc-keycloak.local"` |  |
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
| service.externalIPs[0] | string | `"10.0.1.42"` |  |
| service.port | int | `8090` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `"mcp-admin"` |  |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/mc-eventprovider-conf"` |  |
| volumeMounts[0].name | string | `"config-volume"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumes[0].name | string | `"config-volume"` |  |
| volumes[0].projected.sources[0].secret.items[0].key | string | `"keycloak_truststore"` |  |
| volumes[0].projected.sources[0].secret.items[0].path | string | `"truststore.jks"` |  |
| volumes[0].projected.sources[0].secret.name | string | `"mc-keycloak-secrets"` |  |
| volumes[0].projected.sources[1].secret.items[0].key | string | `"keycloak_idbroker_updater"` |  |
| volumes[0].projected.sources[1].secret.items[0].path | string | `"idbroker-updater.jks"` |  |
| volumes[0].projected.sources[1].secret.name | string | `"mc-keycloak-secrets"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)