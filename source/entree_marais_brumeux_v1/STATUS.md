# EMB1 — Marais brumeux — 16 octobre 2026

## État courant

**Première carte du nouveau biome construite et livrée techniquement ; avis visuel et moteur en attente.**
Demande « passe au prochain biome », choix explicite **marais**. Pas d'approbation implicite des
volcans ni des autres anciens lots. Nouvelle composition plein cadre, pas une forêt recolorée.
Grands arbres bleutés/racines, deux bassins asymétriques, îlot conservé, large passage de vase.
Eau et brume indépendantes ; pas de colonnes de magma dans ce nouveau lieu.

## Provenance et méthode

- Dix branches distantes examinées, arbres API non tronqués, noms de chemins, aucune fusion.
  Anciens projets/références Murky présents ; pas revendication de premier biome marécageux
  de tous les dépôts. Namespace/préfixe nouveaux `entree_marais_brumeux_v1`/EMB1.
- Feuille Murky Forest &Armaldo House téléchargée au blob b6a7b2c4312b3ff33db9526e739538e01f74bf16,
  commit54d373157840500f7a8baacc723ae30f817fad8c de meromoonmeri/projet-pmdo. SHA72d17b72…
  identique au sources.json historique.1162×697 ; crop[0,0,400,312], égalité pixel-à-pixel avec
  murky.png historique vérifiée. Crédits Haalfpack/Noctowl2000 conservés dans feuille complète.
  Pas de nouvelle extraction ROM, code BMA/cadence non inférés, pas de filtre nuit/Abyss.
- Trois générations, premier appel réussi chacune, avec guide réellement en images= : décor,
  support de vase, ruban de brume sur magenta, chacun1200×896. Prompts exacts/hashes/dimensions
  conservés. Nouveau marais inventé depuis guide forestier, eau/brume non officielles.
- Segmentation avant réduction par enveloppes/graines propres au nouveau décor. Eau : deux
  composantes teintées teal dans zones explicites, trous<1000px comblés seulement ; îlot non
  animé. Ombres : luminance moyennée5px<69. Berges12px, racines/feuillage en zones d'édition,
  pas détourage parfait. Support complet non aligné sous partition, nouvelle génération.
- BOX pondéré uniforme576/896, largeur771 crop1gauche/2droite ; palette terrain96, profondeur
  séparée, alpha0/255 et RGB0 sous alpha0. Vase violette légitime : garde clef magenta saturée
  R>170,B>170,G<100, pas ancien filtre qui rejetait aussi la matière pourpre réelle du décor.
- Neuf calques : support, vase, ombres, berges, racines, feuillage, profondeur dessinée, eau,
  brume ; Top vide.768×576 /96×72 /grille8 /TexSize1, arrivée[384,560], seuil[384,120], accès16px.
  Aucun warp/destination/boss/PNJ/objet ajouté. Pas une aventure jouable raccordée.
- Eau : loi ETV1 réutilisée sans modifier helper, sur les nouveaux pixels EAU ; rives fixes3px,
  phase0 identité, sans recoloration, pas BPL officiel. Aucune texture/sprite de lave reprise.
- Brume : nouveau sprite détouré/BOX/palette32 générée, quatre placements/deux miroirs, alpha
  tramé25% pour rester binaire, pas transparence moteur. Oscillation ±6px en x,0..−4px en y,
  clip strict eau sans wrap ; aucun masquage du passage. Chaque piste24×5ticks/boucle2s.
  Ruban assez stylisé et tramé, eau sobre : avis artistique attendu, pas de promesse de réalisme.

## Contrôles exécutés

- **19tests PASS**, sept mutations rejetées : pixel natif, seuil déplacé, faux boss, collisions,
  eau figée, brume figée, brume sur passage. Oracles indépendants des déplacements eau/brume,
  hashes, crop, palette, alpha, boucles/cadences, coins texturés, ORA et profondeur contrôlés.
- **55reconstructions exactes depuis neuf banques**, lecture indépendante de .tile/index et
  du Ground ; formats/grille/Top/entités/accès vérifiés. Pas vrai chargeur PMDO.
- Installateur testé sur copies : dry-run sans écriture, index fusionné à10avec EXISTANT,
  sauvegarde/idempotence et protection d'un Ground modifié.
- **Deux builds complets rejoués :94fichiers/membresORA,0diff**, hors horodatages ZIP. Rapport
  reproducibilite.json ; archives/viewer/rapports hors build non inclus dans cette comparaison.
- **17tests de régression ETV1 PASS**. Aucun ancien helper, brut ou lot modifié.
- Même diagnostic fixé avant génération et seuil35, sans hausse : brut vase/bleu11,42/15,71,
  sortie **8,09/16,54**. Les familles de couleurs ne détourent pas des objets ; le filtre bleu
  peut aussi compter l'eau. Pas score officiel de l'eau ni conformité de textures/volumes/raccords.
  Non comparable aux diagnostics volcaniques. Guide forestier, eau/brume inventées.
- Première passe tests : erreur de chemin de profondeur hérité05au lieu de06, corrigée sans
  modifier les assertions ni les images ;19tests finaux PASS. Premiers essais code corrigés :
  distinction clef magenta/vase violette et allocation locale des patches au lieu du helper
  rgba plein cadre. Aucun nouveau rendu générateur requis pour ces correctifs techniques.

## Livrables et aperçu

- **EMB1_projet_pmdo_0812.zip :2 200 679octets,15membres**, un Ground/neuf banques.
- **EMB1_calques_png_8px.zip :6 444 818octets,78membres**, PNG/ORA/masques/contrôles/références,
  prompts et nouveau sprite de brume original.
- Galerie HTML autonome **3 420 833octets**,9calques/55images intégrées, lecture/pause/phase,
  zoom, collisions/marqueurs et liens ZIP relatifs. SyntaxeJS/données contrôlées, pas test
  automatisé des interactions navigateur. Pas d'API/CDN/URL localhost côté navigateur.
- CRC/doublons/caches/racines et comptes des ZIP vérifiés. Serveur0.0.0.0:8012 ; page, deux ZIP,
  PNG scène et WebP animé HTTP200. ScènePNG527694octets, WebP757042octets/boucle2s.
- Scène finale, collisions et sprite inspectés ; sources/bruts/provenance versionnés, médias
  de sortie ignorés et régénérables. Nouveau lot source+rendus21,53MiB environ.

`art_approved=false`, `runtime_tested=false`, `render_tested=false`.
Ni vrai chargeur, éditeur, caméra/échelle, rendu ou déplacements PMDO exécutés sur ce lot.
Prochaine étape : retour visuel, puis contrôle réel dans PMDO0.8.12 et éventuelle suite assortie.
