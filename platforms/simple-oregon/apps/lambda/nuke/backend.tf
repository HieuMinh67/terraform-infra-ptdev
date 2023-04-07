terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = var.organisation

    workspaces {
      name = "ptdev-simple-oregon-apps-lambda-nuke"
    }
  }
}
