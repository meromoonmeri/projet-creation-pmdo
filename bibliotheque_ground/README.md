# Bibliothèque Ground / `.rsground` — quest PMDO Destiny 0.8.12

Bibliothèque de **maps Ground au format `.rsground`**, en version **clampée**
(aucune donnée hors zone), prêtes à importer dans la quest
**Pokémon Mystery Dungeon: Destiny** (PMDO 0.8.12, Namespace `halcyon`).

- Construite par : `python3 OUTILS/construire_bibliotheque_ground.py`
  (idempotent ; options : `--sceller-bords`, `--dry-run`).
- Rapport d'audit : `rapport_clamp.md` / `rapport_clamp.json` (chaque map :
  corrections appliquées, frontières, tilesets référencés/trouvés/manquants,
  chevauchements d'entités, sha256 d'origine et clampé).
- Provenance et licences : `CREDITS.md` (Étape 0 du filtre de provenance).
- Contexte de la quest : `PROJECT_CONTEXT.md`.

## Contenu (147 maps clampées, 17 lots)

| Lot | Origine | Maps |
|---|---|---|
| `cote_metano_dix_zones_lot2_pmdo` … `cotes_v2_0812_pmdo` (5 lots) | ZIP livrés de `meromoonmeri/projet-pmdo` | 86 |
| `mod_metano_expeditions_pmdo_0812` | ZIP livré | 40 |
| `destiny_cliff_tests` | branches de ce dépôt (cliff day/nord-ouest) | 2 |
| `entree_*` / `fin_*` (5 lots d'exports) | branches de ce dépôt | 5 |
| `reseau_metano_normal_v1` | branches de ce dépôt | 5 |
| `references_dumpasset` / `references_halcyon` / `references_metano` | références autorisées (voir CREDITS) | 7 |

Chaque lot est structuré pour l'import :
`Data/Ground/*.rsground` (clampés) · `Data/Script/ground/<map>/init.lua` ·
`Content/Tile/` + `Content/BG/` (+ `index.idx` quand présent) ·
`meta_src/` (Mod.xml, manifestes d'origine) · `lot.json`
(inventaire + déclaration `GroundMaps` prête à recopier).

## Le « clamp » — définition exacte

Toute donnée en **espace carte** est ramenée dans les limites de la map par
intersection (pixels = tuiles 8 px × `TexSize`) :

- `obstacles[*].Bounds` (y compris les packs dont `obstacles` est en listes de listes) ;
- `Collider` / `Hitbox` des `MapChars`, `GroundObjects`, `Spawners`, `Markers` ;
- `Loc` / `StartLoc` / `EndLoc` et `Decorations.Anims[*].Loc`.

**Jamais modifié** : `TexLoc` (espace texture), `MapLoc`/`BGMovement` (fonds),
`MetLoc`/`DefeatLoc` (identifiants), données de personnages (`NPCChar`), noms,
musique, chemins de scripts. Chaque correction est tracée dans le rapport
(valeur avant/après). Post-contrôle : **0 anomalie hors zone restante**.

Deux points d'honnêteté à connaître :

1. **Frontières ouvertes** : le clamp garantit les *données*, pas la *marchabilité
   des bords* (71 888 cellules de bord sans collision au total). Pour empêcher
   le joueur de sortir de la map en jeu (« hors zone » runtime), construisez avec
   `--sceller-bords` : une collision est ajoutée sur chaque cellule de bord
   marchable. Vérifiez au cas par cas les sorties prévues par marqueurs avant
   de sceller.
2. **Assets non résolus** : 195 noms de feuilles (`Sheet`/`AnimIndex`) sans
   fichier correspondant sont listés dans `rapport_clamp.json`
   (`tilesets_manquants` par map) — surtout `reseau_metano_normal_v1` (imports
   bruts aux noms non normalisés) et `destiny_cliff_tests`. À fournir dans
   `Content/Tile/` avant import, ou à renommer. Les 13 stubs de
   `packages_destiny` sont des **liens symboliques** vers `.cache/tiles/…`
   (cibles non versionnées) : non matérialisés, signalés dans le rapport.

## Procédure d'import dans la quest (Étape 2)

1. Copier `Data/Ground/<map>.rsground` dans `Data/Ground/` de la quest **et**
   chaque tileset référencé dans `Content/Tile/` (les fichiers sont déjà
   rassemblés par lot ; l'import nomme par **basename** → vérifier l'unicité
   des noms entre lots et préfixer en cas d'homonyme).
2. Déclarer la map dans `GroundMaps` du JSON de sa zone — **en fin de tableau**,
   sans décaler les index existants (un fichier non déclaré = crash
   « Cannot find ground map »). Les déclarations prêtes sont dans
   `lot.json > declaration_groundmaps`.
3. Mettre à jour `index.idx` si requis ; valider les JSON modifiés.
4. Créer/vérifier `Data/Script/ground/<map>/init.lua` avec `require` explicite
   de chaque `_ch_N.lua` utilisé ; déclarer toute `SV.*` dans `scriptvars.lua`.
5. Adapter à l'univers Destiny : noms français, chaînes via `Strings/TextData`,
   entités/marqueurs replacés, collisions et points d'entrée vérifiés.
6. Audit final : références cassées, assets orphelins, noms en double.

## Validation avant commit (checklist du PROMPT)

- [x] Licences lues, origines vérifiées, exclusions respectées (`CREDITS.md`)
- [x] Chaque map clampée, JSON valide, sha256 tracé, rapport d'audit à jour
- [x] Requires/entités inventoriés dans le rapport
- [ ] Déclarations `GroundMaps` appliquées dans la quest (au moment de l'import)
- [ ] **Tests en jeu** (impossible depuis le sandbox → à faire par l'utilisateur)
- [ ] `PROJECT_CONTEXT.md` mis à jour après chaque session d'import

Règles projet : aucun pixel généré présenté comme tuile native canonique ; les
anciennes versions sont conservées (les `.rsground` d'origine restent dans les
ZIP et les branches) ; aucun token d'accès dans un fichier.
