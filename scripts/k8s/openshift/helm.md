git clone https://github.com/redhat-gpte-devopsautomation/mlbparks-chart.git
cd mlbparks-chart
less templates/deploymentconfig.yml

helm show values .


helm install mlbparks .

oc get dc


helm ls



helm upgrade mlbparks .


helm rollback mlbparks 1

