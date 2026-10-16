# FFA1 — Clairière finale de la Forêt automnale, 16 octobre 2026

## État courant

**Terminé techniquement, paquets et aperçu prêts ; avis artistique et moteur en attente.**
Après « la suite go », fin assortie à EFA1. La poursuite n'implique aucune approbation artistique
de l'entrée ou de cette fin. Priorité aux biomes forestiers maintenue.

## Origine et palette

- Nouveau décor 1200×896 généré au premier appel avec D24P11A et décor EFA1 réellement en
  `images=` : clairière plus ouverte, nouveau tronc fourchu nord-ouest et lisière nord fermée.
- Rip D24P11A 504×432, une frame, deux couches, aucun BPA/animation de palette, provenance
  pret/pmd-sky c8073235 copiée d'EFA1. Le rip reste vert : **l'automne est inventé**, pas un
  feuillage officiel ni une recoloration scriptée. Nom du biome descriptif.
- Support de litière copié byte-à-byte d'EFA1 et déclaré, non aligné sous les objets ; pas de
  nouvelle génération de support. Prompts, commits et empreintes dans `generation.json`.
- Même diagnostic bois/sol chauds qu'EFA1, pas de comparaison aux feuilles vertes officielles.
  Indices finaux : clairs 31,33 / sombres 31,57, seuil 35. Non comparables directement aux
  indices sol/végétation d'EFF1. Pas de preuve de textures, raccords ou volumes canoniques.

## Réalisé et vérifié

- 768×576, grille 8 px, huit calques + Top : support, mousse/litière, terre nue, ombres,
  sous-bois, troncs/racines, feuillage, feuilles calculées 24×5 ticks. Aucune profondeur sur la fin.
- Bois/feuilles bruns séparés par **huit zones mesurées sur ce nouveau brut**, pas par RGB.
  Fourche nord-ouest comprise ; pas de détourage parfait promis. Test contre l'absorption de
  la canopée brune et contre des pixels de troncs hors des zones relevées.
- Arrivée [384,560], repère boss non nommé [448,328], objectif [384,160]. Accès 16×16 et centre
  éloigné des bords ; aucun boss instancié, warp, seuil de donjon, PNJ, destination ou structure.
- **15 tests PASS**, dont cinq mutations : pixel, marqueur, phase copiée, sortie ajoutée,
  collisions. Loi de feuilles reconstruite indépendamment et correspondance EFA1 testée.
- **31 images reconstruites exactement**, huit banques relues indépendamment depuis le Ground.
- Installateur : simulation sans écriture, fusion/sauvegarde d'index, idempotence, refus
  d'écrasement d'une carte modifiée. Huit banques plus une préexistante dans le test.
- **Deux builds identiques : 67 fichiers/membres ORA**, hors horodatages ZIP/caches Python,
  script de comparaison versionné. Régressions EFA1/EFF1/FFF1 : leurs 43 tests repassent,
  soit **58 PASS** avec FFA1 ; aucun ancien helper ou asset modifié.
- Scène et collisions inspectées. Projet ZIP 1,71 Mo/14 fichiers, PNG-ORA 4,75 Mo/49 fichiers,
  aperçu 2,16 Mo ; CRC et absence de caches Python contrôlés.
- Serveur 0.0.0.0:8008 : page et ZIP HTTP 200. Syntaxe JS et données intégrées contrôlées ;
  aucun test automatisé des interactions navigateur.

## Limites et reprise

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Pixels générés, formats/grille natifs seulement. Ni vrai chargeur PMDO, ni éditeur, ni
caméra/échelle, rendu ou déplacements testés. Terre nue d'aspect dallé par endroits ; aucune
certification artistique supposée. Prochaine étape : retour visuel puis contrôle PMDO 0.8.12.
Sources/bruts versionnés ; sorties lourdes régénérables par build puis package selon le README.
