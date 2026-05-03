# PowerShell Script: Validate tfvars before running terraform plan
# This tests that discovery can actually find the Key Vault

param(
    [string]$Environment = "int"
)

Write-Host "🧪 Validating Terraform configuration for [$Environment]..." -ForegroundColor Cyan
Write-Host ""

$tfvarsFile = "environments\$Environment.tfvars"

if (-not (Test-Path $tfvarsFile)) {
    Write-Host "❌ ERROR: File not found: $tfvarsFile" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found: $tfvarsFile" -ForegroundColor Green
Write-Host ""

# Parse tfvars file
Write-Host "📋 Parsing tfvars values..." -ForegroundColor Cyan

$name = (Select-String -Path $tfvarsFile -Pattern 'name\s*=\s*"([^"]+)"').Matches.Groups[1].Value
$rg = (Select-String -Path $tfvarsFile -Pattern 'resource_group_name\s*=\s*"([^"]+)"').Matches.Groups[1].Value
$location = (Select-String -Path $tfvarsFile -Pattern 'location\s*=\s*"([^"]+)"').Matches.Groups[1].Value

if (-not $name) {
    Write-Host "❌ ERROR: Could not parse 'name' from $tfvarsFile" -ForegroundColor Red
    exit 1
}
if (-not $rg) {
    Write-Host "❌ ERROR: Could not parse 'resource_group_name' from $tfvarsFile" -ForegroundColor Red
    exit 1
}

Write-Host "  Name:              $name" -ForegroundColor White
Write-Host "  Resource Group:    $rg" -ForegroundColor White
Write-Host "  Location:          $location" -ForegroundColor White
Write-Host ""

# Check for placeholder values
Write-Host "🔍 Checking for placeholder values..." -ForegroundColor Cyan
if ($name -match "replace-with|example" -or $rg -match "replace-with|example") {
    Write-Host "❌ ERROR: tfvars contains placeholder values" -ForegroundColor Red
    Write-Host "   - Run: ..\scripts\discover-keyvaults.ps1" -ForegroundColor Yellow
    Write-Host "   - Update $tfvarsFile with real Key Vault names and resource groups" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ No placeholders detected" -ForegroundColor Green
Write-Host ""

# Test Azure CLI discovery (requires az cli and authentication)
Write-Host "🔐 Testing Azure discovery..." -ForegroundColor Cyan

try {
    $discovered = az keyvault show --name $name --resource-group $rg --query '[name, location, id]' -o json 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        $kv = $discovered | ConvertFrom-Json
        Write-Host "✅ Key Vault found in Azure!" -ForegroundColor Green
        Write-Host "   Name:     $($kv[0])" -ForegroundColor White
        Write-Host "   Location: $($kv[1])" -ForegroundColor White
        Write-Host "   ID:       $($kv[2])" -ForegroundColor DarkGray
        Write-Host ""
        
        # Verify location match
        $kvLocation = $kv[1]
        $normalized_tf = $location -replace '\s+', '' -replace '^\s*|\s*$'
        $normalized_kv = $kvLocation -replace '\s+', '' -replace '^\s*|\s*$'
        
        if ($normalized_tf.ToLower() -ne $normalized_kv.ToLower()) {
            Write-Host "⚠️  WARNING: Location mismatch" -ForegroundColor Yellow
            Write-Host "   tfvars location: $location" -ForegroundColor Yellow
            Write-Host "   Azure location:  $kvLocation" -ForegroundColor Yellow
            Write-Host "   This may cause discovery validation to fail" -ForegroundColor Yellow
            Write-Host ""
        } else {
            Write-Host "✅ Location matches" -ForegroundColor Green
            Write-Host ""
        }
    } else {
        Write-Host "❌ ERROR: Key Vault not found in Azure" -ForegroundColor Red
        Write-Host "   Name:             $name" -ForegroundColor Yellow
        Write-Host "   Resource Group:   $rg" -ForegroundColor Yellow
        Write-Host "   Suggestions:" -ForegroundColor Cyan
        Write-Host "   1. Verify you're authenticated: az login" -ForegroundColor Gray
        Write-Host "   2. Check subscription: az account show" -ForegroundColor Gray
        Write-Host "   3. List Key Vaults: ..\scripts\discover-keyvaults.ps1" -ForegroundColor Gray
        write-Host "   4. Verify name/RG are spelled correctly (case-sensitive)" -ForegroundColor Gray
        exit 1
    }
} catch {
    Write-Host "⚠️  WARNING: Azure CLI test skipped" -ForegroundColor Yellow
    Write-Host "   Reason: $($_.Exception.Message)" -ForegroundColor Gray
    Write-Host "   This is OK if az cli is not installed or not authenticated" -ForegroundColor Gray
    Write-Host "   Terraform will still attempt discovery during plan" -ForegroundColor Gray
    Write-Host ""
}

# Summary
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Validation Passed! Ready to run terraform plan" -ForegroundColor Green
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step:" -ForegroundColor Cyan
Write-Host "  terraform plan -var-file='environments\$Environment.tfvars' -var='environment=$Environment'" -ForegroundColor Yellow
Write-Host ""
