terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = ""
  secret_key = ""
  token      = ""
}

# [KEY PAIR]
resource "aws_key_pair" "the_key_pair" {
  key_name   = "id_rsa"
  public_key = file("~/.ssh/id_rsa.pub")
}

# [VPC]
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# [INTERNET GATEWAY]
resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# [SECURITY GROUP]

resource "aws_security_group" "sg_blockchain_net" {
  description = "List of allowed traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "http traffic allowed"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http traffic allowed"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MySQL MariaDB"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "quorum"
    from_port   = 8545
    to_port     = 8547
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "quorum"
    from_port   = 30303
    to_port     = 30303
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "quorum"
    from_port   = 30303
    to_port     = 30303
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh traffic allowed"
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
}

# [SUBNET]
resource "aws_subnet" "main_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2c"

  tags = {
    Name = "public_subnet"
  }
}

# [ROUTE TABLE]
resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "public_subnet_route_table"
  }
}

# [ROUTE ASSOCIATION]
resource "aws_route_table_association" "rt_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_rt.id
}

# [EC2 INSTANCE]

resource "aws_instance" "master-instance" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = aws_key_pair.the_key_pair.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  vpc_security_group_ids = [
    aws_security_group.sg_blockchain_net.id
  ]

  tags = {
    Name = "master-instance"
  }
}

resource "aws_eip" "master-ip" {
  domain   = "vpc"
  instance = aws_instance.master-instance.id
}

resource "aws_instance" "worker1-instance" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = aws_key_pair.the_key_pair.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  vpc_security_group_ids = [
    aws_security_group.sg_blockchain_net.id
  ]

  tags = {
    Name = "worker-instance-1"
  }
}

resource "aws_eip" "worker1-ip" {
  domain   = "vpc"
  instance = aws_instance.worker1-instance.id
}

resource "aws_instance" "worker2-instance" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = aws_key_pair.the_key_pair.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  vpc_security_group_ids = [
    aws_security_group.sg_blockchain_net.id
  ]

  tags = {
    Name = "worker-instance-2"
  }
}

resource "aws_eip" "worker2-ip" {
  domain   = "vpc"
  instance = aws_instance.worker2-instance.id
}

resource "aws_instance" "worker3-instance" {
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = aws_key_pair.the_key_pair.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 10
  }

  vpc_security_group_ids = [
    aws_security_group.sg_blockchain_net.id
  ]

  tags = {
    Name = "worker-instance-3"
  }
}

resource "aws_eip" "worker3-ip" {
  domain   = "vpc"
  instance = aws_instance.worker3-instance.id
}
