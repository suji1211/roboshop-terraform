module "database_servers" {
  for_each = var.database_servers
  source = "./module"
  component_name = each.value["name"]
  env = var.env
  instance_type = each.value["instance_type"]
 password = lookup(each.value, "password", "null")
  provisioner = true
}

module "app_servers" {
  depends_on = [module.database_servers]
  for_each = var.app_servers
  source = "./module"
  component_name = each.value["name"]
  env = var.env
  instance_type = each.value["instance_type"]
  password = lookup(each.value, "password", "null")
}





#03-vars.yml "instance_type" {
#  default = "t3.small"
# }
# 03-vars.yml "components"{
#   default = ["frontend", "mongodb", "catalogue","redis","mysql","cart","user","shipping","dispatch","rabbitmq","payment"]
# }

#03-vars.yml "records" {
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
