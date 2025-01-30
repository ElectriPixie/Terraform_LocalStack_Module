# File: localstack_network.tf
# Define the LocalStack network
data "docker_network" "existing_network" {
  name = var.network_name
}

resource "docker_network" "localstack" {
  name   = var.network_name
  driver = var.network_driver
  id     = try(data.docker_network.existing_network.id, data.docker_network.existing_network.name)
}
