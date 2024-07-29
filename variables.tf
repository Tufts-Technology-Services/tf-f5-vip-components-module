############
# VIP level

# required
variable "vip_name" {
  type = string
}

variable "vip_destination_ip" {
  type = string
}

variable "vip_description" {
  type = string
}

variable "vip_port" {
  type = number
}

variable "vip_partition" {
  type = string
}

# note that I have "vlans_enabled = true" hardcoded in the VIP resource for now, which means they need passed in
variable "vip_enabled_vlans" {
  type = list(string)
}

# optional
variable "vip_client_profiles_list" {
  type    = list(string)
  default = ["/Common/clientssl"]
}

variable "vip_server_profiles_list" {
  type    = list(string)
  default = ["/Common/serverssl"]
}

variable "vip_sec_log_profiles_list" {
  type    = list(string)
  default = ["/Common/global-network"]
}

variable "vip_source_address_translation" {
  type = string

  validation {
    condition     = contains(["snat", "automap", "none"], var.vip_source_address_translation)
    error_message = "vip_source_address_translation should be one of: snat, automap, none"
  }

  default = "automap"
}

variable "vip_irule_list" {
  type    = list(string)
  default = ["/Common/Drop-Non-Tufts-Connections"]
}

####
# pool level

variable "pool_name" {
  type = string
}

variable "pool_description" {
  type = string
}

variable "pool_load_balancing_mode" {
  type    = string
  default = "round-robin"
}

variable "pool_minimum_active_members" {
  type    = number
  default = 1
}

variable "pool_monitors_list" {
  # no idea if these are meant to be strings or ids or what
  type = list(string)
}

####
# node level

variable "node_map" {
  type = map(object({
    name        = string,
    description = string,
    address     = string,
    pool_state  = string,
  }))
  default = {}
}

variable "node_listen_port" {
  type = number
}

# variable "node_connection_limit" {
#   type = string
#   default = "0"
# }

# variable "node_dynamic_ratio" {
#   type = number
#   default = 1
# }
