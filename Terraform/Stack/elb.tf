##################
# ACM certificate
##################

resource "aws_route53_zone" "private" {
  name = "blkswn.local"

  vpc {
    vpc_id = aws_vpc.bs_vpc.id
  }

}

module "acm" {
  source                    = "terraform-aws-modules/acm/aws"
  version                   = "~> 2.0"
  zone_id                   = aws_route53_zone.private.zone_id
  domain_name               = "blkswn.local"
  subject_alternative_names = ["*.blkswn.local"]

  wait_for_validation = false
}


##################
# ELB Definition
##################

resource "aws_elb" "bs-elb" {
  name               = "bs-elb"
  availability_zones = flatten([var.azs])
  subnets            = flatten([aws_subnet.public.*.id])
  security_groups    = [aws_security_group.elb.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "https"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = module.acm.this_acm_certificate_arn
  }


  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

}

