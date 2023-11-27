provider "aws" {
  region = "us-east-1"
  access_key = "AKIAYTUWZ5OWYE7JYHGQ"
  secret_key = "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"
}



resource "aws_vpc" "testvpc" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "testvpc"
  }
}

resource "aws_subnet" "testsubnet" {
  vpc_id     = aws_vpc.testvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "testsubnet"
  }
}

resource "aws_internet_gateway" "gwtest" {
  vpc_id = aws_vpc.testvpc.id

  tags = {
    Name = "testgw"
  }
}

resource "aws_default_route_table" "testroutetable" {
  default_route_table_id = aws_vpc.testvpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gwtest.id
  }

/*   route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  } */

  tags = {
    Name = "testroute"
  }
}

resource "aws_security_group" "test_sg" {
  name        = "test_sg"
  description = "Created for testing purpose"
  vpc_id      = aws_vpc.testvpc.id

  ingress {
    description      = "https connection"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.testvpc.cidr_block,"0.0.0.0/0"]
    }
  ingress {
    description      = "RDP Connection"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.testvpc.cidr_block,"0.0.0.0/0"]
    }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test_sg"
  }
}

