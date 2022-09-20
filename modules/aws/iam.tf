resource "aws_iam_role" "tailscale" {
  name = var.name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = local.tags
}

resource "aws_iam_instance_profile" "tailscale" {
  name = var.name
  role = aws_iam_role.tailscale.name
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = data.aws_iam_policy.ssm.arn
  role       = aws_iam_role.tailscale.name
}
