# File: localstack_network.tf
# Define the LocalStack network
data "docker_network" "localstack" {
  name = var.network_name
}

resource "docker_network" "localstack" {
  name   = var.network_name
  driver = var.network_driver
  count  = data.docker_network.localstack.id == "" ? 1 : 0
}
