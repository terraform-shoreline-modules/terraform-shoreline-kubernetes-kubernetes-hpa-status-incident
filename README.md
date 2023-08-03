
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kubernetes HPA Status Incident
---

A Kubernetes HPA (Horizontal Pod Autoscaler) Status Incident refers to an issue where the autoscaling feature of Kubernetes, which automatically scales the number of pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization, is not functioning as expected. This can result in insufficient resources being provisioned to handle incoming load and potentially lead to service disruptions.

### Parameters
```shell
# Environment Variables

export NAMESPACE="PLACEHOLDER"

export POD_NAME="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"

export HPA_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"
```

## Debug


### List all deployments in the cluster
```shell
kubectl get deployments -n ${NAMESPACE}
```

### Describe a specific deployment
```shell
kubectl describe deployment ${DEPLOYMENT_NAME} -n ${NAMESPACE}
```

### List all horizontal pod autoscalers in the cluster
```shell
kubectl get hpa -n ${NAMESPACE}
```

### Describe a specific horizontal pod autoscaler
```shell
kubectl describe hpa ${HPA_NAME} -n ${NAMESPACE}
```
### List all nodes in the cluster
```shell
kubectl get nodes
```

### Check the CPU and memory usage of a specific node
```shell
kubectl top node ${NODE_NAME}
```

### Check the CPU and memory usage of a specific pod
```shell
kubectl top pod ${POD_NAME} -n ${NAMESPACE}
```

## Repair

export POD_NAME="PLACEHOLDER"

export HPA_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"

export DEPLOYMENT_NAME="PLACEHOLDER"
```

## Debug

### Get the list of nodes in the Kubernetes cluster
```shell
kubectl get nodes
```

### Get the list of pods in the Kubernetes cluster
```shell
kubectl get pods
```

### Get the list of HPA resources in the Kubernetes cluster
```shell
kubectl get hpa
```

### Get the logs of a specific pod
```shell
kubectl logs ${POD_NAME}
```

### Get the events in the Kubernetes cluster
```shell
kubectl get events
```

### Check the status of the HPA resource
```shell
kubectl describe hpa ${HPA_NAME}
```

### Check the CPU and memory usage of a specific pod
```shell
kubectl top pod ${POD_NAME}
```

### Check the CPU and memory usage of all pods in a specific namespace
```shell
kubectl top pod -n ${NAMESPACE}
```

### Check the status of the Kubernetes API server
```shell
kubectl cluster-info
```

### Check the status of the Kubernetes controllers
```shell
kubectl get deployments
```

### Check the status of the Kubernetes scheduler
```shell
kubectl get pods -n kube-system -l component=kube-scheduler
```

### Check the status of the Kubernetes etcd
```shell
kubectl get pods -n kube-system -l component=etcd
```

## Repair
### Restart the affected pods and monitor the HPA status to ensure it stabilizes.
```shell
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
```