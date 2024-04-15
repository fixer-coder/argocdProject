Staging Cluster Services
========================

This folder contains the manifests that define the supporting services deployed on our
staging Kubernetes clusters.


Adding new resources
--------------------

This repository employs [Application Sets](https://github.com/argoproj-labs/applicationset) to generate the appropriate
configuration for multiple destinations at once.
