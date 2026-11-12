terraform {
  required_version = ">= 1.11.0"

  backend "s3" {
    bucket               = "terraform-with-github-ab-4821" # CHANGE: your state bucket
    key                  = "terraform.tfstate"              # a plain key: no workspace name here
    workspace_key_prefix = "env"                            # each workspace gets env/<name>/terraform.tfstate
    region               = "eu-central-1"
    encrypt              = true
    use_lockfile         = true # S3 native locking: no DynamoDB table
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "app_bucket" {
  source            = "../../modules/s3_bucket"
  bucket_name       = "al-myapp-${terraform.workspace}-bucket-ab-4821" # CHANGE: your initials and digits
  enable_versioning = false
  tags = {
    env = terraform.workspace
    owner2 = "data-team"
  }
}
