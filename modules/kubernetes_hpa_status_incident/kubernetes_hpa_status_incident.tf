resource "shoreline_notebook" "kubernetes_hpa_status_incident" {
  name       = "kubernetes_hpa_status_incident"
  data       = file("${path.module}/data/kubernetes_hpa_status_incident.json")
  depends_on = [shoreline_action.invoke_get_k8s_nodes,shoreline_action.invoke_restart_pods]
}

resource "shoreline_file" "get_k8s_nodes" {
  name             = "get_k8s_nodes"
  input_file       = "${path.module}/data/get_k8s_nodes.sh"
  md5              = filemd5("${path.module}/data/get_k8s_nodes.sh")
  description      = "export DEPLOYMENT_NAME="PLACEHOLDER""
  destination_path = "/agent/scripts/get_k8s_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "restart_pods" {
  name             = "restart_pods"
  input_file       = "${path.module}/data/restart_pods.sh"
  md5              = filemd5("${path.module}/data/restart_pods.sh")
  description      = "Restart the affected pods and monitor the HPA status to ensure it stabilizes."
  destination_path = "/agent/scripts/restart_pods.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_k8s_nodes" {
  name        = "invoke_get_k8s_nodes"
  description = "export DEPLOYMENT_NAME="PLACEHOLDER""
  command     = "`chmod +x /agent/scripts/get_k8s_nodes.sh && /agent/scripts/get_k8s_nodes.sh`"
  params      = []
  file_deps   = ["get_k8s_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.get_k8s_nodes]
}

resource "shoreline_action" "invoke_restart_pods" {
  name        = "invoke_restart_pods"
  description = "Restart the affected pods and monitor the HPA status to ensure it stabilizes."
  command     = "`chmod +x /agent/scripts/restart_pods.sh && /agent/scripts/restart_pods.sh`"
  params      = ["NAMESPACE"]
  file_deps   = ["restart_pods"]
  enabled     = true
  depends_on  = [shoreline_file.restart_pods]
}

