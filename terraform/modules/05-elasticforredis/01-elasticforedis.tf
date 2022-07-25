resource "aws_elasticache_subnet_group" "subnet_gp" {
  name       = var.name_redis
  subnet_ids = ["subnet-05c28fcbf01a1de34", "subnet-07d1a0ceb0235c661"]
}


resource "aws_elasticache_replication_group" "redis" {
  replication_group_id          = var.name_redis
  replication_group_description = "Replication group for Redis"
  preferred_cache_cluster_azs   = ["us-east-1a", "us-east-1b"]
  automatic_failover_enabled    = var.automatic_failover_enabled
  number_cache_clusters         = var.desired_clusters
  node_type                     = var.nodes_type["prod_env"]
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group
  security_group_ids            = [aws_security_group.redis_sg.id]
  subnet_group_name             = aws_elasticache_subnet_group.subnet_gp.name
  port                          = "6379"

}