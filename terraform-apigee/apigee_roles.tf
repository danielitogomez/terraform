# Developer
resource "apigee_role" "Developer" {
  name = "Developer"
}

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

resource "apigee_role_permission" "Developer" {
  role_name = apigee_role.Developer.name
  count     = length(var.permissions_Developer)
  path      = var.permissions_Developer[count.index]
  permissions = [
    "get",
    "put"
  ]
}

