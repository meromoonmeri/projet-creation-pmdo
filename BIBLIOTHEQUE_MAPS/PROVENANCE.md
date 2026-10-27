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
| `Palikadude/Halcyon` | **aucune licence** dans le dépôt ; auteur identifié (Palika) | ✅ **compositions importées** : accord de l'auteur confirmé par l'utilisateur (2026-10-27). ⚠️ Précision de l'utilisateur, vérifiée ci-dessous : les **graphismes** ne sont pas une création Halcyon mais le pool PMDO de filiation PMD Sky → seuls les `.rsground` (dispositions, sans pixels) sont importés ; les `.tile` ne sont jamais redistribués par la bibliothèque |
| `Minemaker0430/ExplorersOfSkyOrigins` | sans objet | ⛔ **exclusion ferme** (remake de jeu commercial, Étape 0.3) : dépôt écarté entier |

## Cartes présentes dans le dépôt (13 `.rsground`)

Attributions prouvées par `git hash-object` local comparé aux arbres distants et
aux fichiers `provenance.json` / `halcyon_commit.txt` des chantiers `source/` :

| Fichier | Origine prouvée | Statut |
|---|---|---|
| `cliffdaytest.rsground` | utilisateur, conteneur 0.8.12.0 | ✅ importable → livrée clampée |
| `cliffnordouesttest1.rsground` | utilisateur, conteneur 0.8.12.0 | ✅ importable → livrée clampée |
| `vast_steppe_entrance` | composition Halcyon @1522c7a8 | ✅ importée clampée |
| `altere_pond` | composition Halcyon @1522c7a8 | ✅ importée clampée |
| `metano_cafe` | composition Halcyon @da6c2130 (blob `0010a20b…`) | ✅ importée, `EdgeView` Blank→Clamp |
| `guild_second_floor` | composition Halcyon @da6c2130 | ✅ importée, `EdgeView` Blank→Clamp |
| `ledian_dojo` | composition Halcyon @da6c2130 | ✅ importée clampée |
| `crooked_cavern_entrance` (+ copie `crooked.rsground`) | composition Halcyon @da6c2130 (blob `1be7032f…`) | ✅ importée une seule fois (sources octet-identiques) |
| `luminous_spring` (TexSize 3) | composition Halcyon @da6c2130 ; graphismes pool RawAsset | ✅ importée clampée ; sheets locales |
| `spinda_cafe` | ExplorersOfSkyOrigins @4e7422ac (blob `34405699…` identifié dans `Data/Ground`) | ⛔ exclu |
| `ExplorersOfSkyOrigins__Brine_Cave_Entrance` | ExplorersOfSkyOrigins | ⛔ exclu |
| `ExplorersOfSkyOrigins__drenched_bluff_entrance` | ExplorersOfSkyOrigins | ⛔ exclu |

Les fichiers exclus restent à leur place dans `source/` (références d'étude des
chantiers historiques) : la bibliothèque ne les copie pas, ne les déclare pas et
le manifest les marque `exclu` pour qu'aucun import futur ne les reprenne par erreur.

## Tilesets

Même discipline sheet par sheet (un `.rsground` ne contient que des noms et des
adresses `TexLoc` ; les pixels vivent dans les `.tile`). Vérification du
2026-10-27, à la suite de la précision de l'utilisateur (« Halcyon réemploie les
ressources de PMD Sky ») : les 45 `.tile` de référence des chantiers ont été
comparés par empreinte de blob aux 209 entrées de `Content/Tile` de DumpAsset —
**0 identique**. Ce sont donc des sheets découpées sur mesure pour Halcyon, mais
à partir du pool graphique PMDO (RawAsset, confirmé par les `provenance.json`
des chantiers), de filiation PMD Sky : l'art n'est pas une création d'MR Palika
(hors contributions ciblées de spriteurs créditées dans le README Halcyon).

Conséquence, appliquée uniformément :
- les **compositions** `.rsground` d'Halcyon sont importées (accord d'auteur) —
  elles ne contiennent aucun pixel tiers ;
- les **pixels** `.tile` de filiation jeu commercial ne sont **pas redistribués**
  par la bibliothèque (cohérent avec l'exclusion Étape 0.3 des contenus extraits) :
  chaque carte livrée liste ses sheets dans `manifest.json`, à fournir depuis
  l'installation PMDO locale de l'utilisateur ;
- sheets originales utilisateur (`00_ciel`, `v2_promontoire_jour_03`, `terrain*`…) :
  absentes de ce dépôt → à rapatrier de la même façon ;
- sheets « natifs » des chantiers (`source/*/natifs/`) : filiation visuelle au pool
  à confirmer par l'utilisateur avant toute livraison dans `tilesets/`.

## À faire pour la suite

1. Rapatrier les `.tile` (pool PMDO + originaux utilisateur) dans
   `quest_pmdo_0812/Content/Tile/` depuis l'installation PMDO locale
   (liste exacte par carte dans `manifest.json`), puis reconstruire l'index.
2. Confirmer la filiation des sheets « natifs » (`natifs/`) avant de les livrer.
3. Adapter chaque carte importée à Destiny au moment de son intégration
   (nom français, chaînes FR, PNJ/marqueurs, collisions revérifiées) — les ids
   actuels gardent la traçabilité d'origine.
