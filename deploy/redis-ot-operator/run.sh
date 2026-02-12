helm repo add ot-helm https://ot-container-kit.github.io/helm-charts
helm repo update


helm install redis-operator ot-helm/redis-operator \
  --namespace ot-operators \
  --create-namespace


for pod in redis-replication-0 redis-replication-1; do
  echo "Pod: $pod"
  kubectl exec -it -n ot-operators $pod redis-cli info replication
done