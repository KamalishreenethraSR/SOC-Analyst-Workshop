/*
    YARA Rules — Lab 4.1
    SD0601 SOC Analyst Workshop
    
    Usage:
      yara suspicious_rule.yar sample.exe
      yara -r suspicious_rule.yar /path/to/directory/
      
    MITRE ATT&CK References:
      T1566.001 — Phishing: Spearphishing Attachment
      T1204.002 — User Execution: Malicious File
      T1059.001 — Command and Scripting Interpreter: PowerShell
*/

// ════════════════════════════════════════════════════════════════
// Rule 1 — EICAR Test File Detection (Lab sample)
// This rule matches the standard EICAR antivirus test file
// ════════════════════════════════════════════════════════════════

rule Detect_EICAR_Test_File
{
    meta:
        description   = "Detects the EICAR antivirus test string"
        author        = "SOC Lab — SD0601"
        date          = "2024-08-14"
        version       = "1.0"
        tlp           = "TLP:WHITE"
        mitre_attack  = "N/A (test file — not a real threat)"
        reference     = "https://www.eicar.org/download-anti-malware-testfile/"

    strings:
        $eicar = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE" ascii

    condition:
        $eicar
}


// ════════════════════════════════════════════════════════════════
// Rule 2 — Suspicious Sample (Lab 4.1 primary rule)
// Matches the lab-provided sample by characteristic strings
// ════════════════════════════════════════════════════════════════

rule Suspicious_Lab_Sample
{
    meta:
        description   = "Detects Lab 4.1 sample by encoded PowerShell and download indicators"
        author        = "SOC Lab — SD0601"
        date          = "2024-08-14"
        version       = "1.0"
        tlp           = "TLP:AMBER"
        mitre_attack  = "T1204.002, T1059.001, T1105"
        severity      = "High"

    strings:
        // PowerShell download/execution indicators
        $ps_encoded   = "-EncodedCommand"         ascii nocase
        $ps_bypass    = "-ExecutionPolicy Bypass"  ascii nocase
        $ps_web       = "Invoke-WebRequest"        ascii nocase
        $ps_iex       = "IEX"                     ascii nocase
        $ps_download  = "DownloadFile"            ascii nocase

        // C2 / staging indicators
        $http_dl      = "http://"                 ascii
        $temp_path    = "\\AppData\\Local\\Temp\\" ascii nocase
        $payload_ext  = ".exe"                    ascii

        // EICAR string (for lab test file)
        $eicar_str    = "EICAR-STANDARD-ANTIVIRUS-TEST-FILE" ascii

    condition:
        // Match EICAR test file
        $eicar_str
        or
        // Match PowerShell downloader pattern
        (2 of ($ps_encoded, $ps_bypass, $ps_web, $ps_iex, $ps_download))
        or
        // Match staged download pattern
        ($http_dl and $temp_path and $payload_ext)
}


// ════════════════════════════════════════════════════════════════
// Rule 3 — Macro-Enabled Office Document Phishing Lure
// Detects .docm / .xlsm files with embedded VBA auto-exec
// ════════════════════════════════════════════════════════════════

rule Suspicious_Office_Macro_Dropper
{
    meta:
        description   = "Detects Office documents with VBA AutoOpen/AutoExec macros"
        author        = "SOC Lab — SD0601"
        date          = "2024-08-14"
        version       = "1.0"
        tlp           = "TLP:AMBER"
        mitre_attack  = "T1566.001, T1204.002"
        severity      = "High"

    strings:
        // OLE/OOXML magic bytes
        $ole_magic    = { D0 CF 11 E0 A1 B1 1A E1 }  // OLE2 compound document
        $zip_magic    = { 50 4B 03 04 }               // ZIP (OOXML format)

        // VBA auto-execution keywords
        $autoopen     = "AutoOpen"    ascii nocase wide
        $autoexec     = "AutoExec"    ascii nocase wide
        $document_open = "Document_Open" ascii nocase wide
        $workbook_open = "Workbook_Open" ascii nocase wide

        // Suspicious VBA actions
        $shell        = "Shell("      ascii nocase wide
        $wscript      = "WScript.Shell" ascii nocase wide
        $createobj    = "CreateObject" ascii nocase wide
        $powershell   = "powershell"   ascii nocase wide

    condition:
        // OLE or OOXML format
        ($ole_magic at 0 or $zip_magic at 0)
        // Has auto-execution trigger
        and (1 of ($autoopen, $autoexec, $document_open, $workbook_open))
        // Has suspicious code execution
        and (1 of ($shell, $wscript, $createobj, $powershell))
}


// ════════════════════════════════════════════════════════════════
// Rule 4 — Generic PowerShell Downloader (memory scan)
// Use with YARA memory scanning or on .ps1 script files
// ════════════════════════════════════════════════════════════════

rule PowerShell_Downloader_Generic
{
    meta:
        description   = "Detects common PowerShell download-and-execute patterns"
        author        = "SOC Lab — SD0601"
        date          = "2024-08-14"
        version       = "1.0"
        tlp           = "TLP:AMBER"
        mitre_attack  = "T1059.001, T1105"
        severity      = "Medium"

    strings:
        $iex_web      = /IEX\s*\(?\s*(New-Object\s+Net\.WebClient|Invoke-WebRequest)/ ascii nocase
        $encoded_dl   = /-EncodedCommand\s+[A-Za-z0-9+\/]{20,}={0,2}/ ascii nocase
        $webclient_dl = /New-Object\s+System\.Net\.WebClient/ ascii nocase wide
        $bitsadmin    = "BitsTransfer"  ascii nocase
        $certutil     = "certutil"      ascii nocase

    condition:
        any of them
}
