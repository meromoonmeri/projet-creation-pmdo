# Rapport de debug — Écran noir au chargement des ground maps importées

Date : 2026-07-27 · Commit du fix : voir `git log` (tools/fix_ground_serialization.py)

---

## 1. CAUSE EXACTE DU BLOCAGE

Le blocage n'a **rien à voir avec les assets GBA** (palette, bpp, tileset,
dimensions) : les `.tile` sont corrects et les dimensions (jusqu'à 69×75 tuiles
de 8 px) sont dans les normes du moteur (altere_pond officiel fait 116×96).

La cause est une **erreur de sérialisation JSON**, silencieuse à l'écran :

RogueEssence désérialise les `.rsground` avec **Json.NET**
(`TypeNameHandling.Auto`, cf. `RogueEssence/Data/Serializer.cs`). Trois défauts
de nos fichiers générés le faisaient échouer ou dériver :

| # | Gravité | Défaut | Effet |
|---|---|---|---|
| 1 | **FATALE** | `"Anims": {"$values": []}` **sans** `"$type"` dans `Decorations[0]` | Json.NET ne peut pas convertir un *objet* JSON en `List<GroundAnim>` sans indication de type → `JsonSerializationException` → le chargement de la map est avorté → **écran noir/blocage**. La forme `{"$type": "...List`1[[...]]...", "$values": []}` est légale (cf. `genesis_vision.rsground` officiel), mais un `$values` orphelin ne l'est pas. Forme canonique : `"Anims": []`. |
| 2 | Champ ignoré/à risque | `Layers[0]` contenait `"Front": false` au lieu de `"Layer": 0` | `Front` n'existe pas dans `MapLayer` ; selon le mode de résolution des membres, champ ignoré (calque à profondeur par défaut) ou exception. Les fichiers officiels utilisent `Name/Layer/Visible/Tiles`. |
| 3 | Robustesse | `rand.s = [0,0,0,0]` | État xorshift dégénéré (générateur bloqué sur 0). Les fichiers officiels embarquent un état non nul. |

Fichiers touchés : **40** — les 31 imports pmd-red (pilote + lots 2-3) **et**
9 grounds ch8-10 créés par crop en 8c24ec1 (celestial_peak_*, cloven_ruins_*,
crystal_sanctuary_*, forgotten_marsh_*) qui portaient le défaut n°1 uniquement.
Les `.rsmap` et `Data/Zone/*.json` ont été scannés : **0 défaut**.

### Pistes écartées (vérifiées une par une)
1. **Format/palette/bpp** : rendu 4bpp GBA → PNG RGBA 8 bits/canal par tuile,
   même format que tous les `.tile` du dépôt. Index `Content/Tile/index.idx`
   régénéré et synchronisé (292 tilesets). ✗ pas la cause.
2. **Références manquantes** : chaque `.rsground` référence sa feuille dédiée
   `XXX_Base` (présente), sa musique (présente dans `Content/Music/`), le
   Background `Sky` (présent dans les BG du jeu de base). ✗ pas la cause.
3. **Table entité→position** : `Main_Entrance_Marker` présent partout,
   spawners TEAMMATE clonés d'un spawner officiel fonctionnel. ✗ pas la cause
   du blocage (mais c'est le point 1 qui empêchait d'arriver jusque-là).
4. **Ordre de chargement** : `init.lua` présents, syntaxe validée (lupa).
   ✗ pas la cause.
5. **Taille de zone** : dans les normes. ✗ pas la cause.

---

## 2. FIX APPLIQUÉ

`tools/fix_ground_serialization.py` (idempotent, rejouable) :

1. `{"$values": [...]}` sans `$type` → liste simple `[...]` (récursif, tout le
   document) ;
2. `Layers[0]` : suppression de `Front`, insertion de `Layer: 0`, ré-ordre
   canonique `Name/Layer/Visible/Tiles` ;
3. `rand.s == [0,0,0,0]` → état non dégénéré copié du ground officiel
   `altere_pond`.

Les deux générateurs (`tools/convert_pmdred_batch.py`,
`tools/convert_pmdred_ground.py`) sont patchés pour produire directement le
format canonique — les prochaines conversions n'auront pas besoin du fix.

## 3. GARANTIE DE NON-ALTÉRATION

Le fix calcule une **empreinte SHA-256 avant/après** sur : la grille `Tiles`
complète, la grille `obstacles` complète (collision), tous les `Markers`
(noms + colliders), tous les `Spawners` (noms + colliders), `Music`,
`AssetName`. Le script **refuse d'écrire** si l'empreinte change
(`assert before == after`). Résultat : 40/40 fichiers corrigés, 40/40
empreintes identiques.

Contrôle spécifique sur la zone Rayquaza→Lugia (`autel_celeste`, positions du
script gs209 en tuiles×8 px) après fix :
- `Main_Entrance_Marker` (héros) : (296,296) = tuile (37,37) ✓
- `Boss_Marker` (Rayquaza→Lugia) : (272,272) = tuile (34,34) ✓
- `Cutscene_Marker` (trigger) : (272,280) = tuile (34,35) ✓
- `TEAMMATE_1/2/3` : (256,296)/(272,336)/(304,328) = tuiles (32,37)/(34,42)/(38,41) ✓

**Aucune coordonnée, mur ou position de spawn d'origine n'a été altérée.**
Seul le *mapping entité→spawn* change (règle du projet) : le héros/partenaire
New Era et le boss recasté apparaissent aux points de spawn exacts de la map
d'origine — c'est le script `init.lua` de la zone qui fait ce mapping
(ex. `autel_celeste/init.lua` : TeleportTo(hero, 296,296), Lugia à 272,272).

---

## 4. CHECKLIST RÉUTILISABLE — migration d'une ground map pret/* vers RogueEssence

**A. Extraction (1:1, aucune transformation spatiale)**
- [ ] Décoder BPL/BPC/BMA avec `tools/pmdred_lib.py` (GBA ≠ NDS : ne pas
      utiliser skytemple pour le BPC).
- [ ] Rendu identity-mapped : tuile (x,y) → `TexLoc{X:x,Y:y}` de sa feuille
      dédiée `Content/Tile/<Asset>_Base.tile` (8 px, dédup par offsets).
- [ ] Collision BMA cellule par cellule → `obstacles[x][y].Tags` (0/1).
      Si `hasCollision=0` : dériver de la zone visible et LE DOCUMENTER dans
      `Comment`.
- [ ] Positions d'entités : parser `GroundLivesData`/`GroundEffectData` du
      `ground_data_*_station.h` source. kind 0 = héros → `Main_Entrance_Marker`,
      kind 4/34/10/11 → `TEAMMATE_n`, kind ≥ 80 → `Boss_Marker`,
      effets → `Cutscene_Marker`. Tuile → px : ×8.

**B. Format `.rsground` (la partie qui a causé l'écran noir)**
- [ ] Encodage UTF-8 **avec BOM**.
- [ ] JAMAIS de `{"$values": ...}` sans `"$type"` — utiliser des listes simples.
- [ ] `Layers[0]` = `{Name, Layer: 0, Visible, Tiles}` (pas de `Front`).
- [ ] `rand.s` ≠ [0,0,0,0].
- [ ] `Decorations[0].Anims = []`.
- [ ] Champs identiques au modèle officiel `altere_pond.rsground` (mêmes clés,
      mêmes types) — le vérifier par diff de schéma en cas de doute.
- [ ] Filet de sécurité : `python3 tools/fix_ground_serialization.py`
      (idempotent) + contrôle 0 orphelin sur `Data/Map` et `Data/Zone`.

**C. Branchement**
- [ ] `Content/Tile/index.idx` régénéré (`tools/rebuild_tile_index.py`).
- [ ] Ground listé dans `GroundMaps` de la zone + `Grounds` du résumé
      `Data/Zone/index.idx` si navigable.
- [ ] `init.lua` : mapping entité→spawn UNIQUEMENT (mêmes coordonnées,
      casting New Era), musique existante dans `Content/Music/`,
      strings dans `strings.resx` (+ `.fr.resx` pour le texte joueur).
- [ ] Syntaxe Lua validée (lupa `loadfile`).

**D. Audit final (§11)**
- [ ] Flood-fill depuis `Main_Entrance_Marker` : toutes les entités sur cases
      atteignables.
- [ ] Empreinte géométrie inchangée si retouche postérieure (utiliser le
      pattern `geometry_fingerprint` de `fix_ground_serialization.py`).
- [ ] Ligne de traçabilité dans `docs/pmdred_extraction_tracabilite.md`
      + `docs/integration_tracker.md`.
