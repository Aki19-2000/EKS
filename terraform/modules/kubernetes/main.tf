resource "kubernetes_deployment" "appointment_service" {
  depends_on = [aws_eks_node_group.node_group]  # Ensure node group is ready

  metadata {
    name      = "appointment-service"
    namespace = "default"
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "appointment-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "appointment-service"
        }
      }
      spec {
        container {
          name  = "appointment-service"
          image = "your_ecr_image_url"
          port {
            container_port = 3001
          }
        }
      }
    }
  }
}
