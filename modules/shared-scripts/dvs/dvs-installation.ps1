# Copyright © 2023 Audinate Pty Ltd ACN 120 828 006 (Audinate). All rights reserved.
# This script requires the DVS_VERSION env variable to be set prior to execution

if (-not $Env:DVS_VERSION) {
    throw "DVS_VERSION environment variable must be set."
}

# Helper function whether a directory or file exists.
function FileExists([string]$path) {
    return Test-Path $path
}

# Helper function to download a file
function DownloadFile([string] $remoteFile, [string] $localFile) {
    Write-Output "Download $remoteFile"
    Invoke-WebRequest -Uri $remoteFile -OutFile $localFile
}

# Delete a file (and retry when failing)
function DeleteFileSafe([string] $file) {
    $finished = $false;
    $attemptsLeft = 6;
    do {
        Remove-Item -Path $file -Force
        if (FileExists $file) {
            Write-Output "$file could not be removed, retry in 10 seconds.."
            Start-Sleep -Seconds 10
        } else {
            Write-Output "$file deleted"
            $finished = $true
        }
        $attemptsLeft = $attemptsLeft - 1;
    } 
    while (-not $finished -and $attemptsLeft -gt 0)
}

# Unzip an archive
function Unzip([string] $file) {
    Expand-Archive -Path $file -DestinationPath . -Force
}

# Add an exclusion to windows defender
function AddDefenderExclusion([string] $file) {
    Add-MpPreference -ExclusionPath $file
}

##
# Start of script
##

# Create the working directory when it does not exist.
$WorkingDir = "C:\ProgramData\Audinate\Bootstrap\"
if (-Not (FileExists $WorkingDir )) {
    New-Item -Path $WorkingDir -ItemType Directory
}
Set-Location $WorkingDir

# To avoid false Defender reports on DVS
AddDefenderExclusion "C:\Program Files (x86)\Audinate\Dante Virtual Soundcard"

# Download and extract DVS Installer and DVS Command Line interface
Write-Output "Download Installers"
DownloadFile "${Env:DVS_RESOURCE_URL}/DVS-${Env:DVS_VERSION}_windows.exe" "DVS_Installer.exe"
DownloadFile "${Env:DVS_RESOURCE_URL}/DvsCli-${Env:DVS_VERSION}_windows.zip" "DvsCli.zip"
Unzip DvsCli.zip
Write-Output "Download Installers Done!"

# Install DVS
Write-Output "Start DVS installation"
.\DVS_Installer.exe /passive /norestart
Write-Output "Start DVS installation Done!"

# Wait for the installer to finish (it tries to setup a session to the DVS service )
.\dvs_cli.exe exit
Write-Output "Start DVS installer finished!"

# Delete the downloaded content
Write-Output "Remove files"
DeleteFileSafe $WorkingDir\DvsCli.zip
DeleteFileSafe $WorkingDir\DVS_Installer.exe
Write-Output "Remove files Done!"

# Create the DVS configuration script
Write-Output "Create config script"
$DVSConfigScript = @"
# Copyright (C) 2023 Audinate Pty Ltd ACN 120 828 006 (Audinate). All rights reserved.

param (
    [Parameter(Mandatory)][string]`$DVSLicense,
    [Parameter(Mandatory)][string]`$AudioDriver,
    [Parameter(Mandatory)][int]`$ChannelCount,
    [Parameter(Mandatory)][int]`$Latency,
    [string]`$LicenseServerApiKey,
    [string]`$LicenseServerHostname,
    [hashtable]`$DDMAddress
)

# Input validation
if (`$DDMAddress -and (-not `$(`$DDMAddress.Ip) -or -not `$(`$DDMAddress.Port))) {
    throw "The IP and port must be set for static DDM reference."
}

# If both LicenseServerHostname and LicenseServerApiKey override New-ItemProperty with Force flag to update values when exist
if( `$LicenseServerApiKey -and `$LicenseServerHostname) {
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Audinate'\Dante Virtual Soundcard\' -Name LicenseServerHostname -PropertyType String -Value `$LicenseServerHostname -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Audinate'\Dante Virtual Soundcard\' -Name LicenseServerApiKey -PropertyType String -Value `$LicenseServerApiKey -Force
Restart-Service dvs.manager
}

# Select first available Network Interface Card
C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe interface=`$( (Get-NetAdapter | select -first 1).MacAddress -Replace '-', ':' ) exit

# Applying the License
C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe licensekey=`$( `$DVSLicense.Replace('-', '') ) exit

# Static DDM reference. Device will appear under "Unmanaged"
if (`$DDMAddress) {
    `$DDMConfiguration = "type STATIC`r`naddr `$(`$DDMAddress.Ip)`r`nport `$(`$DDMAddress.Port)"
    if (`$(`$DDMAddress.Hostname)) {
        `$DDMConfiguration += "`r`nhost `$(`$DDMAddress.Hostname)"
    }
    Set-Content -Path "C:\ProgramData\Audinate\Dante Virtual Soundcard\ddm.conf" -Encoding oem -Value `$DDMConfiguration
    C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe stop start exit
}

# Grace period to ensure license capabilities are applied
while (-NOT ((C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe checklicense exit | Select-String 'License Status = 2' | ConvertFrom-StringData) -or (C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe checklicense exit | Select-String 'License Status = 1' | ConvertFrom-StringData)))
{
    Add-Content -Path "C:\ProgramData\Audinate\Dante Virtual Soundcard\dvs_config.log" -Value "Waiting for valid license status."
    Start-Sleep -s 5
}

# Wait for valid configuration state i.e. DVS is enrolled
while (-NOT ((C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe channelcounts exit | Select-String "Available Channel Counts = .*`$ChannelCount.*" | ConvertFrom-StringData) -and (C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe dantelatencies exit | Select-String "Available Dante Latencies = .*`$Latency.*" | ConvertFrom-StringData)))
{
    Add-Content -Path "C:\ProgramData\Audinate\Dante Virtual Soundcard\dvs_config.log" -Value "Waiting for valid dvs state to configure (Channels = `$ChannelCount, Latency = `$Latency)."
    Start-Sleep -s 5
}

# Configure DVS
Add-Content -Path "C:\ProgramData\Audinate\Dante Virtual Soundcard\dvs_config.log" -Value "Apply DVS config"
C:\ProgramData\Audinate\Bootstrap\dvs_cli.exe stop audio=`$AudioDriver channelcount=`$ChannelCount dantelatency=`$Latency start exit

"@
Set-Content -Path 'C:\ProgramData\Audinate\Dante Virtual Soundcard\dvs_config.ps1' -Value $DVSConfigScript
Write-Output "Create config script Done!"

Write-Output "Done"

if ($Env:EXIT_WITH_SUCCESS -eq "true") {
    Exit 0
}
