@{
    # Application Permissions Section
    applicationPermissions = @(
        @{
            name        = 'Application.ReadWrite.All'
            description = 'Read and write all applications'
            granted     = $true
        },
        @{
            name        = 'AuditLog.Read.All'
            description = 'Read all audit log data'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementApps.ReadWrite.All'
            description = 'Read and write Microsoft Intune apps'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementConfiguration.ReadWrite.All'
            description = 'Read and write Microsoft Intune device configuration and policies'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.PrivilegedOperations.All'
            description = 'Perform user-impacting remote actions on Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.Read.All'
            description = 'Read Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.ReadWrite.All'
            description = 'Read and write Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'Directory.Read.All'
            description = 'Read directory data'
            granted     = $true
        },
        @{
            name        = 'Directory.ReadWrite.All'
            description = 'Read and write directory data'
            granted     = $true
        },
        @{
            name        = 'Directory.Write.Restricted'
            description = 'Manage restricted resources in the directory'
            granted     = $true
        },
        @{
            name        = 'Organization.Read.All'
            description = 'Read organization information'
            granted     = $true
        },
        @{
            name        = 'Organization.ReadWrite.All'
            description = 'Read and write organization information'
            granted     = $true
        },
        @{
            name        = 'Policy.Read.All'
            description = 'Read all identity conditional access policies'
            granted     = $true
        },
        @{
            name        = 'Policy.ReadWrite.ConditionalAccess'
            description = 'Read and write identity conditional access policies'
            granted     = $true
        }
    )

    # Delegated Permissions Section
    delegatedPermissions = @(
        @{
            name        = 'Application.ReadWrite.All'
            description = 'Read and write all applications'
            granted     = $true
        },
        @{
            name        = 'AuditLog.Read.All'
            description = 'Read all audit log data'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementApps.ReadWrite.All'
            description = 'Read and write Microsoft Intune apps'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementConfiguration.ReadWrite.All'
            description = 'Read and write Microsoft Intune device configuration and policies'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.PrivilegedOperations.All'
            description = 'Perform user-impacting remote actions on Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.Read.All'
            description = 'Read Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'DeviceManagementManagedDevices.ReadWrite.All'
            description = 'Read and write Microsoft Intune devices'
            granted     = $true
        },
        @{
            name        = 'Directory.Read.All'
            description = 'Read directory data'
            granted     = $true
        },
        @{
            name        = 'Directory.ReadWrite.All'
            description = 'Read and write directory data'
            granted     = $true
        },
        @{
            name        = 'Directory.Write.Restricted'
            description = 'Manage restricted resources in the directory'
            granted     = $true
        },
        @{
            name        = 'Organization.Read.All'
            description = 'Read organization information'
            granted     = $true
        },
        @{
            name        = 'Organization.ReadWrite.All'
            description = 'Read and write organization information'
            granted     = $true
        },
        @{
            name        = 'Policy.Read.All'
            description = 'Read all identity conditional access policies'
            granted     = $true
        },
        @{
            name        = 'Policy.ReadWrite.ConditionalAccess'
            description = 'Read and write identity conditional access policies'
            granted     = $true
        },
        @{
            name        = 'User.Read'
            description = 'Sign in and read user profile'
            granted     = $true
        }
    )
}
