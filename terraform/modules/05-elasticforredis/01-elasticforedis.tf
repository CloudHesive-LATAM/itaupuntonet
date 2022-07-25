resource "aws_elasticache_subnet_group" "subnet_gp" {
  name       = var.name_redis
  subnet_ids = ["10.159.53.128/25, 10.159.53.0/25"]
}


resource "aws_elasticache_replication_group" "redis_group" {
  for_each = var.az
  replication_group_id       = "redis-cluster-webapp"
  description                = "Redis Itaul web app"
  preferred_cache_cluster_azs = [each.value]
  node_type                  = var.nodes_type["prod_env"]
  port                       = 6379
  parameter_group_name       = "default.redis3.2.cluster.on"
  automatic_failover_enabled = true

  num_node_groups         = 2
  replicas_per_node_group = 1
}