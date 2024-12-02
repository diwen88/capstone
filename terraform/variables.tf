variable "env" {
  description = "Environment name (e.g., dev, prod, staging)"
  type        = string
  default     = "dev"
}

variable "ec2_instance_type" {
    description = "EC2 instance type"
    default = "t3.micro"
}

variable "key_name" {
  description = "SSH key name"
  default = "vockey"
}

variable "ami_amz_l2" {
  description = "AWS Linux 2 AMI"
  default = "ami-0da6920932ded1a86"
}