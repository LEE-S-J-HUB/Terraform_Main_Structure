terraform {
    required_providers {
      aws = {
          version = "~>4.10"
      }
    }
    backend "s3" {
        bucket  = "s3-an2-lsj-dev-terraform"
        key     = "tra01/01-local.tfstate"
        region = "ap-northeast-2"
        encrypt = true
    }
}

provider "aws" {
    profile = "default"
    region  = "ap-northeast-2"
}