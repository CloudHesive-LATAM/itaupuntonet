resource "aws_db_instance" "default" {
  allocated_storage    = 100
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "m5.large"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default"
  skip_final_snapshot  = true
}