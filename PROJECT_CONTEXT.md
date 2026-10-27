# Contexte du projet — branche bibliothèque de cartes / quest 0.8.12

Mis à jour : 2026-10-27. Branche de session : `arena/488d1a47-projet-creation-pmdo`
(nom imposé par l'environnement de travail ; c'est elle qui joue le rôle de
« branche bibliothèque » demandée).

## Ce que cette branche ajoute au dépôt

1. **`BIBLIOTHEQUE_MAPS/`** — la bibliothèque de Ground/maps à importer dans la
   quest PMDO 0.8.12 :
   - charte + procédure d'import (`README.md`), audit de provenance Étape 0
     (`PROVENANCE.md`, `provenance_maps.json`), crédits (`CREDITS.md`) ;
   - outillage stdlib : `outils/rsground.py` (lecture/analyse),
     `outils/clamp_rsground.py` (audit/corrections clamp), 
     `outils/construire_manifest.py`, `outils/construire_index_tiles.py` ;
   - `grounds/` : 9 cartes livrées **clampées** — 2 compositions originales de
     l'utilisateur + 7 compositions Halcyon (accord d'auteur confirmé) ;
   - `manifest.json` : catalogue des 13 `.rsground` du dépôt (9 livrées,
     3 ExplorersOfSkyOrigins exclues, 1 source en doublon octet-identique),
     tailles, marqueurs, tilesets présents/missing, audit clamp de chaque source.
2. **`quest_pmdo_0812/`** — squelette de mod Quest PMDO 0.8.12 installable
   (Namespace `destiny_bibliotheque`, UUID neuf) : zone `hub_bibliotheque`
   déclarant les cartes livrées, scripts stubs, `LISEZ-MOI_QUEST.md` avec la
   liste des tests en jeu à faire par l'utilisateur.

## Décisions et faits établis

- **Clamp** = `EdgeView=1` (`BaseMap.ScrollEdge : Blank=0, Clamp=1, Wrap=2`,
  sources RogueEssence) + grilles cohérentes + entités bornées + `TexLoc`
  valides. La taille d'une GroundMap vient de `Layers[0].Tiles` ; la grille
  `obstacles` est en cellules de 8 px (`largeur×TexSize`).
- **Provenance** : accord MR Palika confirmé par l'utilisateur (2026-10-27) → les
  compositions Halcyon sont importées. Précision de l'utilisateur vérifiée :
  l'art des tilesets Halcyon = pool PMDO de filiation PMD Sky (0/45 `.tile`
  identiques au DumpAsset actuel : sheets découpées sur mesure, pixels non
  créés par MR Palika) → la bibliothèque ne redistribue aucun `.tile`, sheets à
  fournir localement. ExplorersOfSkyOrigins exclu ferme (`spinda_cafe` = EoSO,
  prouvé par blob) ; PMDC = MIT ; DumpAsset/PMDOTutorial sans LICENSE
  (référence de format). Détail : `BIBLIOTHEQUE_MAPS/PROVENANCE.md`.
- Les originaux ne sont jamais modifiés : l'outillage corrige des copies et
  refuse d'écraser un fichier existant.

## Reste à faire (utilisateur)

- [x] Accord de MR Palika pour les compositions Halcyon (confirmé par l'utilisateur).
- [ ] Rapatrier les `.tile` (liste par carte dans `manifest.json`) dans
      `quest_pmdo_0812/Content/Tile/` depuis l'installation PMDO locale, puis
      reconstruire l'index (`outils/construire_index_tiles.py`).
- [ ] Tests en jeu / éditeur PMDO 0.8.12 listés dans
      `quest_pmdo_0812/LISEZ-MOI_QUEST.md` (ouverture, EdgeView, marqueurs
      d'entrée, collisions, bords de carte).
- [ ] Confirmer la filiation des sheets `source/*/natifs/` avant livraison.
- [ ] Ensuite seulement : cinématiques (Partie 2 de la charte) carte par carte.
