Gateways
================

The folder contains the deployment configuration to initialize gateways in the cluster.

The Gateways describe the load balancer operating at the edge of the mesh

Manual Deployment
-----------------

Gateways are very specific to the environment in which they operate.

The manifests here assume deployment of:
- Istio Operator
- Istio Control Plane
- Cert Manager
- A certificate issuer named 'istio-gateway-issuer'

<https://istio.io/latest/docs/reference/config/networking/gateway/>
