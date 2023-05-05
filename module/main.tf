resource "aws_instance" "instance" {
   ami                    = data.aws_ami.centos.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.component_name
  }
}

resource "null_resource" "provisioner" {

  depends_on = [aws_instance.instance, aws_route53_record.dns_records]
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance.private_ip
    }
    inline = [
      "rm -rf roboshop-shell",
      "git clone https://github.com/suji1211/roboshop-shell",
      "cd roboshop-shell",
      "sudo bash ${var.component_name}.sh ${var.password }"
    ]
  }

}
resource "aws_route53_record" "dns_records" {
  zone_id = "Z00615461MLF0SCGQYI0V"
  name    = "${var.component_name}-dev.sujianilsrisriyaan.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

