# Carte blanche — Refonte et conception de cutscenes (New Era) Mont Windsep (Mont Venteux)

Document directeur fourni par l'utilisateur le 2026-07-29. Source de vérité permanente
(mode opératoire pour toute refonte ou création de cutscene dans New Era).

## Principe : liberté totale, mais encadrée

Carte blanche sur la façon d'exécuter une cutscene ou sa refonte : choix précis de mise en
scène, de rythme, de découpage, d'effets, de composition. Cette liberté porte sur le
**comment**. Elle ne porte jamais sur le **si** — les contraintes ci-dessous et celles du
fichier de méthode général (`prompt_mise_en_scene_optimise.md`) sont non négociables et
s'appliquent à toute cutscene, actuelle ou future, sans exception.

Ne jamais considérer une contrainte comme un frein à la créativité. Elle définit le terrain
sur lequel la créativité s'exerce.

## Contraintes non négociables

**1. Cadrage** — Aucune entité active dans la scène ne doit se retrouver hors champ caméra
à un moment où elle est censée être visible ou agir. Si un personnage doit réagir ou parler,
la caméra le cadre — pas d'exception pour des raisons de simplicité technique.

**2. Positionnement esthétique** — Le placement de chaque personnage est composé
visuellement, jamais posé au hasard. L'arrivée dans la scène, la formation du groupe, les
distances entre personnages doivent sembler pensées pour être belles à l'écran — pas
seulement fonctionnelles.

**3. Réactivité systématique** — Chaque Pokémon présent réagit aux événements de la scène.
Aucun figurant passif qui attend simplement son tour de dialogue.

**4. Dialogues cohérents avec la personnalité** — Chaque réplique correspond au caractère,
au registre de langage et à l'état de connaissance du personnage qui la prononce. Pas de
ligne interchangeable entre deux personnages.

**5. Déplacements logiques et sans collision** — Les personnages ne se traversent jamais,
ne se bloquent jamais mutuellement. Chaque trajet a une justification narrative — jamais de
déplacement gratuit ou de téléportation d'état.

**6. Séquence de rêve — règle spécifique** — Quand le héros dort et rêve, il doit être
physiquement présent, au centre du rêve — jamais une simple transition noire. La séquence
doit inclure :

- la musique associée au test de personnalité ;
- le dream parallax du test de personnalité ;
- l'apparition de Gardevoir par un effet de clignotement / scintillement progressif —
  jamais une apparition instantanée ou un sprite simplement posé ;
- un dialogue entre le héros et Gardevoir une fois son apparition stabilisée, cohérent
  avec sa personnalité (douce, mystérieuse, ancienne).

## Application immédiate — cutscene du rêve de Gardevoir

Cette cutscene part actuellement d'une mauvaise base sur plusieurs points cumulés à la
fois : positionnement, gestion de l'arrivée, cadrage caméra, réactivité des personnages.
Elle doit être reconstruite entièrement, pas patchée point par point.

- Direction artistique complète : `brief_cinematique_reve_gardevoir.md`
  (conservé dans `docs/BRIEF_REVE_GARDEVOIR.md`).
- Contraintes de mise en scène non négociables sur cette refonte : ce document.
- Règles générales de mise en scène, audit et transitions applicables à toute cutscene :
  `prompt_mise_en_scene_optimise.md` (directive méthode = Annexe A de
  `docs/PASSATION_AGENT_ARENA.md`).

## Portée future

Ce document sert de mode opératoire permanent pour toute refonte ou création de cutscene
dans New Era : carte blanche totale sur l'exécution créative, zéro négociation sur les six
points ci-dessus et sur les règles du fichier de méthode général. À appliquer
systématiquement, sans qu'il soit nécessaire de le rappeler à chaque nouvelle tâche.
