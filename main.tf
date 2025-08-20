terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "6babc3f8-793c-4200-9aa3-51e8d33ff572"
  client_id       = "c421e394-9c7d-43f8-9b93-76ea734b2afb"
  client_secret   = "vD18Q~yQD-6QLeTvTNP5Kh9-BSdElQpEPCdD6anY"
  tenant_id       = "7597b8dc-1559-4285-901d-856b7ac20009"
}

variable "budget_name" {
  default = "vmss-budget-alert"
}

variable "budget_amount" {
  default = 100 # Budget in USD
}

variable "time_grain" {
  default = "Monthly"
}

variable "contact_email" {
  default = "prashanthgowda0026@gmail.com"
}

resource "azurerm_consumption_budget_subscription" "vmss_budget" {
  name            = var.budget_name
  subscription_id = "/subscriptions/6babc3f8-793c-4200-9aa3-51e8d33ff572"
  amount          = var.budget_amount
  time_grain      = var.time_grain

  time_period {
    start_date = "${formatdate("YYYY-MM-01", timestamp())}T00:00:00Z"
  }

  notification {
    enabled        = true
    operator       = "GreaterThanOrEqualTo"
    threshold      = 80
    threshold_type = "Actual"
    contact_emails = [var.contact_email]
  }
}
