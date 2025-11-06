output "epicbook_infra" {
  value = {
    "Public IP" = module.vm.instance_attribute.public_ip
    "RDS Endpoint" = module.db.rds_info.endpoint
  }
}
