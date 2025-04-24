# gcc:origin	v2
# gcc:team	gcci
# ec2:ResourceTag:gcc:security:zone	gcci-intranet gcci-internet
# cmp_compartment_type	Intranet Internet
# type	Intranet Internet
variable "IntranetTags" {
  type    = list(string)
  #default = ["cmp_compartment_type-Intranet", "ec2:ResourceTag:gcc:security:zone-gcci-intranet", "type-Intranet", "gcc:team-gcci", "gcc:origin-v2"]
  default = ["cmp_compartment_type_Intranet", "gcc_security_zone_intranet", "type_Intranet", "gcc_team_gcci", "gcc_origin_v2"]
}
variable "InternetTags" {
  type    = list(string)
  default = ["cmp_compartment_type-Internet", "ec2:ResourceTag:gcc:security:zone-gcci-internet", "type-Internet", "gcc:team-gcci", "gcc:origin-v2"]
}
variable "BindTagIntranetSubnet" {
  type    = bool
  default = false
}
variable "BindTagInternetSubnet" {
  type    = bool
  default = false
}
variable "BindManualTagValues" {
  type    = bool
  default = false
}
variable "CreateTags" {
  type    = bool
  default = false
}
variable "MANUAL_SUBNETIDS" {
  type = list(string)
}
variable "MANUAL_TAGVALUES" {
  type = list(string)
}
variable "PROJECT_NUM" {
  type = string
}
variable "MANUAL_PROJECTNUM" {
  type = string
}
variable "INTRANET_SUBNET_IDS" {
  type = list(string)
}
variable "INTERNET_SUBNET_IDS" {
  type = list(string)
}
# variable "tags" {
#   type = map(object({
#     key         = string
#     valuesID    = list(string)
#     description = string
#   }))

#   default = {
#     type = {
#       key         = "type"
#       valuesID    = ["Intranet", "Internet"]
#       description = "gcci managed resource"
#     },
#     "gcc:origin" = {
#       key         = "gcc:origin"
#       valuesID    = ["v2"]
#       description = "gcci managed resource"
#     },
#     "gcc:team" = {
#       key         = "gcc:team"
#       valuesID    = ["gcci"]
#       description = "gcci managed resource"
#     },
#     "ec2:ResourceTag:gcc:security:zone" = {
#       key         = "ec2:ResourceTag:gcc:security:zone"
#       valuesID    = ["gcci-intranet", "gcci-internet"]
#       description = "gcci managed resource"
#     },
#     "cmp_compartment_type" = {
#       key         = "cmp_compartment_type"
#       valuesID    = ["Intranet", "Internet"]
#       description = "gcci managed resource"
#     }

#   }
# }
variable "all_org_tags_grouped" {
  type = map(object({
    intranet_values = list(string)
    internet_values = list(string)
  }))
  default = {
    "cmp_compartment_type" = {
      intranet_values = ["Intranet"],
      internet_values = ["Internet"]
    },
    "ec2:ResourceTag:gcc:security:zone" = {
      intranet_values = ["gcci-intranet"],
      internet_values = ["gcci-internet"]
    },
    "gcc:origin" = {
      intranet_values = ["v2"],
      internet_values = ["v2"]
    },
    "gcc:team" = {
      intranet_values = ["gcci"],
      internet_values = ["gcci"]
    },
    "type" = {
      intranet_values = ["Intranet"],
      internet_values = ["Internet"]
    }
  }
}

variable "PROJECT_ID" {
  type = string
}

# 1. Organization
data "google_organization" "org" {
  organization = 433106239226
}

# 2. Fetch Tag Keys
data "google_tags_tag_key" "existing_keys" {
  for_each = var.all_org_tags_grouped
  parent   = data.google_organization.org.id
  short_name     = each.key
}

# 3. Fetch Tag Values based on subnet_type
data "google_tags_tag_value" "selected_values" {
  for_each = {
    for item in flatten([
      for tag_key, values in var.all_org_tags_grouped : [
        for value_name in (var.BindTagIntranetSubnet ? values.intranet_values : values.internet_values) : {
          key_name   = tag_key
          value_name = value_name
          combined_key = "${tag_key}-${value_name}"
        }
      ]
    ]) : item.combined_key => item
  }
  parent = data.google_tags_tag_key.existing_keys[each.value.key_name].id
  short_name  = each.value.value_name
}

