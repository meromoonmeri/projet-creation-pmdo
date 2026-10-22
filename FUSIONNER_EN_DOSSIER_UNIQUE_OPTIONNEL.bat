@echo off
chcp 65001 >nul
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$root = Split-Path -Parent $MyInvocation.MyCommand.Path; " ^
  "$packs = @('town02','town02_tiles_pack_a','town02_tiles_pack_b','town02_tiles_pack_c'); " ^
  "$mainTile = Join-Path $root 'town02\Content\Tile'; " ^
  "$ms = New-Object System.IO.MemoryStream; " ^
  "$bw = New-Object System.IO.BinaryWriter($ms); $bw.Write([int]0); $total = 0; " ^
  "foreach ($p in $packs) { " ^
  "  $td = Join-Path $root "$p\Content\Tile"; if (!(Test-Path $td)) { continue }; " ^
  "  $b = [System.IO.File]::ReadAllBytes((Join-Path $td 'index.idx')); " ^
  "  $total += [System.BitConverter]::ToInt32($b, 0); " ^
  "  $ms.Write($b, 4, $b.Length - 4); " ^
  "  if ($p -ne 'town02') { Get-ChildItem $td -Filter *.tile | Move-Item -Destination $mainTile -Force; Remove-Item (Join-Path $root $p) -Recurse -Force } " ^
  "}; " ^
  "$ms.Position = 0; $bw.Write([int]$total); " ^
  "[System.IO.File]::WriteAllBytes((Join-Path $mainTile 'index.idx'), $ms.ToArray()); " ^
  "$mx = Join-Path $root 'town02\Mod.xml'; " ^
  "$c = [System.IO.File]::ReadAllText($mx) -replace '(?s)\s*<RelatedMod>\s*<UUID>A1CE000[123].*?</RelatedMod>',''; " ^
  "[System.IO.File]::WriteAllText($mx, $c); " ^
  "Write-Host ('FUSION REUSSIE : Dossier unique town02 pret (' + $total + ' tilesets) !') -ForegroundColor Green"
pause
