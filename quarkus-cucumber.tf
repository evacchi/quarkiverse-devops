# Create repository
resource "github_repository" "quarkus_cucumber" {
  name                   = "quarkus-cucumber"
  description            = "Quarkus Cucumber extension"
  delete_branch_on_merge = true
  has_issues             = true
  vulnerability_alerts   = true
  topics                 = ["quarkus-extension"]
  lifecycle {
    ignore_changes = [
      # Workaround for integrations/terraform-provider-github#1037.
      branches,
    ]
  }
}

# Create team
resource "github_team" "quarkus_cucumber" {
  name                      = "quarkiverse-cucumber"
  description               = "Quarkiverse team for the Cucumber extension"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_cucumber" {
  team_id    = github_team.quarkus_cucumber.id
  repository = github_repository.quarkus_cucumber.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_cucumber" {
  for_each = { for tm in ["stuartwdouglas", "christophd"] : tm => tm }
  team_id  = github_team.quarkus_cucumber.id
  username = each.value
  role     = "maintainer"
}

# Create main branch
resource "github_branch" "quarkus_cucumber" {
  repository = github_repository.quarkus_cucumber.name
  branch     = "main"
}

# Set default branch
resource "github_branch_default" "quarkus_cucumber" {
  repository = github_repository.quarkus_cucumber.name
  branch     = github_branch.quarkus_cucumber.branch
}