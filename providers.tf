terraform {
  required_version = ">=v1.14.3"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.0.0"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket = "infra"
    region = "us-east-1" # This doesnt matter, its cloudflare r2, set by env vars in the .env file
    key    = "dotfiles/terraform.tfstate"

    # Required for Cloudflare R2 compatibility
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

# --------- VAULT ---------

provider "vault" {}

# --------- VULTR ---------

data "vault_generic_secret" "vultr_auth" {
  path = "secret/vultr_auth"
}

provider "vultr" {
  api_key = data.vault_generic_secret.vultr_auth.data["api_key"]
}

data "vault_generic_secret" "ssh" {
  path = "secret/ssh"
}

resource "vultr_ssh_key" "main" {
  name    = "vault-ssh-key"
  ssh_key = data.vault_generic_secret.ssh.data["public_key"]
}

