
https://deniz-turkmen.medium.com/kubernetes-horizontal-pod-autoscaling-7bdcbeec577b
https://www.optdcom.net/levitate/tr/kubernetes-ile-yaprj-olcekleme-horizontal-auto-scale/
https://www.gokhan-gokalp.com/en/kubernetes-for-production-some-useful-information/



kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


kubectl  get  pods -n kube-system | grep metric


command:
- /metrics-server
- — kubelet-insecure-tls



kubectl top node

kubectl autoscale -n NS_NAME deployment deployment_name --min=1 --max=5 --cpu-percent=50

kubectl get horizontalpodautoscalers.autoscaling -n NS_NAME


behavior:
  scaleDown:
    policies:
    - type: Pods
      value: 4
      periodSeconds: 60
    - type: Percent
      value: 10
      periodSeconds: 60

---

behavior:
  scaleDown:
    stabilizationWindowSeconds: 300

---

ApiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa
  namespace: hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa
  minReplicas: 1
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50

----


apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa_name
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: deployment_name
  minReplicas: 1
  maxReplicas: 7
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
      - type: Percent
        value: 10
        periodSeconds: 1800
      - type: Pods
        value: 1
        periodSeconds: 1800
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 25
        periodSeconds: 50
      - type: Pods
        value: 1
        periodSeconds: 50
      selectPolicy: Max

---

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: hpa2
  namespace: hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 40
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 20

----

apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: external-load-test
  namespace: hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: hpa
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 120
      policies:
      - type: Percent
        value: 50
        periodSeconds: 15
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
      - type: Percent
        value: 50
        periodSeconds: 20
      - type: Pods
        value: 5
        periodSeconds: 20
      selectPolicy: Max
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 20
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 30