variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type = string
  default = "udacity-c01"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created"
  type = string
  default = "ukwest"
}

variable "username" {
  description = "VM admin username"
  type = string
  default = "azureuser"
}

variable "tags" {
  description = "Map of the tags to use for the resources that are deployed"
  type = map(string)
  default = {
    udacity = "udacity"
  }
}

variable "application_port" {
  description = "Port that you want to expose to the external load balancer"
  type = number
  default = 80
}

variable "image_resource_group_name" {
  description = "Packer image resource group name"
  type = string
  default = "packer-rg"
}

variable "image_name" {
  description = "Packer image name"
  type = string
  default = "c01-image"
}

variable "vm_count" {
  description = "The number of VMs to be created"
  type = number
  default = 1
}
