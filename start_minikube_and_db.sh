#!/usr/bin/env bash
minikube start --memory=16384 --cpus=8 --vm-driver=vmware --disk-size=64g --network-plugin=cni --cni=calico --kubernetes-version=v1.20.2


kubectl create -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-operator/namespace-configuration/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/1.9.8/manifests/charts/istio-operator/crds/crd-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/1.9.8/manifests/charts/istio-operator/files/gen-operator.yaml

kubectl apply -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-system/namespace-configuration/.
kubectl apply -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-system/control-plane/overlays/staging/istiocontrolplane-1-9-8.yaml

kubectl apply -f https://raw.githubusercontent.com/istio/istio/1.10.6/manifests/charts/istio-operator/crds/crd-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/1.10.6/manifests/charts/istio-operator/files/gen-operator.yaml

# Upgrade
kubectl apply -f  /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-operator/istio-operator-1-10-6/istio-template.yaml

kubectl apply -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-system/control-plane/overlays/staging/istiocontrolplane-1-10-6.yaml


kubectl create -f  /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-operator/istio-operator-1-11-4/istio-template.yaml

kubectl create -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-system/control-plane/overlays/staging/istiocontrolplane-1-11-4.yaml


#image: docker.io/istio/pilot:1.10.6


#
#k delete -f https://raw.githubusercontent.com/istio/istio/1.9.8/manifests/charts/istio-operator/crds/crd-operator.yaml
#k delete -f https://raw.githubusercontent.com/istio/istio/1.9.8/manifests/charts/istio-operator/files/gen-operator.yaml
#
#kubectl delete -f /Users/dosagie/dev/argocd_projects/staging-cluster-services/istio-system/control-plane/overlays/staging/istiocontrolplane-1-9-8.yaml
#
#
#awsv aws eks --region us-east-1 create-cluster --name demo_eks --role-arn arn:aws:iam::847881920253:role/Eks-role-dosagie --resources-vpc-config subnetIds=subnet-0dd40509f7f1d04a5,subnet-0637788bc82aae711,subnet-0d5cf0ec381b4d0f2,securityGroupIds=sg-0cc7407a343025f49
#Readiness probe failed: Get "http://10.244.120.97:15021/healthz/ready": dial tcp 10.244.120.97:15021: connect: connection refused



#kubectl exec $(kubectl get pod public-ingressgateway-5b6bdd9c4-mxfv5  -n public-istio-ingress -o jsonpath={.items..metadata.name}) -n public-istio-ingress -- curl -sS istiod.istio-system:15014/version



#kubectl get configmap istio-1-10-6 --namespace=istio-system --export -o yaml \
#  | kubectl apply --namespace=public-istio-ingress -f -
#
#kubectl get configmap istio-1-10-6 --namespace=istio-system -o yaml \
#  | sed 's/namespace: istio-system/namespace: private-istio-ingress/' \
#  | kubectl create -f -