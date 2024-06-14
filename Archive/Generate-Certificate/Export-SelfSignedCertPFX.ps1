<#
.SYNOPSIS
    This script is to export a CLIENT cert to PFX. Build another script for exporting a root cert
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

function Export-SelfSignedCertPFX {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $Certificate,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        $PFXFilePath
        # [Parameter(Mandatory = $true)]
        # [ValidateNotNullOrEmpty()]
        # $FilePath
        
    )
    
    begin {
        
    }
    
    process {


        try {
            
            $password = Read-Host -AsSecureString -Prompt 'Enter Private Key for Exported *.PFX file of Client'

            #Client Cert
            Export-PfxCertificate -Cert $Certificate -FilePath $PFXFilePath -Password $password

            #Root Cert
            # Export-Certificate -Cert $cert -FilePath $FilePath -Type CERT
            # Set-Content -Path $FilePath -Value ([Convert]::ToBase64String($cert.RawData)) -Encoding Ascii

        }
        catch {
            
            Write-Error 'An Error happened when .. script execution will be halted'
         
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
         
            #EndRegion CatchAll
         
            Exit
         
         
        }
        finally {
            
        }
        
    }
    
    end {
        
    }
}


$Date = [System.DateTime]::Now.ToString("yyyy%M%d")
$TargetMachineName = [System.Environment]::MachineName

$CertDisplayname = 'MIAONLINE_Client'
$CertStoreLocation = "Cert:\CurrentUser\My"
$Certificate = Get-ChildItem $CertStoreLocation | Where-Object { $_.Subject -match $CertDisplayname }


$CertDir = "C:\Certs"
if (!(Test-Path -Path $CertDir )) { 
    New-Item -Force -ItemType directory -Path $CertDir
}
$PFXFilePath = "C:\Certs\$($CertDisplayname)_$($TargetMachineName)_$($Date).pfx"

Export-SelfSignedCertPFX -Certificate $Certificate -PFXFilePath $PFXFilePath

#Export the root cert to *.cer
#Export the client Cert to *.PFX 

