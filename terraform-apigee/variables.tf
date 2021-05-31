# Organization
variable "organization" {
  default = "danielgomezamaran-eval"
}

variable "username" {
  default = ""
}

variable "password" {
  default = ""
}

# Developer
variable "permissions_Developer" {
  default = [
    "/applications",
    "/apps",
    "/apiproducts",
    "/reports",
    "/deployments",
    "/environments/*/keystores",
    "/keyvaluemaps",
    "/environments/*/deployments"
  ]
}

variable "mails_Developer" {
  default = ["daniel.gomez.a@usach.cl"]
}
