<#      
.NOTES
#===========================================================================  
# Script:  
# Created With: 
# Author:  
# Date: 
# Organization:  
# File Name: 
# Comments:
#===========================================================================  
.DESCRIPTION  
    
#>  

#region Function Copy-Process

# if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#     Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
# }

# $ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine

# if ($ExecutionPolicy -ne 'unrestricted') {

# Write-Host "The Execution Policy is currently set to" $ExecutionPolicy -ForegroundColor Magenta

#setting ExecutionPolicy to unrestricted" on all other scopes
# Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "MachinePolicy" -Confirm:$false -Force
# Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "UserPolicy" -Confirm:$false -Force
# Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "Process" -Confirm:$false -Force
# Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "CurrentUser" -Confirm:$false -Force


# Write-Host "Setting the Execution Policy to  unrestricted on the LocalMachine Scope" -ForegroundColor Magenta
# Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "LocalMachine" -Confirm:$false -Force

# #Re Collecting the $ExecutionPolicy value
# $ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine
# Write-Host "The Execution Policy is currently set to" $ExecutionPolicy "on the LocalMachine Scope" -ForegroundColor green
# }

. "$PSScriptRoot\Fault_Tolerance_CleanupAzSessions.ps1"

function Fault_Tolerance_Connect-AzAccountwithContext {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $subscriptionName

        
    
    )
    
    begin {

        # $TenantID_9001 = $null
        # $currentAzureContext = $null
        # $currentAzureContext = Get-AzContext
        # $AzureSubscription = $null
        # $subscriptionName = $null
        # $AccountID_9001 = $null
        
    }
    
    process {

        try {

            # if ((Get-Module -Name "Az" -ListAvailable -all)) {
                # If (!($currentAzureContext)) {
                    Write-Host "No Azure Context is available in the session" -ForegroundColor Green
                    Write-Host "Connecting to Azure" -ForegroundColor Green
                    Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
                    # Connect-AzAccount | Out-Null
                    Connect-AzAccount
                # }
                
                # $AzureSubscription = Get-AzSubscription
                # if ($AzureSubscription) {
    
                    # This step is important if you are doing things against Azure (not Azure AD)
                    # For example creating Resources and querying resources in Azure
                    Write-Host "Azure Subscription was found in the session" -ForegroundColor Green
                    Write-Host "setting the Azure Context to the Subscription named" $subscriptionName -ForegroundColor Green
                    $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
                    Set-AzContext -SubscriptionId $subscriptionId
                # }
    
                Write-Host "Azure Context was found in the session" -ForegroundColor Green
                Write-Host "Storing Context" -ForegroundColor Green
                $currentAzureContext = Get-AzContext
                
    
    
                # $TenantID_9001 = $currentAzureContext.Tenant.Id
                Write-Host 'Current Tenant ID is' $TenantID
    
                # $AccountID_9001 = $currentAzureContext.Account.Id
            # }
                    

            
        }
        catch {
            
            Write-Error 'There was an error with Connecting to Azure... halting execution'

            #Region CatchAll

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
            # Write-Host $PSItem -ForegroundColor Red
            $PSItem
            Write-Host $PSItem.ScriptStackTrace -ForegroundColor Red
 
 
            $ErrorMessage_1 = $_.Exception.Message
            write-host $ErrorMessage_1  -ForegroundColor Red
            Write-Output "Ran into an issue: $PSItem"
            Write-host "Ran into an issue: $PSItem" -ForegroundColor Red
            throw "Ran into an issue: $PSItem"
            throw "I am the catch"
            throw "Ran into an issue: $PSItem"
            $PSItem | Write-host -ForegroundColor
            $PSItem | Select-Object *
            $PSCmdlet.ThrowTerminatingError($PSitem)
            throw
            throw "Something went wrong"
            Write-Log $PSItem.ToString()

            #endregion CatchAll

            exit
        
        }
        finally {
            
        }
        
    }
    
    end {

        
        # return $TenantID_9001, $AccountID_9001
        # return $TenantID_9001
        return $currentAzureContext
    }
}

function Fault_Tolerance_Connect-AzureADfromAzContext {
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $subscriptionName,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $TenantID,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]
    $AccountID

)
    
    begin {

        # write-host "running az func"
        # $ConnectAzAccountwithContextReturn = $null
        # $ConnectAzAccountwithContextReturn = Fault_Tolerance_Connect-AzAccountwithContext -subscriptionName $subscriptionName
        # $ConnectAzAccountwithContextReturn

        # $TenantID = $ConnectAzAccountwithContextReturn[0]


        # $AccountID = $ConnectAzAccountwithContextReturn[1]

        # Get Start Time 
        # $startDTM = (Get-Date)


        # Closes one or more PowerShell sessions
        # Get-PSSession | Remove-PSSession -Verbose
        # Get-AzContext -ListAvailable:$True | Remove-AzContext -Force
        # Get-AzContext -ListAvailable:$True | Clear-AzContext -Force
        # Clear-AzContext -Force
        # Get-AzContext  -ListAvailable:$True | Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzAccount -Scope CurrentUser
        # Disconnect-AzureAD
        # Set-AzContext -Context ([Microsoft.Azure.Commands.Profile.Models.Core.PSAzureContext]::new())
        # Get-AzDefault | Clear-AzDefault
        # Disable-AzContextAutosave 

        # $AzureADModuleExist = Get-Module -Name -ListAvailable "AzureAD"
        # if (!($AzureADModuleExist)) {

        #     Write-Host "No Azure Context is available in the session" -ForegroundColor Green
        #     # Azure Active Directory PowerShell for Graph module
        #     Install-Module -Name "AzureAD" -Verbose -Force -AllowClobber
        #     Import-Module -Name "AzureAD" -Verbose -Force
        #     Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version, ModuleBase
        # }


        # Check if the Azure AD PowerShell module has already been loaded.
        if ( ! ( $AzModuleExist ) ) {
            # Check if the Azure AD PowerShell module is installed.
            if ( Get-Module -ListAvailable -Name AzureAD ) {
                # The Azure AD PowerShell module is not load and it is installed. This module
                # must be loaded for other operations performed by this script.
                Write-Host -ForegroundColor Green "Loading the Azure AD PowerShell module..."
                #    Install-Module -Name "AzureAD" -Verbose -Force -AllowClobber
                Install-Module -Name "AzureAD" -Force -AllowClobber
                # Import-Module -Name "AzureAD" -Verbose -Force
                Import-Module -Name "AzureAD" -Force
                Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version, ModuleBase
            }
            else {
                Write-Host -ForegroundColor Green "Loading the Azure AD PowerShell module..."
                #    Install-Module -Name "AzureAD" -Verbose -Force -AllowClobber
                Install-Module -Name "AzureAD" -Force -AllowClobber
                # Import-Module -Name "AzureAD" -Verbose -Force
                Import-Module -Name "AzureAD" -Force
                Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version, ModuleBase
            }
        }

        
        # $TenantID = $null
        # $AccountID = $null

    }
    
    process {


        try {

            
            Write-Host "Connecting to Azure AD" -ForegroundColor Green
            # Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
            # Connect-AzureAD -TenantId $Global:TenantId_9001 -AccountId $accountId


            

                Write-Host "Connecting to Azure AD" -ForegroundColor Green
                Write-Host -ForegroundColor Green "When prompted please enter the appropriate credentials... Warning: Window might have pop-under in VSCode"

                Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green

                <#
                           if ([string]::IsNullOrEmpty($Global:TenantId_9001)) {
                    Connect-AzureAD | Out-Null

                    $Global:TenantId_9001 = $null
                    $Global:TenantId_9001 = $(Get-AzureADTenantDetail).ObjectId
                }
                else {
                    # Connect-AzureAD -TenantId $Global:TenantId_9001 | Out-Null

                    Connect-AzureAD -TenantId $Global:TenantId_9001 -AccountId $accountId | Out-Null
                }
                #>

                
        

                # Connect-AzureAD -TenantId $Global:TenantId_9001 -AccountId $accountId | Out-Null
                Connect-AzureAD -TenantId $TenantID -AccountId $AccountID | Out-Null
                # $Global:TenantId_9001 = $null
                # $Global:TenantId_9001 = $(Get-AzureADTenantDetail).ObjectId
     
            
            # catch [Microsoft.Azure.Common.Authentication.AadAuthenticationCanceledException] {}

              
        }
        catch {

                 # The authentication attempt was canceled by the end-user. Execution of the script should be halted.
                 Write-Error 'An error happened while connecting to Azure AD.. halting script execution'

                       
   #Region CatchAll

   Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
   Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
   # Write-Host $PSItem -ForegroundColor Red
   $PSItem
   Write-Host $PSItem.ScriptStackTrace -ForegroundColor Red
 
 
   $ErrorMessage_1 = $_.Exception.Message
   write-host $ErrorMessage_1  -ForegroundColor Red
   Write-Output "Ran into an issue: $PSItem"
   Write-host "Ran into an issue: $PSItem" -ForegroundColor Red
   throw "Ran into an issue: $PSItem"
   throw "I am the catch"
   throw "Ran into an issue: $PSItem"
   $PSItem | Write-host -ForegroundColor
   $PSItem | Select-Object *
   $PSCmdlet.ThrowTerminatingError($PSitem)
   throw
   throw "Something went wrong"
   Write-Log $PSItem.ToString()

   #endregion CatchAll
             
                 Exit
            
        }
        finally {


            
            # # Get End Time 
            # $endDTM = (Get-Date)
             
            # ## Echo Time elapsed 
            # $Timemin = "Elapsed Time: $(($endDTM-$startDTM).totalminutes) minutes"
            # $Timesec = "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"

            # ## Provide time it took 
            # Write-host "" 
            # Write-host " Prcoess has been completed......" -fore Green -back black
            # Write-host " Process took $Timemin       ......" -fore Blue
            # Write-host " Process $Dest_PC took $Timesec        ......" -fore Blue
            
        }
        
    }
    
    end {

        
 
        
    }
}

# Fault_Tolerance_Connect-AzureADfromAzContext











#usage
# Fault_Tolerance_CleanupAzSessions

# write-host "running az func"
# $ConnectAzAccountwithContextReturn = $null
# $ConnectAzAccountwithContextReturn = Fault_Tolerance_Connect-AzAccountwithContext -subscriptionName 'Microsoft Azure'
# # $ConnectAzAccountwithContextReturn | gm

# # $TenantID = $ConnectAzAccountwithContextReturn[0].$TenantID
# $TenantID = ($ConnectAzAccountwithContextReturn).tenant.id

# # $AccountID = $ConnectAzAccountwithContextReturn[1]
# $AccountID = ($ConnectAzAccountwithContextReturn).account.id

# Fault_Tolerance_Connect-AzureADfromAzContext -TenantID $TenantID -AccountID $AccountID -SubscriptionName 'Microsoft Azure'