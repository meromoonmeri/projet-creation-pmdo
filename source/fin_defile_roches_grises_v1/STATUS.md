# FDR1 — fin du Défilé des Roches grises, 16 octobre 2026

## Reprise

L'utilisateur demande de passer à la prochaine map après la correction immersive EAD2.
FDR1, commencée avant cette correction, est finalisée techniquement. Les anciennes mentions
« chantier interrompu » dans les journaux décrivent son état antérieur, pas son état actuel.

## Réalisé

- Décor généré référencé D46P41A et D46P11A ; nouvelle passe référencée pour prolonger les
  falaises hors cadre et remplacer les anciens coins gris unis. Prompt, commit et SHA-256
  de l'image d'entrée de cette dernière passe conservés dans `generation.json`.
- Aucune estrade, structure, porte ou sortie nord ; aucun boss nommé ou scénario ajouté.
- Format 768×576, 96×72 cases de 8 px, six calques + Top vide.
- Sol complet séparé conservé comme support ; sol visible issu du décor final.
- Poussière au vent calculée aux couleurs du rip : 24 phases × 5 ticks, boucle de 2 s.
- Marqueurs : `entrance=[384,560]`, `boss=[376,312]`, `objectif=[384,128]`.
  Chemins avec dégagement 16×16 vérifiés ; aucun warp ni destination liée.
- Fidélité de couleur finale, seuil 35 : **sol 12,65 ; roche 2,09**.
- **13 tests PASS**, dont cinq mutations rejetées : pixel de calque, marqueur déplacé,
  phase d'animation copiée, sortie interdite et masque de collisions modifié.
- Vérificateur indépendant : **29 images reconstruites exactement depuis le Ground et les .tile**,
  soit cinq calques fixes et 24 phases animées. Index et cadence contrôlés.
- Contrôle statistique des quatre coins contre le retour des grandes marges unies,
  inspection visuelle de la scène finale et de la vue des collisions/marqueurs.
- Installateur testé : simulation sans écriture, fusion d'index, sauvegarde, réinstallation
  idempotente et refus d'écrasement d'une carte utilisateur modifiée.
- ZIP projet PMDO 0.8.12, ZIP calques/ORA et aperçu HTML autonome avec calques, pause,
  timeline, zoom, référence et collisions. Sorties lourdes ignorées par Git et régénérables.

## Limites et prochaine étape

**Art non approuvé ; vrai moteur, éditeur, affichage et déplacement en jeu non testés.**
Le terrain est généré à partir d'une référence, pas extrait pixel à pixel de la ROM.
La mesure de fidélité est chromatique : elle ne certifie pas les raccords ou les volumes.
Le nom du biome est descriptif, pas une identification officielle du code D46P41A.
Après retour visuel, contrôler l'échelle, les collisions et l'animation dans PMDO 0.8.12.

## Contrôles finaux de livraison

- Deux builds : 59 fichiers ou membres ORA identiques hors horodatages ZIP et caches Python.
- ZIP projet : 12 fichiers, aucun cache Python ; CRC des deux archives contrôlés.
- Régressions EAD2/EDR1 : 24 tests repassés, soit 37 PASS avec les 13 tests FDR1.
- Serveur sur 0.0.0.0:8002 ; page et deux téléchargements HTTP 200. Syntaxe JavaScript
  contrôlée avec `node --check` ; interactions navigateur non testées automatiquement.
