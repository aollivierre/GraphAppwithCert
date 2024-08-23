iex ((irm "https://raw.githubusercontent.com/aollivierre/module-starter/main/Module-Starter.ps1") -replace '\$Mode = "dev"', '$Mode = "dev"' -replace 'SkipPSGalleryModules\s*=\s*false', 'SkipPSGalleryModules = false')


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
    tenantId        = $tenantId
    clientId        = $clientId
    certPath        = $certPath
    certPassword    = $certPassword
    ConnectToIntune = $true
    ConnectToTeams  = $false
}

# Connect to Microsoft Graph, Intune, and Teams
$accessToken = Connect-GraphWithCert @graphParams

Log-Params -Params @{accessToken = $accessToken }

Get-TenantDetails

$DBG

# $TenantAdminUrl = "https://anteagroupus-admin.sharepoint.com"
# Connect-PnPOnline -Url $TenantAdminUrl -Interactive

# Then run your command
# $SiteCollections = Get-PnPTenantSite


$certificatePassword = ConvertTo-SecureString -String $certPassword -AsPlainText -Force


$TenantAdminUrl = "https://anteagroupus-admin.sharepoint.com"
# $TenantAdminUrl = "https://anteagroupus.sharepoint.com"

$connectParams = @{
    Url                 = $TenantAdminUrl
    ClientId            = $clientId
    Tenant              = $secrets.TenantDomainName
    CertificatePath     = $certPath
    CertificatePassword = $certificatePassword
}

Connect-PnPOnline @connectParams


# $password = (ConvertTo-SecureString -AsPlainText 'myprivatekeypassword' -Force)
# Connect-PnPOnline -Url "https://contoso.sharepoint.com" -ClientId 6c5c98c7-e05a-4a0f-bcfa-0cfc65aa1f28 -CertificatePath 'c:\mycertificate.pfx' -CertificatePassword $password  -Tenant 'contoso.onmicrosoft.com'

# Get-PnPWeb



# Get all site collections, excluding specific templates
$SiteCollections = Get-PnPTenantSite | Where-Object -Property Template -NotIn ("SRCHCEN#0", "REDIRECTSITE#0", "SPSMSITEHOST#0", "APPCATALOG#0", "POINTPUBLISHINGHUB#0", "EDISC#0", "STS#-1")

# Export site collection data to CSV
$SiteCollections | Select-Object Title, URL, Owner, LastContentModifiedDate, WebsCount, Template, StorageUsage | Out-GridView




# # Step 1: Connect to Microsoft Graph
# Connect-MgGraph -Scopes "Sites.Read.All"

# # Step 2: List all SharePoint sites without any filter
# $sites = Get-MgSite -All

# $DBG

# # Step 3: Display the site URLs and titles
# $sites | ForEach-Object {
#     Write-Host "Site Title: $($_.DisplayName)"
#     Write-Host "Site URL: $($_.WebUrl)"
#     Write-Host "----------------------------------"
# }

# # Step 1: Connect to Microsoft Graph
# Connect-MgGraph -Scopes "Sites.Read.All"

# # Step 2: List all SharePoint sites
# $sites = Get-MgSite -Filter "siteCollection/root ne null"

# # Step 3: Display the site URLs and titles
# $sites | ForEach-Object {
#     Write-Host "Site Title: $($_.DisplayName)"
#     Write-Host "Site URL: $($_.WebUrl)"
#     Write-Host "----------------------------------"
# }





# Step 1: Connect to Microsoft Graph
# Connect-MgGraph -Scopes "Sites.Read.All"

# Step 2: List all SharePoint sites
# $sites = Get-MgSite -Filter "siteCollection/root ne null"

# # Step 3: Display the site URLs and titles
# $sites | ForEach-Object {
#     Write-Host "Site Title: $($_.DisplayName)"
#     Write-Host "Site URL: $($_.WebUrl)"
#     Write-Host "----------------------------------"
# }





# # Step 1: Connect to Microsoft Graph
# Connect-MgGraph -Scopes "Sites.Read.All"

# # Step 2: Get the list of root sites (site collections)
# $rootSite = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/sites/root"

# # Step 3: Get the sub-sites or any other site collections under the root
# $sitesRequest = @{
#     Uri    = "https://graph.microsoft.com/v1.0/sites/{$rootSite.id}/sites"
#     Method = "GET"
# }

# $sitesResponse = Invoke-MgGraphRequest @sitesRequest

# # Step 4: Display the site URLs and titles
# $sitesResponse.value | ForEach-Object {
#     Write-Host "Site Title: $($_.displayName)"
#     Write-Host "Site URL: $($_.webUrl)"
#     Write-Host "----------------------------------"
# }




