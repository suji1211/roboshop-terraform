module "vpc" {
  source = "git::https://github.com/suji1211/tf-module-vpc.git"

  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]
  tags = local.tags
  env = var.env
}

module "app" {
  depends_on = [module.vpc, module.docdb, module.rds, module.elasticache, module.rabbitmq, module.alb]
  source     = "git::https://github.com/suji1211/tf-module-app.git"

  for_each          = var.app
  instance_type     = each.value["instance_type"]
  name              = each.value["name"]
  desired_capacity  = each.value["desired_capacity"]
  max_size          = each.value["max_size"]
  min_size          = each.value["min_size"]
  app_port          = each.value["app_port"]
  listener_priority = each.value["listener_priority"]
  dns_name          = each.value["name"] == "frontend" ? each.value["dns_name"] : "${each.value["name"]}-${var.env}"
  parameters        = each.value["parameters"]

  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_app_cidr"], null), "subnet_cidrs", null)
  listener_arn   = lookup(lookup(module.alb, each.value["lb_type"], null), "listener_arn", null)
  lb_dns_name    = lookup(lookup(module.alb, each.value["lb_type"], null), "dns_name", null)

  env          = var.env
  bastion_cidr = var.bastion_cidr
  tags         = merge(local.tags, { Monitor = "true" })
  domain_name  = var.domain_name
  domain_id    = var.domain_id
  kms_arn      = var.kms_arn
  monitor_cidr = var.monitor_cidr
}