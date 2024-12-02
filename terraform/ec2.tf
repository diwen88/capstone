# create ec2 instance in public subnet 
resource "aws_instance" "public_ec2" {
  ami           = var.ami_amz_l2
  instance_type = "${var.ec2_instance_type}"
  subnet_id     = aws_subnet.public_subnet_1.id
  key_name      = "${var.key_name}"
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  # enable public ip
  associate_public_ip_address = true 

  tags = {
    Name = "public-ec2"
  }
}

# create sg for public ec2 instance 
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outboind traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}