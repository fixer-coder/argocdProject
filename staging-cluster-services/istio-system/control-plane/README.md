Istio Control Plane
================

The folder contains the deployment configuration to instruct the [istio operator] how to
initialize and configure an istio [control plane](https://istio.io/latest/docs/ops/deployment/architecture/#istiod).

Manual Deployment
-----------------

Ensure that the istio operator is already deployed on the cluster.

As the istio control plane is fairly unique in configuration to any given cluster, reading through the
[istio operator] documentation is recommended.

For development/experimentation purposes, start with a demo manifest such as the following:

```yaml
apiVersion: install.istio.io/v1alpha1
kind: IstioOperator
metadata:
  namespace: istio-system
  name: demo-istiocontrolplane
spec:
  profile: demo
```

[istio operator]: https://istio.io/latest/docs/setup/install/operator/
