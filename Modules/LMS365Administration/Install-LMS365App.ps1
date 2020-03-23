function Install-LMS365App {
    param (
        [Parameter(Mandatory = $true)]
        [string] $TenantId,
        [Parameter(Mandatory = $true)]
        [string] $UserName
    )
    
    Write-Verbose "Install LMS365"
    try{
        Get-AdToken -TenantId $TenantId -ResourceId $AzureResources.GraphAPI -ClientId $AzureResources.LMS365 -UserName $UserName | Out-Null
    }
    catch{
        if(-not $_.Exception.Message.Contains("AADSTS7000218:")){
            throw $_
        }
        else {
            Write-Verbose $_.Exception.Message
        }
    }
    Write-Verbose "Install LMS365 Native Client"
    Get-AdToken -TenantId $TenantId -ResourceId $AzureResources.LMS365API -ClientId $AzureResources.LMS365APIClient -UserName $UserName | Out-Null

    Invoke-ScriptUntillResult { Get-LMS365AppServicePrincipal } | Out-Null
    Invoke-ScriptUntillResult { Get-LMS365AppClientServicePrincipal } | Out-Null
}
