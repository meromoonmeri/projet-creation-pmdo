# Audit de la logique spatiale des grounds

> Point de départ : « la carte est parfaitement établie, juste quand on spawn
> les entités ignorent toute logique spatiale, comme si on marchait sur une
> feuille, il ignore les reliefs etc ».
>
> Ce constat est **exact**. Il recouvre en réalité trois défauts distincts,
> mesurés ci-dessous. Aucun n'est validé en jeu : tout ce document repose sur
> de l'analyse statique.

## Pourquoi le décor et le relief peuvent diverger

Un `.rsground` contient **deux grilles indépendantes**, et rien dans le moteur
ne les met d'accord :

| grille | rôle | maille | source |
|---|---|---|---|
| `Layers[i].Tiles[x][y]` | ce qu'on **voit** | `8 × TexSize` px | `GroundMap.cs:49` |
| `obstacles[x][y].Tags` | ce qui **bloque** | 8 px fixe | `GroundMap.cs:287` |

Les tags sont interprétés par `GroundChar.basicCollision`
(`Ground/GroundChar.cs:341-352`) :

```
Tags = 0  ->  null            (libre)
Tags = 1  ->  SlideResponse   (mur : on glisse le long)
Tags = 2  ->  TouchResponse   (déclencheur)
Tags = 3  ->  CrossResponse   (traversable)
```

Importer une image en tuiles **sans construire la grille en face** produit
donc exactement la sensation décrite : un relief dessiné que la physique
ignore. C'est une feuille peinte.

Deux conséquences moteur à garder en tête :

- **Hors des bornes, il n'y a aucun mur implicite.** `findWalls`
  (`GroundMap.cs:723`) fait `continue` sur toute case hors carte. Le bord de
  map n'est pas une barrière.
- **En cinématique, plus rien ne bloque.** `basicCollision` renvoie `null` dès
  que `CutsceneMode` est actif (`GroundChar.cs:343`). Une scène scriptée peut
  donc traverser la roche sans que ça se voie — le bug n'apparaît qu'en jeu
  normal.

## Mesures sur les 276 grounds

Outil : `tools/audit_spatial.py` (`python3 tools/audit_spatial.py . -v`).

| défaut | avant | après |
|---|---|---|
| **A.** grille d'obstacles entièrement vide | 63 | 63 |
| **B.** au moins une entité murée | 69 grounds / 255 entités | 59 / 237 |
| **C.** au moins une entité dans une poche inaccessible | 6 / 11 | 6 / 11 |
| **D.** entité hors carte | 7 / 11 | 5 / 9 |

### Défaut B — ce qui est un vrai bug, et ce qui n'en est pas

Sur les 112 entités *entièrement* murées, la répartition par catégorie est
décisive :

| catégorie | nombre | verdict |
|---|---|---|
| `GroundObjects` | 94 | **faux positif** — un arbre, une tente, une barrière *sont* le mur |
| `Spawners` | 10 | **vrai bug** — un équipier naît encastré |
| `Markers` | 8 | **vrai bug** — cible de téléportation dans la roche |

Une entité seulement *partiellement* en contact avec un mur n'est pas un bug
non plus : le moteur applique `SlideResponse` et la fait glisser.

C'est pourquoi `tools/fix_spatial.py` **exclut les `GroundObjects`** de son
périmètre. Corriger les 94 reviendrait à arracher le décor.

## Corrections appliquées — 20 entités, 19 fichiers

Règle de relogement : case libre la plus proche **appartenant à la poche
accessible depuis le marqueur d'entrée**. Ce second critère est le point
important — déplacer une entité vers une case libre mais enclavée
remplacerait un bug visible par un bug invisible.

| ground | entité | avant | après | motif |
|---|---|---|---|---|
| champ_ravage | TEAMMATE_1 | (248,304) | (264,296) | murée |
| champ_sacre | TEAMMATE_2 | (192,304) | (168,296) | murée |
| etang_carapace | Boss_Marker | (224,208) | (200,176) | murée |
| foret_champignons | Boss_Marker | (216,200) | (216,184) | murée |
| foret_givree_oree | Cutscene_Marker | (136,72) | (136,216) | murée |
| gouffre_muet_bord | Cutscene_Marker | (144,128) | (160,128) | murée |
| greve_banquise | TEAMMATE_1 | (224,280) | (232,264) | murée |
| greve_claire | TEAMMATE_3 | (272,208) | (272,192) | murée |
| guild_heros_room | entrance_1 | (-73,462) | (0,216) | hors carte |
| ile_australe | TEAMMATE_2 | (184,328) | (160,320) | murée |
| ile_legendaire | TEAMMATE_2 | (264,256) | (240,248) | murée |
| lac_cascade | Boss_Marker | (216,168) | (216,152) | murée |
| luminous_spring | EVO_SUBJECT | (96,360) | (96,280) | murée |
| mare_tetards | TEAMMATE_1 | (224,328) | (240,320) | murée |
| marecage_cacahuete | TEAMMATE_2 | (176,328) | (152,320) | murée |
| mont_crevasse | TEAMMATE_1 | (200,328) | (208,312) | murée |
| mont_crevasse | Boss_Marker | (216,200) | (200,200) | murée |
| plaines_sauvages | Boss_Marker | (216,224) | (200,240) | murée |
| plancher_abysses | Boss_Marker | (232,184) | (216,200) | murée |
| shady_shop | Dreepy | (974,8) | (784,152) | hors carte |

Diff total : **33 lignes**, uniquement des champs `X`/`Y`. Vérifié :
`git diff | grep -cv '"X":\|"Y":'` renvoie **0**.

### Sérialisation — piège évité

Les `.rsground` du dépôt n'ont pas tous été écrits par la même version de
l'éditeur : **181** en `indent=1`, **69** en `indent=0`, **14** en `indent=2`,
**12** non reproductibles. Réécrire avec un style imposé aurait régénéré le
fichier entier et noyé une correction de 2 lignes dans un diff de plusieurs
milliers. L'outil détecte le style d'origine, le restitue, et **refuse
d'écrire** s'il ne parvient pas à reproduire le fichier au byte près.

## Défaut C — vérifié cas par cas, aucun n'est un bug

Les 11 entités « isolées » ont toutes été inspectées :

| ground | entité | verdict |
|---|---|---|
| metano_town / metano_town_nuit | Bank_Owner, Storage_Owner | **voulu** — tenanciers derrière un comptoir ; Metano Town est la référence validée |
| metano_cafe | Cafe_Owner, Cafe, Cafe_Sign | **voulu** — même motif |
| guild_second_floor | Mission_Board, Outlaw_Board | **voulu** — panneaux muraux, on les consulte de face |
| searing_tunnel_entrance | Kangaskhan_Rock | à revoir en jeu |
| marais_poison | Boss_Marker | à revoir en jeu |

Aucune correction appliquée : deux d'entre eux touchent des zones protégées.

## Défaut A — 63 grounds sans aucune collision

C'est le cœur du problème, et **il n'est pas résolu**. 15 de ces grounds
portent un `Boss_Marker` :

```
arene_clairiere_secrete   arene_hautes_plaines    arene_trone_magma
bois_antan_verger         couloir_legendes        creux_ombres_scelle
escalier_origine          fleche_reliques_courroux gue_poulain_autel
lac_courage               lac_espoir              lac_savoir
nef_prisme_est            porte_plaines_foudre    vallon_malsain_fond
vallon_perdu
```

### Trois pistes essayées, trois échecs documentés

**1. Déduction par la couleur** (`tools/gen_collisions.py`, mode `teinte`).
Sur `arene_trone_magma`, le résultat est **inversé** : le sol est marqué
bloquant, les stalagmites libres. Mesure au pixel :

| élément | RGB | luminance | saturation |
|---|---|---|---|
| sol de l'arène | (159,127,111) | 132 | 48 |
| stalagmite | (167,135,95) | **132** | 72 |

Même teinte brune, **même luminance**. Le seuil d'Otsu ne s'applique pas non
plus : l'histogramme n'est pas bimodal. Aucune règle de pixel ne peut séparer
un sol de grotte d'une paroi de grotte — ils sont faits de la même roche.

**2. Rugosité locale** (écart-type par cellule de 8 px) :
sol 17,65 (min 8,4 max 27,3) contre bords 21,68 (min 1,0 max 46,1).
Les plages se recouvrent presque entièrement. Écarté.

**3. Réutilisation d'un ground-modèle partageant le tileset.**
Résultat : **1 seul des 53** grounds vides tuilés trouve un modèle. Chaque
arène a sa planche unique (rips PMD Sky : `Groudon Boss Arena`,
`Darkrai Boss Arena`, `Azelf Lake 3`…). Écarté.

### Conclusion sur A

Ces 63 grilles demandent un **tracé manuel**, arène par arène, ou une source
de vérité externe (les données de collision du jeu d'origine, via
`pret/pmd-sky` / SkyTemple, pour les cartes qui en sont issues). Aucune
heuristique d'image ne s'en sortira, et **poser de mauvaises collisions est
pire que de n'en poser aucune** : une grille vide laisse au moins passer,
une grille fausse enferme le joueur.

`tools/gen_collisions.py` est conservé avec ses garde-fous (refus si < 20 %
praticable, si une entité serait murée, si l'entrée dessert < 60 % du sol) :
il refuse aujourd'hui les 4 arènes testées, et c'est le comportement voulu.

## Correctif d'outillage

`tools/render_ground.py` dimensionnait l'image de rendu sur `obstacles`
(maille 8 px) au lieu de `Layers[0].Tiles` (maille `8 × TexSize`). Sur une
carte `TexSize = 3`, le rendu sortait **3× trop grand**, décor tassé dans le
coin haut-gauche et bandes noires — un faux « problème de cadrage » purement
optique, qui aurait pu déclencher une refonte inutile de cartes saines.

Vérification après correction : `arene_trone_magma` rend en 648×624 px, décor
occupant 100 % de la surface. La carte est bien cadrée.

## Baselines — toutes tenues

```
audit_bugs.py         12 signalements
audit_integrite.py    849 anomalies
Lua                   673 fichiers, 0 erreur
verify_ground_registration   0 bloquante, 91 avertissements
verify_scene_positions       aucune entité hors carte
validate_all                 toutes les salles valides
```

## Reste à faire

1. **Défaut A** : tracer à la main les 15 arènes de boss sans collision, en
   priorité celles du fil narratif actif.
2. **Défaut C** : confirmer en jeu `searing_tunnel_entrance` et
   `marais_poison`.
3. **Validation en jeu de tout ce document.** Rien ici n'a été testé
   manette en main.
