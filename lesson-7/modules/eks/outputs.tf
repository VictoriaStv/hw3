output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "Назва EKS-кластера"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "Endpoint EKS-кластера"
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "CA сертифікат кластера"
}
