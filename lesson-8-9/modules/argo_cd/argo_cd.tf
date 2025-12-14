resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argo_cd" {
  name       = var.release_name
  namespace  = var.namespace

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version

  values = [file(var.values_file)]

  depends_on = [kubernetes_namespace.this]
}

resource "helm_release" "apps" {
  name      = "${var.release_name}-apps"
  namespace = var.namespace

  chart = var.apps_chart_path

  depends_on = [helm_release.argo_cd]
}
