resource "aws_security_group" "alb_sg" {
    vpc_id = var.vpc_id
   
    tags = {
        Name = "${var.env}-lb_sg"
        env = var.env
    }
    
    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "http"
        
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        description = "everwhere"
    }

  
}

resource "aws_lb" "external_alb" {
    internal = false
    load_balancer_type = "application"  
    subnets = var.subnet_ids
    security_groups = [ aws_security_group.alb_sg.id ]
    tags = {
        Name = "${var.env}-lb_sg"
        env = var.env
    }
}

resource "aws_lb_target_group" "lb_tg" {
    vpc_id = var.vpc_id
    port = 80
    protocol = "HTTP"
    health_check {
  path                = "/"
  port                = "traffic-port"
  protocol            = "HTTP"
  matcher             = "200"
  interval            = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}
tags = {
      Name = "${var.env}-lb_tg"
      environment =  var.env
    }
  
}

resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.external_alb.arn
    port = 80
    protocol = "HTTP"

    default_action  {
      type = "forward"
      target_group_arn = aws_lb_target_group.lb_tg.arn
    }

    tags = {
      Name = "${var.env}-lb_tg_listener"
      environment =  var.env
    }
  
}

resource "aws_lb_target_group_attachment" "lb_tg_attachment" {
    target_id = var.instance_id
    target_group_arn = aws_lb_target_group.lb_tg.arn
    port = 5000
    
  
}
  



