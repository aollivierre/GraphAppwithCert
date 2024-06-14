. "$PSScriptRoot\Fault_Tolerance_CleanupAzSessions.ps1"

function Fault_Tolerance_Connect-AzAccountwithContext {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TenantID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $subscriptionID
    )
    

        try {

            Write-Host "Connecting to Azure" -ForegroundColor Green
            Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
            Connect-AzAccount -Tenant $TenantID -SubscriptionId $subscriptionID
            $currentAzureContext = Get-AzContext
     

            
        }
        catch {
            
            Write-Error 'There was an error with Connecting to Azure... halting execution'

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


        return $currentAzureContext
    
}
function Fault_Tolerance_Connect-AzureADfromAzContext {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $TenantID,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AccountID

    )
            # Check if the Azure AD PowerShell module is installed.
            if ( Get-Module -ListAvailable -Name AzureAD ) {
                Write-Host -ForegroundColor Green "Loading the Azure AD PowerShell module..."
                Install-Module -Name "AzureAD" -Force -AllowClobber
                Import-Module -Name "AzureAD" -Force
                Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version, ModuleBase
            }
            else {
                Write-Host -ForegroundColor Green "Loading the Azure AD PowerShell module..."
                Install-Module -Name "AzureAD" -Force -AllowClobber
                Import-Module -Name "AzureAD" -Force
                Get-Module -Name "AzureAD"-ListAvailable | Select-object Name, Version, ModuleBase
            }

        try {
            Write-Host "Connecting to Azure AD" -ForegroundColor Green
            Write-Host -ForegroundColor Green "When prompted please enter the appropriate credentials... Warning: Window might have pop-under in VSCode"
            Write-Host "Push ALT+TAB and Select the Login Page and Provide creds" -ForegroundColor Green
            Connect-AzureAD -TenantId $TenantID -AccountId $AccountID | Out-Null

        }
        catch {

            # The authentication attempt was canceled by the end-user. Execution of the script should be halted.
            Write-Error 'An error happened while connecting to Azure AD.. halting script execution'    
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
            Exit

        }
            

    
    }

    #Usage Example below
    # Fault_Tolerance_CleanupAzSessions

    # $subscriptionID = '408a6c03-bd25-471b-ae84-cf82b3dff420'
    # $TenantID = 'dc3227a4-53ba-48f1-b54b-89936cd5ca53'
    # $AccountID = 'Abdullah@canadacomputing.ca'


    # $fault_Tolerance_ConnectAzAccountwithContextSplat = @{
    #     TenantID = $TenantID
    #     subscriptionID = $subscriptionID
    # }


    # Fault_Tolerance_Connect-AzAccountwithContext @fault_Tolerance_ConnectAzAccountwithContextSplat
    
    # $fault_Tolerance_ConnectAzureADfromAzContextSplat = @{
    #     TenantID = $TenantID
    #     AccountID = $AccountID
    # }
    
    # Fault_Tolerance_Connect-AzureADfromAzContext @fault_Tolerance_ConnectAzureADfromAzContextSplat
    
    # $SessionInfo = $null
    # $SessionInfo = Get-AzureADCurrentSessionInfo
    # $TenantDomain = $SessionInfo.TenantDomain
    # $TenantDomain