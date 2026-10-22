# Relict — rapport Sprint 3 timelines, timings et VFX

## Timings d'autotiles qualifiés

L'autorité source `Data/Scripts/006_Map renderer/001_TilemapRenderer.rb` fixe
`AUTOTILE_FRAME_DURATION = 5` en unités de 1/20 seconde. Les 17 autotiles animés
utilisés n'ont aucun suffixe de durée : leurs 88 frames ont donc une durée
source exacte de **250 ms chacune**. L'ordre, la boucle et les durées passent au
statut `SOURCE_DOCUMENTED`.

Seuls le chemin, le hash et la constante sont exportés. Aucun script n'est
exécuté ou copié dans les métadonnées.

## Timelines visuelles

Le pipeline produit 34 timelines de Maps (28 canoniques et 6 variantes
réellement divergentes) ainsi que 6 Common Events contenant des commandes
visuelles.

Éléments préservés dans l'ordre source :

- 680 attentes avec durée exacte en frames RGSS et valeur nominale à 40 FPS ;
- 332 routes forcées avec cible, mouvements, attentes et changements d'état ;
- 262 attentes de fin de mouvement ;
- 123 animations déclenchées sur entité ;
- 28 transferts de map ;
- 20 relocalisations d'entités ;
- 14 changements de panorama/fog ;
- 17 affichages, 14 déplacements et 51 suppressions de Pictures ;
- branches, boucles, appels de Common Events et labels nécessaires à la
  reconstruction du flux.

Les paramètres numériques, tones, couleurs et durées sont conservés. Les noms
de cast, dialogues, scripts, sons et Pictures potentiellement liés aux
personnages restent redacted sous forme de hashes.

L'autorité temporelle des événements est le tick RGSS nominal de 40 FPS, soit
25 ms, car `mkxp.json` ne contient aucun override `fixedFramerate` actif. Les
attentes restent attachées à leur branche et ne sont jamais additionnées comme
si le flux était linéaire.

## Ressources environnementales utilisées

Quatre dépendances de scène sont attestées et résolues :

- 3 panoramas statiques ;
- 1 fog animé (`forest.gif`).

Le fog est extrait en 12 PNG composités de 320×240. Les Graphic Control
Extensions du GIF donnent **100 ms par frame** et une boucle infinie. Le
coalescing ImageMagick est normalisé ensuite par le codec PNG déterministe du
pipeline ; la version et le hash de l'exécutable sont verrouillés dans le
manifest.

Les neuf Pictures utilisées par des scènes ont été examinées pixel par pixel et
verrouillées par hash source :

- 3 images avec humains/Pokémon : `EXCLUDED_CHARACTER` ;
- 1 écran texte de fin : `EXCLUDED_UI` ;
- 5 overlays/fonds strictement environnementaux : inclus.

La file `REVIEW_REQUIRED` est vide. Les quatre exclusions ne conservent que hash
et contextes, sans pixels ni nom source. Parmi les cinq inclusions, deux GIF
animés sont exportés frame par frame : 144 frames avec durées exactes de 70 ou
100 ms selon leur Graphic Control Extension, et 4 frames à 300 ms. Les trois
autres overlays sont normalisés en PNG avec provenance complète.

## Audit statique des commandes de script

Les événements contiennent 1 143 commandes de script/continuation, toujours
redacted et jamais exécutées. L'analyseur regroupe les continuations par bloc,
hashe le corps sans l'exporter et n'extrait que les appels visuels reconnus.

Résultat : 199 blocs visuels et 204 appels structurés :

- 113 changements de tone ;
- 27 scrolls caméra ;
- 16 cadrages caméra sur entité ;
- 14 démarrages et 14 arrêts de camera shake ;
- 13 resets caméra ;
- 5 animations utilisateur positionnées ;
- 2 attentes exprimées en secondes.

Tous leurs paramètres numériques, tones, coordonnées, durées, cibles et plages
aléatoires sont conservés. Aucun bloc contenant un mot-clé visuel ne reste sans
classification (`static_script_visual_audit_required_count = 0`). Les autres
commandes restent uniquement comptées comme gameplay/script redacted.

Aucun appel caméra/tone/VFX connu et aucune Picture utilisée ne restent sans
classification. Les systèmes et contenus non visuels restent redacted.

Aucune conversion PMDO n'est commencée.
