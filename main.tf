# export DIGITAL_TOKEN = <insert token> 
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}


# Set the variable value in *.tfvars file 
# or using -var="do_token=..." CLI option
# variable "do_token" {

resource "digitalocean_ssh_key" "web" {
  name       = "web app SHH key"
  public_key = file("${path.module}/files/id_rsa.pub")
}

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  count      = 2
  image      = "ubuntu-20-04-x64"
  name       = "web-${count.index}"
  region     = "ams3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  #private_networking = false // need to use vpc_uuid instead since private_networking is deprecated
  ssh_keys  = [digitalocean_ssh_key.web.id]
  user_data = file("${path.module}/files/user-data.sh")
}

# resource "digitalocean_certificate" "certSN" {
#   name    = "web-certificate-snappy"
#   type    = "lets_encrypt"
#   domains = ["snappy.kantorobotics.jp"]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "digitalocean_loadbalancer" "web" {
  name   = "web-lb"
  region = "ams3"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 8080
    target_protocol = "http"

    # certificate_name = digitalocean_certificate.certSN.name

  }

  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }

  droplet_ids = digitalocean_droplet.web.*.id
}

# Create a new domain
resource "digitalocean_domain" "domain" {
  name = "kantorobotics.jp"
}

resource "digitalocean_record" "cname" {
  domain = digitalocean_domain.domain.name
  type   = "CNAME"
  name   = "www"
  value  = "relativiteit.github.io."
}

resource "digitalocean_record" "main" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  value  = digitalocean_loadbalancer.web.ip
}

resource "digitalocean_record" "mainSnappy" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "snappy"
  value  = digitalocean_loadbalancer.web.ip
}
