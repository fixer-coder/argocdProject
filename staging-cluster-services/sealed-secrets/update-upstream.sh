#!/usr/bin/env sh

export SEALED_SECRET_VERSION=v0.19.1

wget -O upstream/controller.yaml https://github.com/bitnami-labs/sealed-secrets/releases/download/${SEALED_SECRET_VERSION}/controller.yaml
