locals {

  team_name = "team1"
  basename = "${local.team_name}"

  default_tags = {
    team = "${local.team_name}"
  }

}