# TLG1 — Lac des Roches givrées — 17 octobre 2026

## État courant

**Nouvelle map construite et livrée techniquement ; avis artistique et PMDO en attente.**
Dernière demande « Passe a la prochaine map ». On quitte la retouche du col pour une autre
composition du biome glacé : grand lac SOLIDE traversable, rives irrégulières, sortie nord-est.
L'utilisateur a précisé « textures canoniques » puis choisi **générateur beaucoup plus fidèle
au rip**, pas reconstruction en pixels officiels exacts. Ne pas substituer une mosaïque de rips.
Col ECG1 conservé comme proposition suspendue, aucun export natif ; ne pas le reprendre sans demande.
Le passage à une prochaine map n'est pas une approbation visuelle du col ou des autres lots.

## Références et fabrication

- D53P11B/entrée130/504×360/2couches/0BPA/1image/sans animation palette, extrait réellement
  au col, copié avec provenance. D52P11C/entrée126/504×408/2couches/0BPA/1image/sans animation
  palette nouvellement extrait. pret/pmd-sky c8073235, BMA/BPC/BPL/table/blobs/SHA conservés.
- Guide réellement fourni : D53P11B complet +crop sol D52P11C[15,220,490,282] non agrandi.
  Aucun ancien rendu généré fourni, pas reprise du col ni des grands cristaux du rip D52.
  Lac inventé, pas extraction officielle de lac ; pixels générés, formats/grille natifs seulement.
- Deux générations, premier succès chacune : décor et support1200×896. Prompts exacts,
  dimensions, hashes des fichiers/références dans generation.json. Aucun collage/recoloration
  d'ancienne map. Dix branches auditées par noms de chemins, arbres non tronqués, aucune fusion.
  Anciens lieux glacés déjà présents, pas preuve d'inédit absolu. Préfixe/namespace TLG1 propres.
- Six zones de terrain : neige, ombres, berges, reliefs, lac gelé et profondeur nord-est dessinée.
  Support généré non aligné en dessous. Masques fonctionnels, pas détourage parfait des objets.
  Le lac est plein et traversable, pas eau ; fissures dessinées cosmétiques, pas trous.
- BOX pondéré uniforme576/896, largeur771 crop1gauche/2droite, palette96 sans dither,
  profondeur séparée, alpha0/255 et RGB0 sous transparence. Pas de texture liquide animée.
- 768×576/96×72/grille8/TexSize1,9calques+Top vide : support/neige/ombres/berges/reliefs/lac/
  profondeur/reflets/flocons. Reflets et neige sur deux pistes24×5ticks, boucle2s.28positions de
  reflets clippées sur glace,64émetteurs de flocons graine171026 ; particules calculées aux quatre
  couleurs du rip, ni sprites ni cycle officiel. Aucun effet sur collisions, pas simulation physique.
- Arrivée[384,560],seuil nord-est[696,40], accès16×16 ; aucun warp/destination/boss/PNJ/objet ajouté.
  Neige+lac praticables ; autres plates-formes conservativement bloquées. Pas aventure raccordée.

## Contrôles exécutés, périmètre et limites

- **17tests PASS**, dont **six mutations rejetées** : pixel PNG, warp, collisions, marqueur,
  reflets hors lac et reflets figés. Oracles indépendants des deux lois d'animation, crop source,
  hashes, palette/cadences, PNG/WebP2s, ORAordre+pixels et coins texturés contrôlés.
- Lecteur indépendant : **55reconstructions exactes depuis9banques**, index/Ground/alpha,
  Top vide, références héritées retirées, accès/collisions vérifiés. Pas chargeur PMDO.
- Installateur testé sur copies : dry-run sans écriture, fusion10banques avec EXISTANT,
  sauvegarde/idempotence, protection d'un Ground modifié par l'utilisateur.
- **Deux builds complets rejoués après correction finale :93fichiers/membresORA,0diff**,
  hors horodatages ZIP ; archives/viewer/rapports hors build exclus. Rapport reproductibilité réel.
- **Régression marais EMB1 :19PASS** ; aucun ancien helper/asset livré modifié. La météo du
  brouillon de col est copiée et testée ici, pas importée comme dépendance d'exécution.
- Le premier contour du lac coupait une petite zone de glace au sud. Contour rectifié puis
  marge de recherche24px et filtrage de vraie teinte de glace, pas peinture ajoutée ; garde sur
  trois points[480,480],[480,486],[490,490], sans affaiblir assertions. Repro/tests/ZIP rejoués.
- Diagnostic familles neige/roche conservé à seuil35 : brut14,84/15,62,sortie**14,75/19,16**.
  Filtres identiques rip/brut/sortie, plafondG160 du filtre roche pour limiter contribution du
  lac bleu clair. Ce ne sont pas des masques d'objets ou une certification des textures du lac,
  du grain, des volumes/raccords ; non comparable aux familles d'autres biomes/du col.
- Scène et collisions finales inspectées. Rendu généré encore interprétatif, grain parfois
  plus doux que le rip et grand lac ouvert : avis artistique en attente, pas canonique pixel exact.

## Livrables et aperçu

- Projet TLG1_projet_pmdo_0812.zip :**1 579 714octets/15membres**,1Ground/9banques.
- PNG-ORA TLG1_calques_png_8px.zip :**4 160 526octets/79membres**.
- HTML autonome **1 891 346octets**,9calques/55images, zoom/phase/calques/collisions et liens ZIP
  relatifs. SyntaxeJS/données vérifiées, pas test automatisé des interactions navigateur.
- CRC/doublons/caches/racines/comptes de ZIP contrôlés. Serveur0.0.0.0:8013 ; page/deuxZIP/PNG/
  WebP HTTP200. Ni API/CDN ni URL localhost côté navigateur. Sources/bruts/rapports versionnés,
  gros médias ignorés et régénérables. Col non exporté conservé séparément avec décision utilisateur.

art_approved=false,runtime_tested=false,render_tested=false. Ni vrai chargeur, éditeur,
caméra/échelle, rendu ou déplacements PMDO exécutés. Prochaine étape : retour visuel et vrai PMDO.
