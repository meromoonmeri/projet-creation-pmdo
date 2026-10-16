# Pipeline des suites de maps après EDR1

`pipeline.py` charge les helpers d'EDR1 dans une instance isolée et applique un `config.json`
par carte : masque de sol, profondeur, matériau, marqueurs et identifiants.
Il ne modifie pas EDR1 et ne dépend pas des caches ou ZIP historiques absents.
Dépendances : mêmes versions Pillow, NumPy et SciPy qu'EDR1.

```sh
.venv/bin/python source/maps_suite_v1/pipeline.py source/entree_aiguilles_dorees_v2
```

Deux routes de profondeur :
- `depth_mode: drawn` : profondeur déjà dessinée par le générateur, isolée par contour mesuré,
  quantifiée séparément sans remplacement par un aplat ; c'est la correction immersive EAD2.
- Sinon, pour une entrée : clef magenta puis remplissage par une couleur du rip (prototype EAD1).
- Une fin sèche n'a pas de calque de profondeur, pas de sortie ni warp (FDR1, FAD1).

Les pixels restent générés ; seuls les formats et la grille sont natifs. Effets de poussière
recalculés aux couleurs du rip, pas animations officielles. Aucune approbation artistique ni
validation du moteur n'est supposée. Les contours sont des découpes sur le nouveau rendu,
pas des relayouts de tuiles natives.

Lot terminé techniquement : **EAD2**, 8 tests dédiés et 30 images reconstruites par un lecteur
indépendant ; contrôle en jeu et avis artistique en attente. EAD1 est rejeté artistiquement.
FDR1 est maintenant finalisé techniquement : 13 tests dédiés dont cinq mutations, 29 images reconstruites, ZIP projet et calques/ORA. Avis artistique et test en jeu en attente.

FAD1 : fin des Aiguilles dorées assortie à EAD2, matériau `gold`, `kind: end`, six calques + Top, poussière tombante 24×5 ticks. 13 tests dédiés et 29 reconstructions ; aucun changement du pipeline commun. Avis artistique et moteur en attente.

EFF1 : `source/entree_foret_feuillus_v1/build.py` réutilise les helpers dans une instance isolée, mais possède sa partition forestière et son ordre de neuf calques. Utiliser son build dédié, pas la CLI minérale générique. 14 tests, 32 reconstructions, pas de validation artistique/moteur.

FFF1 : `source/fin_foret_feuillus_v1/build.py` est la fin forestière assortie à EFF1, huit calques + Top sans profondeur. Même diagnostic couleur et loi de feuilles, support EFF1 réutilisé et déclaré. 14 tests, 31 reconstructions, avis artistique/moteur en attente.

EFA1 : build dédié sous `source/entree_foret_automnale_v1/`, neuf calques + Top, saison automnale inventée depuis D24P11A vert. Troncs/racines relevés par zones, pas par couleur brune. Diagnostic limité aux tons bois/sol, pas au feuillage officiel. 15 tests, 32 reconstructions ; aucun helper commun modifié.

FFA1 : fin assortie à EFA1, build dédié `source/fin_foret_automnale_v1/`, huit calques + Top sans profondeur. Nouvelles zones de troncs mesurées ; même diagnostic chaud limité et loi de feuilles, support réutilisé déclaré. 15 tests, 31 reconstructions ; aucune approbation artistique/moteur.

ECM1 : build dédié `source/entree_coniferes_moussus_v1/`, conifères inventés depuis D24P11A feuillu. Neuf calques + Top, profondeur dessinée, aiguilles calculées à deux pixels (loi testée indépendamment). Diagnostic sol/végétation et seuil 35 inchangés ; couverture du test 5%/10% déclarée pour ce sentier plus étroit. 14 tests, 32 reconstructions ; avis artistique/moteur en attente.

ETV1 : build dédié `source/entree_terres_volcaniques_v1/`, biome volcanique choisi explicitement. Huit calques + Top ; lave du nouveau décor déplacée cycliquement sans recoloration, rives fixes, braises indépendantes (24×5ticks chacune). Nouveau diagnostic cendre/lave, seuil35, pas le BPL officiel. 17tests/54reconstructions, aucune approbation artistique/moteur.

SVJ2 : `source/suite_jaillissements_v2/`, quatre nouvelles configurations et nouveau sprite de magma hors cadre ; recette ETV1 et préparation AGM3 chargées sans les modifier. Corps/gerbes/gouttes séparés, cinq pistes24×5ticks, projet4Ground/43banques. 47tests et503reconstructions, reproductibilité surVJ21seulement ; moteur/art non approuvés.

EMB1 : `source/entree_marais_brumeux_v1/`, marais choisi après volcans ; nouveau décor/support/brume générés avec rip Murky fourni. Eau par loi ETV1 inchangée, brume générée tramée/clippée sur eau, pistes séparées24×5ticks,9banques+Top.19tests/55reconstructions/repro94éléments0diff ; artistique/moteur non approuvés.

TLG1 : source/traversee_lac_glace_v1, nouvelle composition lac solide avec rips D53P11B/cropD52P11C réellement fournis.17PASS/55reconstructions/repro93éléments0diff, météo séparée testée ; artistique/moteur en attente. Col ECG1 reste brouillon suspendu, pas dépendance exécutable de TLG1.
