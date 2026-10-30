# Destiny — récupération des 16 occurrences absentes

**Mise à jour : 30 octobre 2026.** L’état du dépôt de quête n’a pas changé : 262 occurrences sont inventoriées (229 hashes Ground distincts, 33 occurrences dupliquées), mais la quête `destiny` reste à **246 Grounds**. Aucune des 16 occurrences absentes n’a été intégrée ni remplacée par une candidate.

## Résultat

- **13 Grounds de branche exacts** ont été récupérés, pour 10 payloads Ground distincts et 3 doublons (`002/018`, `003/019`, `010/036`). Le ZIP exact actuel est validé comme archive, mais n’a pas été rechargé par le runtime PMDO dans l’état courant du workspace.
- **3 Grounds générés** (`generated_002/007/029`) n’ont toujours pas leurs payloads aux hashes attendus. Leurs variantes sont conservées séparément, jamais comme substituts.
- Les 13 Grounds exacts contiennent **536 références TileSheet manquantes**, soit **202 noms source bruts** distincts. Dans les chemins `.tile` des packages installables du tag New Era, **509/536 références** (195/202 noms) ont un candidat au même basename insensible à la casse. Ce résultat est une correspondance de nom et de chemin, pas une preuve que le payload est le bon.
- Une comparaison Git stricte des chemins `.tile` des commits source Ground avec les candidats New Era trouve **un seul OID Git commun** : `Metano_Town_Base` (`d4fc7ff9a5ac7e83233b9584d620c2fed1735354`) pour `branch_026`. Le commit source contient trois fichiers de ce nom et deux payloads distincts; l’association au Ground reste donc ambiguë. **Aucune dépendance TileSheet manquante n’est certifiée pour intégration.**
- Quatre fichiers exacts `terrain.tile`, co-présents dans un commit avec le Ground exact de `branch_011`, ont été récupérés dans une archive d’évidence distincte. L’affectation de ces quatre fichiers aux aliases `terrain`, `terrain (2)`, `terrain (3)`, `terrain (4)` n’est pas établie par un index/manifeste et reste non certifiée.

Aucune géométrie, collision, sortie, warp, transition ou TileSheet n’a été inventée. Les sources Ground brutes et leur provenance restent séparées des alias Treasure de l’inventaire; aucun remplacement textuel aveugle n’a été appliqué aux payloads sources.

## Recherche complémentaire dans les branches et archives (30 octobre 2026)

La recherche a été étendue aux branches et à l’historique de `projet-creation-pmdo` et `guilde-treehouse-pmd`. **Aucune des trois sources Ground générées exactes n’a été retrouvée; aucun candidat homonyme n’est compté comme résolution.**

- Pointes : **26 branches / 25 arbres** dans `projet-creation-pmdo`, **81 / 81** dans `guilde-treehouse-pmd`; les 106 arbres récursifs ont été lus sans troncature. Aucun blob Ground direct aux trois tailles attendues.
- Historique Ground : 359 commits accessibles et 352 arbres d’historique uniques du dépôt actif; 929 commits Guild examinés, dont les 45 arbres des commits modifiant des `.rsground`. Aucun payload de taille/hash attendu.
- Historique `.tile` direct : 700 chemins distincts dans le dépôt actif et 280 dans Guild; respectivement 9 et 12 chemins avaient un basename cible. Leurs versions d’historique n’ajoutent pas de payload certifié.
- Archives : les **414 références ZIP** des pointes Guild (411 blobs distincts), les **40 versions ZIP Guild** pertinentes (8 blobs historiques nouveaux, 32 déjà présents aux pointes), les 12 ZIP des pointes du dépôt actif et le ZIP racine ont été dédupliqués par OID Git. **430 blobs ZIP externes** (3 039 063 124 octets) ont été récupérés/validés par OID Git et leurs membres directs inspectés; aucune erreur de téléchargement ni d’index ZIP.
- Dans ces archives : zéro membre aux tailles des trois Grounds manquants, zéro hash Ground exact, et zéro des 13 Grounds de branche exacts. Aucun couple Ground exact + TileSheet référencée co-emballé n’a été trouvé. Le ZIP racine est un doublon de contenu (OID `876f05d235be8e13c549df54366e497637e52db4`) déjà présent dans l’ensemble.

La recherche des **223 basenames `.tile` bruts/canoniques** parmi les 106 pointes trouve 8 basenames candidats, 13 couples chemin/OID et 11 OIDs distincts. Ils restent des candidats; les faits par famille sont :

| Référence manquante | Payload observé dans les branches | Conclusion stricte |
|---|---|---|
| `terrain`, `terrain (2–4)` | Quatre OIDs `28264483…`, `e20a9d8b…`, `4e6bd932…`, `63279730…`, co-présents avec le Ground exact `branch_011`. | Provenance Ground établie, mais aucun index ne relie l’un des quatre payloads à l’un des quatre aliases. Non assignés. |
| `Metano_Town_Base` / `Treasure_Town_Base` | `d4fc7ff9…` et `19b29549…`; le premier est identique au candidat New Era, le second est une autre source du commit. | Plusieurs fichiers/versions coexistent; l’association occurrence-payload reste ambiguë. Non certifié. |
| `Metano_Town_Animated` / `Treasure_Town_Animated` | OID `7f528a8b…`, identique au candidat New Era homonyme. | Pas co-committé avec le Ground exact concerné; nom et payload partagé ne prouvent pas l’association. |
| `Apricorn_Glade_Big_Tree` | OID `534d30f9…`, identique au candidat New Era homonyme. | Pas co-committé avec le Ground exact; non certifié. |
| `interieur_sans_deco_jour (1)` | `dfaae8ca…` dans `quest_pmd_destiny`; différent du candidat New Era `35c6f6a8…`. | Deux payloads homonymes différents; provenance non établie. |
| `spinda_cafe_dojo` | `e6974155…` dans `quest_pmd_destiny`; différent du candidat New Era `b88e1f22…`. | Deux payloads homonymes différents; provenance non établie. |
| `téléchargement (6)` | `b8782038…` dans `quest_pmd_destiny`; différent du candidat New Era `21eea4d4…`. | Deux payloads homonymes différents; provenance non établie. |

Les archives ZIP apportent deux entrées portant le nom `Metano_Town_Base.tile`, mais une seule payload (OID `d4fc7ff9…`, SHA-256 `305a7324…`, 1 231 857 octets), dans `pmd_native_map_v1_pmdo.zip` et `renders/amp_plains_fleurie_v1/amp_plains_fleurie_v1.zip`. Elles ne contiennent aucun des Grounds exacts audités; c’est donc la même candidate ambiguë, pas une nouvelle association.

**Conclusion :** aucun Ground manquant n’est récupéré exactement; aucune nouvelle TileSheet n’est attribuée par occurrence avec preuve suffisante. Aucun payload, alias, chemin de quête ou dépendance n’a été remplacé ou intégré. La recherche ZIP a porté sur les membres directs; les éventuels ZIP imbriqués n’ont pas été développés récursivement. Les détails structurés des branches, hashes, OIDs et candidats sont consignés dans `DESTINY_16_TILE_SOURCE_AUDIT.json`, sous `branchAndArchiveSearch`.

## Grounds de branche exacts

Archive d’évidence (pas un MOD/Quest installable) :

- [`exports/pmdo/PMD_Destiny_13_Exact_Branch_Ground_Sources.zip`](../../exports/pmdo/PMD_Destiny_13_Exact_Branch_Ground_Sources.zip)
- **1 183 078 octets**, SHA-256 `80127d5a9d972ab964ea3df6accfe2a3931fb6bf653f79c8c3adcc10dc195cff`.
- 16 membres, dont un manifeste de 13 occurrences; `unzip -t` et le contrôle CRC passent.
- Le manifeste enregistre le SHA-256 de l’inventaire source au moment du build (`6d7bfd5f1a13a62f993f28d622d5896a1648621f2e5d2c30c23770646385d15d`). L’inventaire entier a ensuite reçu les métadonnées d’audit/bundle : son hash courant est `5edb19c0632b58f23adb6d6582e7e47c4b7eeefce8383782fbe55b27085a1aeb`, donc il ne correspond plus au hash d’entrée historique. Les 262 lignes d’occurrence/provenance n’ont pas été remplacées par ces métadonnées.

| Occurrence(s) | Asset Ground source | SHA-256 du payload Ground exact |
|---|---|---|
| `branch_002`, `branch_018` | `cliffdaytest` | `cee906cd7275ad5b00f4a08f957f63930885ad81e0587be82a52535a6a8486af` |
| `branch_003`, `branch_019` | `cliffnordouesttest1` | `2d0922a1f2220e9ff7b803aa04e1fa63e2ece2c1d739732d1c31631982e14f3a` |
| `branch_010`, `branch_036` | `cliffdaytest` | `6567e19df7a073758d8d52ad1491460067a2dccc1c0d03aa0d1c72b5592e4d2f` |
| `branch_011` | `cliffnordouesttest1` | `2cb10918d6bfa8ed687c1412b2d2e7c4aebc545049b9d2d76eb7c16fdb632f19` |
| `branch_026` | `cliffdaytest` | `9d2075904dea1da3b89f8517ef80915f3317d0505e0a68d99159838e9a88cd73` |
| `branch_027` | `treasure_gen_accueil` | `91b6c38f06dfdb863bb7f101f992d1ee559b1ee14f7d70c67bf4f7255b884e4c` |
| `branch_028` | `treasure_gen_cafe` | `428111d8e41498d0bd96e979cf2a20694d88754e91fbe27bf97e20ce117661fe` |
| `branch_029` | `treasure_gen_casino` | `a6bfa18b6083ce20793bbb149c96b2006186061cc5a3b609bbd850305c3072d9` |
| `branch_030` | `treasure_gen_salon_bas` | `f23932b65e3d7294e534bdb13367545def8cc7bdd026e33fc228e0c1759165f4` |
| `branch_031` | `treasure_gen_salon_haut` | `0f8feeaa6d57399b2f4d87689728470608d168387b4ad368009fd6e150e54f50` |

Les occurrences dupliquées restent séparées dans le manifeste. `branch_036` conserve aussi le blob `.rsground.gz` d’origine; son contenu décompressé correspond au hash indiqué.

### Portée des probes Ground

Les anciens rapports [`destiny_missing16_exact_ground_runtime_results.tsv`](../pmdo_runtime/destiny_missing16_exact_ground_runtime_results.tsv) et [`destiny_missing16_candidates_ground_runtime_results.tsv`](../pmdo_runtime/destiny_missing16_candidates_ground_runtime_results.tsv) enregistrent respectivement 13/13 et 3/3 PASS du chargeur natif PMDO 0.8.12.0. Ils indiquent `Ground.Version=0.8.12.0`, `TexSize=1` pour chaque occurrence, lots de 20 maximum et `GraphicsManager.DungeonTexSize=3`.

**Limite importante :** les empreintes d’entrée inscrites dans ces TSV (`66ed0b0f…` et `d500418d…`) ne correspondent pas aux hashes des deux archives actuelles (`80127d5a…` et `f1344109…`). Les 13 et 3 hashes des payloads Ground, ligne par ligne, correspondent bien aux manifestes actuels; cela étaye les mêmes payloads Ground, mais ne prouve pas le chargement des conteneurs/manifestes ZIP actuels. Le cache `.cache/pmdo-runtime/engine/PMDO` est absent à cette mise à jour : **aucun probe runtime n’a été relancé sur les ZIP actuels**. Les TSV restent des résultats historiques, pas des tests de ces archives.

## Audit New Era / Halcyon par occurrence

Piste examinée : tag `town02-quest-pmdo-0812-complete`, commit `47c571bc6c80721549db3e5e13443a84b87e8b3d`, dépôt `meromoonmeri/projet-creation-pmdo`. Son namespace est `halcyon` : le package sert uniquement à la recherche de provenance et **n’est pas la quête cible**.

| Ground source | Références ayant un chemin candidat au même nom | Noms absents du tag |
|---|---:|---|
| `branch_002` | 6/9 | `01_long_cap_jour_02`, `13_avancee_basse_gauche_terrain`, `v2_promontoire_jour_03` |
| `branch_003` | 3/8 | `terrain`, `terrain (2)`, `terrain (3)`, `terrain (4)`, `v2_promontoire_jour_03` |
| `branch_010` | 6/9 | `01_long_cap_jour_02`, `13_avancee_basse_gauche_terrain`, `v2_promontoire_jour_03` |
| `branch_011` | 3/8 | `terrain`, `terrain (2)`, `terrain (3)`, `terrain (4)`, `v2_promontoire_jour_03` |
| `branch_018` | 6/9 | `01_long_cap_jour_02`, `13_avancee_basse_gauche_terrain`, `v2_promontoire_jour_03` |
| `branch_019` | 3/8 | `terrain`, `terrain (2)`, `terrain (3)`, `terrain (4)`, `v2_promontoire_jour_03` |
| `branch_026` | 13/13 | — |
| `branch_027` | 125/125 | — |
| `branch_028` | 111/111 | — |
| `branch_029` | 82/82 | — |
| `branch_030` | 57/57 | — |
| `branch_031` | 88/88 | — |
| `branch_036` | 6/9 | `01_long_cap_jour_02`, `13_avancee_basse_gauche_terrain`, `v2_promontoire_jour_03` |
| **Total** | **509/536** | **27 références sans candidat, 7 noms distincts** |

Le comptage par occurrence vérifie les stems bruts des Grounds source contre les chemins `.tile` des packages installables (core et packs A–D), sans casse. Parmi les 202 noms, 195 ont un chemin candidat; 196 chemins candidats installables contiennent 196 OIDs Git distincts, notamment deux payloads différents pour `D09p03_Base`. Sur l’arbre complet, qui inclut aussi des fichiers source non installables, l’audit recense 236 chemins candidats et 205 blobs distincts. Les index core/pack B/pack C contiennent également des nœuds portant 195/202 noms cibles; les conflits d’index et fichiers multiples restent des versions candidates, pas une sélection certifiée. L’audit JSON joint donne les références, chemins et OIDs par occurrence.

Les sept noms absents du tag sont :

| Nom source brut | Occurrences | État de la source exacte |
|---|---:|---|
| `01_long_cap_jour_02` | 4 | Aucun payload `.tile` exact confirmé. |
| `13_avancee_basse_gauche_terrain` | 4 | Seul un PNG associé est trouvé; il n’a pas été converti ni substitué. |
| `terrain` | 3 | Un des quatre payloads co-committés est candidat, mais son alias n’est pas certifié. |
| `terrain (2)` | 3 | Payloads `terrain.tile` co-committés récupérés; affectation de suffixe non établie. |
| `terrain (3)` | 3 | Idem. |
| `terrain (4)` | 3 | Idem. |
| `v2_promontoire_jour_03` | 7 | Un package d’un PR distinct contient un fichier de ce nom, mais ses Grounds ont d’autres hashes; association non prouvée. |

Le seul blob Git partagé trouvé dans la comparaison stricte des arbres source Ground et du package New Era est `d4fc7ff9a5ac7e83233b9584d620c2fed1735354` pour `Metano_Town_Base` de `branch_026`. Trois fichiers de ce nom figurent dans le commit Ground source (`0e691d647a661f3c2a79984eda2d39686d4f0dfc`) et portent deux OIDs distincts : `d4fc…` / SHA-256 `305a7324…` et `19b295…` / SHA-256 `ee17ebd2…`. Le fichier Halcyon a l’OID `d4fc…`; une candidate publiée sous l’alias canonique `Treasure_Town_Base` a aussi le SHA-256 `305a7324…`. Cela établit une identité de payload pour une variante, mais pas laquelle des variantes est associée au Ground exact; elle reste exclue.

## Réconciliation du chiffre historique « 60/76 »

Ce ratio n’est pas encore réconcilié : l’unité du chiffre ancien, sa règle de dédoublonnage, les 76 lignes et la liste des 60 OIDs ne sont pas présents dans les éléments d’audit disponibles. Le manifeste du bundle exact compte 633 occurrences de références TileSheet, 589 paires distinctes `(Ground SHA-256, nom brut)` et 229 noms bruts au total; parmi les absences, 536 occurrences / 510 paires distinctes / 202 noms, avec 79 paires non marquées manquantes. Ces dénominateurs ne reproduisent pas 60/76 et ne doivent pas être confondus.

J’ai aussi revérifié le manifeste distinct `BIBLIOTHEQUE_MAPS/manifest.json` du commit `ac58cc9a37ca8a5b5305419e82f44cf6ba646a5d` (blob `728209…`) et `PROVENANCE.md` (blob `8711c5…`) : il contient 13 cartes, 75 lignes de références (72 paires Ground-source/nom brut), dont 52 lignes avec chemin TileSheet explicite (49 paires) et 23 sans. Il confirme des blobs précis déjà présents pour `branch_011` (`Altere_Pond_Cliffs`, blob `ee4527…`; `Metano_Town_Animation_Tileset`, blob `8b01d1…`) mais ces feuilles ne sont pas ses huit références manquantes. La provenance indique que les feuilles utilisateur `00_ciel`, `v2_promontoire_jour_03` et `terrain*` sont absentes de ce dépôt. Ces éléments ne révèlent pas le dénominateur 76 ni ne certifient les aliases `terrain`.

La réconciliation reste donc ouverte : il faut retrouver l’audit source avec ses 76 lignes, clés de dédoublonnage, chemins et OIDs Git (ou le script/log qui a produit le ratio) avant d’attribuer une portée au numérateur 60. Les détails et hashes contrôlés sont consignés dans `DESTINY_16_TILE_SOURCE_AUDIT.json`.

## Sources récupérées pour `branch_011`

L’archive d’évidence [`PMD_Destiny_branch_011_CoCommitted_Terrain_TileSheets.zip`](../../exports/pmdo/PMD_Destiny_branch_011_CoCommitted_Terrain_TileSheets.zip) contient les quatre `.tile` bruts et cinq documents de provenance (manifeste source et quatre `.tsj`), avec chemins, OIDs, tailles et SHA-256 : **6 120 774 octets**, SHA-256 `1ff26ca9bd42900a934796160a641432d191bf6e87b2684ebd40805989bfe20c`. Les quatre blobs TileSheet, les cinq blobs de métadonnées, leurs SHA-256 et le CRC ZIP ont été vérifiés.

| Dossier source du commit | Git blob | Octets | SHA-256 |
|---|---|---:|---|
| `01_promontoire/terrain.tile` | `28264483e5ee0d8f625f099934c3288a37ab2c2c` | 2 403 217 | `5e6a0a14c0ee2ebbdfc85282292ecf3ca56fa2c0ffab3c69ebe4c72fd5a38751` |
| `02_double_terrasse/terrain.tile` | `e20a9d8b61556e17f54f26998f55d35e278b6a03` | 3 004 117 | `1978ba9ab513ca05f801906f4cb971dd68bd81cb1dc6e7f4bad2f748e9ef96a3` |
| `03_cirque_gradins/terrain.tile` | `4e6bd9320f804719c08032f54ee1681b2d0c9784` | 2 311 264 | `f6cd34b6400d54543aad3e04680f362eea0425709885aa09c2446890c950f1be` |
| `04_echancrure/terrain.tile` | `63279730c86b1d99a4fb802bf596ce11dbdb824d` | 2 568 342 | `5710e401781d577480c1a28ef98b5f771551e4a5fc920da6cecb7082da5bfb27` |

Les quatre fichiers sont co-présents avec le Ground exact (`branch_011`, Ground Git blob `51e9dd3b896cbd5563acf1d03ddc5433b22eaf96`) dans `meromoonmeri/guilde-treehouse-pmd@35aeb24d31a7e6856be30abdda4ed91bc0b15e91`. L’archive conserve aussi le manifeste source `renders/falaises_metano_calques/manifest.json` (blob `a37fe4d04886a5e891fe9a3eead564d9bc8d5428`) et les quatre `.tsj` : ils relient chaque payload à un module source `01`–`04`, mais **aucun ne le relie explicitement à l’alias Ground `terrain`, `terrain (2)`, `terrain (3)` ou `terrain (4)`**. Le numéro de dossier reste un indice, pas une preuve; les payloads ne sont donc pas installés ni intégrés comme dépendances certifiées.

Les payloads `Altere_Pond_Cliffs.tile` et `Metano_Town_Animation_Tileset.tile` sont aussi présents dans ce commit avec le Ground et leurs blobs correspondent aux fichiers source; la copie active de l’animation est renommée `Treasure_Town_Animation_Tileset.tile` sans changement de payload (`SHA-256 51ee6afbd9da3747e060bf9c1f3dd3d9305853fbcb7cbf582b51b6fbea81e8d0`). Les feuilles `00_ciel`, `INVERSEPATHWAY` et `Metano_Altere_Transition_Base` trouvées dans le package New Era sont des candidates séparées, non co-committées avec ce Ground. `v2_promontoire_jour_03` vient d’un PR séparé.

Un probe TileGuide antérieur, explicitement **candidate-only**, a chargé le Ground `branch_011` (version `0.8.12.0`, grille 138×98, `TexSize=1`, 4 calques), puis résolu 9 432 coordonnées distinctes sur un index temporaire de 10 nœuds, sans coordonnées absentes. Il a utilisé `GraphicsManager.DungeonTexSize=3`. Son rapport ne conserve pas le hash du ZIP/index d’entrée; l’archive d’évidence actuelle n’a pas été rejouée par PMDO. Ce résultat ne vérifie ni pixels, ni rendu, ni collisions dessinées, ni jouabilité; les quatre associations `terrain` étaient inférées. Il ne transforme aucune candidate en résolution exacte. Aucun TileGuide complet n’a été revendiqué pour les 13 occurrences.

## Bundle de candidates générées non exactes

- [`exports/pmdo/PMD_Destiny_3_NonExact_Generated_Ground_Candidates.zip`](../../exports/pmdo/PMD_Destiny_3_NonExact_Generated_Ground_Candidates.zip)
- **835 940 octets**, SHA-256 `f1344109c217101bb4d473dd58fbc58440137cb05a390f8bf5eade2813c7cec9`; CRC validé.

| ID | Hash attendu | Candidate | Conclusion |
|---|---|---|---|
| `generated_002` | `66bbf7ab1769bd049f705f1a4212eb66743771d4935a2695f82065ad170de54f` | `f8a25c76c2aa7cc032a8e0bf9afa76d02ad96f303bc6cea6eb4ff40fbed047da` | Variante AGM2 publiée; différente de la sortie inventoriée. |
| `generated_007` | `7f1439809f557e4b736b9d414d2a2583df88355e4e40e3eff31fb497387e0788` | `91cfa0d42cffd2ba5b42779411d77936d0df8d204eb99837d9df2b5f15d6eb20` | Reconstruction avec inputs historiques, sérialisation différente. |
| `generated_029` | `65f5f45eb300c2cfd4921350221a554288607f775389b1f2b1646764d2ebefe9` | `5085a04684dd1e9cc671a519dd62b295c65d6344b28d9f3d604fb9aba2376e4b` | Reconstruction avec inputs historiques, sérialisation différente. |

Les anciens TSV indiquent que ces trois **payloads candidats** ont passé le chargeur natif, avec `Version=0.8.12.0` et `TexSize=1`; leur hash d’entrée `d500418d…` n’est toutefois pas celui du ZIP actuel. Leurs Ground SHA-256 individuels correspondent au manifeste actuel. Le probe du ZIP courant reste à relancer lorsque le runtime sera disponible.

Recherche locale d’exactitude au 2026-10-30 : aucun des trois SHA-256 attendus (`66bbf7ab…`, `7f143980…`, `65f5f45e…`) n’a été retrouvé parmi les 32 fichiers `.rsground` libres ni dans les 60 entrées Ground de cinq archives ZIP locales. Cette vérification ne transforme pas les candidates en résolutions et ne remplace pas une recherche d’archive externe.

Contrôle distant complémentaire des blobs `.rsground` du tag Halcyon `town02-quest-pmdo-0812-complete` (`47c571bc…`) : 4 638 fichiers Ground ont été examinés par taille, et aucun n’a la taille attendue d’un des trois payloads. Les noms de famille correspondants existent, mais leurs payloads publiés ne sont pas exacts :

| Cible | Blob candidat dans Halcyon | Taille / SHA-256 du candidat | Attendu |
|---|---|---|---|
| `generated_002` | `town02/Data/Ground/agm2_arene_groudon_magma.rsground` (`703e0448…`) | 16 860 372 / `49e1260d…` | 14 322 020 octets; hash attendu `66bbf7ab…` |
| `generated_002` | `town02/Data/Ground/main_AGM2_calques_png_8px_AGM2_arene_groudon_magma_calques.rsground` (`152fe422…`) | 1 053 055 / `77823ae1…` | idem |
| `generated_007` | `town02/Data/Ground/EKR1_entree_caverne_cristal_calques.rsground` (`6435ee4f…`) | 1 050 049 / `701aa45d…` | 6 959 641 octets; hash attendu `7f143980…` |
| `generated_029` | `town02/Data/Ground/FKR1_fin_caverne_cristal_calques.rsground` (`93cb5ce5…`) | 1 048 450 / `a1ce8a4a…` | 7 911 956 octets; hash attendu `65f5f45e…` |

Les OIDs Git et SHA-256 de ces candidats sont vérifiés; la taille différente suffit à exclure l’identité byte-à-byte. Ils restent des candidats Halcyon, pas des Grounds Destiny. Le commit d’ajout des chemins est `cd93c7fe…`.

## Inventaire et artefacts d’audit

- [`destiny_262_inventory.json`](destiny_262_inventory.json) conserve les 262 occurrences, leurs provenances, 229 Ground hashes distincts et les 33 doublons. Ses métadonnées des archives courantes et des probes historiques sont synchronisées.
- [`DESTINY_16_TILE_SOURCE_AUDIT.json`](DESTINY_16_TILE_SOURCE_AUDIT.json) consigne les 536 références par occurrence, aliases bruts/canoniques, chemins candidats New Era et Git blobs, les 7 noms absents, la comparaison stricte d’OIDs et l’archive des quatre terrains.
- L’archive Halcyon reste une piste seulement (`namespace=halcyon`); aucun payload candidat, y compris l’unique blob partagé ambigu, n’est installé comme dépendance Destiny.

## État final

`all16Resolved=false`, `questIntegrated=false`, `groundOrTileSheetSubstituted=false`. Les 13 Grounds exacts ne complètent pas encore leurs TileSheets et les trois Grounds générés exacts restent introuvés. La quête `destiny` demeure à 246 Grounds; aucun changement de quête ou installation dans le PMDO utilisateur n’a été fait. Validation technique des archives et preuves de provenance ne valent ni rendu visuel ni test de jouabilité.
