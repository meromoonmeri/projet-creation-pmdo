# ETV1 — Entrée des Terres volcaniques, 16 octobre 2026

## État courant

**Terminé techniquement, avis artistique et vrai moteur en attente.**
Après « fait d'autre biome mtn », choix explicite « Terres volcaniques ». La priorité forestière
précédente cède pour cette suite à un biome volcanique. La demande n'approuve pas les anciens lots.
Namespace `entree_terres_volcaniques_v1`, préfixe ETV1, asset `etv1_entree_terres_volcaniques`.
Neuf branches de travail + main consultées via arbres API non tronqués, recherche des noms de
chemins associés et du namespace, pas audit exhaustif des contenus. Rapport `branch_review.json`.
Aucune fusion ni changement de branche. Anciens cratères/magma examinés localement, pas réutilisés.

## Origine des images

- Rip **D41P41A 552×576** nouvellement extrait au commit pret/pmd-sky c8073235, table bg_list
  index 103 ; une couche, aucun BPA, animation de palette présente. Le rendu skytemple-files
  1.8.5 expose 26 images ; seule la frame 0 est gardée. Ce nombre ne décrit pas la durée BPL.
  Hashes BMA/BPC/BPL/bg_list et paramètres versionnés, extracteur optionnel fourni.
- Le rip montre une arène avec un Pokémon ; seules matières et couleurs servent de guide,
  aucun boss, symbole ou objet repris. Nom de biome descriptif, sans identification officielle.
- Nouveau décor **1200×896**, premier appel réussi. Nouveau support complet de cendre de même
  taille : deux appels sans image, puis succès avec prompt simplifié et décor en référence
  secondaire ; rip réellement en `images=` à chaque appel. Prompts exacts et erreurs consignés.
- Pas de collage de bouts de maps, pixels générés, pas des tuiles ROM exactes. Pas de
  recoloration scriptée du terrain. Support indépendant non aligné et caché sous la partition.
  Il porte quelques cailloux plus gros que souhaité, sans effet sur le composite visible.

## Réalisé et vérifié

- **768×576, grille 8 px, huit calques + Top** : support, cendre, teintes sombres du sol,
  rebords, basalte, fond nord dessiné, lave animée et braises animées. Plein cadre, lave
  latérale, plateau central/nord et approche sud, aucun trou noir de grotte ou construction.
- Passage relevé sur ce brut ; autres plates-formes bloquées conservativement. Masque lave
  de teintes chaudes + fill_holes, sol excluant la lave, rebords 12 px bruts et profondeur
  relevée séparément. Zones d'édition, pas détourage parfait. Alpha binaire, partition exacte.
- **Diagnostic cendre/lave défini avant génération**, même masque rip/brut/sortie, seuil 35
  inchangé. Brut **1,11 / 12,86**, sortie **5,87 / 9,94**. Couverture >10 % par famille. Ces
  scores ne sont pas comparables directement aux indices forestiers et ne certifient ni
  les textures, les silhouettes, les raccords, les volumes ou l'échelle.
- Lave : pixels de la surface générée déplacés cycliquement, bord fixe 3 px, alpha fixe,
  aucune couleur nouvelle, phase 0 identité, **24×5 ticks**. Ondulation en place, pas un
  écoulement net, une simulation physique ou le BPL officiel. Braises montantes distinctes,
  deux pixels, 24×5 ticks, couleurs chaudes exactes du rip, clipping dans la lave.
- Arrivée **[384,560]**, seuil **[320,112]**, chemin 16×16, aucun warp, destination, boss,
  Pokémon, PNJ ou objet instancié. Prolongement nord décoratif bloquant derrière le seuil.
- **17 tests PASS**, dont six mutations : pixel, marqueur, phase braises copiée, phase lave
  copiée, marqueur boss interdit, collisions. Loi de lave testée par oracle scalaire indépendant
  sur 40 points×24 phases, loi de braises reconstruite indépendamment, rives/couleurs contrôlées.
- **54 images reconstruites exactement** depuis huit banques relues indépendamment, Top vide.
  Installateur : simulation sans écriture, fusion/sauvegarde d'index, idempotence et refus
  d'écraser une carte utilisateur modifiée. Mutations sur copies temporaires.
- **Deux builds identiques : 90 fichiers/membres ORA**, hors horodatages ZIP/caches Python ;
  script/rapport versionnés. Régression conifères : build + leurs **14 tests PASS**, soit
  **31 tests uniques avec ETV1**. Aucun ancien helper/asset modifié.
- Scène finale, collisions et support brut inspectés. Plateau encore frontal avec grandes
  corniches, approche sud plus étroite ; pas de conformité parfaite au prompt promise.
- Projet ZIP **3 226 082 octets/14 fichiers**, PNG-ORA **6 989 507 octets/72 fichiers**, aperçu
  **4 610 871 octets**. CRC, doublons/caches et racine ZIP contrôlés. Syntaxe JS, données,
  noms de métriques et cadence des deux animations contrôlés.
- Aperçu **0.0.0.0:8010** ; page et deux ZIP HTTP 200. Pas de test automatisé des interactions
  navigateur. Correction finale du libellé ARIA seulement, sans changement des données/JS.

## Limites et reprise

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Ni vrai chargeur, éditeur, caméra/échelle, rendu ou déplacements PMDO exécutés.
Prochaine étape : avis visuel et contrôle PMDO 0.8.12. Sources/bruts versionnés, sorties lourdes
régénérables par build/package. Ne pas déduire une approbation d'une demande de suite.

Point d'audit historique : ECM1 désigne déjà aussi l'ancien Cratère magma, en plus des conifères.
Ne pas fusionner ces deux anciens packs sans audit/renommage des banques ; correction hors de
cette nouvelle carte. ETV1 utilise un autre préfixe et namespace ; aucun ancien lot retouché.
