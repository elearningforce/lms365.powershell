function Get-LMS365TenantProvisionUrl {
    param (
        # Target tenant id.
        [Parameter(Mandatory= $true)]
        [string]
        $TenantId,
        # LMS365 region.
        [Parameter(Mandatory=$true)]
        [string]
        $Region
    )
    
    switch ($Region) {
        "NorthEurope" { $prefix = "ne"  }
        "CentralUS" { $prefix = "us" }
        "JapanEast" { $prefix = "je" }
        "AustraliaEast" { $prefix = "au" }
        "CanadaCentral" { $prefix = "ca" }
        Default {}
    }
    if(-not $prefix) {
        throw "Unknown $Region"
    }
    $tIdStr = [guid]::Parse($TenantId).ToString("N")
    return "https://$prefix-lms.365.systems/tenant/$tIdStr/global/tenant/CreateManually?dcRegion=$Region"
}