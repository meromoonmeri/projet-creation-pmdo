# Dungeon Builder

Outil de création de donjons **au-dessus de RogueElements**, piloté par des
définitions externes (`DungeonDefs/canonical/*.json`). Il ne remplace pas le
moteur : il compose des `GenSteps` RogueElements / RogueEssence / PMDC natifs,
que le jeu exécute avec son propre RNG à chaque entrée dans le donjon.

Lire d'abord : `docs/dungeon_builder/AUDIT_ROGUEELEMENTS.md` (capacités
réellement vérifiées dans le code source) et
`docs/dungeon_builder/PROTOTYPE_METRICS.md` (preuves chiffrées).

## Commandes

```bash
python3 tools/dungeon_builder.py audit                       # profils, tilesets, définitions, partages interdits
python3 tools/dungeon_builder.py verify sinister_woods --report   # parité profils/steps + conformité de l'export
python3 tools/dungeon_builder.py ground sinister_woods --role midpoint --sheet SinisterWoodsB41 --preview
python3 tools/dungeon_builder.py prototype --per-profile 16 --report  # vrai moteur PMDO, 48 floors isolés
python3 tools/dungeon_builder.py preview sinister_woods --floor 7 --count 10 --ascii  # aperçu hors-ligne non certifiant
python3 tools/dungeon_builder.py validate sinister_woods --count 10   # pré-contrôle non certifiant
python3 tools/dungeon_builder.py canonical-audit --report             # gate ROM/provenance/runtime
python3 tools/dungeon_builder.py extract-red-all --source /src/pmd-red --apply  # 51 manifests, aucune zone
python3 tools/dungeon_builder.py scope-111 --pret-source /src/pmd-red --pmdodump-source /src/PMDODump --apply
python3 tools/dungeon_builder.py batch-red-story-01 --apply            # staging Tiny Woods + Thunderwave Cave
python3 tools/dungeon_builder.py batch-red-story-02 --apply            # Silent Chasm + Great Canyon, fail-closed items
python3 tools/dungeon_builder.py generate sinister_woods              # écrit seulement si le gate canonique passe
python3 tools/dungeon_builder.py generate-all --chapters 6-32         # fail-closed : runtime + batch_approved requis
```

`--seed` est **debug uniquement**. `generate --seed` est refusé sans `--dry-run`,
et le prototype moteur refuse toute seed imposée. La production sélectionne ses
profils via `ChanceFloorGen` et construit sa géométrie avec la seed PMDO réelle ;
le service runtime journalise cette seed pour reproduire un incident.

## Architecture

| Module | Rôle |
|---|---|
| `definitions.py` | `DungeonDefinition` / `Segment` : chargement, validation, cascade donjon → segment → étage |
| `profiles.py` | `ArchitectureProfile` : `branching`, `looping`, `dense`, `large_rooms`, `mixed`, `ring`, `lattice`, `twosides`, `crossroads` (+ overrides par donjon) |
| `re_sim/` | Ancien aperçu hors-ligne, **non certifiant** et exclu des gates de production (RNG et certaines sémantiques ne sont pas identiques au C#). À terme, le preview doit passer lui aussi par le moteur. |
| `steps.py` | Adaptateur RogueElements : fabrique les `$type` JSON natifs (vocabulaire vérifié contre les zones existantes) |
| `templates/` | Gabarits natifs extraits du dépôt (boutique Kecleon, monster house) réutilisés tels quels |
| `dtef.py` | Résolution/vérification des auto-tilesets DTEF (`Data/AutoTile` + `Content/Tile`) |
| `grounds.py` | Scènes fixes : entrée / midpoint / Ground de fin, arbitrage boss `canonical_ground` vs `dedicated_arena` |
| `rng.py` | Politique de seeds (entropie OS, jamais de seed figée, traçabilité debug) |
| `validation.py` | Fairplay, traversabilité, signature structurelle, rejet + régénération des doublons |
| `zone_export.py` | Écriture de `Data/Zone/<id>.json` et de `index.idx` |
| `conformance.py` | Parité profil ↔ simulateur ↔ export, et conformité des `$type`/champs émis aux zones livrées |
| `ground_pipeline.py` | Grounds fixes : clone du template validé + retexture tuile à tuile sur la planche du donjon, index, preview PNG |
| `report.py` | Rapport automatique JSON + Markdown (`docs/dungeon_builder/reports/`) |
| `canonical_gate.py` | Gate fail-closed : provenance ROM/DTEF/Ground/scène, conflits canoniques, preuve runtime et autorisation batch |
| `red_source.py` | Extraction sans génération des paramètres/floors/tables PMD Red depuis `pret/pmd-red`, y compris les tables globales et emprunts inter-donjons |
| `red_batch.py` | Extraction massive fail-closed des 51 manifests et file de réconciliation ; n'écrit jamais de zone |
| `scope_registry.py` | Registre machine 111, recoupant ROM EU, pret et les 47 assets PMDODump |
| `red_story_batch.py` | Lot staging Tiny Woods / Thunderwave Cave, définition + ZoneData + enregistrement des preuves PMDO |
| `tools/runtime/run_engine_prototype.sh` | Prototype isolé exécuté par le vrai binaire PMDO/RogueElements, avec métriques du `FloorPlan` natif |
| `prototype.py` | Ancien prototype Python conservé temporairement pour les aperçus ; il n'autorise jamais une production |

> **État au 2026-08-23 :** le registre prioritaire contient 111 entrées exactes
> (64 Red EU + 47 PMDODump). Sinister Woods est promu et route-validé. Tiny
> Woods et Thunderwave Cave passent 80/80 mapgen et leurs deux routes Ground,
> mais restent non promus car leurs musiques PMD Red sont absentes des assets
> PMDO. L’audit exhaustif trouve 49 autres manifests bloqués par floors fixes
> et/ou items sans équivalent exact ; aucune substitution inter-famille n’est faite.

## Écrire une définition

Voir `DungeonDefs/canonical/sinister_woods.json`. Champs principaux :
`id`, `name`, `chapter`, `route`, `source`, `floors`, `biome`, `dtef`,
`variation.direction` (`fond`/`sommet`), `stairs`, `profiles`, `pokemon`,
`items`, `features` (`shop`, `monster_house`, `treasure_room`, `key_room`,
`weather`, `mystery`, `traps`), `segments[]` (avec héritage/surcharge des
tables), `minibosses`, `midpoint`, `boss`, `fixed_grounds`.

Règles appliquées automatiquement :

* les segments doivent couvrir **exactement** 1..`floors`, sans trou ni
  chevauchement ;
* un tileset DTEF non importé fait **échouer** la génération ;
* un étage fixe (`fixed_floors`) est exporté en `LoadGen` + `MappedRoomStep` ;
* si le donjon possède un Ground de fin exploitable, le boss s'y déroule
  (`boss.mode = "canonical_ground"`) ; sinon `arena_rsmap` exige un `.rsmap`
  existant avant conversion. Le Builder **scanne** `Data/Ground` (id + `aliases`)
  et refuse `arena_rsmap` dès qu'une scène finale canonique existe — voir
  `docs/dungeon_builder/GROUNDS_AND_BOSS_RULES.md` ;
* deux donjons ne peuvent pas partager le même triplet de tileset sans
  `dtef.justification`.


## Câblage narratif et exclusivité

```
python3 tools/dungeon_builder.py wire-scenes --report          # simulation
python3 tools/dungeon_builder.py wire-scenes --apply           # écrit scripts + recâblages
python3 tools/dungeon_builder.py verify-exclusivity --report   # 0 ancienne implémentation active
python3 tools/dungeon_builder.py verify-exclusivity --quarantine  # archive les scripts hérités
```

`wire-scenes` applique la règle verrouillée « Ground de cinématique = Ground du
combat = Ground final canonique » et n'invente jamais de décor : un donjon sans
Ground final termine son run normalement, un boss interne reste une salle fixe
`.rsmap` chargée en étage.

`verify-exclusivity` répond à une seule question : les 51 zones sont-elles les
seules implémentations actives du périmètre Ch.6-32 ? Sept contrôles :
définitions/zones/index, empreinte du Builder, scripts de zone générés,
substituts purgés, références de donjon, verrou des anciens générateurs
(`tools/perimeter_guard.py`), règle des scènes.

Aucun de ces contrôles ne remplace le moteur : la validation runtime reste
`tools/runtime/run_mapgen_check.sh`.


## Validation par le moteur, sans SDK .NET

```
tools/runtime/run_engine_mapgen.sh /chemin/de/travail 3
```

Reconstruit une pile PMDO headless (binaire officiel + ANGLE/SwiftShader issus
du paquet npm `@sparticuz/chromium` + SDL 2.30.3 corrigé pour le pilote
`offscreen`), installe le mod, puis fait générer chaque étage des 51 donjons par
le moteur lui-même (`ZoneSegmentBase.GetMap`). Résultat : `mapgen_report.md`.

`tools/runtime/run_mapgen_check.sh` reste le chemin officiel quand un SDK .NET
est disponible (il compile et exécute MapGenTest).
