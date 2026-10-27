# Provenance — audit Étape 0 (2026-10-27)

Preuve avant hypothèse : chaque verdict ci-dessous repose sur une vérification
datée (lecture LICENSE/README via l'API GitHub, comparaison d'empreintes de
blob Git entre les fichiers locaux et les arbres des dépôts sources — métadonnées
uniquement, aucun contenu tiers n'a été importé pour cet audit).

## Dépôts examinés

| Dépôt | Licence constatée | Verdict bibliothèque |
|---|---|---|
| `meromoonmeri/*` (ce dépôt, `projet-pmdo`, `RUNTIMEPMDO`…) | œuvres de l'utilisateur | ✅ importable (compositions originales ; les tilesets tiers peints dedans restent à traiter sheet par sheet) |
| `PMDCollab/PMDC` | **MIT** | ✅ importable avec crédit (aucune carte importée en v1) |
| `audinowho/DumpAsset` | aucun fichier LICENSE (README = celui du jeu de base) | ⚠️ whitelisté par la charte du projet comme source par défaut, mais **sans licence explicite** : à n'utiliser qu'en connaissance de cause, avec crédit ; rien d'importé en v1 |
| `audinowho/PMDOTutorial` | aucun fichier LICENSE, README vide | 📖 documentation/référence de format uniquement ; aucun fichier repris (le squelette de quest est écrit à partir des formats, valeurs originales) |
| `RogueCollab/RogueEssence` | licence non classifiée par GitHub (`NOASSERTION`) | 📖 source consultée pour les faits de format (`GroundMap`, `ScrollEdge`) ; aucun code repris |
| `Palikadude/Halcyon` | **aucune licence**, README sans autorisation de réutilisation ; auteur identifié (Palika) | ⏸ **mod d'auteur → accord de Palika requis** avant tout import de carte ou de tileset (Étape 0.4). Les cartes sont cataloguées, non copiées |
| `Minemaker0430/ExplorersOfSkyOrigins` | sans objet | ⛔ **exclusion ferme** (remake de jeu commercial, Étape 0.3) : dépôt écarté entier |

## Cartes présentes dans le dépôt (13 `.rsground`)

Attributions prouvées par `git hash-object` local comparé aux arbres distants et
aux fichiers `provenance.json` / `halcyon_commit.txt` des chantiers `source/` :

| Fichier | Origine prouvée | Statut |
|---|---|---|
| `cliffdaytest.rsground` | utilisateur, conteneur 0.8.12.0 | ✅ importable → livrée clampée |
| `cliffnordouesttest1.rsground` | utilisateur, conteneur 0.8.12.0 | ✅ importable → livrée clampée |
| `vast_steppe_entrance` | Halcyon @1522c7a8 | ⏸ attente accord |
| `altere_pond` | Halcyon @1522c7a8 | ⏸ attente accord |
| `metano_cafe` | Halcyon @da6c2130 (blob `0010a20b…` identifié dans `Data/Ground`) | ⏸ attente accord |
| `guild_second_floor` | Halcyon @da6c2130 | ⏸ attente accord |
| `ledian_dojo` | Halcyon @da6c2130 | ⏸ attente accord |
| `crooked_cavern_entrance` (+ copie `crooked.rsground`) | Halcyon @da6c2130 (blob `1be7032f…`) | ⏸ attente accord ; doublon signalé |
| `luminous_spring` | Halcyon @da6c2130, graphismes de base RawAsset (provenance mixte signalée dès le chantier) | ⏸ attente accord + vérification des sheets |
| `spinda_cafe` | ExplorersOfSkyOrigins @4e7422ac (blob `34405699…` identifié dans `Data/Ground`) | ⛔ exclu |
| `ExplorersOfSkyOrigins__Brine_Cave_Entrance` | ExplorersOfSkyOrigins | ⛔ exclu |
| `ExplorersOfSkyOrigins__drenched_bluff_entrance` | ExplorersOfSkyOrigins | ⛔ exclu |

Les fichiers exclus restent à leur place dans `source/` (références d'étude des
chantiers historiques) : la bibliothèque ne les copie pas, ne les déclare pas et
le manifest les marque `exclu` pour qu'aucun import futur ne les reprenne par erreur.

## Tilesets

Même discipline sheet par sheet (un `.rsground` ne contient que des noms et des
adresses `TexLoc` ; les pixels vivent dans les `.tile`) :

- sheets originales utilisateur (`00_ciel`, `v2_promontoire_jour_03`, `terrain*`…) :
  absentes de ce dépôt → à rapatrier depuis l'installation PMDO de l'utilisateur ;
- sheets Halcyon présentes sous `source/*/references/` (`Altere_Pond_*`, `Metano_*`) :
  ⏸ même attente d'accord que les cartes ;
- sheets « natifs » des chantiers (`source/*/natifs/`) : reconstructions locales
  d'après les méthodes du dépôt ; filiation visuelle à confirmer par l'utilisateur
  avant livraison dans `tilesets/`.

## À faire pour débloquer la suite

1. Demander à **MR Palika** (Discord PMDO, canal Halcyon) l'autorisation de réemployer
   ses cartes/tilesets de référence dans PMDO Destiny, avec crédit. Tant que la
   réponse n'est pas là : aucun import Halcyon.
2. Rapatrier les `.tile` originaux manquants depuis l'installation PMDO
   (liste exacte dans `manifest.json`, champ `tilesets_tuiles`).
3. Confirmer la filiation des sheets « natifs » (`natifs/`) avant de les livrer.
