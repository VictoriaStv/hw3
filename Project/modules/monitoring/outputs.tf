output "monitoring_namespace" {
  description = "Namespace where Prometheus and Grafana are deployed"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}

output "grafana_service_name" {
  description = "Kubernetes Service name for Grafana"
  value       = "${var.release_name}-grafana"
}

output "prometheus_service_name" {
  description = "Kubernetes Service name for Prometheus"
  value       = "${var.release_name}-kube-prometheus"
}
