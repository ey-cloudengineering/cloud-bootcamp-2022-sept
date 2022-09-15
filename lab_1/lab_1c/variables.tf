variable "resource_group_name" {
  description = "The name of your individual resource group name"
  default = "< your variable >"
}

variable "location" {
  description = "The Azure Region for the lab. This can be left default."
  default = "<LAB 1A AZURE REGION CODE>"
}

variable "admin_username" {
  description = "Username to login to lab VM"
  default = "< your variable >"
}

variable "admin_password" {
  description = "Password to lab VM"
  default = "< your variable >"
}

variable "name" {
  description = "Enter your initials-c101 here"
  default = " < your variable > "
}

variable "subnet_id" {
  description = "vNet Subnet to use"
  default = "<supplied subnet id>"
}

variable "number_of_vm" {
  description = "Enter the number of VM's to create"
  default = 2
}
