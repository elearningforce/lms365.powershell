function Get-LMS365APIAccessToken {
    

    Get-AdToken -TenantId $TenantId -ResourceId $AzureResources.LMS365API -ClientId $AzureResources.LMS365APIClient -UserName $UserName
}