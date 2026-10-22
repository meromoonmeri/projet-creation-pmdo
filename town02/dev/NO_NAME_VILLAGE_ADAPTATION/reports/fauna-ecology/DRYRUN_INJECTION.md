# Dry-run d'injection de la faune — rapport complet

**Aucune écriture n'a été faite dans `Data/`, `Content/` ni dans un Ground.**
Ce document est le plan exact de ce qui serait modifié, plus les preuves
associées. Données brutes : `dryrun-injection.json`,
`evidence-classification.json`.

Gardes au moment du dry-run : **5 982 contrôles au vert**, pixel-perfect
confirmé, aucun damier.

---

## 1. Séparation des niveaux de preuve — fail-closed

| Niveau | Rooms | Individus placés | Promus | Politique |
|---|---:|---:|---:|---|
| **PROVEN** (rendu + collision) | 34 | 1 751 | **1 751** | injectable |
| **PARTIAL** (une seule preuve) | 0 | 0 | 0 | bloqué sans validation |
| **NO_PROOF** (aucune preuve) | 11 | 57 | **0** | FAIL-CLOSED |

Rooms `NO_PROOF` : `rm38`, `rm47`, `rm48`, `rm49`, `rm57`, `rm68`, `rm77`,
`rmcave1`, `rmcave1_0`, `rmcave1_1`, `rmcave1_2`.

Motif unique et vérifié : **leur Ground reconverti n'existe pas** dans
`/tmp/reconv`, donc ni rendu 4992×4992 ni grille de collision. Les seuls
GameObjects source ne disent rien de la praticabilité réelle ni de la présence
d'eau — exactement le piège qui aurait noyé rmvillage. Les 57 individus qui y
étaient positionnés sont **retenus, pas déplacés ailleurs**.

Aucune room n'est en `PARTIAL` : la répartition est nette (34 / 0 / 11).

## 2. Espèces mises en attente

| Espèce | Statut | Raison |
|---|---|---|
| **Cradily** | `HELD` | Ses **92 occurrences source sont toutes dans `rmcave1_0/1/2`**, rooms sans preuve. Aucun placement de substitution : Cradily n'apparaît nulle part. |
| **Sandshrew** | `HELD` | Révélé par la classification : ses 16 individus tombaient tous dans des rooms `NO_PROOF` (`rmcave1*`). Retenu au même titre. |

Ces deux espèces restent dans le roster (25 espèces) mais ne sont **pas
injectées**. Elles attendent la reconversion des Grounds correspondants. Le
test échoue si l'une d'elles réapparaît dans une room promue.

## 3. Couverture saisonnière — 109 individus différés

Seule la variante **`summer`** existe aujourd'hui dans `/tmp/reconv` (34/34
rooms). Les espèces d'automne et d'hiver n'ont donc aucun Ground où être
écrites :

| Espèce | Saison | Individus différés |
|---|---|---:|
| ledyba | automne | 20 |
| piloswine | hiver | 16 |
| dwebble | automne | 13 |
| chinchou | automne | 10 |
| delibird | hiver | 10 |
| swanna | automne | 9 |
| swinub | hiver | 9 |
| ariados | automne | 7 |
| lotad | automne | 7 |
| crabrawler | hiver | 4 |
| ducklett | hiver | 4 |
| **Total** | | **109** |

Ils ne sont ni perdus ni relogés en été : ils attendent les variantes
`autumn`/`winter`. **1 751 − 109 = 1 642 entités effectivement injectées.**

## 4. Fichiers qui seraient modifiés

### 4.1 Grounds — 34 fichiers, +4,35 Mo

`MODIFY` sur `/tmp/reconv/<room>/Data/Ground/nnv_<room>_summer.rsground`
(ajout d'entités `GroundChar`, ~2 650 o par entité).

Les 12 rooms les plus peuplées :

| Room | Entités | Espèces |
|---|---:|---:|
| rm35 | 103 | 11 |
| rm84 | 99 | 7 |
| rm59 | 96 | 3 |
| rm83 | 87 | 8 |
| rm67 | 86 | 4 |
| rm23 | 80 | 7 |
| rm44 | 79 | 9 |
| rm24 | 78 | 8 |
| rm43 | 70 | 10 |
| rm34 | 67 | 6 |
| rm82 | 62 | 3 |
| rm64 | 61 | 6 |

**23 espèces** injectées au total (25 − Cradily − Sandshrew). Le détail par
room, espèce et cellule est dans `dryrun-injection.json`.

### 4.2 Scripts Lua — 2 créations, 1 modification

| Fichier | Action | Pourquoi |
|---|---|---|
| `Data/Script/halcyon/NNVEcology.lua` | `CREATE` | moteur de vie autonome |
| `Data/Script/halcyon/NNVDuel.lua` | `CREATE` | bascule Ground → `.rsmap` |
| `Data/Script/halcyon/NNVLife.lua` | `MODIFY` | ⚠️ voir ci-dessous |

**Conflit identifié dans `NNVLife`** : `Life.GROUPS` contient déjà
`source_birds` (12 `objbird0`) et `source_butterflies` (19 `objbutterfly1`),
qui recouvrent **exactement** les mêmes occurrences que NNVEcology pilote dans
rmvillage. Sans retrait, ces 31 Pokémon seraient commandés par deux boucles
concurrentes. Ces deux groupes doivent être supprimés de `NNVLife` au moment de
l'injection.

### 4.3 Maps de duel — 6 créations, +1,17 Mo

Pour chaque : `Data/Map/nnv_duel_<room>_summer.rsmap` (~143 Ko) +
`Content/Tile/NNV_Duel_<Room>_Summer.tile` (~46 Ko).

Rooms couvertes : rm35, rm59, rm82, rm83, rm84, rmvillage.
Fenêtre 26 × 14 tuiles = 624 × 336 px. **`pixel_identical: true` sur les six.**

### 4.4 `Content/Tile/index.idx` — modification à risque

`MODIFY`, +~30 Ko sur 23,5 Mo existants (735 planches déclarées).

**Pourquoi c'est obligatoire**, chaîne moteur prouvée :

```
GraphicsManager.GetTile()            (GraphicsManager.cs l.1152)
  → TileIndex.GetPosition(Sheet, TexLoc)
      → TileGuide.GetPosition        (Indices/TileIndex.cs l.76)
          si planche inconnue          → return 0      ← cause A
      → TileIndexNode.GetPosition    (Indices/TileIndex.cs l.46)
          si TexLoc inconnu            → return 0      ← cause B
  → if (tilePos > 0) { charge le PNG }
  → sinon : BaseSheet.LoadError()   =  DAMIER MAUVE/NOIR
```

**Où** : `Content/Tile/index.idx` (`GraphicsManager` l.552 et l.1130), et le
`<Sheet>.tile` au même endroit.

**Garde ajoutée** : `tools/verify_tile_index.py` relit l'index binaire, résout
chaque couple (Sheet, TexLoc) référencé, vérifie que l'offset est > 0, tombe
dans le fichier et pointe sur une signature PNG valide.

Vérifié sur les 3 maps de raid existantes : **2 064 tuiles, aucun damier**.
Et les deux causes sont bien détectées quand on les simule :

| Simulation | Détection |
|---|---|
| planche `Planche_Fantome` inexistante | ✅ `ABSENTE de index.idx -> DAMIER (cause A)` |
| `TexLoc (9999,9999)` hors table | ✅ `absent de index.idx -> DAMIER (cause B)` |

### 4.5 Zones — 2 fichiers

| Fichier | Action |
|---|---|
| `Data/Zone/nnv_wild.json` | `CREATE` — 6 segments `IsRelevant = false` |
| `Data/Zone/index.idx` | `MODIFY` — resynchronisation |

### 4.6 Poids total

| Poste | Taille |
|---|---:|
| Grounds (delta) | 4,35 Mo |
| Maps de duel + planches | 1,17 Mo |
| Scripts Lua | 0,03 Mo |
| Zones | 0,01 Mo |
| `index.idx` (delta) | 0,03 Mo |
| **Total** | **5,59 Mo** |

---

## 5. Sauvegarde et rollback

1. Les Grounds reconvertis vivent dans **`/tmp/reconv`, hors dépôt** :
   l'injection écrit des copies, les originaux restent intacts.
2. `git tag pre-fauna-injection` sur le HEAD courant avant toute écriture.
3. Chaque fichier modifié copié en `<fichier>.pre-fauna.bak`, sha256 consigné
   dans `rollback-manifest.json`.
4. **`Content/Tile/index.idx` sauvegardé en entier** (23,5 Mo) : c'est le seul
   fichier partagé réellement à risque, une corruption casserait tout le mod.
5. Rollback : `git checkout pre-fauna-injection -- Data/ Content/`, puis
   `verify_tile_index.py` pour confirmer l'absence de damier.

Fichiers irréversibles sans sauvegarde : `Content/Tile/index.idx`,
`Data/Zone/index.idx`.

---

## 6. Gardes anti-régression — vérifiées par injection de panne

| # | Régression simulée | Détection |
|---|---|---|
| 1 | Croagunk ajouté (déjà à Metano) | ✅ `espece croagunk deja presente a Metano/Guilde` |
| 2 | Individu déplacé dans un arbre | ✅ `rm14/ariados dans un obstacle (13,0) t=5` |
| 3 | Preuve de duel corrompue (812 px) | ✅ 2 échecs |
| 4 | Profil `timid` en pause permanente | ✅ `profil timid en pause permanente` |
| 5 | **1 pixel magenta** dans une planche `.tile` | ✅ `PROMOTION REFUSEE` — bbox (0,0,1,1), sha divergents, couleur de damier |
| 6 | Room `NO_PROOF` promue | ✅ `rmcave1_0 (NO_PROOF) promeut 6 individus sans preuve` |
| 7 | Cradily sorti d'attente | ✅ `cradily doit rester en attente` |

Retour au vert après restauration dans les sept cas.

Le cas 5 est le plus important : **un seul pixel sur 209 664 suffit à refuser
la promotion.**

---

## 7. Garde permanente du pipeline de duel

`tools/verify_duel_pixel_identity.py` implémente la chaîne demandée :

```
Ground → rendu de référence → .rsmap de duel → rendu de duel
       → comparaison pixel-perfect → validation
```

Elle **ne fait pas confiance** aux `*_proof.json` produits à la génération : ils
pourraient être périmés ou falsifiés. Elle refait le travail en suivant la
chaîne moteur réelle — pour chaque tuile, `(Sheet, TexLoc)` → offset dans
`index.idx` → PNG à cet offset dans `<Sheet>.tile` — puis compare au rendu du
Ground redécoupé.

Contrôles supplémentaires : aucune couleur de damier, aucun pixel transparent,
sha256 identiques.

Résultat actuel :

```
nnv_duel_rm35_summer       26x14  sha=bc2bd98633bf  OK
nnv_duel_rm59_summer       26x14  sha=335442eb958c  OK
nnv_duel_rm82_summer       26x14  sha=348cadb21179  OK
nnv_duel_rm83_summer       26x14  sha=e0d3d9210be2  OK
nnv_duel_rm84_summer       26x14  sha=4841c54d0cb6  OK
nnv_duel_rmvillage_summer  26x14  sha=d27183e456e6  OK

PIXEL-PERFECT CONFIRME: la .rsmap rend exactement le Ground
```

Sortie en code 1 si l'identité est rompue → **la promotion est refusée**.

---

## 8. Vie sauvage : contrôle anti-végétatif

Le test ne vérifie pas seulement l'existence des Pokémon :

- tout profil non-`sessile` doit avoir `speed > 0`, `pause_ratio < 1.0` et
  `radius > 0` — sinon échec ;
- `sessile` doit avoir `speed == 0` **et** des états d'immobilité nommés
  (`ancre`, `oscille`, `oriente`, `filtre`) : l'immobilité est un comportement,
  pas un trou ;
- chaque état déclaré dans un profil doit avoir un texte d'observation
  correspondant ;
- les relations inter-espèces ne peuvent référencer que des espèces du roster
  et l'un des 7 verbes (`ignore`, `curieux`, `evite`, `fuit`, `chasse`,
  `rivalise`, `grege`).

Les interactions sont autonomes : `NNVEcology.Update()` fait tourner la boucle
sans aucune entrée joueur, et les rencontres se déclenchent sur distance et
cooldown, pas sur une action.

---

## 9. Décision demandée

Le plan est figé et chiffré. Rien n'est écrit. Pour lancer l'injection il faut
trancher trois points :

1. **Le retrait de `source_birds` / `source_butterflies` de `NNVLife`** —
   sinon double pilotage de 31 Pokémon dans rmvillage.
2. **Les 109 individus d'automne/hiver** : injecter seulement l'été maintenant,
   ou attendre la reconversion des 3 autres variantes pour tout faire d'un coup.
3. **`Content/Tile/index.idx`** : c'est la seule modification à risque réel sur
   un fichier partagé de 23,5 Mo. Sauvegarde intégrale prévue.
