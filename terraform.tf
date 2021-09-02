provider "gitlab" {
  base_url = "http://localhost:8929"
}

terraform {
  required_version = "~> 0.14"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "~> 3.6"
    }
  }
}
