# Audit global des livrables — session du 2026-08-02

Branche `new-era-1-9`, du commit `b683870` au commit `0c84477`.
Grille appliquée : `prompt_audit_verification_globale_livrables.md`, six points
par livrable, plus la passe dédiée aux imports canoniques.

Principe retenu : **rien n'est présumé correct du fait d'avoir été livré.**
Ce document inclut donc mes propres erreurs, y compris celles corrigées en
cours de session.

---

## PARTIE A — Le cas Diancie / Cascade Cristal

### A.1 Ce que vous demandez

Diancie doit avoir son donjon avec **son entrance canonique**, et le fond du
donjon doit être **Waterfall Cave** — renommé « Cascade Cristal » dans New Era,
avec sa traduction anglaise.

### A.2 État réel, vérifié

Le donjon actuel de Diancie, `crystal_sanctuary` (ch8, 6 segments) :

| Ground | Grille | Libre | Tuiles | Tilesets | Musique |
|---|---|---|---|---|---|
| `crystal_sanctuary_entrance` | 30×40 | 88,7 % | 1 253 | `First_Core_Location_*` | `Anima Core.ogg` |
| `crystal_sanctuary_boss` | 30×40 | 56,2 % | 4 800 | `First_Core_Location_Base` | `Boss Battle!.ogg` |

**Deux problèmes de fond :**

1. **L'entrance n'est pas canonique.** Elle réutilise les tilesets
   `First_Core_Location_*` — c'est-à-dire le décor du **premier Cœur**, recyclé.
   Ce n'est ni Waterfall Cave, ni un décor de sanctuaire de cristal.
2. **88,7 % franchissable.** Une entrance de donjon à ce taux est un couloir
   quasi vide : c'est le motif « carte 100 % walkable » listé au point 6 de la
   grille d'audit, sous une forme atténuée.

### A.3 Les grounds Waterfall Cave existent déjà

| Ground | Source EoSO | Grille | Tuiles | Tileset | Musique |
|---|---|---|---|---|---|
| `antre_cascade_porte` | `waterfall_cave_entrance` | 51×69 | **4 692** | `waterfall cave entrance` | `Waterfall Cave.ogg` |
| `antre_cascade_dehors` | `waterfall_cave_outside` | 63×54 | 1 134 | `watercave1-0-sheet` | — |

Comparaison automatique avec les sources : **2/2 identiques à la source**.
L'import est fidèle, le décor est complet, la musique est présente.

**Mais les deux sont à 100 % franchissable et n'ont aucune entité** — ni
marqueur, ni sortie. C'est fidèle à EoSO (qui ne les a jamais scriptés), donc
ce n'est pas un défaut d'import : c'est du travail non fait, côté source comme
côté projet.

### A.4 Précision canonique

Attention à une confusion possible : dans `pret/pmd-red` (Rescue Team), le
donjon aquatique est **Waterfall Pond**, `DUNGEON_WATERFALL_POND = 56`,
**20 étages**. La *Waterfall Cave* dont proviennent nos deux grounds est celle
d'**Explorers** (EoSO), un lieu différent.

Les assets que nous avons sont donc ceux d'Explorers. Il faut choisir
lequel des deux sert de référence — je ne l'ai pas tranché seul.

### A.5 Ce que ça implique

Renommer en « Cascade Cristal » suppose trois choses distinctes :

1. **Le nom** dans le `.rsground` (`Name.DefaultText` anglais +
   `LocalTexts.fr`), et dans l'index de zone.
2. **Le décor** : soit `crystal_sanctuary` adopte les tilesets de la cascade,
   soit `antre_cascade_porte` devient l'entrance du sanctuaire. La seconde
   option est la moins coûteuse — le décor y est déjà peint à 4 692 tuiles.
3. **Les collisions** : à tracer intégralement dans les deux cas.

---

## PARTIE B — Audit de mes livrables de la session

### B.1 Ce qui a été livré

| Commit | Contenu | Validation |
|---|---|---|
| `3299bee` | Bourg du Comptoir : 88 entités restaurées, 12 Roads, `ComptoirVoices` | luaparser 10/10, `verify_comptoir` 0 anomalie |
| `c8779a0` | `AccusationArc` (4 scènes), correctifs ch10, `verify_scene_rules` | 40 répliques, 0 anomalie |
| `0c84477` | Météo 9 presets, 6 scènes ch11, 6 MapStatus | 83 répliques, 0 anomalie |

### B.2 Erreurs que j'ai commises et corrigées

Point 6 de la grille — défauts récurrents. Je les liste sans les minimiser.

**1. Les deux Xatu confondus.** J'ai créé une fiche `Xatu` pour un habitant du
Bourg, puis, croyant supprimer un doublon, je l'ai fait pointer sur
`Canyon_Xatu`. Or l'en-tête de `colline_anciens/init.lua` disait déjà : « Xatu
ne se tient PAS à l'entrée du Grand Canyon : il réside sur la Colline des
Anciens. » C'est exactement le motif « personnage mal localisé par rapport à sa
source canonique » cité dans la grille. **Corrigé** : `Canyon_Xatu` (Veilleur)
et `Bourg_Xatu` (Lisandre) sont deux fiches distinctes, avec des noms d'entité
différents sur les cartes.

**2. Module entier écrit sans accents.** `AccusationArc.lua` : 48 répliques
réaccentuées, puis 19 corrections contextuelles à la main. Violation directe de
la règle « les accents doivent être écrits correctement et systématiquement ».

**3. Mon propre outil a introduit un bug.** `fix_accents.py` transformait la
négation « ne » en participe « né » — 21 occurrences. Corrigé, et la règle
fautive retirée de l'outil.

**4. Deux faux positifs dans mes vérificateurs**, corrigés plutôt que tolérés :
`verify_comptoir.py` ne voyait pas les handlers définis par affectation ;
`verify_scene_rules.py` signalait des mots interdits lus dans le commentaire
qui les interdit.

**5. API inventée, rattrapée avant écriture.** J'allais utiliser
`DUN_Thunderbolt` pour le tonnerre. Vérification : ce SE n'existe pas.
L'éclair aurait été muet, sans erreur. Remplacé par `DUN_Shock_Wave`, attesté.

**6. `BossFX.Flash` mal appelé** — `Flash(20)` au lieu de `Flash(x, y, ...)`.

### B.3 Défauts trouvés dans l'existant

| Défaut | Preuve | État |
|---|---|---|
| **Arc fugitif injouable** | `Aftermath()` pose `PlayedVictoryScene` avant la scène Rayquaza, seule à poser `Chapter = 11` | **non corrigé** |
| Import Treasure Town vidé | 11 514 lignes source → 671 ; 18 PNJ perdus | partiellement corrigé (hub) |
| `Main_Entrance_Marker` dans un mur | `bourg_comptoir` (256,300) bloqué | corrigé → (32,200) |
| Sorties `triggerType 0` | `plage_lucioles` : jamais déclenchables | corrigé |
| `'Shock'` comme émotion | emote de bulle, pas portrait — 3 occurrences | 2 corrigées |
| `BossFX.Voice` pour Rayquaza | canal réservé à la Voix anonyme `\uE040` | corrigé |
| Mots interdits dans `CPB_*` | « l'Abîme » ×2, « humain transformé » ×2 | corrigés |
| Kirlia non déclarée | 98 lignes de quiz livrées, fiche absente | **non corrigé** |
| Tournoi ch8 | 0 ligne implémentée sur un plan de 189 lignes | **non fait** |

### B.4 Conformité aux directives de cinématique

Point 2 de la grille, sur `AccusationArc.lua` :

| Règle | Mesure |
|---|---|
| Héros ne parle jamais à voix haute | 19 pensées, **toutes** entre parenthèses ; 0 `say(hero,...)` |
| Aucune narration dans une scène jouée | **1 seule** narration, sur écran noir, pour clore |
| Emotes dosées | 4 emotes / 85 répliques = **0,05 par ligne** |
| Répliques < 150 caractères | 83/83 conformes |
| Orientation relative | `allTurnTo` oriente chacun depuis sa position |
| Fondus justifiés | 2 fondus, aux 2 changements de configuration |

### B.5 Positionnement — point 3 de la grille

Toutes les coordonnées ont été relevées sur les grilles de collision réelles :

- 8 positions de foule sur `metano_town`, **libres et reliées** à la guilde par
  parcours en largeur ;
- trajet de fuite `metano_town_nuit` : 121 cases praticables ;
- `carrefour_nord` : traversée sud→nord validée, 55 cases ;
- `bourg_comptoir` : 18 PNJ vérifiés, 4 marqueurs libres ;
- collisions et `Layers` **inchangés** après chaque écriture (contrôle
  automatique dans `restore_eoso_entities.py`).

### B.6 Points restés en suspens — point 5 de la grille

1. **Lugia / Rayquaza** au ch10 : conflit non tranché, bloque le ch11.
2. **Carton-titre ch11** : dit « L'Autre Continent », le chapitre s'appelle
   « Ceux que l'on accuse ».
3. **Les 10 scènes du ch11 ne sont pas branchées** : elles existent, rien ne
   les appelle.
4. **`carrefour_nord`** : aucun marqueur, absent de `master_zone`.
5. **Croisée de Cristal** : réservée ch20 Meloetta *ou* donjon du tournoi ch8.
6. **Diancie / Cascade Cristal** : décision à prendre (§A.5).
7. **Quotas** : ch8 412, ch9 413, ch10 379, ch11 ~101 sur 7 000.

### B.7 Ce que je n'ai pas audité

Par honnêteté sur le périmètre :

- Les **252 grounds hors lot Explorers** (origine Rescue Team ou création).
- La **continuité visuelle** des raccords entre cartes voisines.
- Les **2 PNG fournis** (`Entrance - Celestial Peak.png`, `Entrance - Forêt
  Lugubre ch6.png`) : la grille demande une vérification visuelle des Grounds,
  je ne l'ai pas faite.
- Les **74 cinématiques préexistantes** sans mise en scène.
- L'**arc Météorite** en détail.
- Les points de vigilance historiques : corrections `cloven_ruins_entrance`
  effectivement appliquées ? trigger Absol ? texte « la Stepped » ?

### B.8 Réserve permanente

**Rien n'a été testé manette en main.** Tous les blocages annoncés — y compris
celui du ch11, qui est le plus grave — sont déduits de la lecture de fichiers.
C'est solide sur le fond, mais seul un lancement le confirmera.
