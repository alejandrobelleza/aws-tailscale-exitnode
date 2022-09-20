data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_spot_instance_request" "tailnode" {
  spot_price                  = var.spot_price
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.tailscale.name
  subnet_id                   = var.public_subnet_ids[0]
  key_name                    = var.key_pair_name
  vpc_security_group_ids      = [aws_security_group.tailnode.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/templates/user_data.tmpl.sh", {
    hostname             = var.hostname
    authkey              = var.tailscale_authkey
    enable_tailscale_ssh = var.enable_tailscale_ssh
    advertise_routes     = var.advertise_routes
  })

  tags = merge(local.tags, { Component = "exitnode" })

}

resource "aws_security_group" "tailnode" {
  vpc_id = var.vpc_id

  tags = merge(local.tags, { Component = "exitnode" })
}


resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.tailnode.id
}
