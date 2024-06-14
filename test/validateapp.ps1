#!ToDO work on creatng a function for importing all modules in the modules folders without specifying the path of each module.
#fix permissions of the client app to add Intune permissions


# Read configuration from the JSON file
# Assign values from JSON to variables

# Read configuration from the JSON file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
$env:MYMODULE_CONFIG_PATH = $configPath



# Load client secrets from the JSON file
$secretsjsonPath = Join-Path -Path $PSScriptRoot -ChildPath "secrets.json"
$secrets = Get-Content -Path $secretsjsonPath | ConvertFrom-Json

# Variables from JSON file
$tenantId = $secrets.tenantId
$clientId = $secrets.clientId
$clientSecret = $secrets.clientSecret


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
Write-EnhancedLog -Message "Script Started" -Level "INFO" -ForegroundColor ([ConsoleColor]::Cyan)

# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################


# $EnhancedGraphAO = Join-Path -Path $PSScriptRoot -ChildPath "Modules\EnhancedGraphAO\2.0.0\EnhancedGraphAO.psm1"
# Import-ModuleWithRetry -ModulePath $EnhancedGraphAO





# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################



# Call the function to install the required modules and dependencies
# Install-RequiredModules
# Write-EnhancedLog -Message "All modules installed" -Level "INFO" -ForegroundColor ([ConsoleColor]::Green)


# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################


# Example call to the function
$accessToken = Get-MsGraphAccessToken -tenantId $tenantId -clientId $clientId -clientSecret $clientSecret


# ################################################################################################################################
# ################################################################################################################################
# ################################################################################################################################






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

# Install the Microsoft.Graph.Applications module if not already installed
Install-Module -Name Microsoft.Graph.Applications -Scope CurrentUser

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.ReadWrite.All"

# Define the application ID
$appId = "c665c660-1d09-4d94-a1e0-06a0dd512285"

# Read the certificate file using the constructor
$certPath = "C:\Code\Unified365toolbox\Graph\GraphCert.cer"
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath)
$certBytes = $cert.RawData
$base64Cert = [System.Convert]::ToBase64String($certBytes)

# Convert certificate dates to DateTime and adjust for time zone
$startDate = [datetime]::Parse($cert.NotBefore.ToString("o"))
$endDate = [datetime]::Parse($cert.NotAfter.ToString("o"))

# Adjust the start and end dates to ensure they are valid and in UTC
$startDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($startDate, [System.TimeZoneInfo]::Local.Id, 'UTC')
$endDate = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId($endDate, [System.TimeZoneInfo]::Local.Id, 'UTC')

# Adjust end date by subtracting one day to avoid potential end date issues
$endDate = $endDate.AddDays(-1)

# Prepare the key credential parameters
$keyCredentialParams = @{
    CustomKeyIdentifier = [System.Convert]::FromBase64String([System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($cert.Thumbprint.Substring(0, 32))))
    DisplayName = "GraphCert"
    EndDateTime = $endDate
    StartDateTime = $startDate
    KeyId = [Guid]::NewGuid().ToString()
    Type = "AsymmetricX509Cert"
    Usage = "Verify"
    Key = $certBytes
}

# Create the key credential object
$keyCredential = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphKeyCredential]::new()
$keyCredential.CustomKeyIdentifier = $keyCredentialParams.CustomKeyIdentifier
$keyCredential.DisplayName = $keyCredentialParams.DisplayName
$keyCredential.EndDateTime = $keyCredentialParams.EndDateTime
$keyCredential.StartDateTime = $keyCredentialParams.StartDateTime
$keyCredential.KeyId = $keyCredentialParams.KeyId
$keyCredential.Type = $keyCredentialParams.Type
$keyCredential.Usage = $keyCredentialParams.Usage
$keyCredential.Key = $keyCredentialParams.Key

# Update the application with the new key credential
try {
    Update-MgApplication -ApplicationId $appId -KeyCredentials @($keyCredential)
    Write-Host "Key credential added successfully to the application."
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
