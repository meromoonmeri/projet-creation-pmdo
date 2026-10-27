# Manifeste d'extraction

- **Source** : `meromoonmeri/projet-pmdo` @ [`6cca4a09380211e510ab1bea454a1b1926ef4b5a`](https://github.com/meromoonmeri/projet-pmdo/commit/6cca4a09380211e510ab1bea454a1b1926ef4b5a) (branche `main`)
- **Date d'extraction** : 2026-10-01
- **Dépôt source** : 41868 fichiers, 6.21 Go
- **Extrait ici** : 3592 fichiers, 168.9 Mo — soit 2.7 % du volume
- **Non extrait** : 38276 fichiers, 6.04 Go (images de rendu, archives, aperçus HTML)

## Méthode d'extraction

Clone *blobless* + *sparse-checkout* : Git ne télécharge que les blobs demandés,
jamais les 6 Go. Reproductible avec `OUTILS/extraire_depuis_projet-pmdo.py`.

## Contenu extrait par catégorie

| Catégorie | Fichiers | Mo |
|---|---:|---:|
| Données PMDO natives / Tiled | 245 | 77.7 |
| Règles, configs, provenance | 842 | 47.8 |
| Assets légers (PNG des kits, gabarits) | 1356 | 36.1 |
| Scripts et code | 740 | 5.0 |
| Documentation | 326 | 1.6 |
| Visionneuses HTML | 83 | 0.6 |

## Contenu extrait par dossier

| Dossier | Fichiers | Mo |
|---|---:|---:|
| `source` | 2159 | 67.4 |
| `exports` | 236 | 24.7 |
| `sprites` | 153 | 20.9 |
| `(racine)` | 10 | 17.4 |
| `salles` | 72 | 14.0 |
| `renders` | 561 | 11.1 |
| `calques` | 264 | 5.3 |
| `tiled` | 24 | 2.9 |
| `apercus` | 3 | 2.1 |
| `image-search` | 17 | 1.7 |
| `exterieur` | 6 | 1.0 |
| `audits` | 3 | 0.2 |
| `fenetres_exterieur` | 84 | 0.2 |

## Volontairement NON extrait (récupérable à la demande)

| Dossier | Fichiers | Go | Contenu |
|---|---:|---:|---|
| `renders` | 32907 | 4.32 | rendus PNG/GIF/WebP des maps, aperçus HTML, ZIP d'étapes |
| `(racine)` | 287 | 0.88 | archives ZIP livrées, aperçus HTML, images de référence PMD |
| `source` | 456 | 0.56 | PNG de travail des sous-projets (gabarits, découpes) |
| `exports` | 3790 | 0.19 | exports PNG et planches, quelques JSON/CSV repris ici |
| `sprites` | 812 | 0.10 | planches de sprites et découpes PNG |
| `salles` | 24 | 0.00 | PNG/Aseprite des 12 salles (extrait sauf Aseprite) |

## Récupérer ce qui manque

```sh
# un fichier précis, sans cloner :
curl -L -o fichier.png \
  https://raw.githubusercontent.com/meromoonmeri/projet-pmdo/6cca4a09380211e510ab1bea454a1b1926ef4b5a/renders/exemple/fichier.png
```

Ou relancer l'extraction avec `--avec-media` (voir `OUTILS/extraire_depuis_projet-pmdo.py`),
ou un `git sparse-checkout add renders/mon_dossier` dans un clone blobless.

## Restauration des aperçus et des maps en ZIP (27 octobre 2026)

L'aperçu des maps a été restauré dans son intégralité, animations comprises :

- **166 aperçus HTML autonomes** de la racine (770 Mo, images et animations
  intégrées) + les archives **ZIP livrées** (112 Mo) : `OUTILS/restaurer_apercus.py`
  les récupère par clone blobless + sparse-checkout, avec les seuls médias
  réellement chargés par les pages (galeries `renders/*`, GIF, images de revue).
- **126 cartes Ground des 13 archives ZIP** restaurées fidèlement dans
  `apercus/zips/<pack>/` : `OUTILS/restaurer_maps_zip.py` décode les `.rsground`,
  `.tile` et `.dir` natifs et génère une page de carte animée par map (tuiles 8 px
  natives, cycle de palette `FrameLength` en ticks 1/60 s, fonds animés et
  défilement `BGMovement`, marqueurs et collisions en surimpression) + une
  galerie pour les packs de sprites. Chaque pack est listé à l'index du serveur
  par un stub `apercu_zip_<pack>.html`.

Ces fichiers lourds sont dans `.gitignore` (récupérables en une commande) ; seuls
les deux outils et les 13 stubs sont versionnés. Serveur d'aperçus :
`python3 source/serveur_apercus/serve.py --port 8000`.

## Maps récentes des branches, ouvertures & title screen animé (27 octobre 2026)

`OUTILS/restaurer_branches.py` ajoute à l'aperçu tout le travail récent contenu
sur les **20 branches `arena/*` de ce dépôt**, chaque branche étant considérée
à son TIP (les suppressions de fin de branche sont respectées) :

- **137 aperçus racine récents** : maps de donjon et de monde (Fin/Entrée Tour
  Temporelle V1-V2 et variantes Roche Noire-Or, arene Prisme Temporel, Vallons
  Fleuris, lots DTEF EFM1/EFC1/EMH1…, grottes EGI1/EBC1/EGE1, Crevasse
  enneigée ECE1/ECE2, Grotte aux vasques FGV1, Pelipper Post Office PPO1/2,
  Zekrom ZKE1/ZKA1, Faille spatiale Palkia FSA0/1, Oiseaux Légendaires,
  Cliff Nord jour/nuit animés, Reseau Metano, layouts Village Metano, maps de
  PMD Destiny, etc.), catalogues, lots de décor (kiosques Spinda, mobilier
  café, tentes, colonnes & lances…) et cinématique Pichu & Team Dazzling.
- **Ouvertures & title screen animé PMD Destiny** : les 8 aperçus d'ouverture
  (`apercu_fangame_pmd_destiny*.html`), la page du title screen animé
  « Ray of Hope MIX » (`apercu_fangame_pmd_destiny_pixel_opm.html` : logo centré,
  ailes oscillantes amorties, fond `Title_Screen_Background_Jour/Nuit` animé),
  chapitres 1-2, et leurs assets (`renders/pmd_destiny_fangame_v1/`,
  `renders/pmd_destiny_nuit_v1/`, vidéo d'ouverture 60 fps incluse).
- **Galerie** `renders/fin_clairiere_tropicale_v1/` (revue, manifest, `.ora`).

Règles appliquées : pour un même nom de fichier, la branche au TIP le plus
récent gagne ; déduplication par hash de contenu ; **aucun fichier local n'est
écrasé** ; les fichiers non suivis récupérés sont dans `.gitignore` (uniquement
les outils sont versionnés). Les contenus retirés à la demande en fin de branche
(Promontoire 2, lot LCM1 « méthode multicalque non suivie ») ne sont pas
réintégrés ; le FTT1 de remplacement (branche du 18 octobre, postérieure au
rejet de la V1) et la cinématique Pichu (retirée comme « défectueuse » sur une
branche ultérieure mais encore présente au TIP d'une autre) sont inclus.

Lacunes connues (jamais commitées dans le dépôt, liens morts dans les pages) :
les paquets de mods `/download/*.zip` et `/.cache/virtual_zips/*.zip`, et la
planche `renders/pmd_destiny_fangame_v1/apercus_menu/planche_4_maps_opening_pmd_320x240.png`.

Relancer : `python3 OUTILS/restaurer_branches.py --fetch` (idempotent).

## Bibliothèque Ground clampée pour la quest PMDO Destiny (27 octobre 2026)

`OUTILS/construire_bibliotheque_ground.py` construit `bibliotheque_ground/` :
**147 maps `.rsground` en version clampée** (126 des 6 ZIP livrés + 21 des
branches `arena/*`), prêtes à importer dans la quest PMDO Destiny 0.8.12
(Namespace `halcyon`, GameVersion `0.8.12.0` — jamais modifiés).

- **Clamp** : toute donnée espace-carte (obstacles.Bounds — y compris les packs
  en listes de listes —, Collider/Hitbox, Loc/StartLoc/EndLoc, Decorations) est
  ramenée dans les limites par intersection ; `TexLoc`, fonds et identifiants
  intacts. 15 corrections hors zone réelles (spawners des maps
  `reseau_metano_normal_v1` placés 170 px sous la carte) → **0 anomalie
  restante**. Option `--sceller-bords` pour collisionner les cellules de bord
  marchables (71 888 au total — diagnostic de frontières ouvertes).
- **Étape 0 (provenance)** : 5 fichiers **exclus** et signalés (2 dérivés
  d'ExplorersOfSkyOrigins = exclusion ferme, 3 provenances ambiguës/licences
  non vérifiées) ; 13 stubs en liens symboliques `.cache/tiles/` non
  matérialisés. Crédits dépôt par dépôt : `bibliotheque_ground/CREDITS.md`.
- Chaque lot embarque `Data/Ground` (clampé), `Data/Script`, `Content/Tile`+
  `Content/BG`, `meta_src/` et un `lot.json` avec la déclaration `GroundMaps`
  prête à recopier **en fin de tableau** (Étape 2). Audit : 195 noms de
  feuilles référencées sans fichier listés dans `rapport_clamp.json`.
- Les données (`bibliotheque_ground/lots/`, 2,4 Go) sont régénérables par le
  script et non suivies ; le script, les docs et les rapports sont versionnés.
