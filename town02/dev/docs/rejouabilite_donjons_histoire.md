# Rejouabilité des donjons d'histoire — build 2026-07-31-I

## Ce qui est demandé

> « les donjon histoire seront disponible a rejouer une fois vécu cinematique boss
> etc une fois comme dans les jeu donjon pmd officiel »
>
> À l'arène : « juste une cinematique ou on se rend compte ya juste personne et le
> donjon est finis avec le journal de victoire etc »
>
> À la sortie : **fin de journée** (dîner → nuit → lendemain).

Donc : un donjon d'histoire terminé reste jouable en entier — étages, relais,
profondeurs — mais la salle du gardien est **vide**. Une courte scène le
constate, l'écran de résultats s'affiche, l'équipe rentre dormir.

---

## Ce qui existait déjà (vérifié, pas supposé)

Quatre donjons avaient **déjà** ce comportement, chacun avec sa propre fonction
`GenericEnding()` :

| Donjon | Ground | Réplique |
|---|---|---|
| Forêt des Reliques | `relic_forest` | « Il ne semble y avoir rien d'intéressant ici. » |
| Lit de Rivière Lumineux | `luminous_spring` | idem |
| Caverne Tortueuse | `crooked_den` | idem |
| Forêt des Noigrumes | `apricorn_glade` | idem |

Le patron demandé existait donc déjà dans le mod. Le travail a consisté à
l'étendre aux **8 arènes qui en étaient dépourvues**, et à débloquer le chemin
qui y mène.

---

## Les trois bugs qui rendaient la rejouabilité impossible

### 1. Sept donjons n'étaient jamais rendus accessibles

`GAME:UnlockDungeon` n'était appelé que pour `relic_forest`,
`illuminant_riverbed`, `crooked_cavern`, `apricorn_grove` et `gloomy_forest`.

Les **sept autres** — Grande Steppe, Tunnel Ardent, Mont Venteux, Ruines
Tordues, Sanctuaire de Cristal, Marais de l'Oubli, Pic Céleste — n'étaient
`UnlockDungeon`és **nulle part dans le dépôt**. Ils figuraient pourtant déjà
dans la liste `dungeons` de `metano_town.East_Exit_Touch`, mais le filtre
`if GAME:DungeonUnlocked(...)` les écartait systématiquement. Ils étaient donc
**invisibles au comptoir de voyage**, même une fois terminés.

Correction : `ReplayEnding.SyncUnlocks()`, appelée à deux endroits —
à l'ouverture du menu de voyage, et dans `OnUpgrade` pour les sauvegardes
existantes. Idempotente (gardée par `DungeonUnlocked`) et sous `pcall`.

### 2. Quatre donjons étaient bloqués dès le premier segment

`cloven_ruins`, `crystal_sanctuary`, `forgotten_marsh` et `celestial_peak`
routaient leur sortie de segment 0 ainsi :

```lua
if result == ...Cleared and SV.ChapterProgression.Chapter == 7 then
    GAME:EnterGroundMap('cloven_ruins_midpoint', ...)
elseif result ~= ...Cleared then
    ...
end
-- aucun else : hors chapitre 7, victoire = rien ne se passe
```

Hors du chapitre concerné, **finir le segment ne déclenchait aucune
transition**. Le joueur restait bloqué à la fin des étages.

Correction : `SV.ChapterProgression.Chapter == N` remplacé par
`ReplayEnding.FollowsRoute(zone, N)`, vrai pendant le chapitre **et** une fois
le donjon terminé. La logique de chapitre elle-même n'est pas touchée.

### 3. Huit arènes de boss n'avaient pas de sortie hors chapitre

- `vast_steppe_guardian`, `mount_windswept_guardian`, `searing_crucible`,
  `gloomy_forest_boss`, `cloven_ruins_boss` : tombaient dans un
  `else GAME:FadeIn(20)` — carte sans issue, joueur bloqué.
- `crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_boss`,
  `autel_celeste`, `celestial_peak_fulgur` : leur `Enter()` n'avait **aucune
  condition**. Revenir sur place rejouait la cinématique **et relançait le
  combat contre un boss déjà vaincu**.

Correction : branche `ReplayEnding.IsReplay(...)` en tête de chaque `Enter()`,
qui joue la salle vide puis termine l'exploration.

---

## Le module `Data/Script/halcyon/ReplayEnding.lua`

### Détecter qu'un donjon est terminé

Table `ReplayEnding.CLEARED` : un drapeau **persistant** par donjon.

Piège évité : les drapeaux de routage (`SteppeGuardianDefeated`,
`DefeatedRuinsBoss`…) sont remis à `false` juste après la scène de victoire.
Ils ne peuvent donc pas servir de mémoire. Ce sont les drapeaux de fin de
chapitre qui font foi :

| Donjon | Drapeau retenu |
|---|---|
| relic_forest | `Chapter1.TeamCompletedForest` |
| illuminant_riverbed | `Chapter2.FinishedRiver` |
| crooked_cavern | `Chapter3.FinishedRootScene` |
| apricorn_grove | `Chapter4.FinishedGrove` |
| vast_steppe / searing_tunnel / mount_windswept | `Chapter5.FinishedExpedition` |
| gloomy_forest | `Chapter6.DefeatedGloomyBoss` |
| cloven_ruins | `Chapter7.SawAnimaCoreCorruption` |
| crystal_sanctuary | `Chapter8.CrystalSanctuaryComplete` |
| forgotten_marsh | `Chapter9.ForgottenMarshComplete` |
| celestial_peak | `Chapter10.CelestialPeakComplete` |

Les trois donjons de l'expédition partagent `FinishedExpedition` : l'expédition
se clôt au sommet du Mont Venteux, ce qui termine les trois d'un coup.

### Trois fonctions de décision

- `IsCleared(zone)` — le donjon a-t-il été bouclé ?
- `FollowsRoute(zone, ch)` — faut-il suivre le parcours complet ? Vrai pendant
  le chapitre, vrai à nouveau après. Remplace les gardes de chapitre.
- `IsReplay(zone, ch)` — sommes-nous en visite de rejouabilité ? Vrai dès que la
  conclusion du donjon a été vue (voir l'encadré ci-dessous).

### Pourquoi `IsReplay` ne regarde PAS le numéro de chapitre

Version initiale : « faux tant que `Chapter == N` ». **Faux et dangereux.**

Vérification dans le dépôt : `SV.ChapterProgression.Chapter` n'est jamais porté
à 7, 8, 9, 10 ni 11. Les seules affectations existantes sont `Chapter = 2..6`
(`guild_heros_room/init.lua`, `mount_windswept/init.lua`). **La progression de
chapitre s'arrête à 6.** C'est un état préexistant du dépôt, pas une régression
de ce lot — les chapitres 7-10 ont leur contenu écrit mais aucun déclencheur.

Conséquences si on se fiait au chapitre :

- **Forêt Lugubre** — ch6 est le dernier chapitre atteignable. Zarude vaincu,
  revenir sur la carte rejouait `FirstBossScene()` **et relançait le combat**
  contre un boss déjà battu.
- **Pic Céleste** — après la victoire sur Lugia, `Chapter` reste à 10 et seul
  `StoryCompleted` passe à `true`. Le donjon serait resté **définitivement
  injouable**.

`IsReplay` s'appuie donc uniquement sur le drapeau d'achèvement du donjon. Une
fois la conclusion vue, l'arène est vide — que le chapitre ait avancé ou non.
`FollowsRoute` reste inchangée (chapitre courant **ou** donjon terminé), ce qui
garantit que le déroulé de l'histoire n'est jamais raccourci.

Non-régression contrôlée par simulation sur 11 scénarios : à chaque étape de
l'histoire le donjon courant a bien `replay=false` / `route=true`, et les
4 donjons terminés ont `replay=true`.

### Deux fonctions de mise en scène

- `PlayEmptyScene(cfg)` — l'équipe entre, avance, balaie la salle du regard,
  constate. Ne décide pas de la suite.
- `EmptyArena(cfg)` — `PlayEmptyScene` **+** fin d'exploration.

Le corps de `PlayEmptyScene` est intégralement sous `pcall`. La sortie
(`EndDay`) est **en dehors** : si une position ou une piste audio pose problème,
la scène est écourtée mais le joueur n'est jamais coincé sur une carte sans
issue. Même précaution que sur les 7 `DefeatedBoss()`.

### Fin de journée

`EndDay()` pose `Dinnertime` / `Bedtime` / `MorningWakeup` / `MorningAddress`,
puis `EndDungeonRun(..., display=true, fanfare=true)` vers le réfectoire
(carte 6), ou le 2ᵉ étage (22) s'il reste une mission à rendre.

`display=true` est ce qui déclenche le **journal de fin d'exploration**.

---

## Textes ajoutés

4 clés par arène (`_R01` à `_R04`), en **EN dans `strings.resx`** et **FR dans
`strings.fr.resx`**. Structure constante : le partenaire remarque le vide, le
héros pense une ligne intérieure, le partenaire conclut, puis la narration
ferme sur « Il n'y a plus rien à trouver ici. Il est temps de rentrer. » —
reprise exacte de la formule de `crooked_den.GenericEnding()`.

| Arène | Préfixe | Ce qui a changé sur place |
|---|---|---|
| Gardien de la Steppe | `VSG_R01..R04` | l'herbe a repoussé, plus une empreinte |
| Gardien du Mont | `MWG_R01..R04` | le ciel est vide, il niche plus haut |
| Creuset Ardent | `SC5_R01..R04` | la lave a repris ses canaux, les Limagma somnolent |
| Sanctuaire des Titans | `CRB_R01..R04` | trois alcôves vides, veines dorées virées au gris |
| Cœur de la Forêt | `GF6B_R01..R04` | les racines se sont desserrées, la lumière passe |
| Chambre de Diancie | `CSB_R01..R04` | les gemmes ont cessé de chanter |
| Abysses du Marais | `FMB_R01..R04` | la vase s'est refermée, pas un remous |
| Autel des Cieux | `CPB_R01..R04` | l'autel est nu, il est reparti vers la mer |
| Corniche Fulgur | `CPF_R01..R04` | trois empreintes aux trois quarts effacées |

### Bug de traduction corrigé au passage

Cinq grounds n'avaient **que** `strings.resx` — rempli en **français**. Le
fichier anglais contenait donc du FR, et il n'existait aucun fichier FR :
`crystal_sanctuary_boss`, `forgotten_marsh_boss`, `celestial_peak_boss`,
`autel_celeste`, `celestial_peak_fulgur` (16 clés `CSB_/FMB_/CPB_/CPF_`).

Le FR a été déplacé vers `strings.fr.resx` et une vraie traduction EN écrite
dans `strings.resx`. Même classe de bug que les 244 + 16 clés inversées déjà
traitées.

---

## Cas particulier : le Pic Céleste

Le relais choisissait sa destination ainsi :

```lua
local nextSegment = 2
if SV.Chapter10.OutranEscouadeFulgur then nextSegment = 4 end
```

`OutranEscouadeFulgur` reste vrai **pour toujours**. En rejouabilité, le relais
aurait donc sauté directement au segment 4, rendant la **Mer de Nuages
(segment 2) injouable**.

Correction : un jalon `SV.Chapter10.ReplayPastFulgur`, propre au parcours en
cours, remis à `false` à chaque entrée dans le donjon (`celestial_peak.Init`)
et posé à `true` au passage de la corniche Fulgur. Déclaré dans `scriptvars.lua`
et rattrapé dans `OnUpgrade`.

La corniche Fulgur est le seul ground à utiliser `PlayEmptyScene` plutôt que
`EmptyArena` : ce n'est pas une fin de donjon, on enchaîne vers le relais.

## Cas particulier : la Forêt Lugubre

La sortie du segment 1 exigeait `SV.Chapter6.ChenipentFound` pour ouvrir le
cœur de la forêt. En rejouabilité, la mission de sauvetage est déjà accomplie
et la chenille ne réapparaît pas — la condition ne pouvait plus être remplie.
Elle accepte désormais aussi `ReplayEnding.IsCleared('gloomy_forest')`.

---

## Ce qui n'est PAS touché

- **Les revanches Grodoudou.** Zarude (`verdant_oath`, segment 3) et Regigigas
  (`colossus_quarry`, segment 3) restent le seul moyen de réaffronter ces deux
  boss. La rejouabilité n'y touche pas et ne les court-circuite pas :
  `zone/cloven_ruins/init.lua` intercepte le cas revanche **avant** d'atteindre
  le ground d'arène.
- **Les mini-boss ch5.** Ils sont hors du chemin en rejouabilité : le relais
  saute au segment 2 dès que `<X>MiniBossCleared` est vrai, ce qui est
  définitif. Aucune scène de salle vide n'est nécessaire.
- **La progression de chapitre.** `FollowsRoute` ajoute une condition, elle n'en
  retire aucune. Une partie en cours se comporte exactement comme avant.
- **Les 202 autres donjons** (Ancrages, Réseau des Anciens Chemins, Réseau du
  Ciel, secondaires) : ils étaient déjà rejouables, ils rentrent à Metano.

---

## Vérifications effectuées

- Lua : **635/635** fichiers OK
- `.resx` : **573/573** OK
- Zones JSON + `index.idx` : **209/209** OK, 0 zone manquante
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- Toutes les clés `_R0x` appelées existent en EN **et** en FR (contrôle croisé
  script ↔ resx)
- Simulation Lua du module sur 7 scénarios : histoire finie, déverrouillage +
  idempotence, chapitre 5 en cours, chapitre 6 après expédition, chapitre 7
  avant/après victoire, donjon non terminé, zone inconnue

## Audit après coup — 4 bugs trouvés dans ce lot et corrigés

1. **Équipiers téléportés hors carte.** Le module plaçait les alliés à +32 px
   en Y sous le duo. Contrôle croisé script ↔ dimensions réelles des
   `.rsground` : hors carte sur 3 arènes (Steppe `y=380 ≥ 368`, Ruines
   `y=272 ≥ 240`, Mont `y=176 ≥ 176`). Les scènes de boss d'origine décalent
   en fait de **+16 en Y et ±32 en X** (les alliés s'écartent sur les côtés).
   Module aligné sur ce patron.
2. **Aegis Cave : duo sur le bord bas.** La scène ch7 spawne à `y=240` sur
   une carte de 240 px — elle ne place aucun équipier, donc ça passait. En
   copiant ces coordonnées, les équipiers sortaient. Duo remonté à `y=200`.
3. **`IsReplay` inopérant** sur Forêt Lugubre et Pic Céleste (voir encadré).
4. **`Boss Battle!.ogg` sur une salle vide** — contresens musical sur 3 arènes.
   Remplacé par la piste calme du relais du même donjon (`Snow Camp`,
   `Cave Camp`, `Summit`), ce que fait déjà `RelayScenes` en visite libre.

Contrôles ajoutés : 0 clé `.resx` perdue lors de la réécriture des 5 fichiers
(diff de clés avant/après), 10/10 scènes avec spawns et cadrage dans les
bornes, 10/10 pistes musicales présentes dans `Content/Music/`.

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier :

- Les **coordonnées** sont désormais contrôlées par script (dans les bornes de
  la carte, parleurs dans le cadre 320×240), mais le rendu visuel n'a pas été
  observé : rien ne garantit que le duo ne se retrouve pas sur un décor plutôt
  qu'au centre de la salle.
- Les **pistes musicales** existent, mais leur justesse de ton n'a pas été
  jugée à l'écoute.
- Le parcours complet **entrée → relais → profondeurs → salle vide → journal →
  guilde** n'a jamais été joué de bout en bout.

---

## Dettes préexistantes repérées pendant l'audit (NON corrigées)

Hors périmètre de ce lot, signalées pour mémoire :

- **`metano_town/strings.fr.resx` : 655 clés référencées absentes**, dont les
  150 clés `MT10_*` (chapitre 10) qui n'existent qu'en anglais. Un joueur FR
  verrait du texte non traduit sur ces dialogues.
- **`post_office` : 37 clés `Connect_*`** référencées et absentes des deux
  fichiers. Probablement fournies par le moteur, à confirmer.
- **`metano_town` : `Item_Give_Storage`** absente des deux fichiers.
- ~~**La progression de chapitre s'arrête à 6.**~~ **CORRIGÉ** dans le build
  2026-07-31-J : paliers ch6→ch7→ch8→ch9→ch10 ajoutés, donjons déverrouillés,
  délais armés, 4 zones passées à `Released=true`. Voir
  `docs/deblocage_chapitres_7_a_10.md`. Les 12 donjons d'histoire sont
  désormais atteignables, donc leur rejouabilité est testable.
