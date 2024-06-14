$ScriptRoot5 = $null
$ScriptRoot5 = if ($PSVersionTable.PSVersion.Major -lt 3) {
    Split-Path -Path $MyInvocation.MyCommand.Path
}
else {
    $PSScriptRoot
}


function Decrypt-Secret {
    param (
        

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Description

    )
    

    #Create the Encryption Keys parameters
    $Secret_File_2 = $null
    $Key_File_2 = $null
    $Key_2 = $null
    $MyCredential_2 = $null

    $User_2 = $null
    # $User_2 = "websiteSMTP@canadacomputing.ca"
    # $User_2 = "alerts@canadacomputing.ca"
    $User_2 = "CCI Admin"
    $Secret_File_2 = "$ScriptRoot5\$($Description)_Secret.txt"
    $Key_File_2 = "$ScriptRoot5\$($Description)_AES.key"
    $Key_2 = Get-Content $Key_File_2

    $SecurePWD_2 = $null
    $SecurePWD_2 = (Get-Content $Secret_File_2 | ConvertTo-SecureString -Key $Key_2)
    $MyCredential_2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User_2, $SecurePWD_2

    $Secret_OBJECT_2 = $null
    $Secret_OBJECT_2 = $MyCredential_2.GetNetworkCredential().Password

    # $smtp_2.Credentials = New-Object System.Net.NetworkCredential($MyCredential_2.UserName, $Secret_OBJECT_2)

    return $Secret_OBJECT_2 

}



# Decrypt-Secret
