 terraform {
  required_version = ">= 0.11" 
 backend "azurerm" {
  storage_account_name = "__terraformstorageaccount__"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
	access_key  ="__storagekey__"
  features{}
	}
	}
  provider "azurerm" {
    version = "=2.0.0"
features {}
}
//resource "azurerm_resource_group" "dev" {
 // name     = "appdbwebtest"
  //location = "Central US"
  //tags = {
   // environment = "dev"
   // createdby="poorani"
    //modeofdeployment= "azurecicd"
  //}*/

//}

resource "azurerm_app_service_plan" "dev" {
  name                = "__appserviceplan__"
  location            = "Central US"
	//"${azurerm_resource_group.dev.location}"
  resource_group_name = "appdbwebtest"
	//"${azurerm_resource_group.dev.name}"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_application_insights" "example" {
  name                = "__appinsights__"
  location            = azurerm_app_service_plan.dev.location
  resource_group_name = azurerm_app_service_plan.dev.resource_group_name
  application_type    = "web"
}

resource "azurerm_app_service" "dev" {
  name                = "__appservicename__"
  location            = "Central US"
  resource_group_name = "appdbwebtest"
  app_service_plan_id = "${azurerm_app_service_plan.dev.id}"
  depends_on = [azurerm_app_service_plan.dev , azurerm_monitor_autoscale_setting.asplan1]
app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.example.instrumentation_key}"
  }
	  

}



resource "azurerm_monitor_autoscale_setting" "asplan1" {
  name                ="__azuremonitor__"
  resource_group_name = azurerm_app_service_plan.dev.resource_group_name
  location            =  azurerm_app_service_plan.dev.location
  target_resource_id  = azurerm_app_service_plan.dev.id

  profile {
    name = "default"

    capacity {
      default = 1
      minimum = 1
      maximum = 2
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.dev.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        //threshold          = var.cpuUpperThreshold
	      threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_app_service_plan.dev.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT15M"
      }
    }
  }

  notification {
    email {
      send_to_subscription_administrator    = false
      send_to_subscription_co_administrator = false
      custom_emails                         = "poorani.kamalakannan@allianzlife.com;sampath.palanisamy@allianzlife.com"
    }
  }
  depends_on = [azurerm_app_service_plan.dev]
}

