# Déblocage des chapitres 7 à 10 — build 2026-07-31-J

## Le problème

**La progression de chapitre s'arrêtait au chapitre 6.**

Constat mesuré : dans tout le dépôt, les seules affectations de
`SV.ChapterProgression.Chapter` sont `= 1` à `= 6`. Aucun `Chapter = 7`, `8`,
`9`, `10` ni `11` n'existe nulle part.

Conséquence : une fois la mission de la Forêt Lugubre terminée, le joueur
restait **bloqué indéfiniment**. Les chapitres 7 à 10 étaient injouables.

Ce n'était pas un manque de contenu. Tout était déjà là :

| Chapitre | Donjon | Contenu existant, non atteignable |
|---|---|---|
| 7 | Aegis Cave | carton-titre, adresse du matin, rêve, dialogues de ville, énigme des Zarbi, éveil des trois golems, boss Regigigas |
| 8 | Sanctuaire de Cristal | dialogues de ville, relais, arène Diancie |
| 9 | Marais de l'Oubli | dialogues de ville, relais, arène Laggron, Cercle du Suaire |
| 10 | Pic Céleste | dialogues de ville, relais, Escouade Fulgur, Autel des Cieux, boss Lugia |

Il manquait exactement **trois choses** : le déclencheur de chapitre, le
`UnlockDungeon` du donjon, et l'armement du délai `DaysToReach`.

---

## Ce qui a été fait

### 1. Le palier ch6 → ch7

Ajouté dans `guild_heros_room.CheckTriggerEvent()`, sur le patron exact des
paliers ch4→ch5 et ch5→ch6 déjà en place :

```lua
if SV.ChapterProgression.Chapter == 6 and SV.Chapter6.PostMissionScenePlayed
   and SV.ChapterProgression.DaysPassed >= SV.ChapterProgression.DaysToReach then
    SV.ChapterProgression.Chapter = 7
    SV.ChapterProgression.CurrentStoryDungeon = "cloven_ruins"
    GAME:UnlockDungeon("cloven_ruins")
    ...
```

`cloven_ruins` n'était `UnlockDungeon`é **nulle part** dans le dépôt : même en
forçant `Chapter = 7`, le donjon serait resté invisible au comptoir de voyage.

### 2. Les paliers ch7 → ch8 → ch9 → ch10

Écrits sous forme de table plutôt qu'en trois blocs recopiés, la logique étant
strictement identique :

```lua
local chapter_gates = {
  [7] = { function() return SV.Chapter7.HadFirstDream end,            8,  "crystal_sanctuary", {...} },
  [8] = { function() return SV.Chapter8.CrystalSanctuaryComplete end, 9,  "forgotten_marsh",   {...} },
  [9] = { function() return SV.Chapter9.ForgottenMarshComplete end,   10, "celestial_peak",    {...} },
}
```

Chaque palier attend le **drapeau de conclusion** du chapitre précédent — le
même que celui utilisé par `ReplayEnding.CLEARED`, ce qui garantit la
cohérence entre progression et rejouabilité.

### 3. Armement du délai `DaysToReach`

Les paliers existants imposent quelques jours de missions libres entre deux
chapitres (`+3` après la Forêt des Noigrumes, `+2` après l'expédition). Ce
délai n'était armé nulle part après le ch6.

- `metano_town_ch_6.lua` : `+2 jours` posé avec `PostMissionScenePlayed`.
- `guild_heros_room_ch_7.lua` : `+2 jours` posé avec `HadFirstDream`.
- Paliers ch8-10 : `+2 jours` posé automatiquement à chaque franchissement.

Sans cela, `DaysToReach` gardait la valeur du palier précédent — déjà dépassée
— et les chapitres se seraient enchaînés **d'un seul coup, la même nuit**.

### 4. `Released = false` sur les 4 zones ch7-10

Question posée en session précédente, restée sans réponse. **Tranchée par la
preuve** plutôt que par supposition.

Les 7 zones à `Released=false` du dépôt se répartissent en deux groupes nets :

| Zone | Segments | Grounds | Verdict |
|---|---|---|---|
| `imbion_coven_cave` | 0 | 0 | coquille vide, placeholder |
| `imbion_haunted_bazar` | 0 | 0 | coquille vide, placeholder |
| `imbion_sentient_workshop` | 0 | 0 | coquille vide, placeholder |
| `cloven_ruins` | 5 | 3 | **donjon complet** |
| `crystal_sanctuary` | 5 | 3 | **donjon complet** |
| `forgotten_marsh` | 5 | 3 | **donjon complet** |
| `celestial_peak` | 7 | 5 | **donjon complet** |

Les 8 autres donjons d'histoire sont tous `Released=true`. Le `false` sur ces
quatre-là est un reste de développement, pas une intention.

Passés à `true`, dans le `.json` **et** dans le résumé `index.idx` (le moteur
valide contre le résumé). Patch chirurgical par regex ciblée : **diff de 8
lignes, uniquement `false` → `true`**, formatage et BOM UTF-8 préservés. Les
trois `imbion` restent intacts.

### 5. Rattrapage des sauvegardes déjà bloquées

Une partie ayant **déjà** vu la scène de retour du chapitre 6 resterait coincée
malgré cette mise à jour : `DaysToReach` n'y a jamais été armé pour le palier
suivant. `OnUpgrade` le pose rétroactivement, une seule fois, uniquement si on
est au ch6 avec la mission bouclée.

---

## Ce que le joueur verra

Chapitre 7 : chaîne complète et soignée — carton-titre au réveil, adresse du
matin de Phileas au 3ᵉ étage, expédition aux Aegis Cave, énigme des Zarbi,
éveil des trois golems, Regigigas, puis le récit de la Genèse et le premier
rêve.

Chapitres 8, 9 et 10 : **plus sobres**. Ils ont leurs dialogues de ville, leur
donjon complet avec relais et arène, mais **pas de carton-titre ni d'adresse du
matin dédiés** (il n'existe ni `guild_heros_room_ch_8` ni
`guild_third_floor_lobby_ch_8`). Le réveil générique s'applique et la
découverte passe par la ville et le donjon.

C'est un manque connu, pas un bug : ces scènes d'encadrement n'ont jamais été
écrites. Elles restent à produire si l'on veut aligner ces trois chapitres sur
la densité du chapitre 7.

---

## Vérifications

- Lua **635/635**, `.resx` **573/573**, zones + index **209/209**
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- BOM UTF-8 préservé sur les 4 zones et sur `index.idx`
- Diff `Data/Zone/` : **8 lignes**, exclusivement `Released` `false` → `true`
- Simulation de la chaîne ch6 → ch10 : franchissement correct, blocage correct
  quand la conclusion manque, blocage correct quand le délai n'est pas écoulé,
  8 donjons ouverts au voyage à l'arrivée
- Simulation croisée progression ↔ rejouabilité sur 6 cas : **aucun conflit**
  (le donjon du chapitre courant reste en mode histoire, les précédents passent
  en salle vide)
- `water_maze` retiré des secondaires du ch7 après contrôle : déjà ouvert au
  chapitre 2

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier, la simulation reproduit la
logique des paliers mais ne prouve pas que les scènes du chapitre 7
s'enchaînent correctement en conditions réelles, ni que les grounds ch8-10 se
chargent sans incident.

Point de vigilance : `PromptChapterSaveAndQuit` renvoie vers la carte 2
(`guild_heros_room`) à chaque franchissement de palier, comportement repris des
paliers existants sans modification.
