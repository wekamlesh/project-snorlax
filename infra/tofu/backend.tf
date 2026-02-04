terraform {
  backend "s3" {
    bucket                      = "snorlax-tofu-state"
    key                         = "tofu/state/terraform.tfstate"
    region                      = "auto"
    endpoint                    = "https://c03dbc6f7e1be2187be646fd35be1ea2.r2.cloudflarestorage.com"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}
