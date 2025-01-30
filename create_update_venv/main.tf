resource "null_resource" "create_update_venv" {
  provisioner "local-exec" {
    command     = "if [ ! -d localstack-venv ]; then python3 -m venv localstack-venv && localstack-venv/bin/pip install -r requirements.txt; else localstack-venv/bin/pip check; fi"
    interpreter = ["bash", "-c"]
  }
}
