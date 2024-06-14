
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

$ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine

if ($ExecutionPolicy -ne 'unrestricted') {

    Write-Host "The Execution Policy is currently set to" $ExecutionPolicy -ForegroundColor Magenta

    setting ExecutionPolicy to unrestricted" on all other scopes
    Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "MachinePolicy" -Confirm:$false -Force
    Set-ExecutionPolicy -ExecutionPolicy "undefined" -Scope "UserPolicy" -Confirm:$false -Force
    Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "Process" -Confirm:$false -Force
    Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "CurrentUser" -Confirm:$false -Force


    Write-Host "Setting the Execution Policy to  unrestricted on the LocalMachine Scope" -ForegroundColor Magenta
    Set-ExecutionPolicy -ExecutionPolicy "unrestricted" -Scope "LocalMachine" -Confirm:$false -Force

    #Re Collecting the $ExecutionPolicy value
    $ExecutionPolicy = Get-ExecutionPolicy -Scope LocalMachine
    Write-Host "The Execution Policy is currently set to" $ExecutionPolicy "on the LocalMachine Scope" -ForegroundColor green
}