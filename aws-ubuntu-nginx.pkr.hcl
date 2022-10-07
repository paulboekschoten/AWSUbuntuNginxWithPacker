variable "region" {
  type    = string
}

variable "ami_name" {
  type    = string
}

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu-nginx" {
  ami_name      = "${var.ami_name}"
  instance_type = "t2.micro"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "${var.ami_name}"
  sources = [
    "source.amazon-ebs.ubuntu-nginx"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx"
    ]
  }
}