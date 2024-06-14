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





if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

Set-ExecutionPolicy -ExecutionPolicy unrestricted -Confirm:$false -Force

#region Function Get-AzureKeyVaultSecre
function Get-AzureKeyVaultSecret {
    [CmdletBinding()]
    param (
        
    )
    
    begin {

        ## Get Start Time 
        $startDTM = (Get-Date)

        $PermissionsToCertificates = @()
        $PermissionsToKeys = @()
        $PermissionsToSecrets = @()

        $PermissionsToCertificates = @( 
            "Get",
            "List",
            "Delete",
            "Create",
            "Import",
            "Update",
            "Managecontacts",
            "Getissuers",
            "Listissuers",
            "Setissuers",
            "Deleteissuers",
            "Manageissuers",
            "Recover",
            "Backup",
            "Restore",
            "Purge"
        )
        $PermissionsToKeys = @(
        
         
            "Decrypt",
            "Encrypt",
            "UnwrapKey",
            "WrapKey", "Verify",
            "Sign", "Get", "List",
            "Update",
            "Create",
            "Import",
            "Delete",
            "Backup",
            "Restore",
            "Recover",
            "Purge"
        
        
        )
        $PermissionsToSecrets = @(
        
            "Get",
            "List",
            "Set",
            "Delete",
            "Backup",
            "Restore",
            "Recover",
            "Purge"
        
        )
        
        #Subscription Name
        $subscriptionName = ""
        $subscriptionName = 'Microsoft Partner Network'
        
        #Resource Group Name
        $RGname = ""
        $RGname = "KeyVaultGroup"
        
        # Key Vault Name
        $vaultname = ""
        $vaultname = "CorpVault"
        
        #AzAdGroup Name
        $AzAdGroupName = ""
        $AzAdGroupName = 'KeyvaultTeam'
        
        # Secret Name
        $SecretName = ""
        $SecretName = "Application Password"

        # Secret Value
        $Prompt = ""
        $Prompt = "Enter Secret Value to be stored in the Azure Vault Named $vaultname"

        $SecretValue = ""
        $SecretValue = Read-Host -Prompt $Prompt -AsSecureString

        #Location Name
        $location = ""
        $location = "Canada Central"

        $SetAzKeyVaultAccessPolicyParam = 
            
        @{
            VaultName                 = $vaultName
            ObjectID                  = (Get-AzAdGroup -SearchString $AzAdGroupName)[0].Id
            PermissionstoCertificates = $PermissionsToCertificates
            PermissionsToKeys         = $PermissionsToKeys
            PermissiontoSecrets       = $PermissionsToSecrets
            PassThru                  = $true
        }
        
        $currentAzureContext = Get-AzContext
        $AzureSubscription = Get-AzSubscription
    }
    
    process {


        try {


            If (!($currentAzureContext)) {
                Write-Host "No Azure Context is available in the session" -ForegroundColor Green
                Write-Host "Connecting to Azure" -ForegroundColor Green
                Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
                Connect-AzAccount
            }
            
            Write-Host "Azure Context was found in the session" -ForegroundColor Green
            Write-Host "Storing Context" -ForegroundColor Green
            $currentAzureContext = Get-AzContext
            $TenantId = $currentAzureContext.Tenant.Id
            $accountId = $currentAzureContext.Account.Id
            
            Write-Host "Connecting to Azure AD" -ForegroundColor Green
            Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
            Connect-AzureAD -TenantId $TenantId -AccountId $accountId

            if ($AzureSubscription) {

                #This step is important if you are doing things against Azure (not Azure AD)
                #For example creating Resources and querying resources in Azure
                Write-Host "Azure Subscription was found in the session" -ForegroundColor Green
                Write-Host "setting the Azure Context to the Subscription named" $subscriptionName -ForegroundColor Green
                $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
                Set-AzContext -SubscriptionId $subscriptionId
            }

            #Create Azure AD Group
            Write-Host "Creating Azure AD Group" -ForegroundColor Green
            New-AzureADGroup -DisplayName $AzAdGroupName -MailEnabled $True -SecurityEnabled $false -MailNickName $AzAdGroupName

            #Set Azure Conetxt to the proper subscription
            Write-Host "Setting Azure Conetxt to the named subscription" $subscriptionName -ForegroundColor Green
            $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
            Set-AzContext -SubscriptionId $subscriptionId
            
            #Create Resource Group for Azure Key Vault
            Write-Host "Creating a Resrouce Group Named" $RGname -ForegroundColor Green
            New-AzResourcegroup -Name $RGname -Location $location
            
            #Create Vault in Azure Key Vault
            Write-Host "Creating an Azure Key Vault named" $vaultname "under the Resrouce Group named" $RGname -ForegroundColor Green
            New-AzKeyVault -VaultName $vaultname -ResourceGroupName $RGname -Location $location #you should store the response of this command in a variable
            
            #Setup Permissions for the AzADGroup
            Write-Host "Setting Azure Key Vault" $vaultname "Access Policy for Azure AD Group" $AzAdGroupName -ForegroundColor Green
            Set-AzKeyVaultAccessPolicy $SetAzKeyVaultAccessPolicyParam
            
            #Create Secret in Vault
            Write-Host "Creating Azure Key Vault" $vaultname "Secret" $SecretName -ForegroundColor Green
            Set-AzKeyVaultSecret -VaultName $vaultname -Name $SecretName -SecretValue $SecretValue
            
            # Get Azure secrets from Key Vault
            Write-Host "Getting Azure Key Vault" $vaultname "Secret" $SecretName -ForegroundColor Green
            $Password = (Get-AzKeyVaultSecret -VaultName $vaultname -Name $SecretName).SecretValueText
            
        }
        catch {
            
        }
        finally {            
            ## Get End Time 
            $endDTM = (Get-Date)
             
            ## Echo Time elapsed 
            $Timemin = "Elapsed Time: $(($endDTM-$startDTM).totalminutes) minutes"
            $Timesec = "Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds"

            ## Provide time it took 
            Write-host "" 
            Write-host " Prcoess has been completed......" -fore Green -back black
            Write-host " Process took $Timemin       ......" -fore Blue
            Write-host " Process $Dest_PC took $Timesec        ......" -fore Blue
            
        }
        
    }
    
    end {
        
    }
}