param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
    [switch]$UseSymlink
)

$ErrorActionPreference = 'Stop'

$vault = Join-Path $RepoRoot 'vault'
$skillsSource = Join-Path $RepoRoot 'skills'
$skillSource = Join-Path $skillsSource 'obsidian-memory'
$codexHome = Join-Path $env:USERPROFILE '.codex'
$codexSkills = Join-Path $codexHome 'skills'
$skillTarget = Join-Path $codexSkills 'obsidian-memory'
$configPath = Join-Path $codexHome 'config.toml'
$pluginDir = Join-Path $vault '.obsidian\plugins\obsidian-local-rest-api'
$pluginData = Join-Path $pluginDir 'data.json'

if (-not (Test-Path $vault)) {
    throw "Vault not found: $vault"
}

if (-not (Test-Path $skillsSource)) {
    throw "Skills directory not found: $skillsSource"
}

New-Item -ItemType Directory -Force -Path $pluginDir, $codexSkills | Out-Null

if (-not (Test-Path $pluginData)) {
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $apiKeyBytes = New-Object byte[] 32
    $rng.GetBytes($apiKeyBytes)
    $rng.Dispose()
    $apiKey = [Convert]::ToBase64String($apiKeyBytes).TrimEnd('=').Replace('+','-').Replace('/','_')

    @{
        apiKey = $apiKey
        port = 27124
        enableInsecureServer = $true
        insecurePort = 27123
        hostname = '127.0.0.1'
    } | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $pluginData -Encoding UTF8
} else {
    $apiKey = (Get-Content -LiteralPath $pluginData -Raw | ConvertFrom-Json).apiKey
}

foreach ($sourceSkill in Get-ChildItem -LiteralPath $skillsSource -Directory) {
    $targetSkill = Join-Path $codexSkills $sourceSkill.Name

    if ($UseSymlink) {
        if (Test-Path $targetSkill) {
            $item = Get-Item -LiteralPath $targetSkill -Force
            if (-not ($item.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
                $backup = "$targetSkill.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
                Move-Item -LiteralPath $targetSkill -Destination $backup
            } else {
                Remove-Item -LiteralPath $targetSkill -Force
            }
        }
        New-Item -ItemType SymbolicLink -Path $targetSkill -Target $sourceSkill.FullName | Out-Null
    } else {
        New-Item -ItemType Directory -Force -Path $targetSkill | Out-Null
        robocopy $sourceSkill.FullName $targetSkill /E /NFL /NDL /NJH /NJS /NP | Out-Null
    }
}

if (-not (Test-Path $configPath)) {
    New-Item -ItemType File -Force -Path $configPath | Out-Null
}

$backup = "$configPath.bak-obsidian-memory-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item -LiteralPath $configPath -Destination $backup

$config = Get-Content -LiteralPath $configPath -Raw
$config = [regex]::Replace($config, '(?ms)^\[mcp_servers\.obsidian\].*?(?=^\[|\z)', '')
$config = [regex]::Replace($config, '(?ms)^\[mcp_servers\.obsidian\.http_headers\].*?(?=^\[|\z)', '')

$block = @"
[mcp_servers.obsidian]
enabled = true
url = "http://127.0.0.1:27123/mcp/"
startup_timeout_sec = 20
tool_timeout_sec = 120

[mcp_servers.obsidian.http_headers]
Authorization = "Bearer $apiKey"
"@

$config = $config.TrimEnd() + "`r`n`r`n" + $block + "`r`n"
Set-Content -LiteralPath $configPath -Value $config -Encoding UTF8

$obsidianGlobal = Join-Path $env:APPDATA 'obsidian'
New-Item -ItemType Directory -Force -Path $obsidianGlobal | Out-Null
$obsidianJson = Join-Path $obsidianGlobal 'obsidian.json'
$md5 = [System.Security.Cryptography.MD5]::Create()
$vaultIdBytes = $md5.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($vault.ToLowerInvariant()))
$md5.Dispose()
$vaultId = -join ($vaultIdBytes | ForEach-Object { $_.ToString('x2') })

$global = @{ vaults = @{} }
if (Test-Path $obsidianJson) {
    try {
        $global = Get-Content -LiteralPath $obsidianJson -Raw | ConvertFrom-Json -AsHashtable
    } catch {
        $global = @{ vaults = @{} }
    }
}
if (-not $global.ContainsKey('vaults')) {
    $global['vaults'] = @{}
}
$global['vaults'][$vaultId] = @{
    path = $vault
    ts = [DateTimeOffset]::Now.ToUnixTimeMilliseconds()
    open = $true
}
$global | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $obsidianJson -Encoding UTF8

Write-Output "Vault: $vault"
Write-Output "Skills: $codexSkills"
Write-Output "Codex config backup: $backup"
Write-Output "Restart Obsidian and Codex Desktop after setup."
