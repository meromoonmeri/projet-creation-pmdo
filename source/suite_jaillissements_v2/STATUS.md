# SVJ2 — Les Fournaises, quatre cartes — 16 octobre 2026

## État courant

**Livraison technique terminée ; avis artistique et vrai PMDO en attente.**
Demande : « plein de map », colonnes de flamme/magma montantes sans sommet visible,
jaillissements depuis la lave. Après interruption et « Fait d'autre map », finalisation
du lot de quatre nouvelles compositions. Une suite n'est pas une approbation artistique.

- VJ21 : Chenal des Fournaises, traversée sinueuse.
- VJ22 : Défilé des Scories, corniches asymétriques.
- VJ23 : Bassins Bouillonnants, poches de lave.
- VJ24 : Caldeira des Éruptions, fin avec nord fermé.

Un seul projet `suite_jaillissements_v2`, quatre Ground, **43 banques** distinctes,
768×576, grille8px / 96×72 / TexSize1. Trois traversées :11calques+Top ; fin :10+Top,
sans profondeur de fin. Aucun ancien lot/helper/asset modifié, aucune fusion de branche.
Arbres distants non tronqués consultés pour noms de chemins/namespaces : branch_review.json.

## Générateur et origine

Rip D41P41A 552×576/provenance copiés byte-identiques d'ETV1, pret/pmd-sky c8073235,
une couche, aucun BPA, palette animée ; rendu outil26 images, seule frame0 gardée comme guide.
Pas de reprise du Pokémon/layout de l'arène. Animations nouvelles, pas BPL/BPA officiel.
Quatre décors1200×896 générés avec rip en images=, puis corrections au générateur :
marches indésirables VJ22, motifs de visages VJ23, lave trop rouge VJ24 en deux retouches.
Dernière retouche VJ24 avec crop canonique non agrandi [0,0,200,50] en guide ; pas collage.
Les corrections ont aussi changé le sol, VJ24 plus chaud : ne pas prétendre le reste inchangé.
Premiers bruts conservés avec prompts exacts/empreintes/étapes, aucune peinture corrective.

Nouveau sprite de colonne **784×1360**, premier appel réussi avec rip en images=,
shaft hors cadre et bouche/gerbes/gouttes sur magenta. Aucun ancien sprite AGM3 repris.
Support de cendre ETV1 réutilisé/déclaré, pas une nouvelle génération ni support aligné.
Pixels générés/transformés, formats/grille natifs seulement. Aucune approbation artistique.

## Réalisation et contrôles

- Passage : enveloppes propres aux nouveaux décors et segmentation luminance médiane5px>=65,
  fermeture2px, composante connectée principale, érosion2px, lave et profondeur exclues.
  Sud restauré après fermeture, bordures12px bloquantes. Zones d'édition, pas détourage parfait.
- **Quatre jets par carte**, bouches déterministes dans les mares, couloir vertical sans
  recouvrir le passage, deux échelles et phases décalées. Matière du nouveau sprite,
  préparation AGM3 chargée isolément sans modifier ses fichiers. Paramètres940/950/1200,
  palette32, raccord20%, transformations et contours documentés.
- Corps ascendant sur une période avec deux poussées, vitesse non arrondie toujours >0.
  Corps tracé du bord haut jusqu'à la bouche, pas de cap visible. Gerbes générées translatées
  ±2px, clippées dans la lave ; gouttes générées en paraboles hors passage. Trois pistes
  séparées, indépendantes de lave/braises ; chacune24×5ticks, boucle2s.
- **47 tests PASS**, dix tests paramétrés sur chacune des quatre cartes +sept de bundle.
  Cinq mutations rejetées : sommet découvert, colonne figée, bouche sur sol, pixel natif,
  warp. Oracle scalaire indépendant de montée, source/palette, cadences, accès16px et
  installateur fusion/sauvegarde/idempotence/refus d'écrasement testés sur copies.
- **503 images reconstruites exactement** depuis43banques relues indépendamment :126×3+125.
  Top vide, aucun Pokémon/objet/PNJ instancié. Repère boss non nommé sur VJ24 seulement.
- Garde complémentaire : centre de chaque corps opaque sur toutes les lignes jusqu'au bord
  haut, **16jets×24phases=384 cas PASS**, pas seulement des fenêtres contenant le jet voisin.
- Premier essai : deux tests détectent un bord nord praticable sur VJ23. Enveloppe de
  profondeur élargie sur ce nouveau décor, carte reconstruite, 47tests finaux PASS ; seuils
  et assertions non affaiblis. Les paquets ne sont produits qu'après succès.
- Régression ETV1 : ses **17tests PASS**, sans rebuild ancien nécessaire (staging présent).
- Reproductibilité : **VJ21 seulement**,167fichiers/membresORA identiques. Les autres n'ont
  pas deux builds identiques vérifiés ; `check_reproducibility.py --all` disponible.
- Même diagnostic couleur cendre/lave et seuil35 qu'ETV1, sans hausse/recoloration scriptée.
  Sortie cendre/lave : VJ21 **16,05/20,19**, VJ22 **7,81/17,02**,
  VJ23 **1,39/23,86**, VJ24 **19,87/19,23**. Ce n'est pas une certification artistique,
  de textures officielles, volumes, raccords ou conformité ; non comparable aux scores verts.
- Quatre scènes finales et collisions inspectées sur planches. Grain sobre VJ21, structures
  rocheuses encore frontales/circulaires sur la fin, colonnes très contrastées : avis attendu.

## Fichiers et aperçu

- Projet **SVJ2_projet_pmdo_0812.zip :20 120 463octets /55fichiers**,4Ground,43.tile,4Lua.
- PNG/ORA **SVJ2_calques_png_8px.zip :45 617 601octets /566fichiers**.
- CRC, doublons/caches, racine/compte de projet contrôlés ; aucune donnée Python temporaire.
- Galerie relative index.html10735octets, catalogue150267octets,503chemins images contrôlés,
  quatre cartes sélectionnables, cinq pistes animées séparées, zoom/phase/calques/collisions.
  SyntaxeJS/données vérifiées, **pas de test automatisé des interactions navigateur**.
- Serveur0.0.0.0:8011, page/catalogue/planche/ZIP et scène de fin HTTP200.
- Planche d'aperçu réduite **SVJ2_apercu_4_cartes.png**,742038octets ; pas une map à importer.

`art_approved=false`, `runtime_tested=false`, `render_tested=false`.
Ni vrai chargeur, éditeur, caméra/échelle, rendu ou déplacements dans PMDO exécutés.
Sources/bruts/rapports versionnés ; gros médias ignorés et régénérables. Prochaine étape :
retour visuel et contrôle dans PMDO0.8.12, sans inventer de destination/warp/boss spécifique.
