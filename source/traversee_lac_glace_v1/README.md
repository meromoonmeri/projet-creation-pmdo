# TLG1 — Lac des Roches givrées

Demande « Passe a la prochaine map » après correction de fidélité du col. **Nouvelle composition
du biome glacé**, pas une nouvelle retouche du col. Celui-ci reste une proposition suspendue,
sans export natif. Une demande de suite ne valide artistiquement ni le col ni les anciens lots.

L'utilisateur a clarifié « textures canoniques » : **générateur beaucoup plus fidèle au rip**,
pas reconstruction en pixels officiels exacts. Ici les références sont réellement fournies
au générateur ; les pixels restent générés. Pas d'assemblage de fragments de maps.

## Références réellement utilisées

pret/pmd-sky `c8073235b39746a7ee74e6cea16c730bd91a1e67` :

- **D53P11B**, entrée130,504×360,2couches,aucunBPA,une image,pas animation palette. Rip examiné
  pour la neige, roche bleu-gris, grain et échelle. PNG/provenance copiés byte-identiques de
  l'extraction du col ; aucune texture générée du col fournie pour éviter de reprendre son style.
- **D52P11C**, entrée126,504×408,2couches,aucunBPA,une image,pas animation palette. Nouvelle
  extraction par extract_reference.py, sans écraser l'index ROM global. Crop de sol
  **[15,220,490,282]**, non agrandi, pour les teintes du sol bleu, pas les cristaux/layout.
  La feuille complète et les hashes BMA/BPC/BPL/table sont conservés dans reference/.

**Le lac est inventé**, pas un lac officiellement extrait de ces rips. Aucun nom officiel de
lieu déduit du numéro ROM. Pas de forêt recolorée, ancienne map collée ou référence générée.
Deux appels générateur réussis : décor1200×896 et nouveau support de neige1200×896. Prompts
exacts, références, SHA et dimensions dans generation.json. Les effets n'étaient pas dessinés
sur le terrain : pistes calculées à part, pas animation BPL/BPA officielle.

Dix branches distantes consultées, arbres non tronqués, noms de chemins dans branch_review.json.
Anciens lieux glacés déjà présents ; pas de revendication d'inédit absolu ni de comparaison
exhaustive des images. Aucune fusion/changement de branche. Namespace `traversee_lac_glace_v1`,
préfixe TLG1, Ground `tlg1_traversee_lac_glace`.

## Calques et masque jouable

**768×576,96×72 cases de8px,TexSize1. Neuf calques+Top vide** : support complet, neige, ombres,
berges, reliefs, lac gelé solide, profondeur nord-est dessinée, reflets, flocons.
Les caps de neige des rochers restent avec leurs reliefs : **zones fonctionnelles, pas détourage
parfait des objets**. Support généré non aligné, sous la partition complète ; surface visible
issue du décor. Aucun ajout de pont/chemin peint pour rendre les accès possibles.

Le **lac est une plaque SOLIDE traversable**, non de l'eau liquide : pas de déplacement de
surface ni de fonte. Enveloppe relevée élargie24px bruts comme zone de recherche, composante
connexe de teinte froide 100<R<210,G>145,B>185,B>R+12,G>R+5 ; trous internes comblés, fissures
visuelles sans vide. L'élargissement sert au masque, ne repeint pas les pixels du terrain.
Neige : enveloppe du nouveau décor et médianeR5px>160, plus grande composante avec lac inclus.
Bords externes12px bloquants, ombres par luminance moyenne5px<215, berges12px bloquantes.
Les autres plates-formes restent conservativement bloquées.

Premier masque coupait une petite partie de la glace au sud. Contour puis recherche de teinte
corrigés, trois points de glace de la rive sud ajoutés aux tests. Scène et collisions finales
inspectées ; tests/reproductibilité/paquets rejoués **après** cette correction.

Réduction BOX pondérée par classe avant quantification96 sans dither, profondeur séparée.
Facteur uniforme576/896, largeur771 recadrée à768 (1pxgauche/2droite), pas étirement/recoloration.
Alpha0/255 et RGB0 sous alpha0. Neige/roche/lac générés, seuls formats/grille natifs.

## Animations et accès

Deux pistes24×5ticks chacune, boucle120ticks/2s :

- **Reflets** :28positions déterministes dans érosion3px du lac, k=(t+phase)%24, visibles k<8,
  niveau=min(k,7−k,3), un pixel sauf niveaux3 (croix5pixels), clip au lac. Quatre couleurs
  exactes du rip D53P11B. Reflets ajoutés, pas de recoloration/cycle de palette du terrain.
- **Flocons** :64émetteurs graine171026, k=(t+phase)%24, visibles k<18,
  x=x0+round(4sin(2πk/18)),y=y0+2k ; deux pixels verticaux, couleurs[min(k,17−k,3)].
  Six phases invisibles pour le retour, pas de téléportation d'un flocon encore visible,
  accumulation/physique/vent réaliste ou sprites officiels. Météo discrète sur toute la scène.

Arrivée **[384,560]**, seuil nord-est **[696,40]** ; chemin16×16 vérifié à travers la glace et la
neige. Aucun warp, destination, PNJ, Pokémon, boss, objet ou aventure raccordée.

## Contrôles effectivement exécutés

**17tests PASS**, dont **six mutations** : pixel PNG, warp, collision, marqueur, reflet hors lac,
reflets figés. Lecteur indépendant de l'encodeur : **55reconstructions exactes depuis9banques**,
index/PNG/Ground/alpha/cadences/Top vide/entités/collisions. Oracles scalaires des deux effets,
pixels/ordre ORA, boucle WebP2s, coins texturés, crop et hashes source contrôlés. Ce lecteur n'est
pas le chargeur PMDO. Installateur testé sur copies : dry-run sans écriture, fusion10banques
avec EXISTANT, sauvegarde/idempotence et refus d'écraser un Ground modifié par l'utilisateur.

**Deux builds complets identiques,93fichiers/membresORA,0diff**. Rapport reproducibilite.json,
hors horodatages ZIP, archives/HTML/rapports hors build. Régression marais EMB1 : **19tests PASS**.
Anciens helpers/assets non modifiés ; nouvelle météo copiée de l'ébauche du col, puis testée ici,
sans dépendance d'exécution à cette ébauche. Codecs/réduction/pipeline/installer parents réutilisés.

Diagnostic de familles neige/roche, mêmes filtres rip/brut/sortie, seuil35 : neige R>190,G>210,B>230 ;
roche30<R<150,60<G<160,100<B<220,G>R+10,B>G+10. PlafondG limite la contribution du lac bleu clair,
mais **ces filtres ne détourent pas les objets**. Brut14,84/15,62 ; sortie14,75/19,16. Diagnostic
adapté à ces matières, pas comparable aux anciennes familles du col/marais/volcan, ni preuve de
textures officielles, conformité du lac, grain, volumes, raccords ou fidélité artistique.
La génération reste interprétative : grain parfois plus doux que le rip et lac assez vaste.

## Reproduire et installer

```sh
.venv/bin/pip install -r source/traversee_lac_glace_v1/requirements.txt
.venv/bin/python -m source.traversee_lac_glace_v1.build
.venv/bin/python -m source.traversee_lac_glace_v1.check_reproducibility
.venv/bin/python -m source.traversee_lac_glace_v1.package
```

Les bruts/rips sont versionnés, build normal hors ligne. L'extracteur optionnel requiert gh et
skytemple-files1.8.5 ; ne régénère que D52P11C, D53P11B provient de l'extraction du col conservée.
Sorties `renders/traversee_lac_glace_v1/` : **TLG1_projet_pmdo_0812.zip**, **TLG1_calques_png_8px.zip**,
ORA, PNG, WebP, masques, rapports et index.html autonome. Voir README_PACK.md pour l'import.
Import PNG manuel à **8px**, sans redimensionnement. Les ZIP doivent accompagner le HTML pour
ses liens de téléchargement. Servir uniquement le dossier de sortie, bind0.0.0.0, port8013.
Médias de sortie ignorés par Git, sources/bruts/provenance/rapports versionnés.

**art_approved=false, runtime_tested=false, render_tested=false**. Ni vrai chargeur, éditeur,
caméra/échelle, rendu ou déplacements PMDO exécutés sur ce lot. Avis visuel et test réel attendus.
