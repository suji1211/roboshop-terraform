data "aws_ami" "centos" {
  owners           = ["973714476881"]
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"

}
data "aws_security_group" "allow-all" {
  name = "allow-all"
}
variable "components" {
  default = {
    frontend={
      name = "frontend"
      instance_type = "t3.small"
    }
    mongodb = {
      name = "mongodb"
      instance_type = "t3.micro"
    }
    catalogue = {
      name = "catalogue"
      instance_type = "t3.micro"
    }
    redis = {
      name = "redis"
      instance_type = "t3.small"
    }
    user = {
      name = "user"
      instance_type = "t3.micro"
    }
    cart = {
      name = "cart"
      instance_type = "t3.small"
    }
    mysql = {
      name = "mysql"
      instance_type = "t3.small"
    }
    shipping = {
      name = "shipping"
      instance_type = "t3.medium"
    }
    rabbitmq = {
      name = "rabbitmq"
      instance_type = "t3.small"
    }
    payment = {
      name = "payment"
      instance_type = "t3.small"
    }
  }
}

resource "aws_instance" "instance" {
    for_each = var.components
    ami           = data.aws_ami.centos.image_id
    instance_type = each.value["instance_type"]
    vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]

    tags          = {
      Name = each.value["name"]
    }
  }
resource "aws_route53_record" "dns_records" {
  for_each = var.components
  zone_id = "Z00615461MLF0SCGQYI0V"
  name    = "${each.value["name"]}.dev.sujianilsrisriyaan.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}







#variable "instance_type" {
#  default = "t3.small"
# }
# variable "components"{
#   default = ["frontend", "mongodb", "catalogue","redis","mysql","cart","user","shipping","dispatch","rabbitmq","payment"]
# }

#variable "records" {
#  default = ["frontend-dev.sujianilsrisriyaan.online", "mongodb-dev.sujianilsrisriyaan.online","catalogue-dev.sujianilsrisriyaan.online","redis-dev.sujianilsrisriyaan.online","mysql-dev.sujianilsrisriyaan.online","cart-dev.sujianilsrisriyaan.online","user-dev.sujianilsrisriyaan.online","shipping-dev.sujianilsrisriyaan.online","dispatch-dev.sujianilsrisriyaan.online","rabbitmq-dev.sujianilsrisriyaan.online","payment-dev.sujianilsrisriyaan.online"]
#}
#  resource "aws_instance" "instance" {
#    count = length(var.components)
#    ami           = data.aws_ami.centos.image_id
#    instance_type = var.instance_type
#    vpc_security_group_ids = [ data.aws_security_group.allow-all.id ]
#
#    tags          = {
#      Name = var.components[count.index]
#    }
#  }
#
#resource "aws_route53_record" "dns_records" {
#  count =length(var.records)
#  zone_id = "Z00615461MLF0SCGQYI0V"
#  name    = var.records[count.index]
#  type    = "A"
#  ttl     = 30
#  records = [aws_instance.instance[count.index].private_ip]
#}
