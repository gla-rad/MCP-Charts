# mc-mms-router

A Helm chart for the MCP MMS Router

![Version: 0.0.2](https://img.shields.io/badge/Version-0.0.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

## Description
The MMS system architecture defines the following components:
* MMS Agents
* MMS Edge Routers
* MMS Router Network

and the following protocols:
* Maritime Message Transfer Protocol (MMTP)
* Secure Maritime Message Protocol (SMMP)

System Actors (short Actors) in the document are systems, personal devices and
applications using the MMS. Actors run/use different applications, which
interact with other Actors through an MMS Agent. All MMS Agents that want to
send messages and receive MRN addressed messages, must be authenticated with a
MMS Edge Router using MCP certificate from MSS Agents MCP MRN. All messages from
MMS Agents must be authenticated (signed) with certificate from sending MCP MRN.
MMTP only provides message authentication. Messages between Actors may be sent
via the SMMP to provide further security guarantees.

An MMS Router Network consists of zero or more MMS Routers. An MMS Edge Router
shall perform domain specific operations needed in the intended installation
location, such as supporting multiple communication links.

The MMS is designed to support message transfer between routers over different
connection types, i.e. TCP/IP and VDES.

The Agent - Router Network Interface uses the Maritime Messaging Transfer
Protocol (MMTP). The MMTP facilitates the transfer of messages from MMS Agent
 through MMS Edge Routers and the MMS Router Network to one or multiple
 eceiving MMS Agents.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"PRIVKEY"` |  |
| env[0].value | string | `"/conf/pk.key"` |  |
| env[1].name | string | `"CERT_PATH"` |  |
| env[1].value | string | `"/conf/tls.crt"` |  |
| env[2].name | string | `"CERT_KEY_PATH"` |  |
| env[2].value | string | `"/conf/tlspk.key"` |  |
| env[3].name | string | `"CLIENT_CA"` |  |
| env[3].value | string | `"/conf/ca-chain.pem"` |  |
| env[4].name | string | `"PORT"` |  |
| env[4].valueFrom.configMapKeyRef.key | string | `"port"` |  |
| env[4].valueFrom.configMapKeyRef.name | string | `"mc-mms-router-config"` |  |
| env[5].name | string | `"LIBP2P_PORT"` |  |
| env[5].valueFrom.configMapKeyRef.key | string | `"port_libp2p"` |  |
| env[5].valueFrom.configMapKeyRef.name | string | `"mc-mms-router-config"` |  |
| env[6].name | string | `"BEACONS"` |  |
| env[6].value | string | `"/conf/beacons.txt"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
| global.mc_mms_router.beacons | string | `""` |  |
| global.mc_mms_router.certificate | string | `""` |  |
| global.mc_mms_router.certificate_key | string | `""` |  |
| global.mc_mms_router.client_ca | string | `""` |  |
| global.mc_mms_router.port | int | `8080` |  |
| global.mc_mms_router.port_libp2p | int | `9000` |  |
| global.mc_mms_router.private_key | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/gla-rad/mc-mms-router"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
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
| service.port | int | `8080` |  |
| service.port_libp2p | int | `9000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/conf"` |  |
| volumeMounts[0].name | string | `"config-volume"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumes[0].name | string | `"config-volume"` |  |
| volumes[0].projected.sources[0].secret.items[0].key | string | `"private_key"` |  |
| volumes[0].projected.sources[0].secret.items[0].path | string | `"pk.key"` |  |
| volumes[0].projected.sources[0].secret.name | string | `"mc-mms-router-secrets"` |  |
| volumes[0].projected.sources[1].secret.items[0].key | string | `"certificate"` |  |
| volumes[0].projected.sources[1].secret.items[0].path | string | `"tls.crt"` |  |
| volumes[0].projected.sources[1].secret.name | string | `"mc-mms-router-secrets"` |  |
| volumes[0].projected.sources[2].secret.items[0].key | string | `"certificate_key"` |  |
| volumes[0].projected.sources[2].secret.items[0].path | string | `"tlspk.key"` |  |
| volumes[0].projected.sources[2].secret.name | string | `"mc-mms-router-secrets"` |  |
| volumes[0].projected.sources[3].secret.items[0].key | string | `"client_ca"` |  |
| volumes[0].projected.sources[3].secret.items[0].path | string | `"ca-chain.pem"` |  |
| volumes[0].projected.sources[3].secret.name | string | `"mc-mms-router-secrets"` |  |
| volumes[0].projected.sources[4].secret.items[0].key | string | `"beacons"` |  |
| volumes[0].projected.sources[4].secret.items[0].path | string | `"beacons.txt"` |  |
| volumes[0].projected.sources[4].secret.name | string | `"mc-mms-router-secrets"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)