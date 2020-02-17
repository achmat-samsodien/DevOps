resource "aws_instance" "webserver" {
  count                       = length(var.private_subnets_cidr)
  ami                         = var.ami
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.webserver_sg.id]
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  source_dest_check           = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_instance_profile.name
  associate_public_ip_address = false

  root_block_device {
    volume_size           = var.storage_volume
    volume_type           = "gp2"
    delete_on_termination = true #we dont want to incur costs unnecesarily
  }
  provisioner "file" {
    source      = "nginx.sh"
    destination = "tmp/nginx.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }

  tags = {
    Name = "webserver-${count.index}"
  }
}