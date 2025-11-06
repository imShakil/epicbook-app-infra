output "epicbook_infra" {
  value = {
    publicIP    = module.vm.instance_attribute.public_ip
    rdsEndpoint = "${split(":", module.db.rds_info.endpoint)[0]}"
  }
}
