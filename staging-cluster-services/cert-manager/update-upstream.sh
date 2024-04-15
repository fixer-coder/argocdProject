#!/usr/bin/env sh

export CERT_MANAGER_VERSION=v1.6.1

wget -O resources/cert-manager.yaml https://github.com/jetstack/cert-manager/releases/download/$CERT_MANAGER_VERSION/cert-manager.yaml
