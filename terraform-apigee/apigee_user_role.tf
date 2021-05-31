# Developer
resource "apigee_user_role" "Developer" {
  count     = length(var.mails_Developer)
  email_id  = var.mails_Developer[count.index]
  role_name = apigee_role.Developer.name
}
