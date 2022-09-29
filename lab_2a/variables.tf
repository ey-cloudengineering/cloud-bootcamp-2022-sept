variable "resource_group_name" {
  description = "The name of your individual resource group name"
  default = "< your variable >"
}

variable "location" {
  description = "The Azure Region for the lab. This can be left default."
  default = "australiaeast"
}

variable "name" {
  description = "Enter your initials here"
  default = "< your variable >"
}

variable "subnet_allocated" {
  description = "enter your subnet according to the subnet allocation chart"
  default = "< your variable >"
}
