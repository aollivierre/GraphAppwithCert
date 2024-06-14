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

#Step2 install and import the module

Install-Module -Name EditorServicesCommandSuite -Scope CurrentUser
# Install-Module -Name EditorServicesCommandSuite -MinimumVersion '1.0.0-beta3' -AllowPrerelease
Install-Module -Name EditorServicesCommandSuite -AllowPrerelease

Find-Module EditorServicesCommandSuite -AllowPrerelease -AllVersions

#Step3 add it to the your VS Code Power Shell Porofile

# Place this in your VSCode profile
Import-Module EditorServicesCommandSuite
Import-EditorCommand -Module EditorServicesCommandSuite
# Get-Module EditorServicesCommandSuite -ListAvailable -All | Select-Object name, Version, ModuleBase
Get-Module EditorServicesCommandSuite | Select-Object name, Version, ModuleBase

Uninstall-Module EditorServicesCommandSuite

#Initialize the $PSprofile vs in the path saved in the $Profile variable
# https://wagthereal.com/2017/08/25/visual-studio-code-powershell-profile/
notepad $profile

# Place this in your VSCode profile
# Import-CommandSuite

# Or copy this command and paste it into the integrated console
New-Item -ItemType File $profile
psedit $profile;$psEditor|% g*t|% c*e|% i* "Import-CommandSuite`n" 1 1 1 1