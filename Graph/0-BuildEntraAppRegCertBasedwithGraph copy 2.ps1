#!ToDO work on creatng a function for importing all modules in the modules folders without specifying the path of each module.
#fix permissions of the client app to add Intune permissions

# Load the secrets from the JSON file
#First, load secrets and create a credential object:
# Assuming secrets.json is in the same directory as your script
$certsecretsPath = Join-Path -Path $PSScriptRoot -ChildPath "certsecrets.json"

# Load the secrets from the JSON file
$certsecrets = Get-Content -Path $certsecretsPath -Raw | ConvertFrom-Json

# Read configuration from the JSON file
# Assign values from JSON to variables

# Read configuration from the JSON file
$configPath = Join-Path -Path $PSScriptRoot -ChildPath "config.json"
$env:MYMODULE_CONFIG_PATH = $configPath

$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

#  Variables from JSON file
$CertPassword = $certsecrets.certexportpassword

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
            $global:modulesBasePath = "C:\code\modules"
            if (-Not (Test-Path $global:modulesBasePath)) {
                $global:modulesBasePath = "$PSScriptRoot\modules"
            }
            if (-Not (Test-Path $global:modulesBasePath)) {
                $global:modulesBasePath = "$PSScriptRoot\modules"
                Download-Modules -destinationPath $global:modulesBasePath
            }
        }
    }

    function Download-Modules {
        param (
            [string]$repoUrl = "https://github.com/aollivierre/modules/archive/refs/heads/main.zip",
            [string]$destinationPath
        )

        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        $tempExtractPath = "$env:TEMP\modules-$timestamp"
        $zipPath = "$env:TEMP\modules.zip"

        Write-Host "Downloading modules from GitHub..."
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath
        Expand-Archive -Path $zipPath -DestinationPath $tempExtractPath -Force
        Remove-Item -Path $zipPath

        $extractedFolder = Join-Path -Path $tempExtractPath -ChildPath "modules-main"
        if (Test-Path $extractedFolder) {
            Write-Host "Copying extracted modules to $destinationPath"
            robocopy $extractedFolder $destinationPath /E
            Remove-Item -Path $tempExtractPath -Recurse -Force
        }

        # $DBG

        Write-Host "Modules downloaded and extracted to $destinationPath"
    }

    function Setup-WindowsEnvironment {
        # Get the base paths from the global variables
        Setup-GlobalPaths

        # Construct the paths dynamically using the base paths
        $modulePath = Join-Path -Path $global:modulesBasePath -ChildPath $WindowsModulePath

        $global:modulePath = $modulePath
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
        $global:AOscriptDirectory = Convert-WindowsPathToLinuxPath -WindowsPath "$PSscriptroot"
        $global:directoryPath = Convert-WindowsPathToLinuxPath -WindowsPath "$PSscriptroot\Win32Apps-DropBox"
        $global:Repo_Path = Convert-WindowsPathToLinuxPath -WindowsPath "$PSscriptroot"
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


try {

    # Check if C:\code\modules exists
    if (Test-Path "C:\code\modules") {
        $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "C:\code\modules" -UnixPath "/usr/src/code/modules"
    }
    else {
        $ModulesFolderPath = Get-ModulesFolderPath -WindowsPath "$PsScriptRoot\modules" -UnixPath "$PsScriptRoot/modules"
    }

    Write-Host "Modules Folder Path: $ModulesFolderPath"

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
    # Ensure-LoggingFunctionExists -LoggingFunctionName "# Write-EnhancedLog"
    # Continue with the rest of the script here
    # exit
}
catch {
    Write-Host "Critical error: $_" -ForegroundColor Red
    exit
}

###############################################################################################################################
###############################################################################################################################
###############################################################################################################################

# Setup logging
Write-EnhancedLog -Message "Script Started" -Level "INFO"

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
# Path to the scopes.json file
$jsonFilePath = "$PSscriptroot\scopes.json"

# Read the JSON file
$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

# Extract the scopes
$scopes = $jsonContent.Scopes -join " "

# Connect to Microsoft Graph with the specified scopes
# Connect to Graph interactively
Disconnect-MgGraph -Verbose

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
    Run-DumpAppListToJSON -JsonPath $jsonPath
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
    $secretsFolder = Join-Path -Path "$tenantFolder" -ChildPath "secrets"

    # Check if the folder exists
    if (Test-Path -Path "$secretsFolder") {
        # Remove the existing folder and its contents
        Remove-Item -Path "$secretsFolder" -Recurse -Force
        Write-Host "Removed existing secrets folder: $secretsFolder"
    }
    
    # Create a new folder
    New-Item -ItemType Directory -Path "$secretsFolder" -Force | Out-Null
    Write-Host "Created new secrets folder: $secretsFolder"
    


    # $Certname = "GraphCert-$($tenantDetails.DisplayName)-$($app.AppId)"
    $Certname = "GraphCert-$($apptenantDetails.DisplayName)"
    # Define the parameters as a hashtable
    $params = @{
        CertName    = $Certname
        TenantName  = $apptenantDetails.DisplayName
        AppId       = $app.AppId
        OutputPath  = "$secretsFolder"
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
    $certPath = ExportCertificatetoCER -CertThumbprint $certThumbprint -ExportDirectory $secretsFolder -Certname $Certname

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
    $SecretsFile = Join-Path -Path $secretsFolder -ChildPath "secrets.json"

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
        OutputPath       = $secretsFolder
    }

    # Call the function using splatting
    Output-Secrets @params

    Write-EnhancedLog -Message "Script Completed Successfully" -Level "INFO"
}
catch {
    Write-EnhancedLog -Message "Script failed: $_" -Level "ERROR"
    Handle-Error -ErrorRecord $_
}