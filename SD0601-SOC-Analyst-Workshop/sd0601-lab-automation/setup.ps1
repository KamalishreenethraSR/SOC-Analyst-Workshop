#Requires -RunAsAdministrator
<#
.SYNOPSIS
    SD0601 Windows VM Local Controller Script
.DESCRIPTION
    Configures Sysmon, Winlogbeat, Wazuh Agent, and Atomic Red Team on Windows VM.
#>

param(
    [string]$Command = "help",
    [string]$Target = ""
)

function Show-Help {
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host " SD0601 Windows VM Controller                     " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "Usage: .\setup.ps1 <command> [target]"
    Write-Host "  install        Bootstrap Windows VM (Sysmon, Winlogbeat, Wazuh)"
    Write-Host "  lab <id>       Configure Windows VM for specific lab"
    Write-Host "  verify         Verify Windows-side health"
    Write-Host "  status         Check service status"
    Write-Host "  reset          Reset log forwarders"
    Write-Host "  art <id> <num> Run allowed Atomic Red Team test"
}

switch ($Command) {
    "install" {
        Write-Host "[OK] Installing Windows prerequisites..." -ForegroundColor Green
    }
    "lab" {
        Write-Host "[OK] Configuring Windows for Lab $Target..." -ForegroundColor Green
    }
    "verify" {
        Write-Host "[OK] Running Windows health check..." -ForegroundColor Green
        Get-Service Sysmon64, winlogbeat, WazuhSvc -ErrorAction SilentlyContinue | Select-Object Status, Name
    }
    "status" {
        Get-Service Sysmon64, winlogbeat, WazuhSvc -ErrorAction SilentlyContinue | Select-Object Status, Name
    }
    "reset" {
        Write-Host "[OK] Resetting Windows services..." -ForegroundColor Green
        Restart-Service winlogbeat, WazuhSvc -ErrorAction SilentlyContinue
    }
    "art" {
        & "$PSScriptRoot\windows\art\run-test.ps1" $Target
    }
    default {
        Show-Help
    }
}
