# EFF1 — Entrée de la Forêt de feuillus, 16 octobre 2026

## État courant

**Terminé techniquement et empaqueté, avis artistique et test moteur en attente.**
Demande explicite : « continue des biome forestier etc ». Schistes bleus rejetés ; proposition
Col de sable laissée de côté. Nouvelle forêt de feuillus, aucun de ces décors réutilisé.

## Réalisé et vérifié

- Rip D24P11A, 504×432, une frame, deux couches, aucun BPA ni animation de palette.
  Provenance pret/pmd-sky c8073235 et empreintes conservées. Nom du biome descriptif, pas officiel.
- Deux bruts générés référencés 1200×896, décor et herbe support. L'appel initial du support
  n'avait retourné aucune image, puis une reprise référencée a réussi ; prompts exacts conservés.
- 768×576, grille 8 px, neuf calques + Top vide : herbe/chemin et troncs/feuillage séparés.
  Feuilles animées calculées 24×5 ticks, aux couleurs du rip mais pas une animation officielle.
- Arrivée [384,560], seuil [384,160], chemins avec dégagement 16×16 ; aucun warp, boss ou PNJ.
- Fidélité finale, seuil 35 : sol 34,23, végétation 24,04. Le sol est proche du seuil,
  plus jaune/saturé que le rip ; ceci n'est pas une certification des raccords ou des volumes.
- **14 tests PASS**, dont cinq mutations : pixel, marqueur déplacé, phase copiée, boss ajouté,
  collisions. Loi d'animation reconstruite indépendamment dans le test ; boucle 2 s contrôlée.
- **32 images reconstruites exactement** depuis le Ground et les neuf banques .tile.
- Installateur : simulation sans écriture, fusion/sauvegarde d'index, idempotence et refus
  d'écrasement d'une carte utilisateur modifiée. Index testé avec neuf banques + une préexistante.
- **Deux builds identiques : 71 fichiers/membres ORA** hors horodatages et caches Python.
  `check_reproducibility.py` versionné pour rejouer cette comparaison.
- Régression EDR1 : build relancé et ses 16 tests repassés ; 30 PASS avec EFF1.
  Aucun changement d'un helper commun ou d'un lot antérieur.
- Scène et collisions inspectées. Archives contrôlées (CRC, sans caches Python) :
  projet 2,00 Mo/15 fichiers, PNG/ORA 5,08 Mo/51 fichiers. Aperçu autonome 2,58 Mo.
- Serveur de session 0.0.0.0:8005 : page et deux ZIP HTTP 200. Syntaxe JS contrôlée par
  `node --check`, données intégrées contrôlées ; pas de test automatisé des interactions navigateur.

## Limites et prochaine étape

`art_approved: false`, `runtime_tested: false`, `render_tested: false`.
Terrain généré référencé, formats/grille natifs seulement. Ni le chargeur réel, ni l'éditeur,
ni la caméra/échelle, le rendu ou les déplacements dans PMDO n'ont été exécutés.
Le chemin garde l'aspect de terre dallée de la référence ; l'arrivée est moins large que
l'intention du prompt. Ne pas présenter la proposition comme une validation artistique.

Prochaine étape : retour visuel sur cette direction forestière, puis contrôle dans PMDO 0.8.12.
Ne pas reprendre ESB1 ou le col de sable comme prochaine livraison par défaut.
Régénérer sorties, packs et aperçu selon `README_PACK.md` ; médias lourds ignorés par Git.

## Suite demandée

Après « passe a la suite », FFF1 — clairière finale assortie — est proposée séparément dans
`source/fin_foret_feuillus_v1/`. Le décor, le support et le code d'EFF1 restent inchangés.
La poursuite ne constitue pas une approbation artistique d'EFF1 ni un test moteur.
