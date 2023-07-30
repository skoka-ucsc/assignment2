packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "skoka-${regex_replace(timestamp(), "[- TZ:]", "")}"
  instance_type = "t2.micro"
  region        = "us-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "redis-dev-env"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "builduser=redisbuilder",
    ]
    inline = [
      "echo \"Provisioning Redis Dev Environment with builduser=$builduser.\" > buildlog.txt",
      "sleep 30",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo apt-get update",
      "sudo apt-get install -y build-essential",
      "sudo apt-get install -y libsystemd-dev",
      "sudo apt-get install -y pkg-config",
      "sudo apt-get install -y tcl",
      "sudo sysctl vm.overcommit_memory=1",
      "sudo sysctl -w net.core.somaxconn=1024",
      "sudo sysctl -w fs.file-max=500000",
      "sudo useradd -m -d /home/$builduser $builduser",
      "sudo -i -u $builduser  git clone https://github.com/redis/redis.git",
    ]
  }

  provisioner "shell" {
    inline = ["echo \"Completed provisioning of Redis Dev Environment.\" >> buildlog.txt"]
  }
}

