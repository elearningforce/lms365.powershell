
function Get-ADToken {
    param (
        [Parameter(Mandatory = $true)]
        [string] $TenantId,
        [Parameter(Mandatory = $true)]
        [string] $ResourceId,
        [Parameter(Mandatory = $true)]
        [string] $ClientId,
        [Parameter(Mandatory = $true)]
        [string] $UserName
    )

    $authContext = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext]::new("$LoginEndPoint/$TenantId")
    $result = $authContext.AcquireTokenAsync($ResourceId, `
                                    $ClientId, `
                                    [System.Uri]::new("urn:ietf:wg:oauth:2.0:oob"), `
                                    [Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters]::new([Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto), `
                                    [Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifier]::new($UserName, [Microsoft.IdentityModel.Clients.ActiveDirectory.UserIdentifierType]::RequiredDisplayableId)).GetAwaiter().GetResult();

    return $result.AccessToken
}

