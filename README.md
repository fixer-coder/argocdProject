- Deployed two istio version (A and B)
- I have the ingressGateways in different namespaces as we currently have and both version have it own ingressGateway
  - public-ingressgateway-A and public-ingressgateway-B
- I have ingress and gateway pointing to both (duplicate this https://github.com/BeyondTrust/hatchery/blob/master/cluster-services/istio-system/gateways/overlays/production/public-https-gateway.yaml) one pointing to A and other pointing to B
- I also added both gateway to VirtualService so that when I delete `public-ingressgateway-A` events/traffic will still keep going through


Added the following 
- alb.ingress.kubernetes.io/load-balancer-attributes: "deletion_protection.enabled=true" Prevents LB from been deleeted and recreated every time I make changes 
- alb.ingress.kubernetes.io/group.name: sre.public-ingress 
- Suppose to route traffic from A target to B (Dosnt seems this will work as it requires copying targetGroupARN)
alb.ingress.kubernetes.io/actions.public-ingressgateway: |

        {
          "type":"forward",
          "targetGroupARN": "arn:aws:elasticloadbalancing:us-east-1:778720601445:targetgroup/k8s-publicis-publicin-cdc8e4e489/2294c1b2d748f7f8"
        }

- This is sending to service 
alb.ingress.kubernetes.io/actions.blue-green: |

    {
      "type":"forward",
      "forwardConfig":{
        "targetGroups":[
          {
            "serviceName":"hello-kubernetes-v1",
            "servicePort":"80",
            "weight":100
          },
          {
             "serviceName":"hello-kubernetes-v2",
             "servicePort":"80",
             "weight":0
          }
       ]
     }
   }
- Also looked at this https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/guide/ingress/annotations.md#actions