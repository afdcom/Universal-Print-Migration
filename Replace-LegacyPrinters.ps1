# Script: Replace-LegacyPrinters.ps1
# Description: Enumerates printers installed on a Windows computer and
# replaces them with Universal Print equivalents based on a mapping table.

# Hashtable mapping existing printer share names to Universal Print IDs
# Modify the values below to match your environment
$PrinterMap = @{
    "Edmonton - Main"  = "<UniversalPrintPrinterIdForEdmontonMain>"
    "Calgary - Main"   = "<UniversalPrintPrinterIdForCalgaryMain>"
    # Add additional mappings as required
}

# Retrieve all printers installed on the system
$installedPrinters = Get-Printer

foreach ($printer in $installedPrinters) {
    $shareName = $printer.ShareName
    if ([string]::IsNullOrEmpty($shareName)) {
        continue
    }

    if ($PrinterMap.ContainsKey($shareName)) {
        $upId = $PrinterMap[$shareName]

        try {
            # Add the Universal Print printer using its ID
            $null = Add-Printer -ConnectionName $upId -ErrorAction Stop
            Write-Host "Installed Universal Print $upId for printer $($printer.Name)." -ForegroundColor Green

            # Remove the old printer
            Remove-Printer -Name $printer.Name -ErrorAction Stop
            Write-Host "Removed legacy printer $($printer.Name)." -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to replace printer $($printer.Name): $_"
        }
    }
}
