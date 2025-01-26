# File: localstack.tf

locals {
  services_map = length(var.services) > 0 ? {
    "SERVICES" = join(",", var.services)
  } : {}
}

# Define the LocalStack image
resource "docker_image" "localstack" {
  name = var.image_name
}

# Define the main LocalStack container
resource "docker_container" "localstack" {
  name  = var.container_name 
  image = docker_image.localstack.name

  dynamic "ports" {
    for_each = var.ports
    content {
      internal = ports.value.internal
      external = ports.value.external
      protocol = ports.value.protocol
    }
  }

  hostname = var.host_name
  networks_advanced {
    name = var.network_name  
  } 

  env = flatten([
    #I feel like maybe I could be doing this better
    for key, value in merge(var.environment, var.environment_root, local.services_map) : 
    "${key}=${value}"
  ])
}
