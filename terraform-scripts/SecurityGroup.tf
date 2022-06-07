resource "aws_security_group" "vprofile-elb-sg" {
  name = "vprofile-elb-sg"
  description = "This is sec group of bean stalk load balancer"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bashionhost-sg-vprofile" {
  name = "bashionhost-sg-vprofile"
  description = "This is sec group of bashion host"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [var.MYIP]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vprofile-beanstalk-sg" {
  name = "vprofile-beanstalk-sg"
  description = "This is sec group of bean stalk"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [aws_security_group.bashionhost-sg-vprofile.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "vprofile-backend-inst" {
  name = "vprofile-backend-inst"
  description = "This is sec group of backend instances"
  ingress {
    from_port = 0
    protocol = "tcp"
    to_port = 0
    security_groups = [aws_security_group.vprofile-beanstalk-sg.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "to-allow-bg-comm" {
  from_port = 0
  protocol = "tcp"
  source_security_group_id = aws_security_group.vprofile-backend-inst.id
  security_group_id = aws_security_group.vprofile-backend-inst.id
  to_port = 65535
  type = "ingress"
}