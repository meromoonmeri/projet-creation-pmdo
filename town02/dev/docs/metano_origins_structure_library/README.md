# Structures Metano Town + Explorers of Sky: Origins

## Résultat livré

La bibliothèque contient **18 PNG RGBA indépendants** :

### Metano Town — jour et nuit

- `metano_cafe_day.png` / `metano_cafe_night.png` — 259×109 ;
- `metano_kecleon_shop_day.png` / `metano_kecleon_shop_night.png` — 112×120 ;
- `metano_house_normal_day.png` / `metano_house_normal_night.png` — 80×111 ;
- `metano_house_rock_day.png` / `metano_house_rock_night.png` — 96×96 ;
- `metano_house_fire_day.png` / `metano_house_fire_night.png` — 110×99.

Les identités sont confirmées par les zones fonctionnelles de `metano_town.rsground` :

- `Cafe_Entrance` ;
- `Shop`, avec les NPC Kecleon placés séparément dans la Ground ;
- `Normal_Home_Entrance` ;
- `Rock_Home_Entrance` ;
- `Fire_Home_Entrance`.

### Explorers of Sky: Origins

Source : `https://github.com/Minemaker0430/ExplorersOfSkyOrigins`, commit épinglé `159084383056c9552d174a87cbe098b933fc4a67`.

- quatre frames natives de `Content/Object/Windmill.dir`, 64×72 chacune ;
- quatre frames natives de `Content/Object/Well.dir`, 72×56 chacune.

Les frames sont séparées selon les limites exactes de la planche d’animation source. Elles ne proviennent pas d’une map et ne sont pas redimensionnées.

Aucune licence racine n’a été trouvée dans ExplorersOfSkyOrigins au commit épinglé. L’attribution au projet et aux auteurs listés dans son README doit être conservée ; la promotion distributive reste soumise à une revue de provenance.

## Méthode Metano

Les structures ne sont pas extraites depuis le rendu aplati de Metano Town.

Le script charge exclusivement les couches graphiques d’objets :

- `Objects Under` ;
- `Objects Under Anim` ;
- `Objects` ;
- `Objects Anim` ;
- `Objects Over` ;
- `Objects Over Anim` ;
- `Fringe`.

Les couches `Base`, `Cliffs`, `River` et la couche vide ne sont jamais utilisées. Les entités `MapChar`, dont Kecleon, ne sont jamais rendues.

Pour chaque structure :

1. les cellules PMDO et leurs PNG RGBA source sont composés sans interpolation ;
2. une zone autorisée manuellement vérifiée retire les décorations adjacentes ;
3. seule la composante alpha connectée contenant la structure est conservée ;
4. le résultat est resserré après application du masque ;
5. chaque pixel opaque est comparé avec les couches source ;
6. les références exactes `layer / map_cell / sheet / TexLoc` sont consignées dans `manifest.json`.

## Candidats volontairement non exportés

Trois maisons restent exclues du lot promu :

- `metano_house_grass` : clôture, panneau et fleurs graphiquement connectés ;
- `metano_house_water` : seau, rochers et fleurs graphiquement connectés ;
- `metano_house_electric` : arbre, fleurs et panneau graphiquement connectés.

Elles restent `BLOCKED_NOT_EXPORTED`. Aucun PNG contaminé n’est livré à leur place.

## Garanties

Pour les 18 fichiers :

- résolution native : oui ;
- transparence : oui ;
- NPC inclus : non ;
- terrain inclus : non ;
- palette modifiée : non ;
- interpolation : non ;
- redimensionnement source : non ;
- correspondance pixel source : 0 différence.

Statuts :

- extraction : `PIXEL_EXACT_SOURCE_STRUCTURE` ;
- conversion PMDO `GroundObject` : `NOT_RUN` ;
- validation PMDO 0.8.12 : `NOT_RUN` ;
- placement NNV : `NOT_PLACED`.
