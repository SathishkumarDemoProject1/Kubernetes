terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "kubernetes" {
 # config_context = "export KUBE_CONFIG_PATH=C:\\Users\\pasathishkumar\\.kube\\config"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "application"
  }
}

#-------------------------------------------------------- Shopping Service --------------------------------------------------------

resource "kubernetes_deployment" "shopping_service" {
  metadata {
    name      = "shopping"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "shoppingApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "shoppingApp"
        }
      }
      spec {
        container {
          image = "docker.io/sathishkumar281995/giftingapp-shopping-service"
          name  = "shopping-container"
          port {
            container_port = 8082
          }
		  resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "shopping_service" {
  metadata {
    name      = "shopping"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.shopping_service.spec.0.template.0.metadata.0.labels.app
    }
    type = "ClusterIP"
    port {
      port        = 8082
	  target_port = 8082
    }
  }
}

# ------------------------------------------------------------- Merchant Service  --------------------------------------------

resource "kubernetes_deployment" "merchant_service" {
  metadata {
    name      = "merchant"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "merchantApp"
      }
    }
    template {
      metadata {
        labels = {
          app = "merchantApp"
        }
      }
      spec {
        container {
          image = "docker.io/sathishkumar281995/giftingapp-merchant-service"
          name  = "merchant-container"
          port {
            container_port = 8081
          }
		  resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "merchant_service" {
  metadata {
    name      = "merchant"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }
  spec {
    selector = {
      app = kubernetes_deployment.merchant_service.spec.0.template.0.metadata.0.labels.app
    }
    #type = "NodePort"
    port {
      port        = 8081
      target_port = 8081
    }
	type = "ClusterIP"
  }
}

#----------------------------------------------- Improving availability of service(Scale based on cpu utilization)-------------------------------

resource "kubernetes_horizontal_pod_autoscaler" "shopping_service" {
  metadata {
    name      = "shopping"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    max_replicas = 10
    min_replicas = 2
	target_cpu_utilization_percentage = 80
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "shopping"
    }
	
  } 
}


resource "kubernetes_horizontal_pod_autoscaler" "merchant_service" {
  metadata {
    name      = "merchant"
    namespace = kubernetes_namespace.namespace.metadata.0.name
  }

  spec {
    max_replicas = 10
    min_replicas = 2
	target_cpu_utilization_percentage = 80
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "merchant"
    }
	
  } 
}

# To enable ingress `minikube addons enable ingress`
# Create tunnel to access the service `minikube tunnel`
#----------------------------------------------------------------- Connecting to Service using ingress (Proxy Service) ----------------------------
resource "kubernetes_ingress" "application_ingress" {
  metadata {
    name = "application-ingress"
	namespace = kubernetes_namespace.namespace.metadata.0.name
	#annotations = {
	#	"kubernetes.io/ingress.class" = "nginx"
	#}
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "shopping"
            service_port = 8082
          }
          path = "/v1/shopping"
        }

        path {
          backend {
            service_name = "merchant"
            service_port = 8081
          }
		  path = "/v1/merchants"
        }
      }
    }

    tls {
      secret_name = "tls-secret"
    }
  }
  	wait_for_load_balancer = true
}

# Display load balancer hostname (typically present in AWS)
output "load_balancer_hostname" {
  value = kubernetes_ingress.application_ingress.status.0.load_balancer.0.ingress.0.hostname
}

# Display load balancer IP (typically present in GCP, or using Nginx ingress controller)
output "load_balancer_ip" {
  value = kubernetes_ingress.application_ingress.status.0.load_balancer.0.ingress.0.ip
}