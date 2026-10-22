# Correspondance PNG sources → grounds New Era

Date : 2026-08-02. Méthode : appariement par **dimensions au pixel près**
entre les PNG fournis et la grille `obstacles` des `.rsground` du dépôt,
puis contrôle visuel de la silhouette de collision contre l'image.

Suffixes des fichiers : `RTRB` = Rescue Team Red/Blue (pmd-red),
`TDS` = Time / Darkness / Sky (pmd-sky).

---

## 1. Décision de nommage

**« Aegis Cave »** est retenu (décision auteur, 2026-08-02).

`Data/Zone/cloven_ruins.json` porte déjà `LocalTexts.fr = "Aegis Cave"`.
En revanche **30 occurrences de « Aegis Cave »** subsistent dans les
`.lua` et les `.resx` contre 28 de « Aegis Cave » : le joueur voit
aujourd'hui les deux noms pour le même donjon. À uniformiser (non fait
dans ce lot — c'est un passage sur 10 fichiers, à traiter séparément pour
ne pas noyer le correctif de collision).

Fichiers concernés par « Aegis Cave » :
`CharacterEssentials.lua`, `cloven_ruins_boss_ch_7.lua`,
`cloven_ruins_entrance_ch_5.lua`, `cloven_ruins_entrance/init.lua`,
`cloven_ruins_entrance/strings.fr.resx`, `hero_dream/init.lua`,
`metano_town_ch_7.lua`, `mount_windswept_entrance/strings.fr.resx`,
`mount_windswept_guardian/strings.fr.resx`,
`mount_windswept_guardian_ch_5.lua`.

---

## 2. Appariement des 10 PNG

| PNG fourni | Dim. | Ground | État constaté |
|---|---|---|---|
| `Magma_Cavern_entrance_RTRB.png` | 408×336 | **`gorge_ardente_porte`** | déjà peint + collision 49 % **conforme** |
| `Sky_Tower_entrance_RTRB.png` | 408×288 | **`parvis_celeste`** | déjà peint + collision 69 % **conforme** |
| `Crystal_Crossing_entrance_TDS.png` | 600×480 | **`croisee_cristal_porte`** | peint, **grille VIDE** → corrigée |
| `Crystal_Lake_peninsula_TDS.png` | 696×600 | **`galerie_cristal_4`** | peint, **grille VIDE** → corrigée |
| `Crystal_Lake_shore_TDS.png` | 408×456 | *aucun* | ground à créer |
| `Sky_Tower_summit_RTRB.png` | 551×576 | *aucun* | ground à créer (551 px = **largeur impaire**, à recadrer en 552 pour tomber juste sur la maille de 8 px) |
| `Sky_Tower_cutscene_RTRB.png` | 288×216 | *aucun* | fond de cinématique, pas un ground jouable |
| `Mt_Blaze_entrance_RTRB.png` | 360×312 | *aucun* | ground à créer |
| `240px-Mt_Blaze_summit_RTRB.png` | 240×240 | *aucun* | ground à créer |
| `240px-Mt_Blaze_cutscene_RTRB.png` | 240×349 | *aucun* | fond de cinématique |

**`enigme_cristal`** fait aussi 600×480 et est peint avec
`Crystal Cave Puzzle Unsolved Layer 1/2` : c'est la **salle d'énigme**
de Crystal Cave, un décor distinct de l'entrée. Sa grille est déjà
remplie (73 %). Il ne correspond pas au PNG fourni malgré la dimension
identique — vérifié sur les noms de tilesets, pas sur la seule taille.

---

## 3. Correctif appliqué — deux grilles de collision reconstruites

Outil créé : `tools/collisions_depuis_png.py`.

Il diffère de `gen_collisions.py` (qui rend le ground depuis ses propres
tuiles) en partant du **PNG source d'origine**, strictement plus fidèle
quand on en dispose.

| Ground | Avant | Après |
|---|---|---|
| `croisee_cristal_porte` | **0 mur** — feuille intégrale | 2059 murs, 54 % praticable, couverture 97 % |
| `galerie_cristal_4` | **0 mur** — feuille intégrale | 4219 murs, 35 % praticable, couverture 94 % |

Round-trip JSON prouvé : taille de fichier **identique au bit près**
(812 018 et 1 335 731 octets), et comparaison structurelle confirmant que
**seuls les champs `Tags` ont changé**.

### Erreur commise pendant la mise au point, et corrigée

Première version de `mode_du_sol()` : mode de luminance de la moitié
basse de l'image. Elle captait le **fond hors-carte**. Sur
`Crystal_Crossing` le PNG est bordé de noir (lum ≈ 35) sur toute sa
périphérie ; ce noir devenait la référence de « sol », et le vrai sol
(lum ≈ 59) passait pour du relief. Le garde-fou C a **refusé l'écriture**
(41 % de couverture) — il a fonctionné comme prévu.

Version retenue : médiane de la **bande centrale basse**, là où tout
décor d'entrée de donjon PMD place le point d'arrivée du joueur.

`galerie_cristal_4` a demandé des seuils élargis (`tol=55`,
`relief=70`) : la presqu'île de cristal a un motif interne à forte
variance qui, aux seuils par défaut, passait pour du relief. Ici c'est
l'**eau sombre qui est le mur** et la terre claire le sol — l'inverse du
cas précédent.

---

## 4. BLOQUANT MAJEUR découvert — 13 grounds inatteignables

Aucun des grounds de l'arc Groudon, du Pic Céleste ou du Sanctuaire de
Cristal n'est déclaré dans `master_zone.GroundMaps` :

```
croisee_cristal_porte      galerie_cristal_4       parvis_celeste
palier_celeste             sanctuaire_cristal_porche  enigme_cristal
lac_cascade                gorge_ardente_porte     fosse_ardente
gorge_ardente_coeur        arene_trone_magma       statue_colosse_magma
fosse_volcanique
```

Conséquence prouvée dans le moteur — `RogueEssence/Dungeon/Zone.cs:167` :

```csharp
int index = GroundMaps.FindIndex((str) => (str == mapname));
if (index > -1) CurrentGround = GetGround(new SegLoc(-1, index));
else throw new Exception($"Cannot find ground map of name {mapname} in {Name.DefaultText}.");
```

Ce n'est pas un échec silencieux : c'est une **exception levée**.

Or `zone/new_era_zone_15/init.lua:44` fait :

```lua
GAME:EnterGroundMap('fosse_ardente', 'Main_Entrance_Marker')
```

→ **crash dur** dès que le joueur termine le premier segment de la
Caverne Magma. Le contenu existe, il est peint, il a ses marqueurs et ses
spawners — il est simplement injoignable.

`master_zone.GroundMaps` compte 95 entrées pour 277 `.rsground` au dépôt.

---

## 5. Ce qui reste à faire

1. **Déclarer les 13 grounds dans `master_zone.GroundMaps`** — préalable
   à tout test de l'arc Groudon. Priorité absolue.
2. Créer les 3 grounds manquants : rive du Lac Cristal (408×456), sommet
   de la Tour Céleste (551×576 → recadrer en 552), entrée et sommet du
   Mont Brasier (360×312 et 240×240).
3. Les 2 PNG de cinématique (`Sky_Tower_cutscene`, `Mt_Blaze_cutscene`)
   ne sont pas des grounds : ce sont des fonds fixes, à traiter comme
   décor de scène.
4. Uniformiser « Aegis Cave » sur les 10 fichiers listés en §1.

---

**Rien de ceci n'est testé manette en main.** Les deux grilles écrites
sont validées par contrôle visuel ASCII contre l'image source et par les
quatre garde-fous de l'outil, pas par une session de jeu.
