variable "vpc_id" {
  type        = string
}

variable "alb_name" {
  type        = string
}

variable "target_group_name" {
  type        = string
}

variable "alb_subnet_ids" {
  type        = list(string)
}

variable "alb_security_group_id" {
  type        = string
}

variable "private_server_1_id" {
  type        = string
}

variable "private_server_2_id" {
  type        = string
}
