# gcc:origin	v2
# gcc:team	gcci
# ec2:ResourceTag:gcc:security:zone	gcci-intranet gcci-internet
# cmp_compartment_type	Intranet Internet
# type	Intranet Internet
variable "IntranetTags" {
  type    = list(string)
  default = ["cmp_compartment_type-Intranet", "ec2:ResourceTag:gcc:security:zone-gcci-intranet", "type-Intranet", "gcc:team-gcci", "gcc:origin-v2"]
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
variable "tags" {
  type = map(object({
    key         = string
    valuesID    = list(string)
    description = string
  }))

  default = {
    type = {
      key         = "type"
      valuesID    = ["Intranet", "Internet"]
      description = "gcci managed resource"
    },
    "gcc:origin" = {
      key         = "gcc:origin"
      valuesID    = ["v2"]
      description = "gcci managed resource"
    },
    "gcc:team" = {
      key         = "gcc:team"
      valuesID    = ["gcci"]
      description = "gcci managed resource"
    },
    "ec2:ResourceTag:gcc:security:zone" = {
      key         = "ec2:ResourceTag:gcc:security:zone"
      valuesID    = ["gcci-intranet", "gcci-internet"]
      description = "gcci managed resource"
    },
    "cmp_compartment_type" = {
      key         = "cmp_compartment_type"
      valuesID    = ["Intranet", "Internet"]
      description = "gcci managed resource"
    }

  }
}


variable "PROJECT_ID" {
  type = string
}