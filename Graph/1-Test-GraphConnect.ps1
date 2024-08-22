iex ((irm "https://raw.githubusercontent.com/aollivierre/module-starter/main/Module-Starter.ps1") -replace '\$Mode = "dev"', '$Mode = "dev"')

$secretsPath = Join-Path -Path $PSScriptRoot -ChildPath "secrets.json"

# Load the secrets from the JSON file
$secrets = Get-Content -Path $secretsPath -Raw | ConvertFrom-Json

#  Variables from JSON file
$tenantId = $secrets.TenantId
$clientId = $secrets.ClientId

# $certPath = Join-Path -Path $PSScriptRoot -ChildPath 'graphcert.pfx'


# Find any PFX file in the root directory of the script
$pfxFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.pfx

if ($pfxFiles.Count -eq 0) {
    Write-Error "No PFX file found in the root directory."
    throw "No PFX file found"
}
elseif ($pfxFiles.Count -gt 1) {
    Write-Error "Multiple PFX files found in the root directory. Please ensure there is only one PFX file."
    throw "Multiple PFX files found"
}

# Use the first (and presumably only) PFX file found
$certPath = $pfxFiles[0].FullName

Write-Output "PFX file found: $certPath"

$CertPassword = $secrets.CertPassword



# Define the splat for Connect-GraphWithCert
$graphParams = @{
    tenantId       = $tenantId
    clientId       = $clientId
    certPath       = $certPath
    certPassword   = $certPassword
    ConnectToIntune = $true
    ConnectToTeams = $false
}

# Connect to Microsoft Graph, Intune, and Teams
$accessToken = Connect-GraphWithCert @graphParams

Log-Params -Params @{accessToken = $accessToken }

Get-TenantDetails