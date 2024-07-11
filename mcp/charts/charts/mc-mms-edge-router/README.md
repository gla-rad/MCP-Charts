# mc-mms-edge-router

A Helm chart for the MCP MMS Edge Router

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: latest](https://img.shields.io/badge/AppVersion-latest-informational?style=flat-square)

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

The MMS Router Network consists of zero or more MMS Routers. The Router Network
shall handle message routing and forwarding between MMS Edge Routers. The Router
Network shall have the capability to exchange the knowledge about subscribed MMS
Agents, and subjects between each other. An MMS Router handles MMS message
transport for a set of connected MMS Edge Routers, that subscribe to a set of
specific subjects and/or specific MRNs on behalf of their subscribed MMS Agents.

An MMS Router queues messages that an MMS Edge Router has subscribed to until
they are fetched by that MMS Edge Router. An MMS Router may delete stored
subscriptions and queued messages after a configured timeout occurs.

The MMS Router Network may handle the transfer of stored subscriptions and
queued messages between the MMS Routers in case an MMS Edge Router roams from
one MMS Router to another.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| env[0].name | string | `"CLIENT_CERT_PATH"` |  |
| env[0].value | string | `"/conf/cc.crt"` |  |
| env[1].name | string | `"CLIENT_CERT_KEY_PATH"` |  |
| env[1].value | string | `"/conf/ccpk.key"` |  |
| env[2].name | string | `"CERT_PATH"` |  |
| env[2].value | string | `"/conf/tls.crt"` |  |
| env[3].name | string | `"CERT_KEY_PATH"` |  |
| env[3].value | string | `"/conf/tlspk.key"` |  |
| env[4].name | string | `"CLIENT_CA"` |  |
| env[4].value | string | `"/conf/ca-chain.pem"` |  |
| env[5].name | string | `"PORT"` |  |
| env[5].valueFrom.configMapKeyRef.key | string | `"port"` |  |
| env[5].valueFrom.configMapKeyRef.name | string | `"mc-mms-edge-router-config"` |  |
| env[6].name | string | `"MRN"` |  |
| env[6].valueFrom.configMapKeyRef.key | string | `"mrn"` |  |
| env[6].valueFrom.configMapKeyRef.name | string | `"mc-mms-edge-router-config"` |  |
| env[7].name | string | `"RADDR"` |  |
| env[7].valueFrom.configMapKeyRef.key | string | `"router_address"` |  |
| env[7].valueFrom.configMapKeyRef.name | string | `"mc-mms-edge-router-config"` |  |
| fullnameOverride | string | `""` |  |
| global.keycloak_realm | string | `"MCP"` |  |
| global.keycloak_url | string | `"http://localhost/mcp"` |  |
| global.mc_mms_edge_router.certificate | string | `""` |  |
| global.mc_mms_edge_router.certificate_key | string | `""` |  |
| global.mc_mms_edge_router.client_ca | string | `""` |  |
| global.mc_mms_edge_router.client_certificate | string | `""` |  |
| global.mc_mms_edge_router.client_certificate_key | string | `""` |  |
| global.mc_mms_edge_router.mrn | string | `""` |  |
| global.mc_mms_edge_router.port | int | `8080` |  |
| global.mc_mms_edge_router.router_address | string | `"mc-mms-router.mcp:8080"` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/gla-rad/mc-mms-edgerouter"` |  |
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
| volumes[0].projected.sources[0].secret.items[0].key | string | `"client_certificate"` |  |
| volumes[0].projected.sources[0].secret.items[0].path | string | `"cc.crt"` |  |
| volumes[0].projected.sources[0].secret.name | string | `"mc-mms-edge-router-secrets"` |  |
| volumes[0].projected.sources[1].secret.items[0].key | string | `"client_certificate_key"` |  |
| volumes[0].projected.sources[1].secret.items[0].path | string | `"ccpk.key"` |  |
| volumes[0].projected.sources[1].secret.name | string | `"mc-mms-edge-router-secrets"` |  |
| volumes[0].projected.sources[2].secret.items[0].key | string | `"certificate"` |  |
| volumes[0].projected.sources[2].secret.items[0].path | string | `"tls.crt"` |  |
| volumes[0].projected.sources[2].secret.name | string | `"mc-mms-edge-router-secrets"` |  |
| volumes[0].projected.sources[3].secret.items[0].key | string | `"certificate_key"` |  |
| volumes[0].projected.sources[3].secret.items[0].path | string | `"tlspk.key"` |  |
| volumes[0].projected.sources[3].secret.name | string | `"mc-mms-edge-router-secrets"` |  |
| volumes[0].projected.sources[4].secret.items[0].key | string | `"client_ca"` |  |
| volumes[0].projected.sources[4].secret.items[0].path | string | `"ca-chain.pem"` |  |
| volumes[0].projected.sources[4].secret.name | string | `"mc-mms-edge-router-secrets"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)