# File: localstack_network.tf
# Define the LocalStack network
resource "docker_network" "localstack" {
  name = var.name
  driver = var.driver
}