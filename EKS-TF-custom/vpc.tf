# Lấy tên vpc
data "aws_vpc" "vpc" {
    filter {
      name   = "tag:Name"
      values = [var.vpc-name]
    }
}

# Lấy Internet gateway của vpc
data "aws_internet_gateway" "igw" {
    filter {
      name   = "tag:Name"
      values = [var.igw-name]
    }
}

# Lấy subnet của Jenkins Server 
data "aws_subnet" "subnet" {
    filter {
        name   = "tag:Name"
        values = [var.subnet-name-jenkins-az1]
    }
}

data "aws_subnet" "subnet1" {
  filter {
    name = "tag:Name"
    values = [var.subnet-name-jenkins-az2]
  }
}

# Lấy ra security group Jenkins 
data "aws_security_group" "sg-default" {
    filter {
        name   = "tag:Name"
        values = [var.security-group-name]
    }
}

# Tạo 2 subnet cho EKS phân ra hai khu vực 
resource "aws_subnet" "public-subnet-eks-AZ1" {
    vpc_id                  = data.aws_vpc.vpc.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true

    tags = {
      Name = var.subnet-name-EKS-az1
    }
}

resource "aws_subnet" "public-subnet-eks-Az2" {
  vpc_id            = data.aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet-name-EKS-az2
  }
}

# Tạo ra route table cho EKS
resource "aws_route_table" "rt-eks" {
    vpc_id = data.aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.igw.id
    }

    tags = {
        Name = var.rt-name-eks
    }
}

# Đính kèm subnet vào route table EKS
resource "aws_route_table_association" "rt-association-subnet1" {
    route_table_id = aws_route_table.rt-eks.id
    subnet_id  = aws_subnet.public-subnet-eks-AZ1.id
}

resource "aws_route_table_association" "rt-association-subnet2" {
    route_table_id = aws_route_table.rt-eks.id
    subnet_id  = aws_subnet.public-subnet-eks-Az2.id
}
