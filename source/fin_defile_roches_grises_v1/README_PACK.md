# FDR1 — Fin du Défilé des Roches grises

> **CHANTIER EN COURS : build produit, mais tests dédiés, vérificateur et packaging non terminés. Voir STATUS.md ; les commandes ci-dessous sont la cible, pas une livraison certifiée.**

Projet d'édition **PMDO 0.8.12**, **768 × 576 px**, 4:3 vaste, 96 × 72 cases de **8 px** (`TexSize=1`).
Namespace `fin_defile_roches_grises`, Ground `fdr1_fin_defile_roches_grises`. Nouveau lot indépendant, aucun ancien lot écrasé.

## Intention et référence

Fin assortie a EDR1 ; arene naturelle fermee, arrivee sud, boss central non nomme, objectif au pied de la paroi nord. Aucune sortie.

Référence ROM **D46P41A**, rendue avec skytemple-files 1.8.5 depuis `pret/pmd-sky`, commit
`c8073235b39746a7ee74e6cea16c730bd91a1e67`. Les fichiers source, blobs Git et SHA-256 sont
consignés dans `reference/provenance.json`. Le nom de la carte est descriptif, **pas un nom officiel
déduit du code Dnn**. Les images ROM ont réellement été fournies au générateur.

La référence principale donne la matière du défilé ; D46P11A est aussi passée au générateur pour rester cohérent avec EDR1. Le rendu de D46P41A renvoyé par l’outil contient une seule frame (malgré le drapeau BPL d’animation de palette). La première proposition contenait une estrade indésirable : elle a été supprimée par édition générée locale, sans sortie nord ni artefact. L’image intermédiaire rejetée n’est pas conservée ; les prompts le signalent.

## Pipeline et origine des pixels

Bruts conservés à 1200×896 : décor complet, puis sol complet séparé. Prompts dans `generation.json`.
Segmentation sur le brut, contour de sol relevé et documenté dans `config.json`, ombres déjà présentes
séparées par luminance. Talus et pied de parois isolés dans une bande de 24 px, non praticables.
Réduction BOX pondérée par classe, vote maximal, facteur uniforme 576/896, largeur arrondie 771
puis recadrage centré à 768. Palette commune 96 sans dither. Le sol visible conserve le décor ;
le sol complet assure un support continu sous les masses. Les racines/aiguilles restent dans les parois.

**Terrain généré référencé**, pas extraction de pixels officiels. « Natif » désigne les formats
`.tile`, `index.idx`, `.rsground` et la grille 8 px. Les effets sont recalculés avec des couleurs exactes du rip.
La mesure de fidélité utilise le même classifieur sur rip, brut et sortie ; seuil bloquant **35**.
Les distances et la couverture de chaque matière sont dans le manifeste ; elles ne certifient pas les volumes.

## Calques du bas vers le haut

| # | Fonction | Cadence |
|---|---|---|
| 00 | Sol complet | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres déjà dessinées au sol | fixe |
| 03 | Talus et gravats | fixe |
| 04 | Parois et détails rocheux | fixe |
| 05 | Poussière au vent | 24×5 ticks |
| 06 | Top vide (`Layer=4`) | — |

Boucle 120 ticks, 2 s à 60 ticks/s. Alpha binaire, RGB nuls sous alpha nul, pas de magenta résiduel.
ORA ordonné : première phase de chaque animation, pas un fichier d'animation temporelle.
Loi : `k=(t+phase)%24 ; visible k<18 ; x=x0+k-9 ; y=y0+round(2 sin(2 pi k/18))`. Un effet calculé aux couleurs du rip n'est pas une animation officielle.

## Accès

`entrance` au sud, `boss` au centre (aucun Pokémon choisi), `objectif` contre le pied de paroi nord. **Aucune sortie, aucun warp, pas de donjon_seuil.**

Passage 16×16 vérifié sur la grille. Parois et talus bloqués. Vue de contrôle
`review/FDR1_collisions_marqueurs.png`. **À contrôler en jeu.**

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/fin_defile_roches_grises_v1/requirements.txt
.venv/bin/python source/fin_defile_roches_grises_v1/build.py
.venv/bin/python -m unittest source.fin_defile_roches_grises_v1.test_build -v
.venv/bin/python source/fin_defile_roches_grises_v1/verify.py
.venv/bin/python source/fin_defile_roches_grises_v1/package.py
```

Le build fonctionne hors ligne avec ce checkout : bruts, référence et gabarit 0.8.12 sont présents.
Code commun : `source/maps_suite_v1/`. Helpers bas niveau chargés dans une instance isolée depuis
`source/entree_defile_roches_grises_v1/build.py` ; **EDR1 n'est pas modifié**. Les codecs partagés
restent `source/pmdo_cote/`. Aucun ZIP historique absent n'est requis.
Les tests relisent les vrais octets des banques générées et reconstruisent les images via le Ground.
Ce n'est pas le chargeur du moteur. Les mutations sont effectuées dans des copies temporaires.

## Livraison et import

Sorties : `renders/fin_defile_roches_grises_v1/`, staging : `.cache/fin_defile_roches_grises_v1/fin_defile_roches_grises/`.
ZIP projet `FDR1_projet_pmdo_0812.zip`, ZIP calques `FDR1_calques_png_8px.zip`, `index.html` autonome.
Les rendus, archives et HTML ne sont pas versionnés : relancer build puis package après reprise.

Copier le dossier `fin_defile_roches_grises` du ZIP projet dans `PMDO/MODS/`, activer le mod puis ouvrir
le Ground. Pour fusionner dans un mod existant : extraire le ZIP entier, fermer PMDO, lancer
`python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run` puis sans `--dry-run`.
L'installateur fusionne l'index, en conserve une sauvegarde et refuse les fichiers modifiés.
Import PNG manuel : **PNG to Tileset, 8 px**, aucune mise à l'échelle, garder les noms `FDR1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Aucun test de l'éditeur, du rendu ou du déplacement en jeu n'a été effectué pour ce lot.
La fidélité chromatique et la reconstruction des textures ne remplacent pas cette validation.
Les collisions sont conservatrices et issues d'une découpe de composition, à revoir dans PMDO.
