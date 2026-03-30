module "network" {
  source = "./modules/network"
  for_each =  var.components
  component = each.key
  env  = "dev"
}


module "compute" {
  source = "./modules/compute"
  for_each =  var.components
  component = each.key
  env  = "dev"
  sg_id = module.network[each.key].sg_id
}

module "dns" {
  source = "./modules/dns"
  for_each =  var.components
  component = each.key
  private_ip = module.compute[each.key].private_ip
  env = "dev"
}

module "ansible" {
  source = "./modules/ansible"
  depends_on = [module.dns]
  for_each =  var.components
  component = each.key
  public_ip = module.compute[each.key].public_ip
  env = "dev"
}

