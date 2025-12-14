output "namespace" {
  value       = var.namespace
  description = "Namespace where Jenkins is installed."
}

output "release_name" {
  value       = var.release_name
  description = "Helm release name for Jenkins."
}
