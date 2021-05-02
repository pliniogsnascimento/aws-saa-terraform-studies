locals {
  ec2_user_data = "echo \"It was not possible to execute ec2 user data\" > /home/log.txt"
}