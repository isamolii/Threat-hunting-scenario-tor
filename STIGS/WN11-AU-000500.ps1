}<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Isaias Molina
    LinkedIn        : linkedin.com/in/isaiasmolina/
    GitHub          : github.com/isamolii
    Date Created    : 2026-03-17
    Last Modified   : 2026-03-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# YOUR CODE GOES HERE
# Run this in an elevated PowerShell (right-click PowerShell -> Run as administrator)
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$desiredValue = 65536  # Decimal; 65536 KB = 64 MB (or set to 32768 for exact minimum)

# Create the path if it doesn't exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
    Write-Host "Created registry path: $regPath"
}

# Set or update the MaxSize value (DWORD)
Set-ItemProperty -Path $regPath -Name "MaxSize" -Value $desiredValue -Type DWord -Force

# Verify
$currentValue = Get-ItemProperty -Path $regPath -Name "MaxSize" -ErrorAction SilentlyContinue
if ($currentValue) {
    Write-Host "MaxSize set to: $($currentValue.MaxSize) (decimal)"
    if ($currentValue.MaxSize -ge 32768) {
        Write-Host "Value meets or exceeds STIG minimum (32768 KB). Good."
    } else {
        Write-Host "Warning: Value is below 32768 KB!"
    }
} else {
    Write-Host "Failed to read back the value - check permissions."
}
