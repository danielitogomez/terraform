# Developer
resource "apigee_role" "Developer" {
  name = "Developer"
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

