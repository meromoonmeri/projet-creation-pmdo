# Matrice de couverture finale — 27 grounds canoniques directs PMD Red EU (dXXpYY)

ROM : Pokémon Mystery Dungeon - Red Rescue Team (Europe) (En,Fr,De,Es,It).gba
SHA-256 : 0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd — 33 554 432 octets
Source projet : meromoonmeri/BIBLIOTHEQUE@bibliotheque `PMD-RED/pmdred-eu.gba` (pointeur Git LFS, même OID SHA-256).
Runtime : PMDO 0.8.12 headless réel (pmdc-linux-x64 c64f72af…, SDL offscreen patché du projet, DumpAsset épinglé 9d864d14).

| Ground | ROM | Decode | Normalize | Map | Emit | Validate | Runtime PMDO | Promote | New Era | Installer |
|---|---|---|---|---|---|---|---|---|---|---|
| d01p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d02p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d03p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d04p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d05p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d06p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d06p03 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d09p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d09p03 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d10p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d10p03 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d11p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d11p03 | PASS | PASS | PASS | PASS | PASS | PASS | PASS (campagne exhaustive historique + routes runtime des 12 donjons) | PASS | PASS | PASS |
| d12p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d12p04 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d13p02 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d13p03 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d14p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d15p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d16p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d17p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d18p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d19p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d20p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d21p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d23p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |
| d25p01 | PASS | PASS | PASS | PASS | PASS | PASS | PASS 2026-08-24 (LOAD+MOVEMENT+ANIMATION, SAFE, NORMAL_EXIT rc=0) | PASS | PASS | PASS |

Preuves runtime des 15 nouveaux : events_d04p02.jsonl, events_batch14.jsonl,
termination_d04p02.json, termination_batch14.json (dans ce dossier).
Preuves des 12 protégés : dev/docs/pmdred_eu/pmdo_validation/<gid>/ + commits fd70439f, a8fddeb0, fb14cdc6.

Vérification installateur (New-Era-Setup.exe d172e45f…) : les 27 .rsground et
leurs planches (12 historiques + 15 nouveaux + d04p02_DirectBase.tile) sont
physiquement présents dans l'archive 7z embarquée; 12 zones protégées intactes;
chemin max 101 caractères (Windows-safe); Mod.xml directement sous New-Era/.
