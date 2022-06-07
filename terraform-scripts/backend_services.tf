resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "db_subnet_grp"
  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
  tags = {
    Name = "Subnet for RDS"
  }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name = "elasticache_subnet_grp"
  subnet_ids = [module.vpc.private_subnets[0],module.vpc.private_subnets[1],module.vpc.private_subnets[2]]
  tags = {
    Name = "Subnet for elastic cache"
  }
}
resource "aws_db_instance" "vprofile_mysql" {
  allocated_storage    = 20
  storage_type = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.34"
  instance_class       = "db.t2.micro"
  db_name                 = var.dbname
  username             = var.dbuser
  password             = var.dbpass
  parameter_group_name = "default.mysql5.6"
  multi_az = "false"
  publicly_accessible = "false"
  skip_final_snapshot  = true
  security_group_names = [aws_security_group.vprofile-backend-inst.id]
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
}

resource "aws_elasticache_cluster" "vprofile_elastic_cache" {
  cluster_id           = "vprofile-elastic-cache"
  engine               = "memcached"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.5"
  port                 = 11211
  security_group_names = [aws_security_group.vprofile-backend-inst.id]
  subnet_group_name = aws_elasticache_subnet_group.elasticache_subnet_group.name
}

resource "aws_mq_broker" "vprofile_active_mq" {
  broker_name = "vprofile_active_mq"

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = [aws_security_group.vprofile-backend-inst.id]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}