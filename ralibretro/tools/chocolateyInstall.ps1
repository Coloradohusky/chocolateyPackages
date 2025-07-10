$packageName   = 'ralibretro'
$url           = 'https://retroachievements.org/bin/RALibretro.zip'
$url64         = 'https://retroachievements.org/bin/RALibretro-x64.zip'
$checksum      = '45E44B4F774030D5DF6DF1993043C102B720F18FA2E16B32832D128B6ED19BA1'
$checksum64    = 'ED56520E238A9A230E0120CA81B70A62FA66922AABB45CB0A0295CEDE10EED97'
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