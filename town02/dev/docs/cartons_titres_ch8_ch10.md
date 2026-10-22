# Cartons-titres et veillées des chapitres 8 à 10 — build 2026-07-31-L

## Le manque

Après le déblocage des chapitres 7 à 10 (build `-J`), il restait un défaut
d'encadrement narratif signalé dans les rapports précédents :

| Chapitre | Carton-titre | Adresse du matin | Veillée de fin |
|---|---|---|---|
| 7 | ✅ | ✅ | ✅ (rêve) |
| 8 | ❌ | ❌ | ❌ |
| 9 | ❌ | ❌ | ❌ |
| 10 | ❌ | ❌ | ❌ |

Concrètement : on battait Diancie, et on se retrouvait au chapitre 9 **sans
aucune transition**. Pas d'annonce, pas de nuit, pas de respiration. Les
chapitres s'enchaînaient à sec.

---

## Ce qui a été ajouté

Trois fichiers, écrits sur le patron **exact** de `guild_heros_room_ch_7.lua` :

- `guild_heros_room_ch_8.lua` — carton-titre + veillée « Le Sanctuaire de Cristal »
- `guild_heros_room_ch_9.lua` — carton-titre + veillée « Le Marais de l'Oubli »
- `guild_heros_room_ch_10.lua` — carton-titre + veillée finale « Le Pic Céleste »

Chaque carton-titre reprend la structure d'origine : titre et fond lancés en
coroutines parallèles, 180 frames d'affichage, puis `Morning(true)`.

### Les veillées

Ce ne sont pas des scènes décoratives : chacune fait avancer le doute central
de l'arc 2.

**Chapitre 8** — le Fragment de Cristal mène à un sanctuaire où les premiers
gardiens ont *écrit ce qu'ils savaient*. Le héros bute sur une question simple :

> « Pourquoi écrire quelque chose si on ne veut pas qu'on le lise ?
> ...Ou alors c'était l'inverse. »

**Chapitre 9** — la phrase du Cercle du Suaire empêche le duo de dormir. Le
partenaire s'endort, le héros reste éveillé. Aucune voix, aucune vision : juste
la question qui tourne.

> « (...Et si soigner n'était pas la même chose que sauver ?) »

**Chapitre 10** — la Voix revient une dernière fois. Elle ne menace plus, et
c'est précisément ce qui glace :

> « Quatre Cœurs.[pause=25] Quatre murs de moins. »
> « Continuez.[pause=30] Je vous en prie.[pause=25] Continuez. »
>
> « (Elle ne me menaçait pas, cette fois. Elle me remerciait. C'est bien pire.) »

**Règles du projet respectées** : la Voix reste anonyme (speaker `\uE040`),
aucun nom interdit n'est prononcé, le mot « prison » est approché sans être
dit. Le twist des Cœurs-prison reste intact pour l'arc 6.

**23 clés** ajoutées, EN dans `strings.resx` et FR dans `strings.fr.resx`.

---

## Un bug trouvé en chemin

Les trois veillées n'auraient **jamais pu se déclencher**.

`crystal_sanctuary`, `forgotten_marsh` et `celestial_peak` renvoyaient le joueur
au **relais du donjon** (cartes 71, 73, 75) après la victoire finale, sans jamais
poser `SV.TemporaryFlags.Bedtime`. Or `PlotScripting` de `guild_heros_room` ne
joue une scène de chambre que si `Bedtime` ou `MorningWakeup` est armé — et
encore faut-il être *dans* la chambre.

Correction sur les trois zones : pose des quatre drapeaux de fin de journée
(`Dinnertime`, `Bedtime`, `MorningWakeup`, `MorningAddress`) et sortie vers la
**carte 2** (`guild_heros_room`) au lieu du relais.

C'est le même patron que la fin du chapitre 4 (`apricorn_grove`) et du
chapitre 5 (`mount_windswept`).

---

## Incident de sandbox

Le dépôt local a été **recloné en cours de tour** : l'historique est retombé sur
`45c445a` et les 4 commits de session ont disparu du local. `verify_legend`
signalait alors 2 échecs sur `colossus_quarry` — faux positifs dus au reclonage,
pas à une régression.

Résolu par `git fetch` + `git reset --hard FETCH_HEAD` sur `d762869`, après
sauvegarde des 3 fichiers neufs dans `/tmp`. Les modifications perdues
(clés `.resx`, `init.lua`, `scriptvars.lua`, les 3 zones) ont été réappliquées.

`verify_legend` est repassé au vert immédiatement après restauration, ce qui
confirme que les 2 échecs venaient bien du reclonage.

---

## Vérifications

- Lua **638/638** (+3 nouveaux fichiers), `.resx` **576/576**, zones **209/209**
- `tools/verify_legend.py .` : **TOUT EST VERIFIE**
- Les **23 clés** `GHR8/9/10_*` référencées existent en EN **et** en FR
- Simulation de `PlotScripting` sur les 3 chapitres, 4 états chacun :
  arrivée → carton-titre, titre vu → rien, donjon fini → veillée, veillée jouée
  → rien (pas de rejeu). **3/3 corrects.**

## Ce qui n'est PAS vérifié

**Rien n'a été testé en jeu.** En particulier :

- Les **fonds de carton-titre** réutilisent des ressources existantes
  (`Chapter_4`, `Chapter_3`, `Chapter_2`) faute de visuels dédiés. Le rendu peut
  jurer avec le thème du chapitre.
- Les animations `Laying` / `EventSleep` sont reprises du chapitre 7 sans
  vérifier qu'elles existent pour toutes les espèces jouables.
- L'enchaînement réel donjon → chambre → veillée → lendemain n'a jamais été
  joué de bout en bout.
