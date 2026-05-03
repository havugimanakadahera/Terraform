# 🎯 Quick Reference: Fix Terraform Import in 4 Commands

## Problem
```
plan : 1 to add, 0 to change, 0 to destroy    ❌ WRONG
```

## Solution
```
plan : 1 to import, 0 to change, 0 to destroy  ✅ CORRECT
```

---

## 4-Command Fix (5 minutes)

### Command 1️⃣  Discover Real Key Vaults
```powershell
cd d:\Codes\github\BDF\Terraform
.\scripts\discover-keyvaults.ps1
```
**Output:** Lists all Key Vaults by environment (int, qa, uat, stg, prod, mir)  
**Copy:** Name and Resource Group for each environment

---

### Command 2️⃣  Edit tfvars with Real Values
```hcl
# Edit: environments/int.tfvars
name                = "kv-int-myapp-01"        # ← From discovery
resource_group_name = "rg-int-vault"           # ← From discovery
location            = "westeurope"             # ← Verify matches
```

**Repeat for:** qa, uat, stg, prod, mir

---

### Command 3️⃣  Validate Before Terraform
```powershell
.\scripts\validate-tfvars.ps1 -Environment int
```
**Expected:** ✅ Validation Passed!  
**If not:** Read error message, fix tfvars

---

### Command 4️⃣  Run Plan & See Import Action
```powershell
terraform init -backend=false -reconfigure
terraform plan -var-file="environments/int.tfvars" -var="environment=int"
```
**Look for:** `Plan: 1 to import, 0 to add, 0 to change, 0 to destroy`  
**If shows "1 to add":** Go back to Command 2, verify tfvars values

---

## Debugging One-Liners

### Check tfvars has no placeholders
```powershell
Select-String "replace-with" environments/*.tfvars
# Should return: (nothing)
```

### List current Key Vaults
```powershell
.\scripts\discover-keyvaults.ps1  # Full output
```

### Test specific environment
```powershell
.\scripts\validate-tfvars.ps1 -Environment qa
.\scripts\validate-tfvars.ps1 -Environment prod
```

### Show what discovery resolved
```powershell
terraform init -backend=false
terraform output  # Shows discovered_keyvault_* values
```

---

## Files to Edit

| File | Change |
|------|--------|
| `environments/int.tfvars` | `name =` and `resource_group_name =` |
| `environments/qa.tfvars` | `name =` and `resource_group_name =` |
| `environments/uat.tfvars` | `name =` and `resource_group_name =` |
| `environments/stg.tfvars` | `name =` and `resource_group_name =` |
| `environments/prod.tfvars` | `name =` and `resource_group_name =` |
| `environments/mir.tfvars` | `name =` and `resource_group_name =` |

All other files are auto-generated and working.

---

## Scripts Available

| Script | Purpose | When to Use |
|--------|---------|------------|
| `discover-keyvaults.ps1` | List Key Vaults in Azure | Before updating tfvars |
| `validate-tfvars.ps1` | Test tfvars before terraform | After updating tfvars, before plan |

---

## Success Indicators

| Step | Indicator | ✅ = OK | ❌ = Problem |
|------|-----------|---------|------------|
| Discovery | Lists Key Vaults | Shows Name, RG, Location | Shows empty or error |
| Validate | Command runs clean | ✅ Validation Passed | ❌ ERROR: placeholder text |
| Plan | Plan output shows action | `1 to import` | `1 to add` |
| Apply | State has resource | `module.keyvault.azurerm_key_vault.this` | Missing or error |

---

## Emergency Troubleshooting

**Q: Still showing "1 to add" after updating tfvars?**  
A: Delete state cache and retry:
```powershell
rm -Force .terraform* -ErrorAction SilentlyContinue
terraform init -backend=false -reconfigure
terraform plan ...
```

**Q: "Key Vault not found"?**  
A: Verify exact name match:
```powershell
az keyvault list --query "[*].name" -o json
# Make sure name in tfvars matches exactly (case-sensitive)
```

**Q: Location mismatch error?**  
A: Check tfvars location:
```powershell
az keyvault show --name <kv-name> --resource-group <rg> --query location
# Match this exact value in tfvars
```

---

## Full Guide vs Quick Card

- **This card**: 4 commands to fix in 5 minutes
- **[IMPLEMENTATION_GUIDE.md](scripts/IMPLEMENTATION_GUIDE.md)**: Full detail with all scenarios
- **[CHANGES_SUMMARY.md](CHANGES_SUMMARY.md)**: What was generated and why

---

## Done? Go to Production

After **int** works perfectly:

```powershell
# Repeat same 4 commands for each environment
foreach ($env in @("qa", "uat", "stg", "prod", "mir")) {
    .\scripts\validate-tfvars.ps1 -Environment $env
    terraform plan -var-file="environments\$env.tfvars" -var="environment=$env"
    # Review plan, then apply
    terraform apply tfplan
}
```

All 6 environments will have their Key Vaults imported into Terraform state ✅

