# Top-level domain for the webserver
# eg. foo.com
variable "root_domain" {
  type = "string"
}

# All subdomains that should redirect traffic
# eg. www.foo.com en.foo.com
variable "domains" {
  type = "list"
}

# URL you want to redirect to
variable "target_url" {
  type = "string"
}

variable "ssh_user" {
  type = "string"
}

variable "ssh_key_path" {
  type    = "string"
  default = "~/.ssh/id_rsa.pub"
}
