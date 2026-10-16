# FFF1 — Clairière finale de la Forêt de feuillus

Base d'édition PMDO 0.8.12, **768×576 px**, **96×72 cases de 8 px** (`TexSize=1`).
Namespace `fin_foret_feuillus_v1`, Ground `fff1_fin_foret_feuillus`, banques graphiques `FFF1_*`.

## Intention et origine

Après « passe a la suite », nouvelle fin assortie à l'entrée EFF1 : clairière plus ouverte,
terre nue centrale, herbe et arbres feuillus, arrivée sud, lisière forestière nord bloquante.
Aucune grotte, structure, artefact ou sortie ajouté. Aucun boss choisi ou scénario inventé.
Cette poursuite ne vaut pas approbation artistique de l'entrée ou de la fin.

Référence ROM D24P11A, 504×432, une frame, deux couches, aucun BPA ni animation de palette.
Provenance pret/pmd-sky c8073235b39746a7ee74e6cea16c730bd91a1e67, rendu skytemple-files 1.8.5,
empreintes et blobs Git dans `reference/provenance.json`, copiés d'EFF1 avec le rip.
Le nom forestier est descriptif, pas une identification officielle du code ROM.

Rip **réellement fourni au générateur en `images=`**, avec le décor EFF1 comme seconde référence.
Nouveau décor 1200×896. Premier appel sans image, reprise réussie ; prompts exacts et hashes
conservés dans `generation.json`. Le support d'herbe est copié byte-à-byte d'EFF1, explicitement
déclaré : ce n'est pas une nouvelle génération. Il n'est pas aligné avec le décor de la fin.
Le sol visible vient du nouveau décor ; le support n'est qu'un fond opaque sous les objets.

**Terrain généré référencé, pas des pixels officiels extraits de la ROM.** Formats et grille
natifs seulement. Pas de mosaïque de bouts de maps ni de recoloration des bruts.
L'herbe et la terre nue générées sont assez plates par endroits : ne pas revendiquer une
texture riche ou une validation artistique que le prompt seul ne garantit pas.

## Calques et méthode

Huit calques du bas vers le haut, puis Top vide (`DrawLayer.Top=4`) :

1. Sol complet — support d'herbe indépendant.
2. Herbe — herbe et petites plantes du sol praticable.
3. Terre nue — plaque centrale et approche, pas de chemin traversant au nord.
4. Ombres — zones déjà sombres du sol, pas un voile ajouté.
5. Sous-bois — bande de lisière bloquante.
6. Troncs/racines — tons chauds hors sol praticable.
7. Feuillage — végétation extérieure restante.
8. Feuilles animées — effet indépendant calculé.

Petites fleurs/fougères conservées avec herbe/ombres ; pas de faux détourage promis.
Pas de calque de profondeur sur cette fin : aucun remplissage noir ou fausse bouche nord.
Contour de sol mesuré sur le nouveau brut dans `config.json`, pas repris de la géométrie EFF1.
Réduction BOX pondérée par classe à facteur uniforme 576/896, largeur 771 puis crop centré 768
(1 px à gauche, 2 à droite), palette terrain commune 96 sans dither. Alpha binaire et RGB nuls
sous transparence ; partition sans trou ni chevauchement. Aucun ancien lot/helper commun modifié.

Diagnostic chromatique identique à EFF1, sur rip/brut/sorties :
sol chaud = R>120, G>80, 15<R-G<95, G-B>30, B<140 ; végétation = G>1,1R, G>1,25B, G>50, B<160.
Seuil RGB moyen 35, sans assouplissement ni recalage de couleur. La mesure ne certifie ni les
raccords, ni les volumes, ni l'échelle en jeu. Le nom `dust` du manifeste est hérité du schéma
technique commun ; son `label` décrit bien des feuilles calculées, pas de la poussière.

## Animation et marqueurs

Même loi de feuilles qu'EFF1 : 24 émetteurs déterministes, 24 phases×5 ticks, boucle 2 s.
`k=(t+phase)%24`, visible k<18 ; `x=x0+round(4 sin(2 pi k/18))`, `y=y0+k-9` ; trois pixels
aux décalages (0,0),(1,0),(1,1), couleurs vertes exactes du rip, clipping hors sol praticable.
**Dessin et loi inventés, pas une animation officielle** ; le rip est statique.

Trois marqueurs : `entrance` au sud, `boss` central non nommé, `objectif` devant la lisière nord.
Le marqueur `boss` est un repère d'édition, pas un Pokémon instancié. Chemins avec dégagement
16×16, centre éloigné des bords ; aucune sortie, aucun `donjon_seuil`, warp, PNJ ou destination.
Collisions conservatrices aux lisières, à contrôler dans le moteur.

## Contrôles techniques exécutés

**14 tests PASS**, dont cinq mutations rejetées, et **31 images reconstruites exactement** depuis
huit banques natives. Fidélité couleur finale, seuil 35 : **sol 6,17 ; végétation 19,95**.
Marqueurs : arrivée `[384,560]`, boss `[424,344]`, objectif `[384,192]`, accès avec dégagement
16×16. Test de correspondance avec EFF1 : mêmes règles couleur et loi d'animation ; support
copié et seconde référence vérifiés par empreinte. Ce n'est pas une validation moteur.

## Reproduire depuis la racine

```sh
python -m venv .venv
.venv/bin/pip install -r source/fin_foret_feuillus_v1/requirements.txt
.venv/bin/python source/fin_foret_feuillus_v1/build.py
.venv/bin/python -m unittest source.fin_foret_feuillus_v1.test_build -v
.venv/bin/python source/fin_foret_feuillus_v1/verify.py
.venv/bin/python source/fin_foret_feuillus_v1/check_reproducibility.py
.venv/bin/python source/fin_foret_feuillus_v1/package.py
```

Utiliser le build dédié, pas la CLI générique minérale. Build hors ligne avec les bruts
versionnés ; codecs `source/pmdo_cote/`, helpers EDR1 dans une instance isolée et gabarit réel
0.8.12 sous `source/cote_v5_expeditions/references/`. Le vérificateur indépendant relit les PNG
des banques .tile et reconstruit depuis le Ground : **ce n'est pas le vrai chargeur PMDO**.
Mutations réalisées dans des copies temporaires, jamais sur les livrables.

## Livrer et installer

Sorties régénérables dans `renders/fin_foret_feuillus_v1/`, staging sous `.cache/`.
`FFF1_projet_pmdo_0812.zip`, `FFF1_calques_png_8px.zip`, `index.html` autonome, PNG/ORA et contrôles.
Médias lourds ignorés par Git ; build puis package pour les retrouver après reprise.
Extraire le dossier du ZIP projet dans `PMDO/MODS/`, activer puis ouvrir le Ground.
Fusion dans un mod : fermer PMDO, extraire le ZIP puis `python INSTALLER.py /chemin/mod --dry-run`
et sans `--dry-run`. Index fusionné avec sauvegarde, fichiers utilisateur modifiés protégés.
Import PNG manuel : PNG to Tileset, **8 px**, sans redimensionnement, noms uniques `FFF1_*`.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Aucun test du chargeur réel, de l'éditeur, du rendu, de la caméra/échelle ou des déplacements.
Les tests Python ne remplacent ni l'avis visuel ni un contrôle PMDO. Résultats dans `STATUS.md`.
