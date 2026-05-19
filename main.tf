module "nat_gateway" {
  source = "./modules/nat-gateway"

  environment        = var.environment
  vpc_id             = var.vpc_id
  public_subnet_id   = var.public_subnet_ids[0]
  private_subnet_ids = var.private_subnet_ids

  tags = local.tags
}

module "security_groups" {
  source = "./modules/security-groups"

  environment = var.environment
  vpc_id      = var.vpc_id
  tags        = local.tags
}

module "alb" {
  source = "./modules/alb"

  environment           = var.environment
  vpc_id                = var.vpc_id
  public_subnet_ids     = var.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id

  enable_https        = var.enable_https
  acm_certificate_arn = var.acm_certificate_arn

  tags = local.tags
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  environment = var.environment
  tags        = local.tags
}

module "iam" {
  source = "./modules/iam"

  environment   = var.environment
  db_secret_arn = var.db_secret_arn

  tags = local.tags
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  environment = var.environment

  tags = local.tags
}

module "ecs_service" {
  source = "./modules/ecs-service"

  environment = var.environment

  cluster_name = module.ecs_cluster.cluster_name

  desired_count = var.desired_count

  private_subnet_ids    = var.private_subnet_ids
  ecs_security_group_id = module.security_groups.ecs_security_group_id
  alb_target_group_arn  = module.alb.target_group_arn

  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn

  log_group_name = module.cloudwatch.log_group_name

  ecr_image_uri = var.ecr_image_uri
  db_secret_arn = var.db_secret_arn

  aws_region = var.aws_region

  tags = local.tags
  # depends_on = [
  #   module.alb,
  #   module.security_groups,
  #   module.cloudwatch
  # ]
}

module "autoscaling" {
  source = "./modules/autoscaling"

  environment = var.environment

  cluster_name = module.ecs_cluster.cluster_name
  service_name = module.ecs_service.service_name

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  tags = local.tags

  depends_on = [module.ecs_service]
}
