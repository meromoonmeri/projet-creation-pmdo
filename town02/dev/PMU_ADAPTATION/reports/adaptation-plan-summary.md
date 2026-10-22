# PMU → PMDO — plan d’adaptation intelligent

- **Gate phase 1 :** `PASS`
- **État phase 2 :** `PHASE2_PLANNED`
- **Maps planifiées :** 2000
- **Grounds générés :** 0
- **Grounds validés runtime :** 0
- **Grounds certifiés :** 0
- **Profils TexSize locaux :** {1: 433, 2: 1476, 4: 91}
- **Catégories reconstruites :** {'connector': 292, 'settlement': 96, 'dungeon': 368, 'indoor': 1163, 'special': 81}

## Ce que ce plan interdit

- aucune utilisation du PNG source comme image de map PMDO ;
- aucune interpolation ou mise à l’échelle globale ;
- aucune copie de layout depuis Metano ou un autre Ground ;
- aucun viewport, zoom, `TexSize` ou skin global ;
- aucune invention pour les types 101/103, les destinations calculées ou Silversail.

## Contrat géométrique

Chaque map conserve son empreinte physique source tant qu’une transformation différente n’est pas justifiée localement. Les éléments 32 px sont reconstruits sur une grille PMDO de 8, 16 ou 32 px choisie par map. La collision reste une grille native de 8 px. Les bâtiments, routes, respirations, warps, NPC et autres anchors doivent conserver leurs relations topologiques ; une référence PMDO ne fournit que sa grammaire visuelle locale, jamais son layout.

## État honnête

Ce livrable commence la phase 2 de façon exhaustive, mais ne prétend pas l’avoir terminée : aucun `.rsground` n’est émis par le planner. Un Ground mécanique source-looking serait précisément le faux résultat interdit. Chaque map reste `NOT_GENERATED` jusqu’à résolution de sa composition native, puis devra passer le vrai runtime PMDO 0.8.12 via la méthode headless d’Agent A.

## Cibles critiques

- Grassroot : plans `s737` et `s1810` ;
- Snowbasin : plan `s1991` ;
- Silversail : `UNKNOWN`, aucun plan ni image substituée.
