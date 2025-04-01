############
# VIP level

# required
variable "vip_name" {
  type        = string
  description = "the name of the VIP/virtual server"
}

variable "vip_destination_ip" {
  type        = string
  description = "target IP that the VIP will listen on"
}

variable "vip_description" {
  type        = string
  description = "vip description (ticket, owner, etc), automatically gets tf- appended"
}

variable "vip_port" {
  type        = number
  description = "the port that the VIP listens on"
}

variable "vip_partition" {
  type        = string
  description = "the partition/namespace inside the F5 device where the VIP lives"
}

# note that I have "vlans_enabled = true" hardcoded in the VIP resource for now, which means they need passed in
variable "vip_enabled_vlans" {
  type        = list(string)
  description = "list of vlans, including partition, on which to enable traffic for VIP listener"
}

# optional
variable "vip_client_profiles_list" {
  type        = list(string)
  default     = ["/Common/clientssl"]
  description = "list of profiles, including partition"
}

variable "vip_server_profiles_list" {
  type        = list(string)
  default     = ["/Common/serverssl"]
  description = "list of profiles, including partition"
}

# Note: If you override this, you MUST include /Common/tcp among the rest of your list. 
# docs: "(Optional) List of profiles associated both client and server contexts 
# on the virtual server. This includes protocol, ssl, http, etc."
variable "vip_profiles_list" {
  type        = list(string)
  default     = ["/Common/tcp"]
  description = "These get applied to both client and server. list of profiles, including partition"
}

variable "vip_sec_log_profiles_list" {
  type        = list(string)
  default     = ["/Common/global-network"]
  description = "list of profiles, including partition"
}

variable "vip_persistence_profiles" {
  type        = list(string)
  default     = ["/Common/source_addr"]
  description = "list of profiles, including partition"
}

variable "vip_source_address_translation" {
  type = string

  validation {
    condition     = contains(["snat", "automap", "none"], var.vip_source_address_translation)
    error_message = "vip_source_address_translation should be one of: snat, automap, none"
  }
  description = "the type of translatio to be used, if any. snat, automap, none"
  default     = "automap"
}

variable "vip_irule_list" {
  type        = list(string)
  default     = ["/Common/Drop-Non-Tufts-Connections"]
  description = "list of irules, including partition"
}

####
# pool level

variable "pool_name" {
  type        = string
  description = "name of the pool, node_listen_port gets automatically appended"
}

variable "pool_description" {
  type        = string
  description = "name of the pool, automatically gets tf- prepended"
}

variable "pool_load_balancing_mode" {
  type        = string
  default     = "round-robin"
  description = "Load balancing mode. Valid values TBD."
}

variable "pool_minimum_active_members" {
  type    = number
  default = 1
}

variable "pool_monitors_list" {
  # docs: "List of monitor names to associate with the pool"
  type        = list(string)
  default     = []
  description = "List of monitor names to associate with the pool"
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
  default     = {}
  description = "object containing the nodes to add to the pool"
}

variable "node_listen_port" {
  type        = number
  description = "the port that the nodes will listen on. Can be different than vip_port."
}

# variable "node_connection_limit" {
#   type = string
#   default = "0"
# }

# variable "node_dynamic_ratio" {
#   type = number
#   default = 1
# }
