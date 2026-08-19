# Ransom Busters & Akira Tactical Mitigation Patch

This repository contains tactical mitigations to defend against recent behaviors exhibited by the "Ransom Busters" extortion group and Akira ransomware affiliates, as detailed in recent August 2026 threat intelligence reports. 

Because these threat actors rely heavily on Living off the Land (LotL) techniques, legitimate tool abuse, and credential theft, standard software patches are insufficient. This repo provides configuration-based blocks and auditing tools.

## Threat Actor TTPs Addressed
*   **Ransom Busters:** Use of `s5cmd` for AWS exfiltration, SoftPerfect Network Scanner, Remotely RMM, and local backdoors.
*   **Akira Affiliates:** Rebooting hosts into Safe Mode with Networking to bypass EDR agents via SonicWall VPN initial access.
*   **UNC6671:** Adversary-in-the-middle (AitM) phishing targeting M365 and Okta.

## Getting Started

### 1. Apply Endpoint Network Mitigations
Run the included PowerShell script on vulnerable endpoints to block known attacker infrastructure and audit for backdoor accounts.
\`\`\`powershell
# Must be run as Administrator
.\scripts\Invoke-RansomBustersMitigation.ps1
\`\`\`

### 2. Import EDR Blocklist
Import `edr_rules/ioc_blocklist.csv` into your Endpoint Detection and Response (EDR) platform (e.g., CrowdStrike, SentinelOne, Defender for Endpoint) to quarantine known malicious tooling and command-line arguments.

### 3. Immediate Infrastructure Hardening (Manual Actions Required)
*   **SonicWall VPNs:** Update firmware immediately and enforce strict MFA for all accounts.
*   **Identity Providers:** Transition to FIDO2 / WebAuthn hardware keys to defeat UNC6671's AitM phishing proxy tactics.
*   **PowerShell:** Enforce `Set-ExecutionPolicy RemoteSigned` and enable Script Block Logging (Event ID 4104) to catch Remotely RMM deployment scripts.
