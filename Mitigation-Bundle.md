# 🛡️ Ransom Busters & Akira Tactical Mitigation Bundle

This unified repository bundle contains technical documentation, deployment guides, PowerShell hardening scripts, and EDR blocklists to mitigate August 2026 threat activity associated with **Ransom Busters**, **Akira** affiliates, and **UNC6671**.

---

## 📋 Table of Contents
1. [Overview & Threat Intelligence](#-overview--threat-intelligence)
2. [MITRE ATT&CK Mapping](#-mitre-attck-mapping)
3. [Setup & Installation Guide](#-setup--installation-guide)
4. [Executable Mitigation Script (`Invoke-RansomBustersMitigation.ps1`)](#-executable-mitigation-script)
5. [EDR Blocklist CSV (`ioc_blocklist.csv`)](#-edr-blocklist-csv)
6. [Auto-Installer Script](#-auto-installer-script-generate-repository)

---

## 📖 Overview & Threat Intelligence

Threat reports detail an operational shift by ransomware affiliates and extortion groups:

* **Ransom Busters:** Claims to hack ransomware administrative panels and offer victim organizations file deletion services for $20,000–$60,000. Investigation shows this persona is likely a ransomware affiliate betraying partners or obfuscating true access. Common tactics include using `s5cmd` for AWS exfiltration, SoftPerfect Network Scanner (`netscan.exe`), Remotely RMM, and local backdoors using password `Numlock!123`.
* **Akira Affiliates:** Observed rebooting compromised hosts into **Safe Mode with Networking** via `bcdedit` to knock Endpoint Detection and Response (EDR) agents offline.
* **UNC6671 (Cordial Spider):** Conducting adversary-in-the-middle (AitM) phishing targeting financial and legal sectors to bypass standard MFA.

Because these actors rely heavily on Living off the Land (LotL) tools and credential theft rather than a single software vulnerability, mitigation requires direct endpoint configuration and behavioral blocking.

---

## 🎯 MITRE ATT&CK Mapping

| Threat Actor | Tool / Technique | MITRE ATT&CK ID | Mitigation |
| :--- | :--- | :--- | :--- |
| **Ransom Busters** | `s5cmd.exe` | [T1567.002](https://attack.mitre.org/techniques/T1567/002/) Cloud Storage Exfiltration | EDR Blocklist |
| **Ransom Busters** | SoftPerfect (`netscan.exe`) | [T1046](https://attack.mitre.org/techniques/T1046/) Network Service Discovery | EDR Blocklist |
| **Ransom Busters** | Remotely RMM via PowerShell | [T1219](https://attack.mitre.org/techniques/T1219/) Remote Access Software | EDR Blocklist |
| **Ransom Busters** | Password `Numlock!123` | [T1136.001](https://attack.mitre.org/techniques/T1136/001/) Local Account Backdoor | Local Account Audit |
| **Ransom Busters** | Hostname `DESKTOP-BBETH6K` | [T1071](https://attack.mitre.org/techniques/T1071/) Application Layer Protocol | Firewall Rule |
| **Akira** | `bcdedit` Safe Mode Reboot | [T1562.009](https://attack.mitre.org/techniques/T1562/009/) Safe Mode Boot | BitLocker Enforcement & EDR |

---

## ⚙️ Setup & Installation Guide

### Prerequisites
* **Supported OS:** Windows 10/11 or Windows Server 2016+
* **Permissions:** Local Administrator privileges (standalone) or Intune/Domain Admin (enterprise)
* **PowerShell:** Version 5.1 or newer

### Installation Steps

1. **Local Endpoint Testing:**
   Open PowerShell as Administrator and run the embedded script section.
   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force
   .\Invoke-RansomBustersMitigation.ps1
