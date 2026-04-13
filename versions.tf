terraform {
  # 1.7.0+ is required: import blocks support for_each from this version.
  required_version = ">= 1.7.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.114"
    }
  }

  backend "azurerm" {}
}
