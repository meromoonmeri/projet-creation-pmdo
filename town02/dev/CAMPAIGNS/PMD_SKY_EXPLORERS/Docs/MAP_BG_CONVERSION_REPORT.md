# MAP_BG Conversion Report — PMD Explorateurs du Ciel (NDS) → PMDO

**Dépôt** : `meromoonmeri/PMD-SKY-PMDO-PORT` (branche `master`)
**Date** : 2026-08-06
**Source** : `pret/pmd-sky` → `files/MAP_BG/` (`.bpl`/`.bpc`/`.bma`/`.bpa` NDS)

---

## 1. Résultat final (vérifié via API GitHub `git/trees/master`)

| Métrique | Valeur |
|---|---|
| **Total MAP_BG** | **458** |
| **Grounds exportés** (`output/Grounds/*.rsground`) | **465** |
| **Tiles exportés** (`output/Tiles/*.tile`) | **569** |
| Maps MAP_BG restantes | **0** |
| Erreurs (FAILED) | **0** |
| Références invalides (bug tuiles noires) | **0** |

> 465 grounds = 458 MAP_BG + 7 assets nommés (waterfall_cave_entrance/boss,
> aegis_cave_entrance/boss/ice/rock, b01p01_beach hérité).

## 2. Conformité au cahier des charges

1. **Rendu** : 100 % via `bma.to_pil(bpc, bpl, bpas)` (skytemple-files).
   Aucune reconstruction manuelle, aucune transformation spatiale.
2. **.tile** : planche RogueEssence, déduplication par pixels RGBA, toutes les
   frames d'animation incluses (eau, lave, cascades, drapeaux).
3. **.rsground** : Layers/Tiles/Frames/obstacles/Entities/Markers, `AssetName`,
   `Comment` source (BMA/BPC/BPL/BPA, nb frames, collision). `FrameLength` :
   10 animé / 60 statique.
4. **Collision** : SOURCE UNIQUE `bma_obj.collision`.
   - Cas A (présente) : données BMA exactes.
   - Cas B (absente) : `Tags = 0` partout, AUCUNE dérivation par pixels.
     `collision_source=NONE`, commentaire « No BMA collision layer available.
     No artificial collision generated. »
5. **BPA** : 8 slots (0-3 layer 0, 4-7 layer 1), mapping via
   `bpc.layers[L].bpas[i]` <-> `bpa.number_of_tiles`. Ex. d17p31a →
   slots[0]=d17p31a1 (64), slots[4]=d17p31a5 (126). Résout les références
   hors limites (bug tuiles noires).
6. **Dimensions** : audit IMAGE/CAMERA/COLLISION/DECISION systématique, aucune
   correction silencieuse (écarts consignés).
7. **Markers** : `Main_Entrance_Marker` fallback sur cellule marchable proche
   du centre, jamais sur collision.
8. **Robustesse** : try/except + timeout (600s) par carte, logs séparés
   (`output/export_log.txt`), reprise automatique (skip déjà exportées,
   `--force`), une erreur n'arrête pas le batch.

## 3. Statistiques d'animation

- Maps avec BPA : **41**
- Maps animées (>1 frame) : **43** (dont d17p31a : 4 frames, t00p01 : 6,
  t01p02a : 4, d04p31a : 135, d53p41b : 384)
- Maps sans collision BMA (Tags=0 documenté) : **~150** (fonds/arènes de
  donjon procédurales — aucune collision artificielle générée)

## 4. Cartes remarquables

| Map | Particularité |
|---|---|
| d53p41b | 384 frames d'animation, 39 003 tuiles uniques (planche 6,9 Mo) — traitée en 17 s |
| t00p01 | Place Pokémon (ville), 6 frames, 120×90 |
| t01p02a | Étang Barbicha, 4 frames, 69×63 |
| d17p31a | Test BPA 2 slots (1+5), 4 frames |
| d04p31a | 135 frames (animation riche) |

## 5. Historique de réparation (important)

Une régression a été détectée et corrigée : les lots exportés depuis un clone
`--no-checkout` faisaient perdre les anciens fichiers de l'arbre (le
`git add -A` sur working tree vide retirait les fichiers de l'index). Commit
`41e938b` **restaure l'arbre complet** (union du commit `92a837e` = 255 grounds
et du HEAD = 210) → 465 grounds / 569 tiles, vérifié via l'API GitHub.
Tous les fichiers restent dans l'historique git (aucune perte).

## 6. Compatibilité New Era

Les `.rsground` générés sont directement exploitables dans `Data/Ground/` :
structure RogueEssence valide (AssetName = nom fichier), collisions BMA
fidèles, animations NDS converties en frames PMDO, `Main_Entrance_Marker`
fallback pour les scripts New Era (les entrées canoniques seront ajustées
par les scripts).
