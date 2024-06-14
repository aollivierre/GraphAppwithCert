#Step1 ensure PowershellGet is running the latest version to make the AllowPrerelease param available
$PSVersionTable.PSVersion
Get-module PowershellGet | Select-Object name, Version, ModuleBase
Import-Module PowershellGet
Find-module PowershellGet -AllowPrerelease -AllVersions
Install-Module PowershellGet -Force #https://evotec.xyz/install-module-a-parameter-cannot-be-found-that-matches-parameter-name-allowprerelease/
Install-Module -Name PowerShellGet -AllowPrerelease

Install-Module PowershellGet -Force
Get-module PackageManagement | Select-Object name, Version, ModuleBase
Import-Module PackageManagement

Find-module PackageManagement -AllowPrerelease -AllVersions


#I had issues using the -AllowPrerelease parameter in order to install the latest version of EditorServicesCommandSuite
#WARNING: The version '1.4.7' of module 'PackageManagement' is currently in use. Retry the operation after closing the applications.
#notice this is PackageManagement not PowershellGet