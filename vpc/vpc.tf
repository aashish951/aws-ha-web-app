resource "aws_vpc" "my_vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "${var.env}- my_vpc"
        env = var.env
    }
}
resource "aws_subnet" "public_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.env}-public_subnet"
        env = var.env
    }

}

resource "aws_subnet" "public_subnet2"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone  = "us-east-1b"

    tags = {
        Name = "${var.env}-public_subnet2"
        env = var.env
    }

}

resource "aws_subnet" "private_subnet"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
     availability_zone = "us-east-1a"

    tags = {
        Name = "${var.env}-private_subnet"
        env = var.env
    }

}

resource "aws_subnet" "private_subnet2"{
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.3.0/24"
     availability_zone = "us-east-1b"

    tags = {
        Name = "${var.env}-private_subnet2"
        env = var.env
    }

}

resource "aws_eip" "elastic_ip" {
    domain = "vpc"
    tags = {
    Name = "${var.env}-elastic"
    environment = var.env
  }

  
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnet.id
    

     tags = {
    Name = "${var.env}-nat"
    environment = var.env
  }
  depends_on = [ aws_internet_gateway.igw ]
}
  


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.env}-private_subnet"
        env = var.env
    }
  
}

resource "aws_route_table" "my_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route  {
        gateway_id = aws_internet_gateway.igw.id
        cidr_block = "0.0.0.0/0"
        
    }
    tags = {
        Name = "${var.env}-route_table"
        env = var.env
    }
  
}

resource "aws_route_table" "priavte_rt" {
    vpc_id = aws_vpc.my_vpc.id

    route  {
       nat_gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
        
    }
    tags = {
        Name = "${var.env}-route_table"
        env = var.env
    }
}


resource "aws_route_table_association" "public_subnet-rt" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.my_rt.id
  
}

resource "aws_route_table_association" "public_subnet2-rt" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.my_rt.id
  
}

resource "aws_route_table_association" "private_subnet-rt" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.priavte_rt.id
  
}
resource "aws_route_table_association" "private_subnet2-rt" {
    subnet_id = aws_subnet.private_subnet2.id
    route_table_id = aws_route_table.priavte_rt.id
  
}