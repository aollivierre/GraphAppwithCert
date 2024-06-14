
# Key Vault Name
$vaultname = $null
$vaultname = "CCI-AKV-M365"

# Secret Name
$SecretName = $null
$SecretName = "ApplicationPassword"

# Secret Value
$Prompt = $null
$Prompt = "Enter Secret Value to be stored in the Azure Vault Named $vaultname"

$SecretValue = $null
$SecretValue = Read-Host -Prompt $Prompt -AsSecureString

#Create Secret in Vault
Write-Host "Creating Azure Key Vault" $vaultname "Secret" $SecretName -ForegroundColor Green
Set-AzKeyVaultSecret -VaultName $vaultname -Name $SecretName -SecretValue $SecretValue


# To view the value contained in the secret as plain text:
# $secret = Get-AzKeyVaultSecret -VaultName 'Contoso-Vault2' -Name 'ExamplePassword'
# $ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
# try {
#    $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
# } finally {
#    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
# }
# Write-Output $secretValueText