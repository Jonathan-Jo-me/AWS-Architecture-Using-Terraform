resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id  
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bastion_sg.id] 
  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }


  root_block_device {
    volume_size = 10
  }

}



resource "aws_security_group" "bastion_sg" {
  vpc_id = var.vpc_id 

  name        = "bastion-sg"
  description = "Security group for the bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "bastion-sg"
  }
}




