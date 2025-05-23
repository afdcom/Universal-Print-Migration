# Universal Print Migration

This repository contains a helper script for migrating network printers to Universal Print printers on Windows 10/11 machines.

## Usage
1. Edit `Replace-LegacyPrinters.ps1` and update the `$PrinterMap` table with the Universal Print information for your printers. Each entry requires a `PrinterSharedId`, `PrinterSharedName` and `CloudDeviceId`.
2. Run the script in an elevated PowerShell session:
   ```powershell
   .\Replace-LegacyPrinters.ps1
   ```

The script enumerates installed printers using `Get-Printer`. If a printer's share name matches an entry in the mapping table, the script installs the associated Universal Print printer using `UPPrinterInstaller.exe`. On success, it removes the old printer.
