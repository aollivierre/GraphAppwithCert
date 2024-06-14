# https://github.com/PowerShell/Win32-OpenSSH/releases
#Download the latest OpenSSH-Win64.zip package from the link above on GitHub
# https://github.com/PowerShell/Win32-OpenSSH/releases/tag/v8.1.0.0p1-Beta this was the latest at the time



# Install the OpenSSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0



Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'


Start-Service sshd


Get-Service sshd

Stop-Service sshd



Set-Service -Name sshd -StartupType 'Automatic'


Get-NetFirewallRule -Name *ssh*



#When you try to start the OpenSSH Server Service (SSHD) you will get an error, do the following to fix the error
#Run the .\FixHostFilePermissions.ps1 included in the x64 package of the OpenSSH-Win64.zip package downloaded from GitHub

#The expected output is as follows

# PS C:\Users\Admin-CCI\Downloads\OpenSSH-Win64\OpenSSH-Win64> .\FixHostFilePermissions.ps1

# Security warning
# Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your
# computer. If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning
# message. Do you want to run C:\Users\Admin-CCI\Downloads\OpenSSH-Win64\OpenSSH-Win64\FixHostFilePermissions.ps1?
# [D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R

# Security warning
# Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your
# computer. If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning
# message. Do you want to run C:\Users\Admin-CCI\Downloads\OpenSSH-Win64\OpenSSH-Win64\OpenSSHUtils.psm1?
# [D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R
#   [*] C:\ProgramData\ssh\sshd_config

# Need to remove the inheritance before repair the rules.
# Shall I remove the inheritace?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# Inheritance is removed from 'C:\ProgramData\ssh\sshd_config'.

# 'NT AUTHORITY\Authenticated Users' should not have access to 'C:\ProgramData\ssh\sshd_config'..
# Shall I remove this access?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'NT AUTHORITY\Authenticated Users' has no more access to 'C:\ProgramData\ssh\sshd_config'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_dsa_key

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_dsa_key'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' has no more access to 'C:\ProgramData\ssh\ssh_host_dsa_key'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_dsa_key.pub

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_dsa_key.pub'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' now has Read access to 'C:\ProgramData\ssh\ssh_host_dsa_key.pub'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_ecdsa_key

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_ecdsa_key'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' has no more access to 'C:\ProgramData\ssh\ssh_host_ecdsa_key'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_ecdsa_key.pub

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_ecdsa_key.pub'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' now has Read access to 'C:\ProgramData\ssh\ssh_host_ecdsa_key.pub'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_ed25519_key

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_ed25519_key'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' has no more access to 'C:\ProgramData\ssh\ssh_host_ed25519_key'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_ed25519_key.pub

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own
# 'C:\ProgramData\ssh\ssh_host_ed25519_key.pub'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' now has Read access to 'C:\ProgramData\ssh\ssh_host_ed25519_key.pub'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_rsa_key

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_rsa_key'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' has no more access to 'C:\ProgramData\ssh\ssh_host_rsa_key'.
#       Repaired permissions

#   [*] C:\ProgramData\ssh\ssh_host_rsa_key.pub

# Current owner: 'PSAutomation1\Admin-CCI'. 'NT AUTHORITY\SYSTEM' should own 'C:\ProgramData\ssh\ssh_host_rsa_key.pub'.
# Shall I set the file owner?
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): A
# 'PSAutomation1\Admin-CCI' now has Read access to 'C:\ProgramData\ssh\ssh_host_rsa_key.pub'.
#       Repaired permissions

#    Done.




#Install SSHD Manually

#expected Output
# Security warning
# Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your
# computer. If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning
# message. Do you want to run C:\Users\Admin-cci\Downloads\OpenSSH-Win64\OpenSSH-Win64\install-sshd.ps1?
# [D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R
# **** Warning: Publisher OpenSSH resources could not be found or are not accessible
# to the EventLog service account (NT SERVICE\EventLog).

# [SC] SetServiceObjectSecurity SUCCESS
# [SC] ChangeServiceConfig2 SUCCESS
# [SC] ChangeServiceConfig2 SUCCESS
# sshd and ssh-agent services successfully installed




#Built in Win10/Win Server 2019
$newNetFirewallRuleSplat = @{
    Name = 'sshd'
    DisplayName = 'OpenSSH SSH Server'
    Enabled = 'True'
    Direction = 'Inbound'
    Protocol = 'TCP'
    Action = 'Allow'
    LocalPort = 22
    Program = "C:\System32\OpenSSH\sshd.exe"
}

New-NetFirewallRule @newNetFirewallRuleSplat


#GitHub Version
# $newNetFirewallRuleSplat = @{
#     Name = 'sshd'
#     DisplayName = 'OpenSSH SSH Server'
#     Enabled = 'True'
#     Direction = 'Inbound'
#     Protocol = 'TCP'
#     Action = 'Allow'
#     LocalPort = 22
#     Program = "C:\Program Files\OpenSSH\ssh.exe"
# }

# New-NetFirewallRule @newNetFirewallRuleSplat




#GitHub Version
$newNetFirewallRuleSplat = @{
    Name = 'OpenSSH SSH Server'
    DisplayName = 'OpenSSH SSH Server'
    Enabled = 'True'
    Direction = 'Inbound'
    Protocol = 'TCP'
    Action = 'Allow'
    LocalPort = 22
    Program = "C:\Program Files\OpenSSH\sshd.exe"
}

New-NetFirewallRule @newNetFirewallRuleSplat






# Connecting to the server
# Finding Host Key
# Before the first connection, find out fingerprint of the server’s host key by using ssh-keygen.exe for each file.

# In Windows command-prompt, use:

# for %f in (%ProgramData%\ssh\ssh_host_*_key) do @%WINDIR%\System32\OpenSSH\ssh-keygen.exe -l -f "%f"
# Replace %WINDIR%\System32 with %ProgramFiles%, if appropriate.



# PS C:\Program Files\OpenSSH\OpenSSH-Win64> 
Get-ChildItem $env:ProgramData\ssh\ssh_host_*_key | ForEach-Object { . $env:WINDIR\System32\OpenSSH\ssh-keygen.exe -l -f $_ }


#Expected Output
# 1024 SHA256:ayKfoGvqOJfwYs4oBfy8U3ABnZ3PdqpP2tHkr0w3njU nt authority\system@FTP1 (DSA)
# 256 SHA256:E+CjRjjy5vU80wk4uwLOH8Gg5HQ0v7ymB/z7NarCEKE nt authority\system@FTP1 (ECDSA)
# 256 SHA256:dpLlAwX847NADJRbAlY+WFxWttcqj6oHOqdox6m/QYs nt authority\system@FTP1 (ED25519)
# 3072 SHA256:FksTWjtpKiq8lIQk3LXgs2AORmLDzgYqoj/+S2rkycM nt authority\system@FTP1 (RSA)



# PS C:\Program Files\OpenSSH\OpenSSH-Win64> 
Get-ChildItem $env:ProgramData\ssh\ssh_host_*_key | ForEach-Object { . 'C:\Program Files\OpenSSH\OpenSSH-Win64\ssh-keygen.exe' -l -f $_ }
Get-ChildItem $env:ProgramData\ssh\ssh_host_*_key | ForEach-Object { . $env:ProgramFiles\OpenSSH\OpenSSH-Win64\ssh-keygen.exe -l -f $_ }

#Expected Output
# 1024 SHA256:ayKfoGvqOJfwYs4oBfy8U3ABnZ3PdqpP2tHkr0w3njU nt authority\system@FTP1 (DSA)
# 256 SHA256:E+CjRjjy5vU80wk4uwLOH8Gg5HQ0v7ymB/z7NarCEKE nt authority\system@FTP1 (ECDSA)
# 256 SHA256:dpLlAwX847NADJRbAlY+WFxWttcqj6oHOqdox6m/QYs nt authority\system@FTP1 (ED25519)
# 3072 SHA256:FksTWjtpKiq8lIQk3LXgs2AORmLDzgYqoj/+S2rkycM nt authority\system@FTP1 (RSA)










# Get the Access Control List from the file
# Be careful $acl is more a security descriptor with more information than ACL
$acl = Get-Acl "C:\Users\Admin-cci\.ssh\authorized_keys"


# Show here how to refer to useful enumerate values (see MSDN)
$Right = [System.Security.AccessControl.FileSystemRights]::FullControl
$Control = [System.Security.AccessControl.AccessControlType]::Allow

# Build the Access Control Entry ACE 
# Be careful you need to replace "everybody" by the user or group you want to add rights to
# $ace = New-Object System.Security.AccessControl.FileSystemAccessRule ("everybody", $Right, $Control)
$ace = New-Object System.Security.AccessControl.FileSystemAccessRule ("admin-cci", $Right, $Control)

# Add ACE to ACL
$acl.AddAccessRule($ace)

# Put ACL to the file
Set-Acl "C:\Users\Admin-cci\.ssh\authorized_keys" $acl
(Get-Acl "C:\Users\Admin-cci\.ssh\authorized_keys").access
Read-Host "--------- Test Here --------------"

# Remove ACE from ACL
$acl.RemoveAccessRule($ace)
Set-Acl "C:\Users\Admin-cci\.ssh\authorized_keys" $acl
(Get-Acl "C:\Users\Admin-cci\.ssh\authorized_keys").access

