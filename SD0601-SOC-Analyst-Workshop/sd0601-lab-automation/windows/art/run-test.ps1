#Requires -RunAsAdministrator
param(
    [string]$TechniqueID = "T1110",
    [int]$TestNumber = 1
)

$allowlistFile = Join-Path $PSScriptRoot "approved-tests.json"
if (Test-Path $allowlistFile) {
    $allowlist = Get-Content $allowlistFile | ConvertFrom-Json
    $matched = $allowlist.approved_tests | Where-Object { $_.technique_id -eq $TechniqueID -and $_.test_number -eq $TestNumber }
    if (-not $matched) {
        Write-Error "[BLOCKED] Technique $TechniqueID test $TestNumber is not in the lab allowlist."
        exit 1
    }
}

Write-Host "[OK] Executing approved Atomic Test: $TechniqueID-$TestNumber" -ForegroundColor Green
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -ErrorAction SilentlyContinue
Invoke-AtomicTest $TechniqueID -TestNumbers $TestNumber
