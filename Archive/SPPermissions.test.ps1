# Path to your PSD1 file
$SPPermissionsPath = "C:\code\GraphAppwithCert\Graph\SPPermissions.psd1"

# Import the PSD1 data
$permissionsData = Import-PowerShellDataFile -Path $SPPermissionsPath

# Check if data is imported correctly
if ($null -eq $permissionsData) {
    Write-Host "Failed to load permissions data." -ForegroundColor Red
    return
}

# Verify applicationPermissions
Write-Host "Application Permissions:" -ForegroundColor Cyan
$permissionsData.applicationPermissions | ForEach-Object {
    if ($_ -and $_.name) {
        Write-Host "Permission Name: $($_.name)" -ForegroundColor Green
    } else {
        Write-Host "Missing 'name' property." -ForegroundColor Red
    }
}

# Verify delegatedPermissions
Write-Host "`nDelegated Permissions:" -ForegroundColor Cyan
$permissionsData.delegatedPermissions | ForEach-Object {
    if ($_ -and $_.name) {
        Write-Host "Permission Name: $($_.name)" -ForegroundColor Green
    } else {
        Write-Host "Missing 'name' property." -ForegroundColor Red
    }
}
