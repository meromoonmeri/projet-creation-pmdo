# Les 11 rooms `NO_PROOF` — rendues et auditées

`PROMOTION_MANIFEST.json` retenait **57 entités** en `NO_PROOF` avec ce motif :

> « ni rendu ni collision : Ground reconverti inexistant »

Le motif portait sur deux manques distincts. Celui du **rendu** est levé ici.
Celui de la **collision** ne l'est pas.

## Ce qui est maintenant prouvé

Les 11 rooms existent dans la source GameMaker et se rendent intégralement.

| Room | Tuiles | Assets | Instances | Remplissage | Non résolu |
|---|---:|---:|---:|---:|---:|
| `rm38` | 17 589 | 81 | 583 | 100 % | 0 |
| `rm47` | 18 701 | 63 | 420 | 100 % | 0 |
| `rm48` | 19 752 | 76 | 363 | 100 % | 0 |
| `rm49` | 15 765 | 25 | 685 | 100 % | 0 |
| `rm57` | 18 738 | 33 | 539 | 100 % | 0 |
| `rm68` | 20 029 | 60 | 434 | 100 % | 0 |
| `rm77` | 19 781 | 23 | 288 | 100 % | 0 |
| `rmcave1` | 7 503 | 1 | 7 | 95,6 % | 0 |
| `rmcave1_0` | 8 519 | 0 | 133 | 94,9 % | 0 |
| `rmcave1_1` | 8 599 | 0 | 170 | 94,9 % | 0 |
| `rmcave1_2` | 7 686 | 0 | 198 | 97,9 % | 0 |

**Le remplissage inférieur à 100 % des quatre grottes n'est pas un défaut**, et
ce n'est pas le compteur qui le dit : l'image a été regardée. `rmcave1` est une
galerie sinueuse tracée dans un canevas 4992×4992. Le noir autour d'elle est le
hors-cavité, qui n'a jamais reçu de tuile dans la source. Un remplissage à
100 % sur ces rooms signalerait au contraire un bug de rendu.

Toutes les rooms affichent **0 tuile, 0 asset et 0 instance non résolus**. Ce
chiffre-là ne prouve rien à lui seul non plus ; il complète l'inspection, il ne
la remplace pas.

## Audit des créatures — 152 créatures, 0 sans Pokémon

Même méthode que pour les 34 rooms promues, et pour la même raison : **le nom
d'un objet ne prouve rien**. Une créature est un objet GameMaker descendant de
`objbgmob` ou `objmob`, hiérarchie remontée via `ParentId`.

| Objet source | Instances | Pokémon |
|---|---:|---|
| `objmob2` | 92 | `cradily` |
| `objmob1` | 16 | `sandshrew` |
| `objmobwn0` | 16 | `swinub` |
| `objmobwn2` | 12 | `crabrawler` |
| `objmobwn5` | 9 | `delibird` |
| `objmobwn1` | 3 | `ducklett` |
| `objmobwn4` | 3 | `piloswine` |
| `objmobwn0_old` | 1 | `swinub` |

**8 objets distincts, tous castés. Aucun être vivant sans Pokémon.**

`objmob1` → `sandshrew` et `objmob2` → `cradily` sont précisément les deux
espèces marquées `HELD` dans `PROMOTION_MANIFEST.json`, et leurs 108
occurrences sont bien toutes dans `rmcave1*`, comme le rapport l'annonçait.
L'audit indépendant retombe sur la même localisation.

### 10 faux positifs de nom écartés sur preuve

`objwnplant0`, `objwnplant03`, `objwnplant04`, `objwnplant05`, `objwnplant06`,
`objwnplant08`, `objwnplant09`, `objwnplant12`, `objwnplant13`, `objwnplant14`
contiennent « ant ». Leur hiérarchie réelle est
`objplant0x → objplant00 → objdepthparent` : ce sont des **plantes d'hiver**,
aucun ancêtre `objbgmob`/`objmob`. Elles ne deviennent pas des Pokémon.

## Ce qui reste non prouvé

Ces PNG montrent **la source GameMaker, pas le résultat PMDO**. Les insectes et
oiseaux qu'on y voit sont les sprites d'origine : ils servent de référence de
casting, ils ne sont pas le rendu final.

Les 57 entités restent donc `NO_PROOF` et **ne sont pas promues**. Il y manque :

1. la **conversion** des 11 rooms en Grounds PMDO (`convert_environment_room.py`
   sur chacune) ;
2. la **grille de collision 8 px** qui en découle, sans laquelle un placement
   écologique ne peut pas être vérifié ;
3. le **runtime PMDO 0.8.12**, toujours inexécutable : ni `dotnet` ni `mono`
   dans le bac à sable, et les cinq hôtes de distribution .NET répondent `000`.

L'écart entre les **152 créatures** comptées ici et les **57 entités**
`NO_PROOF` est normal et n'est pas une contradiction : 152 est le nombre de
créatures **dans la source**, 57 le nombre d'entités que le placement
écologique avait retenues pour ces rooms. Les deux chiffres ne mesurent pas la
même chose.

## Reproduire

```bash
python3 NO_NAME_VILLAGE_ADAPTATION/tools/render_nnv_rooms.py \
  --inventory /tmp/nnv/inventory --textures /tmp/nnv/textures \
  --out reports/noproof-rooms \
  --rooms rm38,rm47,rm48,rm49,rm57,rm68,rm77,rmcave1,rmcave1_0,rmcave1_1,rmcave1_2

python3 NO_NAME_VILLAGE_ADAPTATION/tools/audit_creatures_noproof_rooms.py
```

## Statut

`RENDERED_AND_AUDITED · NOT_CONVERTED · NOT_CERTIFIED`
