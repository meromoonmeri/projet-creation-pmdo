# CORRECTION EXHAUSTIVE — ARÈNES DE COMBAT, CINÉMATIQUES, ROUTES FUGITIVES

**Branche : `arena/019fd882-new-era-abyss-to-ascension-v4` — 2 commits poussés :**
- `c191c8c` — routes A03 activées + cinématiques canoniques des routes et des 5 boss
- `665c478` — arènes de combat plein écran + sprites de boss corrigés + AllyTeams retirés

---

## 1. ROUTES DE L'ARC FUGITIF (A02/A03)

| Élément | Avant | Après |
|---|---|---|
| Routes A03 (froid/neige/blizzard) | **absentes** du cheminement (grounds en réserve) | **activées** : `a03p01/02/03.rsground` dans Data/Ground, `init.lua`, ajoutées à `master_zone` (fin de tableau, sans décaler les index) et à `FugitiveArc.SEQUENCE` entre Mt Blaze (D09) et Frosty Forest (D10) — **ordre canonique PMD Red** |
| Cinématiques routes A02 | template générique (2 lignes + titre) | **réécrites** : déplacements scriptés du duo (`MoveCharAndCamera`), émotes, **voix de la foule** (poursuite A02P03), soulagement (A02P04), froid (A03P01), neige (A03P02), **voix invisible de Feunard** (A03P03 « Je ne suis visible que de vous ») |
| Textes routes | clés SCENE_* **vides** | **107 clés remplies** FR + EN (dialogues canoniques PMD Red traduits/adaptés « 30 ans plus tard ») |
| Taille des grounds | — | tous ≥ écran (480×360, 264×192, 360×288, 960×288…) → **aucune bande noire** |

## 2. CINÉMATIQUES DES 5 BOSS (arc fugitif)

| Boss | Avant | Après (modèle tour_ciel_sommet) |
|---|---|---|
| **Sulfura** (D09P03) | template : boss posé direct | `EmergeFire` dans les flammes + flash + shake, jugement, promesse, positions canoniques (34,22) |
| **Artikodin** (D10P03) | template | `EmergeMist`, accusation, intervention d'Absol, positions canoniques (33,22) |
| **Feunard** (D11P03) | template | témoignage (pas de combat), apparition discrète dans la brume |
| **Groudon** (D12P04) | template + VFX isolé | `EmergeFire` + VFX flamme + secousse + flash, réveil, positions canoniques (30,22) |
| **Rayquaza** (D13P03) | template | `DescendSky` + `PushBack` + flash, arbitre du ciel, positions canoniques (34,34) |

Chaque scène : **déplacement scripté du duo vers le boss**, apparition progressive, dialogue canonique (clés SCENE_D09P03/D10P03/D11P03/D12P04/D13P03 — **102 clés remplies** FR+EN).

## 3. ARÈNES DE COMBAT — PLEIN ÉCRAN (plus de bandes noires)

8 arènes **régénérées depuis les grounds sources complets** (collision = obstacles du ground,
visuel = Layers du ground, entrée/boss aux markers canoniques) :

| Arène | Avant (rognée) | Après (source complète) |
|---|---|---|
| `magma_cavern_pit` (Groudon) | 21×21 = 168×168 px | **63×63 = 504×504 px** — Groudon (30,22) |
| `mt_blaze_summit` (Moltres) | 23×23 = 184×184 | **69×69 = 552×552** — Moltres (34,22) |
| `frosty_forest_summit` (Articuno) | 22×21 = 176×168 | **66×63 = 528×504** — Articuno (33,22) |
| `tour_ciel_sommet` (Rayquaza) | 23×25 = 184×200 | **69×75 = 552×600** — Rayquaza (34,34) |
| `wish_cave_jirachi` (Jirachi) | 15×14 = 120×112 | **45×42 = 360×336** |
| `mount_windswept_guardian` (Tornadus) | 15×14 = 120×112 | **45×42 = 360×336** |
| `vast_steppe_guardian` (Absol) | 16×22 = 128×176 | **46×66 = 368×528** |
| `gloomy_forest_boss` (Zeraora) | 20×16 = 160×128 | **60×47 = 480×376** |

**Le combat se joue désormais sur la même géométrie que la cinématique** (le boss apparaît là où
la ciné le montrait) — plus de « boss collé au mur » ni de bandes noires.

## 4. SPRITES DE BOSS (le moteur rend `CurrentForm`)

17 arènes corrigées — le joueur voit le **vrai boss** :
- **Tsareena → Rayquaza** (tour_ciel_sommet), **Diancie** (crystal_sanctuary), **Swampert/Laggron** (forgotten_marsh)
- **Zeraora → Articuno** (frosty_forest), **Jirachi** (wish_cave)
- **BaseForm aligné** : Regice/Regirock/Registeel (cloven_ruins), gardiens du sanctuaire_titans (stats cohérentes avec le rendu)

## 5. ALLYTEAMS SPECTATEURS

Retirés des arènes de boss isolées : `mount_windswept_guardian`, `sanctuaire_voeu`
(8 spectateurs L5 hérités du template). **La foule reste uniquement dans les scènes Metano**
(duel + raids — légitime).

## 6. AUDIT FINAL

**47 arènes OK / 52** (boss + entrée walkable, sprites cohérents). Restants (documentés, à traiter
séparément) :
- `boss_artifact_water` (DumpAsset) : 4 boss sur tuile `water` — salle secondaire, à vérifier
- `marais_errants_fond` : boss sur `grass` — **faux positif** (l'herbe est traversable)
- `metano_raid_1/2/3` : ennemis empilés à l'arrivée — embuscade à re-composer
- `forgotten_marsh_miniboss` : étage 7×7 **sans couche visuelle** (vestige) — à reconstruire
- `crystal_sanctuary_boss` / `forgotten_marsh_boss` : 120×112 / 152×112 (arènes New Era **sans
  source complète**) — à étendre via un plan officiel (méthode Tornadus v2)

## 7. MUSIQUES

16/17 musiques canoniques de l'arc en .ogg. **`The Escape`** (musique de la fuite A02) :
**introuvable en source** (données audio GBA non extraites de pret/pmd-red, aucun .ogg dans les
dépôts) → nécessite la **ROM GBA** pour extraction. En attendant : `Rising Fear.ogg` (piste de
tension PMD, déjà branchée).
