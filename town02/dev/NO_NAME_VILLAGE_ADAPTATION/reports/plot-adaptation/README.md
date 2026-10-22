# Réadaptation architecturale de la zone extérieure NNV

Les 4 maisons NNV de `rmvillage` sont remplacées par des bâtiments PMU natifs,
et **chaque parcelle a été réadaptée à l'emprise réelle de son nouveau bâtiment**.

## Audit parcelle par parcelle

| Parcelle NNV | Maison originale | Asset PMU | Dimensions PMU | Nouvelle emprise | Parcelle réadaptée | Chemin adapté | Décor conservé | Statut |
|---|---|---|---:|---|---|---|---|---|
| Sud-ouest | `objplayerhouse` 150×123 | `tiles9_0744` | **122×120** ×1 | (50,361) | −815 herbe / +34 restaurée | accès sud 48×72 | arbres, falaise, rochers | **ADAPTÉE** |
| Nord-ouest | `objloggerhouse` 118×105 | `tiles9_0422` | **116×99** ×1 | (102,181) | −647 herbe | accès sud 48×72 | arbres, muret, souche | **ADAPTÉE** |
| Est | `objhunterhouse` 118×107 | `tiles9_0434` | **115×98** ×1 | (478,215) | −695 herbe | accès sud 48×72 | arbres, panneau | **ADAPTÉE** |
| Nord | `objcarpenterhouse` 149×91 | `tiles9_0406` | **126×94** ×1 | (176,3) | −551 herbe | accès sud 48×72 | arbres, chemin nord | **ADAPTÉE** |

Ratios d'emprise : **0,79× / 0,93× / 0,89× / 0,87×** — chaque bâtiment est
proche de l'ancien sans l'égaler, donc la parcelle a réellement été redessinée
autour de lui plutôt que laissée surdimensionnée.

## Méthode

La parcelle n'est pas un objet séparé dans NNV : `NNV ground` est un lit de
terre **uniforme** (6 084 cellules, une seule tuile) et `grass0`/`grass1`
peignent l'herbe par-dessus. **Une parcelle nue = une absence d'herbe.**

Réadapter une parcelle revient donc à éditer uniquement les couches d'herbe,
avec des tuiles **déjà présentes dans le tileset NNV** :

1. retrait de l'ancienne structure sur son emprise (`HouseBelow`, `sHouseBelow`) ;
2. retrait du bloc de porte sur `NNV instances` + de l'entité `Exit_Door_*` ;
3. dégagement de l'herbe sur la nouvelle emprise + marge de circulation 16 px ;
4. dégagement d'un couloir d'accès 48×72 px vers l'entrée sud ;
5. **restauration d'herbe** là où l'ancienne parcelle débordait le nouveau
   bâtiment (34 cellules sur la parcelle sud-ouest) ;
6. collision : ancienne emprise libérée, nouvelle dérivée du masque alpha réel
   du bâtiment (règle majorité sur bloc 8×8).

Aucun sol, arbre ou chemin d'une autre map n'a été importé.

## Assets PMU — ×1 strict

| Contrôle | Résultat |
|---|---|
| Redimensionnement | **aucun** — dimensions natives conservées |
| Recoloration / interpolation | aucune |
| Sources `docs/pmuniverse_buildings` | **intactes** (143 hashes vérifiés) |
| Vérificateurs | 5/5 au vert |

Les bâtiments sont intégrés via une planche dédiée
`NNV_rmvillage_PMU_Buildings.tile` et posés en `GroundObject` decorations : le
tileset NNV n'est pas modifié.

## Validation

| Point | Résultat |
|---|---|
| Monde / TexSize / collision | 624×624 · `TexSize 1` · grille 78 |
| Portes `Exit_Door_*` restantes | **0** (les 4 retirées) |
| Bâtiments PMU posés | **4** |
| Collision bloquée | 35,0 % (contre 37,6 % avant) |
| `NNV HouseBelow` restant | **0 cellule** |
| Entrées/sorties de bord | 10 markers préservés |
| 4 saisons | alignées : `tex 1`, `[624,624]`, `HouseBelow=0` |
| Terrain NNV identifiable | **oui** — arbres, falaises, chemins intacts |
| Asset d'une autre map | **aucun** |

## Intérieurs — hors périmètre

`playerhouse`, `loggerhouse`, `hunterhouse`, `carpenterhouse` **ne sont pas
convertis**, conformément à la consigne.

**Conséquence à noter** : les 4 entités `Exit_Door_*` ayant été retirées avec
les maisons, il n'existe plus aucune référence vers ces intérieurs. Les
références cassées signalées à l'audit précédent sont donc **supprimées, pas
réparées**. Si les nouveaux bâtiments PMU doivent être pénétrables, il faudra
créer explicitement une entrée par bâtiment — à documenter séparément.

## Réserve : `sHouseBelow`

3 cellules subsistent sur `sHouseBelow` en été (0 dans les autres saisons).
Elles sont hors des 4 emprises traitées — vraisemblablement une ombre portée
isolée. **Non supprimée** faute de preuve qu'elle appartient à une maison
retirée. À trancher.

## Rendus

- `NNV_ADAPTED_GLOBAL.png` — vue complète 624×624
- `PLOTS_CROPS.png` — les 4 parcelles avec un Pokémon PMDO ×1 à l'entrée

## Statut

`PLOTS_ADAPTED_RUNTIME_NOT_RUN`. Le runtime PMDO 0.8.12 reste indisponible
(bundle headless absent du cache) : **non certifié**.
