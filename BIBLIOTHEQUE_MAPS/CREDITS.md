# Crédits — bibliothèque de cartes

Registre des contenus effectivement présents dans `grounds/` et `tilesets/`,
et des références ayant servi à construire l'outillage. Mis à jour à chaque import.

## Cartes livrées

| Fichier | Auteur | Licence / base | Source (dépôt, commit) | Traitement bibliothèque |
|---|---|---|---|---|
| `grounds/cliffdaytest.rsground` | meromoonmeri | œuvre originale de l'utilisateur | ce dépôt, racine (`cliffdaytest.rsground`) | copie clampée : `EdgeView` Blank→Clamp (seul changement, prouvé par diff sémantique) |
| `grounds/cliffnordouesttest1.rsground` | meromoonmeri | œuvre originale de l'utilisateur | ce dépôt, racine (`cliffnordouesttest1.rsground`) | copie clampée : `EdgeView` Blank→Clamp (seul changement, prouvé par diff sémantique) |

| `grounds/vast_steppe_entrance.rsground` | disposition : Halcyon (Palika) ; art des tilesets : pool PMDO (PMD Sky) | accord de l'auteur confirmé par l'utilisateur (2026-10-27) ; aucun pixel tiers dans le fichier | `Palikadude/Halcyon` @1522c7a8b7a34d70078e11ed605b21d563b0dc51 | copie clampée (déjà `EdgeView=Clamp`) |
| `grounds/altere_pond.rsground` | idem | idem | `Palikadude/Halcyon` @1522c7a8b7a34d70078e11ed605b21d563b0dc51 | copie clampée (déjà `EdgeView=Clamp`) |
| `grounds/metano_cafe.rsground` | idem | idem | `Palikadude/Halcyon` @da6c2130d641507447e6386a5e47a296e8cb4c71 (blob `0010a20b…`) | copie clampée : `EdgeView` Blank→Clamp |
| `grounds/guild_second_floor.rsground` | idem | idem | `Palikadude/Halcyon` @da6c2130d641507447e6386a5e47a296e8cb4c71 | copie clampée : `EdgeView` Blank→Clamp |
| `grounds/crooked_cavern_entrance.rsground` | idem | idem | `Palikadude/Halcyon` @da6c2130d641507447e6386a5e47a296e8cb4c71 (blob `1be7032f…`) | importée une seule fois (deux sources octet-identiques) ; déjà `EdgeView=Clamp` |
| `grounds/ledian_dojo.rsground` | idem | idem | `Palikadude/Halcyon` @da6c2130d641507447e6386a5e47a296e8cb4c71 | copie clampée (déjà `EdgeView=Clamp`) |
| `grounds/luminous_spring.rsground` | idem (+ graphismes pool RawAsset selon le chantier) | idem | `Palikadude/Halcyon` @da6c2130d641507447e6386a5e47a296e8cb4c71 | copie clampée (déjà `EdgeView=Clamp`, TexSize 3) |

Aucun tileset n'est livré (`tilesets/` vide — voir `tilesets/README.md`) : les
pixels des sheets, de filiation PMD Sky via le pool PMDO, ne sont pas redistribués
par la bibliothèque ; chaque carte liste ses sheets dans `manifest.json`, à
fournir depuis l'installation PMDO locale. Les cartes ExplorersOfSkyOrigins
présentes dans `source/` restent **exclues** (voir `PROVENANCE.md`).

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

## Précision d'attribution (2026-10-27)

À la demande de l'utilisateur : les ressources graphiques peintes par les cartes
Halcyon proviennent du pool PMDO de filiation **PMD Sky** (sheets découpées sur
mesure, art non créé par MR Palika — hors contributions ciblées de spriteurs
créditées dans le README d'Halcyon). Le travail d'MR Palika crédité ici est la
**composition des cartes** (disposition, entités, marqueurs). Vérification :
0/45 `.tile` de référence identiques octet pour octet au `Content/Tile` de
DumpAsset ; provenance RawAsset consignée par les chantiers `source/`.
