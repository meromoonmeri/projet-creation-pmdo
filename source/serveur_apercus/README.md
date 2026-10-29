# Aperçus PMDO — cartes et archives Arena

Démarrer depuis la racine du dépôt :

```sh
python3 source/serveur_apercus/serve.py --port 8000
```

Le serveur écoute sur `0.0.0.0`, pour fonctionner dans l’aperçu Arena. Ouvrir `/` pour la galerie.

## Sources consultées en lecture seule

Le catalogue combine deux dépôts, épinglés à leurs commits de base :

- `meromoonmeri/projet-pmdo` — `6cca4a09380211e510ab1bea454a1b1926ef4b5a` : **166 pages HTML et 200 ZIP** de `main`, plus **54 aperçus, 99 ZIP et 743 ressources** provenant des instantanés Arena retenus parmi 14 têtes examinées.
- `meromoonmeri/projet-creation-pmdo` — `8d2a5b8d9dadef254a0773bb36d633888148adcd` : **174 aperçus** (149 pages racine et 25 pages imbriquées), **10 ZIP, 6 ORA et 683 ressources** issues de 12 instantanés; 24 têtes Arena ont été examinées.

Cela représente **394 cartes/pages et 315 archives** dans la galerie. Les pages homonymes des deux dépôts restent distinctes : leur URL porte l’identité du dépôt et le commit exact, afin que leurs images, animations et autres ressources soient restituées depuis le bon arbre. Les branches distantes sont lues sans checkout ni fusion.

Les 10 ZIP et 6 fichiers OpenRaster ajoutés depuis `projet-creation-pmdo` ont été ouverts et vérifiés (membres ZIP lisibles et CRC sans erreur). Les archives sont téléchargeables depuis l’onglet **Archives ZIP / ORA**.

## Cartes demandées et animations

- **Vallons Fleuris** (FVF1 + EVF1), **Entrée Tour Temporelle V2** (ETT2) et **Sommet Tour Temporelle V2** (FTN2) ont des références de rendu absentes dans les instantanés contrôlés. Les calques ORA fournissent les secours statiques; les médias vidéo/animés réellement présents dans les pages source restent servis. Pour la V2, les trois WebP manquants du Sommet sont remplacés par les deux calques et leur composite statique, sans prétendre reconstituer leurs animations.
- **Tour Temporelle — Roche Noire & Or V1** conserve les rendus WebP animés et les ORA d’ETT1/FTT1. La page d’ensemble inclut aussi ECL1, CLR1 et CLR2; deux images de revue associées à CLR1 manquent dans cet instantané et sont signalées au-dessus de l’aperçu.
- **Faille Spatiale · Palkia** conserve sa page multicarte originale. Les composites statiques vérifiés de FSE1 et FSA1 restent visibles lorsque les couches détaillées manquent; FSA0 n’a pas de composite vérifié dans l’instantané consulté. Le titre de la source est « Faille Spatiale », pas « Domaine de Palkia ».
- Les ZIP liés à des pages de carte ouvrent la visionneuse originale. Pour les autres archives, le serveur privilégie une visionneuse intégrée, puis un manifeste exploitable, puis une galerie des médias présents.

Les visionneuses source sont servies à la demande. Seules les pages explicitement concernées par un secours reçoivent un petit avis visible; les fichiers source ne sont ni modifiés ni copiés dans le dépôt.

## Stockage et tests

Les clones blobless, l’index de l’API et les blobs consultés restent dans `.cache/apercus-upstream/` et `.cache/apercus-creation-upstream/` (ignorés par Git). Aucun lot de médias volumineux n’est copié ici. Si l’index GitHub est temporairement indisponible, les instantanés locaux `branch_catalog.json` et `branch_catalog_creation.json` sont tout de même chargés : les aperçus de branches restent visibles, avec un libellé de mode secours dans la galerie.

```sh
python3 -m unittest source.serveur_apercus.test_serve -v
```
