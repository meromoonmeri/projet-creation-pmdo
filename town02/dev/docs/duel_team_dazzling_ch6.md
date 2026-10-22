# L'Épreuve des Trois — duel de la Team Dazzling + après-boss du chapitre 6

Build : `2026-07-31-U`

## Pourquoi ce lot

Deux trous **mesurés**, pas ressentis.

### 1. Zarude n'avait aucun après-boss

`zone/gloomy_forest/init.lua`, segment 2, victoire : on posait quatre drapeaux
et on rentrait en ville. Les chapitres 8, 9 et 10 ont reçu leur scène de
conséquence dans le lot `ChapterAftermath` ; le 6 n'a jamais rien eu. Le boss
le plus « personnage » du jeu — un gardien qui défend sa forêt — mourait sans
un mot.

### 2. La Team Dazzling se moquait sans jamais combattre

Vérifié dans `metano_town_ch_6.lua` :

| fonction | ce qu'elles font |
|---|---|
| `DazzlingIntroduction` (l.86) | elles paradent |
| `PostDefeatCutscene` (l.855) | elles narguent après l'échec contre Zarude |
| `PostMissionCutscene` (l.383) | elles félicitent du bout des lèvres |

Trois scènes de parole, **zéro confrontation**. Un rival qui n'affronte jamais
le héros n'est pas un rival, c'est un décor bavard.

## Ce qui a été fait

### `Data/Script/halcyon/DazzlingArc.lua` (nouveau, 77 répliques)

Module **global** → texte littéral, jamais `STRINGS.MapStrings` (patron
`SuaireArc.lua` / `ChapterAftermath.lua`).

| fonction | registre | fonction dramatique |
|---|---|---|
| `GloomyVictory` | honte | Zarude ne se rend pas, il **réalise**. Il croyait protéger la forêt en la fermant ; il l'étouffait. Personne ne triomphe. |
| `TrialIntro` | sport | Adagio demande un combat **sans enjeu** — et choisit exprès le pire moment. |
| `TrialVictory` | reconnaissance | Adagio arrête de dire « les petits » et emploie le nom de l'équipe. C'est le vrai prix du duel. |
| `TrialDefeat` | correction | Elle **soigne** le duo et ne racontera rien en ville. Le contraste avec ses moqueries urbaines est le portrait du personnage. |

Points d'écriture :

- Le partenaire **paie sa réplique d'avant-combat**. Il hurlait « on n'abandonne
  personne » avant Zarude ; c'est lui qui tend la main à Zarude après.
- Première fois que le duo comprend qu'un adversaire peut avoir **raison sur le
  fond et tort sur la méthode**.
- **La Voix ne parle pas de tout le chapitre.** C'est voulu : son silence
  pendant un combat sans enjeu est une information pour le joueur attentif.
- Le mot « prison » n'apparaît pas. Le mot « paroi » non plus : on n'anticipe
  pas l'arc 9.

### Techniques reprises des sources

- **pmd-red `intro.inc`** — fils parallèles synchronisés par drapeaux
  (`setFlag`/`waitFlag`). Les trois rivales n'entrent jamais en file indienne :
  trois `BranchCoroutine` décalés de 8/16/22 frames, un `JoinCoroutines`.
- **pmd-red** — cascade d'animations sur un acteur (`setAnimation 0xE, 0xF…`).
  Zarude passe `Hurt` → secousse → `Idle` avec des temps morts. Les trois
  rivales s'arrêtent en décalé (10/18 frames), jamais ensemble.
- **EoSO `beach/init.lua`** — on établit le lieu avant les personnages :
  60 frames de clairière vide avant que quiconque parle.
- **EoSO `storm_cutscene_a`** — bascule de fin en coroutines calées : la
  dernière phrase s'efface exactement avec l'image.

### Arène et zone

- `Data/Map/serment_dazzling_arene.rsmap` — clone **1:1** de
  `gloomy_forest_boss.rsmap` (15×18, même géométrie), seul le casting change :
  Adagio 26 / Aria 25 / Sonata 25, `Unrecruitable = true` (ce sont des
  personnages d'histoire). Capacités, talents et objets tous **attestés
  ailleurs dans le dépôt** (vérifié par grep sur `Data/Zone` et `Data/Map`).
- `Data/Zone/gloomy_forest.json` — segment **5**, `IsRelevant = false`
  (+54 lignes, formatage et BOM préservés).
- `Data/Zone/index.idx` — resynchronisé (+3 lignes).
- Aucun légendaire, aucun fabuleux.

### Chaînage

```
segment 2 vaincu  → DazzlingArc.GloomyVictory()  + DazzlingTrialOffered = true
relais (61)       → les trois campent à l'est du foyer ; parler à Adagio
gloomy_forest_boss→ DazzlingArc.TrialIntro() → ContinueDungeon(segment 5)
segment 5 fini    → TrialVictory / TrialDefeat → retour relais, journée figée
```

Le duel est **entièrement facultatif** : refusable, ignorable, et il ne fait
avancer aucun drapeau d'histoire. Victoire comme défaite, la journée n'avance
pas — c'est un match, pas une expédition.

## Bugs préexistants corrigés au passage

1. **`GloomyPlayedMidpointIntro` et `GloomyMidpointState` n'étaient déclarés
   nulle part** dans `scriptvars.lua`. Ils étaient lus par
   `ground/gloomy_forest_midpoint` et écrits par `zone/gloomy_forest`, mais
   seul le rattrapage `OnUpgrade` de `debug_tools` les créait — donc une partie
   **neuve** arrivait au relais avec `nil`.
2. **`tools/count_dialogue.py` sous-comptait.** Il ignorait les modules globaux
   et ne voyait que les appels bruts au moteur, pas les helpers
   `say`/`think`/`narrate`/`voice` qui les enveloppent. `DazzlingArc` affichait
   3 lignes au lieu de 77, et **51 répliques de `ChapterAftermath` (ch8-10)
   n'étaient comptées nulle part**. Corrigé.

## Densité

| ch | avant ce lot | après |
|---|---|---|
| 6 | **199** (dont 74 jamais comptées) | **283** |

## Validation

- Lua **643/643** · `.resx` **576/576** · zones + index **208/208**
- `verify_legend.py` → TOUT EST VÉRIFIÉ
- `verify_bg_format.py` → AUCUN BUG DE FORMAT
- `verify_scene_positions.py` → aucune entité hors carte
- `validate_all.py` → toutes les salles valides
- **Positions vérifiées une à une** sur les `obstacles` des `.rsground` :
  3 ancrages de mon premier jet tombaient dans la roche
  (`gloomy_forest_boss` : le nord y<230 est plein) et 2 au relais
  (`x=452` est dans la paroi). Corrigés — et l'arrivée **par le sud** est
  meilleure narrativement : elles ont suivi le duo depuis l'entrée.

## Non testé

**Rien n'est testé en jeu.** Validation statique uniquement. Non vérifiable par
script : le rendu du décor derrière les sprites aux positions choisies, et le
fait que `Team_Dazzling.ogg` couvre bien la durée des trois scènes.
