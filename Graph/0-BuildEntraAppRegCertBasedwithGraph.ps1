#!ToDO work on creatng a function for importing all modules in the modules folders without specifying the path of each module.
#fix permissions of the client app to add Intune permissions


# Read configuration from the JSON file
# Assign values from JSON to variables

# Read configuration from the JSON file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
$env:MYMODULE_CONFIG_PATH = $configPath



# # Load client secrets from the JSON file
# $secretsjsonPath = Join-Path -Path $PSScriptRoot -ChildPath "secrets.json"
# $secrets = Get-Content -Path $secretsjsonPath | ConvertFrom-Json

# # Variables from JSON file
# $tenantId = $secrets.tenantId
# $clientId = $secrets.clientId
# $clientSecret = $secrets.clientSecret


function Get-ModulesScriptPathsAndVariables {
    

    <#
    .SYNOPSIS
    Dot-sources all PowerShell scripts in the 'Modules' folder relative to the script root.
    
    .DESCRIPTION
    This function finds all PowerShell (.ps1) scripts in a 'Modules' folder located in the script root directory and dot-sources them. It logs the process, including any errors encountered, with optional color coding.
    
    .EXAMPLE
    Dot-SourceModulesScripts
    
    Dot-sources all scripts in the 'Modules' folder and logs the process.
    
    .NOTES
    Ensure the Write-EnhancedLog function is defined before using this function for logging purposes.
    #>
    param (
        [string]$BaseDirectory
    )
    
    try {
        $ModulesFolderPath = Join-Path -Path $BaseDirectory -ChildPath "Modules"
            
        if (-not (Test-Path -Path $ModulesFolderPath)) {
            throw "Modules folder path does not exist: $ModulesFolderPath"
        }
    
        # Construct and return a PSCustomObject
        return [PSCustomObject]@{
            BaseDirectory     = $BaseDirectory
            ModulesFolderPath = $ModulesFolderPath
        }
    }
    catch {
        Write-Host "Error in finding Modules script files: $_" -ForegroundColor Red
        # Optionally, you could return a PSCustomObject indicating an error state
        # return [PSCustomObject]@{ Error = $_.Exception.Message }
    }
}

# Retrieve script paths and related variables
$DotSourcinginitializationInfo = Get-ModulesScriptPathsAndVariables -BaseDirectory $PSScriptRoot

# $DotSourcinginitializationInfo
$DotSourcinginitializationInfo | Format-List


# Example of how to use the function
# $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$EnhancedLoggingAO = Join-Path -Path $PSScriptRoot -ChildPath "Modules\EnhancedLoggingAO\2.5.0\EnhancedLoggingAO.psm1"
$EnhancedGraphAO = Join-Path -Path $PSScriptRoot -ChildPath "Modules\EnhancedGraphAO\2.5.0\EnhancedGraphAO.psm1"




function Import-ModuleWithRetry {
    <#
    .SYNOPSIS
    Imports a PowerShell module with retries on failure.

    .DESCRIPTION
    This function attempts to import a specified PowerShell module, retrying the import process up to a specified number of times upon failure. It also checks if the module path exists before attempting to import.

    .PARAMETER ModulePath
    The path to the PowerShell module file (.psm1) that should be imported.

    .PARAMETER MaxRetries
    The maximum number of retries to attempt if importing the module fails. Default is 3.

    .PARAMETER WaitTimeSeconds
    The number of seconds to wait between retry attempts. Default is 2 seconds.

    .EXAMPLE
    $modulePath = "C:\Modules\MyPowerShellModule.psm1"
    Import-ModuleWithRetry -ModulePath $modulePath

    Tries to import the module located at "C:\Modules\MyPowerShellModule.psm1", with up to 3 retries, waiting 2 seconds between each retry.

    .NOTES
    This function requires the `Write-EnhancedLog` function to be defined in the script for logging purposes.

    .LINK
    Write-EnhancedLog
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$ModulePath,

        [int]$MaxRetries = 3,

        [int]$WaitTimeSeconds = 2
    )

    Begin {
        $retryCount = 0
        $isModuleLoaded = $false
        Write-Host "Starting to import module from path: $ModulePath"
        
        # Check if the module file exists before attempting to load it
        if (-not (Test-Path -Path $ModulePath -PathType Leaf)) {
            Write-Host "The module path '$ModulePath' does not exist."
            return
        }
    }

    Process {
        while (-not $isModuleLoaded -and $retryCount -lt $MaxRetries) {
            try {
                Import-Module $ModulePath -ErrorAction Stop
                $isModuleLoaded = $true
                Write-EnhancedLog -Message "Module: $ModulePath imported successfully." -Level "INFO"
            }
            catch {
                $errorMsg = $_.Exception.Message
                Write-Host "Attempt $retryCount to load module failed: $errorMsg Waiting $WaitTimeSeconds seconds before retrying."
                Write-Host "Attempt $retryCount to load module failed with error: $errorMsg"
                Start-Sleep -Seconds $WaitTimeSeconds
            }
            finally {
                $retryCount++
            }

            if ($retryCount -eq $MaxRetries -and -not $isModuleLoaded) {
                Write-Host "Failed to import module after $MaxRetries retries."
                Write-Host "Failed to import module after $MaxRetries retries with last error: $errorMsg"
                break
            }
        }
    }

    End {
        if ($isModuleLoaded) {
            Write-EnhancedLog -Message "Module: $ModulePath loaded successfully." -Level "INFO"
        }
        else {
            Write-Host -Message "Failed to load module $ModulePath within the maximum retry limit."
        }
    }
}


# Call the function to import the module with retry logic
Import-ModuleWithRetry -ModulePath $EnhancedLoggingAO
Import-ModuleWithRetry -ModulePath $EnhancedGraphAO

# Import-Module "E:\Code\CB\Entra\ARH\Private\EnhancedGraphAO\2.0.0\EnhancedGraphAO.psm1" -Verbose


# ################################################################################################################################
# ################################################ END MODULE LOADING ############################################################
# ################################################################################################################################




# Usage
try {
    Ensure-LoggingFunctionExists
    # Continue with the rest of the script here
    # exit
}
catch {
    Write-Host "Critical error: $_" -ForegroundColor Red
    exit
}

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################

# Setup logging
Write-EnhancedLog -Message "Importing Modules with Import-ModuleWithRetry" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################


$EnhancedGraphAO = Join-Path -Path $PSScriptRoot -ChildPath "Modules\EnhancedGraphAO\2.5.0\EnhancedGraphAO.psm1"
Import-ModuleWithRetry -ModulePath $EnhancedGraphAO


#Region #########################################DEALING WITH MODULES########################################################


# Function to validate if a module is available
function Validate-Module {
    param (
        [string]$ModuleName
    )
    return $null -ne (Get-Module -ListAvailable -Name $ModuleName)
}

# Function to install required modules
function Install-Modules {
    param (
        [array]$Modules
    )

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

    foreach ($module in $Modules) {
        if (-not (Validate-Module -ModuleName $module)) {
            Write-EnhancedLog -Message "Installing module: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
            Install-Module -Name $module -Force -Scope AllUsers
            Write-EnhancedLog -Message "Module: $module has been installed" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        }
        else {
            Write-EnhancedLog -Message "Module $module is already installed" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
        }

        # Validate after installation
        if (Validate-Module -ModuleName $module) {
            Write-EnhancedLog -Message "Validation successful: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
        }
        else {
            Write-EnhancedLog -Message "Validation failed: $module" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        }
    }
}

# Function to import required modules
function Import-Modules {
    param (
        [array]$Modules
    )

    foreach ($module in $Modules) {
        if (Validate-Module -ModuleName $module) {
            Write-EnhancedLog -Message "Importing module: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
            Import-Module -Name $module
            Write-EnhancedLog -Message "Module: $module has been imported" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

            # Validate after importing
            if (Validate-Module -ModuleName $module) {
                Write-EnhancedLog -Message "Validation successful: $module" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
            }
            else {
                Write-EnhancedLog -Message "Validation failed: $module" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
            }
        }
    }
}

# Main script execution
function Main {
    # Read modules from module.json file
    $moduleJsonPath = "$PSscriptroot/modules.json"
    if (Test-Path -Path $moduleJsonPath) {
        $moduleData = Get-Content -Path $moduleJsonPath | ConvertFrom-Json
        $requiredModules = $moduleData.requiredModules
        $importedModules = $moduleData.importedModules

        # Validate, Install, and Import Modules
        Install-Modules -Modules $requiredModules
        Import-Modules -Modules $importedModules
    }
    else {
        Write-EnhancedLog -Message "modules.json file not found." -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
    }
}

# Execute main function
Main

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
#     Write-EnhancedLog -Message "App does not exist" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
# }




# Create App Registration
function Create-AppRegistration {
    param (
        [string]$AppName,
        [string]$PermsFile = "$PSScriptRoot/perms.json"
    )

    if (-Not (Test-Path $PermsFile)) {
        Write-EnhancedLog -Message "Permissions file not found: $PermsFile" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw "Permissions file missing"
    }

    $permissions = Get-Content -Path $PermsFile | ConvertFrom-Json

    # Connect to Graph interactively
    Connect-MgGraph -Scopes "Application.ReadWrite.All"

    # Get tenant details
    $tenantDetails = Get-MgOrganization | Select-Object -First 1

    # Create the application
    $app = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -RequiredResourceAccess $permissions

    if ($null -eq $app) {
        Write-EnhancedLog -Message "App registration failed" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
        throw "App registration failed"
    }

    Write-EnhancedLog -Message "App registered successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)
    return @{ App = $app; TenantDetails = $tenantDetails }
}

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
}

# Main script execution
Write-EnhancedLog -Message "Script Started" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

try {
    # Get the unique app name
    $appName = Get-AppName -AppJsonFile "$PSScriptRoot/app.json"


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
        Write-EnhancedLog -Message "App does not exist" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
    }


    # Create the app registration
    $appDetails = Create-AppRegistration -AppName $appName
    $app = $appDetails.App
    $tenantDetails = $appDetails.TenantDetails
    
    # Example usage
    # $AppName = "YourAppName"
    # $JsonPath = "C:\path\to\your\jsonfile.json"
    Write-EnhancedLog -Message 'calling Validate-AppCreationWithRetry for the second validation'
    Validate-AppCreationWithRetry -AppName $AppName -JsonPath $JsonPath
    

    # Create the self-signed certificate with tenant and app details
    $cert = Create-SelfSignedCert -CertName "GraphCert" -TenantName $tenantDetails.DisplayName -AppId $app.AppId
    $thumbprint = $cert.Thumbprint

    # Export the certificate to a file
    # $certPath = $null
    # $certPath = Export-CertificateToFile -Certificate $cert -ExportPath "$PSScriptRoot" -FileName "GraphCert"
    # $certPath = "C:\Code\Unified365toolbox\Graph\GraphCert.cer"
    # $certPath = Export-CertificateToFile -Certificate $cert -ExportPath "$PSScriptRoot"

    # Call the function with the required parameters
    # Define the variables
    $certThumbprint = $thumbprint 
    $exportDirectory = "$PSScriptRoot"

    # $exportedCertPath = ExportCertificatetoFile -CertThumbprint $certThumbprint -ExportDirectory $exportDirectory
    $certPath = ExportCertificatetoFile -CertThumbprint $certThumbprint -ExportDirectory $exportDirectory

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
    # $appId = "c665c660-1d09-4d94-a1e0-06a0dd512285"
    # $certPath = "C:\Code\Unified365toolbox\Graph\GraphCert.cer"
    # $certPath = $certPath


    # Example usage
    # $appId = "dfde17fe-a9fd-4925-a035-5a23cf53be9d"
    $permissionsFilePath = Join-Path -Path $PSScriptRoot -ChildPath "permissions.json"
    Update-ApplicationPermissions -appId $appId -permissionsFile $permissionsFilePath

    # Call the function to Associate the Cert With App
    Add-KeyCredentialToApp -AppId $appId -CertPath $certPath




    # Open the certificate store
    Start-Process certmgr.msc

    # Output the secrets
    Output-Secrets -AppDisplayName $app.DisplayName -ApplicationID $app.AppId -Thumbprint $thumbprint -TenantID $tenantDetails.Id
    Write-EnhancedLog -Message "Script Completed Successfully" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)
}
catch {
    Write-EnhancedLog -Message "Script failed: $_" -Level "ERROR" -ForegroundColor ([ConsoleColor]::Red)
}


# Get-MgApplication 



# List all applications
#  Write-Host "Listing all applications:"
#  Validate-AppCreation
#  $allApps | Format-Table Id, DisplayName, AppId, SignInAudience, PublisherDomain -AutoSize

#  Get-MgApplication 