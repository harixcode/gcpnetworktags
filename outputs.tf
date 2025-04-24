# Output the applied Tag Bindings on the Project
output "applied_project_intranet_tag_bindings" {
  value = google_tags_location_tag_binding.IntranetBinding
  description = "The Tag Bindings applied to the project based on subnet_type"
}

output "applied_project_intranet_tag_values" {
  value = [for binding in google_tags_location_tag_binding.IntranetBinding : binding.tag_value]
  description = "List of namespaced names of the Tag Values applied to the project"
}

output "applied_project_internet_tag_bindings" {
  value = google_tags_location_tag_binding.InternetBinding
  description = "The Tag Bindings applied to the project based on subnet_type"
}

output "applied_project_internet_tag_values" {
  value = [for binding in google_tags_location_tag_binding.InternetBinding : binding.tag_value]
  description = "List of namespaced names of the Tag Values applied to the project"
}
# output the tag data fetched from org
# output "selected_tag_values" {
#   value = data.google_tags_tag_value.selected_values
# }