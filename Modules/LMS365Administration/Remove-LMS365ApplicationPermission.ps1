
function Remove-LMS365ApplicationPermission {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("SharePoint", "GraphAPI")]
        [string] $Resource,
        [Parameter(Mandatory = $true)]
        [string] $ScopeToDelete
    )

    switch ($Resource) {
        "SharePoint" { $appId = $AzureResources.SharePoint  }
        "GraphAPI" { $appId = $AzureResources.GraphAPI  }
        default {}
    }
    $lms365App = Get-LMS365AppServicePrincipal
    $resourceApp = Get-ServicePrincipalByAppId -AppId $appId

    $appRoleIdToDelete = $resourceApp.AppRoles | Where-Object { $_.Value -eq $ScopeToDelete } | Select-Object -ExpandProperty Id
    if(-not $appRoleIdToDelete){
        throw "Permission scope $ScopeToDelete cannot be found in $Resource app roles."
    }
    # Get all application permissions for the service principal
    $spApplicationPermission = Get-AzureADServiceAppRoleAssignedTo -ObjectId $lms365App.ObjectId -All $true `
                                | Where-Object { $_.PrincipalType -eq "ServicePrincipal" -and $_.ResourceId -eq $resourceApp.ObjectId } `
                                | Where-Object { $_.Id -eq $appRoleIdToDelete}
    if(-not $spApplicationPermission) {
        throw 'Role assignment is not found.'
    }
    Remove-AzureADServiceAppRoleAssignment -ObjectId $spApplicationPermission.PrincipalId -AppRoleAssignmentId $spApplicationPermission.ObjectId
}
