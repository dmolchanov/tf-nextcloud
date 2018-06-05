variable "access_key" {}
variable "secret_key" {}
variable "nextcloud_version" {}
variable "nextcloud_s3_bucket_id" {}
variable "nextcloud_db_name" {
  type = "string"
  description = "Nextcloud database name"
  default = "nextcloud"
}
variable "nextcloud_db_user" { 
  type = "string"
  description = "Nextcloud database user"
  default = "nextcloud"
}
variable "nextcloud_db_password" {
  type = "string"
  description = "Nextcloud database password"
}
variable "region" {
  default = "eu-central-1"
}
variable "images" {
  type = "map"
}
variable "version" {
  type = "string"
  default = "v1"
}
