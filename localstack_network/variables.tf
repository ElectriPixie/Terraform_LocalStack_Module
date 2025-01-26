variable "network_name" {
  description = "the name of the docker network to create"
  type = string
  default = "localstack"
}
variable "network_driver" {
  description = "the name of the docker network to create"
  type = string
  default = "bridge"
}