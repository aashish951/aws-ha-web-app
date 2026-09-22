variable "vpc_id" {
    type = string
  
}

variable "instance_ids" {
    type = list(string)
  
}
variable "env" {
    type = string
  
}
variable "subnet_ids" {
    type = list(string) 
}