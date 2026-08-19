<#
.SYNOPSIS
    Applies local mitigations against Ransom Busters and Akira TTPs.
.DESCRIPTION
    Blocks known attacker hostnames, audits for hardcoded backdoor accounts, 
    and verifies BitLocker configuration to prevent seamless Safe Mode reboots.
#>

# Requires Admin privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as an Administrator."
    break
}

Write-Host "Applying Ransom Busters & Akira Mitigations..." -ForegroundColor Cyan

# 1. Block Attacker Hostname (DESKTOP-BBETH6K)
Write-Host "[*] Blocking attacker-controlled hostname: DESKTOP-BBETH6K..."
New-NetFirewallRule -DisplayName "BLOCK-RansomBusters-In" -Direction Inbound -Action Block -RemoteMachine "DESKTOP-BBETH6K" -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "BLOCK-RansomBusters-Out" -Direction Outbound -Action Block -RemoteMachine "DESKTOP-BBETH6K" -Profile Any -ErrorAction SilentlyContinue

# 2. Audit Local Accounts for the Backdoor
Write-Host "[*] Auditing enabled local users. Verify these do not use the known backdoor password (Numlock!123)..." -ForegroundColor Yellow
Get-LocalUser | Where-Object { $_.Enabled -eq $true } | Select-Object Name, PrincipalSource, LastLogon

# 3. Mitigate Safe Mode Abuse (Akira TTP)
Write-Host "[*] Verifying BitLocker configuration for Safe Mode protection..."
$BitLocker = Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue
if ($BitLocker.VolumeStatus -eq 'FullyEncrypted') {
    Write-Host "[+] BitLocker is enabled. Ensure a pre-boot PIN is enforced to break the Akira Safe Mode reboot chain." -ForegroundColor Green
} else {
    Write-Host "[-] WARNING: BitLocker is not enabled on C:. Attackers can reboot into Safe Mode seamlessly to bypass EDR." -ForegroundColor Red
}

Write-Host "Patch script execution complete." -ForegroundColor Cyan
