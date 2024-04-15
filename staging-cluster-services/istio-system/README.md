Istio System
============

This folder contains the configuration for [Istio](https://istio.io/).

See [istio-operator](../istio-operator) for more details of installation.

Manual Deployment
-----------------
Deploy the [istio-operator](../istio-operator) before deploying istio-system.

The resources/application should be deployed in the order of the list
- [namespace-configuration](configurations)
- [control-plane](control-plane) select the environment you want to deploy in the [overlays](control-plane/overlays)
- [gateways](gateways) select the environment you want to deploy in the [overlays](gateways/overlays)

Note:

To deploy applications on your testing system, you can deploy istio  [Bookinfo Application](https://istio.io/latest/docs/examples/bookinfo/)
