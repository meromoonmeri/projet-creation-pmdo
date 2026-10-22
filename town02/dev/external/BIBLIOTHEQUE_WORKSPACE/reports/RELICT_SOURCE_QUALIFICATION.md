# Relict — qualification complète de la source

## Verdict

Les **28 Zones canoniques** passent au statut `SOURCE_DOCUMENTED`.

Cette promotion est automatique uniquement lorsque tous les gates suivants
sont vrais :

- géométrie et trois couches intégralement conservées ;
- collisions brutes et dérivées complètes ;
- 115 placements d'entités/pages documentés ;
- 68 identités de casting remplacées par des placeholders ;
- toutes les dépendances environnementales résolues ;
- 34 previews sans tile manquant ;
- contact sheet des 28 Maps et 6 variantes divergentes revue le 13 août 2026 ;
- 17 autotiles animés avec timing exact ;
- 3 overlays/fogs GIF avec timing exact ;
- 10 animations de Map et 231 frames documentées ;
- 199 blocs de script visuel et 204 appels structurés ;
- aucune candidate visuelle scriptée non classifiée ;
- 9 Pictures décidées par hash : 5 environnementales, 4 casting/UI exclues ;
- aucune file `REVIEW_REQUIRED`, dépendance manquante ou transformation non
  supportée.

## Séparation

La qualification ne contient aucun dialogue, corps de script, sprite humain,
trainer, Pokémon, audio, moteur ou exécutable. Les fichiers sources restent
dans le sous-module épinglé et ne sont jamais modifiés.

## Conséquence

Le pipeline peut désormais commencer une **normalisation intermédiaire** puis
un pilote de conversion PMDO. Cela ne constitue pas encore une autorisation
d'intégrer les Maps dans New Era : toute conversion devra conserver couches,
collisions, entités placeholders, timings, animations et VFX, puis être validée
séparément dans RogueEssence/PMDO.
