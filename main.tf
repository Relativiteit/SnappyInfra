terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean"{}

# Set the variable value in *.tfvars file 
# or using -var="do_token=..." CLI option
# variable "do_token" {

# Create a new Web Droplet in the nyc2 region
resource "digitalocean_droplet" "web" {
  image  = "ubuntu-20-04-x64"
  name   = "testing-1"
  region = "ams3"
  size   = "s-1vcpu-1gb"
}