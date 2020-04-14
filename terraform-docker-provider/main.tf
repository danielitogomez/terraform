
variable "image_name" {
  description = "Image for container."
  default     = "danielgomeza/apache-php-passenger:latest"
}

variable "container_name" {
  description = "Name of the container."
  default     = "blog"
}

variable "int_port" {
  description = "Internal port for container."
  default     = "80"
}

variable "ext_port" {
  description = "External port for container."
  default     = "80"
}

resource "docker_image" "image_id" {
  name = "${var.image_name}"
}

resource "docker_container" "container_id" {
  name  = "${var.container_name}"
  image = "${docker_image.image_id.latest}"
  ports {
    internal = "${var.int_port}"
    external = "${var.ext_port}"
  }
}

output "ip_address" {
  value       = "${docker_container.container_id.ip_address}"
  description = "The IP for the container."
}

output "container_name" {
  value       = "${docker_container.container_id.name}"
  description = "The name of the container."
}

