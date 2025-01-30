# File: localstack_network.tf
# Define the LocalStack network
resource "null_resource" "ensure_network" {
  provisioner "local-exec" {
    command = "docker network ls --quiet --filter name=${var.network_name} || docker network create ${var.network_name}."
  }
}
