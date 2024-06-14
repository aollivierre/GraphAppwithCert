       # Closes one or more PowerShell sessions
       Get-PSSession | Remove-PSSession | Out-Null

       
               if (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) {

           Get-InstalledModule *sharepoint* | Uninstall-Module -AllVersions -Force
           Get-Package *sharepoint* | Uninstall-Package -Force -AllVersions
           Uninstall-Package -Name SharePointPnPPowerShellOnline -Force -AllVersions
           Uninstall-Package -Name Microsoft.Online.SharePoint.PowerShell -Force -AllVersions
          

           Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable -all | Uninstall-Module -Allversions -Force
           Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
           Import-Module Microsoft.Online.SharePoint.PowerShell -Force
           Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable | Select-object Name, Version
   
       } 
       else {
           Write-Host "Module does not exist"
           Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Force
           Import-Module Microsoft.Online.SharePoint.PowerShell -Force
       }


       if (Get-Module -ListAvailable -Name SharePointPnPPowerShellOnline) {

           Get-Module -Name SharePointPnPPowerShellOnline -ListAvailable -all | Uninstall-Module -Allversions -Force
           Install-Module -Name SharePointPnPPowerShellOnline -Force
           Import-Module SharePointPnPPowerShellOnline -Force
           Get-Module -Name SharePointPnPPowerShellOnline -ListAvailable | Select-object Name, Version
       } 
       else {
           Write-Host "Module does not exist"
           Install-Module -Name SharePointPnPPowerShellOnline -Force
           Import-Module SharePointPnPPowerShellOnline -Force
       
       }
       

       Import-Module Microsoft.Online.SharePoint.PowerShell -Force
       Import-Module SharePointPnPPowerShellOnline -Force