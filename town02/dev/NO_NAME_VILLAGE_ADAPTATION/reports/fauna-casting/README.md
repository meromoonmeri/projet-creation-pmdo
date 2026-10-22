# Casting Pokémon de la faune NNV — proposition

**Statut : `PROPOSAL_AWAITING_VALIDATION`. Aucun Ground, aucun `.rsground`,
aucun script Lua n'a été modifié.** Ce dossier est une proposition motivée,
pas une application.

Périmètre : les **2 019 occurrences** de faune source recensées dans
`reports/fauna-fix/fauna-occurrences.json` (36 objets, 45 rooms), dont 1 483
avaient été baked à tort dans les Grounds et ont été reconverties.

## Méthode

Aucune espèce n'a été choisie « au feeling ». Pour chaque objet source :

1. **Sprite décodé** depuis les textures officielles (`Sprites.json` +
   `TexturePageItems.json` + pages QOI), rendu en PNG à l'échelle 1, sans
   rééchantillonnage autre que NEAREST pour la planche de contact.
2. **GML lu** (`decompiled-gml.tar.gz`) : `hp`, `maxhp`, `dmg`, `level`,
   `season`, `collision`, comportements (`dig`, `fly`, `water`, `jump`…).
3. **Parent GameMaker** vérifié : `objbgmob` = ambiance sans HP,
   `objmob` = créature avec HP et dégâts.
4. **Espèce validée** dans `Data/Misc/MonsterFeature.json` (1 011 espèces
   disponibles) : existence, types, stade évolutif, famille.
5. **Attestation dépôt** : présence ou non de l'espèce ailleurs dans
   `Data/Map`, `Data/Zone`, `Data/Ground`.

Planches de contact jointes : `source-fauna-sheet.png` (les 36 objets),
`source-fauna-detail.png` et `source-fauna-detail-2.png` (zoom ×10 sur les
silhouettes déterminantes).

## Contrainte respectée

- **Générations 1 à 7 uniquement** — vérifié : génération maximale utilisée =
  **7** (Cutiefly). Aucun Pokémon de gen 8/9.
- Aucun légendaire, aucun fabuleux (règle du projet).
- Toutes les entités restent **16×16 px**, échelle PMDO. Aucun asset
  redimensionné.

## Le casting — 24 espèces pour 2 019 occurrences

| Espèce | Occ. | Gen | Types | Comportement | Niv. |
|---|---:|---:|---|---|---:|
| Vivillon | 478 | 6 | bug/flying | ambient_flying | 1 |
| Cutiefly | 369 | 7 | bug/fairy | ambient_flying | 1 |
| Volbeat | 326 | 3 | bug | ambient_night | 1 |
| Fletchling | 185 | 6 | normal/flying | ambient_flying | 3 |
| Croagunk | 125 | 4 | poison/fighting | ambient_ground | 3 |
| Magikarp | 108 | 1 | water | timid | 5 |
| Cradily | 92 | 3 | rock/grass | territorial | 12 |
| Illumise | 59 | 3 | bug | timid | 5 |
| Jumpluff | 38 | 2 | grass/flying | timid | 6 |
| Barboach | 32 | 3 | water/ground | timid | 4 |
| Swinub | 27 | 2 | ice/ground | timid | 10 |
| Ledyba | 20 | 2 | bug/flying | timid | 6 |
| Murkrow | 20 | 2 | dark/flying | timid | 10 |
| Piloswine | 19 | 2 | ice/ground | territorial | 20 |
| Chinchou | 17 | 2 | water/electric | timid | 12 |
| Swanna | 17 | 5 | water/flying | territorial | 14 |
| Sandshrew | 16 | 1 | ground | timid | 4 |
| Skorupi | 16 | 4 | poison/bug | territorial | 14 |
| Lotad | 14 | 3 | water/grass | timid | 6 |
| Dwebble | 13 | 5 | bug/rock | territorial | 10 |
| Wooper | 8 | 2 | water/ground | timid | 6 |
| Bellsprout | 8 | 1 | grass/poison | ambient_ground | 4 |
| Ledian | 7 | 2 | bug/flying | territorial | 12 |
| Wingull | 5 | 3 | water/flying | timid | 6 |
| **Total** | **2 019** | | | | |

Le détail objet par objet, avec la preuve visuelle et la preuve GML de chaque
choix, est dans `fauna-casting.json`.

## Cohérences remarquables obtenues

- **Ledyba → Ledian** : `objmobau0` (maxhp 4, level 1) et `objmobau1`
  (maxhp 6, level 3) partagent la même palette rouge/jaune et la même
  morphologie de coccinelle ; le second est plus grand et plus élancé. La ligne
  évolutive reproduit exactement la relation du GML.
- **Swinub → Piloswine** : `objmobwn0` (maxhp 8) est une boule de fourrure
  crème ; `objmobwn4` (maxhp 35, `dig` + `bite`, `collision = false`) n'a plus
  qu'un masque de collision et des traînées de neige — la même bête, adulte et
  chargeante.
- **Vivillon** couvre `objbutterfly1`, l'entité la plus fréquente de tout le
  jeu (478 occurrences), et est déjà attestée dans `Data/Zone/bassin_tari.json`.
- **Volbeat** pour `objfirefly` : le GML place l'objet à `z = 64` avec un
  sprite clignotant `sfire10..12`. C'est la luciole canonique.

## 14 objets marqués `REVIEW` — je ne tranche pas seul

1. **La chaîne `objmobsm5` / `objmobsm501..510`** (108 occurrences). Ce sont
   dix états d'un même objet : un amas laiteux dont la taille suit `hp`, et
   `objmobsm5` fait naître un `objmob0` (poisson) dans 10 % des cas. Lecture :
   une **ponte aquatique**. Magikarp est le seul frai canonique disponible,
   mais **le sprite source ne montre aucun poisson** — juste une masse. Trois
   options : (a) Magikarp, (b) une espèce d'œufs/frai différente, (c) laisser
   ces 108 occurrences en décor aquatique et ne pas les caster.
2. **`objmobsm40`** (8 occ.) : `ssmbplant001` est une tige verte ancrée au sol
   à bulbe rouge. Bellsprout est plausible, mais l'objet ne se déplace pas :
   ça peut aussi rester du décor.
3. **`objmobau4` et `objmobwn1`** (17 occ. cumulées) : même silhouette
   d'échassier bleu-gris à long cou, mais **deux objets saisonniers distincts**
   (automne / hiver). Je leur ai donné Swanna à tous les deux. Si tu veux deux
   espèces différentes, c'est une décision de design, pas une preuve.

## Duels à l'état sauvage

Réponse complète et sourcée dans **`DUELS_SAUVAGES_PMDO.md`**.

En un paragraphe : **PMDO n'accepte pas de combat sur un Ground.** `GroundChar`
n'a pas de champ HP, il n'y a ni faction ni tour dans la couche Ground, et le
bouton « Attaque » y est recâblé sur le dialogue (`GSceneZone.cs` l. 143 →
`ProcessObjectInteract`). Un duel sauvage est donc possible mais se construit
autrement : cinématique sur le Ground, puis `ContinueDungeon` vers un segment
`IsRelevant = false` portant une `.rsmap` dédiée — exactement le patron déjà
utilisé par le duel Team Dazzling et les pillards de Metano dans ce dépôt.
Bonus utile : `Team.FoeConflict = true` sur une équipe `AllyTeams` donne des
sauvages pacifiques envers le joueur mais hostiles entre eux ; le mod ne s'en
sert nulle part pour l'instant.

## Prochaine étape (bloquée sur ta validation)

Rien ne sera écrit tant que tu n'as pas tranché sur :

- le casting ci-dessus, en bloc ou espèce par espèce ;
- les 3 points `REVIEW` (frai, plante, échassier) ;
- si tu veux des duels, lesquels et où.
