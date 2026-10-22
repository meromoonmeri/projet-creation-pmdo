# Zones de recrutement des Pokémon fabuleux et légendaires

> Stand de **Grodoudou**, Metano Town. Implémenté le 25/07/2026.
> Validation : 202/202 Lua compilent · 553/553 resx valides · 355/355 JSON valides ·
> 6/6 scénarios d'exécution simulée passent.

---

## 1. Le conflit avec la règle des légendaires — tranché

La règle existante du projet est : *les légendaires sont réservés aux moments
d'enjeu narratif fort, jamais en rencontre aléatoire.*

**Lecture 1 retenue, et implémentée telle quelle.** Le système ne l'assouplit
pas : il l'utilise. Acheter une zone n'ajoute **aucune** apparition aléatoire.

Trois verrous en série :

| # | Verrou | Ce qui le lève | Où c'est codé |
|---|---|---|---|
| 1 | **Histoire** | le légendaire a été rencontré dans le scénario | champ `flag` de `LegendZones.LIST` |
| 2 | **Marchand** | la zone a été achetée chez Grodoudou | `SV.LegendZones.Purchased[key]` |
| 3 | **Combat** | il faut aller le vaincre sur place | `Unrecruitable = false` sur la `.rsmap` |

Tant que le verrou 1 n'est pas levé, **la zone n'est même pas affichée en
boutique** — Grodoudou n'a « pas encore entendu parler » du lieu. C'est la règle
demandée : *chaque fois qu'on rencontre un légendaire dans l'histoire, sa zone
devient achetable.*

Grodoudou le dit elle-même au joueur, mot pour mot (`LZ_Shop_Disclaimer`) :

> « Je vous vends le **chemin**, pas Zarude. »

Vérifié par exécution réelle du Lua (scénario C) : après un achat réussi,
`IsPurchased` passe à `true` mais `IsDefeated` **reste faux**. L'achat ne donne
jamais le Pokémon.

---

## 2. L'existant réutilisé (aucune mécanique nouvelle)

| Besoin | Système réutilisé | Preuve |
|---|---|---|
| Boucle de boutique | `metano_town.Shop_Action` (Kecleon) | `init.lua:717`, structure `while state > -1` |
| Monnaie | **Poké standard** | `GAME:GetPlayerMoney` / `RemoveFromPlayerMoney`, `init.lua:855` |
| Son d'achat | `SOUND:PlayBattleSE("DUN_Money")` | `init.lua:861` |
| Flash blanc | `BossFX.Flash` → `FlashEmitter` + `BGAnimData("White", 0)` | `BossFX.lua:52`, motif de `COMMON.BossTransition` (`common.lua:523-531`) |
| Départ en donjon | `GAME:EnterDungeon` | `init.lua:457` (menu de destination) |
| Sprite Grodoudou | jeu de base, chargé à l'exécution | Murkrow/Kangaskhan/Ambipom/Slowpoke sont des PNJ actifs **absents** de `Content/Chara/` |

> **`UI:ShopMenu` n'a pas été utilisé** : il attend des `InvItem` (objets
> d'inventaire). On vend des lieux, pas des objets → `UI:BeginChoiceMenu`,
> comme le fait déjà le menu de destination de la ville.

**Aucun asset créé.** Wigglytuff (n° 40) existe dans DumpAsset et dans le jeu de
base ; les 25 espèces du catalogue sont présentes dans
`Data/Misc/MonsterFeature.json` (1011 entrées) — vérifié une à une.

---

## 3. Emplacement du stand

Clairière centrale du **quartier des marchands**, entre les deux étals existants.

| Élément | Position (px) | Taille |
|---|---|---|
| `Legend_Merchant` (Grodoudou) | 656, 1232 | 16×16 |
| `Legend_Stand` (comptoir, déclencheur) | 648, 1248 | 32×16 |
| `Legend_Stand_Marker` | 656, 1272 | 16×16 |

Vérifié par script : cases **marchables** (`Tags = 0`), **aucun chevauchement**
avec les 11 MapChars, 61 GroundObjects et 37 Markers préexistants. Repères
voisins : Nénupiot (592, 1296) et Lombre (720, 1296), le café Spinda est à
l'autre bout de la carte (1144, 592). Rien n'est recouvert.

Cliquer sur Grodoudou **ou** sur le comptoir ouvre la même scène.

---

## 4. Catalogue — 25 zones

Chaque zone a une identité propre à New Era : un nom original, une accroche
(`blurb`) et une image concrète du lieu (`sight`). Aucun nom repris d'un autre jeu.

### Jouable aujourd'hui

| Zone | Pokémon | Prix | Déblocage |
|---|---|---|---|
| **Serment Verdoyant** | Zarude | 15 000 | victoire ch. 6 (`SV.Chapter6.DefeatedGloomyBoss`) |

### Contrats en attente (`ready = false` — jamais affichés en boutique)

| Zone | Pokémon | Prix | Zone pressentie |
|---|---|---|---|
| Carrière du Colosse | Regigigas | 22 000 | `cloven_ruins` (ch. 7) |
| Colline Spatiale | Palkia | 38 000 | — |
| L'Heure Qui Traîne | Dialga | 38 000 | — |
| Pente Inversée | Giratina | 42 000 | — |
| Les Heures Mortes | Celebi | 25 000 | `relic_forest` |
| Gué d'Eau Claire | Suicune | 26 000 | `illuminant_riverbed` |
| Veillée de Braise | Entei | 26 000 | `searing_tunnel` |
| Cloche d'Orage | Raikou | 26 000 | `mount_windswept` |
| Sommeil Léger | Cresselia | 28 000 | — |
| Rêve Retourné | Darkrai | 30 000 | — |
| Vœux Tus | Jirachi | 32 000 | — |
| Premier Berceau | Mew | 50 000 | — |
| Marche Dégelée | Artikodin | 24 000 | — |
| Haut Conducteur | Électhor | 24 000 | — |
| Longue Cendre | Sulfura | 24 000 | — |
| Registre Muet | Créhelf | 27 000 | — |
| Sentiment Gardé | Créfollet | 27 000 | — |
| Dernière Résolution | Créfadet | 27 000 | — |
| Chœur Englouti | Lugia | 36 000 | — |
| Cendre Arc-en-ciel | Ho-Oh | 36 000 | — |
| Querelle de Pierre | Terrakium | 25 000 | — |
| Neuvième Cime | Rayquaza | 45 000 | — |
| Lumière Empruntée | Necrozma | 48 000 | — |
| Vie Donnée | Xerneas | 44 000 | — |

**Colline Spatiale** (exemple de l'utilisateur) : *« Des runes gravées à même le
sol tournent lentement autour d'un centre trop lumineux. La distance y ment. »*
Palkia y est marqué `roam = true` (se déplace une fois recruté).

Le champ `roam` est renseigné pour chaque entrée mais **n'est pas encore lu par
le code** : c'est une donnée de conception pour l'implémentation des arènes à
venir. Point à traiter honnêtement plutôt que de le présenter comme fonctionnel.

---

## 5. Comment ajouter une zone

1. Passer `ready = true` et écrire le `flag` (le drapeau `SV` posé par le chapitre).
2. Créer la `.rsmap` de l'arène avec l'occupant **`Unrecruitable = false`**.
3. Ajouter le segment dans `Data/Zone/<zone>.json` et mettre à jour `Data/Zone/index.idx`
   (`Maps` + `CountedFloors`).
4. Gérer le `segmentID` dans `ExitSegment` de `zone/<zone>/init.lua`, avec
   `LegendZones.SetDefeated('<key>')` à la victoire.
5. Relancer `verify_legend.py` et `sim_legend.py`.

Les trois points (a) segment, (b) carte recrutable, (c) `ExitSegment` sont
vérifiés automatiquement pour toute entrée `ready = true`.

---

## 6. Checklist de test manette en main

| # | À tester | Attendu |
|---|---|---|
| 1 | Aller au quartier des marchands | Grodoudou visible entre les deux étals, rien ne se superpose |
| 2 | Lui parler la 1ʳᵉ fois | Présentation en 5 répliques, une seule fois |
| 3 | Parler au comptoir | Même scène que via Grodoudou |
| 4 | « Acheter » **avant** d'avoir battu Zarude | Étal vide, aucune zone listée |
| 5 | Battre Zarude (ch. 6) puis revenir | Serment Verdoyant apparaît à 15 000 |
| 6 | Acheter sans assez d'argent | Refus, **aucun flash**, rien débloqué |
| 7 | Acheter avec l'argent | Émote *glowing* → **flash blanc** → retour boutique + confirmation |
| 8 | Vérifier le porte-monnaie | −15 000 Poké exactement |
| 9 | « S'y rendre » | Arrivée dans l'arène, Zarude niveau 45 |
| 10 | Le battre | **Recrutement possible** (contrairement au combat d'histoire) |
| 11 | Revenir au stand | Zone marquée « (visité) », toujours accessible |
| 12 | Charger une **ancienne sauvegarde** | Le stand fonctionne, aucun crash |

Points 1 à 12 validés statiquement et en simulation ; **seul le test en jeu réel
reste à faire** — aucun .NET ni RogueEssence dans l'environnement.

---

## 7. Fichiers

**Créés**
- `Data/Script/halcyon/LegendZones.lua` — catalogue + état de sauvegarde
- `Data/Script/halcyon/ground/metano_town/metano_town_legend.lua` — boutique et cinématique
- `Data/Map/verdant_oath_arena.rsmap` — arène de revanche (Zarude recrutable, niv. 45)

**Modifiés**
- `Data/Ground/metano_town.rsground` — +1 MapChar, +1 GroundObject, +1 Marker
- `Data/Script/halcyon/ground/metano_town/init.lua` — require + 2 callbacks
- `Data/Script/halcyon/scriptvars.lua` — `SV.LegendZones`
- `Data/Script/halcyon/zone/gloomy_forest/init.lua` — segment 3
- `Data/Zone/gloomy_forest.json` — segment 3 (0-2 inchangés, vérifié)
- `Data/Zone/index.idx` — `Maps` + `CountedFloors` 21 → 22
- `strings.resx` / `strings.fr.resx` — **106 clés, parité EN/FR stricte**

**Outils** (hors dépôt) : `verify_legend.py` (44 contrôles), `sim_legend.py`
(6 scénarios exécutés dans Lua réel).
