
function Set-LMS365DelegatedPermission {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $TenantId,
        [Parameter(Mandatory = $true)]
        [string] $UserName,
        [Parameter(Mandatory=$true)]
        [ValidateSet("SharePoint", "GraphAPI")]
        [string] $Resource,
        [Parameter(Mandatory=$true)]
        [string] $DesiredScopes
    )

    switch ($Resource) {
        "SharePoint" { $appId = $AzureResources.SharePoint  }
        "GraphAPI" { $appId = $AzureResources.GraphAPI  }
        Default {}
    }
    $lms365App = Get-LMS365AppServicePrincipal
    $resourceApp = Get-ServicePrincipalByAppId -AppId $appId
    if(-not $resourceApp) {
        throw "Resource $Resource : $appId not found."
    }
    $oauthPermission = Get-AzureADOAuth2PermissionGrant -All $true | Where-Object {$_.ClientId -eq $lms365App.ObjectId -and $_.ResourceId -eq $resourceApp.ObjectId }
    if(-not $oauthPermission){
        throw "LMS365 permissions for $Resource cannot be found."
    }
    $token = Get-ADToken -TenantId $TenantId -UserName $UserName -ResourceId $AzureResources.GraphAPI -ClientId $AzureResources.WellKnownPSClientId
    if(-not $token){
        throw "Access token for GrapAPI cannot be obtained using PowerShell client id."
    }
    Invoke-RestMethod -Method PATCH `
                      -ContentType "application/json" `
                      -Uri "https://graph.microsoft.com/beta/oAuth2Permissiongrants/$($oauthPermission.ObjectId)" `
                      -Headers @{Authorization = "Bearer $token"} `
                      -Body $(@{ scope = $DesiredScopes } | ConvertTo-Json)
}
