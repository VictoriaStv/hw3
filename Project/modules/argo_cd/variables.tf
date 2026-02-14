variable "namespace" {
  type        = string
  description = "Kubernetes namespace for Argo CD."
}

variable "release_name" {
  type        = string
  description = "Helm release name for Argo CD."
}

variable "chart_version" {
  type        = string
  description = "Helm chart version for Argo CD."
}

variable "values_file" {
  type        = string
  description = "Path to values.yaml for Argo CD."
}

variable "apps_chart_path" {
  type        = string
  description = "Path to local Helm chart with Argo CD Applications."
}
