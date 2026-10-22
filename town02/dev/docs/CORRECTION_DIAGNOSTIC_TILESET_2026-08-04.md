# Correction : mon diagnostic « tileset » était partiellement faux

Date : 2026-08-04. Ce document corrige
`FORMAT_TILESET_ROGUEESSENCE_2026-08-04.md`, écrit quelques heures plus
tôt, dont la conclusion principale était erronée.

---

## 1. Ce que j'avais affirmé

> « Mes planches ont 0,2 % de redondance contre 90,3 % pour la
> référence PMD. Je découpe une image au lieu de composer une carte. »

J'en avais tiré qu'il fallait **composer** la carte en réutilisant un
petit jeu de tuiles. J'ai écrit `composer_carte.py`, atteint 95,5 % de
redondance… et produit un résultat visuellement mauvais.

---

## 2. Ce que la vérification montre

J'ai récupéré `mystifying_forest_entrance.rsground` du dépôt
**slothplaysnecro/PMDO-Explorers-Maps** — une carte authentique
d'Explorers of Sky portée sous RogueEssence :

```
carte 600x504 px, TexSize 3
838 tuiles distinctes / 838 cases  ->  REDONDANCE 0,0 %
```

Et le détail du placement :

```
case (0,0) -> tuile (0,0)
case (0,1) -> tuile (0,1)
case (1,0) -> tuile (1,0)
```

**Case (x,y) → tuile (x,y).** Exactement ce que fait ma méthode.

Un ground officiel du jeu d'origine a donc la même « anomalie » que mes
planches. Ma métrique mesurait donc autre chose que ce que je croyais.

---

## 3. Où se trouve réellement la déduplication

Elle est **dans le fichier `.tile`**, pas dans le `.rsground`. Le format
`.tile` stocke une table `(clé → offset)` ; deux cases identiques
partagent le même offset :

| Planche | Cases déclarées | Images réelles | Déduplication |
|---|---|---|---|
| Mystifying Forest Layer 1 (officiel) | 525 | **285** | **45,7 %** |
| Camp_Ruines_Base (la mienne) | 3 672 | 3 663 | **0,2 %** |

C'est là qu'est le vrai écart. Sur une planche officielle, la tuile la
plus partagée sert 16 fois ; sur la mienne, 10 fois seulement, sur une
planche 7 fois plus grande.

La cause n'est donc pas « je découpe une image » — les cartes
officielles portées le font aussi. La cause est que **mon image source
n'a aucune zone strictement identique**, parce qu'elle est peinte avec
des dégradés continus, alors qu'un décor dessiné à la main répète
littéralement les mêmes blocs de 24 px.

---

## 4. La bonne solution, et elle n'est pas celle que je poursuivais

Composer une carte à partir d'un jeu de tuiles est un travail
d'**artiste**, pas d'algorithme : le placement des lisières, des
transitions et des accidents de terrain relève du dessin. Mon
`composer_carte.py` atteint la bonne statistique et produit un damier.

La voie réaliste est de **partir de grounds authentiques existants** et
de les adapter. Recensement fait :

| Dépôt | Grounds | Tilesets | Intérêt |
|---|---|---|---|
| slothplaysnecro/PMDO-Explorers-Maps | **82** | 135 | cartes EoS complètes, prêtes |
| Minemaker0430/ExplorersOfSkyOrigins | 95 | 145 | déjà utilisé partiellement |
| PMDCollab/RawAsset | — | nombreux | bibliothèque communautaire |
| Logical321/ProjectEoN | — | 68 | tilesets supplémentaires |

`PMDO-Explorers-Maps` n'avait jamais été exploité dans ce projet. Il
contient notamment, tous authentiques :

```
mystifying_forest_entrance   waterfall_cave_entrance
crystal_cave_entrance        crystal_crossing_entrance
crystal_lake_1/2/3           dark_crater_entrance
quicksand_cave_entrance      northern_desert_entrance
steam_cave_entrance          brine_cave_entrance
temporal_tower_entrance      hidden_land_entrance
treeshroud_forest_entrance   mt_bristle_entrance / peak
mt_travail_entrance / peak   apple_woods_entrance / end
drenched_bluff_entrance/end  sealed_ruin_entrance / pit
aegis_cave_entrance          deep_aegis_cave_regigigas_boss_arena
groudon_boss_arena           darkrai_boss_arena
far_amp_plains_boss_arena    dusknoir_boss_arena
```

---

## 5. Conclusion

Je ne suis pas capable de produire du pixel art PMD authentique par
génération : ni en peignant une image entière (rendu volumétrique,
0,2 % de déduplication), ni en composant algorithmiquement (damier).

La méthode qui donne un résultat digne du jeu est de **réutiliser les
grounds officiels portés**, en les habillant et en y branchant la
géométrie et les scripts du mod. C'est ce qui a été fait avec succès
pour l'arène Regigigas, jugée « magnifique » par l'auteur — et elle
venait précisément d'un tileset officiel du dépôt.
