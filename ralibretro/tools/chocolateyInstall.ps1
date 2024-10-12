$packageName   = 'ralibretro'
$url           = 'https://retroachievements.org/bin/RALibretro.zip'
$url64         = 'https://retroachievements.org/bin/RALibretro-x64.zip'
$checksum      = '2DC91C4B569C057082BF80F26CC00A6D14D1FD4B52EA1E45DA1DAE04DF0D2022'
$checksum64    = '79993C479E830961BE1EABA852D3E24B708E599B77D098FA67A60697065F1A7A'
$checksumType  = 'sha256'
$checksumType64= 'sha256'


# Get the package parameters and then back them up for the uninstaller
# This works around choco#1479 https://github.com/chocolatey/choco/issues/1479
$pp = Get-PackageParameters
$toolsPath = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$paramsFile = Join-Path (Split-Path -Parent $toolsPath) 'PackageParameters.xml'
Write-Debug "Writing package parameters to $paramsFile"
Export-Clixml -Path $paramsFile -InputObject $pp

if ((Get-ProcessorBits 32) -or $env:ChocolateyForceX86 -eq 'true') {
  $specificFolder = "RALibretro"
} else {
  $specificFolder = "RALibretro-x64"
}

$installDir = $(Get-ToolsLocation)
if ($pp.InstallDir -or $pp.InstallationPath ) { $installDir = $pp.InstallDir + $pp.InstallationPath }
Write-Host "RALibretro is going to be installed in '$installDir\$specificFolder'"

Install-ChocolateyZipPackage "$packageName" `
  -Url "$url" -Checksum "$checksum" -ChecksumType $checksumType `
  -Url64 "$url64" -Checksum64 "$checksum64" -ChecksumType64 $checksumType64 `
  -UnzipLocation "$installDir\$specificFolder"

if ($installDir -eq $toolsPath) {
  New-Item "$installDir\$specificFolder\RALibretro.exe.gui" -Type file -Force | Out-Null
} else {
  Install-BinFile ralibretro -path "$installDir\$specificFolder\RALibretro.exe" -UseStart
}

if ($pp.DesktopShortcut) {
  $desktop = [System.Environment]::GetFolderPath("Desktop")
  Install-ChocolateyShortcut -ShortcutFilePath "$desktop\RALibretro.lnk" `
    -TargetPath "$installDir\$specificFolder\RALibretro.exe" -WorkingDirectory "$installDir" `
    -WindowStyle 3
  Write-Host "Added desktop shortcut at '$desktop\RALibretro.lnk'"
}