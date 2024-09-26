# Set environment variable globally for all users
[System.Environment]::SetEnvironmentVariable('EnvironmentMode', 'dev', 'Machine')

# Retrieve the environment mode (default to 'prod' if not set)
$mode = $env:EnvironmentMode

# Toggle based on the environment mode
switch ($mode) {
    'dev' {
        Write-Host "Running in development mode" -ForegroundColor Yellow
        # Your development logic here
    }
    'prod' {
        Write-Host "Running in production mode" -ForegroundColor Green
        # Your production logic here
    }
    default {
        Write-Host "Unknown mode. Defaulting to production." -ForegroundColor Red
        # Default to production
    }
}

#region FIRING UP MODULE STARTER
#################################################################################################
#                                                                                               #
#                                 FIRING UP MODULE STARTER                                      #
#                                                                                               #
#################################################################################################

# Invoke-Expression (Invoke-RestMethod "https://raw.githubusercontent.com/aollivierre/module-starter/main/Install-EnhancedModuleStarterAO.ps1")

# Define a hashtable for splatting
# $moduleStarterParams = @{
#     Mode                   = 'prod'
#     SkipPSGalleryModules   = $false
#     SkipCheckandElevate    = $false
#     SkipPowerShell7Install = $false
#     SkipEnhancedModules    = $false
#     SkipGitRepos           = $true
# }

# # Call the function using the splat
# Invoke-ModuleStarter @moduleStarterParams

#endregion FIRING UP MODULE STARTER


#!ToDO work on creatng a function for importing all modules in the modules folders without specifying the path of each module.
#fix permissions of the client app to add Intune permissions

# Load the secrets from the JSON file
#First, load secrets and create a credential object:
# Assuming secrets.json is in the same directory as your script
# $certsecretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.json"

# # Load the secrets from the JSON file
# $certsecrets = Get-Content -Path $certsecretsPath -Raw | ConvertFrom-Json

# #  Variables from JSON file
# $CertPassword = $certsecrets.certexportpassword








# Define the path to the PSD1 file for storing cert secrets
$certsecretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.psd1"

# Check if the PSD1 file exists
if (-Not (Test-Path -Path $certsecretsPath)) {
    # If the file doesn't exist, prompt the user for the cert secret
    $CertPassword = Read-Host -AsSecureString "Enter the certificate export password"

    # Convert the secure string to an encrypted standard string for storage
    $CertPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($CertPassword)
    )

    # Create a hashtable to store the cert secret
    $certsecrets = @{
        certexportpassword = $CertPasswordPlain
    }

    # Save the hashtable to a PSD1 file
    $certsecrets | Export-Clixml -Path $certsecretsPath
    Write-Host "Cert secrets stored in '$certsecretsPath'."
}
else {
    # Load the secrets from the PSD1 file
    $certsecrets = Import-Clixml -Path $certsecretsPath

    # Extract the certificate password
    $CertPassword = $certsecrets.certexportpassword
}

# Now you can use $CertPassword in your script


#################################################################################################################################
################################################# END VARIABLES #################################################################
#################################################################################################################################


##########################################################################################################################
############################################STARTING THE MAIN FUNCTION LOGIC HERE#########################################
##########################################################################################################################


################################################################################################################################
################################################ START GRAPH CONNECTING ########################################################
################################################################################################################################
# Path to the scopes.json file
$jsonFilePath = "$PSscriptroot\scopes.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Extract the scopes
$scopes = $jsonContent.Scopes -join " "

# Connect to Microsoft Graph with the specified scopes
# Connect to Graph interactively
disconnect-Graph
Disconnect-MgGraph -Verbose
disconnect-Graph

# Call the function to connect to Microsoft Graph
Connect-ToMicrosoftGraphIfServerCore -Scopes $scopes




# $dbg


# Get the tenant details
$tenantDetails = $null
$tenantDetails = Get-TenantDetails
if ($null -eq $tenantDetails) {
    Write-EnhancedLog -Message "Unable to proceed without tenant details" -Level "ERROR"
    throw "Tenant Details name is empty. Cannot proceed without a valid tenant details"
    exit
}

#################################################################################################################################
################################################# END Connecting to Graph #######################################################
#################################################################################################################################

#Endregion #########################################DEALING WITH MODULES########################################################

# Example usage
$jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "applist.json"
Remove-AppListJson -jsonPath $jsonPath


Remove-AppRegistrationsAndDeletedItems -AppDisplayNamePattern "*graphapp-test*"

# Validate certificate creation

# Main script execution
Write-EnhancedLog -Message "Script Started" -Level "INFO"

try {
    # Get the unique app name
    $appName = Get-AppName -AppJsonFile "$PSScriptRoot\app.json"


    $params = @{
        Appname = $appName
    }
    Log-Params -Params $params

    # Validate that the app does not already exist
    Write-EnhancedLog -Message 'first validation'
    # Run-DumpAppListToJSON -JsonPath $jsonPath
    $appExists = Validate-AppCreation -AppName $appName -JsonPath $jsonPath
    # $DBG
    if ($appExists) {
        Write-EnhancedLog -Message "App already exists" -Level "ERROR"
        throw "App already exists"
    }
    else {
        Write-EnhancedLog -Message "App does not exist" -Level "INFO"
    }

    # Create the app registration
    $appDetails = Create-AppRegistration -AppName $appName -PermsFile "$PSScriptRoot\permissions.json"
    $app = $appDetails.App
    $apptenantDetails = $null
    $apptenantDetails = $appDetails.TenantDetails

    # Write-EnhancedLog -Message 'calling Validate-AppCreationWithRetry for the second validation'
    # Validate-AppCreationWithRetry -AppName $AppName -JsonPath $JsonPath
    

    # Create the self-signed certificate with tenant and app details
    # Create the folder structure based on tenant name and tenant ID
    # $tenantFolder = Join-Path -Path $PSScriptRoot -ChildPath "$($tenantDetails.DisplayName)_$($tenantDetails.Id)"
    $tenantFolder = Join-Path -Path $PSScriptRoot -ChildPath "$($apptenantDetails.DisplayName)"
    # $secretsFolder = Join-Path -Path "$tenantFolder" -ChildPath "secrets"

    # # Check if the folder exists
    # if (Test-Path -Path "$secretsFolder") {
    #     # Remove the existing folder and its contents
    #     Remove-Item -Path "$secretsFolder" -Recurse -Force
    #     Write-Host "Removed existing secrets folder: $secretsFolder"
    # }
    
    # # Create a new folder
    # New-Item -ItemType Directory -Path "$secretsFolder" -Force | Out-Null
    # Write-Host "Created new secrets folder: $secretsFolder"
    


    # $Certname = "GraphCert-$($tenantDetails.DisplayName)-$($app.AppId)"
    $Certname = "GraphCert-$($apptenantDetails.DisplayName)"
    # Define the parameters as a hashtable
    $params = @{
        CertName    = $Certname
        TenantName  = $apptenantDetails.DisplayName
        AppId       = $app.AppId
        # OutputPath  = "$secretsFolder"
        OutputPath  = "$tenantFolder"
        PfxPassword = $certPassword
    }

    # $DBG

    # Call the function using splatting
    #Create and Export *.PFX and *.key files for the actual graph connection later on OUTSIDE of this script
    $cert = Create-SelfSignedCert @params

    # $DBG

    $thumbprint = $cert.Thumbprint

    # Call the function with the required parameters
    # Define the variables
    $certThumbprint = $thumbprint

    #Export the CERT to a *.CER file to associatae with the new Entra ID App reg (however when you connect you need to use *.PFX format of that file if not using the cert from the store)
    $certPath = ExportCertificatetoCER -CertThumbprint $certThumbprint -ExportDirectory $tenantFolder -Certname $Certname

    # $DBG

    # Output the exported certificate path
    Write-EnhancedLog -Message "The certificate was exported to: $certPath" -Level "INFO"

    # Validate the certificate creation
    Validate-CertCreation -Thumbprint $thumbprint

    $params = @{
        certPath = $certPath
    }
    Log-Params -Params $params


    # Define the application ID and certificate path
    $appId = $app.id
    $clientId = $app.AppId
  
    # Call the function to Associate the Cert With App
    Add-KeyCredentialToApp -AppId $appId -CertPath $certPath

    Grant-AdminConsentToApiPermissions -clientId $clientId -SPPermissionsPath $PSScriptRoot

    # # Open the certificate store

    # Call the function
    Open-CertificateStore


    # Output the secrets
    # Define the parameters as a hashtable
    $SecretsFile = Join-Path -Path $tenantFolder -ChildPath "secrets.json"

    $params = $null
    $params = @{
        AppDisplayName   = $app.DisplayName
        ApplicationID    = $app.AppId
        TenantID         = $tenantDetails.TenantId
        SecretsFile      = $secretsfile
        CertName         = $Certname
        Thumbprint       = $thumbprint
        CertPassword     = $CertPassword
        TenantName       = $tenantDetails.TenantName
        TenantDomainName = $tenantDetails.tenantDomain
        OutputPath       = $tenantFolder
    }

    # Call the function using splatting
    Output-Secrets @params



    # Define the destination path
    $destinationPath = "C:\code\Intune-Win32-Deployer\secrets"

    # Check if the tenant folder exists
    if (-Not (Test-Path -Path $tenantFolder)) {
        Write-Error "The specified tenant folder '$tenantFolder' does not exist."
        throw "Invalid tenant folder"
    }

    # # Get the folder name from the tenant folder path
    # $tenantFolderName = Split-Path -Path $tenantFolder -Leaf

    # # Define the full destination path for the tenant folder
    # $fullDestinationPath = Join-Path -Path $destinationPath -ChildPath $tenantFolderName

    # Copy the tenant folder to the destination
    try {
        Copy-Item -Path $tenantFolder -Destination $destinationPath -Recurse -Force
        Write-Host "Successfully copied '$tenantFolder' to '$destinationPath'."
    }
    catch {
        Write-Error "Failed to copy the tenant folder: $_"
        throw
    }





    Write-EnhancedLog -Message "Script Completed Successfully" -Level "INFO"
}
catch {
    Write-EnhancedLog -Message "Script failed: $_" -Level "ERROR"
    Handle-Error -ErrorRecord $_
}