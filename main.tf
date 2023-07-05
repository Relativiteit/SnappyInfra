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
  image      = "ubuntu-20-04-x64"
  name       = "testing-1"
  region     = "ams3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  #private_networking = false // need to use vpc_uuid instead since private_networking is deprecated
  ssh_keys  = [digitalocean_ssh_key.web.id]
  user_data = file("${path.module}/files/user-data.sh")
}


