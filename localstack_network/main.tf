# File: localstack_network.tf
# Define the LocalStack network
/* resource "null_resource" "ensure_network" {
  provisioner "local-exec" {
    command = "docker network ls --quiet --filter name=${var.network_name} || docker network create ${var.network_name}."
  }
}

resource "docker_network" "localstack" {
  name       = var.network_name
  driver     = var.network_driver
  depends_on = [data.docker_network.localstack]
}
 */
data "docker_network" "localstack_network_exists" {
  name = var.network_name
}

resource "docker_network" "localstack" {
  name   = data.docker_network.localstack_network_exists.name
  driver = var.network_driver
}
