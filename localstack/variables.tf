variable "network_name" {}

variable "ports" {
  type = list(map(string))
  default = [{
      internal = 4566,
      external = 4566,
      protocol = ""
      }]
}

variable "host_name" {
  description = "Container Hostname"
  type = string
  default="localstack"
}

variable "container_name" {
  description = "Container Name"
  type = string
  default="localstack"    
}

variable "image_name" {
  description = "Image Name"
  type = string
  default="localstack/localstack"    
}

variable "services"{
  description = "LocalStack service name"
  type = list(string)
  default=[]
}

variable "environment_root" {
  description = "A map of environment variables for LocalStack services from the root variables.tf"
  type = map(string)
  default = {}
}

variable "environment" {
  description = "A map of environment variables for LocalStack services."
  type = map(string)
  default = {}
}