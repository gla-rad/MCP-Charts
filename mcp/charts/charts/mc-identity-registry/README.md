mc-identity-registry
====================
A Helm chart for the MCP MIR service

Current chart version is `0.0.4`





## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| global.mir_api_config | string | `""` |  |
| global.mir_api_keycloak_json | string | `""` |  |
| global.mir_api_subca_keystore | string | `""` |  |
| global.mir_api_truststore | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/maritimeconnectivity/identityregistry"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"mc-identity-registry.local"` |  |
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
| service.port | int | `8443` |  |
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
| volumes[0].projected.sources[0].secret.items[0].key | string | `"mir_api_subca_keystore"` |  |
| volumes[0].projected.sources[0].secret.items[0].path | string | `"subca-keystore.jks"` |  |
| volumes[0].projected.sources[0].secret.name | string | `"mc-identity-registry-secrets"` |  |
| volumes[0].projected.sources[1].secret.items[0].key | string | `"mir_api_truststore"` |  |
| volumes[0].projected.sources[1].secret.items[0].path | string | `"mcp-truststore.jks"` |  |
| volumes[0].projected.sources[1].secret.name | string | `"mc-identity-registry-secrets"` |  |
| volumes[0].projected.sources[2].secret.items[0].key | string | `"mir_api_config"` |  |
| volumes[0].projected.sources[2].secret.items[0].path | string | `"application.yaml"` |  |
| volumes[0].projected.sources[2].secret.name | string | `"mc-identity-registry-secrets"` |  |
| volumes[0].projected.sources[3].secret.items[0].key | string | `"mir_api_keycloak_json"` |  |
| volumes[0].projected.sources[3].secret.items[0].path | string | `"keycloak.json"` |  |
| volumes[0].projected.sources[3].secret.name | string | `"mc-identity-registry-secrets"` |  |
| waitForServices[0].serviceName | string | `"mc-keycloak"` |  |
| waitForServices[0].servicePort | int | `8090` |  |
