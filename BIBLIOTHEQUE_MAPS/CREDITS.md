# Crédits — bibliothèque de cartes

Registre des contenus effectivement présents dans `grounds/` et `tilesets/`,
et des références ayant servi à construire l'outillage. Mis à jour à chaque import.

## Cartes livrées

| Fichier | Auteur | Licence / base | Source (dépôt, commit) | Traitement bibliothèque |
|---|---|---|---|---|
| `grounds/cliffdaytest.rsground` | meromoonmeri | œuvre originale de l'utilisateur | ce dépôt, racine (`cliffdaytest.rsground`) | copie clampée : `EdgeView` Blank→Clamp (seul changement, prouvé par diff sémantique) |
| `grounds/cliffnordouesttest1.rsground` | meromoonmeri | œuvre originale de l'utilisateur | ce dépôt, racine (`cliffnordouesttest1.rsground`) | copie clampée : `EdgeView` Blank→Clamp (seul changement, prouvé par diff sémantique) |

Aucun tileset tiers n'est livré en v1 (`tilesets/` vide — voir `tilesets/README.md`).
Les cartes de référence Halcyon et ExplorersOfSkyOrigins présentes dans `source/`
ne sont **pas** importées (voir `PROVENANCE.md`) : elles ne figurent donc pas ici
comme contenus livrés, seulement au catalogue du `manifest.json` avec leur statut.

## Références techniques (formats, aucun contenu repris)

- **RogueEssence** (RogueCollab) — classes `GroundMap` / `BaseMap.ScrollEdge`
  consultées pour les faits de format : taille dérivée de `Layers[0]`, grille
  d'obstacles en cellules de 8 px, `EdgeView` (`Blank=0, Clamp=1, Wrap=2`).
- **PMDC** (PMDCollab, licence MIT) — structure de référence des données de zone.
- **PMDOTutorial / DumpAsset** (audinowho) — documentation de format uniquement
  (schéma `Mod.xml`, zone à `Segments` vide + `GroundMaps`, arborescence
  `Data/Script/<Namespace>/…`) ; le squelette `quest_pmdo_0812/` est écrit avec
  des valeurs originales (Namespace, UUID, noms et scripts propres au projet).
- **Ce dépôt** — `source/pmdo_cote` (conventions d'installation et de protection
  des cartes éditées) et `source/pmdo_runtime` (méthode de validation sur le vrai
  chargeur PMDO 0.8.12, à rejouer par l'utilisateur).

## En attente (rien d'importé)

- **Halcyon — MR Palika et contributeurs** : 7 cartes de référence cataloguées
  (`vast_steppe_entrance`, `altere_pond`, `metano_cafe`, `guild_second_floor`,
  `ledian_dojo`, `crooked_cavern_entrance`, `luminous_spring`) + leurs tilesets.
  Import seulement après accord explicite de l'auteur, avec ce crédit complété
  (commit exact par fichier — déjà consigné dans `provenance_maps.json`).
