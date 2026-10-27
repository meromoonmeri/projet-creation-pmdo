# Bibliothèque de cartes PMDO 0.8.12 — Ground / maps prêts à importer

Cette branche fait du dépôt la **base de lancement de la quest PMDO 0.8.12** et sa
**bibliothèque de cartes** : des `.rsground` (et demain des `.rsmap`) vérifiés,
**tous en clamp**, prêts à être déclarés dans une zone sans risque de hors-zone.

```
BIBLIOTHEQUE_MAPS/
├── README.md            ← ce fichier (charte + procédure)
├── PROVENANCE.md        ← audit Étape 0 : verdict par dépôt et par carte (preuves)
├── CREDITS.md           ← auteurs, licences, commits, fichiers importés
├── provenance_maps.json ← verdicts machine-lisibles (maintenus à la main)
├── manifest.json        ← catalogue généré (faits par carte : tailles, tilesets, clamp)
├── grounds/             ← copies CLAMPÉES livrées (les originaux ne sont jamais touchés)
├── tilesets/            ← .tile livrés avec les cartes (voir son README)
└── outils/
    ├── rsground.py              lecture/écriture/analyse .rsground (stdlib)
    ├── clamp_rsground.py        audit + corrections de clamp (dry-run par défaut)
    ├── construire_manifest.py   régénère manifest.json
    └── construire_index_tiles.py (re)construit Content/Tile/index.idx d'un mod
quest_pmdo_0812/         ← le mod Quest installable dans PMDO/MODS (banc d'essai)
```

## « Clamp », définition appliquée à chaque carte livrée

Une carte est livrée seulement si l'audit `clamp_rsground.py` passe à zéro problème :

1. **`EdgeView = Clamp (1)`** — énumération `BaseMap.ScrollEdge` de RogueEssence
   (`Blank=0, Clamp=1, Wrap=2`) : la caméra ne défile jamais au-delà des bords de la
   carte. `Blank` affiche le vide hors zone, `Wrap` boucle la carte : les deux sont refusés.
2. **Grilles cohérentes** — tous les calques de tuiles font exactement la taille de
   `Layers[0]` ; la grille `obstacles` couvre `largeur×TexSize × hauteur×TexSize`
   cellules de 8 px, `Bounds` alignés sur les indices.
3. **Rien ne dépasse** — personnages, objets, marqueurs, spawners et décors animés
   tiennent entièrement dans `[0, largeur_px) × [0, hauteur_px)`.
4. **Adresses valides** — quand le `.tile` est disponible, chaque `TexLoc` peint
   existe dans la grille du tileset (pas de tuile adressée hors sheet).

Les corrections sont écrites dans une **nouvelle copie** sous `grounds/`, jamais sur
l'original, puis prouées par relecture + ré-audit. Aucun calque plus grand que la
carte n'est rogné en silence : c'est signalé pour correction manuelle dans l'éditeur.

## Règles d'import (procédure bibliothèque)

1. **Provenance d'abord.** Aucune carte n'entre dans `grounds/` sans ligne dans
   `provenance_maps.json` avec statut `importable` (licence lue ou accord d'auteur).
   Statuts : `importable` · `en_attente_accord` (cataloguée, non copiée) ·
   `exclu` (cataloguée pour traçabilité, jamais importée). Détail : `PROVENANCE.md`.
2. **Clamp systématique.** `python outils/clamp_rsground.py CARTE --corriger -o grounds/CARTE`
   puis `python outils/construire_manifest.py`. Le manifest doit montrer la carte
   « livrée » avec zéro problème restant.
3. **Tilesets avec la carte.** Chaque `Sheet` référencé doit avoir son `.tile` dans
   `tilesets/` (ou être documenté manquant dans le manifest). Nommage par basename :
   deux tilesets homonymes s'écrasent à l'import → préfixer au besoin. Ne jamais
   mélanger 8 px (`TexSize 1`) et 24 px (`TexSize 3`) dans une même carte.
4. **Déclaration en zone, en fin de tableau.** Ajouter l'id de la carte à la **fin**
   de `GroundMaps` du JSON de zone (jamais d'insertion : les index existants ne
   doivent pas bouger — un fichier sur disque non déclaré provoque le crash
   « Cannot find ground map » en cascade).
5. **Index des tilesets.** Après tout ajout de `.tile` dans le mod cible :
   `python outils/construire_index_tiles.py CHEMIN/MOD/Content/Tile`
   (ou reconstruction complète via les outils développeur PMDO). Ne jamais coller
   un `index.idx` partiel sur un mod existant.
6. **Script de carte.** `Data/Script/<Namespace>/ground/<carte>/init.lua` avec
   `require` explicite de chaque module `_ch_N.lua` utilisé ; toute `SV.*` déclarée
   dans `scriptvars.lua` ; chaînes via `strings.resx`/`strings.fr.resx`.
7. **Crédits.** Mettre à jour `CREDITS.md` (dépôt, auteur, licence, commit, fichiers).

## État (2026-10-27)

| Carte | Origine | État bibliothèque |
|---|---|---|
| `cliffdaytest` (123×99), `cliffnordouesttest1` (138×98) | compositions originales utilisateur | ✅ livrées clampées |
| `vast_steppe_entrance` (64×64), `altere_pond` (116×96) | compositions Halcyon @1522c7a8 | ✅ livrées clampées |
| `metano_cafe` (57×40), `guild_second_floor` (84×56) | compositions Halcyon @da6c2130 | ✅ livrées, `EdgeView` Blank→Clamp |
| `crooked_cavern_entrance` (40×30), `ledian_dojo` (51×39) | compositions Halcyon @da6c2130 | ✅ livrées clampées |
| `luminous_spring` (25×25, **TexSize 3**) | composition Halcyon @da6c2130 | ✅ livrée clampée |
| 3 cartes ExplorersOfSkyOrigins | remake de jeu commercial | ⛔ exclues, jamais importées |

Précision d'attribution (utilisateur, 2026-10-27) : l'art des tilesets peints par
les cartes Halcyon vient du pool PMDO de filiation **PMD Sky** — MR Palika est crédité
pour les **compositions**, pas pour les pixels. En conséquence, la bibliothèque
livre les `.rsground` (sans pixels tiers) et **ne redistribue aucun `.tile`** :
les sheets de chaque carte (listées dans `manifest.json`) se fournissent depuis
l'installation PMDO locale. Même règle pour les grosses sheets originales des
deux cartes utilisateur, absentes de ce dépôt.

Limites connues, assumées : marqueurs d'entrée et collisions des deux cartes
utilisateur restent à valider/poser en éditeur ; `luminous_spring` est en
tuiles de 24 px (ne pas la mélanger à des sheets 8 px) ; les ids livrés gardent
leur nom d'origine pour la traçabilité — renommage français au moment de
l'intégration Destiny. Le squelette `../quest_pmdo_0812/` déclare les 9 cartes
pour validation dans PMDO 0.8.12 (voir son `LISEZ-MOI_QUEST.md`). Aucun test
moteur n'a été fait depuis ce dépôt : tout est prouvé par relecture des fichiers.
