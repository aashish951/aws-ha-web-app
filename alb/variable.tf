variable "vpc_id" {
    type = string
  
}

variable "instance_id" {
    type = string
  
}
variable "env" {
    type = string
  
}
variable "subnet_ids" {
    type = list(string) 
}