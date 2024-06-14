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


# Closes one or more PowerShell sessions
# Get-PSSession | Remove-PSSession -Verbose
# Get-AzContext | Disconnect-AzAccount -Scope CurrentUser
# Get-AzContext | Disconnect-AzAccount
# Disconnect-AzureAD

#region Function Invoke-Robocopy

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

Set-ExecutionPolicy -ExecutionPolicy unrestricted -Confirm:$false -Force

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
        
        # read-host -AsSecureString | ConvertFrom-SecureString | out-file C:\R\passphrase_encrypted.txt
        # $Secret = Get-Content C:\R\passphrase_encrypted.txt | ConvertTo-SecureString

        # $Secret = Read-Host -Prompt "Enter password" -AsSecureString | ConvertTo-SecureString
        # $Secret = ""
        # $Secret = Read-Host -Prompt "Enter password" -AsSecureString
        # $Secret = Get-Credential

        # $Secret = 'Whatever your password is'
        # $SecretValue = ConvertTo-SecureString -String $Secret


        # $adminUPN = "abdullah@canadacomputing.ca"
        # $O365password = "Whatever your password is"
        # $O365passwordsec = ConvertTo-SecureString $O365password -AsPlainText -Force
        # $O365passwordsec = $Secret
        # $credential = ""
        # $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList ($adminUPN, $O365passwordsec)


        Write-Host "Getting Credentials interactively to login to Azure AD" -ForegroundColor Green
        Write-Host "Please enter your office 365 credentials" -ForegroundColor Green
        # $credential = ""
        # $Credential = Get-Credential

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


            
            # Write-Host "Getting a list of tenants and storing them" -ForegroundColor Green
            # $Tenants = Get-AzureADContract -All $true | Where-Object { $_.DisplayName -eq 'Best Western Pembina' }
            # $Tenants = Get-AzureADContract -All $true

            # $credential = ""
            # $Credential = Get-Credential
            # Connect-AzAccount -Credential $Credential
            # Connect-AzAccount


            # $credential = ""
            # $Credential = Get-Credential
            # Connect-AzureAD -Credential $credential

            # Write-Host "Connecting to Azure AD of tenant" $tenant  -ForegroundColor Green
            # Connect-AzureAD -TenantId $_.CustomerContextID -Credential $credential | Out-Null #outputting to out-null to so it does not add the output to the array

            #Create Azure AD Group
            New-AzureADGroup -DisplayName $AzAdGroupName -MailEnabled $True -SecurityEnabled $false -MailNickName $AzAdGroupName

            $subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
            Set-AzContext -SubscriptionId $subscriptionId
            
            #Create Resource Group for Azure Key Vault
            New-AzResourcegroup -Name $RGname -Location $location
            
            #Create Vault in Azure Key Vault
            New-AzKeyVault -VaultName $vaultname -ResourceGroupName $RGname -Location $location
            
            #Setup Permissions for the AzADGroup
            Set-AzKeyVaultAccessPolicy $SetAzKeyVaultAccessPolicyParam
            
            #Create Secret in Vault
            Set-KeyVaultSecret -VaultName $vaultname -Name $SecretName -SecretValue $SecretValue
            
            # Get Azure secrets from Key Vault
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