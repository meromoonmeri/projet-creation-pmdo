# Audit des grounds de boss et d'entrée de donjon (hors ch1-4)

Date : 2026-08-02. Périmètre : **52 grounds** dont le nom contient
`boss`, `arene`, `entrance`, `porte`, `entree`, `summit`, `cime`,
`sommet`, `autel`, `trone`, `guardian`, `miniboss`, plus les grounds
Zeraora repérés par recherche de script.

Méthode : téléchargement des 52 `.rsground` réels, lecture de la grille
`obstacles`, des tilesets, des marqueurs et des spawners ; croisement
avec `master_zone.GroundMaps`, avec `Content/Tile/` et avec les 695
scripts Lua du dépôt.

---

## 1. Les deux écrans noirs constatés en jeu — cause trouvée

### Forêt Lugubre : `clouds_overhead` n'existait pas

`gloomy_forest_entrance_ch_6.lua:54` appelait

```lua
GROUND:AddMapStatus("clouds_overhead")
```

Or `Data/MapStatus/` ne contenait **que 17 entrées**, et
`clouds_overhead` n'en faisait pas partie.

Chaîne exacte dans le moteur :

| Fichier | Ligne | Effet |
|---|---|---|
| `Lua/ScriptGround.cs` | 1024 | `new MapStatus(id)` puis `status.LoadFromData()` |
| `Dungeon/Maps/MapStatus.cs` | 44 | `entry = DataManager.Instance.GetMapStatus(ID)` |
| `Data/DataManager.cs` | 1313 | `catch` : **l'exception est avalée**, `data` reste `null` |
| `Dungeon/Maps/MapStatus.cs` | 46 | `foreach (… in entry.StatusStates)` → **NullReferenceException** |

L'appel se trouve **ligne 54**, le `GAME:FadeIn(60)` **ligne 56**.
L'exception tue `ArrivalCutscene` deux lignes avant le rallumage de
l'écran. Et `PlotScripting` appelait `ArrivalCutscene()` **à nu**, sans
`pcall` : rien ne rattrapait. D'où l'écran noir définitif.

Le même appel existait dans **4 fichiers** :
`metano_town/init.lua:35`, `altere_pond/init.lua:36`,
`metano_altere_transition/init.lua:32`,
`gloomy_forest_entrance_ch_6.lua:54`.

**Correctif :**
1. Création de `Data/MapStatus/clouds_overhead.json` (gabarit `gloom`,
   `OverlayEmitter`, alpha 70, couleur `255,255,255,40`, dérive `X:-6`) —
   ombres de nuages discrètes, qui n'assombrissent pas la carte.
2. Ajout dans `Data/MapStatus/index.idx` (17 → 18 entrées), **ordre
   d'origine préservé**, l'ajout est fait en fin de dictionnaire.
3. Les 4 appels passent sous `pcall` : un ID absent ne doit plus jamais
   pouvoir noircir l'écran.
4. `gloomy_forest_entrance.PlotScripting` : `ArrivalCutscene` sous
   `pcall`, avec chemin de secours qui pose le drapeau, rétablit le
   décor, coupe le mode cinématique et rallume l'écran.

Round-trip JSON prouvé avant écriture : `MapStatus/*.json` = BOM +
indent 2 + `\n` final ; `index.idx` = pas de BOM + indent 2 + `\n`.

### Arène Zeraora : `pre_tonnerre` absent de `master_zone`

Le ground `pre_tonnerre` (456×336, collision 62 %, `PreTonnerre_Base`,
marqueurs `Main_Entrance_Marker` **et** `Boss_Marker`) est complet.

Mais `zone/piste_fulgurante/init.lua:38` fait
`GAME:EnterGroundMap('pre_tonnerre', …)` alors que le nom **n'était pas
déclaré dans `master_zone.GroundMaps`**.

`RogueEssence/Dungeon/Zone.cs:167` :

```csharp
int index = GroundMaps.FindIndex((str) => (str == mapname));
if (index > -1) CurrentGround = GetGround(new SegLoc(-1, index));
else throw new Exception($"Cannot find ground map of name {mapname} in …");
```

Exception levée, pas d'échec silencieux.

---

## 2. Le défaut est systémique : 88 grounds concernés

Recherche de **tous** les `EnterGroundMap` du mod croisée avec
`master_zone.GroundMaps` : **91 appels vers 88 grounds non déclarés**.
Les 88 possèdent bien leur `.rsground` — seule la déclaration manquait.

Parmi eux : `arene_trone_magma` (Groudon), `fosse_ardente`,
`colline_anciens` (Xatu, arc ch7), `arene_hautes_plaines` (Raikou),
`palier_celeste`, `gue_poulain_autel`, `sommet_aurore`,
`caverne_trouble_autel`, `fosse_argentee`, `abime_tempetes` (Lugia),
plus 30 relais `new_era_sky_*_relais` et `new_era_zone_*_relais`.

**Correctif :** les 88 noms ajoutés à `master_zone.GroundMaps`,
**95 → 183 entrées**. Vérifié :
- les 95 index d'origine sont **inchangés** (aucune régression sur le
  code qui adresse par index) ;
- aucun doublon ;
- tout le reste du fichier est identique (comparaison structurelle) ;
- round-trip : pas de BOM, indent 2, pas de `\n` final.

---

## 3. Autres défauts relevés sur les 52

### Grille de collision entièrement vide (on traverse le décor) — 9

```
antre_cascade_porte      antre_sables_porte     apricorn_grove_entrance
desert_boreal_porte      gue_poulain_autel      piste_fulgurante_cime
porte_cratere_obscur     porte_plaines_foudre   sanctuaire_titans_entree
```

`apricorn_grove_entrance` est le seul déjà déclaré dans `master_zone` :
il est donc **atteignable et traversable** aujourd'hui.

### Aucun marqueur d'entrée — 14

```
antre_cascade_porte   antre_sables_porte    arene_cauchemar
arene_emissaire_ombre creux_ombres_porte    croisee_cristal_porte
desert_boreal_porte   forge_vapeur_porte    gouffre_beant_porte
gue_poulain_porte     piste_fulgurante_cime porte_cratere_obscur
sanctuaire_titans_entree tour_reliques_porte
```

Sans marqueur, `EnterGroundMap(g, 'Main_Entrance_Marker')` ne peut pas
placer le joueur. Déclarer ces grounds dans `master_zone` ne suffira
pas : il faut leur poser un marqueur.

### Cumul de deux défauts ou plus — 16 grounds

`antre_cascade_porte`, `antre_sables_porte`, `desert_boreal_porte`,
`piste_fulgurante_cime`, `porte_cratere_obscur`,
`sanctuaire_titans_entree` cumulent les **trois**.

### Ce qui va bien

- **Aucun tileset manquant** sur les 52 : les 527 `.tile` de
  `Content/Tile/` couvrent toutes les références. L'écran noir ne venait
  pas de là.
- Les grilles de tuiles sont cohérentes avec les `.tile` (vérifié :
  `gloomy_forest_entrance` 75×39 = 2925 tuiles, le `.tile` en déclare
  exactement 2925).
- `CutsceneMode` déséquilibré sur 3 grounds seulement
  (`cloven_ruins_entrance` 6/5, `mount_windswept_entrance` 11/9,
  `mount_windswept_guardian` 4/3) — à vérifier, mais les chemins de
  secours existent.

---

## 4. Rayquaza : Sky Tower, pas Celestial Peak — tu as raison

Aujourd'hui Rayquaza est instancié dans :
- `ground/autel_celeste/init.lua:105` et `:155` (segment 5 de
  `celestial_peak`) ;
- `ground/vigie_stratos/init.lua:28`.

Canoniquement (Rescue Team), Rayquaza est au sommet de **Sky Tower**,
un donjon distinct. `celestial_peak` est bâti sur les tilesets
`Mount_Windswept_*` et `Sky Peak Cave.ogg` — c'est un Pic Céleste, pas
la Tour.

État des ressources Sky Tower dans le dépôt :
- musique **`Content/Music/Sky Tower.ogg` : présente** ;
- tilesets Sky Tower : **aucun**.

D'où les PNG fournis. Il faut donc créer les tilesets et les grounds à
partir de `Sky_Tower_entrance` (408×288), `Sky_Tower_summit` (551×576)
et `Sky_Tower_cutscene` (288×216, fond de cinématique).

Note : `parvis_celeste` (408×288, `ParvisCeleste_Base`) a **exactement**
les dimensions de `Sky_Tower_entrance_RTRB.png` et une collision déjà
conforme à cette image — c'est déjà l'entrée de la Tour, mal nommée.

---

## 5. Reste à faire

1. Poser un marqueur d'entrée sur les 14 grounds qui n'en ont pas.
2. Générer les collisions des 9 grilles vides
   (`tools/collisions_depuis_png.py` quand le PNG source existe).
3. Créer les grounds Sky Tower et Mt Blaze depuis les PNG fournis, et
   arbitrer le déplacement de Rayquaza vers la Tour.
4. Uniformiser « Aegis Cave » (30 occurrences de « Aegis Cave »
   subsistent).

---

**Rien n'est testé manette en main.** Les chaînes de causalité sont
tracées jusqu'au code C# du moteur, les round-trips JSON sont prouvés,
la syntaxe Lua est validée par `luaparser` — mais la confirmation en jeu
reste à faire.
