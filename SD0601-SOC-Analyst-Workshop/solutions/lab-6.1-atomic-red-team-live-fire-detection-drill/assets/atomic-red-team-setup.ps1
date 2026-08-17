#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Atomic Red Team Setup Script — Lab 6.1
    SD0601 SOC Analyst Workshop

.DESCRIPTION
    Installs Atomic Red Team (Invoke-AtomicRedTeam) and its prerequisites
    on the Windows Victim VM for the live-fire detection drill.

.NOTES
    Run from Administrator PowerShell on the Windows Victim VM.
    Requires internet access to download Atomics and dependencies.

.USAGE
    # Open Administrator PowerShell and run:
    Set-ExecutionPolicy Bypass -Scope Process -Force
    .\atomic-red-team-setup.ps1
#>

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Atomic Red Team Setup — SD0601 Lab 6.1         " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Set Execution Policy ──────────────────────────────────
Write-Host "[1/6] Setting execution policy..." -ForegroundColor Yellow
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force
Write-Host "      Done." -ForegroundColor Green

# ── Step 2: Install NuGet provider (required for PSGallery) ───────
Write-Host "[2/6] Ensuring NuGet provider is installed..." -ForegroundColor Yellow
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Confirm:$false
}
Write-Host "      Done." -ForegroundColor Green

# ── Step 3: Trust PSGallery ──────────────────────────────────────
Write-Host "[3/6] Trusting PSGallery repository..." -ForegroundColor Yellow
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Write-Host "      Done." -ForegroundColor Green

# ── Step 4: Install Invoke-AtomicRedTeam module ──────────────────
Write-Host "[4/6] Installing Invoke-AtomicRedTeam PowerShell module..." -ForegroundColor Yellow
$artInstallScript = "https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/master/install-atomicredteam.ps1"
try {
    IEX (IWR $artInstallScript -UseBasicParsing)
    Write-Host "      Invoke-AtomicRedTeam installed." -ForegroundColor Green
} catch {
    Write-Host "      ERROR: Could not download install script. Check internet connectivity." -ForegroundColor Red
    Write-Host "      Error: $_" -ForegroundColor Red
    exit 1
}

# ── Step 5: Download Atomic test definitions ─────────────────────
Write-Host "[5/6] Downloading Atomic test definitions (atomics folder)..." -ForegroundColor Yellow
$atomicsPath = "C:\AtomicRedTeam\atomics"
if (-not (Test-Path $atomicsPath)) {
    Install-AtomicRedTeam -getAtomics -Force -InstallPath "C:\AtomicRedTeam"
    Write-Host "      Atomics downloaded to $atomicsPath" -ForegroundColor Green
} else {
    Write-Host "      Atomics folder already exists at $atomicsPath — skipping download." -ForegroundColor Yellow
}

# ── Step 6: Install required Atomic prerequisites ────────────────
Write-Host "[6/6] Installing prerequisites for lab tests..." -ForegroundColor Yellow

# Import the module
Import-Module "C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -Force

# Install prereqs for the four lab tests
$labTests = @(
    @{ ID = "T1110"; Num = 1 },
    @{ ID = "T1053.005"; Num = 1 },
    @{ ID = "T1059.001"; Num = 1 }
)

foreach ($test in $labTests) {
    Write-Host "      Checking prereqs for $($test.ID)-$($test.Num)..." -ForegroundColor Cyan
    try {
        Invoke-AtomicTest $test.ID -TestNumbers $test.Num -GetPrereqs -ErrorAction SilentlyContinue
        Write-Host "      Prereqs installed for $($test.ID)." -ForegroundColor Green
    } catch {
        Write-Host "      Warning: Could not install prereqs for $($test.ID): $_" -ForegroundColor Yellow
    }
}

# ── Verification ─────────────────────────────────────────────────
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Verification                                    " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Checking Invoke-AtomicRedTeam module..." -ForegroundColor Yellow
if (Get-Module -ListAvailable -Name Invoke-AtomicRedTeam -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Invoke-AtomicRedTeam module available." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Module not found. Installation may have failed." -ForegroundColor Red
}

Write-Host ""
Write-Host "Checking atomics folder..." -ForegroundColor Yellow
if (Test-Path $atomicsPath) {
    $atomicsCount = (Get-ChildItem $atomicsPath -Directory).Count
    Write-Host "  [OK] Atomics folder exists: $atomicsCount technique folders found." -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Atomics folder not found at $atomicsPath." -ForegroundColor Red
}

Write-Host ""
Write-Host "Running show-details test for T1110..." -ForegroundColor Yellow
try {
    Invoke-AtomicTest T1110 -TestNumbers 1 -ShowDetails | Out-Null
    Write-Host "  [OK] T1110 test details available." -ForegroundColor Green
} catch {
    Write-Host "  [FAIL] Could not retrieve T1110 details: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Checking prereqs for lab tests..." -ForegroundColor Yellow
foreach ($test in $labTests) {
    try {
        $result = Invoke-AtomicTest $test.ID -TestNumbers $test.Num -CheckPrereqs 2>&1
        Write-Host "  [OK] $($test.ID)-$($test.Num) prereqs: $result" -ForegroundColor Green
    } catch {
        Write-Host "  [WARN] $($test.ID)-$($test.Num) prereq check failed: $_" -ForegroundColor Yellow
    }
}

# ── Quick Reference ──────────────────────────────────────────────
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Lab 6.1 Quick Reference — Attacker Commands    " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Import module before each session:" -ForegroundColor White
Write-Host "  Import-Module C:\AtomicRedTeam\invoke-atomicredteam\Invoke-AtomicRedTeam.psd1" -ForegroundColor Gray
Write-Host ""
Write-Host "Test 1 — T1110 (Brute Force):" -ForegroundColor White
Write-Host "  Invoke-AtomicTest T1110 -TestNumbers 1" -ForegroundColor Gray
Write-Host ""
Write-Host "Test 2 — T1053.005 (Scheduled Task):" -ForegroundColor White
Write-Host "  Invoke-AtomicTest T1053.005 -TestNumbers 1" -ForegroundColor Gray
Write-Host ""
Write-Host "Test 3 — T1059.001 (PowerShell):" -ForegroundColor White
Write-Host "  Invoke-AtomicTest T1059.001 -TestNumbers 1" -ForegroundColor Gray
Write-Host ""
Write-Host "Cleanup after each test:" -ForegroundColor White
Write-Host "  Invoke-AtomicTest T1110 -TestNumbers 1 -Cleanup" -ForegroundColor Gray
Write-Host "  Invoke-AtomicTest T1053.005 -TestNumbers 1 -Cleanup" -ForegroundColor Gray
Write-Host "  Invoke-AtomicTest T1059.001 -TestNumbers 1 -Cleanup" -ForegroundColor Gray
Write-Host ""
Write-Host "Setup complete. Atomic Red Team is ready for Lab 6.1." -ForegroundColor Green
Write-Host ""
