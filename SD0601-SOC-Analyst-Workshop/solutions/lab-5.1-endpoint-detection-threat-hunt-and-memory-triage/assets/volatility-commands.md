# Volatility3 Command Reference — Lab 5.1

**Memory Triage Reference for Analysts**  
Platform: Windows memory images  
Tool: Volatility3 (`vol.py`)

---

## Installation

```bash
# Python 3.9+ required
python3 -m venv ~/vol3-env && source ~/vol3-env/bin/activate
pip install volatility3

# Verify
vol.py --version
# Volatility 3 Framework 2.x.x
```

---

## Core Commands

### System Information

```bash
# Get OS version, kernel, and architecture
vol.py -f victim.mem windows.info

# Expected output (excerpt):
# Kernel Base         0xf8024e800000
# DTB                 0x1aa000
# Symbols             file:///home/.../windows/ntkrnlmp.pdb/...
# Is64Bit             True
# IsPAE               False
# layer_name          WindowsIntel32e
# memory_layer        FileLayer
# KdVersionBlock      0xf8024ec01428
# Major/Minor         15.19041        ← Windows 10 build 19041
```

---

### Process Analysis

```bash
# List all processes (flat)
vol.py -f victim.mem windows.pslist

# Process tree (parent-child relationships)
vol.py -f victim.mem windows.pstree

# Detect hidden/unlinked processes (rootkit detection)
vol.py -f victim.mem windows.psscan

# Cross-reference pslist vs psscan (find discrepancies = likely hidden processes)
# Processes in psscan but not pslist = possible process hiding
```

**Suspicious indicators in process list:**
- `svchost.exe` with parent other than `services.exe` (PID 676 typically)
- `lsass.exe` with multiple instances or unusual parent
- Misspelled process names (`svch0st`, `lsaas`, `scvhost`)
- Processes running from `\Temp`, `\AppData`, `\Users\Public`
- `powershell.exe` or `cmd.exe` with parent = Office app or browser

```bash
# Get process command lines (what were they launched with?)
vol.py -f victim.mem windows.cmdline

# Get command line for specific PID
vol.py -f victim.mem windows.cmdline --pid 3412

# Expected (malicious):
# PID  Process       Args
# 3412 powershell.exe C:\Windows\System32\powershell.exe -ExecutionPolicy Bypass -EncodedCommand JAB...
```

---

### Network Analysis

```bash
# Show all network connections (TCP + UDP)
vol.py -f victim.mem windows.netscan

# Expected output (excerpt):
# Offset     Proto  LocalAddr     LocalPort  ForeignAddr      ForeignPort  State        PID  Owner
# 0x...      TCPv4  10.10.1.45    49812      185.220.101.55   443          ESTABLISHED  3412 powershell.exe
# 0x...      TCPv4  10.10.1.45    0          0.0.0.0          0            CLOSED       1234 svchost.exe
# 0x...      UDPv4  0.0.0.0       5353       *                *                         1172 svchost.exe

# Filter for ESTABLISHED connections to external IPs
vol.py -f victim.mem windows.netscan | grep -E "ESTABLISHED" | grep -v "10\.|192\.168\.|172\."
```

---

### Memory and DLL Analysis

```bash
# List DLLs loaded by a specific process
vol.py -f victim.mem windows.dlllist --pid 3412

# Check for injected code (unusual DLLs or memory-only sections)
vol.py -f victim.mem windows.malfind --pid 3412
# Dumps suspicious memory regions that have:
#   - MZ header (executable)
#   - Marked as EXECUTE + WRITE (PAGE_EXECUTE_READWRITE)
#   - Not backed by a file on disk

# Dump suspicious process memory for further analysis
vol.py -f victim.mem windows.dumpfiles --pid 3412
```

---

### Registry Analysis

```bash
# List registry hives loaded in memory
vol.py -f victim.mem windows.registry.hivelist

# Read specific registry key (persistence check)
vol.py -f victim.mem windows.registry.printkey \
  --key "SOFTWARE\Microsoft\Windows\CurrentVersion\Run"

# Get all Run keys from all hives
vol.py -f victim.mem windows.registry.printkey \
  --key "SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
```

---

### User and Credential Analysis

```bash
# List local user accounts from registry
vol.py -f victim.mem windows.registry.printkey --key "SAM\Domains\Account\Users\Names"

# Extract NTLM hashes from memory (requires elevated access in image)
vol.py -f victim.mem windows.hashdump

# Check for credential artifacts in LSASS
# (Look for lsass.exe in process list then use malfind/dumpfiles)
vol.py -f victim.mem windows.dumpfiles --pid <lsass_pid>
```

---

### Scheduled Tasks and Services

```bash
# List services from registry
vol.py -f victim.mem windows.svcscan

# Look for unusual service names or binary paths
vol.py -f victim.mem windows.svcscan | grep -v "System32\|SysWOW64" | grep -i "exe"
```

---

## Triage Workflow Checklist

```
Step 1: windows.info       → Confirm OS build, 64-bit, kernel
Step 2: windows.pslist     → Full process list
Step 3: windows.pstree     → Find abnormal parent-child chains
Step 4: windows.psscan     → Cross-check for hidden processes
Step 5: windows.cmdline    → Get command lines for suspicious PIDs
Step 6: windows.netscan    → Map network connections to PIDs
Step 7: windows.dlllist    → Check DLLs for suspicious PIDs
Step 8: windows.malfind    → Detect injected code regions
Step 9: windows.registry   → Check Run keys for persistence
Step 10: Correlate findings → Build mini forensic note
```

---

## Common MITRE ATT&CK Mappings from Volatility Findings

| Finding | Likely MITRE Technique |
|---------|----------------------|
| Office process → PowerShell in pstree | T1566.001 + T1059.001 |
| Non-svchost parent for svchost | T1055 (Process Injection) |
| EXECUTE_READWRITE region in process | T1055 or T1027 |
| LSASS memory access from non-system process | T1003.001 |
| External ESTABLISHED connection from unexpected process | T1071 / T1041 |
| Suspicious Run key in registry | T1547.001 |
| Unusual service binary path | T1543.003 |

---

[⬅ Back to Lab 5.1 Solution](../solution.md)
