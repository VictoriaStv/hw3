variable "release_name" {
  description = "Helm release name for kube-prometheus-stack"
  type        = string
}

variable "namespace" {
  description = "Namespace for monitoring stack (Prometheus + Grafana)"
  type        = string
}

variable "chart_version" {
  description = "Helm chart version for kube-prometheus-stack"
  type        = string
  default     = "65.5.0"
}
