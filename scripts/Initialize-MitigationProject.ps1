# Create Directory Structure
New-Item -ItemType Directory -Force -Path "ransom-busters-mitigation/scripts" | Out-Null
New-Item -ItemType Directory -Force -Path "ransom-busters-mitigation/edr_rules" | Out-Null

# Write Script File
@'
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Run as Administrator."
    break
}
New-NetFirewallRule -DisplayName "BLOCK-RansomBusters-In" -Direction Inbound -Action Block -RemoteMachine "DESKTOP-BBETH6K" -Profile Any -ErrorAction SilentlyContinue
New-NetFirewallRule -DisplayName "BLOCK-RansomBusters-Out" -Direction Outbound -Action Block -RemoteMachine "DESKTOP-BBETH6K" -Profile Any -ErrorAction SilentlyContinue
Get-LocalUser | Where-Object { $_.Enabled -eq$true } | Select-Object Name, PrincipalSource, LastLogon
Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue
'@ | Out-File -FilePath "ransom-busters-mitigation/scripts/Invoke-RansomBustersMitigation.ps1" -Encoding utf8

# Write CSV File
@"
Type,Indicator,Context,Recommended_Action
File_Name,s5cmd.exe,Used by Ransom Busters for AWS data exfiltration,Block_and_Quarantine
File_Name,netscan.exe,SoftPerfect Network Scanner used for internal recon,Alert_and_Quarantine
File_Name,Remotely.exe,Unauthorized RMM tool used for persistence,Block_and_Quarantine
Command_Line,"bcdedit /set {current} safeboot network",Akira tactic to force Safe Mode and disable EDR,Alert_and_Block_Execution
Credential_Password,Numlock!123,Hardcoded password for local backdoor account,Alert_on_Use
Network_Hostname,DESKTOP-BBETH6K,Known attacker-controlled machine,Block_Traffic
"@ | Out-File -FilePath "ransom-busters-mitigation/edr_rules/ioc_blocklist.csv" -Encoding utf8

Write-Host "Repository structure generated successfully in ./ransom-busters-mitigation" -ForegroundColor Green
