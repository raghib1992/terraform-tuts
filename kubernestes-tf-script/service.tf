resource "kubernetes_service" "webapp-service" {
  metadata {
    name = "webapp-service"
  }
  spec {
    selector = {
      name= "webapp"
    }
    type = "NodePort"
    port {
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
      node_port   = 30080
    }
  }
}