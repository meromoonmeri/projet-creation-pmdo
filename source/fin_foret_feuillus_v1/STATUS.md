# FFF1 — Clairière finale de la Forêt de feuillus, 16 octobre 2026

## État courant

**Terminé techniquement, paquets et aperçu prêts ; avis artistique et moteur en attente.**
Après « passe a la suite », fin assortie à EFF1 dans la direction forestière demandée.
Ne pas déduire une approbation artistique de l'entrée ni de la fin de cette poursuite.

## Réalisé et vérifié

- Nouveau décor généré avec rip D24P11A et décor EFF1 réellement fournis en références.
  Premier appel sans image, reprise réussie ; prompts exacts et hashes dans `generation.json`.
- Référence 504×432, une frame, deux couches, sans BPA/animation de palette, provenance
  pret/pmd-sky c8073235 copiée avec le rip. Nom de biome descriptif, pas identification officielle.
- Support d'herbe copié byte-à-byte d'EFF1 et déclaré ; ce n'est pas une nouvelle génération.
- 768×576, grille 8 px ; huit calques + Top vide, sans fausse profondeur. Herbe/terre nue
  et troncs/feuillage séparés. Feuilles calculées 24×5 ticks ; pas animation ROM.
- Arrivée [384,560], repère boss non nommé [424,344], objectif [384,192]. Accès 16×16
  contrôlés, centre éloigné du bord. Aucun boss instancié, artefact, structure, sortie ou warp.
- Fidélité sortie, seuil 35 : sol 6,17 ; végétation 19,95. Diagnostic couleur, pas preuve de
  raccords, texture ou volumes ; l'herbe et la terre restent assez plates par endroits.
- **14 tests PASS**, dont cinq mutations rejetées : pixel, marqueur déplacé, phase copiée,
  sortie ajoutée, collisions. La loi d'animation est reconstruite indépendamment dans le test.
- Test de correspondance EFF1 : mêmes matières, couleurs d'effet et loi de feuilles ; support
  et référence secondaire vérifiés par empreinte ; aucune profondeur ni seuil de donjon sur la fin.
- **31 images reconstruites exactement** depuis le Ground et huit banques natives.
- Installateur : simulation sans écriture, fusion/sauvegarde d'index, réinstallation idempotente,
  refus d'écrasement d'une carte modifiée ; huit banques plus une préexistante dans le test.
- **Deux builds identiques : 67 fichiers/membres ORA**, caches et horodatages ZIP exclus.
  Script de comparaison versionné et rapport inclus dans le pack calques.
- Régression EFF1 : build puis ses 14 tests repassés, soit **28 PASS** avec FFF1.
  Aucun helper commun ou asset de l'entrée modifié.
- Scène finale et collisions inspectées. ZIP projet 1,96 Mo/14 fichiers ; calques/ORA
  4,97 Mo/49 fichiers ; CRC contrôlés, aucun cache Python. Aperçu autonome 2,54 Mo.
- Serveur 0.0.0.0:8006 : page et deux ZIP HTTP 200 ; syntaxe JS et données intégrées contrôlées.
  Aucun test automatisé des interactions navigateur.

## Limites et reprise

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Terrain généré référencé, seuls formats et grille natifs. Ni chargeur réel, ni éditeur, ni
caméra/échelle, rendu ou déplacements dans PMDO testés. Prochaine étape : retour visuel puis
contrôle dans PMDO 0.8.12. Ne pas reprendre les pistes rejetées ESB1 ou Col de sable par défaut.

Sources et bruts versionnés. Sorties lourdes régénérables dans `renders/fin_foret_feuillus_v1/`
par build puis package ; `README_PACK.md` donne les commandes, installation et limites.
