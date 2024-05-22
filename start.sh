#!/usr/bin/env bash

# To start argocd server on my system

# start minikube
##  minikube start --memory=16384 --cpus=8 --vm-driver=vmware --disk-size=64g --network-plugin=cni --cni=calico --kubernetes-version=v1.20.2
minikube start --memory=16384 --cpus=8  --disk-size=64g --kubernetes-version=v1.26.0

# create namespace argocd
kubectl create namespace argocd

# Install latest argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Patch argo cd serever
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# install ApplicationSet
kubectl apply -f https://raw.githubusercontent.com/argoproj/applicationset/master/manifests/crds/argoproj.io_applicationsets.yaml

# Install rollout
kubectl apply -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml -n argocd

# install cert manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.14.5/cert-manager.yaml

# sleep for 30 sec
sleep 30


# Argocd password
argocd_password=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

# In new terminal
kubectl port-forward svc/argocd-server -n argocd 8080:443

# login to argocd cli
# shellcheck disable=SC2046
# shellcheck disable=SC2006
argocd login localhost:8080 --insecure --username admin --password "$argocd_password"

# Add repo to Argo cd
#argocd repo add git@github.com:BeyondTrust/hatchery.git --ssh-private-key-path ~/.ssh/id_rsa

# echo password
echo "Argocd password is : $argocd_password"


argocd repo add git@github.com:fixer-coder/argocdProject.git --ssh-private-key-path ~/.ssh/id_ed25519_test_acct
kubectl apply -k ~/Documents/argocdProject/ad-hoc-argo/argocd/argocd-server/.
