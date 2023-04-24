resource "aws_eip" "bastion-eip" {
  vpc      = true

}

resource "aws_key_pair" "terraform-key" {
  key_name   = "${local.id_gen}-keypair"
  public_key = file("${path.module}/Private_Key/${local.id_gen}-terraform.pub")
}



resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion-eip.id
}

resource "aws_instance" "bastion" {
    ami = data.aws_ami.amz_lnx_2.id
    vpc_security_group_ids = [aws_security_group.bastion-sg.id]
    instance_type = var.bastion-instance-type
    subnet_id = [for subnet in aws_subnet.public_subnets: subnet.id][0]
    key_name = aws_key_pair.terraform-key.key_name

    tags = merge({
    Name = "${local.id_gen}-bastion-server"
  },
  local.common_tags
  )
}

resource "null_resource" "key-2-copy" {

    depends_on = [
      aws_instance.bastion
    ]
    connection {
      type = "ssh"
      host = aws_eip.bastion-eip.public_ip
      user = "ec2-user"
      password = ""
      private_key = file("${path.module}/Private_Key/${local.id_gen}-terraform")
    }
    provisioner "file" {
      source = "Private_Key/${local.id_gen}-terraform"
      destination = "/tmp/key.pem"
    }

    provisioner "remote-exec" {
        inline = [
          "mkdir ~/.ssh",
          " cp -p /tmp/key.pem ~/.ssh/key.pem",
          "sudo chmod 400 ~/.ssh/key.pem"
        ]     
    }  
}