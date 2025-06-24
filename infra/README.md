# Despliegue de Bases de Datos para Modelos Dimensionales

Este proyecto crea 3 bases de datos separadas en Azure SQL Server para los modelos dimensionales del laboratorio de Business Intelligence.

## 📋 Prerrequisitos

1. **Recursos Azure existentes:**
   - Grupo de recursos: `recursosLabBI` (o el que definas)
   - SQL Server: `serverlabBIU2` (o el que definas)

2. **Herramientas:**
   - Terraform >= 1.1.0
   - Azure CLI
   - Acceso a Azure con permisos para crear bases de datos

## 🚀 Configuración y Despliegue

### 1. Configurar variables

```bash
# Copiar archivo de configuración
cp terraform.tfvars.example terraform.tfvars

# Editar con tus valores
notepad terraform.tfvars
```

### 2. Actualizar tu IP

Obtén tu IP actual en: https://whatismyipaddress.com/ y actualízala en `terraform.tfvars`:

```hcl
my_ip_address = "TU.IP.ACTUAL.AQUI"
```

### 3. Desplegar

```bash
# Inicializar Terraform
terraform init

# Ver el plan de despliegue
terraform plan

# Aplicar cambios
terraform apply
```

## 📊 Bases de Datos Creadas

El script creará estas 3 bases de datos:

| Base de Datos | Propósito | Script SQL |
|---------------|-----------|------------|
| `modelo01_envios` | Modelo dimensional de envíos/shipping | `modelo01.sql` |
| `modelo02_reservas` | Modelo dimensional de reservas de viaje | `modelo02.sql` |
| `modelo03_adicional` | Modelo dimensional adicional | `modelo03.sql` |

## 🔧 Siguientes Pasos

Después del despliegue exitoso:

1. **Conectar a SQL Server:**
   - Server: `[tu-servidor].database.windows.net`
   - Autenticación: SQL Server Authentication

2. **Ejecutar scripts SQL:**
   ```sql
   -- Conectar a modelo01_envios y ejecutar:
   -- contenido de modelo01.sql
   
   -- Conectar a modelo02_reservas y ejecutar:
   -- contenido de modelo02.sql
   
   -- Conectar a modelo03_adicional y ejecutar:
   -- contenido de modelo03.sql
   ```

## 🛠️ Comandos Útiles

### Ver información de despliegue
```bash
terraform output
```

### Ver estado actual
```bash
terraform show
```

### Actualizar solo la regla de firewall (si cambió tu IP)
```bash
terraform apply -target=azurerm_mssql_firewall_rule.allow_my_ip
```

### Limpiar recursos (solo las bases de datos, no el servidor)
```bash
terraform destroy
```

## 🔒 Seguridad

- ✅ Regla de firewall configurada para tu IP específica
- ✅ Acceso permitido para servicios de Azure
- ✅ Uso de recursos existentes (no crea nuevos servidores)
- ✅ Tags aplicados para identificación

## 📋 Estructura del Proyecto

```
infra/
├── main.tf                    # Configuración principal
├── terraform.tfvars.example  # Plantilla de variables
├── terraform.tfvars          # Tu configuración (no versionar)
└── README.md                 # Esta documentación

├── modelo01.sql              # Script para modelo de envíos
├── modelo02.sql              # Script para modelo de reservas  
└── modelo03.sql              # Script para modelo adicional
```

## ❓ Solución de Problemas

### Error: "Resource group not found"
- Verifica que el grupo de recursos existe en Azure
- Actualiza `resource_group_name` en `terraform.tfvars`

### Error: "SQL Server not found"  
- Verifica que el servidor SQL existe
- Actualiza `sql_server_name` en `terraform.tfvars`

### Error de conexión
- Verifica tu dirección IP actual
- Actualiza `my_ip_address` en `terraform.tfvars`
- Ejecuta `terraform apply` nuevamente

### Ver recursos en Azure
```bash
az sql db list --server [servidor] --resource-group [grupo-recursos]
```

## 🎯 Ejemplo de Uso Completo

```bash
# 1. Configurar
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus valores

# 2. Desplegar
terraform init
terraform plan
terraform apply

# 3. Verificar
terraform output

# 4. Conectar y ejecutar scripts SQL en cada BD correspondiente
```

¡Listo para trabajar con tus modelos dimensionales! 🎉
