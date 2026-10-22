# PMD Red EU → RogueEssence/PMDO — convertisseur

> **Statut** : squelette architectural. Chaque étage est fonctionnel à sec
> (dry-run sans ROM) et refuse d'aller plus loin qu'il ne peut prouver.
> Chaque `PASS` doit être justifiable ; sinon le pipeline émet
> `UNIMPLEMENTED`, `UNKNOWN` ou `REVIEW_REQUIRED` et poursuit la
> réflexion sans mentir.

## Périmètre

Le convertisseur transforme une **copie légale locale** de la ROM
Pokémon Mystery Dungeon: Red Rescue Team (version européenne
multilingue) en contenu jouable pour le moteur PMDO 0.8.12
(RogueEssence + RogueElements + PMDC), aligné sur la convention Halcyon
du mod New Era: Abyss to Ascension.

**La ROM n'est jamais commitée, jamais uploadée, jamais redistribuée.**
Elle reste dans `converter/rom_input/` (git-ignoré). Le convertisseur
l'authentifie par SHA-256 et refuse toute ROM différente.

## ROM de référence

- Titre       : Pokémon Mystery Dungeon: Red Rescue Team
- Édition     : Europe (En, Fr, De, Es, It)
- Support     : Game Boy Advance
- Taille      : 33 554 432 octets (32 MiB)
- SHA-256     : `0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd`

Ce hash est celui utilisé par les artefacts d'audit déjà présents dans
`dev/RESERVE/pmdred_direct/manifest.json`. Toute ROM différente est
refusée par le pipeline.

## Architecture en huit étages

```
    +------------------------------------------------------------+
    |  0. detect     Authentifier la ROM par hash                |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  1. extract    Extraire les régions ROM brutes             |
    |                (via pret/pmd-red offsets + tables)         |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  2. decode     Décoder les formats propriétaires GBA :     |
    |                BMA (map), BPC (tiles), BPA (anim),         |
    |                Kao (portraits), SSB (scripts), MPT (BGM)   |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  3. normalise  Représentation intermédiaire (IR) neutre :  |
    |                Ground_IR, Script_IR, Cinematic_IR,         |
    |                Asset_IR — sans dépendance moteur cible     |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  4. map        Cartographie IR → PMDO :                    |
    |                Ground_IR       -> .rsground               |
    |                Script_IR       -> Lua (halcyon namespace) |
    |                Cinematic_IR    -> Lua ground cutscene     |
    |                Asset_IR (tile) -> .tile atlas             |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  5. emit       Écrire dans Data/Ground, Data/Script,       |
    |                Content/Tile, Strings/*.resx                |
    |                Chaque fichier a un manifest de provenance  |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  6. validate   Vérifications statiques :                   |
    |                - hash de provenance par fichier            |
    |                - parse Lua                                 |
    |                - cross-refs (Ground, Zone, Tile, Music)    |
    |                - collision layer sanity                    |
    |                - dialogue keys existent dans Strings       |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  7. runtime    Smoke-test dans PMDO 0.8.12 (RogueEssence   |
    |                headless) : load zone, load ground, tick    |
    |                cutscene, verify camera/entities/dialogues  |
    +------------------------------------------------------------+
                              |
                              v
    +------------------------------------------------------------+
    |  8. report     Rapport de provenance + statut par entité   |
    |                CANONICAL | PORTED | PARTIAL |              |
    |                RECONSTRUCTED | UNKNOWN | BLOCKED           |
    +------------------------------------------------------------+
```

## Représentation intermédiaire (IR)

Le point-clé de l'architecture : chaque étage 2 (decode) parle un
**format IR** neutre, indépendant du moteur cible. Cela permet :

- de valider la fidélité ROM sans mélanger les questions PMDO
- de rejouer l'étage 4 (mapping) si un mécanisme PMDO évolue
- de journaliser sur chaque champ IR l'octet source (`rom_offset`,
  `rom_length`, `rom_sha256_partial`) pour la traçabilité

### `Ground_IR`

```
Ground_IR {
  id:                str                  # ex: "d01p02"
  rom_map_file_id:   int                  # index dans la table MAP_FILE_ID_*
  width:             int (tiles)          # 45
  height:            int (tiles)          # 42
  pixel_width:       int                  # 360
  pixel_height:      int                  # 336
  tileset_id:        int                  # 14 pour d01p02
  bma:               BMA_IR
    { layers[i]: TileLayer_IR (chunk indices),
      collision_layers[i]: bytes,
      unknown_data: bytes | null }
  bpc:               BPC_IR (tileset chunks + palettes)
  bpa[]:             list[BPA_IR] (animated tiles, per frame)
  entities[]:        list[Entity_IR] (spawn pos, direction, script_ref)
  triggers[]:        list[Trigger_IR] (warps, script hooks)
  provenance:        Provenance
}
```

### `Script_IR` / `Cinematic_IR`

Extrait du bytecode SSB compilé + désassemblé via les macros
`pret/pmd-red` (`data/scripts/*.inc` + `src/data/ground/*_station.h`).

```
Cinematic_IR {
  scene_id:          str                  # "d01p02_arrival"
  ground_id:         str                  # "d01p02"
  trigger:           Trigger_IR           # first_visit | flag(F,==,1) | ...
  preconditions:     list[Condition_IR]
  timeline[]:        list[Event_IR]
    Event_IR is one of:
      PlayBGM(track_id, loop)
      StopBGM(fade_ms)
      SFX(sfx_id)
      CameraGoto(x, y, tiles_per_sec)
      CameraFollow(entity_ref)
      EntitySpawn(entity_ref, pos, dir)
      EntityMove(entity_ref, [waypoints], speed)
      EntityFace(entity_ref, dir)
      EntityAction(entity_ref, action_id)
      DialogueShow(string_key, portrait_id, portrait_emote)
      DialogueClose()
      FadeToColor(rgba, ms)
      Wait(ms)
      SetFlag(id, value)
      WaitFlag(id, value)
      WarpToGround(ground_id, spawn_id)
      # UnknownSSBOpcode preserved verbatim as raw bytes to avoid
      # silent loss.
      UnknownOpcode(byte, args, rom_offset)
  post_effects:      list[Effect_IR]
  provenance:        Provenance
}
```

## Provenance obligatoire

```
Provenance {
  rom_sha256:        str                  # attendu = ROM_EXPECTED_HASH
  rom_offset:        int                  # début lecture
  rom_length:        int                  # longueur brute
  extractor_version: str                  # ex: "converter/0.1.0"
  extracted_at_utc:  str                  # ISO-8601
  auxiliary:         list[AuxRef]         # (path in pret/pmd-red, sha256)
  status:            Enum
    CANONICAL      # 100% traçable ROM
    PORTED         # traçable + adapté PMDO sans perte
    PARTIAL        # adapté avec perte documentée
    RECONSTRUCTED  # inféré à partir de sources auxiliaires
    UNKNOWN        # non extractible dans l'état actuel du convertisseur
    BLOCKED        # requiert mécanisme PMDO non disponible
  status_reason:     str                  # obligatoire si status != PORTED/CANONICAL
}
```

**Aucun fichier émis par le convertisseur n'existe sans un manifest de
provenance.** Un fichier généré sans provenance est une régression et
le validateur (étage 6) la refuse.

## Layout disque

```
converter/
  __init__.py
  version.py               # __version__ = "0.1.0"
  rom_input/               # gitignoré, l'utilisateur y dépose la ROM
    README.txt
  rom_output/              # gitignoré, sortie brute par étage
    01_extract/
    02_decode/
    03_normalise/
    04_map/
    05_emit/               # staging avant écriture dans Data/…
    logs/
  rom_cache/               # gitignoré, cache incrémental
  pipeline.py              # entrée CLI
  stages/
    __init__.py
    s00_detect.py
    s01_extract.py
    s02_decode.py
    s03_normalise.py
    s04_map.py
    s05_emit.py
    s06_validate.py
    s07_runtime.py
    s08_report.py
  ir/                      # dataclasses IR
    __init__.py
    ground.py
    script.py
    cinematic.py
    asset.py
    provenance.py
  decoders/                # décodeurs de formats GBA
    __init__.py
    bma.py                 # Background Map Assembly
    bpc.py                 # Background Palette Chunk
    bpa.py                 # animated tiles
    kao.py                 # portraits
    ssb.py                 # scripts (compile depuis pret macros)
    text_bank.py           # tables de strings
  mappers/                 # IR → PMDO
    __init__.py
    ground_to_rsground.py
    cinematic_to_lua.py
    tile_to_atlas.py
    strings_to_resx.py
  validators/
    __init__.py
    provenance.py
    lua_parse.py
    xrefs.py
  runtime/
    __init__.py
    pmdo_headless.py       # subprocess RogueEssence en mode --dev
  registry/                # tables de correspondance ROM ↔ PMDO
    dungeon_map.json       # d01p02 -> gloomy_forest, sinister_woods…
    music_map.json         # MUS_IN_THE_DEPTHS_OF_THE_PIT -> asset ogg
    portrait_map.json      # kao_bulbasaur -> Chara/0001.chara
    string_map.json        # SCENE_D01P02_001 -> stringsEx.resx key
  tests/
    __init__.py
    test_s00_detect.py
    test_ir_provenance.py
    …
docs/converter/
  architecture.md          # ce document
  format_bma.md            # notes de format
  format_ssb.md
  provenance.md
  status_glossary.md
```

## Règles de rigueur

1. **Aucune écriture sous `Data/`, `Content/`, `Strings/`** sans passer
   par l'étage 5 (`emit`). L'étage 5 refuse d'écraser un fichier
   canonique dont la provenance montre un statut supérieur au fichier
   qu'on veut écrire (ex: on ne remplace pas un `PORTED` validé par un
   `RECONSTRUCTED`).
2. **Aucun `UnknownOpcode`, `UNIMPLEMENTED`, `UNKNOWN` n'est
   silencieux.** Le rapport final (étage 8) les liste avec offset ROM
   + contexte + estimation d'effort.
3. **`runtime PASS` n'existe pas sans exécution effective** dans PMDO
   (étage 7). Un `runtime PASS` inclut le log RogueEssence, la liste
   des entités chargées, les dialogues émis, la caméra finale.
4. **Le pipeline est idempotent** : rejouer une extraction sur la même
   ROM (même hash) doit produire des fichiers bit-à-bit identiques.
   Chaque écart casse le build.
5. **La ROM n'est jamais accédée hors de l'étage 0-1.** Les étages
   supérieurs ne relisent que les artefacts extraits, pour que
   l'utilisateur puisse retirer la ROM du disque après extraction.

## Ce que le convertisseur NE fait PAS

- Il ne redistribue rien de la ROM.
- Il ne « améliore » pas les graphismes, palettes, ou dialogues.
- Il ne remplace pas un contenu New Era déjà validé par une
  reconstruction ROM plus faible.
- Il ne bypass pas les scripts canoniques par des hacks Lua.
- Il ne déclare pas `PASS` sur base d'un fichier écrit ; le PASS exige
  la chaîne complète : `emit` + `validate` + `runtime`.

## État d'implémentation (au commit courant)

- Étage 0 (detect)       : implémenté (`s00_detect.py`)
- Étage 1 (extract)      : squelette + registry ROM offsets à peupler
- Étage 2 (decode)       : décodeurs BMA/SSB en cours (voir `docs/converter/`)
- Étages 3-8             : squelette vide avec entrée/sortie typée
- Runtime PMDO           : pas encore branché (dépend d'une build headless)

Toute déclaration `PASS` avant que les huit étages soient implémentés
concerne exclusivement l'étage lui-même. Un `PASS s00` ne dit rien de
la fidélité globale.
