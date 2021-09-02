resource "gitlab_user" "user" {
  for_each = local.users

  name     = each.value.username
  username = each.value.username
  password = "this_is_A_long_password"
  email    = each.value.email
}

resource "gitlab_group" "group" {
  for_each = local.groups

  name = each.value.name
  path = each.value.name
}

resource "gitlab_group_membership" "group" {
  for_each     = local.group_members
  group_id     = gitlab_group.group[each.value.group].id
  user_id      = gitlab_user.user[each.value.username].id
  access_level = each.value.access_level
}

resource "gitlab_project" "project" {
  for_each = local.projects

  name         = each.value.name
  description  = each.value.description
  namespace_id = gitlab_group.group[each.value.parent].id
}

resource "gitlab_project_membership" "project" {
  for_each     = local.project_members
  project_id   = gitlab_project.project[each.value.project].id
  user_id      = gitlab_user.user[each.value.username].id
  access_level = each.value.access_level
}