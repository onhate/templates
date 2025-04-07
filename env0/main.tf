terraform {
  required_providers {
    env0 = {
      source = "env0/env0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "random" {

}

provider "env0" {
  api_endpoint    = "https://api-pr18719.dev.env0.com"
  api_key         = "uml4kspesgao7nuk"
  api_secret      = "dT5TjLtmk7zjiK6UWYRuvRX5ImUJwxvM"
  organization_id = "9bf6f8b6-e3dc-47a7-a627-59748712a33f"
}

resource "random_pet" "random" {
  length = 3
}

data "env0_project" "project" {
  name = "My First Project"
}

resource "env0_template" "null_resource" {
  name             = "null resource"
  type             = "opentofu"
  repository       = "https://github.com/onhate/templates"
  path             = "misc/null-resource"
  opentofu_version = "latest"
}

resource "env0_template_project_assignment" "null_resource_assignment" {
  template_id = env0_template.null_resource.id
  project_id  = data.env0_project.project.id
}

resource "env0_template" "workflow_template" {
  depends_on = [env0_template.null_resource, env0_template_project_assignment.null_resource_assignment]

  name             = "template-${random_pet.random.id}"
  type             = "workflow"
  repository       = "https://github.com/onhate/templates"
  path             = "misc/single-environment-workflow"
  opentofu_version = "latest"
}

resource "env0_template_project_assignment" "workflow_template_assignment" {
  template_id = env0_template.workflow_template.id
  project_id  = data.env0_project.project.id
}

resource "env0_environment" "workflow_environment" {
  depends_on = [env0_template.workflow_template, env0_template_project_assignment.workflow_template_assignment]

  force_destroy = true
  name          = "environment-${random_pet.random.id}"
  project_id    = data.env0_project.project.id
  template_id   = env0_template.workflow_template.id

  configuration {
    name  = "root_env1_var1"
    value = "root_env1_var1_value"
  }
  configuration {
    name  = "root_env1_var2"
    value = "root_env1_var2_value"
  }

  sub_environment_configuration {
    alias                      = "rootService1"
    approve_plan_automatically = true
    configuration {
      name  = "sub_env1_var1"
      value = "sub_env1_var1_value"
    }
    configuration {
      name  = "sub_env1_var2"
      value = "sub_env1_var2_value"
    }
  }
}

