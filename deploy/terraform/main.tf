# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# And a subnet for the instance(s)
resource "aws_subnet" "general" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"
}

resource "aws_subnet" "other" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1b"
}

# A security group for the LB so it is accessible via the web
resource "aws_security_group" "load_balancer" {
  name        = "load-balancer"
  description = "For the load-balancer"
  vpc_id      = aws_vpc.default.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #specific route from the ELB to subnets within the VPC
  egress {
    from_port = 4001
    to_port =  4001
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "Instance"
  description = "Security group for the instance"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 4001
    to_port     = 4001
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_acm_certificate" "mycert" {
  domain = var.domain_name
  statuses = ["ISSUED"]
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "web" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = lookup(var.aws_amis, var.aws_region)

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.auth.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.default.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.general.id

  # use this to set up nginx so we can see it working.
  # Once we have releases it is no longer needed
  user_data  =  templatefile("cloud_config.yaml.tpl", {release_name: var.release_name} )

  lifecycle {
    create_before_destroy = true
  }
  provisioner "file" {
    source = "../release/${var.release_name}.tar.gz"
    destination = "/home/ubuntu/${var.release_name}.tar.gz"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir app",
      "cd app && tar zxvf ../${var.release_name}.tar.gz",
      "sudo systemctl enable --now ${var.release_name}"
    ]
  }
}

resource "aws_lb" "lb" {
  name = "new-front-of-house"
  depends_on = [aws_instance.web]
  internal           = false
  load_balancer_type = "application"
  
  security_groups = [aws_security_group.load_balancer.id]
  subnets         = [aws_subnet.general.id, aws_subnet.other.id] 
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.lb.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = data.aws_acm_certificate.mycert.arn
  default_action {
    target_group_arn = aws_lb_target_group.instance.arn
    type = "forward"
  }
}

resource "aws_lb_target_group" "instance" {
  name = "for-instance"
  port = 4001
  protocol = "HTTP"
  vpc_id = aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.instance.arn
  target_id        = aws_instance.web.id
  port             = 4001
  lifecycle {
    create_before_destroy = true
  }
}
