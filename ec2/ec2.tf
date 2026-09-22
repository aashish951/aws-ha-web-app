resource "aws_key_pair" "my_key" {
    key_name = "${var.env}-my_key"
    public_key = file("~/.ssh/my-key.pub")
    tags = {
        Name = "${var.env}-public_subnet"
        env = var.env
    }

  
}

resource "aws_security_group" "ec2_sg" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.env}-ec2_sg"
        env = var.env
    }
    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "ssh"

    }
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        security_groups = [ var.alb_sg_id ]
        description = "traffic from alb only "
}


    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "everwhere"
    }

  
}

resource "aws_instance" "ec2" {
    count = 2
    subnet_id = var.subnet_id
   vpc_security_group_ids = [ aws_security_group.ec2_sg.id ]
   instance_type = "t3.micro"
   key_name = aws_key_pair.my_key.id
  ami = var.ami
  associate_public_ip_address = true
  user_data = file("deploy.sh")
   root_block_device {
     volume_size = 10
     volume_type = "gp3"
   }

   tags = {
        Name = "${var.env}-public_subnet"
        env = var.env
    }
   

  
}