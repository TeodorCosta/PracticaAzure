resource "random_password" "password" {
  length  = 16
  special = true
}