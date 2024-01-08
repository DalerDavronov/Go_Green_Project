variable "ami" {
  type        = string
  default     = "ami-0e534e4c6bae7faf7"
}
variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
variable "prefix" {
  type    = string
  default = "default"
}
variable "groups" {
  type        = list(string)
  default     = []
  description = "List of group names for Terraform create, case create_groups variable be true"
}

variable "users" {
  type        = map(any)
  default     = {}
  description = "Map for Terraform create users."

}

variable "create_groups" {
  type        = bool
  default     = false
  description = "Define if Terraform will create new_groups based on variable groups ."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for all resources."
}