# Universal Print Migration

This repository contains a helper script for migrating network printers to Universal Print printers on Windows 10/11 machines.

## Usage
1. Edit `Replace-LegacyPrinters.ps1` and update the `$PrinterMap` hashtable with mappings of existing share names to Universal Print printer IDs.
2. Run the script in an elevated PowerShell session:
   ```powershell
   .\Replace-LegacyPrinters.ps1
   ```

The script enumerates installed printers using `Get-Printer`. If a printer's share name matches an entry in the mapping table, the script attempts to add the corresponding Universal Print printer and, if successful, removes the legacy printer.
