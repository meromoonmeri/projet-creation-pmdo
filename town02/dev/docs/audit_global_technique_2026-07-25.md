# Audit global technique — New Era : Abyss to Ascension

Date : 25 juillet 2026
Dépôt audité : `new-era-abyss-to-ascension-V2`

## Résumé exécutif

Le projet est chargé sur le plan statique, mais il ne doit pas encore être considéré comme totalement terminé en jeu.

### Validation statique

- 178 fichiers Lua analysés ; **0 erreur de syntaxe** ;
- tous les JSON analysés ; **0 erreur JSON** ;
- tous les XML/RESX analysés ; **0 erreur XML** ;
- aucun doublon de clé RESX détecté ;
- 43 cartes `Data/Ground` présentes ;
- fond du menu `.dir` valide : PNG interne 320×240, 0 direction, 1 frame ;
- image titre `Content/UI/Title.png` valide en 320×240.

### Conclusion générale

Le mod possède une base jouable et les transitions principales existent. Les points qui empêchent une validation finale sont :

1. absence de test complet dans PMDO ;
2. cinématique du Mont Venteux déclarée mais non déclenchée ;
3. mini-boss/gardiens du chapitre 5 désormais branchés statiquement, mais non testés en jeu ;
4. traductions automatiques récentes à relire en jeu et quelques textes visibles encore suspects ;
5. descriptions d'objets encore manquantes en français.

---

## Mise à jour — rencontres fixes du chapitre 5

Les cinq rencontres prévues sont maintenant reliées aux étages concernés par `ScriptGenStep` :

- Grande Steppe : mini-boss à l’étage 7, gardien à l’étage 14 ;
- Tunnel Incandescent : mini-boss à l’étage 5 ;
- Mont Venteux : mini-boss à l’étage 7, gardien au sommet ;
- Tunnel : 15 étages normaux + arène conservés.

Le branchement a été contrôlé par parsing JSON et par correspondance entre les noms `ScriptGenStep` et les fonctions `ZONE_GEN_SCRIPT`. Cela ne remplace pas un test PMDO réel.

## P0 — À vérifier avant toute release

### P0.1 Test réel de toutes les sorties de donjon

La validation Lua ne vérifie pas la transition réelle. Il faut parcourir PMDO et vérifier chaque résultat :

- `Downed` / K.O. ;
- `Failed` ;
- `Escaped` ;
- `Cleared` ;
- `Rescue` ;
- `TimedOut` ;
- `GaveUp`.

Le test doit être fait dans :

- Grande Steppe ;
- Tunnel Incandescent segment 0 ;
- Tunnel Incandescent segment 1 ;
- Crucible ;
- Mont Venteux.

À contrôler en particulier :

- écran noir après le journal d'échec ;
- sons d'attaque qui continuent après la défaite ;
- retour au bon camp ;
- sauvegarde et reprise après redémarrage ;
- non-répétition des scènes déjà jouées.

### P0.2 Test du nouveau titre

Le fond PMDO a été reconstruit avec le format `DirSheet` attendu par l'engine :

```text
Content/BG/Title_Screen_Background.dir
PNG interne : 320×240
TileWidth : 320
TileHeight : 240
Dirs : 0
Frames : 1
```

L'erreur `EndOfStreamException` rencontrée précédemment correspondait à l'ancien fichier sans `TileWidth` et `TileHeight`. Le commit correctif est `500b515`.

À tester dans l'installation locale, car l'audit statique ne peut pas ouvrir une fenêtre PMDO :

- écran titre avec le logo ;
- affichage de `PRESS ENTER` ;
- disparition du logo après Entrée ;
- menu New Game/Continue/Options au-dessus du fond ;
- absence d'erreur dans `logs`.

---

## P1 — Chapitre 5

### P1.1 Mont Venteux : cinématique non déclenchée

Le fichier suivant contient une scène :

```text
Data/Script/halcyon/ground/mount_windswept_entrance/mount_windswept_entrance_ch_5.lua
```

Fonction présente :

```lua
mount_windswept_entrance_ch_5.ArrivalCutscene()
```

Mais `mount_windswept_entrance/init.lua` contient actuellement seulement :

```lua
function mount_windswept_entrance.PlotScripting()
  GAME:FadeIn(20)
end
```

La fonction `ArrivalCutscene()` n'est donc pas appelée automatiquement. Le Mont peut arriver sur une entrée sans jouer la scène prévue.

**Correction recommandée :** terminer d'abord la scène — sortie du mode cinématique, nettoyage des personnages temporaires et retour au contrôle — puis l'appeler une seule fois avec `SV.Chapter5.FinishedMountWindsweptIntro` comme garde.

Ne pas simplement appeler la fonction telle quelle : son contenu actuel est incomplet et peut laisser `GAME:CutsceneMode(true)` actif.

### P1.2 Mini-boss et gardiens

Les documents de conception prévoient :

- Grande Steppe : mini-boss à l'étage 7 et gardien à l'étage 14 ;
- Tunnel : mini-boss à l'étage 5 et boss au Crucible ;
- Mont Venteux : mini-boss à l'étage 7 et gardien au sommet.

L'audit des scripts n'a pas trouvé de séquence équivalente au système de boss du chapitre 3 pour la Steppe ou le Mont Venteux. La présence de `BossRoom` dans un JSON ne suffit pas : `BossRoom` sélectionne une salle de génération, mais ne crée pas à lui seul une rencontre scénarisée.

Il faut donc vérifier en jeu :

- présence réelle des ennemis ;
- déclenchement de la scène avant combat ;
- victoire et conclusion ;
- retour après défaite ;
- absence de révélation de Necrozma/Eternatus.

### P1.3 Tunnel Incandescent : nombre d'étages

Le plan indique :

```text
10 étages + arène
2 × 5 + Crucible
```

Le JSON actuel indique techniquement :

```text
segment 0 : 10 étages, plages 0–4 et 5–9
segment 1 : 5 étages de profondeurs
segment 2 : 1 arène Crucible
```

La version actuelle est donc **15 étages normaux + l'arène**. Cette décision est maintenant considérée comme voulue par la demande, mais le rapport de conception doit être mis à jour pour ne plus annoncer 10 étages.

### P1.4 Crucible

Le Crucible possède bien :

- `FirstPreBossScene()` ;
- `SecondPreBossScene()` ;
- `DefeatedBoss()` ;
- `GAME:ContinueDungeon("searing_tunnel", 2, 0, 0, ...)` ;
- sortie de zone du boss ;
- retour au point médian après défaite.

À valider en jeu :

- le boss est réellement présent après la transition ;
- la scène ne se répète pas ;
- la lave ne bloque pas définitivement la carte ;
- la victoire passe bien par `DefeatedBoss()` ;
- la défaite revient au point médian avec les bons flags.

---

## P1 — Bugs de scripting repérés

### P1.5 Signature Rescue incohérente

`COMMON.EndRescue` est déclaré ainsi :

```lua
function COMMON.EndRescue(zone, result, rescue, segmentID)
```

Mais `COMMON.ExitDungeonMissionCheck` l'appelle ainsi :

```lua
COMMON.EndRescue(zone, result, segmentID)
```

Le troisième argument reçu par `EndRescue` devient alors `rescue = segmentID`, et `segmentID` devient `nil`.

La fonction ne semble pas toujours utilisée dans le parcours courant, mais cela doit être corrigé avant de considérer les secours comme sûrs :

```lua
COMMON.EndRescue(zone, result, rescue, segmentID)
```

### P1.6 Signature `Rescued` d'Illuminant Riverbed

La zone contient :

```lua
function illuminant_riverbed.Rescued(zone, mail)
  COMMON.Rescued(zone, mail)
end
```

Les autres zones utilisent généralement :

```lua
function zone.Rescued(zone, name, mail)
```

`COMMON.Rescued` attend `zone, name, mail`. La signature d'Illuminant Riverbed doit être alignée avec les autres zones pour éviter une erreur lors d'un vrai secours.

### P1.7 `master_zone.Rescued`

Même contrôle à faire sur `master_zone/init.lua`, qui utilise également une signature abrégée. Le callback de secours doit être homogène dans toutes les zones.

---

## P2 — Traduction

### P2.1 État des ressources

Les noms français des zones, rangs, statuts et skins sont présents dans l'audit actuel.

Il reste toutefois :

- 38 clés globales `BEGINNER_LESSON_*` sans valeur française utile ;
- plusieurs clés de test ou de debug sans valeur ;
- 58 descriptions d'objets sans `LocalTexts.fr` ;
- des textes visibles codés directement dans Lua ;
- des textes générés dynamiquement à vérifier en contexte.

### P2.2 Qualité des traductions Lua

La passe globale a traduit un grand nombre de littéraux, mais une traduction automatique peut produire :

- espaces manquants autour de `[pause=0]` ;
- accords variables selon le Pokémon ;
- phrases dynamiques maladroites ;
- noms techniques qui ne doivent pas être traduits ;
- chaînes de debug qui ressemblent à du texte joueur.

Il faut donc relire les fichiers prioritaires en jeu, surtout :

- `PartnerEssentials.lua` ;
- `guild_bottom_right_bedroom/init.lua` ;
- `guild_second_floor/init.lua` ;
- `metano_town/init.lua` ;
- `post_office/init.lua` ;
- `event_single.lua` ;
- `event_battle.lua`.

### P2.3 Texte dans les ressources plutôt que Lua

Les textes narratifs devraient être placés dans les `.resx` et appelés par `STRINGS:Format`/`STRINGS:FormatKey`. Les textes encore en dur dans Lua rendent :

- la relecture difficile ;
- la gestion des placeholders fragile ;
- les corrections linguistiques plus risquées ;
- les futures langues difficiles à ajouter.

---

## P2 — Données et contenu

### P2.4 Descriptions d'objets

Les noms sont largement couverts, mais 58 descriptions d'objets n'ont pas encore de version française. Cela touche surtout :

- projectiles ;
- baies ;
- boîtes ;
- boissons du café ;
- objets tenus ;
- objets de mission ;
- orbes et graines.

### P2.5 Données de départ

`Data/StartParams.xml` contient encore de nombreux noms d'équipes de départ en anglais. Il faut décider si ces noms de référence doivent rester les noms officiels des équipes ou être localisés dans le menu français.

### P2.6 Version du mod

`Mod.xml` indique encore :

```xml
<Version>0.5.0</Version>
```

Après les corrections du titre, du chapitre 5 et de la traduction, une version `0.5.1` ou `0.6.0` serait plus claire pour les joueurs et les rapports de bug.

---

## P3 — Qualité et maintenance

### P3.1 Fichiers de test

Les scripts suivants contiennent du contenu de test qui peut donner l'impression que le jeu n'est pas traduit :

- `ground/test_grounds/init.lua` ;
- `ground/testmap/init.lua` ;
- messages de test dans plusieurs `.resx` ;
- options de debug de `mission_gen.lua`.

Il faut soit les traduire, soit les isoler clairement comme contenu développeur non accessible dans le parcours normal.

### P3.2 Contrôle des transitions

Chaque callback `ExitSegment` doit avoir un chemin explicite pour :

- défaite ;
- fuite ;
- victoire ;
- secours si autorisé.

Les branches vides ou les fonctions qui appellent `EndDungeonRun` sans transition doivent être interdites par un contrôle automatique.

### P3.3 Contrôle des références

Ajouter un script de CI qui vérifie :

- chaque zone publiée possède son script ;
- chaque `GroundMap` déclaré existe ;
- chaque `require` pointe vers un fichier réel ;
- chaque clé `MapStrings` existe en anglais et en français ;
- chaque placeholder `{0}` est conservé entre anglais et français ;
- chaque asset `.dir` peut être lu avec le bon format ;
- chaque Lua passe `load()`.

---

## Ordre de correction recommandé

1. Tester le nouveau titre PMDO et vérifier le log `Title_Screen_Background.dir`.
2. Corriger les callbacks de secours.
3. Finaliser et déclencher la cinématique du Mont Venteux.
4. Vérifier en jeu les mini-boss/gardiens des étages prévus.
5. Valider le Crucible et la sortie de boss.
6. Traduire les 58 descriptions d'objets restantes.
7. Revoir manuellement `PartnerEssentials`, l'almanach et les menus.
8. Mettre à jour le plan du Tunnel à 15 étages.
9. Bumper la version de `Mod.xml`.
10. Faire un parcours PMDO complet et archiver les logs.

## Conclusion

Le projet est dans un état statiquement propre, mais pas encore dans un état de release finale vérifié en jeu. Les risques les plus sérieux sont les callbacks de secours, la cinématique du Mont Venteux non déclenchée, les rencontres mini-boss/gardiens non confirmées et les 58 descriptions d'objets absentes en français.

## Mise à jour après correction — commit 99935aa

Les deux problèmes de scripting confirmés ont été corrigés :

- `COMMON.ExitDungeonMissionCheck` transmet maintenant les quatre arguments à `COMMON.EndRescue` ;
- les callbacks `Rescued` d'Illuminant Riverbed et de `master_zone` utilisent maintenant `(zone, name, mail)` ;
- `mount_windswept_entrance.PlotScripting()` déclenche désormais la cinématique du Mont Venteux au premier passage ;
- la cinématique du Mont Venteux termine proprement son mode cinématique, nettoie ses personnages temporaires, pose `FinishedMountWindsweptIntro` et relance la musique ;
- la version du mod passe à `0.5.1`.

Validation après ces corrections : 178 Lua, 0 erreur de syntaxe.

Les mini-boss/gardiens restent à valider ou à implémenter selon le contenu exact voulu dans les étages générés. Aucun test PMDO réel n'est simulé par cet audit.
