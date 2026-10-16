# FAD1 — Fin des Aiguilles dorées, 16 octobre 2026

## État courant

**Terminé techniquement et empaqueté ; avis artistique et test moteur en attente.**
Nouvelle chambre finale assortie à EAD2, après « contonu ». Cette poursuite n'implique pas
une approbation de l'entrée ni de cette fin. Le nom du biome est descriptif, pas officiel.

## Réalisé

- Nouvelle génération avec rip ROM D14P12A et décor EAD2 en références. Sol support EAD2
  réutilisé à l'identique et déclaré. Prompts, sources et SHA-256 dans `generation.json`.
- Premier essai conservé : son coin haut-gauche échouait au garde-fou plein cadre (6,64, minimum
  >10). Une correction générée remplit les marges de roche ; **test inchangé**, désormais PASS.
- 768×576, grille 8 px, six calques + Top vide ; poussière calculée 24×5 ticks, pas animation ROM.
- Arrivée [384,560], boss [408,360], objectif [384,224] ; chemins avec dégagement 16×16,
  centre éloigné des parois. Aucun boss choisi, artefact, structure, sortie, warp ou destination.
- Scène finale et vue des collisions inspectées. Fidélité couleur sortie : sol 13,69 ; roche 13,04,
  sous le seuil 35. Mesure chromatique, pas certification des volumes ou raccords.
- **13 tests PASS**, dont cinq mutations rejetées : pixel de calque, marqueur déplacé,
  phase d'animation copiée, sortie interdite, masque de collisions modifié.
- **29 images reconstruites exactement**, six banques natives relues indépendamment du build.
  Installateur : simulation, fusion/sauvegarde d'index, idempotence et protection d'un fichier modifié.
- **Deux builds identiques : 59 fichiers/membres ORA**, hors horodatages ZIP et caches Python.
- Régression : 13 tests FDR1 + 8 EAD2 + 16 EDR1 repassés ; **50 PASS** avec les 13 FAD1.
- ZIP projet 1,60 Mo/12 fichiers sans cache Python ; ZIP calques/ORA 3,96 Mo/45 fichiers ;
  CRC des deux archives contrôlés. Aperçu HTML 1,80 Mo, calques, pause, timeline, zoom, collisions.
- Serveur de session 0.0.0.0:8003 : page et ZIP HTTP 200. JavaScript vérifié par `node --check` ;
  aucun test automatisé des interactions navigateur. Sorties lourdes ignorées par Git.

## Livrables et reprise

`renders/fin_aiguilles_dorees_v1/` : `index.html`, `FAD1_projet_pmdo_0812.zip`,
`FAD1_calques_png_8px.zip`, `review/FAD1_scene_t000.png`, contrôles JSON et calques.
Régénérer : commandes du `README_PACK.md`, build puis package. Le rapport de comparaison des
builds est inclus dans le ZIP calques quand il est présent ; un build seul ne le recrée pas.

## Limites

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Le terrain est généré référencé, pas extrait pixel à pixel de la ROM. Pas de validation du
chargeur réel, de l'éditeur, de la caméra/échelle, du rendu ou des déplacements dans PMDO.
Prochaine étape : avis visuel puis contrôle dans PMDO 0.8.12, sans remplacer les anciens lots.
