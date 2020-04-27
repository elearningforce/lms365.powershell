
function Add-LMS365ApplicationPermission {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TenantId,
        [Parameter(Mandatory = $true)]
        [string] $UserName,
        [Parameter(Mandatory = $true)]
        [ValidateSet("SharePoint", "GraphAPI")]
        [string] $Resource,
        [Parameter(Mandatory = $true)]
        [string] $ScopeToAdd
    )

    switch ($Resource) {
        "SharePoint" { $appId = $AzureResources.SharePoint }
        "GraphAPI" { $appId = $AzureResources.GraphAPI }
        default { }
    }
    $lms365App = Get-LMS365AppServicePrincipal
    $resourceApp = Get-ServicePrincipalByAppId -AppId $appId

    $appRoleIdToAdd = $resourceApp.AppRoles | Where-Object { $_.Value -eq $ScopeToAdd } | Select-Object -ExpandProperty Id
    if (-not $appRoleIdToAdd) {
        throw "Permission scope $ScopeToDelete cannot be found in $Resource app roles."
    }
    # Get all application permissions for the service principal
    $spApplicationPermission = Get-AzureADServiceAppRoleAssignedTo -ObjectId $lms365App.ObjectId -All $true `
                                    | Where-Object { $_.PrincipalType -eq "ServicePrincipal" -and $_.ResourceId -eq $resourceApp.ObjectId } `
                                    | Where-Object { $_.Id -eq $appRoleIdToAdd }
    if ($spApplicationPermission) {
        return
    }
    $token = Get-ADToken -TenantId $TenantId -UserName $UserName -ResourceId $AzureResources.GraphAPI -ClientId $AzureResources.WellKnownPSClientId
    if (-not $token) {
        throw "Access token for GrapAPI cannot be obtained using PowerShell client id."
    }
    $body = @{ 
        appRoleId   = $appRoleIdToAdd; 
        principalId = $lms365App.ObjectId
        resourceId  = $resourceApp.ObjectId
    }
    Invoke-RestMethod -Method POST `
        -ContentType "application/json" `
        -Uri "https://graph.microsoft.com/beta/servicePrincipals/$($lms365App.ObjectId)/appRoleAssignments" `
        -Headers @{Authorization = "Bearer $token" } `
        -Body $( $body | ConvertTo-Json)
}

