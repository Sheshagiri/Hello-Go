apiVersion: v1
kind: Service
metadata:
  name: SVCNAME
  labels:
    app: SVCAPPNAME
    version: SVCRELEASEVERSION
spec:
  type: NodePort
  ports:
    - name: http
      port: 8000
      targetPort: forwarder-port
      protocol: TCP
      nodePort: 8000
  selector:
    app: SVCAPPNAME
    version: SVCRELEASEVERSION
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: SVCNAME
spec:
  replicas: 1
  selector:
    matchLabels:
      app: SVCAPPNAME
      version: SVCRELEASEVERSION
  template:
    metadata:
      labels:
        app: SVCAPPNAME
        version: SVCRELEASEVERSION
    spec:
      containers:
      - name: hello-go
        image:  hello-go:SVCFULLVERSION
        readinessProbe:
          httpGet:
            path: /health
            port: forwarder-port
          initialDelaySeconds: 10
          timeoutSeconds: 3
          periodSeconds: 15
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /health
            port: forwarder-port
          initialDelaySeconds: 60
          timeoutSeconds: 3
          periodSeconds: 30
          failureThreshold: 2
        ports:
        - name: forwarder-port
          containerPort: 8000
          protocol: TCP
