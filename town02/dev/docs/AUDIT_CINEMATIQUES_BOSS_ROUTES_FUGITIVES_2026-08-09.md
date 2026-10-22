# AUDIT CINÉMATIQUES DE BOSS + ROUTES DE L'ARC FUGITIF vs CANON PMD RED

**Branche : `arena/019fd882-new-era-abyss-to-ascension-v4` (2026-08-08 22:08) + `pret/pmd-red`.**
**Statut : 100 % lecture seule. Aucune modification.**

---

## PARTIE A — CINÉMATIQUES DE BOSS : le template générique a remplacé la mise en scène canonique

### A.1 Le constat

Les cinématiques de boss de l'arc fugitif passent **toutes par un template unique** :
`FugitiveCinematics.Play(id)` (Data/Script/halcyon/FugitiveCinematics.lua). Ce template fait, pour
chaque scène :

```
GAME:CutsceneMode(true)
GROUND:TeleportTo(hero, 176, 240, Direction.Up)      -- position FIGÉE quel que soit le ground
GROUND:TeleportTo(partner, 152, 240, Direction.Up)
GAME:MoveCamera(176, 196, 1, false); GAME:FadeIn(25)
boss = MakeCharactersFromList({{boss, 176, 136}})     -- boss posé TOUT DE SUITE, visible
UI:WaitShowTitle(b.title, 20)
2-3 lignes de dialogue (WaitShowDialogue)
GAME:CutsceneMode(false)
```

Scènes concernées (toutes en `arc_fugitif/scene/*.lua` = wrapper de 4 lignes → `C.Play(id)`) :

| Scène | Boss canonique | Template ? |
|---|---|---|
| d09p03 | **Sulfura (Moltres)** — Mont Ardent | ✅ template (2 lignes) |
| d10p03 | **Artikodin (Articuno)** — Neiges | ✅ template (2 lignes) |
| d11p03 | **Feunard (Ninetales)** — témoignage | ✅ template (3 lignes) |
| d12p04 | **Groudon** — Cœur de la Terre | ✅ template (2 lignes) + VFX flame ajouté à part |
| d13p03 | **Rayquaza** — Arbitre du Ciel | ✅ template (2 lignes) |
| a02p01..a02p04 | routes fugitives | ✅ template (titre + 2 lignes) |

### A.2 Ce que le canon PMD Red fait (vérifié dans les scripts GBA) et que le template jette

| Élément canonique | Exemple GBA (gs206 Groudon) | Template PMDO |
|---|---|---|
| **Le duo MARCHE vers le boss** | `WALK_RELATIVE(128, 0, -8)` (héros avance de 8 cases vers Groudon) + rotations (`ROTATE_TO` NW/NE/N) | ❌ TeleportTo figé, aucun déplacement |
| **Apparition progressive du boss** | fanfares d'éveil `FANFARE_PLAY2(665/662)`, `ALERT_CUE`, tremblements | ❌ boss créé immédiatement, visible dès le fondu |
| **Réactions des alliés présents** | dialogues des alliés (« Look! It's {NAME_3}! »), rotations | ❌ aucun allié |
| **Positions canoniques par ground** | héros (34,29), partenaire (27,29), Groudon (30,22) sur fosse_ardente | ❌ toujours (176,240)/(152,240)/(176,136) |
| **Musique/ambiance par étape** | `MUS_IN_THE_DEPTHS_OF_THE_PIT`, fanfares | ⚠️ musique du BEAT (1 piste) |

**Conséquence directe** : en jeu, le joueur arrive, le boss est déjà là (collé au nord de l'arène),
aucun mouvement — exactement ce que tu as observé avec Groudon et Sulfura.

### A.3 La seule exception soignée : tour_ciel_sommet (Rayquaza)

`Data/Script/halcyon/ground/tour_ciel_sommet/init.lua` (34 appels ciné) = le standard à généraliser :
téléportation aux positions canoniques (296,296)/(256,296) ✓, `BossFX.DescendSky` (Rayquaza descend
des nuages, apparition progressive ✓), `BossFX.PushBack` (le duo repoussé ✓), flash, rotations,
dialogues CPB_001+ ✓.

---

## PARTIE B — ROUTES DE L'ARC FUGITIF : A02 en template, A03 absentes du cheminement

### B.1 L'arc fugitif canonique PMD Red (7 routes, vérifié dans les sources)

| Map canonique | Script | Fichier GBA | Contenu cinématique canonique |
|---|---|---|---|
| MAP_FUGITIVES_FISSURE | gs164 | a02p01 | ouverture de la fuite (BGM_STOP → THE_ESCAPE) |
| MAP_FUGITIVES_FIRE | gs165 | a02p02 | incendie, fuite |
| MAP_FUGITIVES_LAPIS_CAVE | gs166 | a02p03 | **la foule poursuit** : « Gasp... Gasp... », « They're running for Mt. Blaze! », « Are they insane? Mt. Blaze is doomed desolation! » + 10 mouvements |
| MAP_FUGITIVES_VOLCANO | gs167 | a02p04 | **soulagement** : « We can say good-bye to living like fugitives », « We don't have to keep running away anymore! » + 14 mouvements |
| MAP_FUGITIVES_SNOW_ROAD | gs168 | a03p01 | **le froid** : « ...Brr... It's cold! », « Hachoo! », « My nose is running, and it's freezing. », « Those trees are frozen! » + 15 mouvements |
| MAP_FUGITIVES_SNOW_FOREST | gs169 | a03p02 | **la neige** : « Wow! The snow is like frozen powder! » |
| MAP_FUGITIVES_BLIZZARD_ROAD | gs170 | a03p03 | **rencontre avec Feunard (Ninetales)** : « ...Finally, you have arrived... », « I am visible only to you. », « Inside its peak... Ninetales lives. », « Beware... » + 9 mouvements |

**Ordre canonique dans la trame** : A02 (fissure→incendie→Lapis→volcan) → donjon Lapis Cave (D08)
→ donjon Mt Blaze (D09, Moltres) → **A03 (route de neige → forêt de neige → route de blizzard/
Ninetales)** → donjon Frosty Forest (D10, Articuno) → Mt Freeze (D11, Ninetales) → Magma Cavern
(D12, Groudon) → Sky Tower (D13, Rayquaza).

### B.2 Ce que le mod fait (et ne fait pas)

**Présent** :
- Grounds A02 actifs : `Data/Ground/a02p01..a02p04.rsground` (+ scripts `ground/a02p0X/init.lua`).
- Grounds A03 **en réserve uniquement** : `RESERVE/red_grounds/a03p01..a03p03.rsground` (pas actifs).
- `FugitiveArc.SEQUENCE` : suit l'ordre canonique pour les donjons (D08→D13) et A02.

**Problèmes** :
1. **Les A02 utilisent le template générique** → les dialogues canoniques de la poursuite
   (« Gasp... Gasp... », « They're running for Mt. Blaze! ») et du soulagement (« We can say
   good-bye to living like fugitives ») **ne sont pas joués** — à la place, 2 lignes originales du
   mod + titre.
2. **Les A03 (routes de neige) sont ABSENTES du cheminement** : la SEQUENCE saute de `d09p03`
   (Moltres) directement à `foret_givree_oree` (D10) — les 3 routes de neige canoniques (froid,
   neige, rencontre Ninetales) ne sont **ni actives ni branchées** (absentes de Data/Ground actifs,
   de master_zone, de la SEQUENCE).
3. **Les scènes A03 existent mais leurs textes ne sont pas écrits** : `arc_fugitif/scene/a03p01.lua`
   appelle `SCENE_A03P01_001..014` (idem a03p02/a03p03) mais **aucune de ces clés n'est définie**
   dans les Strings → en jeu, `FormatKey` renverrait la clé elle-même (documenté : « à adopter plus
   tard »).
4. Les musiques canoniques des routes (THE_ESCAPE, Rising Fear…) sont remplacées par 1 piste par
   étape, sans progression.

---

## PARTIE C — SYNTHÈSE DES ÉCARTS (ce qui manque vs PMD Red)

| Élément | État dans le mod | Action requise |
|---|---|---|
| Ciné de boss : déplacement duo vers boss | ❌ aucun (template figé) | réécrire chaque ciné de boss sur le modèle tour_ciel_sommet |
| Ciné de boss : apparition progressive + fanfares/VFX | ❌ boss posé direct | ajouter DescendSky/éveil/fanfares par boss |
| Ciné de boss : positions canoniques par ground | ❌ (176,240) générique partout | utiliser les positions canoniques (markers du ground) |
| Route A02P03 (poursuite foule) | ❌ template (2 lignes) | jouer les dialogues canoniques + mouvements |
| Route A02P04 (soulagement) | ❌ template (2 lignes) | idem |
| Route A03P01 (froid) | ❌ non branchée + textes vides | activer le ground, écrire SCENE_A03P01_*, brancher entre D09 et D10 |
| Route A03P02 (neige) | ❌ idem | idem |
| Route A03P03 (rencontre Ninetales) | ❌ idem (scène dédiée mais texte vide + non branchée) | idem |
| Musique canonique par étape | ⚠️ 1 piste/étape | enrichir |

---

## PARTIE D — PROCHAINE ÉTAPE (sur validation, aucune modification faite)

1. **Réécrire les 5 cinématiques de boss de l'arc fugitif** (Moltres, Articuno, Ninetales, Groudon,
   Rayquaza) sur le modèle `tour_ciel_sommet` : positions canoniques, déplacement du duo, apparition
   progressive, fanfares/VFX, dialogues PMD Red traduits/adaptés.
2. **Activer et brancher les 3 routes A03** dans la SEQUENCE entre D09 (Mt Blaze) et D10
   (Frosty Forest) + les grounds dans Data/Ground + master_zone.
3. **Écrire les textes SCENE_A03P0X_*** (traduction des dialogues canoniques : froid, neige,
   rencontre Ninetales).
4. **Remplacer le template des A02** par les scènes canoniques (poursuite, soulagement).
