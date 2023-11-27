variable "rootvolume" {}
variable "datavolume" {}

resource "aws_instance" "web" {
  ami           = "ami-0cd601a22ac9e6d79"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.test_sg.id]
  subnet_id = aws_subnet.testsubnet.id
  key_name = "tfkey"

  tags = {
    Name = "HelloWorld"
    Owner = "Prasanna"
  }

  root_block_device {
    volume_size           = var.rootvolume
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.datavolume
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
}

resource "aws_eip" "myeip" {
   instance = aws_instance.web.id
}


output "ec2_private_ip"{
  value = aws_instance.web.private_ip

}

output "ec2_public_ip" {
    value = aws_eip.myeip.public_ip
}
