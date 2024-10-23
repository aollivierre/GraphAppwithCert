@{
    permissions = @(
        @{
            # Microsoft Graph API
            resourceAppId = '00000003-0000-0000-c000-000000000000'

            # Application Permissions
            applicationPermissions = @(

                # Identity Management Permissions
                @{
                    name = 'Directory.Read.All'
                    type = 'Role'
                },
                @{
                    name = 'Directory.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'Directory.Write.Restricted'
                    type = 'Role'
                },
                @{
                    name = 'AppRoleAssignment.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'Organization.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'Organization.Read.All'
                    type = 'Role'
                },

                # Device Management Permissions
                @{
                    name = 'DeviceManagementApps.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'DeviceManagementConfiguration.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'DeviceManagementManagedDevices.PrivilegedOperations.All'
                    type = 'Role'
                },
                @{
                    name = 'DeviceManagementManagedDevices.Read.All'
                    type = 'Role'
                },
                @{
                    name = 'DeviceManagementManagedDevices.ReadWrite.All'
                    type = 'Role'
                },

                # Application Management Permissions
                @{
                    name = 'Application.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'AppCatalog.Read.All'
                    type = 'Role'
                },

                # SharePoint & Sites Management Permissions
                @{
                    name = 'Sites.FullControl.All'
                    type = 'Role'
                },
                @{
                    name = 'Sites.Read.All'
                    type = 'Role'
                },
                @{
                    name = 'Sites.ReadWrite.All'
                    type = 'Role'
                },
                @{
                    name = 'Sites.Manage.All'
                    type = 'Role'
                },
                @{
                    name = 'Sites.Selected'
                    type = 'Role'
                },
                @{
                    name = 'TermStore.Read.All'
                    type = 'Role'
                },
                @{
                    name = 'TermStore.ReadWrite.All'
                    type = 'Role'
                },

                # Logging & Auditing Permissions
                @{
                    name = 'AuditLog.Read.All'
                    type = 'Role'
                }
            )

            # Delegated Permissions
            delegatedPermissions = @(

                # Identity Management Permissions
                @{
                    name = 'User.Read'
                    type = 'Scope'
                },
                @{
                    name = 'Directory.Read.All'
                    type = 'Scope'
                },
                @{
                    name = 'Organization.ReadWrite.All'
                    type = 'Scope'
                },

                # Device Management Permissions
                @{
                    name = 'DeviceManagementConfiguration.ReadWrite.All'
                    type = 'Scope'
                },
                @{
                    name = 'DeviceManagementManagedDevices.Read.All'
                    type = 'Scope'
                },
                @{
                    name = 'DeviceManagementManagedDevices.ReadWrite.All'
                    type = 'Scope'
                },
                @{
                    name = 'DeviceManagementManagedDevices.PrivilegedOperations.All'
                    type = 'Scope'
                },

                # Application Management Permissions
                @{
                    name = 'AppCatalog.Read.All'
                    type = 'Scope'
                },

                # SharePoint & Sites Management Permissions
                @{
                    name = 'Sites.Read.All'
                    type = 'Scope'
                },
                @{
                    name = 'Sites.ReadWrite.All'
                    type = 'Scope'
                },
                @{
                    name = 'Sites.FullControl.All'
                    type = 'Scope'
                },
                @{
                    name = 'Sites.Manage.All'
                    type = 'Scope'
                },
                @{
                    name = 'TermStore.Read.All'
                    type = 'Scope'
                },
                @{
                    name = 'TermStore.ReadWrite.All'
                    type = 'Scope'
                },

                # Logging & Auditing Permissions
                @{
                    name = 'AuditLog.Read.All'
                    type = 'Scope'
                },
                @{
                    name = 'AccessReview.ReadWrite.All'
                    type = 'Scope'
                },

                # Browser Site List Permissions
                @{
                    name = 'BrowserSiteLists.Read.All'
                    type = 'Scope'
                }
            )
        }
    )
}
