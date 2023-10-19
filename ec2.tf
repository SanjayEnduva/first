resource "aws_instance" "bastion" {
  ami           = "ami-03eb6185d756497f8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_sg_for_public.id]
  subnet_id = aws_subnet.public.id

  tags = {
    Name = "bastion-instance"
  }
}

resource "aws_instance" "linux" {
  ami           = "ami-03eb6185d756497f8"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.test_sg_for_private.id]
  subnet_id = aws_subnet.private.id

  tags = {
    Name = "linux-instance"
  }
}

resource "aws_security_group" "test_sg_for_public" {
  name        = "secg-for-pubec2"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.test_vpc.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "test_sg_for_private" {
  name        = "secg-for-priec2"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.test_sg_for_public.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}