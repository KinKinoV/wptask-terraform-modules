# module "my-sql-rds" {
#   source = "terraform-aws-modules/rds/aws"
#   version = "6.6.0"

#   identifier = "${var.environment}-wp-mysql"

#   engine = "mysql"
#   engine_version = "8.0.35"
#   family = "mysql8.0"
#   major_engine_version = "8.0"
#   instance_class = "db.c6gd.medium"

#   allocated_storage = 20
#   max_allocated_storage = 100

#   db_name = "wpMysql"
#   username = "wp_admin"
#   port = 3306

#   multi_az = true
#   db_subnet_group_name = module.vpc.database_subnet_group
#   vpc_security_group_ids = [module.db-sg.security_group_id]

#   enabled_cloudwatch_logs_exports = ["general"]
#   create_cloudwatch_log_group     = true

#   skip_final_snapshot = true
#   deletion_protection = false

#   performance_insights_enabled          = true
#   performance_insights_retention_period = 7
#   create_monitoring_role                = false
#   monitoring_role_arn                   = var.rds_monitoring_role_arn
#   monitoring_interval                   = 60

#   tags = local.tags
# }

