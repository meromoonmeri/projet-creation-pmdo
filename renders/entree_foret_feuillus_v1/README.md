# EFF1 — Entrée de la Forêt de feuillus

Nouvelle proposition forestière après la demande « continue des biome forestier etc ».
La carte des Schistes bleus est rejetée et le col de sable laissé de côté. Aucun de ces deux
décors n'est réutilisé. Cette poursuite ne signifie pas une approbation artistique d'EFF1.

## Référence et origine des pixels

Rip D24P11A, 504×432, pret/pmd-sky commit c8073235b39746a7ee74e6cea16c730bd91a1e67.
Rendu skytemple-files 1.8.5, sans collisions dessinées : une frame, deux couches, aucun BPA ni
animation de palette. Provenance et empreintes des blobs dans `reference/provenance.json`.
Le nom de biome est descriptif, pas une identification officielle du code ROM.

Deux bruts générés avec ce rip réellement fourni en `images=` : décor et herbe support,
1200×896 chacun. Prompts exacts et reprise de l'appel sans image dans `generation.json`.
Le chemin garde l'aspect de terre dallée du rip et l'arrivée est moins large que demandé au
prompt. Ne pas faire passer les intentions du prompt pour des caractéristiques mesurées.
**Terrain généré référencé, pas des pixels officiels extraits.** Seuls la grille et les formats
sont natifs. Pas de recoloration des bruts ni d'assemblage de bouts de maps ROM.

## Format et calques

PMDO 0.8.12, 768×576, 96×72 cases de 8 px (`TexSize=1`).
Namespace `entree_foret_feuillus_v1`, Ground `eff1_entree_foret_feuillus`, graphiques `EFF1_*`.
Calques, du bas vers le haut : sol complet, herbe, chemin, ombres existantes, sous-bois,
troncs, feuillage, profondeur dessinée, feuilles animées ; puis Top vide (`DrawLayer.Top=4`).
Les petites fleurs et fougères du sol restent dans herbe/ombres ; pas de faux détourage promis.
Le feuillage inclut la canopée et les autres plantes extérieures hors bande de sous-bois.
Les troncs et racines sont isolés par leurs tons chauds hors du sol praticable.

Le support d'herbe est indépendant et non aligné, invisible sous le terrain final. Profondeur
nord dessinée par le générateur, sans remplacement par un aplat noir. Contours mesurés dans
`config.json`, réduction BOX pondérée par classe à facteur uniforme 576/896, largeur 771 puis
crop centré 768 (1 px à gauche, 2 à droite). Terrain quantifié en palette commune 96 couleurs,
profondeur quantifiée séparément ; sans dither. Alpha binaire, RGB nuls sous transparence.
Aucun changement du pipeline partagé ou des anciens lots.

Diagnostic couleur identique sur rip, brut et sorties :
- sol chaud : R>120, G>80, 15<R-G<95, G-B>30, B<140 ;
- végétation : G>1,1R, G>1,25B, G>50, B<160.
Seuil de distance RGB moyenne 35, sans recalage de couleur. Ce n'est pas une preuve de raccords,
de volume, d'identité des pixels ou d'échelle en jeu.

## Animation et accès

Feuilles **calculées**, pas animation ROM : 24 émetteurs déterministes, 24 phases×5 ticks,
boucle 2 s. `k=(t+phase)%24`, visible k<18, `x=x0+round(4 sin(2 pi k/18))`, `y=y0+k-9`.
Forme de 3 pixels (0,0),(1,0),(1,1), couleurs vertes exactes du rip ; clipping au sol praticable.
Pas de rayons, voile de brume ou scintillements ajoutés.

Arrivée sud et seuil nord, chemins sur grille avec dégagement 16×16. Le seuil est un marqueur,
pas un téléporteur : aucun warp, boss, PNJ, destination ou aventure jouable raccordée.
Collisions conservatrices aux lisières, à tester dans le vrai moteur.

## Contrôles techniques exécutés

**14 tests PASS**, dont cinq mutations rejetées ; **32 images reconstruites exactement** depuis
neuf banques natives. Fidélité couleur finale : sol **34,23** (proche du seuil 35), végétation
**24,04**. Le rendu est plus jaune et saturé que la référence ; cette mesure n'est pas une
approbation artistique. Arrivée `[384,560]`, seuil `[384,160]`, chemin avec dégagement 16×16.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/entree_foret_feuillus_v1/requirements.txt
.venv/bin/python source/entree_foret_feuillus_v1/build.py
.venv/bin/python -m unittest source.entree_foret_feuillus_v1.test_build -v
.venv/bin/python source/entree_foret_feuillus_v1/verify.py
.venv/bin/python source/entree_foret_feuillus_v1/check_reproducibility.py
.venv/bin/python source/entree_foret_feuillus_v1/package.py
```

Utiliser le build de ce lot, pas la CLI générique des cartes minérales. Codecs PMDO de
`source/pmdo_cote/`, helpers EDR1 chargés dans une instance isolée, gabarit réel 0.8.12 conservé
sous `source/cote_v5_expeditions/references/`. Build hors ligne avec les bruts versionnés.
Vérificateur : relit indépendamment les banques .tile et reconstruit depuis le Ground ;
ce n'est pas le chargeur PMDO. Mutations dans des copies temporaires uniquement.

## Livrer et installer

Sorties régénérables dans `renders/entree_foret_feuillus_v1/`, staging sous `.cache/`.
ZIP projet natif `EFF1_projet_pmdo_0812.zip`, PNG/ORA `EFF1_calques_png_8px.zip`, `index.html`.
PNG, WebP, ZIP, ORA et HTML restent ignorés par Git, sources et bruts conservés.
Extraire le dossier du ZIP projet dans `PMDO/MODS/`, activer le mod et ouvrir le Ground.
Fusion dans un mod : fermer PMDO, extraire le ZIP, lancer `python INSTALLER.py /chemin/mod --dry-run`
puis sans `--dry-run`. Index fusionné avec sauvegarde, refus d'écraser un fichier modifié.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms `EFF1_*` uniques.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni chargeur réel, ni éditeur, ni rendu, caméra/échelle ou déplacements en jeu testés.
Les tests Python ne remplacent pas l'avis artistique ni le contrôle dans PMDO.
Résultats effectivement exécutés et prochaine étape : `STATUS.md`.
