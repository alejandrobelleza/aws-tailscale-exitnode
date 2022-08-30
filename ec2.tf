data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "worker" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  iam_instance_profile        = aws_iam_instance_profile.tailscale.name
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.worker.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/user_data.tmpl.sh", {
    name    = var.name
    authkey = var.tailscale_authkey
  })

  tags = merge(local.tags, { Component = "worker" })

}

resource "aws_security_group" "worker" {
  vpc_id = var.vpc_id

  tags = merge(local.tags, { Component = "worker" })
}


# resource "aws_security_group_rule" "allow_9202_worker" {
#   type              = "ingress"
#   from_port         = 9202
#   to_port           = 9202
#   protocol          = "tcp"
#   cidr_blocks       = var.allow_cidr_blocks_to_workers
#   security_group_id = aws_security_group.worker.id
# }

resource "aws_security_group_rule" "allow_egress_worker" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker.id
}
