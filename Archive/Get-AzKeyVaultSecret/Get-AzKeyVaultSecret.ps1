<#
 .DESCRIPTION
    Returns a Secret for Azure Key Vault
 .NOTES
    Author: 
    Intent: Sample to demonstrate accessing Azure KeyVault
 #>

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
    "WrapKey","Verify",
    "Sign","Get","List",
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
$subscriptionName = '<your subscription name here>'

#Resource Group Name
$RGname = "KeyVaultGroup"

# Key Vault Name
$vaultname = "CorpVault"

#AzAdGroup Name
$AzAdGroupName = 'KeyvaultTeam'

# Secret Name
$SecretName = "Application Password"

#Location Name
$location = "Canada Central"


Connect-AzAccount
$subscriptionId = (Get-AzSubscription -SubscriptionName $subscriptionName).Id
Set-AzContext -SubscriptionId $subscriptionId

#Create Resource Group for Azure Key Vault
New-AzResourcegroup -Name $RGname -Location $location

#Create Vault in Azure Key Vault
New-AzKeyVault -VaultName $vaultname -ResourceGroupName $RGname -Location $location

#Setup Permissions for the AzADGroup
$SetAzKeyVaultAccessPolicyParam = 

@{
    VaultName = $vaultName
    ObjectID = (Get-AzAdGroup -SearchString $AzAdGroupName)[0].Id
    PermissionstoCertificates = $PermissionsToCertificates
    PermissionsToKeys = $PermissionsToKeys
    PermissiontoSecrets = $PermissionsToSecrets
    PassThru = $true
 }
Set-AzKeyVaultAccessPolicy $SetAzKeyVaultAccessPolicyParam

#Create Secret in Vault
$SecretValue = ConvertTo-SecureString 'Whatever your password is' -AsPlainText -Force
Set-KeyVaultSecret -VaultName $vaultname -Name $SecretName -SecretValue $SecretValue


# Get Azure secrets from Key Vault
$Password = (Get-AzKeyVaultSecret -VaultName $vaultname -Name $SecretName).SecretValueText

# Set-AzKeyVaultAccessPolicy -VaultName $vaultName -ResourceGroupName $resourceGroupName -PermissionsToKeys create, get, wrapKey, unwrapKey, sign, verify, list -UserPrincipalName $userPrincipalName

# Set-AzKeyVaultAccessPolicy  -VaultName $vaultName  -ResourceGroupName $resourceGroupName -ServicePrincipalName $applicationId -PermissionsToKeys get, wrapKey, unwrapKey, sign, verify, list




# $ClientId = (Get-AzKeyVaultSecret -VaultName $vault -Name AzureClientID).SecretValueText
# $ClientSecret = (Get-AzKeyVaultSecret -VaultName $vault -Name AzureClientSecret).SecretValueText
# $SubscriptionId = (Get-AzKeyVaultSecret -VaultName $vault -Name AzureSubscriptionID).SecretValueText

<#
# Acquire an access token
$Resource = "https://management.core.windows.net/"
$RequestAccessTokenUri = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$Body = "grant_type=client_credentials&client_id=$ClientId&client_secret=$ClientSecret&resource=$Resource"
$Token = Invoke-RestMethod -Method Post -Uri $RequestAccessTokenUri -Body $Body -ContentType 'application/x-www-form-urlencoded'
#>



<#
# Query RG Endpoint
$ResourceGroupApiUri = "https://management.azure.com/subscriptions/$SubscriptionId/resourcegroups?api-version=2018-02-01"
$Headers = @{}
$Headers.Add("Authorization","$($Token.token_type) "+ " " + "$($Token.access_token)")
$ResourceGroups = Invoke-RestMethod -Method Get -Uri $ResourceGroupApiUri -Headers $Headers
#>


<#
# Output resource groups
Write-Output $ResourceGroups
#>

