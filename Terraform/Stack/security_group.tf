#=============================================================================#
#                    ELB SECURITY GROUP
#=============================================================================#

resource "aws_security_group" "elb" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.bs_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "elb_http" {
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  type              = "ingress"
  description       = "Allow traffic to ELB via 80 port from internet"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "elb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  description       = "Allow traffic to ELB via 443 port from internet"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb.id
}

#=============================================================================#
#                    DB SECURITY GROUP
#=============================================================================#

resource "aws_security_group" "db" {
  name        = format("%s-database-sg", var.environment)
  description = "DB security group"
  vpc_id      = aws_vpc.bs_vpc.id
}

#Only Allow private subnet access

resource "aws_security_group_rule" "db_mysql" {
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"

  cidr_blocks = var.private_subnets_cidr

  type              = "ingress"
  security_group_id = aws_security_group.db.id
}


#=============================================================================#
#                    EC2 SECURITY GROUP
#=============================================================================#

resource "aws_security_group" "webserver_sg" {
  name   = "webserver-ssm-sg"
  vpc_id = aws_vpc.bs_vpc.id
}

resource "aws_security_group" "endpoints_sg" {
  name   = "endpoints-ssm-sg"
  vpc_id = aws_vpc.bs_vpc.id
}


resource "aws_security_group_rule" "allow_webserver_443_from_endpoints" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.endpoints_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

resource "aws_security_group_rule" "allow_webserver_443_to_endpoints" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.endpoints_sg.id
  security_group_id        = aws_security_group.webserver_sg.id
}

#=============================================================================#
#                    ENDPOINTS SECURITY GROUP ROLES
#=============================================================================#

resource "aws_security_group_rule" "allow_endpoints_443_from_webserver" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.endpoints_sg.id
}

resource "aws_security_group_rule" "allow_endpoints_443_to_webserver" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.webserver_sg.id
  security_group_id        = aws_security_group.endpoints_sg.id
}