#!ToDO work on creatng a function for importing all modules in the modules folders without specifying the path of each module.
#fix permissions of the client app to add Intune permissions


# Load the secrets from the JSON file
#First, load secrets and create a credential object:
# Assuming secrets.json is in the same directory as your script
$secretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.json"

# Load the secrets from the JSON file
$secrets = Get-Content -Path $secretsPath -Raw | ConvertFrom-Json

# Read configuration from the JSON file
# Assign values from JSON to variables

# Read configuration from the JSON file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
$env:MYMODULE_CONFIG_PATH = $configPath

$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

#  Variables from JSON file
$CertPassword = $secrets.certexportpassword




function Initialize-Environment {
    param (
        [string]$WindowsModulePath = "EnhancedBoilerPlateAO\2.0.0\EnhancedBoilerPlateAO.psm1",
        [string]$LinuxModulePath = "/usr/src/code/Modules/EnhancedBoilerPlateAO/2.0.0/EnhancedBoilerPlateAO.psm1"
    )

    function Get-Platform {
        if ($PSVersionTable.PSVersion.Major -ge 7) {
            return $PSVersionTable.Platform
        }
        else {
            return [System.Environment]::OSVersion.Platform
        }
    }

    function Setup-GlobalPaths {
        if ($env:DOCKER_ENV -eq $true) {
            $global:scriptBasePath = $env:SCRIPT_BASE_PATH
            $global:modulesBasePath = $env:MODULES_BASE_PATH
        }
        else {
            $global:scriptBasePath = $PSScriptRoot
            # $global:modulesBasePath = "$PSScriptRoot\modules"
            $global:modulesBasePath = "c:\code\modules"
        }
    }

    function Setup-WindowsEnvironment {
        # Get the base paths from the global variables
        Setup-GlobalPaths

        # Construct the paths dynamically using the base paths
        $global:modulePath = Join-Path -Path $modulesBasePath -ChildPath $WindowsModulePath
        $global:AOscriptDirectory = Join-Path -Path $scriptBasePath -ChildPath "Win32Apps-DropBox"
        $global:directoryPath = Join-Path -Path $scriptBasePath -ChildPath "Win32Apps-DropBox"
        $global:Repo_Path = $scriptBasePath
        $global:Repo_winget = "$Repo_Path\Win32Apps-DropBox"


        # Import the module using the dynamically constructed path
        Import-Module -Name $global:modulePath -Verbose -Force:$true -Global:$true

        # Log the paths to verify
        Write-Output "Module Path: $global:modulePath"
        Write-Output "Repo Path: $global:Repo_Path"
        Write-Output "Repo Winget Path: $global:Repo_winget"
    }

    function Setup-LinuxEnvironment {
        # Get the base paths from the global variables
        Setup-GlobalPaths

        # Import the module using the Linux path
        Import-Module $LinuxModulePath -Verbose

        # Convert paths from Windows to Linux format
        $global:AOscriptDirectory = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer"
        $global:directoryPath = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer\Win32Apps-DropBox"
        $global:Repo_Path = Convert-WindowsPathToLinuxPath -WindowsPath "C:\Users\Admin-Abdullah\AppData\Local\Intune-Win32-Deployer"
        $global:Repo_winget = "$global:Repo_Path\Win32Apps-DropBox"
    }

    $platform = Get-Platform
    if ($platform -eq 'Win32NT' -or $platform -eq [System.PlatformID]::Win32NT) {
        Setup-WindowsEnvironment
    }
    elseif ($platform -eq 'Unix' -or $platform -eq [System.PlatformID]::Unix) {
        Setup-LinuxEnvironment
    }
    else {
        throw "Unsupported operating system"
    }
}

# Call the function to initialize the environment
Initialize-Environment


# Example usage of global variables outside the function
Write-Output "Global variables set by Initialize-Environment:"
Write-Output "scriptBasePath: $scriptBasePath"
Write-Output "modulesBasePath: $modulesBasePath"
Write-Output "modulePath: $modulePath"
Write-Output "AOscriptDirectory: $AOscriptDirectory"
Write-Output "directoryPath: $directoryPath"
Write-Output "Repo_Path: $Repo_Path"
Write-Output "Repo_winget: $Repo_winget"

#################################################################################################################################
################################################# END VARIABLES #################################################################
#################################################################################################################################

###############################################################################################################################
############################################### START MODULE LOADING ##########################################################
###############################################################################################################################

<#
.SYNOPSIS
Dot-sources all PowerShell scripts in the 'private' folder relative to the script root.

.DESCRIPTION
This function finds all PowerShell (.ps1) scripts in a 'private' folder located in the script root directory and dot-sources them. It logs the process, including any errors encountered, with optional color coding.

.EXAMPLE
Dot-SourcePrivateScripts

Dot-sources all scripts in the 'private' folder and logs the process.

.NOTES
Ensure the Write-EnhancedLog function is defined before using this function for logging purposes.
#>


Write-Host "Starting to call Get-ModulesFolderPath..."

# Store the outcome in $ModulesFolderPath
try {
  
    $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "C:\code\modules" -UnixPath "/usr/src/code/modules"
    # $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "$PsScriptRoot\modules" -UnixPath "$PsScriptRoot/modules"
    Write-host "Modules folder path: $ModulesFolderPath"

}
catch {
    Write-Error $_.Exception.Message
}


Write-Host "Starting to call Import-LatestModulesLocalRepository..."
Import-LatestModulesLocalRepository -ModulesFolderPath $ModulesFolderPath -ScriptPath $PSScriptRoot

###############################################################################################################################
############################################### END MODULE LOADING ############################################################
###############################################################################################################################
try {
    Ensure-LoggingFunctionExists -LoggingFunctionName "Write-EnhancedLog"
    # Continue with the rest of the script here
    # exit
}
catch {
    Write-Host "Critical error: $_" -ForegroundColor Red
    Handle-Error $_.
    exit
}

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

# Setup logging
Write-EnhancedLog -Message "Script Started" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

################################################################################################################################
################################################################################################################################
################################################################################################################################

# Execute InstallAndImportModulesPSGallery function
InstallAndImportModulesPSGallery -moduleJsonPath "$PSScriptRoot/modules.json"

################################################################################################################################
################################################ END MODULE CHECKING ###########################################################
################################################################################################################################

    
################################################################################################################################
################################################ END LOGGING ###################################################################
################################################################################################################################

#  Define the variables to be used for the function
#  $PSADTdownloadParams = @{
#      GithubRepository     = "psappdeploytoolkit/psappdeploytoolkit"
#      FilenamePatternMatch = "PSAppDeployToolkit*.zip"
#      ZipExtractionPath    = Join-Path "$PSScriptRoot\private" "PSAppDeployToolkit"
#  }

#  Call the function with the variables
#  Download-PSAppDeployToolkit @PSADTdownloadParams

################################################################################################################################
################################################ END DOWNLOADING PSADT #########################################################
################################################################################################################################


##########################################################################################################################
############################################STARTING THE MAIN FUNCTION LOGIC HERE#########################################
##########################################################################################################################


################################################################################################################################
################################################ START GRAPH CONNECTING ########################################################
################################################################################################################################
# $accessToken = Connect-GraphWithCert -tenantId $tenantId -clientId $clientId -certPath $certPath -certPassword $certPassword

# Log-Params -Params @{accessToken = $accessToken }

# Get-TenantDetails




# Path to the scopes.json file
$jsonFilePath = "$PSscriptroot\scopes.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Extract the scopes
$scopes = $jsonContent.Scopes -join " "

# Connect to Microsoft Graph with the specified scopes
# Connect to Graph interactively
Connect-MgGraph -Scopes $scopes

# # Check the connection
# $connectionStatus = Get-MgProfile
# if ($null -eq $connectionStatus) {
#     Write-Host "Failed to connect to Microsoft Graph." -ForegroundColor Red
# } else {
#     Write-Host "Successfully connected to Microsoft Graph." -ForegroundColor Green
# }


Get-TenantDetails




# function Get-AccessToken {
#     try {
#         $MGprofile = Get-MgProfile -ErrorAction Stop
#         $token = $MGprofile.Context.TokenCache.GetItem("https://graph.microsoft.com")
        
#         if ($null -eq $token) {
#             Write-EnhancedLog -Message "Access token not found in the current session." -Level "ERROR"
#             throw "Access token not found"
#         }

#         Write-EnhancedLog -Message "Access token retrieved successfully." -Level "INFO"
#         return $token.Secret
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while retrieving the access token." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }




# function Get-AccessToken {
#     try {
#         $context = Get-MgContext -ErrorAction Stop
        
#         if ($null -eq $context) {
#             Write-EnhancedLog -Message "Microsoft Graph context not found." -Level "ERROR"
#             throw "Microsoft Graph context not found"
#         }

#         $token = $context.AuthContext.AccessToken

#         if ($null -eq $token) {
#             Write-EnhancedLog -Message "Access token not found in the current session." -Level "ERROR"
#             throw "Access token not found"
#         }

#         Write-EnhancedLog -Message "Access token retrieved successfully." -Level "INFO"
#         return $token
#     } catch {
#         Write-EnhancedLog -Message "An error occurred while retrieving the access token." -Level "ERROR"
#         Handle-Error -ErrorRecord $_
#         throw $_
#     }
# }

# $accessToken = Get-AccessToken
# Log-Params -Params @{accessToken = $accessToken }

# $DBG











#################################################################################################################################
################################################# END Connecting to Graph #######################################################
#################################################################################################################################

#Endregion #########################################DEALING WITH MODULES########################################################


# Example usage
$jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "applist.json"
Remove-AppListJson -jsonPath $jsonPath





# Define the path for the JSON output




# Optionally, export the extracted data to a CSV file
# $appInfo | Export-Csv -Path "C:\path\to\output.csv" -NoTypeInformation




# # Example usage with a random app name
# $appName = "randomAppNameThatDoesNotExist"
# $jsonPath = Join-Path -Path $PSScriptRoot -ChildPath "applist.json"

# # Validate that the app does not already exist
# if (Validate-AppCreation -AppName $appName -JsonPath $jsonPath) {
#     Write-EnhancedLog -Message "App already exists" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#     throw "App already exists"
# } else {
#     Write-EnhancedLog -Message "App does not exist" -Level "INFO"
# }




# Create App Registration
# function Create-AppRegistration {
#     param (
#         [string]$AppName,
#         [string]$PermsFile = "$PSScriptRoot\permissions.json"
#     )

#     try {
#         if (-Not (Test-Path $PermsFile)) {
#             Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#             throw "Permissions file missing"
#             Handle-Error -ErrorRecord $_
#         }
    
#         $permissions = Get-Content -Path $PermsFile | ConvertFrom-Json
    
#         # Connect to Graph interactively
#         # Connect-MgGraph -Scopes "Application.ReadWrite.All"
    
#         # Get tenant details
#         $tenantDetails = Get-MgOrganization | Select-Object -First 1
    
#         # Create the application
#         $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $permissions
    
#         if ($null -eq $app) {
#             Write-EnhancedLog -Message "App registration failed" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#             throw "App registration failed"
#         }
    
#         Write-EnhancedLog -Message "App registered successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
#         return @{ App = $app; TenantDetails = $tenantDetails }
        
#     }
#     catch {
#         <#Do this if a terminating exception happens#>
#         Handle-Error -ErrorRecord $_
#     }

   
# }

# Create self-signed certificate








### Export-CertificateToFile Function
# This function will export a given certificate to a specified file path.
# function Export-CertificateToFile {
#     param (
#         [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate,
#         [string]$ExportPath,
#         [string]$FileName
#     )

#     try {
#         # Ensure the export directory exists
#         if (-not (Test-Path -Path $ExportPath)) {
#             New-Item -ItemType Directory -Path $ExportPath -Force
#         }

#         # Export the certificate to a file (DER encoded binary format with .cer extension)
#         $exportFilePath = Join-Path -Path $ExportPath -ChildPath "$FileName.cer"
#         $Certificate | Export-Certificate -FilePath $exportFilePath -Type CERT -Force
#         # Write-EnhancedLog -Message "Certificate exported successfully to $exportFilePath" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
#     } catch {
#         # Write-EnhancedLog -Message "Failed to export certificate: $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#         throw "Failed to export certificate"
#     }

#     return $exportFilePath  # Returning the path where the certificate was exported
# }




# function Export-CertificateToFile {
#     param (
#         [System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate,
#         [string]$ExportPath,
#         [string]$FileName
#     )

#     try {
#         # Ensure the export directory exists
#         if (-not (Test-Path -Path $ExportPath)) {
#             New-Item -ItemType Directory -Path $ExportPath -Force
#         }

#         # Export the certificate to a file (DER encoded binary format with .cer extension)
#         $exportFilePath = Join-Path -Path $ExportPath -ChildPath "$FileName.cer"
#         $Certificate | Export-Certificate -FilePath $exportFilePath -Type CERT -Force
#         # Write-EnhancedLog -Message "Certificate exported successfully to $exportFilePath" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
#     }
#     catch {
#         # Write-EnhancedLog -Message "Failed to export certificate: $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#         throw "Failed to export certificate"
#     }

#     return $exportFilePath  # Returning the path where the certificate was exported
# }



# function Create-SelfSignedCert {
#     param (
#         [string]$CertName,
#         [string]$CertStoreLocation = "Cert:\CurrentUser\My",
#         [string]$TenantName,
#         [string]$AppId,
#         [string]$ExportPath  # Path to export the certificate file
#     )

#     # Create the self-signed certificate
#     $cert = New-SelfSignedCertificate -CertStoreLocation $CertStoreLocation `
#         -Subject "CN=$CertName, O=$TenantName, OU=$AppId" `
#         -KeyLength 2048 `
#         -NotAfter (Get-Date).AddDays(30)

#     if ($null -eq $cert) {
#         Write-EnhancedLog -Message "Failed to create certificate" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
#         throw "Certificate creation failed"
#     } else {
#         Write-EnhancedLog -Message "Certificate created successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
#     }

#     # Export the certificate to a file (DER encoded binary format with .cer extension)
#     $exportPath = Join-Path $ExportPath "$CertName.cer"
#     $cert | Export-Certificate -FilePath $exportPath -Type CERT

#     Write-EnhancedLog -Message "Certificate exported successfully to $exportPath" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

#     return $exportPath  # Returning the path where the certificate was exported
# }





Remove-AppRegistrationsAndDeletedItems -AppDisplayNamePattern "*graphapp-test*"











# Validate certificate creation
function Validate-CertCreation {
    param (
        [string]$Thumbprint,
        [string[]]$StoreLocations = @("Cert:\LocalMachine", "Cert:\CurrentUser")
    )

    foreach ($storeLocation in $StoreLocations) {
        $cert = Get-ChildItem -Path "$storeLocation\My" | Where-Object { $_.Thumbprint -eq $Thumbprint }
        if ($null -ne $cert) {
            Write-EnhancedLog -Message "Certificate validated successfully in $storeLocation" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
            return $cert
        }
    }

    Write-EnhancedLog -Message "Certificate validation failed" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    throw "Certificate not found"
    Handle-Error -ErrorRecord $_
}

# Main script execution
Write-EnhancedLog -Message "Script Started" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

try {
    # Get the unique app name
    $appName = Get-AppName -AppJsonFile "$PSScriptRoot\app.json"


    $params = @{
        Appname = $appName
    }
    Log-Params -Params $params



    # Validate that the app does not already exist
    Write-EnhancedLog -Message 'first validation'
    Run-DumpAppListToJSON -JsonPath $jsonPath
    $appExists = Validate-AppCreation -AppName $appName -JsonPath $jsonPath
    # $DBG
    if ($appExists) {
        Write-EnhancedLog -Message "App already exists" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw "App already exists"
    }
    else {
        Write-EnhancedLog -Message "App does not exist" -Level "INFO"
    }


    # Create the app registration
    $appDetails = Create-AppRegistration -AppName $appName -PermsFile
    $app = $appDetails.App
    $tenantDetails = $appDetails.TenantDetails

    # $DBG
    
    # Example usage
    # $AppName = "YourAppName"
    # $JsonPath = "C:\path\to\your\jsonfile.json"
    Write-EnhancedLog -Message 'calling Validate-AppCreationWithRetry for the second validation'
    Validate-AppCreationWithRetry -AppName $AppName -JsonPath $JsonPath
    

    # Create the self-signed certificate with tenant and app details
    # $secretsFolder = Join-Path -Path $PSScriptRoot -ChildPath "certs"


    # Create the folder structure based on tenant name and tenant ID
    $tenantFolder = Join-Path -Path $PSScriptRoot -ChildPath "$($tenantDetails.DisplayName)_$($tenantDetails.Id)"
    $secretsFolder = Join-Path -Path $tenantFolder -ChildPath "secrets"

    # Ensure the folders are created
    if (-not (Test-Path -Path $secretsFolder)) {
        New-Item -ItemType Directory -Path $secretsFolder -Force | Out-Null
    }


    $Certname = "GraphCert-$($tenantDetails.DisplayName)-$($app.AppId)"
    # $cert = Create-SelfSignedCert -CertName $Certname -TenantName $tenantDetails.DisplayName -AppId $app.AppId
    # Define the parameters as a hashtable
    $params = @{
        CertName    = $Certname
        TenantName  = $tenantDetails.DisplayName
        AppId       = $app.AppId
        OutputPath  = $secretsFolder
        PfxPassword = $certPassword
    }

    # Call the function using splatting
    $cert = Create-SelfSignedCert @params

    $thumbprint = $cert.Thumbprint

    # Export the certificate to a file
    # $certPath = $null
    # $certPath = Export-CertificateToFile -Certificate $cert -ExportPath "$PSScriptRoot" -FileName "GraphCert"
    # $certPath = "C:\Code\Unified365toolbox\Graph\GraphCert.cer"
    # $certPath = Export-CertificateToFile -Certificate $cert -ExportPath "$PSScriptRoot"

    # Call the function with the required parameters
    # Define the variables
    $certThumbprint = $thumbprint 
    

    # $exportedCertPath = ExportCertificatetoFile -CertThumbprint $certThumbprint -ExportDirectory $exportDirectory
    $certPath = ExportCertificatetoFile -CertThumbprint $certThumbprint -ExportDirectory $secretsFolder

    # Output the exported certificate path
    Write-Host "The certificate was exported to: $certPath"



 



    



    # $DBG

    # Validate the certificate creation
    Validate-CertCreation -Thumbprint $thumbprint

    # Associate the certificate with the app registration
    # Associate-CertWithApp -AppId $app.AppId -Thumbprint $thumbprint
    # Associate-CertWithApp -AppId $app.AppId -certificatepath $certPath



    
    $params = @{
        certPath = $certPath
    }
    Log-Params -Params $params


    # Define the application ID and certificate path
    $appId = $app.id
    $clientId = $app.AppId
    # $appId = "c665c660-1d09-4d94-a1e0-06a0dd512285"
    # $certPath = "C:\Code\Unified365toolbox\Graph\GraphCert.cer"
    # $certPath = $certPath


    # Example usage
    # $appId = "dfde17fe-a9fd-4925-a035-5a23cf53be9d"
    # $permissionsFilePath = Join-Path -Path $PSScriptRoot -ChildPath "permissions.json"
    # Update-ApplicationPermissions -appId $appId -permissionsFile $permissionsFilePath

    # Call the function to Associate the Cert With App
    Add-KeyCredentialToApp -AppId $appId -CertPath $certPath



    # Grant-AdminConsentToApiPermissions -AppId $appId
    # Grant-AdminConsentToApiPermissions -AppId $appId -clientId $clientId
    # Grant-AdminConsentToApiPermissions -clientId $clientId -Headers $headers
    Grant-AdminConsentToApiPermissions -clientId $clientId -SPPermissionsPath $PSScriptRoot


    # Grant-AdminConsentUsingAzCli -AppId $clientId

    # Grant-AdminConsentToAllPermissions -AppDisplayName 'GraphApp-Test001-20240618142134'
    # Grant-AdminConsentToAllPermissions -AppDisplayName $app.DisplayName
    

    # Grant-AdminConsentToDelegatedPermissions -AppId $appId -Permissions "User.Read.All Group.Read.All" -AccessToken $accessToken




    # Open the certificate store
    Start-Process certmgr.msc

    # Output the secrets
    # Define the parameters as a hashtable
    $SecretsFile = Join-Path -Path $secretsFolder -ChildPath "secrets.json"
    $params = @{
        AppDisplayName = $app.DisplayName
        ApplicationID  = $app.AppId
        TenantID       = $tenantDetails.Id
        SecretsFile    = $secretsfile
        CertName       = $Certname
        Thumbprint     = $thumbprint
        CertPassword   = $CertPassword
        TenantName     = $tenantDetails.DisplayName
        OutputPath     = $secretsFolder
    }

    # Call the function using splatting
    Output-Secrets @params

    Write-EnhancedLog -Message "Script Completed Successfully" -Level "INFO"
}
catch {
    Write-EnhancedLog -Message "Script failed: $_" -Level "ERROR"
    Handle-Error -ErrorRecord $_
}


# Get-MgApplication 



# List all applications
#  Write-Host "Listing all applications:"
#  Validate-AppCreation
#  $allApps | Format-Table Id, DisplayName, AppId, SignInAudience, PublisherDomain -AutoSize

#  Get-MgApplication 