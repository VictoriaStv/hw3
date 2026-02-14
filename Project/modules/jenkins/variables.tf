variable "namespace" {
  type        = string
  description = "Kubernetes namespace for Jenkins."
}

variable "release_name" {
  type        = string
  description = "Helm release name for Jenkins."
}

variable "chart_version" {
  type        = string
  description = "Helm chart version for Jenkins."
}

variable "values_file" {
  type        = string
  description = "Path to values.yaml for Jenkins."
}
