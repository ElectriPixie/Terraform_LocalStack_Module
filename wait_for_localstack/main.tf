resource "null_resource" "wait_for_localstack" {
  depends_on = [module.localstack, null_resource.create_update_venv]
  provisioner "local-exec" {
    command     = <<EOT
      source localstack-venv/bin/activate
      echo "Waiting for LocalStack services to be ready..."
      until curl -s -f http://localhost:4566/_aws/service/health > /dev/null; do
        echo "Waiting for LocalStack services to be ready..."
        sleep 5
      done
      echo "LocalStack services are ready!"
    EOT
    interpreter = ["bash", "-c"]
  }
}
