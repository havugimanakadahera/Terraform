# Terraform — Azure State Rebuild (Import)

Manages existing Azure infrastructure across **6 environments** by rebuilding
Terraform state without destroying or recreating resources.

---

## Repository structure

```
terraform-public/
│
├── main.tf                   # Root: calls all modules
├── imports.tf                # Root: import blocks (ONE-TIME per env)
├── outputs.tf                # Root: surfaces module outputs
├── variables.tf              # Root: all input variables
├── providers.tf              # AzureRM provider + client config data source
├── versions.tf               # Terraform + provider version constraints
│
├── environments/             # Per-environment variable files
│   ├── int.tfvars
│   ├── qa.tfvars
│   ├── uat.tfvars
│   ├── stg.tfvars
│   ├── prod.tfvars
│   └── mir.tfvars
│
├── modules/
│   └── keyvault/
│       ├── main.tf           # Resource declaration only
│       ├── discovery.tf      # Data lookup + check assertions
│       ├── variables.tf      # Module inputs
│       └── outputs.tf        # Discovered ID + debug values
│
├── pipelines/
│   └── templates/
│       └── job-import.yml    # Reusable job: bootstrap → init → import → drift gate
│
├── azure-pipelines.yml       # Multi-env pipeline (one stage per environment)
│
└── scripts/
    └── discover-keyvault-id.sh  # Optional: Azure CLI fallback for manual checks
```

---

## How the import flow works

```
Pipeline stage (per env)
        │
        ▼
1. Bootstrap backend    ← az cli: creates RG + storage account + container if missing
        │
        ▼
2. terraform init       ← connects to per-env remote state key (<env>.tfstate)
        │
        ▼
3. terraform validate   ← syntax + provider schema check
        │
        ▼
4. terraform apply      ← import_existing=true
   │                       │
   │  modules/keyvault/    │
   │  discovery.tf reads ──┘── az keyvault data source (name + resource_group_name)
   │                            → resolves existing Azure resource ID
   │                            → validates location and tenant_id
   │
   │  imports.tf maps ─────── discovered ID → module.keyvault.azurerm_key_vault.key_vault
   │
   └─► State rebuilt. No resource is destroyed or recreated.
        │
        ▼
5. terraform plan       ← import_existing=false (import blocks inactive)
   Drift gate: must return exit code 0 (no changes).
   If exit code 2 → config differs from Azure reality → pipeline FAILS.
        │
        ▼
6. terraform state list ← confirms all expected addresses in state
```

---

## Environments and variable groups

| Environment | tfvars file             | DevOps variable group |
|-------------|-------------------------|-----------------------|
| int         | environments/int.tfvars | tf-int                |
| qa          | environments/qa.tfvars  | tf-qa                 |
| uat         | environments/uat.tfvars | tf-uat                |
| stg         | environments/stg.tfvars | tf-stg                |
| prod        | environments/prod.tfvars| tf-prod               |
| mir         | environments/mir.tfvars | tf-mir                |

Each variable group must contain:

| Variable                | Description                                    |
|-------------------------|------------------------------------------------|
| `TFSTATE_RESOURCE_GROUP`  | Resource group for the backend storage account |
| `TFSTATE_LOCATION`        | Azure region for backend resources             |
| `TFSTATE_STORAGE_ACCOUNT` | Storage account name for tfstate files         |
| `TFSTATE_CONTAINER`       | Blob container name                            |

---

## Setup checklist

- [ ] Fill real values in each `environments/<env>.tfvars` (name, location, resource_group_name)
- [ ] Create one DevOps variable group per environment (see table above)
- [ ] Set your service connection name in `azure-pipelines.yml` (`azureServiceConnection`)
- [ ] Run pipeline for `int` first, then promote sequentially

---

## Import lifecycle (important)

| Phase                 | `import_existing` | What happens                          |
|-----------------------|-------------------|---------------------------------------|
| First run (per env)   | `true`            | Import blocks active — state rebuilt  |
| All subsequent runs   | `false`           | Import blocks inactive — normal apply |

The pipeline passes `import_existing=true` only during the import apply step
and then re-runs plan with `import_existing=false` as the drift gate.

---

## Module: keyvault

| File           | Purpose                                              |
|----------------|------------------------------------------------------|
| `main.tf`      | `azurerm_key_vault` resource — what Terraform manages|
| `discovery.tf` | Reads existing Key Vault from Azure by name + RG     |
|                | Validates location (space/case normalized) and tenant|
| `variables.tf` | Module inputs                                        |
| `outputs.tf`   | Exposes discovered ID + location + tenant values     |

### Dynamic ID resolution

The existing Key Vault is found using:
- `name = var.name`
- `resource_group_name = var.resource_group_name`

And validated against:
- `location = var.location` (normalized: `West Europe` == `westeurope`)
- `tenant_id = data.azurerm_client_config.current.tenant_id`

---

## Extending to additional resource types

For each new resource type, apply the same pattern:

1. Create `modules/<resource>/main.tf` — resource declaration
2. Create `modules/<resource>/discovery.tf` — data lookup + check assertions
3. Create `modules/<resource>/variables.tf` and `outputs.tf`
4. Call the module from root `main.tf`
5. Add import block in root `imports.tf` targeting `module.<resource>.<type>.<name>`

