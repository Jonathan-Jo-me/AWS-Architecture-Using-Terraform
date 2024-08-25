variable "vpc_id" {
  type        = string
}

variable "db_subnet_group_name" {
  type        = string
}

variable "db_subnet_ids" {
  type        = list(string)
}

variable "db_name" {
  type        = string
}

variable "db_username" {
  type        = string
}

variable "db_password" {
  type        = string
}

variable "app_server_sg_ids" {
  type        = list(string)
}
