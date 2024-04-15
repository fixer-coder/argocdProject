#!/usr/bin/env bash

# To start argocd server on my system
 kubectl create namespace argocd

# Install latest argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# expose argocd server
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl annotate service/argocd-server  -n argocd "service.beta.kubernetes.io/aws-load-balancer-internal"="true"
# get server info

sleep 30
# shellcheck disable=SC2155
export ARGOCD_SERVER=` kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname'`

# get server password
# shellcheck disable=SC2006
export ARGO_PWD=` kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

# Login using argocd cli
argocd login $ARGOCD_SERVER --username admin --password $ARGO_PWD --insecure

# To login to UI
echo $ARGOCD_SERVER
echo $ARGO_PWD
## go to you browser and put server url
## User name  = admin
## password = $ARGO_PWD


# Install other needed stuffs (ApplicationSet, Rollout, Cert Manager)
 kubectl apply -f https://raw.githubusercontent.com/argoproj/applicationset/master/manifests/crds/argoproj.io_applicationsets.yaml
 kubectl apply -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml -n argocd
# kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.2/cert-manager.yaml


# Adding github project for argocd
argocd repo add git@github.com:osazz/argocd_projects.git --ssh-private-key-path ~/.ssh/id_ed25519

# apply first boostrap
 kubectl apply -k /Users/dosagie/dev/learning/argocd_projects/ad-hoc-argo/argocd/argocd-server/.


###################################
#### Setting up ingress controller
#### https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/deploy/installation/
###################################
# Create IAM OIDC provider
 eksctl utils associate-iam-oidc-provider --region us-east-1 --cluster eks-example-us-east-1 --approve

# Download IAM policy for the AWS Load Balancer Controller
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/iam_policy.json

# Create an IAM policy called AWSLoadBalancerControllerIAMPolicy
 aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json

# Create a IAM role and ServiceAccount for the AWS Load Balancer controller, use the ARN from the step above
 eksctl create iamserviceaccount --cluster eks-example-us-east-1 --namespace=kube-system  --name=aws-load-balancer-controller --attach-policy-arn=arn:aws:iam::778720601445:policy/AWSLoadBalancerControllerIAMPolicy --override-existing-serviceaccounts --region us-east-1 --approve

# Setup IAM manually
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.5/docs/install/iam_policy.json

# Add Controller to Cluster

## Download spec for load balancer controller
wget https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.1/docs/install/v2_2_1_full.yaml




## Error :

```
#Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws":
#Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1beta1-ingress?timeout=10s":
#no endpoints available for service "aws-load-balancer-webhook-service"
```
# while true;echo "@@@@ sleep 1.00 @@@@"; do sleep 1.00; echo "@@@@@@@ hit product page url  @@@@@@@"; curl -s http://k8s-publicis-ingressg-b86b9c4dcc-604283750.us-east-1.elb.amazonaws.com/productpage | grep -o "<title>.*</title>"; done
unable to initialize AWS cloud","error":"failed to introspect vpcID from EC2Metadata or Node name, specify --aws-vpc-id instead if EC2Metadata is unavailable: failed to fetch VPC ID from instance metadata: EC2MetadataError: failed to make EC2Metadata request\n\n\tstatus code: 401, request id: "}

helm template -i aws-load-balancer-controller eks/aws-load-balancer-controller  --set clusterName=eks-example-us-east-1 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=us-east-1 --set vpcId=vpc-0507871dacb1f4b6b -n kube-system

To generate controlller with helm
- helm repo add eks https://aws.github.io/eks-charts
- helm template aws-load-balancer-controller eks/aws-load-balancer-controller  --set clusterName=eks-example-us-east-1 --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=us-east-1 --set vpcId=vpc-0507871dacb1f4b6b -n kube-system > controller.yaml