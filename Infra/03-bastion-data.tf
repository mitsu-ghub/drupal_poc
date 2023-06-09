data "aws_ami" "amz_lnx_2" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["Amazon Linux 2*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}