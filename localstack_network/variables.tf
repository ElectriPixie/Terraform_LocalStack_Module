variable "name" {
  description = "the name of the docker network to create"
  type = string
  default = "localstack"
}
variable "driver" {
  description = "the name of the docker driver"
  type = string
  default = "bridge"
}