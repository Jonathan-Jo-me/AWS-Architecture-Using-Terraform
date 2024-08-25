region               = "us-east-1"
vpc_name             = "clops-vpc"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]
ami_id = "ami-066784287e358dad1"
instance_type = "t2.micro"
key_name = "ClopsKEY"
db_username          = "admin"
db_password          = "mysql1706"
iam_user_name = "clops-user"
bucket_name = "clops-s3-bucketsss"