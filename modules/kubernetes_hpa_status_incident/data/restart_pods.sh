#!/bin/bash

# Define the namespace and deployment name

namespace=${NAMESPACE}

deployment=${DEPLOYMENT}

# Get the pods that are part of the deployment

pods=$(kubectl get pods -n $namespace -l app=$deployment -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

# Restart the pods one by one and wait for them to become ready

for pod in $pods; do

  kubectl delete pod -n $namespace $pod

  echo "Restarting pod $pod..."

  until kubectl get pod -n $namespace $pod | grep "Running" >/dev/null; do sleep 1; done

  echo "Pod $pod is ready"

done
# Monitor the HPA status until it stabilizes

echo "Monitoring HPA status..."

until kubectl describe hpa -n $namespace $deployment | grep -E "Min Replicas:|Max Replicas:" >/dev/null; do sleep 1; done

echo "HPA status stabilized"