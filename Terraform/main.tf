provider "aws" {
  region = "ap-south-1"
}

data "aws_subnet" "public_a" {
  id = "subnet-03571a7062bf14be8"
}

data "aws_security_group" "default" {
  id = "sg-0bd9eba5479b04af8"
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-05d2d839d4f73aafb"
  instance_type = "m7i-flex.large"

  subnet_id                   = data.aws_subnet.public_a.id
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  key_name = "DevOps"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  user_data = <<-EOF
              ${file("userdata.sh")}
              EOF

  provisioner "file" {
    source      = "plugins.txt"
    destination = "/tmp/plugins.txt"
  }

  provisioner "file" {
    source      = "jenkins.yaml"
    destination = "/tmp/jenkins.yaml"
  }

  tags = {
    Name = "Aniket-Jenkins-Master"
  }
}
