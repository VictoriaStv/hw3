resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = var.release_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.chart_version

  namespace        = kubernetes_namespace.monitoring.metadata[0].name
  create_namespace = false

  timeout = 900

  # Використовуємо дефолтні values чарта.
  values = []
}
