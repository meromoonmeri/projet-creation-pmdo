# OUTIL — Générateur de maps à tileset cohérent (New Era)

**Localisation** : `tools/mapgen/` (`extract_tileset_db.py`, `gen_map.py`, `data/`).
**Statut** : v1 (2026-07-29). Complète `make_gemini_cloven.py` (image → ground),
les audits de Ground et les contrôleurs de scènes.

> ⚠ **`docs/conception_donjons_segmentes.md` est ABSENT du dépôt** (vérifié dans
> toutes les branches Arena et l'historique git, 2026-07-29). En attendant, les
> biomes sont **INFÉRÉS des usages réels** du dépôt et chaque donnée porte sa
> provenance (`tools/mapgen/data/*`, clé `_provenance`). **Le jour où la fiche
> arrive, elle prime** : poser le fichier dans `docs/` puis relancer
> `python3 tools/mapgen/extract_tileset_db.py` et aligner `GROUPES`/`ADJACENTS`
> de `gen_map.py` sur ses règles de progression.

## Principe directeur — preuve avant hypothèse

L'outil ne peut **jamais** choisir un tileset qui n'a pas déjà servi dans une
zone du dépôt (ou qui n'aurait pas été importé depuis une source légitime puis
re-extrait). Il ne réinvente pas RogueElements : il **clone les GenSteps
éprouvés** d'une zone donatrice et ne reparamètre que texture/élément/musique.

## Ce qui est un « tileset valide »

- **Donjon** : triplet `MapTextureStep` (`GroundTileset`/`BlockTileset`/
  `WaterTileset`) réellement présent dans `Data/Zone/*.json` — **80 triplets**
  extraits, avec zones utilisatrices, éléments vus, musiques vues, étages
  cumulés (`data/tilesets_donjons.json`).
- **Ground** : feuille `Content/Tile/<Nom>.tile` existante, **sans espaces**
  dans le nom (règle apprise du glitch : les feuilles à espaces ne chargent
  jamais en jeu).

## Commandes

```bash
python3 tools/mapgen/extract_tileset_db.py          # (re)construit la base
python3 tools/mapgen/gen_map.py tilesets <requête> [--element EL]
python3 tools/mapgen/gen_map.py gen-etages --zone ID --nom-fr "Nom" \
        --etages N --tileset FLOOR [--element EL] [--musique F.ogg] \
        [--donneur ZONE] [--ecrire]
python3 tools/mapgen/gen_map.py check --cible <Data/Zone/*.json|Data/Ground/*.rsground>
```

- `tilesets` : recherche par mots-clefs + filtre d'élément. **Aucun résultat =
  REFUS EXPLICITE** (exit 2) plutôt qu'un approximant — conformément au cahier
  des charges (« signaler plutôt que forcer »).
- `gen-etages` : génère une **zone à 1 RangeDictSegment** (N étages) en clonant
  le `GridFloorGen` du donneur (défaut `cloven_ruins`), en patchant le triplet
  de textures + `GroundElement` + musique. **Avertissement affiché et écrit
  dans le Comment de la zone** : les pools de spawns restent ceux du donneur —
  à remplacer selon la fiche de biome. Jamais d'écrasement d'une zone
  existante. L'enregistrement (`master_zone.json`, `index.idx`, `init.lua` de
  zone) reste un geste manuel documenté, suivi de la boucle de validation.
- `check` : la **validation avant sortie** du cahier des charges :
  - *zone* : tilesets valides + triplets complets, plages d'étages continues
    depuis 0 (ni trou ni chevauchement), **gradient de biome** entre segments
    voisins (groupes d'éléments, transitions listées dans `ADJACENTS` —
    heuristique dérivée, marquée comme telle), présence de spawns ;
  - *ground* : dimensions/@px, Bounds d'obstacles exactes, **bordure bloquée**
    (lisibilité caméra), feuilles sans espaces + existantes, **connexité de la
    zone marchable** (flood-fill — 100 % requis sinon WARN + FAIL sur objet
    inatteignable : un trigger mort = bug en jeu, prouvé sur
    `cloven_ruins_entrance` : 40 cellules isolées détectées puis corrigées).

## Intégration au pipeline

Après toute génération/édition, rejouer la boucle existante :
`audit_bugs .` (12), `audit_integrite .` (925), `verify_legend .`,
`verify_scene_positions`, `verify_bg_format`, `validate_all`,
`verify_ground_registration`, `verify_lua_globals`, `verify_cutscene_guard`,
`verify_spawner_enabled`, `count_dialogue 5` (1580) — puis bump du tag de build
(3 fichiers) et commit.

## Relais / points médians assortis à leur donjon (`gen_relais.py`)

Référence : `searing_tunnel_midpoint` (camp magma en `magma_cavern_2`, même
triplet que son donjon — le template). `lister` audite chaque relais contre le
triplet canonique de son donjon ; `assortir --ground NOM` remplace en place les
autotiles par le triplet du donjon (**topologie, entités, sorties et musique
jamais touchées** ; correspondance `_floor/_wall/_secondary`, NeighborCode
intacts). `vast_steppe_midpoint` et `crooked_cavern_midpoint` sont PROTÉGÉS
(déjà cohérents — directive utilisateur). Premier usage : `cloven_ruins_midpoint`
passé de `wish_cave_1` (grotte à vœux, hors-biome) à `western_cave_1` (320
cellules, checker 100 % valide). La famille `new_era_sky_XX_relais` est
détectée automatiquement : les 25 relais, tous clonés en magma, ont été
assortis au triplet de leur donjon (361 cellules chacun, 0 FAIL). Les
autotiles DA ne sont pas rendables hors-moteur : vérification visuelle en
jeu requise.

```bash
python3 tools/mapgen/gen_relais.py lister
python3 tools/mapgen/gen_relais.py assortir --ground NOM [--zone ZONE] [--ecrire]
```

## Limites assumées de la v1

- `gen-etages` produit des étages **structurés** (grid+branch, escalier,
  météo, spawns du donneur) : bosses, arènes (`LayeredSegment` → `.rsmap`),
  grounds d'entrée/relais et cinématiques restent des chantiers séparés
  (cf. template du `registre_donjons_new_era.md`).
- Les grounds « dessinés » passent par `make_gemini_cloven.py` (image → tuiles)
  ; `check` vérifie leur géométrie de marche exactement comme ici.
- Le gradient de biome est une heuristique en attendant la fiche de conception.
