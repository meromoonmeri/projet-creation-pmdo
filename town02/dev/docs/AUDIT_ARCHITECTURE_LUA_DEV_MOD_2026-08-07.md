# AUDIT ARCHITECTURE LUA + DEV MOD — 2026-08-07

## Résultat global : 0 erreur de compilation, 0 require manquant, 0 musique cassée

## 1. Architecture Lua

| Contrôle | Résultat |
|---|---|
| Fichiers .lua compilés (lupa) | **0 erreur** (510+ fichiers) |
| `require 'halcyon.*'` résolus (fichier .lua OU dossier/init.lua) | **1367/1367** |
| Dépendances circulaires entre modules halcyon | **0** |
| Dossiers `ground/*` sans `init.lua` | **0** |
| Zones .json sans `zone/<zone>/init.lua` | **0** (43/43) |
| Dossiers `ground/*` sans ground correspondant | **0** |
| Objets testmap sans handler `_Action` | **0** (31/31) |
| SceneDebug : 36 grounds existants, 36 entrées valides | **OK** |
| `origin.*` / `lib.*` non résolus | **0** (fournis par le moteur PMDO) |

## 2. Musique — correctif majeur (arc fugitif + cinématiques)

**Problème trouvé** : 58 appels `SOUND:PlayBGM('Nom GBA')` SANS extension
`.ogg` dans les 133 scènes de l'arc fugitif + 21 musiques GBA dans
`FugitiveArc.SEQUENCE` — aucune de ces pistes n'existe dans Content/Music.

**Correctif** : mapping canonique GBA→PMDO (`tools/music_map_gba_pmdo.json`,
58 entrées) appliqué aux 125 fichiers de scènes + FugitiveArc. Apostrophes
(`Dialga's`, `Wigglytuff's`, `Spinda's`) réécrites en guillemets doubles
(6 fichiers).

**Vérification finale** : **551 appels PlayBGM → 0 fichier manquant**
(regex avec gestion correcte des guillemets) ; FadeOutBGM → 0 manquant.

## 3. Pipeline PMD Red — correctif format critique (tuiles 8x8)

Le premier jet des planches .tile écrivait des cellules 24x24 au lieu de
tuiles 8x8 par position de grille (le moteur aurait mal dessiné). Corrigé
dans `tools/convert_red_all.py` et `tools/regenerate_red_grounds.py` :
découpage 8x8 + fond noir opaque (patron du port officiel). Re-prouvé :
reconstruction = port à **0 pixel (RGBA)** sur 7 maps de référence, et
Tornadus ground vs rsmap = **0/120960**.

## 4. Rappels de sécurité (règles projet)

- Aucun script/ground/zone des chapitres 1-6 modifié (seulement les scènes
  d'arc fugitif ch11 — hors whitelist).
- Les 50 placeholders (grounds fantômes) restent intacts : index stables.
