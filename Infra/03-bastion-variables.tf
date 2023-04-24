variable "port_sg" {
    description = "Port required to be opened for Bastion servers"
    type = map(string)
    default = {
      "22" = "182.72.157.210/32"
    }
}

variable "bastion-instance-type" {
      type = string
      description = "Instance type for the bastion hosts"
      default = "t3a.medium"
}
  


