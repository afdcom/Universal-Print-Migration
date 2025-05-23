# Script: Replace-LegacyPrinters.ps1
# Description: Enumerates printers installed on a Windows computer and
# replaces them with Universal Print equivalents based on a mapping table.

# Hashtable mapping existing printer share names to Universal Print settings
# Modify the values below to match your environment. Each entry should contain
#   PrinterSharedId  - The Universal Print printer shared ID
#   PrinterSharedName - The name to display for the printer
#   CloudDeviceId    - The Universal Print cloud device ID
$PrinterMap = @{
    "Edmonton - Main" = @{ 
        PrinterSharedId = "<PrinterSharedIdForEdmonton>"
        PrinterSharedName = "Edmonton - Main"
        CloudDeviceId = "<CloudDeviceIdForEdmonton>"
    }
    "Calgary - Main" = @{
        PrinterSharedId = "<PrinterSharedIdForCalgary>"
        PrinterSharedName = "Calgary - Main"
        CloudDeviceId = "<CloudDeviceIdForCalgary>"
    }
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
        $info = $PrinterMap[$shareName]
        $printerSharedId = $info.PrinterSharedId
        $printerSharedName = $info.PrinterSharedName
        $cloudDeviceId = $info.CloudDeviceId

        try {
            $args = @(
                '-install'
                "-printersharedid $printerSharedId"
                "-printersharedname `"$printerSharedName`""
                "-clouddeviceid $cloudDeviceId"
            )

            $process = Start-Process -FilePath "$env:WINDIR\System32\UPPrinterInstaller.exe" `
                -ArgumentList $args -NoNewWindow -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host "Installed Universal Print $printerSharedName for printer $($printer.Name)." -ForegroundColor Green
                Remove-Printer -Name $printer.Name -ErrorAction Stop
                Write-Host "Removed legacy printer $($printer.Name)." -ForegroundColor Green
            }
            else {
                Write-Warning "UPPrinterInstaller failed with exit code $($process.ExitCode) for printer $($printer.Name)"
            }
        }
        catch {
            Write-Warning "Failed to replace printer $($printer.Name): $_"
        }
    }
}
