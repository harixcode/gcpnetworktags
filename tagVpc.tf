locals {
  # flatten ensures that this local value is a flat list of objects, rather
  # than a list of lists of objects.
  # proceed = var.INTRANET_SUBNET_ID != "" ? false :true
  flattenIntranetSubnet = var.BindTagIntranetSubnet == true ? flatten([
    for subnetID in toset(var.INTRANET_SUBNET_IDS) : [
      for tag in var.IntranetTags : {
        subnetID  = subnetID
        tag       = tag
        parentID  = "//compute.googleapis.com/projects/${var.PROJECT_NUM}/regions/asia-southeast1/subnetworks/${subnetID}"
        tag_value = google_tags_tag_value.tag_values["${tag}"].id
      }
    ]
  ]) : []
  flattenInternetSubnet = var.BindTagInternetSubnet == true ? flatten([
    for subnetID in toset(var.INTERNET_SUBNET_IDS) : [
      for tag in var.InternetTags : {
        subnetID  = subnetID
        tag       = tag
        parentID  = "//compute.googleapis.com/projects/${var.PROJECT_NUM}/regions/asia-southeast1/subnetworks/${subnetID}"
        tag_value = google_tags_tag_value.tag_values["${tag}"].id
      }
    ]
  ]) : []
  flattenManualTags = var.BindManualTagValues == true ? flatten([
    for subnetID in toset(var.MANUAL_SUBNETIDS) : [
      for tag in var.MANUAL_TAGVALUES : {
        subnetID  = subnetID
        tag       = tag
        parentID  = "//compute.googleapis.com/projects/${var.MANUAL_PROJECTNUM}/regions/asia-southeast1/subnetworks/${subnetID}"
        tag_value = "${tag}"
      }
    ]
  ]) : []
}

resource "google_tags_location_tag_binding" "IntranetBinding" {
  # for_each = toset(var.IntranetTags)
  for_each = {
    for tags in local.flattenIntranetSubnet : "${tags.tag}-${tags.subnetID}" => tags if var.BindTagIntranetSubnet
  }
  parent    = each.value.parentID
  tag_value = each.value.tag_value
  location  = "asia-southeast1"
  depends_on = [
    google_tags_tag_value.tag_values
  ]
}

resource "google_tags_location_tag_binding" "InternetBinding" {
  # for_each = toset(var.IntranetTags)
  for_each = {
    for tags in local.flattenInternetSubnet : "${tags.tag}-${tags.subnetID}" => tags if var.BindTagInternetSubnet
  }
  parent    = each.value.parentID
  tag_value = each.value.tag_value
  location  = "asia-southeast1"
  depends_on = [
    google_tags_tag_value.tag_values
  ]
}

resource "google_tags_location_tag_binding" "ManualTagging" {
  # for_each = toset(var.IntranetTags)
  for_each = {
    for tags in local.flattenManualTags : "${tags.tag}-${tags.subnetID}" => tags if var.BindManualTagValues
  }
  parent    = each.value.parentID
  tag_value = each.value.tag_value
  location  = "asia-southeast1"
}