# EFA1 — Entrée de la Forêt automnale, 16 octobre 2026

## État courant

**Terminé techniquement et empaqueté ; avis artistique et moteur en attente.**
Après « LA SUITE », nouvelle entrée forestière, distincte d'EFF1/FFF1. Le choix de l'automne
est celui de l'agent ; aucune approbation artistique de cette carte ou des précédentes supposée.

## Origine et limites de la palette

- Rip D24P11A, 504×432, une frame, deux couches, aucun BPA/animation de palette, provenance
  pret/pmd-sky c8073235 copiée d'EFF1 avec les empreintes. Nom de biome descriptif.
- Le rip reste vert. **La saison automnale est inventée par génération référencée** : aucun
  feuillage automnal officiel revendiqué, pas de recoloration scriptée d'une ancienne carte.
- Deux nouveaux bruts 1200×896, décor et support de litière ; rip réellement fourni aux deux
  appels `images=`, réussis au premier essai. Prompts et empreintes conservés.
- Diagnostic de deux familles de tons chauds bois/sol du rip, pas comparaison des feuilles
  brunes avec ses feuilles vertes. Indices finaux : clairs 27,48 / sombres 32,15, seuil 35.
  Non directement comparables aux indices sol/végétation des lots verts. Pas de certificat de
  feuillage canonique, de raccords ou de volumes. Le chemin garde un aspect de terre dallée.

## Réalisé et vérifié

- 768×576, grille 8 px, neuf calques + Top : support, mousse/litière, chemin, ombres,
  sous-bois, zones de troncs/racines, feuillage, profondeur dessinée, feuilles calculées 24×5 ticks.
- Bois et feuilles étant bruns, séparation par sept polygones relevés, pas par RGB.
  Zones d'édition, pas détourage parfait de toutes les branches. Politique et contours dans
  config et manifeste ; test contre l'absorption de la canopée dans le calque des troncs.
- Arrivée [384,560], seuil [384,160], accès 16×16, aucun warp, boss, PNJ ou destination.
- **15 tests PASS**, dont cinq mutations : pixel, marqueur, phase copiée, boss ajouté, collisions.
  Loi de feuilles reconstruite indépendamment ; couleurs bois/terre exactes du rip, dessin/loi
  calculés et non officiels. Le vérificateur confirme **32 reconstructions exactes**, neuf banques.
- Installateur dry-run, fusion/sauvegarde, réinstallation idempotente et protection des fichiers
  utilisateur modifiés testés ; neuf banques plus une préexistante.
- **Deux builds identiques : 71 fichiers/membres ORA**, horodatages et caches exclus.
  Script de comparaison versionné. Régression EFF1/FFF1 : leurs 28 tests repassent, **43 PASS**
  avec EFA1. Aucun ancien helper ou asset modifié.
- Scène finale et collisions inspectées. Projet ZIP 1,74 Mo/15 fichiers, PNG-ORA 4,84 Mo/51 fichiers,
  aperçu 2,19 Mo ; CRC et absence de caches Python contrôlés.
- Serveur 0.0.0.0:8007 : page et deux ZIP HTTP 200 ; syntaxe JS et données intégrées contrôlées.
  Pas de test automatisé des interactions navigateur.

## Prochaine étape

Retour visuel, puis contrôle dans PMDO 0.8.12. `art_approved: false`, `runtime_tested: false`,
`render_tested: false`. Ni chargeur réel, ni éditeur, ni caméra/échelle, rendu ou déplacements
exécutés. Les tests Python ne remplacent pas la validation en jeu.
Sources/bruts versionnés ; sorties lourdes régénérables via build puis package dans
`renders/entree_foret_automnale_v1/`. Voir `README_PACK.md` pour commandes, méthode et installation.
