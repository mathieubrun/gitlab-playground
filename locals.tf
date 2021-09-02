locals {
  configuration = yamldecode(file("${path.root}/gitlab.yaml"))

  users = { for t in flatten([
    for user_key, user in local.configuration.users : {
      username = user_key
      email    = user.email
    }
  ]) : t.username => t }

  groups = { for t in flatten([
    for group_key, group in local.configuration.groups : {
      name       = group_key
      developer  = lookup(group, "developer", [])
      maintainer = lookup(group, "maintainer", [])
      key        = group_key
    }
  ]) : t.key => t }

  group_members = { for t in flatten([
    for group_key, group in local.groups : [
      for access_level in ["developer", "maintainer"] : [
        for username in lookup(group, access_level, []) : {
          username     = username
          access_level = access_level
          group        = group_key
          key          = "${group_key}/${access_level}/${username}"
        }
      ]
    ]
  ]) : t.key => t }

  projects = { for t in flatten([
    for group_key, group in local.configuration.projects : [
      for project_key, project in group : {
        name        = project_key
        description = lookup(project, "description", null)
        parent      = group_key
        developer   = lookup(project, "developer", [])
        maintainer  = lookup(project, "maintainer", [])
        key         = "${group_key}/${project_key}"
      }
    ]
  ]) : t.key => t }

  project_members = { for t in flatten([
    for project_key, project in local.projects : [
      for access_level in ["developer", "maintainer"] : [
        for username in lookup(project, access_level, []) : {
          username     = username
          access_level = access_level
          project      = project_key
          key          = "${project_key}/${access_level}/${username}"
        }
      ]
    ]
  ]) : t.key => t }
}
