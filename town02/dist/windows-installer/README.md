# New Era: Abyss to Ascension — installateur Windows (vrai `.exe`)

## Installation en 15 secondes

1. Téléchargez **le dossier `dist/windows-installer/` en entier** depuis
   GitHub (contient ce README + `New-Era-Installer.bat` +
   `New-Era-Installer.ps1` + `MANIFEST.json` + les 5 parts).
2. Double-cliquez sur **`New-Era-Installer.bat`**.
3. Le script reassemble les parts en **`New-Era-Setup.exe`** (365 MiB),
   vérifie son SHA-256 via `certutil`, puis le lance.
4. L'installateur `.exe` (vrai binaire Windows PE natif) ouvre sa
   fenêtre GUI, propose le dossier `PMDO/MODS`, extrait le contenu.
5. Lancez PMDO → **Special Episodes → New Era: Abyss to Ascension**.

## Ce qu'est vraiment `New-Era-Setup.exe`

- **Vrai fichier `.exe` Windows PE** — pas un `.bat`, pas un `.zip`
  renommé, pas un raccourci PowerShell. Signature `MZ...PE\0\0`,
  machine i386, subsystem GUI (fenêtre native).
- **SHA-256** : `d172e45f0b1dfe3899c6b4615e88fc20032fa9508e9f024e9b46f3909a94edfb`
- **Taille** : 382 700 080 octets (364.97 MiB)
- **Type** : installateur self-extracting **7-Zip SFX (SetupSFX)**,
  utilisé par des milliers d'installeurs Windows dans la nature
  (dont plusieurs versions officielles de 7-Zip lui-même).
- **Contient** : le mod complet New Era 0.5.1 (4231 entrées, incluant
  WoN et NNV), compressé en 7z LZMA2. Longest internal path 101 chars,
  Windows-safe.

Le module SFX est le fichier `7zSD.sfx` officiel de 7-Zip, redistribué
sous **LGPL** — chaque `.exe` type fangame construit sur SFX (dizaines
de projets communautaires) fait exactement la même chose.

## Pourquoi 5 parts et pas un `.exe` direct ?

GitHub avertit au-dessus de 50 MiB par fichier. Un `.exe` de 365 MiB
serait rejeté avec un warning bloquant. Les 5 parts de 85 MiB max
respectent la contrainte, sont commitables sans avertissement bloquant,
et la reassembly + hash-check est **100% automatique** côté utilisateur
via `New-Era-Installer.bat`.

## Contenu du dossier

| Fichier | Rôle | Taille |
|---|---:|---:|
| `New-Era-Installer.bat` | Point d'entrée double-clic | ~3 KB |
| `New-Era-Installer.ps1` | Alternative PowerShell (même comportement) | ~2 KB |
| `New-Era-Setup.exe.part_001..005` | 5 parts du vrai `.exe` (365 MiB) | 375 MB |
| `MANIFEST.json` | SHA-256 total + par-part, tailles, provenance | 2 KB |
| `README.md` | Ce document | 3 KB |

## Vérifications automatiques

- **Présence de chaque part** vérifiée avant reassembly.
- **SHA-256 du `.exe` reassemblé** comparé à la valeur attendue
  ci-dessus via `certutil -hashfile SHA256` (built-in Windows).
- **Abandon immédiat** en cas de mismatch, avec suppression du `.exe`
  potentiellement corrompu et message clair à l'utilisateur.

## Alternative : PowerShell

```
powershell -ExecutionPolicy Bypass -File .\New-Era-Installer.ps1
```

Options :
- `-NoLaunch` : reassemble et vérifie sans lancer le `.exe`
  (utile pour distribuer le `.exe` seul à quelqu'un d'autre).
- `-OutDir "chemin"` : écrit le `.exe` reassemblé ailleurs que dans
  ce dossier.

## Désinstallation

7-Zip SFX est un extracteur, pas un tracker d'installation. La
désinstallation se fait en supprimant simplement le dossier
`New-Era` dans `PMDO/MODS/` créé lors de l'installation.

## Compatibilité

- **Windows 7, 8.1, 10, 11** (x86 ou x64)
- Aucun runtime tiers requis (le `.exe` embarque tout)
- Le `.bat` d'installation utilise `copy /b` et `certutil`, tous deux
  natifs Windows depuis 7

## Vérification manuelle (pour les prudents)

```
certutil -hashfile New-Era-Setup.exe SHA256
```
Résultat attendu : `d172e45f0b1dfe3899c6b4615e88fc20032fa9508e9f024e9b46f3909a94edfb`
