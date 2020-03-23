
function Install-AzureADModule {
    #https://www.powershellgallery.com/packages/AzureADPreview/2.0.2.85
    $azureAD = Get-Module -Name "AzureADPreview" -ListAvailable 
    if(-not $azureAD) {
        Install-Module -Name "AzureADPreview" -RequiredVersion "2.0.2.85"
    }
    else {
        Write-Verbose "Azure AD module already exists."
    }
}

function Invoke-ScriptUntillResult {
    param(
        [ScriptBlock] $ScriptBlock,
        [int]$WaitingTime = 4,
        [int]$MaxAttempts = 10
    )

    
    $currentRetry = 0;
    
    $completed = $false;
    $returnedValue = $null 
    while ($completed -eq $false -and $currentRetry -lt $maxAttempts) {
        try {
            $returnedValue = & $ScriptBlock
            $completed = $null -ne $returnedValue
        }
        catch {
            Write-Warning "Exception during call: $($_.Exception.Message)" -Verbose            
        }
        if(-not $completed){
            Write-Warning "Retrying call '$ScriptBlock'  Waiting time '$WaitingTime sec'" -Verbose
            Start-Sleep -s $waitingTime
            $waitingTime = $waitingTime + 4
            $currentRetry += 1
        }
    }
    if ($completed -eq $false) {
        throw $($Error[0])
    }
    return $returnedValue
}

function Get-LMS365AppServicePrincipal {
    return Get-AzureADServicePrincipal -SearchString "LMS365" | Where-Object { $_.AppId -eq $AzureResources.LMS365 }
}

function Get-LMS365AppClientServicePrincipal {
    return Get-AzureADServicePrincipal -SearchString "LMS365" | Where-Object { $_.AppId -eq $AzureResources.LMS365APIClient }
}


function Get-ServicePrincipalByAppId {
    param (
        [Parameter(Mandatory=$true)]
        [string] $AppId
    )
    return Get-AzureADServicePrincipal -All $true | Where-Object { $_.AppId -eq $AppId }
}
