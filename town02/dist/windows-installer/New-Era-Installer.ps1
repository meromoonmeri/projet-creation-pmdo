# ============================================================================
#  New Era: Abyss to Ascension - PowerShell reassembly + launch alternative
#
#  Alternative to New-Era-Installer.bat for users who prefer PowerShell.
#  Does exactly the same thing:
#    1. Reassembles the split parts into New-Era-Setup.exe
#    2. Verifies its SHA-256
#    3. Launches the .exe (a real 7-Zip SFX GUI installer)
#
#  Usage:
#      powershell -ExecutionPolicy Bypass -File .\New-Era-Installer.ps1
#      powershell -ExecutionPolicy Bypass -File .\New-Era-Installer.ps1 -NoLaunch
#      powershell -ExecutionPolicy Bypass -File .\New-Era-Installer.ps1 -OutDir "D:\Custom\Path"
# ============================================================================

[CmdletBinding()]
param(
    [string]$OutDir = $PSScriptRoot,
    [switch]$NoLaunch
)

$ErrorActionPreference = "Stop"
$ExpectedSha = "d172e45f0b1dfe3899c6b4615e88fc20032fa9508e9f024e9b46f3909a94edfb"
$ExpectedSize = 382700080
$ExeName = "New-Era-Setup.exe"

Write-Host "New Era: Abyss to Ascension - Windows installer" -ForegroundColor Cyan
Write-Host ("=" * 60) -ForegroundColor Cyan

$parts = 1..5 | ForEach-Object {
    Join-Path $PSScriptRoot ("$ExeName.part_{0:D3}" -f $_)
}
foreach ($p in $parts) {
    if (-not (Test-Path $p)) {
        throw "Part manquante : $p. Verifiez que le dossier dist\windows-installer\ a ete telecharge en entier."
    }
}

$exeOut = Join-Path $OutDir $ExeName
if (Test-Path $exeOut) { Remove-Item -Force $exeOut }

Write-Host "Reassemblage des 5 parts vers : $exeOut"
$out = [System.IO.File]::Create($exeOut)
try {
    foreach ($p in $parts) {
        $in = [System.IO.File]::OpenRead($p)
        try { $in.CopyTo($out) } finally { $in.Dispose() }
        Write-Host ("  + {0} ({1:N0} bytes)" -f (Split-Path -Leaf $p), (Get-Item $p).Length)
    }
} finally { $out.Dispose() }

$actualSize = (Get-Item $exeOut).Length
if ($actualSize -ne $ExpectedSize) {
    Remove-Item -Force $exeOut
    throw "Reassembly size mismatch: got $actualSize, expected $ExpectedSize."
}

Write-Host "Verification SHA-256 ..."
$actualSha = (Get-FileHash -Algorithm SHA256 $exeOut).Hash.ToLower()
if ($actualSha -ne $ExpectedSha) {
    Remove-Item -Force $exeOut
    throw "SHA-256 mismatch: got $actualSha, expected $ExpectedSha."
}
Write-Host "OK ($actualSha)" -ForegroundColor Green

if ($NoLaunch) {
    Write-Host ""
    Write-Host "New-Era-Setup.exe pret dans : $exeOut" -ForegroundColor Green
    Write-Host "Lancez-le a la main pour installer."
    return
}

Write-Host ""
Write-Host "Lancement de New-Era-Setup.exe (installateur GUI 7-Zip SFX)..." -ForegroundColor Green
Start-Process -FilePath $exeOut
