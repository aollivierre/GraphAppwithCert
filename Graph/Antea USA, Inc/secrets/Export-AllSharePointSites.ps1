function InstallOrUpdatePnPModule {
    # Check if PnP.PowerShell module is installed
    $PnPModule = Get-InstalledModule -Name "PnP.PowerShell" -ErrorAction SilentlyContinue

    if (-not $PnPModule) {
        # Install PnP.PowerShell module if it is not installed
        Install-Module -Name "PnP.PowerShell" -Scope CurrentUser -Force -AllowPrerelease
    }
    else {
        # Check if a newer version of PnP.PowerShell module is available
        $LatestPnPModule = Find-Module -Name "PnP.PowerShell" -AllowPrerelease
        if ($PnPModule.Version -lt $LatestPnPModule.Version) {
            # Update the PnP.PowerShell module if a newer version is available
            Update-Module -Name "PnP.PowerShell" -Force -AllowPrerelease
            Write-Host "Updated PnP.PowerShell module to version $($LatestPnPModule.Version)" -ForegroundColor Green
        }
    }

    Import-Module -Name "PnP.PowerShell"
}

# Call the function to install or update the PnP.PowerShell module
InstallOrUpdatePnPModule


function Export-AllSharePointSites {
    param(
        [string]$TenantAdminUrl,
        [string]$CsvFilePath = "AllSitesData.csv"
    )

    # Connect to Tenant Admin Site
    # Connect-PnPOnline -Url $TenantAdminUrl -Interactive


    $connectParams = @{
        Url                 = "https://yourtenant.sharepoint.com"
        ClientId            = "Your-Client-Id"
        Tenant              = "yourtenant.onmicrosoft.com"
        CertificatePath     = "C:\Path\To\YourCertificate.pfx"
        CertificatePassword = $certificatePassword
    }
    
    Connect-PnPOnline @connectParams
    


    # Get all site collections, excluding specific templates
    $SiteCollections = Get-PnPTenantSite | Where-Object -Property Template -NotIn ("SRCHCEN#0", "REDIRECTSITE#0", "SPSMSITEHOST#0", "APPCATALOG#0", "POINTPUBLISHINGHUB#0", "EDISC#0", "STS#-1")

    # Export site collection data to CSV
    $SiteCollections | Select-Object Title, URL, Owner, LastContentModifiedDate, WebsCount, Template, StorageUsage | Export-Csv -Path $CsvFilePath -NoTypeInformation

    Write-Host "Exported all SharePoint site collections to $CsvFilePath" -ForegroundColor Green
}

# Example usage
$TenantAdminUrl = "https://anteagroupus-admin.sharepoint.com"
$CsvFilePath = "C:\Temp\AllSitesData.csv"

Export-AllSharePointSites -TenantAdminUrl $TenantAdminUrl -CsvFilePath $CsvFilePath


# # Example usage:
# $TenantUrl = "https://anteagroupus-admin.sharepoint.com"
# $OutputPath = "C:\temp\SharePointSiteInfo.csv"
# Export-SharePointSiteInfo -TenantUrl $TenantUrl -OutputPath $OutputPath
