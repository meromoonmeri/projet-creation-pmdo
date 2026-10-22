# Diagnostic — damier mauve/noir du duel de la place de Metano (2026-08-05)

Symptôme rapporté par l'auteur : depuis le commit `9cbdf80`
(*« Duel Team Dazzling : toute la place de Metano en copie pixel (63x63) »*),
la carte `metano_town_duel` s'affiche en jeu comme un **damier mauve et
noir**. Avant ce commit, la place était valide pour le combat contre la
Team Dazzling.

---

## 1. Fonctionnement exhaustif `.rsmap` / `.rsground` (ce qu'il faut savoir)

Les deux fichiers sont du **JSON** (chargeable avec `utf-8-sig`).

### `.rsground` — carte de cinématique (`Data/Ground/`)

- `Object.Layers[i].Tiles[x][y]` : grille graphique, pas de `8 * TexSize` px
  (`TexSize=1` → cellules de 8 px pour Metano).
- `GroundMap.Width/Height` se lisent sur `Layers[0].Tiles` (GroundMap.cs:49).
- Chaque cellule contient `Layers[]` (pile de `TileLayer`) :
  `TileLayer.Frames[k] = { Sheet, TexLoc {X,Y} }` — plusieurs frames =
  tuile animée (`FrameLength` en frames moteur).
- `Object.obstacles[x][y].Tags` : grille de collision **toujours en
  cellules de 8 px** (`0` = libre). Dimensions = `W*TexSize × H*TexSize`
  cellules, distincte de la grille graphique.
- `Object.Entities` : PNJ, objets interactifs, markers de cinématique.

### `.rsmap` — carte de combat (`Data/Map/`)

- `Object.Tiles[x][y]` : grille **logique** de tuiles de 24 px.
  `Data.ID` = `floor` / `unbreakable` / etc. (collision du donjon),
  `TileTex` = texture de terrain (vide dans notre duel, la déco vient des
  couches).
- `Object.Layers` : **même** structure `MapLayer` que le ground
  (`Tiles[x][y].Layers[].Frames[]`), dessinée dans l'ordre croissant de
  `Layer` (`< 4` sous les personnages, `== 4` frange au-dessus).
- `EntryPoints` : positions d'arrivée joueur/partenaire (en tuiles).
- `MapTeams[].Players[]` : ennemis fixes ; **leur position de spawn est
  dans `serializationLoc`** (tuiles), pas dans `BaseForm`.
- `AllyTeams[]` : PNJ neutres (le moteur leur impose `Faction.Friend` au
  chargement — trêve garantie, cf. en-tête de `DazzlingPlaza.lua`).
- `Music`, `MapEffect`, `Name` (avec `LocalTexts.fr`)…

### Planches `.tile` et `index.idx` — la chaîne de résolution des textures

```
Sheet (nom dans la carte)
   → Content/Tile/index.idx     (nom → tileSize + table clé→offset)
   → Content/Tile/<nom>.tile    (à offset : int64 len + PNG)
   → texture en jeu
```

- `.tile` : `uint32 tileSize, uint32 count`, `count × (uint64 key =
  x|(y<<32), uint64 offset_absolu)`, puis à chaque offset `int64 len` +
  octets PNG. Les tuiles identiques **partagent le même offset**
  (déduplication).
- `index.idx` : `uint32 nbTilesets`, puis par tileset `uint8 lenNom`,
  nom UTF-8, `uint32 tileSize`, `uint32 count`, **copie de la table**
  `count × 16 octets`.
- **Sans entrée dans `index.idx`, le moteur ne trouve pas la planche et
  dessine la texture de substitution = damier mauve/noir.** C'est
  exactement ce qui s'est passé.

---

## 2. Comparaison des trois intégrations de la place pour le duel

| | `dc360a1` (31/07) | `79a096b` (02/08) | `9cbdf80` (04/08) |
|---|---|---|---|
| Fenêtre | 19×13 tuiles | **14×18 tuiles** | 63×63 tuiles |
| Couches | 9 | 8 | 10 |
| Planches | 27 `Metano_Arene_*` | **17 `Metano_Arene_*`** | 27 `metano_city_*` |
| Entrées | … | (6,10) / (5,10) | (48,42) / (47,42) |
| Duo/Trio | … | (7,9) etc. | (48,38) etc. |
| index.idx | injecté ✅ | injecté ✅ | **JAMAIS injecté ❌** |
| En jeu | valide | **valide** | **damier mauve/noir** |

La méthode de `dc360a1` (le « premier agent ») : transplant pixel-par-pixel
via `tools/make_metano_arene.py` — fusion des blocs 3×3 de cellules 8 px du
ground en tuiles 24 px, une planche dédiée par couche, **injection des
planches dans `index.idx`**, JSON indenté sans BOM. `79a096b` a recentré la
fenêtre sur la place marchande (14×18) par le même outil — état jugé valide.

## 3. Cause racine du damier

Le message du commit `9cbdf80` affirme : *« 27 planches metano_city_*.tile
générées et injectées dans Content/Tile/index.idx (568 planches) »*.

**Vérification octet par octet : cette affirmation est fausse.**

- `index.idx` à `9cbdf80` : **541 tilesets, 0 entrée `metano_city`** —
  identique au parent `9cbdf80~1` (541) et à HEAD (541).
- `git show 9cbdf80 --stat` : le commit ne touche que les 27 `.tile` et le
  `.rsmap`. `index.idx` n'y apparaît pas.
- Résultat : les 27 planches existaient sur disque mais étaient
  **invisibles pour le moteur** → chaque tuile de chaque couche tombait en
  texture manquante → damier sur toute la carte.

Le fichier `.rsmap` avait aussi changé de forme (JSON minifié 1 ligne, BOM
ajouté, contre 28 122 lignes indentées sans BOM avant) — gênant pour les
diffs, mais sans lien avec le damier.

## 4. Correctif appliqué (cette session)

1. **`Data/Map/metano_town_duel.rsmap` restauré à `79a096b`** (14×18,
   entrées (6,10)/(5,10), trio Dazzling au centre de la place).
2. **27 planches `metano_city_*.tile` supprimées** ( mort-nées : jamais
   référencées ailleurs, jamais dans l'index).
3. Vérifications nouvelles :
   - `tools/verify_tile_index.py` — contrôle exhaustif planches ↔
     index.idx ↔ toutes les cartes du dépôt (aurait intercepté l'incident).
     Verdict : **541/541 cohérent, 0 problème**.
   - `tools/verify_duel_pixelmatch.py` — recherche la fenêtre source dans
     `metano_town.rsground` par glissement et mesure l'écart pixel :
     **fenêtre (41,29), 0 pixel différent sur 145 152** (rendus dans
     `docs/renders/duel_vs_ground_pixelmatch.png`,
     `duel_fenetre_dans_metano.png`, `metano_town_duel_restaure.png`).

## 5. Non testé

Validation 100 % statique. À confirmer manette en main : Acte I →
`ContinueDungeon("gloomy_forest", 7)` → la place s'affiche (plus de
damier), trio au centre, entrées joueur au sud, spectateurs neutres.
