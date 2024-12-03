terraform {
  cloud {

    organization = "sst-fiap-soat"

    workspaces {
      name = "sst-lambda"
    }
  }
}