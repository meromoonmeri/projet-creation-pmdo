# FAD1 — Fin des Aiguilles dorées

Projet d'édition **PMDO 0.8.12**, **768 × 576 px**, 4:3 vaste, **96 × 72 cases de 8 px** (`TexSize=1`).
Namespace `fin_aiguilles_dorees`, Ground `fad1_fin_aiguilles_dorees`. Préfixe graphique unique `FAD1`.

## Intention et référence

La demande « contonu » poursuit la série après FDR1. L'agent choisit une fin assortie à l'entrée
immersive EAD2 : immense chambre souterraine, sable ocre, aiguilles et stalactites, paroi nord fermée.
Ni l'entrée ni la fin ne sont considérées approuvées artistiquement du seul fait de cette poursuite.

La référence canonique **D14P12A** et le décor EAD2 sont réellement fournis au générateur.
La première fixe la matière et la palette, le second la cohérence avec l'entrée ; le layout de la
fin est nouveau, pas une copie étirée. Nom de biome descriptif, pas une identification officielle
inférée du code Dnn. Le rip est rendu depuis `pret/pmd-sky`, commit
`c8073235b39746a7ee74e6cea16c730bd91a1e67`, avec skytemple-files 1.8.5 ; code, blobs Git,
SHA-256 et métadonnées dans `reference/provenance.json`.

Le rendu ROM comporte quatre frames ; ses colonnes lumineuses et orbes ne sont **pas** repris.
La poussière est notre propre effet calculé aux couleurs du rip, pas une animation officielle.
Le décor est plein cadre, sans estrade, sceau, porte ou sortie nord, sans boss nommé ni PNJ.

## Pipeline et origine des pixels

Terrain **généré référencé**, pas extraction de pixels ROM. « Natif » qualifie les formats et la
grille, pas l'origine du dessin. Prompts exacts et références dans `generation.json`.

- Décor à 1200×896, contour de sol relevé sur ce brut dans `config.json` ; les rochers latéraux
  restent bloqués, y compris leurs pieds. La découpe conserve une marge de sécurité.
- Sol complet généré réutilisé **byte-à-byte depuis EAD2** comme support sous les masses,
  sans nouvelle génération ni alignement prétendu entre les deux compositions. Le sol visible
  est extrait du nouveau décor FAD1.
- Réduction BOX pondérée par matière, vote maximal, facteur uniforme 576/896 ; largeur arrondie
  à 771 puis recadrage centré à 768. Aucun étirement ni mélange entre classes.
- Palette commune de 96 couleurs sans dither. Ombres présentes au sol séparées par luminance.
  Alpha binaire, RGB nuls sous transparence. Aucun magenta : cette chambre est entièrement solide.
- Les aiguilles restent dans les masses rocheuses ; pas de faux calque de profondeur sur une fin sèche.

## Correction des marges et contrôles

Le premier essai est conservé dans `bruts/essais/decor_marges_sombres.png` : son coin haut-gauche
échouait au garde-fou de texture plein cadre (écart-type 6,64, minimum >10). Une correction
référencée remplace ces marges par de la roche, sans assouplir le test. Les deux prompts exacts,
les références et empreintes sont dans `generation.json`.

Fidélité chromatique finale : **sol 13,69 ; roche 13,04**, seuil 35. **13 tests Python PASS**, dont
cinq mutations, et **29 images reconstruites exactement** depuis le Ground et six banques natives.
Marqueurs : arrivée `[384,560]`, boss `[408,360]`, objectif `[384,224]`. Boss non nommé ; aucun warp.
Ces contrôles techniques ne valent pas approbation artistique ni test moteur.

## Calques du bas vers le haut

| # | Fonction | Animation |
|---|---|---|
| 00 | Sol complet, support continu sous les masses | fixe |
| 01 | Sol praticable | fixe |
| 02 | Ombres déjà dessinées au sol | fixe |
| 03 | Talus et pieds de rochers | fixe |
| 04 | Parois, aiguilles et stalactites | fixe |
| 05 | Poussière calcaire qui tombe | 24 × 5 ticks |
| 06 | Top vide, `Layer=4` | — |

Boucle **120 ticks, 2 s à 60 ticks/s**. Poussière : `k=(t+phase)%24`, visible pour `k<18`,
`x=x0+round(2 sin(2πk/18))`, `y=y0+k-9`, puis repos. Couleurs exactes du rip ; loi et dessin inventés.
L'ORA conserve les calques dans le bon ordre, première phase des animations uniquement.

## Accès

`entrance` au sud, `boss` au centre (aucun Pokémon choisi), `objectif` au pied de la paroi nord.
Chemins sur grille avec dégagement **16 × 16 px**, boss éloigné des parois. **Aucun warp, aucune
sortie, aucun `donjon_seuil`, aucune destination liée.** Vue de contrôle :
`review/FAD1_collisions_marqueurs.png`. Collisions conservatrices, à contrôler dans PMDO.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/fin_aiguilles_dorees_v1/requirements.txt
.venv/bin/python source/fin_aiguilles_dorees_v1/build.py
.venv/bin/python -m unittest source.fin_aiguilles_dorees_v1.test_build -v
.venv/bin/python source/fin_aiguilles_dorees_v1/verify.py
.venv/bin/python source/fin_aiguilles_dorees_v1/package.py
```

Build hors ligne avec les fichiers versionnés : `source/maps_suite_v1/pipeline.py` charge les
helpers EDR1 dans une instance isolée ; codecs `source/pmdo_cote/`. Aucune modification des lots
antérieurs, aucun ZIP historique absent requis. Un gabarit réel 0.8.12 fournit le schéma ; ses
anciens graphiques, entités, décorations et collisions sont remplacés.

Le vérificateur indépendant relit les PNG contenus dans les banques `.tile` et reconstruit les
images via le Ground. Ce n'est pas le chargeur PMDO. Mutations réalisées dans des copies temporaires.

## Livrer et installer

Sorties régénérables dans `renders/fin_aiguilles_dorees_v1/`, staging dans
`.cache/fin_aiguilles_dorees_v1/fin_aiguilles_dorees/`.
ZIP projet `FAD1_projet_pmdo_0812.zip`, ZIP calques/ORA `FAD1_calques_png_8px.zip`, aperçu `index.html`.
Les rendus, archives et HTML restent ignorés par Git : relancer build puis package après reprise.

Copier le dossier du ZIP projet dans `PMDO/MODS/`, activer le mod puis ouvrir le Ground.
Pour fusionner dans un mod existant : fermer PMDO, extraire tout le ZIP, lancer
`python INSTALLER.py /chemin/PMDO/MODS/mon_mod --dry-run` puis sans `--dry-run`.
L'index est fusionné avec sauvegarde ; les fichiers modifiés ne sont pas écrasés.
Import PNG manuel : **PNG to Tileset, 8 px**, sans redimensionnement, garder les noms `FAD1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni le vrai chargeur, ni l'éditeur graphique, ni le rendu et le déplacement en jeu n'ont été
exécutés sur ce lot. La fidélité publiée mesure les couleurs, pas les volumes ou les raccords.
Les tests techniques ne remplacent pas l'avis artistique ni le contrôle de l'échelle dans PMDO.
