# ECM1 — Entrée de la Forêt de conifères moussus, 16 octobre 2026

## État courant

**Terminé techniquement, avis artistique et vrai moteur en attente.**
Après « continue » suivant FFA1, nouvelle entrée choisie dans la priorité forestière.
La demande de suite ne vaut pas approbation des cartes précédentes ou de celle-ci.
Branches distantes consultées par leurs arbres API non tronqués (neuf branches de travail
et main), sans fusion ni changement de branche. Namespace/prefixe propres au nouveau lot.
ESB1 rejeté et prototype du col de sable laissés intacts, pas repris comme suite.

## Origine

- Référence D24P11A 504×432 et provenance copiées d'EFF1 : pret/pmd-sky c8073235,
  une frame, deux couches, aucun BPA ni animation de palette, skytemple-files 1.8.5.
- **Le rip montre des feuillus ; les conifères sont inventés**, pas des sprites officiels.
- Deux nouveaux bruts 1200×896, décor et mousse/litière support. Premier appel réussi pour
  chacun, rip réellement fourni en `images=`. Prompts exacts et empreintes dans generation.json.
- Aucun collage, pixels ROM exacts ou recoloration scriptée du terrain revendiqués. Nom
  descriptif. Seuls formats et grille natifs. Conifères plus stylisés que le rip, mousse
  assez unie, terre un peu dallée : pas de conformité artistique parfaite promise.

## Réalisé et vérifié

- 768×576, grille 8 px, neuf calques + Top : support complet, mousse/herbe, terre/chemin,
  ombres, sous-bois, troncs/racines, feuillage, profondeur dessinée, aiguilles calculées.
  Arrivée sud, sentier sinueux, nord prolongé en décor texturé, aucune grotte ni structure.
- Contours de sol/profondeur propres au nouveau brut. Bois par tons chauds hors sol, pas
  reprise des polygones d'automne. Ombres déjà dessinées, sous-bois 24 px bruts ; pas de
  détourage parfait promis. Alpha binaire, partition exacte, Top vide.
- **Même diagnostic RGB et seuil 35 qu'EFF1** : brut 23,54/27,09 ; sortie 21,22/28,13
  (sol/végétation). Mesure de couleurs seulement, pas de certification de formes ou raccords.
  Test de couverture des échantillons : sol 5 % / végétation 10 %, contre 10 %/10 % dans
  EFF1 : le chemin ECM1 n'occupe que 8,63 % du brut avec les mêmes masques. Cette adaptation
  explicite ne change ni les familles mesurées ni le seuil de fidélité.
- Aiguilles : 24 émetteurs, 24 phases×5 ticks, deux pixels diagonaux (0,0),(1,1), non les
  trois pixels des feuilles EFF1 ; couleurs vertes du rip. Loi reconstruite indépendamment
  dans le test, pas animation ROM ni sprite de conifère officiel.
- Entrée [384,560], seuil [384,168], chemin 16×16 ; prolongement nord dessiné bloquant,
  marqueur sans destination. Aucun warp, boss, Pokémon, PNJ ou objet instancié.
- **14 tests PASS**, cinq mutations rejetées, **32 images reconstruites exactement** depuis
  neuf banques relues indépendamment. Installateur : simulation sans écriture, fusion et
  sauvegarde de l'index, idempotence, protection d'une carte utilisateur modifiée.
- **Deux builds identiques : 71 fichiers/membres ORA**, hors horodatages ZIP/caches Python.
  Script et rapport de reproductibilité versionnés. Régression FFA1 : build et ses **15 tests
  PASS**, soit 29 tests uniques avec ECM1. Aucun ancien helper ou asset modifié.
- Scène finale, support brut et collisions inspectés. Projet ZIP **1 656 844 octets/15 fichiers**,
  PNG-ORA **4 267 481 octets/51 fichiers**, HTML **2 084 110 octets**. CRC, absence de caches
  Python/doublons et racine d'archive vérifiés. Syntaxe JS et données intégrées contrôlées.
- Aperçu servi sur 0.0.0.0:8009, page et deux ZIP HTTP 200. Pas de test automatisé des
  interactions navigateur. Premier build interrompu faute de README_PACK ; notice ajoutée
  avant les builds/tests/reproductibilité réussis et la fabrication des paquets définitifs.

## Limites et reprise

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni vrai chargeur, ni éditeur, ni rendu, caméra/échelle ou déplacements en jeu testés.
Tests Python ≠ validation PMDO. Prochaine étape : retour visuel et contrôle dans PMDO 0.8.12.
Sources/bruts versionnés, sorties lourdes régénérables par build/package selon README_PACK.
