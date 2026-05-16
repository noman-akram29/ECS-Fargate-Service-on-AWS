output "nat_gateway_id" {
  value = module.nat_gateway.nat_gateway_id
}

output "nat_eip" {
  value = module.nat_gateway.nat_eip
}

output "private_route_table_id" {
  value = module.nat_gateway.private_route_table_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}