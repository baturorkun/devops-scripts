
export CLUSTER_NAME="eks-cluster"
export PROFILE_NAME="test-app"
export AWS_REGION=eu-west-3
export AWS_DEFAULT_REGION=$AWS_REGION
export NAMESPACE="game"
export ACCOUNT_ID="377060497047"
export LBC_VERSION="v2.0.0"

eksctl create cluster \
--name ${CLUSTER_NAME} \
--region ${AWS_REGION} \
--fargate \
--alb-ingress-access

eksctl utils associate-iam-oidc-provider \
    --region ${AWS_REGION} \
    --cluster ${CLUSTER_NAME} \
    --approve


aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

eksctl create iamserviceaccount \
--region ${AWS_REGION} \
--cluster ${CLUSTER_NAME} \
--namespace kube-system \
--name aws-load-balancer-controller  \
--attach-policy-arn arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve


kubectl get sa aws-load-balancer-controller -n kube-system -o yaml

kubectl apply -k github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master

helm repo add eks https://aws.github.io/eks-charts


export VPC_ID=$(aws eks describe-cluster \
                --name ${CLUSTER_NAME} \
                --query "cluster.resourcesVpcConfig.vpcId" \
                --output text)

helm upgrade -i aws-load-balancer-controller \
    eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=eksworkshop-eksctl \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set image.tag="${LBC_VERSION}" \
    --set region=${AWS_REGION} \
    --set vpcId=${VPC_ID}


kubectl -n kube-system rollout status deployment aws-load-balancer-controller



eksctl create fargateprofile \
--cluster ${CLUSTER_NAME} \
--region ${AWS_REGION} \
--name ${PROFILE_NAME} \
--namespace ${NAMESPACE}

eksctl get fargateprofile \
  --cluster  ${CLUSTER_NAME} \
  -o yaml














eksctl utils associate-iam-oidc-provider \
    --region ${AWS_REGION} \
    --cluster ${CLUSTER_NAME} \
    --approve


eksctl create iamserviceaccount \
--cluster=${CLUSTER_NAME} \
--namespace=kube-system \
--name=aws-load-balancer-controller  \
--attach-policy-arn=arn:aws:iam::${AWS_ACCOUNT_ID}:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve




helm upgrade -i aws-load-balancer-controller \
    eks/aws-load-balancer-controller \
    -n kube-system \
    --set clusterName=test-cluster \
    --set serviceAccount.create=false \
    --set serviceAccount.name=aws-load-balancer-controller \
    --set image.tag="${LBC_VERSION}" \
    --set region=${AWS_REGION} \
    --set vpcId=${VPC_ID}


##################################################


eksctl create fargateprofile \
    --cluster <cluster_name> \
    --name <fargate_profile_name> \
    --namespace <kubernetes_namespace> \
    --labels <key=value>



eksctl create fargateprofile \
    --cluster test1-c \
    --name test1-fp \
    --namespace test1-ns 




aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json





    - --cluster-name=fargate
    - --aws-vpc-id=vpc-0688f93aeacbc200c
    - --aws-region=eu-west-3




helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=<cluster-name> --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller


kubectl apply -f deployment.yaml
kubectl expose deployment tomcat-deployment --type=NodePort

kubectl expose deployment nginx-deployment  --type=LoadBalancer --name=nginx-service