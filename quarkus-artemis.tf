# Create repository
resource "github_repository" "quarkus_artemis" {
  name                   = "quarkus-artemis"
  description            = "Quarkus Artemis extensions"
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
resource "github_team" "quarkus_artemis" {
  name                      = "quarkiverse-artemis"
  description               = "Quarkiverse team for the Artemis extensions"
  create_default_maintainer = false
  privacy                   = "closed"
  parent_team_id            = data.github_team.quarkiverse_members.id
}

# Add team to repository
resource "github_team_repository" "quarkus_artemis" {
  team_id    = github_team.quarkus_artemis.id
  repository = github_repository.quarkus_artemis.name
  permission = "maintain"
}

# Add users to the team
resource "github_team_membership" "quarkus_artemis" {
  for_each = { for tm in ["middagj"] : tm => tm }
  team_id  = github_team.quarkus_artemis.id
  username = each.value
  role     = "maintainer"
}
