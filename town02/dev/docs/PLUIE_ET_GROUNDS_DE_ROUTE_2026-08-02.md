# Pluie jouable et grounds de route — réponses vérifiées

Date : 2026-08-02 — branche `new-era-1-9`

Deux questions, deux réponses adossées aux fichiers.

---

## 1. La pluie : oui, et sans créer un seul asset

### Ce que j'avais dit et pourquoi c'était incomplet

J'ai écrit qu'« aucun MapStatus de pluie n'existe ». C'était exact pour le
**projet** (10 MapStatus, aucun de pluie) mais je n'avais pas vérifié le
**moteur**. C'était une conclusion trop rapide.

### Ce que montrent les sources

`winter_snow.json` du projet utilise déjà un émetteur nommé
**`ScreenRainEmitter`** — l'émetteur de pluie du moteur, détourné pour de la
neige. Le mécanisme était donc là depuis le début.

Et le jeu de base définit un MapStatus `rain` complet, avec ses paramètres
exacts, dans `PMDODump/DataGenerator/Data/MapStatusInfo.cs` (`ii == 1`) :

```csharp
ScreenRainEmitter rain = new ScreenRainEmitter(new AnimData("Rain", 1, 0, 0));
rain.HeightSpeed = -360;
rain.SpeedDiff  = 120;
rain.BurstTime  = 3;
rain.ParticlesPerBurst = 2;
rain.ResultAnim = new AnimData("Rain", 1, 1, -1);
rain.Layer = DrawLayer.Top;
```

**L'animation `Rain` est fournie par le moteur.** Elle n'a pas à être ajoutée
dans `Content/Particle/` — ce dossier ne contient que 4 animations propres au
projet (`Snow_Fall`, `Ash_Fall`, `Sakura_Fall`, `Leaf_Fall`).

### Ce que j'ai créé

`Data/MapStatus/falling_rain.json` — « Pluie battante » :

- structure reprise de `winter_snow.json` (même famille : météo décorative de
  surface, `DefaultHidden: true`, aucun effet de combat) ;
- émetteur aux paramètres canoniques ci-dessus : chute rapide et oblique
  (`HeightSpeed -360` contre `-55` pour la neige, `SpeedDiff 120` contre `18`),
  salves serrées (2 particules toutes les 3 frames contre 3 toutes les 10) ;
- **volontairement sans effet de combat**, contrairement au `rain` de donjon
  qui booste l'Eau et affaiblit le Feu. Ici c'est de l'ambiance de ground : la
  pluie ne doit pas modifier l'équilibre d'un affrontement.

Enregistré dans `Data/MapStatus/index.idx` (11 entrées désormais).

### Précaution de format

`GROUND:AddMapStatus` **échoue en silence** sur un nom absent : un nom mal
orthographié donnerait une scène sans pluie et sans message d'erreur. D'où la
vérification du round-trip avant toute écriture.

Format des `.json` de MapStatus, établi par test et non supposé :
**BOM UTF-8 + indentation 2 + saut de ligne final**. Ma première tentative a
échoué (mon test s'arrêtait au premier indent et ne testait pas le `\n` final) ;
`tools/make_rain_mapstatus.py` refuse maintenant d'écrire si le modèle n'est pas
reproduit à l'octet près, et relit le fichier produit pour contrôle.

Usage : `GROUND:AddMapStatus("falling_rain")`.

---

## 2. Les grounds de route : ils existent déjà

Votre intuition était juste. En croisant EoSO et le projet :

### Côté EoSO

`crossroads`, `crossroads_assembly`, `crossroads_south` — le réseau de
carrefours qui relie Treasure Town au reste du monde. Plus `sunset_view` et
`guild_gate_view`, deux **cartes de contemplation** sans autre fonction que de
marquer un moment.

### Côté New Era — le meilleur candidat

**`carrefour_nord`** (importé de `crossroads`) :

| | |
|---|---|
| Grille | 54×57 cellules = 432×456 px |
| Décor | **3 078 tuiles posées** — la carte est entièrement peinte |
| Collisions | 32,2 % franchissable, **une seule zone** (aucun îlot isolé) |
| Entités | **zéro** — aucune scène existante à ménager |
| Musique | `Treasure Town.ogg` (à changer pour un départ) |

Sa géométrie est un **vrai carrefour en croix**, relevé sur la grille :

```
   0 ###########.....###########     voie nord (départ)
  96 ##########.......##########
 160 ...........................     branche est-ouest traversante
 192 ...........................
 224 ####...........######...###
 304 ############...############     voie sud (arrivée)
 448 ##########.......##########
```

Chemins vérifiés par parcours en largeur sur les collisions réelles :

| Trajet | Résultat |
|---|---|
| Arrivée sud → centre | 34 cases |
| Centre → voie nord | 22 cases |
| Centre → branche ouest | 27 cases |
| Centre → branche est | 27 cases |
| **Traversée sud → nord** | **55 cases** |

Points de mise en scène, tous libres : arrivée sud (216, 440), halte centrale
(216, 192), départ nord (216, 24), et deux positions latérales (160, 176) /
(272, 176) pour un dialogue de côté.

C'est exactement la carte d'un départ : on arrive par le sud en venant de la
ville, on s'arrête au centre pour la dernière parole, on repart par le nord.
Le joueur *voit* le trajet au lieu qu'on le lui raconte.

### Autres cartes utilisables pour du voyage

| Ground | Grille | État | Usage |
|---|---|---|---|
| `carrefour_sud` | 54×54 | 23,1 % libre, 2 sorties + 2 marqueurs déjà branchés | étape vers le littoral |
| `carrefour_assemblee` | 54×57 | 32,2 %, puits, moulin, panneau | plaque tournante |
| `vallon_perdu` | 51×45 | **100 % libre**, 6 marqueurs, musique `Sympathy.ogg` | halte mélancolique — collisions à tracer |
| `plaines_brulees` | 57×42 | 35,2 %, 3 zones | traversée désolée |
| `plage_crepuscule` | 99×48 | 100 % libre, 14 256 tuiles | contemplation (collisions à tracer) |

### Conséquence pour la scène 10

Le départ ne sera donc pas un fondu au noir avec une ligne de narration. Il se
joue en trois lieux :

1. **`metano_town_nuit`** — la fuite depuis la guilde jusqu'à la sortie sud
   (chemin déjà validé : 121 cases praticables), sous `falling_rain`.
2. **`carrefour_nord`** — la halte. On voit d'où l'on vient et où l'on va.
   C'est là que se joue la dernière parole, pas dans un écran noir.
3. La route qui s'éloigne, et seulement là le carton de fin d'acte.

---

## Ce qui reste à faire

- Tracer les collisions de `vallon_perdu` et `plage_crepuscule` si on les
  utilise comme cartes jouables (elles sont à 100 % franchissable, ce qui est
  fidèle à leur source EoSO mais impraticable pour un déplacement libre).
- `carrefour_nord` n'a **aucun marqueur** : il faudra en poser (arrivée sud,
  départ nord) avant de pouvoir y entrer par `EnterGroundMap`.
- Le ground n'est déclaré dans aucune zone : à ajouter à `master_zone`.

## Réserve

La pluie n'a pas été vue à l'écran. L'animation `Rain` est référencée par le
jeu de base, ce qui est un indice fort qu'elle est fournie par le moteur — mais
seul un lancement le confirmera. Si elle manquait, l'émetteur tournerait sans
rien afficher, sans erreur.
