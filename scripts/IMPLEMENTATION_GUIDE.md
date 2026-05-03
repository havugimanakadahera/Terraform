# 🔐 Azure Key Vault Terraform Import Guide

## Problem Recap
Current plan shows: `1 to add, 0 to change, 0 to destroy`  
**Root Cause:** tfvars have placeholder values → Discovery can't find real Key Vault → Import block fails → Terraform tries to create new resource

---

## ✅ Step 1: Discover Your Key Vaults (PowerShell)

Run the discovery script to list all existing Key Vaults:

```powershell
cd d:\Codes\github\BDF\Terraform
..\scripts\discover-keyvaults.ps1
```

**Expected Output:**
```
int Environment:
━━━━━━━━━━━━━━━━━━━━━━
  Name:              kv-int-myapp-01
  Resource Group:    rg-int-keyvault
  Location:          westeurope
  Resource ID:       /subscriptions/.../resourceGroups/rg-int-keyvault/providers/Microsoft.KeyVault/vaults/kv-int-myapp-01

prod Environment:
  Name:              kv-prod-myapp-01
  Resource Group:    rg-prod-keyvault
  Location:          eastus
```

---

## ✅ Step 2: Update tfvars Files

For **each environment**, update `environments/[env].tfvars`:

### Example: environments/int.tfvars

**BEFORE (Placeholder):**
```hcl
name                = "kv-int-app"                    # ← Change this
resource_group_name = "rg-int-vault"                  # ← Change this
```

**AFTER (Real Values):**
```hcl
name                = "kv-int-myapp-01"               # ← Copy from discovery output
resource_group_name = "rg-int-keyvault"               # ← Copy from discovery output
location            = "westeurope"                    # ← Verify matches
```

### Repeat for all environments:
- `environments/qa.tfvars`
- `environments/uat.tfvars`
- `environments/stg.tfvars`
- `environments/prod.tfvars`
- `environments/mir.tfvars`

---

## ✅ Step 3: Validate Configuration

Run terraform validate to check for errors:

```powershell
cd d:\Codes\github\BDF\Terraform
terraform validate -var-file="environments/int.tfvars"
```

**Expected Result:** ✅ `Success! The configuration is valid.`

**If you get errors about 'replace-with':** Go back to Step 2 and update the placeholder values.

---

## ✅ Step 4: Test Plan with Import Validation  

Generate a plan to see the import action:

```powershell
# Clear any old state
rm -Force .terraform -ErrorAction SilentlyContinue

# Initialize and plan
terraform init -backend=false -reconfigure
terraform plan -var-file="environments/int.tfvars" -var="environment=int"
```

**Expected Output (Import Action):**
```
azurerm_key_vault.this will be imported
  id = "/subscriptions/xxx/resourceGroups/rg-int-keyvault/providers/Microsoft.KeyVault/vaults/kv-int-myapp-01"

Plan: 1 to import, 0 to add, 0 to change, 0 to destroy
```

✅ **This is the correct behavior** — import action appears in plan.

---

## ✅ Step 5: Execute Import + Apply

Once plan shows "1 to import":

```powershell
# Create plan file (required for import blocks)
terraform plan -var-file="environments/int.tfvars" -var="environment=int" -out=tfplan

# Review plan (optional auto-approve depends on your setup)
terraform apply tfplan
```

**After apply completes, verify state:**

```powershell
terraform state list
# Should show:
#   data.azurerm_client_config.current
#   module.keyvault.azurerm_key_vault.this
#   ...
```

✅ **If `module.keyvault.azurerm_key_vault.this` appears**, import succeeded!

---

## 🐛 Troubleshooting

### Issue: "replace-with" validation error
```
ERROR: 'name' contains placeholder text. Run: .\scripts\discover-keyvaults.ps1
```
**Fix:** Update tfvars with real values from discovery script output.

### Issue: Plan still shows "1 to add"
```
Terraform will perform the following actions:

  # module.keyvault.azurerm_key_vault.this will be created
  + resource "azurerm_key_vault" "this" {
```
**Cause:** Discovery couldn't find Key Vault with given name.  
**Fix:** 
1. Verify tfvars values match discovery output exactly
2. Run: `terraform output` to see what discovery resolved
3. Check: Does the Key Vault exist in Azure with that name?

### Issue: "Key Vault not found" error
```
Error: retrieving Key Vault: (Name: "kv-int-myapp-01" / Resource Group: "rg-int-keyvault")
```
**Fix:**
1. Verify Key Vault name is spelled correctly (case-sensitive in Azure)
2. Verify you're authenticated to correct Azure subscription
3. Run: `az keyvault list` to confirm Key Vault exists

---

## 🔄 Sequence for All 6 Environments

Once **int** works, repeat Steps 2-5 for remaining environments:

```powershell
# For each environment (qa, uat, stg, prod, mir):
1. Update environments/[env].tfvars with real values
2. terraform plan -var-file="environments/[env].tfvars" -var="environment=[env]"
3. Verify "1 to import" in plan output
4. terraform apply tfplan
5. Verify state contains module.keyvault.azurerm_key_vault.this
```

---

## 📋 Quick Reference: tfvars Structure

All environment files follow this pattern:

```hcl
environment         = "[env]"                         # int|qa|uat|stg|prod|mir
name                = "kv-[env]-app"                  # ← Real Key Vault name from Azure
resource_group_name = "rg-[env]-vault"                # ← Real resource group from Azure
location            = "westeurope" | "eastus" | ...   # ← Must match Key Vault location
enabled_for_disk_encryption = true|false              # ← Optional, default true
soft_delete_retention_days  = 7 | 30 | ...            # ← Optional, default 7
tags = {
  environment = "[env]"
  managed_by  = "terraform"
}
```

---

## ✨ What Happens After Import

Once all 6 environments are imported:

1. **State:** Each module.keyvault.azurerm_key_vault.this contains existing Azure resource
2. **Future Changes:** All modifications go through Terraform (no manual Azure portal changes)
3. **Safety:** `lifecycle { prevent_destroy = true }` blocks accidental deletion
4. **Validation:** Discovery validates location + tenant match on every plan

---

## 🚀 Next Steps

1. **If stuck:** Check Troubleshooting section above
2. **After all 6 imported:** Update pipeline to use remote backend
3. **Backup:** State files are now source-controlled with your infrastructure

