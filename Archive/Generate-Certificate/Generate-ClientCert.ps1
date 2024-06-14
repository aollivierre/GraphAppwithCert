. "$PSScriptRoot\Generate-RootCert.ps1"

function Generate-ClientCert {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $RootCert
    )
    
    begin {
    
        
        $NewSelfSigned_CLIENT_CertificateParam = $null
        $NewSelfSigned_CLIENT_CertificateParam = @{

            Type              = 'custom'
            KeySpec           = 'KeyExchange'
            subject           = "cn=$($CertDisplayname)"
            KeyExportPolicy   = 'Exportable'
            HashAlgorithm     = 'sha256'
            KeyLength         = '2048'
            CertStoreLocation = "Cert:\CurrentUser\My"
            KeyUsageProperty  = 'sign'
            KeyUsage          = 'CertSign'
            DnsName           = "$Domain"
            Signer            = $RootCert
            TextExtension     = @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")

            

        }
    }
    
    process {
        
        try {

            #Create ROOT Cert
            Write-Host 'creating a root cert' -ForegroundColor Green
            $Cert = New-SelfSignedCertificate @NewSelfSigned_CLIENT_CertificateParam

            
        }
        catch {

            Write-Error 'There was an error with Creating Cert ... halting execution'

            #Region CatchAll

            Write-Host "A Terminating Error (Exception) happened" -ForegroundColor Magenta
            Write-Host "Displaying the Catch Statement ErrorCode" -ForegroundColor Yellow
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
        Write-Host 'Root Cert with the subject '"$($Cert.Subject)" ' has been created' -ForegroundColor Green
        Write-Host 'Root Cert with the Thumbprint '"$($Cert.Thumbprint)" ' has been created' -ForegroundColor Green
        Write-Host 'Creating a Base64 String from the Root Cert' -ForegroundColor Green
        Write-Host 'a Base64 String from the Root Cert has been created' -foregroundcolor green
        return $Cert
        
    }
}


$CertDisplayname = 'MIAONLINE_Root'
$Domain = 'MIAONLINE.LOCAL'
$RootCert = Generate-RootCert -CertDisplayname $CertDisplayname -Domain $Domain

$CertDisplayname = 'MIAONLINE_Client'
Generate-ClientCert -CertDisplayname $CertDisplayname -Domain $Domain -RootCert $RootCert