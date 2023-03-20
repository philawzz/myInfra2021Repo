provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = "172.16.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "main"
  }
}          

# Create the production subnet
resource "aws_subnet" "main-subnet" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "eu-west-2a"
  cidr_block              = "172.16.0.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Main subnet"
  }
}

# Create Internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
}


# Create route table
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "Main-RT"
  }
}


# Associates subnet with Route Table
resource "aws_route_table_association" "main-rta" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-rt.id
}
  
#Create security group with firewall rules
resource "aws_security_group" "jenkins-sg-2022" {
  name        = var.security_group
  description = "security group for Ec2 instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id         = aws_subnet.main-subnet.id
  key_name = var.key_name
  
 # Security Group
  vpc_security_group_ids = [aws_security_group.jenkins-sg-2022.id]
  tags= {
    Name = var.tag_name
  }
}

