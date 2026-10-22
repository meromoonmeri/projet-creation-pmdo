# COUCHE D'ADAPTATION NEW ERA — ARC DU FUTUR

## Modèle 4 couches (aucune fusion, aucune donnée Sky modifiée)

```
1. SSB Sky original (bytecode)   pret/pmd-sky — intouché
   ↓
2. IR canonique JSON             docs/ssb_ir/<ZONE>_<scene>.json (validation 100%)
   ↓
3. ADAPTATION NEW ERA            docs/ssb_adaptation/ (cast, tables, dialogues) — CE DOSSIER
   ↓
4. Lua PMDO (RogueEssence)       généré par le convertisseur, jouable dans le mod
```

## Directives utilisateur (verbatim, encodées dans cast.json)

- **dusknoir_grovyle_allies** : dusknoir & groovyle dans new era font équipe ils viennent d'un futur
- **dialga_gentil** : dialga dans new era est gentil il est plus corrompu (ABSENT de l'arc du futur)
- **decalage_30_ans** : tout les evenement de new era se passe 30 ans plus tard
- **necrozma_lumiere** : necrozma dans le futur a absorbé toute la lumiere du monde, la vie en somme le monde deviens progressivement neant
- **eternatus_realite** : eternatus lui a altérée la réalitée et cela devenu une sorte d'infini
- **climax_ch32** : ces deux boss final (Necrozma + Eternatus) sont le climax du jeu au chapitre 32
- **p05p01a_repaire_necrozma** : P05P01A = repaire de Necrozma (deux yeux rouges dans l'obscurité)
- **p05p03a_poteau_execution** : p05p03a = poteau d'exécution où héros/partenaire/Grovyle sont ligotés (anims/positions 1:1)

## Cast global

| Entité Sky | Acteur New Era | Rôle |
|---|---|---|
| `NPC_YONOWAARU` | NewEra.Dusknoir | ALLIÉ venu du futur (fait équipe avec Grovyle). Jamais antagoniste. |
| `NPC_YONOWAARU_N8` | NewEra.Dusknoir | ALLIÉ venu du futur (variante d'instanciation N8). |
| `NPC_JUPUTORU` | NewEra.Grovyle | ALLIÉ venu du futur (fait équipe avec Dusknoir). |
| `NPC_YAMIRAMI` | NewEra.Sableye_1 | Sbire de Necrozma (garde du futur plongé dans le néant). |
| `NPC_YAMIRAMI2` | NewEra.Sableye_2 | Sbire de Necrozma. |
| `NPC_YAMIRAMI3` | NewEra.Sableye_3 | Sbire de Necrozma. |
| `NPC_YAMIRAMI4` | NewEra.Sableye_4 | Sbire de Necrozma. |
| `NPC_YAMIRAMI5` | NewEra.Sableye_5 | Sbire de Necrozma. |
| `NPC_YAMIRAMI6` | NewEra.Sableye_6 | Sbire de Necrozma. |
| `NPC_SEREBII` | NewEra.Celebi | Gardienne du Passage du Temps / alliée (guide). |
| `PLAYER` | NewEra.Hero | Héros (présent). |
| `ATTENDANT1` | NewEra.Partner | Partenaire (ligoté aux pieux en p05p03a, animation 78 conservée). |
| `PLAYER_FUTURE` | NewEra.HeroFuture | Héros du futur (30 ans plus tard — le même, dans le monde devenu néant). |
| `__MAITRE__` | NewEra.Necrozma | LE MAÎTRE aux yeux rouges dans l'obscurité (P05P01A). A absorbé toute la lumière du futur. |

## Règle « antagoniste / maître de l'original → Necrozma »

Dans Sky le méchant est **Dusknoir** et le maître **Dialga**. Dans New Era :
Dusknoir est **allié**, le maître du futur est **Necrozma** (yeux rouges, P05P01A),
**Dialga est absent** (gentil, non corrompu). **Aucune réécriture narrative** :
la chorégraphie 1:1 est conservée, seul l'acteur change.

- Scènes où YONOWAARU est l'**antagoniste** (geôlier du poteau, confrontation,
  confession, menaces) : l'acteur devient **Necrozma**.
  P05P03A_m17a0302, P05P03A_m26a06d3, P09P01A_m19b1001, P09P01A_m19b1007, P09P01A_m19b1009, P09P01A_m19d1072.
- Scènes où YONOWAARU n'est pas l'antagoniste (rapporte au maître, guide le
  héros du futur) : il reste **Dusknoir**.
- Substitutions dans les dialogues canoniques : 'Dialga' -> 'Necrozma',
  `Primal Dialga` → `Necrozma`, `Dusknoir` → `Necrozma` (scènes antagoniste).

## Tables d'adaptation

- **tables.json** : BGM (Sky -> .ogg New Era), grounds (Sky -> ground importé),
  faces (Sky -> émotion portrait PMDO), variables (Sky -> SV New Era),
  routines communes (Sky -> helpers Lua).
- **vocabulaire.json** : ids d'animations / SE / effets OBSERVÉS dans les 24 scènes,
  avec leur fréquence. **Statut : TABLES REQUISES** (à établir depuis la ROM,
  jamais inventées). Les ids 640/645/651 (SetEffect) sont NON CONVERTIS.

## Pipeline de conversion (prochaine étape)

```
IR canonique  →  résolution des contextes (lives/performer/object)  →
résolution des acteurs (cast.json) → résolution des tables →
génération Lua (coroutine + GAME/GROUND/UI/SOUND) → compilation → runtime
```