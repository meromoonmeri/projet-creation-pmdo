# EMB1 — Entrée des Marais brumeux

L'utilisateur demande de passer au biome suivant puis choisit **marais**. Première entrée
indépendante de ce biome : grandes masses d'arbres bleutés, racines tortueuses, deux bassins
asymétriques, îlot décoratif et chemin de vase sec sud→nord. Pas de reprise des colonnes volcaniques.
Les anciens lots sont conservés, sans fusion de branche. Ce changement ne les approuve pas.

## Référence vérifiée, nouveau lieu inventé

Feuille **Murky Forest & Armaldo House**, PMD Explorers of Sky, rippée par **Haalfpack / Noctowl2000**
(attribution lisible sur la feuille, Spriters Resource59171 selon l'historique du dépôt).
Téléchargée du blob Git `b6a7b2c4312b3ff33db9526e739538e01f74bf16` de
`meromoonmeri/projet-pmdo` au commit `54d373157840500f7a8baacc723ae30f817fad8c`.
Feuille1162×697, SHA256 `72d17b72012d545e7ed2699152d1c422afdec56c253485b3f0885076bb01c8d1`,
identique au sources.json historique. Feuille complète avec crédits conservée.

Guide : crop **[0,0,400,312]**, sans recoloration, agrandissement ni filtre de nuit/Abyss.
Égalité pixel-à-pixel contrôlée avec le murky.png historique du présent dépôt.
Ce n'est **pas une nouvelle extraction ROM** ; aucun code BMA ni cadence officielle inférés.
Guide lu avant génération, réellement fourni dans `images=` à chacun des trois appels.

Trois nouvelles générations réussies au premier appel : décor1200×896, support de vase1200×896,
ruban de brume sur magenta1200×896. Prompts exacts, références, dimensions et SHA dans generation.json.
Aucun collage de morceaux de maps ou ancienne forêt recolorée. **Le marais est inventé** depuis
une référence forestière ; son eau et sa brume ne sont pas attribuées au jeu officiel.
Les pixels générés restent générés : natif décrit les formats/grille, pas une origine ROM.

Audit préliminaire des **dix branches distantes**, arbres non tronqués, dans branch_review.json.
Des références et anciens projets Murky existent déjà ; pas de revendication d'inédit absolu.
Audit des noms de chemins, pas de tous les visuels. Aucune fusion ni changement de branche.
Namespace `entree_marais_brumeux_v1`, préfixe EMB1, asset `emb1_entree_marais_brumeux`.

## Calques et traitement

**768×576 /96×72 cases de8px /TexSize1. Neuf calques +Top vide** :

1. Sol complet, nouveau support de vase non aligné, texture indépendante sous la partition.
2. Vase praticable.
3. Teintes sombres déjà présentes dans le sol, pas un voile ajouté.
4. Berges, bande12px bruts autour du passage.
5. Racines/troncs, familles violettes hors passage.
6. Feuillage/roseaux et reste du décor.
7. Prolongement forestier nord dessiné et bloquant, pas un trou noir.
8. Eau animée.
9. Brume animée.

Masques fonctionnels, **pas détourage parfait des objets**. Contours du passage relevés sur ce
nouveau décor, ombres selon luminance moyennée sur5px <69. Eau : deux zones et graines de
composantes connexes, G>R+18, B>R+24, G>=.8B, R<75, G<115. Seuls petits trous<1000px comblés,
**îlot conservé** ; pas fill_holes global qui transformerait l'îlot en eau. Configuration complète
versionnée. Les autres zones sèches restent bloquées conservativement.

Réduction BOX pondérée par classe avant palette commune96 sans dither. Facteur uniforme576/896,
largeur771 recadrée à768 (1px gauche,2droite). Pas étirement, peinture ou recoloration du terrain.
Alpha0/255, RGB nuls sous transparence. La vase violette est un matériau légitime : la garde de
fuite magenta vise la clef **R>170,B>170,G<100**, pas toutes les teintes pourpres comme dans les
anciens lots gris. Le détourage du sprite emploie une clef plus large par rapports de canaux.

Diagnostic défini avant génération, mêmes filtres rip/brut/sortie, seuil35 : famille vase
45<R<155,R>G+5,B>G+3,|R-B|<35 ; famille bleue dite feuillage B>R+12,G>R+8,B>G+3,G>35.
**Ces familles ne sont pas des masques d'objets : l'eau peut aussi contribuer au filtre bleu.**
Sortie8,09/16,54, brut11,42/15,71. Ce n'est ni une mesure officielle de l'eau ni certification de
textures, volumes, raccords, palette complète ou conformité artistique ; non comparable au volcan.

## Deux animations indépendantes

- **Eau** : pixels de la nouvelle eau générée ondulés, rives3px et alpha fixes, phase0 identité.
  Appel de `ETV1.Map.lava_frame` inchangé, recette mathématique générique appliquée à cette eau,
  **aucun pixel/sprite de lave réutilisé**. Déplacements périodiques sin/cos±4px, source la plus
  proche dans le masque ; pas écoulement net, simulation physique ou BPL officiel.
- **Brume** : nouveau sprite sur magenta, crop à sa silhouette, BOX pondéré, palette32 issue du
  sprite, trame alpha `(x+2*y)%4==0` (25% des positions, pas opacité moteur). Quatre placements,
  deux miroirs du sprite généré ; pas de transformation d'un sprite canonique. Translation
  `dx=round(6sinθ),dy=round(2(cosθ−1))`, θ=2π(t%24)/24. Respiration oscillante, pas transport net.
  Pas de wrap à l'autre bord, clip strict à l'eau : **le passage reste visible à chaque phase**.
  Ruban assez stylisé/tramé et eau sobre, avis visuel attendu.

Chaque piste : **24×5ticks**, boucle120ticks/2s. L'ORA contient les phases0, les PNG toutes les phases.
Textures, positions, couleurs et lois réellement utilisées figurent dans le manifest.

## Vérification effectivement exécutée

**19 tests PASS, dont sept mutations rejetées**, oracles indépendants pour déplacements de l'eau
et translations de brume, masques, source du sprite, palette, boucle/cadences, coins texturés,
profondeur dessinée, hashes, ORA, arrivée/seuil et accès16×16. Installateur testé sur copies :
dry-run sans écriture, fusion10banques avec EXISTANT, sauvegarde/idempotence, refus d'écraser
un Ground modifié par l'utilisateur. Ancien lot ETV1 : **17tests de régression PASS**.

Vérificateur indépendant : relit chaque banque et reconstruit **55images depuis neuf banques**
et le Ground, compare les PNG exportés, index, grille, accès16px et collisions. Top vide,
aucun objet/PNJ/boss instancié. Arrivée[384,560], seuil[384,120], **aucun warp/destination**.
Ce lecteur Python n'est pas le vrai chargeur PMDO.

Reproductibilité réellement rejouée : **deux builds complets**, **94fichiers/membresORA identiques**,
horodatages ZIP exclus. Ne couvre pas archives/HTML/rapports hors build ni d'autres plateformes.
CRC/comptes/racines/doublons/caches ZIP contrôlés. SyntaxeJS/données de galerie contrôlées,
pas test automatisé des interactions navigateur. Scène finale, collisions et sprite inspectés.

## Reproduire et livrer

```sh
.venv/bin/pip install -r source/entree_marais_brumeux_v1/requirements.txt
.venv/bin/python -m source.entree_marais_brumeux_v1.build
.venv/bin/python -m source.entree_marais_brumeux_v1.check_reproducibility
.venv/bin/python -m source.entree_marais_brumeux_v1.package
```

Les anciens helpers sont réutilisés sans modification : pipeline maps_suite_v1, réduction/codec
EDR1, INSTALLER pmdo_cote et loi d'ondulation ETV1. Les bruts et le guide sont versionnés :
aucun accès réseau/skytemple n'est requis pour le build normal.

Sorties `renders/entree_marais_brumeux_v1/` : **EMB1_projet_pmdo_0812.zip** (projet autonome,
9banques/1Ground), **EMB1_calques_png_8px.zip** (PNG, ORA, masques, contrôles et sprite original),
`index.html` autonome (servir avec les ZIP pour télécharger), scènePNG et WebP animé.
Notice d'installation README_PACK.md. Import PNG manuel : **8px**, sans redimensionnement.
Serveur d'aperçu : `python -m http.server 8012 --bind 0.0.0.0 --directory renders/entree_marais_brumeux_v1`.
Gros médias ignorés par Git et régénérables, sources/bruts/rapports conservés.

**art_approved=false, runtime_tested=false, render_tested=false.** Pas de vrai chargeur, éditeur,
caméra/échelle, rendu ou déplacements PMDO exécutés sur ce lot. Pas une aventure raccordée.
Prochaine étape : retour visuel puis test réel PMDO0.8.12, pas certification artistique implicite.
