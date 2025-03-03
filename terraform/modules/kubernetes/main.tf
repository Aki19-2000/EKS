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
resource "kubernetes_service" "appointment_service" {
  depends_on = [kubernetes_deployment.appointment_service]  # Ensure deployment is ready

  metadata {
    name = "appointment-service"
  }

  spec {
    selector = {
      app = "appointment-service"
    }

    port {
      port        = 80
      target_port = 3001
    }

    type = "LoadBalancer"
  }
}
