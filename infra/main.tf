terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Variables para configuración
variable "resource_group_name" {
  description = "Nombre del grupo de recursos existente"
  type        = string
  default     = "recursosLab03"
}

variable "sql_server_name" {
  description = "Nombre del servidor SQL existente"
  type        = string
  default     = "serverlab03"
}

variable "my_ip_address" {
  description = "Tu dirección IP para reglas de firewall"
  type        = string
  default     = "38.250.158.179"  # Tu IP actual
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "lab"
}

# Referenciamos el grupo de recursos ya existente (o lo creamos si no existe)
data "azurerm_resource_group" "lab_rg" {
  name = var.resource_group_name
}

# Referenciamos el servidor SQL ya existente (o lo creamos si no existe)
data "azurerm_mssql_server" "lab_server" {
  name                = var.sql_server_name
  resource_group_name = data.azurerm_resource_group.lab_rg.name
}

# Base de datos para Modelo 01 - Envíos (Shipping)
resource "azurerm_mssql_database" "modelo01" {
  name      = "modelo01_envios"
  server_id = data.azurerm_mssql_server.lab_server.id
  sku_name  = "Basic"
  
  tags = {
    Environment = var.environment
    Model       = "Envios"
    Purpose     = "Dimensional-Model-Shipping"
    Lab         = "BI-U2-01"
  }
}

# Base de datos para Modelo 02 - Reservas de Viaje (Travel Reservations)
resource "azurerm_mssql_database" "modelo02" {
  name      = "modelo02_reservas"
  server_id = data.azurerm_mssql_server.lab_server.id
  sku_name  = "Basic"
  
  tags = {
    Environment = var.environment
    Model       = "Reservas"
    Purpose     = "Dimensional-Model-Travel"
    Lab         = "BI-U2-01"
  }
}

# Base de datos para Modelo 03 - Modelo adicional
resource "azurerm_mssql_database" "modelo03" {
  name      = "modelo03_adicional"
  server_id = data.azurerm_mssql_server.lab_server.id
  sku_name  = "Basic"
  
  tags = {
    Environment = var.environment
    Model       = "Adicional"
    Purpose     = "Dimensional-Model-Extra"
    Lab         = "BI-U2-01"
  }
}

# Regla de firewall para permitir tu IP
resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = data.azurerm_mssql_server.lab_server.id
  start_ip_address = var.my_ip_address
  end_ip_address   = var.my_ip_address
}

# Regla de firewall para permitir servicios de Azure
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = data.azurerm_mssql_server.lab_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Outputs para información de conexión
output "server_info" {
  description = "Información del servidor SQL"
  value = {
    name = data.azurerm_mssql_server.lab_server.name
    fqdn = data.azurerm_mssql_server.lab_server.fully_qualified_domain_name
  }
}

output "databases" {
  description = "Información de las bases de datos creadas"
  value = {
    modelo01 = {
      name = azurerm_mssql_database.modelo01.name
      id   = azurerm_mssql_database.modelo01.id
    }
    modelo02 = {
      name = azurerm_mssql_database.modelo02.name
      id   = azurerm_mssql_database.modelo02.id
    }
    modelo03 = {
      name = azurerm_mssql_database.modelo03.name
      id   = azurerm_mssql_database.modelo03.id
    }
  }
}

output "connection_instructions" {
  description = "Instrucciones de conexión"
  value = <<-EOT
    
    🎯 BASES DE DATOS CREADAS EXITOSAMENTE:
    
    📊 Servidor: ${data.azurerm_mssql_server.lab_server.fully_qualified_domain_name}
    
    📦 Bases de Datos:
    ├── ${azurerm_mssql_database.modelo01.name} (Modelo de Envíos)
    ├── ${azurerm_mssql_database.modelo02.name} (Modelo de Reservas)
    └── ${azurerm_mssql_database.modelo03.name} (Modelo Adicional)
    
    🔧 Siguientes pasos:
    1. Ejecutar modelo01.sql en la BD: ${azurerm_mssql_database.modelo01.name}
    2. Ejecutar modelo02.sql en la BD: ${azurerm_mssql_database.modelo02.name}
    3. Ejecutar modelo03.sql en la BD: ${azurerm_mssql_database.modelo03.name}
    
    🔐 Configuración de firewall aplicada para IP: ${var.my_ip_address}
    
  EOT
}