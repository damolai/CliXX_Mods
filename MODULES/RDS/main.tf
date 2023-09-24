# #Creating subnet group for RDS database
resource "aws_db_subnet_group" "RDS_subnet_group" {
  subnet_ids = var.subnet_ids
  
  tags = merge(var.required_tags, {"Name" = "rds-subg-tf"} )
}

#Restore RDS database
resource "aws_db_instance" "restore-rds" {
  instance_class       = var.instance_class
  identifier           = var.rdsdbname
  username             = var.DB_Username
  password             = var.DB_Password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot  = var.skip_final_snapshot
  vpc_security_group_ids = [var.security_group]
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_group.name

  multi_az = true
  # Identifier of the DB snapshot to restore from
  snapshot_identifier = var.snapshot_identifier

  tags = merge(var.required_tags, {"Name" = "var.rdsdbname"} )
}