resource "aws_instance" "private_server_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_1_id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.private_server_sg.id]  
  tags = {
    Name = "clops-application-server-1"
  }

  root_block_device {
    volume_size = 25
  }
}

resource "aws_instance" "private_server_2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_2_id
  key_name       = var.key_name

  vpc_security_group_ids = [aws_security_group.private_server_sg.id]  

  tags = {
    Name = "clops-application-server-2"
  }

  root_block_device {
    volume_size = 25
  }
}



resource "aws_security_group" "private_server_sg" {
  vpc_id = var.vpc_id
  name   = "private-server-sg"
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-server-sg"
  }
}


resource "aws_security_group_rule" "allow_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_server_sg.id
  source_security_group_id = var.bastion_sg_id 
}
