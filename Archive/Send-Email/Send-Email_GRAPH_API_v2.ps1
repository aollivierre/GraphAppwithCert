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


.NOTES
    General notes

    It uses the same pattern as the oAuth implementation. Simply use Graph switch parameter to tell Send-EmailMessage that it's dealing with Graph Credentials and then pass $ClientID, $DirectoryID and $ClientSecret as $Credentials object using ConvertTo-GraphCredential cmdlet.


    Find-Module Mailozaurr | select -ExpandProperty description

Mailozaurr is a PowerShell module that aims to provide SMTP, POP3, IMAP and few other ways to interact with Email. Underneath it uses MimeKit 
and MailKit and EmailValidation libraries written by Jeffrey Stedfast.
#>

function Send-EmailMessageMSGraphAPI {
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$From,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$To,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$subject


    )


# Install-PackageProvider -Name NuGet -Force

# Get-Module -Name "Mailozaurr" -ListAvailable -all | Remove-Module -Force -verbose
# Get-Module -Name "Mailozaurr" -ListAvailable -all | Uninstall-Module -Force -verbose

# Install-Module -Name "Mailozaurr" -Force -Verbose -AllowClobber
# Import-Module -Name "Mailozaurr" -Verbose -Force
# Get-Module -Name "Mailozaurr" -ListAvailable | Select-object Name, Version


# Get-Module -Name "PSWriteHTML" -ListAvailable -all | Remove-Module -Force -verbose
# Get-Module -Name "PSWriteHTML" -ListAvailable -all | Uninstall-Module -Force -verbose
# Install-Module -Name "PSWriteHTML" -Force -Verbose -AllowClobber
# Import-Module -Name "PSWriteHTML" -Verbose -Force
# Get-Module -Name "PSWriteHTML" -ListAvailable | Select-object Name, Version

$Body = EmailBody {
    EmailText -Text 'Your Script has ran and here are the results'
    # EmailTable -DataTable (Get-Process | Select-Object -First 5 -Property Name, Id, PriorityClass, CPU, Product)
    EmailTable -DataTable (Get-Content -Path $Logfile)
} -Online

$ClientID = Decrypt-Secret -Description 'ClientID'
$DirectoryID = Decrypt-Secret -Description 'DirectoryID'
$ClientSecret = Decrypt-Secret -Description 'ClientSecret'


$Credential = ConvertTo-GraphCredential -ClientID $ClientID -ClientSecret $ClientSecret -DirectoryID $DirectoryID
$sendEmailMessageSplat = @{
    From       = $From
    To         = $To
    Credential = $Credential
    HTML       = $Body
    Subject    = $subject
    Graph      = $true
    Verbose    = $true
    Priority   = 'Low'
    # Attachment = 'logfile1.txt', 'logFile2.txt', etc..
    # Attachment = 'logfile1.txt', 'logFile2.txt'
}

Send-EmailMessage @sendEmailMessageSplat
    
}

# Example

$EmailMessageMSGraphAPISplat = @{
    From       = 'Alerts@canadacomputing.ca'
    To         = 'Syslog@canadacomputing.ca'
    Subject    = 'Your Script has ran and here are the results'
}

Send-EmailMessageMSGraphAPI @EmailMessageMSGraphAPISplat


