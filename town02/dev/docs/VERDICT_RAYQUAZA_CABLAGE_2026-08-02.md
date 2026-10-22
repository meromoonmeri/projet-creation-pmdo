# Point 1 — Rayquaza : oubli de câblage ou scène abandonnée ?

Date : 2026-08-02 — branche `new-era-1-9`
Vérification demandée avant toute mise en scène de `PeakVictory`.

## Verdict : **oubli de câblage.** La scène Rayquaza n'est pas obsolète.

---

## La preuve, par l'historique Git

| Date | Commit | Fichier touché |
|---|---|---|
| 28/07 | `ac1ddde` — « Apres-boss ch8-10 : structure reprise de pret/pmd-red » | crée `ChapterAftermath.PeakVictory` (**Lugia**) + `zone/celestial_peak` |
| **01/08** | **`a8f2362`** — « feat(ch10/climax): implement **Rayquaza** boss encounter, Rescue Team reference, and meteorite destruction sequence » | `autel_celeste/init.lua` (+144/-20) et ses 2 `.resx` |

La scène Rayquaza est **postérieure de quatre jours** à `PeakVictory`. Elle a
été écrite pour la remplacer — le message de commit est explicite : *implement
Rayquaza boss encounter*.

**Mais ce commit n'a touché que 3 fichiers** :

```
modified  +144  -20   Data/Script/halcyon/ground/autel_celeste/init.lua
modified  +18   -4    Data/Script/halcyon/ground/autel_celeste/strings.fr.resx
modified  +18   -4    Data/Script/halcyon/ground/autel_celeste/strings.resx
```

Ni `zone/celestial_peak/init.lua`, ni `ChapterAftermath.lua`. L'auteur a écrit
la nouvelle scène et **a oublié de débrancher l'ancienne**.

## Le mécanisme exact du blocage

Le flux réel du chapitre 10 :

```
segment 4 (Sommet Sacré, 4 étages) — victoire
   └─> GAME:EnterGroundMap('autel_celeste', 'Main_Entrance_Marker')
          └─> autel_celeste.Enter()
                 └─> teste : CelestialPeakComplete and not PlayedVictoryScene
                     -> FAUX au premier passage (CelestialPeakComplete pas encore posé)
                 └─> joue la cinématique d'apparition de Rayquaza  ✔
                 └─> GAME:ContinueDungeon("celestial_peak", 5, ...)   → segment 5

segment 5 (le combat) — victoire
   └─> SV.Chapter10.CelestialPeakComplete = true
   └─> ChapterAftermath.PeakVictory()        ← LUGIA, l'ancienne scène
          └─> Aftermath() pose PlayedVictoryScene = true dès sa 1re ligne
   └─> EndDungeonRun(... carte 2 ...)        ← retour direct à la chambre
```

Le joueur ne repasse **jamais** par `autel_celeste.Enter()` après le combat.
Et même s'il y repassait, `PlayedVictoryScene` est déjà à `true` : la condition
d'entrée de `PlayPostVictoryScene` est définitivement fausse.

**Conséquences en chaîne :**

1. La cinématique d'**apparition** de Rayquaza se joue bien (avant le combat).
2. La scène d'**après-victoire** de Rayquaza — météorite, clin d'œil aux
   explorateurs, avertissement final — ne se joue **jamais**.
3. Le joueur voit donc apparaître Rayquaza, le combat, puis une scène où
   **Lugia** replie ses ailes et demande pardon. Deux boss différents dans la
   même séquence.
4. `SV.ChapterProgression.Chapter = 11` n'existe que dans la scène morte →
   **le chapitre 11 est inatteignable**.

Le point 3 est le plus parlant : ce n'est pas seulement un enchaînement cassé,
c'est une **incohérence visible à l'écran**.

## Ce que ça implique pour votre point 1

Vous aviez raison de m'arrêter. Mettre en scène `PeakVictory` dans sa version
Lugia aurait été du travail à jeter : cette fonction doit être **remplacée**,
pas embellie.

Le bon geste est en trois temps :

1. **Débrancher** : `segment 5` n'appelle plus `PeakVictory()` mais renvoie sur
   `autel_celeste`, où la scène Rayquaza attend déjà.
2. **Déplacer la bascule de chapitre** : `Chapter = 11` doit être posé dans le
   flux réellement exécuté.
3. **Mettre en scène la scène Rayquaza** (celle d'`autel_celeste`), qui est
   aujourd'hui un squelette : 14 boîtes, 1 caméra, 2 déplacements,
   **0 orientation**.

Et aligner ce qui reste de Lugia au ch10 : flags `DefeatedLugia`,
`ReachedLugiaAltar`, `DiedToLugia`, la réplique de mort « Lugia... le Gardien
des Cieux... nous a jugés », et les 10 clés `GHR10_*` de la veillée qui disent
« On a parlé à LUGIA ».

## Sort de `ChapterAftermath.PeakVictory`

Elle n'est pas à jeter entièrement. Son contenu — le gardien qui s'excuse,
« Cherchez sous l'écaille », la Voix qui a peur pour la première fois — est
d'excellente facture et porte la fin du Livre I.

**Recommandation** : transposer ce contenu sur Rayquaza plutôt que le
supprimer. La scène d'`autel_celeste` couvre la météorite et l'accusation ; la
scène de `PeakVictory` couvre l'aveu du gardien. Les deux sont complémentaires,
et leur fusion donnerait un climax complet — ce qui règle aussi le déficit de
boîtes du ch10 (56 en cinématiques aujourd'hui).

**Question qui reste à trancher** : Lugia doit-il conserver un rôle au ch10
(par exemple une apparition au Sommet Sacré, segment 4, avant l'Autel), ou
disparaît-il complètement du chapitre pour ne revenir qu'au ch9 dans Stormy
Sea comme vous l'avez demandé ?

Tant que ce point n'est pas tranché, je ne touche pas aux 119 occurrences de
« Lugia » — dont 66 dans `metano_town_ch_7.lua`, qui relèvent de la légende
racontée en ville et ne sont probablement pas à modifier.

## Réserve

Rien n'est testé manette en main. Le mécanisme décrit est déduit de la lecture
croisée de `zone/celestial_peak` (segments 4 et 5), de `Aftermath()` et de la
condition d'entrée d'`autel_celeste.Enter()`.
