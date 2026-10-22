# Installateurs Windows — dossier de référence

L'installateur Windows **opérationnel** est le **vrai `.exe`** disponible
dans [`dist/windows-installer/`](../dist/windows-installer/).

## Ce qui est effectivement livré

`dist/windows-installer/` contient :
- **`New-Era-Setup.exe`** (365 MiB) — vrai binaire Windows PE natif,
  installateur self-extracting 7-Zip SFX (SetupSFX), subsystem GUI,
  machine i386. SHA-256 :
  `51eb223967730d6d48935f8028c6f3f56bdcd337d2936a6881233aa8b7fd2808`.
  Distribué en 5 parts de 85 MiB max (limite pratique GitHub).
- **`New-Era-Installer.bat`** — reassemble les parts, vérifie le
  SHA-256 via `certutil` natif Windows, lance le `.exe`.
- **`New-Era-Installer.ps1`** — équivalent PowerShell pour les
  utilisateurs qui préfèrent.
- **`MANIFEST.json`** — provenance complète (module SFX 7-Zip LGPL,
  configuration Setup, archive du mod compressée LZMA2).

## Provenance du binaire

Le `.exe` a été construit **dans le sandbox de l'agent** en concaténant :

1. **Module SFX 7-Zip** `7zSD.sfx` — binaire officiel LGPL (Copyright
   1999-2018 Igor Pavlov), redistribuable librement, extrait du package
   npm `7zip-standalone` au moment du build.
2. **Fichier de configuration** `config.txt` (généré) — directives
   SetupSFX standard : `Title`, `BeginPrompt`, `InstallPath`,
   `ExtractDialogText`, `FinishMessage`.
3. **Archive `.7z`** du mod complet (~382 MB compressé LZMA2 preset 6)
   produite par le packager `dev/tools/package_windows.py` puis
   `py7zr` sur l'arborescence Halcyon-conforme (Mod.xml + Data/ +
   Content/ + Strings/ + CONVERSION/, WoN + NNV inclus).

## Alternative Inno Setup (`New-Era.iss`)

Le fichier `New-Era.iss` reste dans ce dossier comme référence Inno
Setup, utilisable par toute personne qui a accès à un runner Windows
avec `ISCC.exe`. Il n'est pas nécessaire pour l'installateur en
production : le `.exe` SFX 7-Zip fait déjà tout ce qu'il faut
(détection de dossier, extraction avec progress bar, dialogues
utilisateur) et il est construit sans dépendre d'un runner Windows,
sans permission GitHub Actions, sans upload endpoint externe.
