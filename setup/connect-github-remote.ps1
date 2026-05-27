param(
    [Parameter(Mandatory = $true)]
    [string]$RemoteUrl,

    [string]$RemoteName = 'origin',

    [switch]$Push
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Push-Location $repoRoot
try {
    $existing = git remote get-url $RemoteName 2>$null
    if ($LASTEXITCODE -eq 0 -and $existing) {
        git remote set-url $RemoteName $RemoteUrl
    } else {
        git remote add $RemoteName $RemoteUrl
    }

    git branch -M main

    if ($Push) {
        git push -u $RemoteName main
    }

    Write-Output "Remote '$RemoteName' -> $RemoteUrl"
} finally {
    Pop-Location
}
