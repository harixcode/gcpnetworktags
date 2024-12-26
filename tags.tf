#flatten key and values
locals {
  #Proceed only if CreateTags is true
  flattened_tags = var.CreateTags == true ? flatten([
    for key, values in var.tags : [
      for v in values.valuesID : {
        key         = key
        valueID     = v
        description = values.description
        parentID    = google_tags_tag_key.tag_keys[key].id
      }
    ]
  ]) : []
}
resource "google_tags_tag_key" "tag_keys" {
  #for_each = var.tags if var.CreateTags
  #Proceed only if CreateTags is true
  for_each = { for k, v in var.tags : k => v if var.CreateTags }

  parent      = "projects/${var.PROJECT_ID}"
  short_name  = each.key
  description = each.value.description
}


resource "google_tags_tag_value" "tag_values" {
  for_each = {
    for tag in local.flattened_tags : "${tag.key}-${tag.valueID}" => tag if var.CreateTags #Proceed only if CreateTags is true
  }

  parent     = each.value.parentID
  short_name = each.value.valueID

  #description = each.value.description
}