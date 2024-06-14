# Install-Module Mailozaurr -Force
# Import-Module Mailozaurr

$ClientID = '7ddf059f-071e-4a5c-973f-8d0e2bde9b24' #Same as AppID
$TenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' #Same as DirectoryID
# $ReplyURI = 'http://localhost:8400'

$Body = EmailBody {
    EmailText -Text 'This is my text'
    EmailTable -DataTable (Get-Process | Select-Object -First 5 -Property Name, Id, PriorityClass, CPU, Product)
} -Online

$CredentialOAuth2 = Connect-oAuthO365 -ClientID $ClientID -TenantID $TenantID
$sendEmailMessageSplat = @{
    # From = @{ Name = 'Przemys?aw K?ys'; Email = 'test@evotec.pl' }
    # To = 'test@evotec.pl'
    From       = 'Alerts@canadacomputing.ca'
    To         = 'Alerts@canadacomputing.ca'
    Server = 'smtp.office365.com'
    HTML = $Body
    # Text = $Text
    DeliveryNotificationOption = 'OnSuccess'
    Priority = 'High'
    Subject = 'This is another test email'
    SecureSocketOptions = 'Auto'
    Credential = $CredentialOAuth2
    oAuth2 = $true
}

Send-EmailMessage @sendEmailMessageSplat