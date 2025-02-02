#defining the provider as aws
provider "aws" {
    region     = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}

#create a ElastiCache Redis Cluster
resource "aws_elasticache_cluster" "redis_db" {
  cluster_id           = "redis-db"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  engine_version       = "7.1.0"
  port                 = 6379
  tags = {
    Name = "myrediscluster"
  }
}