# Refonte de la cinématique du rêve de Gardevoir + Ground onirique

Brief de tâche fourni par l'utilisateur le 2026-07-29. Complémentaire au fichier de
méthode général (`prompt_mise_en_scene_optimise.md` = Annexe A de
`docs/PASSATION_AGENT_ARENA.md`). Toutes les règles générales de ce fichier — mise en
scène, positionnement, orientation, caméra, déplacements, audit final, transitions —
s'appliquent intégralement à cette scène sans exception. Ce brief ne couvre que ce qui est
spécifique à cette cinématique.

## Constat de départ

La version actuelle de la scène part d'une mauvaise base : mise en scène faible,
positionnement artificiel, caméra mal pensée, personnages statiques, apparition de
Gardevoir sans impact émotionnel, Ground peu immersive.

**Décision** : ne pas réparer l'existant morceau par morceau. Reconstruire la scène en
considérant qu'il s'agit d'une cinématique majeure du jeu, au niveau d'une scène
émotionnelle officielle de Pokémon Mystery Dungeon (registre : Explorateurs du Ciel /
Équipe de Secours).

## Phase 1 — Audit avant tout code

Avant de modifier quoi que ce soit, analyser : la cinématique actuelle et ses scripts, les
transitions existantes, les dialogues, le système de caméra, les assets disponibles, les
Grounds oniriques ou similaires déjà présentes dans le projet, et des exemples de
cinématiques PMD officielles de registre équivalent.

Identifier précisément : pourquoi la scène actuelle ne fonctionne pas, ce qui casse
l'immersion, ce qui doit être supprimé, ce qui doit être reconstruit. Aucune correction
superficielle.

## Direction artistique — la Ground du rêve

Ce n'est pas une zone de dialogue : c'est une représentation du rêve du héros, de son
inconscient, de son lien avec Gardevoir — un espace entre réalité et souvenir. Le joueur
doit comprendre immédiatement que ce lieu n'existe pas réellement.

**Ambiance** : mystérieuse, calme, spirituelle, magique, émotionnelle. Lumière douce,
brume légère, particules flottantes, couleurs adaptées au rêve, effets de profondeur —
le décor doit vivre, pas ressembler à une map normale.

**Nature** : végétation abondante et variée, arbres travaillés, zones sauvages naturelles,
détails environnementaux. La map ne doit jamais sembler vide.

**Eau** : cours d'eau, ruisseaux, cascades, bassins, reflets lumineux — sensation de calme
et d'ancienneté. L'eau peut servir de point d'ancrage à l'apparition de Gardevoir.

**Composition pensée pour la caméra** : une zone centrale d'apparition du héros, un espace
ouvert pour les interactions, des chemins naturels, des points de vue intéressants, des
éléments visibles en arrière-plan. Chaque élément du décor doit servir la narration,
l'émotion ou la composition — rien de gratuit.

## Présence du héros dans son rêve

Le héros doit être physiquement présent dans le rêve — pas de simple transition noire. Le
joueur voit le héros au centre, son environnement mental, et une traduction visuelle de
son état émotionnel.

**Musique** : utiliser la musique associée au test de personnalité et son dream parallax.
La musique doit démarrer avant ou pendant l'apparition du décor, pour renforcer l'entrée
dans le rêve.

## Apparition de Gardevoir

Ce doit être un moment fort — pas une apparition instantanée, pas un sprite simplement
posé sur la map, pas un dialogue sans mise en scène.

Construire une vraie entrée : silence temporaire, lumière étrange, clignotement du sprite,
apparition progressive, effet spectral, caméra attirée vers elle. L'impression recherchée :
une présence ancienne qui vient de traverser le rêve.

## Personnalité de Gardevoir

Douce, mystérieuse, protectrice, calme, ancienne. Ses mouvements doivent être élégants —
elle ne se comporte jamais comme un PNJ banal. Ses dialogues portent de la sagesse, de la
douceur, du mystère ; jamais de phrase générique.

Le héros, de son côté : cherche des réponses, réagit naturellement (surprise,
incompréhension, curiosité, peur, émerveillement selon le moment), ressent le poids de la
rencontre.

## Structure narrative de la scène

La cinématique doit suivre un arc complet : introduction (découverte du lieu, immensité,
héros placé au centre), montée émotionnelle (rapprochement avec Gardevoir), moment fort
(la rencontre / la révélation), conclusion.

## Méthode de travail

1. Audit complet de l'existant
2. Identification précise des problèmes
3. Proposition de la nouvelle mise en scène
4. Conception de la nouvelle Ground
5. Application des règles générales de déplacement, caméra, positionnement
6. Vérification des réactions et animations
7. Implémentation
8. Tests répétés en jeu

## Règle absolue

Ne jamais privilégier la facilité technique au détriment de la qualité artistique. Une
cinématique réussie doit provoquer immersion, émotion, curiosité et attachement aux
personnages. Le moteur est un outil au service de la mise en scène, pas une contrainte qui
la limite.

**Objectif** : que cette scène devienne l'une des cinématiques les plus mémorables du jeu.
