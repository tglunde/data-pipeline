terraform {
  # Version of Terraform to include in the bundle. An exact version number
  # is required.
  version = "0.12.0"
}

# Define which provider plugins are to be included
providers {
  # Include the newest "aws" provider version in the 1.0 series.
  aws = ["~> 2.20.0"]


}
