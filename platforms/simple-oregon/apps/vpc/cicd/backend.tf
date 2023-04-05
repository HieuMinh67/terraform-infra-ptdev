terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "HieuMinh67"

    workspaces {
      name = "ptdev-simple-oregon-apps-vpc-cicd"
    }
  }
}
