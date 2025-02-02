provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_elasticache_cluster" "demo_cluster" {
  cluster_id           = "demo_cluster"
  engine               = "memcached"
  node_type            = "cache.t4g.micro"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
  tags = {
    Name = "my_new_cluster"
  }
}
