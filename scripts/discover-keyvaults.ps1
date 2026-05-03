# PowerShell Script: Discover existing Azure Key Vaults
# This script lists all Key Vaults in your Azure subscription
# Use this to populate the environment tfvars files with real values

param(
    [string]$SubscriptionId = ""
)

Write-Host "🔍 Discovering Azure Key Vaults..." -ForegroundColor Cyan

# Set subscription if provided
if ($SubscriptionId) {
    Write-Host "Setting subscription to: $SubscriptionId" -ForegroundColor Yellow
    az account set --subscription $SubscriptionId
} else {
    $current = az account show --query 'id' -o tsv
    Write-Host "Using current subscription: $current" -ForegroundColor Yellow
}

Write-Host "`n" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  Azure Key Vaults by Environment Pattern      " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Query all Key Vaults
$keyvaults = az keyvault list --query '[*].[name, resourceGroup, location, id]' -o tsv

if (-not $keyvaults) {
    Write-Host "`n❌ No Key Vaults found in subscription" -ForegroundColor Red
    exit 1
}

# Parse and display results grouped by environment
$environments = @{}

$keyvaults | ForEach-Object {
    $parts = $_ -split "`t"
    if ($parts.Count -ge 3) {
        $name = $parts[0]
        $rg = $parts[1]
        $location = $parts[2]
        $id = $parts[3]
        
        # Infer environment from name (e.g., kv-int-app, kv-prod-app)
        $env = "unknown"
        if ($name -match '-int-') { $env = "int" }
        elseif ($name -match '-qa-') { $env = "qa" }
        elseif ($name -match '-uat-') { $env = "uat" }
        elseif ($name -match '-stg-') { $env = "stg" }
        elseif ($name -match '-prod-') { $env = "prod" }
        elseif ($name -match '-mir-') { $env = "mir" }
        
        if (-not $environments[$env]) {
            $environments[$env] = @()
        }
        
        $environments[$env] += @{
            name = $name
            rg = $rg
            location = $location
            id = $id
        }
    }
}

# Display grouped by environment
$environments.Keys | Sort-Object | ForEach-Object {
    $env = $_
    Write-Host "`n$env Environment:" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Gray
    
    $environments[$env] | ForEach-Object {
        Write-Host "  Name:              $($_.name)" -ForegroundColor White
        Write-Host "  Resource Group:    $($_.rg)" -ForegroundColor White
        Write-Host "  Location:          $($_.location)" -ForegroundColor White
        Write-Host "  Resource ID:       $($_.id)" -ForegroundColor DarkGray
        Write-Host ""
    }
}

Write-Host "💡 Next Steps:" -ForegroundColor Cyan
Write-Host "1. Copy the Name and Resource Group from above for each environment" -ForegroundColor Gray
Write-Host "2. Update environments/[env].tfvars with real values:" -ForegroundColor Gray
Write-Host "   - Replace 'name' with the Key Vault Name" -ForegroundColor Gray
Write-Host "   - Replace 'resource_group_name' with the Resource Group Name" -ForegroundColor Gray
Write-Host "   - Verify 'location' matches the Key Vault location" -ForegroundColor Gray
Write-Host "`n"
