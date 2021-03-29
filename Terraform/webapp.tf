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

resource "azurerm_app_service" "dev" {
  name                = "__appservicename__"
  location            = "Central US"
  resource_group_name = "appdbwebtest"
  app_service_plan_id = "${azurerm_app_service_plan.dev.id}"

}
