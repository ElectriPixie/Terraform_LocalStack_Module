# File: localstack_network.tf
# Define the LocalStack network
resource "docker_network" "localstack" {
  name = "localstack"
  driver = "bridge"
}