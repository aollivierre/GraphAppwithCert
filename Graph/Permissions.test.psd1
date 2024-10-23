@{
    permissions = @(
        @{
            # Microsoft Graph API
            resourceAppId = '00000003-0000-0000-c000-000000000000'

            # Application Permissions
            applicationPermissions = @(
                @{
                    id   = '1bfefb4e-e0b5-418b-a88f-73c46d2cc8e9'
                    type = 'Role'
                    # Application.ReadWrite.All
                },
                @{
                    id   = 'b0afded3-3588-46d8-8b3d-9842eff778da'
                    type = 'Role'
                    # AuditLog.Read.All
                },
                @{
                    id   = '7ab1d382-f21e-4acd-a863-ba3e13f7da61'
                    type = 'Role'
                    # Directory.Read.All
                },
                @{
                    id   = '19dbc75e-c2e2-444c-a770-ec69d8559fc7'
                    type = 'Role'
                    # Directory.ReadWrite.All
                },
                @{
                    id   = '78145de6-330d-4800-a6ce-494ff2d33d07'
                    type = 'Role'
                    # DeviceManagementApps.ReadWrite.All
                },
                @{
                    id   = '9241abd9-d0e6-425a-bd4f-47ba86e767a4'
                    type = 'Role'
                    # DeviceManagementConfiguration.ReadWrite.All
                },
                @{
                    id   = '5b07b0dd-2377-4e44-a38d-703f09a0dc3c'
                    type = 'Role'
                    # DeviceManagementManagedDevices.PrivilegedOperations.All
                },
                @{
                    id   = '2f51be20-0bb4-4fed-bf7b-db946066c75e'
                    type = 'Role'
                    # DeviceManagementManagedDevices.Read.All
                },
                @{
                    id   = '243333ab-4d21-40cb-a475-36241daa0842'
                    type = 'Role'
                    # DeviceManagementManagedDevices.ReadWrite.All
                },
                @{
                    id   = 'e12dae10-5a57-4817-b79d-dfbec5348930'
                    type = 'Role'
                    # AppCatalog.Read.All
                },
                @{
                    id   = '292d869f-3427-49a8-9dab-8c70152b74e9'
                    type = 'Role'
                    # Organization.ReadWrite.All
                },
                @{
                    id   = '498476ce-e0fe-48b0-b801-37ba7e2685c6'
                    type = 'Role'
                    # Organization.Read.All
                },
                @{
                    id   = 'f20584af-9290-4153-9280-ff8bb2c0ea7f'
                    type = 'Role'
                    # Directory.Write.Restricted
                },
                @{
                    id   = '06b708a9-e830-4db3-a914-8e69da51d44f'
                    type = 'Role'
                    # AppRoleAssignment.ReadWrite.All
                }
            )

            # Delegated Permissions
            delegatedPermissions = @(
                @{
                    id   = 'e1fe6dd8-ba31-4d61-89e7-88639da4683d'
                    type = 'Scope'
                    # User.Read
                },
                @{
                    id   = 'c5ee1f21-fc7f-4937-9af0-c91648ff9597'
                    type = 'Scope'
                    # BrowserSiteLists.Read.All
                },
                @{
                    id   = 'ef5f7d5c-338f-44b0-86c3-351f46c8bb5f'
                    type = 'Scope'
                    # AccessReview.ReadWrite.All
                },
                @{
                    id   = 'e12dae10-5a57-4817-b79d-dfbec5348930'
                    type = 'Scope'
                    # AppCatalog.Read.All
                },
                @{
                    id   = 'b0afded3-3588-46d8-8b3d-9842eff778da'
                    type = 'Scope'
                    # AuditLog.Read.All
                },
                @{
                    id   = '7ab1d382-f21e-4acd-a863-ba3e13f7da61'
                    type = 'Scope'
                    # Directory.Read.All
                },
                @{
                    id   = '292d869f-3427-49a8-9dab-8c70152b74e9'
                    type = 'Scope'
                    # Organization.ReadWrite.All
                },
                @{
                    id   = '9241abd9-d0e6-425a-bd4f-47ba86e767a4'
                    type = 'Scope'
                    # DeviceManagementConfiguration.ReadWrite.All
                },
                @{
                    id   = '2f51be20-0bb4-4fed-bf7b-db946066c75e'
                    type = 'Scope'
                    # DeviceManagementManagedDevices.Read.All
                },
                @{
                    id   = '243333ab-4d21-40cb-a475-36241daa0842'
                    type = 'Scope'
                    # DeviceManagementManagedDevices.ReadWrite.All
                },
                @{
                    id   = '5b07b0dd-2377-4e44-a38d-703f09a0dc3c'
                    type = 'Scope'
                    # DeviceManagementManagedDevices.PrivilegedOperations.All
                }
            )
        }
    )
}
