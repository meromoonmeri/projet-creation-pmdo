# Constitution de continuité — trente ans après Rescue Team / Explorers of Sky

## Statut

Document autoritatif. En cas de contradiction, il prime sur les anciens audits, inventaires et plans qui classent les Aegis Cave au chapitre 7 ou imposent un renommage original aux lieux canoniques.

## Canon du projet

*New Era: Abyss to Ascension* est une suite située dans le même monde que *Pokémon Mystery Dungeon: Red/Blue Rescue Team* et *Explorers of Sky*, environ trente ans plus tard.

Les imports Sky/Red sont les fondations géographiques du monde : géométrie, collisions et positions structurantes sont conservées en 1:1 avant une retouche artistique manuelle montrant le temps écoulé.

## Verrou chronologique du chapitre 5

`cloven_ruins` / **Aegis Cave**, héritières d’**Aegis Cave**, constituent le **donjon final du chapitre 5**.

Chaîne canonique :

`vast_steppe` → `searing_tunnel` → `mount_windswept` → camp `cloven_ruins_entrance` → secteurs Aegis/Regi → Puits → `sanctuaire_titans` / Regigigas → révélation → `FinishedExpedition` → chapitre 6.

Le code actuel matérialise déjà cette intention :

- scripts d’entrée `cloven_ruins_entrance_ch_5.lua` ;
- drapeaux de défaite et victoire sous `SV.Chapter5` dans la zone ;
- sortie du Mont Venteux vers le camp des Ruines ;
- `RuinesRenforts` pose `RuinsExpeditionDone` et `FinishedExpedition` ;
- `ReplayEnding.cloven_ruins` lit `SV.Chapter5.SawAnimaCoreCorruption`.

Toute mention « cloven_ruins = chapitre 7 » est une dette documentaire ou un vestige de nommage interne, pas le canon.

Le chapitre 7 doit recevoir son propre rôle narratif ; il ne peut pas revendiquer à nouveau les Ruines comme donjon principal. Les champs historiques `SV.Chapter7.*Ruins*` ne doivent plus servir au flux principal et seront migrés uniquement avec une stratégie de compatibilité de sauvegarde.

## Portée obligatoire à partir de la fin du chapitre 5

À partir de la séquence finale du chapitre 5 et du début du chapitre 6, cette continuité gouverne **tout le contenu principal et secondaire**. Elle ne s’applique pas uniquement aux noms ou aux cinématiques.

Chaque lieu canonique doit être restauré comme un **paquet indivisible** :

1. nom canonique ;
2. Grounds canoniques d’entrée, de transition et de fin ;
3. zone JSON du même donjon ;
4. nombre d’étages et découpage canonique, adaptés seulement lorsque les trente années ou le scénario l’exigent explicitement ;
5. tilesets et progression visuelle du même lieu ;
6. tables de Pokémon, objets, pièges et mécaniques cohérentes avec ce donjon ;
7. salles fixes `.rsmap` issues ou reconstruites d’après ce même donjon ;
8. légendaire, boss et gardiens historiquement associés, sauf changement narratif documenté survenu pendant les trente années ;
9. musiques et ambiance du lieu ;
10. scripts d’entrée, de sortie, de défaite, de revanche et de sauvegarde ;
11. connexions géographiques avec les autres lieux canoniques ;
12. marques visibles du temps et casting New Era.

**Interdiction absolue :** prendre le Ground canonique d’un lieu et le greffer sur le JSON, le boss ou la fonction narrative d’un autre lieu. Un asset canonique n’est pas un décor générique.

### Directive de recasting cinématique Red/Sky

Pour chaque Ground cinématique hérité, les positions d’entités de la scène source sont contractuelles. Les personnages historiques sont remplacés rôle pour rôle par le casting New Era **aux mêmes coordonnées**, avec les mêmes orientations structurantes, le même ordre d’apparition, les mêmes mouvements, la même caméra, les mêmes pauses et les mêmes VFX. Les dialogues et les conséquences `SV.*` sont réécrits pour New Era. Il est interdit de recomposer librement la scène sur la carte canonique : la mise en scène originale est le patron, le casting est l’adaptation.

Exemple autoritatif : Sinister Woods D04P02 conserve les trois slots de Team Meanies — centre `(272,192)`, droite `(312,224)`, gauche `(240,224)` — réattribués respectivement à Adagio, Aria et Sonata.

### Unité spatiale cinématique → combat → conséquence

Toute confrontation se déroule dans un seul lieu visuel. Le Ground de pré-scène est la source de la `.rsmap` de combat : mêmes couches, décor, collision agrégée, météo et cadrage. Les positions 8 px du Ground sont converties sur la grille 24 px sans changer la composition. La post-scène revient sur ce même Ground. Une arène générique ou un changement de salle invisible derrière un fondu est interdit.

Exemples d’associations interdites à démêler :

- Wish Cave/Jirachi utilisé pour le Sanctuaire de Cristal/Diancie ;
- Sinister Woods utilisé comme entrée d’une forêt sans rapport et associée à Zeraora ;
- Northwind Field/Articuno utilisé comme arène de Tornadus ;
- Poison Swamp Friend Area utilisé comme boss ground d’un autre marais ;
- Sky Tower fractionnée entre plusieurs zones ou associée à Lugia.

Lorsqu’un scénario New Era a besoin d’un lieu inédit, il doit recevoir ses propres Grounds et son propre JSON. Il ne doit pas détourner un lieu canonique disponible dans la réserve.

## Deux catégories de lieux

### Lieux hérités

- nom canonique conservé ;
- provenance et version documentées ;
- fondation spatiale 1:1 ;
- vieillissement visible ajouté manuellement ;
- casting New Era par défaut ;
- personnage historique uniquement sur décision explicite.

### Lieux nouveaux

- nom original selon la convention du projet ;
- aucune usurpation d’un nom canonique pour créer artificiellement de la reconnaissance.

## Lieux prioritaires

- Treasure Town ;
- ville/camp de l’Équipe de Secours ;
- Aegis Cave / Aegis Cave ;
- Sky Tower ;
- Mt. Thunder ;
- Mt. Blaze ;
- Mt. Freeze ;
- Temporal Tower ;
- Spacial Rift ;
- Buried Relic ;
- autres réserves documentées dans `pmdred_extraction_tracabilite.md`.

## Statut des héros et personnages historiques

**Arbitrage encore ouvert — ne pas improviser dans un script.** Jusqu’à décision de l’auteur :

- aucune scène ne doit affirmer contradictoirement qu’un héros historique est mort, disparu, retraité et encore actif ;
- les mentions restent légendaires, indirectes ou explicitement incertaines ;
- une future décision unique devra préciser le statut des équipes de Rescue Team et Explorers, puis être propagée dans tous les dialogues.

## Définition de « lieu terminé »

Un lieu hérité n’est terminé que si : nom, provenance, géométrie/collision, marques des trente ans, casting, statut des figures historiques, statut du légendaire et connexions géographiques sont tous documentés et vérifiés.
