function Generate-RootCert {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CertDisplayname,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Domain
    )
    
    begin {
    
        
        $NewSelfSigned_ROOT_CertificateParam = $null
        $NewSelfSigned_ROOT_CertificateParam = @{

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

            

        }
    }
    
    process {
        
        try {

            #Create ROOT Cert
            Write-Host 'creating a root cert' -ForegroundColor Green
            $Cert = New-SelfSignedCertificate @NewSelfSigned_ROOT_CertificateParam

            
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

#Example Usage
# $CertDisplayname = 'MIAONLINE_Root'
# $Domain = 'MIAONLINE.LOCAL'

# Generate-RootCert -CertDisplayname $CertDisplayname -Domain $Domain