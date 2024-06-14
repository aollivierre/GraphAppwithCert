$ScriptRoot1 = $null
$ScriptRoot1 = if ($PSVersionTable.PSVersion.Major -lt 3) {
    Split-Path -Path $MyInvocation.MyCommand.Path
}
else {
    $PSScriptRoot
}

."$ScriptRoot1\Secrets\Encrypt-Secret.ps1"
."$ScriptRoot1\Secrets\Decrypt-Secret.ps1"


<#
.SYNOPSIS
    Short description

    https://evotec.xyz/mailozaurr-new-mail-toolkit-smtp-imap-pop3-with-support-for-oauth-2-0-and-graphapi-for-powershell/
.DESCRIPTION
    Long description


Mailozaurr – New mail toolkit (SMTP, IMAP, POP3) with support for oAuth 2.0 and GraphApi for PowerShell
 4th August 2020Standard0Przemyslaw Klys
Today, I'm introducing a new PowerShell module called Mailozaurr. It's a module that aims to deliver functionality around Email for multiple use cases. I've started it since native SMTP cmdlet Send-MailMessage is obsolete,  and I thought it would be good to write a replacement that adds more features over it as things around us are changing rapidly.

Send-MailMessage is obsolete
The Send-MailMessage cmdlet is obsolete. This cmdlet does not guarantee secure connections to SMTP servers. While there is no immediate replacement available in PowerShell, we recommend you do not use Send-MailMessage. For more information, see Platform Compatibility note DE0005.

While initially, it started as a way to send emails, it now has grown to support a bit more than that. Since I've started playing with MailKit library (on which Mailozaurr is based), I've noticed its potential for other use cases. MailKit supports a lot of features (not all are implemented in Mailozaurr yet), so if anything touches SMTP, IMAP, or POP3, it's most likely already implemented by it. All I have to do is write PowerShell implementation of it.

.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)


    VERBOSE: POST https://login.microsoftonline.com/dc3227a4-53ba-48f1-b54b-89936cd5ca53/oauth2/token with -1-byte payload
VERBOSE: received 1868-byte response of content type application/json; charset=utf-8
VERBOSE: POST https://graph.microsoft.com/v1.0/users/Alerts@canadacomputing.ca/sendMail with -1-byte payload
VERBOSE: received 0-byte response of content type text/plain

VERBOSE: Message content: {
    "message":  {
                    "subject":  "This is another test email 2",
                    "body":  {
                                 "contentType":  "Text"
                             },
                    "from":  {
                                 "emailAddress":  {
                                                      "address":  "Alerts@canadacomputing.ca"
                                                  }
                             },
                    "toRecipients":  [
                                         {
                                             "emailAddress":  {
                                                                  "address":  "Alerts@canadacomputing.ca"
                                                              }
                                         }
                             },
                    "toRecipients":  [
                                         {
                                             "emailAddress":  {
                                                                  "address":  "Alerts@canadacomputing.ca"
                                                              }
                                         }
                                     ],
                    "importance":  "Low"
                },
    "saveToSentItems":  true
}
Status Error SentTo                    SentFrom
------ ----- ------                    --------
  True       Alerts@canadacomputing.ca Alerts@canadacomputing.ca

.NOTES
    General notes

    It uses the same pattern as the oAuth implementation. Simply use Graph switch parameter to tell Send-EmailMessage that it's dealing with Graph Credentials and then pass $ClientID, $DirectoryID and $ClientSecret as $Credentials object using ConvertTo-GraphCredential cmdlet.


    Find-Module Mailozaurr | select -ExpandProperty description

Mailozaurr is a PowerShell module that aims to provide SMTP, POP3, IMAP and few other ways to interact with Email. Underneath it uses MimeKit 
and MailKit and EmailValidation libraries written by Jeffrey Stedfast.
#>


# Install-Module -Name 'Mailozaurr' -Force
# Import-Module -Name 'Mailozaurr' -Force
# (get-command -Module mailozaurr ) | Where-Object { $_.CommandType -eq 'function' } | Select-Object Name


# Install-PackageProvider -Name NuGet -Force
# Get-Module -Name "PSWriteHTML" -ListAvailable -all | Remove-Module -Force -verbose
# Install-Module -Name "PSWriteHTML" -Force -Verbose -AllowClobber
# Import-Module -Name "PSWriteHTML" -Verbose -Force
# Get-Module -Name "PSWriteHTML" -ListAvailable | Select-object Name, Version
# (get-command -Module 'PSWriteHTML'  ) | Where-Object { $_.CommandType -eq 'function' } | Select-Object Name

# Playing with SMTP in PowerShell - Microsoft Graph API
# While I failed my battle with oAuth 2.0 for Office 365, Microsoft also offers a way to send emails with Graph API. I've decided to implement it as part of Send-EmailMessage as well.


# It seems larger HTML is not supported. Online makes sure it uses less libraries inline
# it may be related to not escaping chars properly for JSON, may require investigation
$Body = EmailBody {
    EmailText -Text 'This is my text'
    EmailTable -DataTable (Get-Process | Select-Object -First 5 -Property Name, Id, PriorityClass, CPU, Product)
} -Online


# Credentials for Graph
# $ClientID = '7ddf059f-071e-4a5c-973f-8d0e2bde9b24' #Same as AppID
# $DirectoryID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53' #Same as TenantID
# $ClientSecret = 'yFY85xfIMijJQUBcZwlgiGDnEy92Yqdv4c3OH6r/vc4=' #Same as AppSecret

Encrypt-Secret -SecretValue $ClientID -Description 'ClientID'
Encrypt-Secret -SecretValue $DirectoryID -Description 'DirectoryID'
Encrypt-Secret -SecretValue $ClientSecret -Description 'ClientSecret'

$ClientID = Decrypt-Secret -Description 'ClientID'
$DirectoryID = Decrypt-Secret -Description 'DirectoryID'
$ClientSecret = Decrypt-Secret -Description 'ClientSecret'


$Credential = ConvertTo-GraphCredential -ClientID $ClientID -ClientSecret $ClientSecret -DirectoryID $DirectoryID
# Sending email
# $sendEmailMessageSplat = @{
#     From       = @{ Name = 'CCI Alerts'; Email = 'Alerts@canadacomputing.ca' }
#     To         = 'Alerts@canadacomputing.ca'
#     Credential = $Credential
#     # HTML = $Body
#     Subject    = 'This is another test email 1'
#     Graph      = $true
#     Verbose    = $true
#     Priority   = 'High'
#     Attachment = ''
# }

# Send-EmailMessage @sendEmailMessageSplat


#note run the Scope-AzureADAppExchangeOnline.ps1 to restrict access
# Note: Changes to application access policies can take up to 30 minutes to take effect in Microsoft Graph REST API calls.

# Status Error                                                                                       SentTo                      SentFrom                    
# ------ -----                                                                                       ------                      --------
#  False The remote server returned an error: (403) Forbidden. details: Access to OData is disabled. Abdullah@canadacomputing.ca Mahmoud@canadacomputing.ca  

# sending email with From as string (it won't matter for Exchange )
$sendEmailMessageSplat = @{
    From       = 'Alerts@canadacomputing.ca'
    To         = 'Abdullah@canadacomputing.ca'
    Credential = $Credential
    HTML       = $Body
    Subject    = 'This is another test email 2'
    Graph      = $true
    Verbose    = $true
    Priority   = 'Low'
    Attachment = 'C:\Users\Abdullah.Ollivierre\AzureRepos2\Unified365toolbox\Send-Email\Sent-EmailGraph.ps1', 'C:\Users\Abdullah.Ollivierre\AzureRepos2\Unified365toolbox\Send-Email\Request-AccessToken.ps1'
}

Send-EmailMessage @sendEmailMessageSplat




