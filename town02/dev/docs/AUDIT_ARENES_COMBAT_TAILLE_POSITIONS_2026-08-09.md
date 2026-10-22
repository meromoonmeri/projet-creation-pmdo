# AUDIT ARÈNES DE COMBAT — taille plein écran, positions entités, cinématiques

**Branche : `arena/019fd882-new-era-abyss-to-ascension-v4` (2026-08-08 22:08).**
**Statut : 100 % lecture seule. Aucune modification.**
**Outils : `audit_boss_center.py`, `audit_arenas2.py`, `audit_bossform.py` + audits existants de la branche.**

---

## 0. CONTEXTE — pourquoi le noir n'apparaît qu'en combat

Le ground de cinématique (ex. `fosse_ardente`, `tour_ciel_sommet`) est un **ground complet**
(69×75, 63×63…) → **il prend tout l'écran** (le moteur scroll). Le **combat** se joue sur un
**étage-arène `.rsmap` rogné** (fenêtre extraite du ground source), plus petit que l'écran
(240×160 px). Pendant le combat, la caméra ne peut pas scroller sur une map < écran → reste au
bord → **bandes noires**.

**Cause racine confirmée** : toutes les arènes de combat sont des **recadrages** des grounds sources
(`audit_battle_same_ground.py` : paires ciné↔combat exigent la même taille, échoue partout) :

| Arène de combat (rsmap) | Taille actuelle | Ground source (RESERVE) | Taille source |
|---|---|---|---|
| `tour_ciel_sommet` | 23×25 = 184×200 px | d13p03 | **69×75 = 552×600 px** |
| `magma_cavern_pit` | 21×21 = 168×168 px | d12p04 | **63×63 = 504×504 px** |
| `mt_blaze_summit` | 23×23 = 184×184 px | d09p03 | **69×69 = 552×552 px** |
| `frosty_forest_summit` | 22×21 = 176×168 px | d10p03 | **66×63 = 528×504 px** |
| `fosse_argentee` (Lugia) | — | d15p01 | 66×63 (source RESERVE) |
| `wish_cave_jirachi` | 15×14 = 120×112 px | d23p01 | 45×42 = 360×336 px |
| `mount_windswept_guardian` | 15×14 = 120×112 px | ground 45×42 | 360×336 px |
| `crystal_sanctuary_boss` | 15×14 = 120×112 px | (New Era) | ~120×112 (rogné) |
| `forgotten_marsh_boss` | 19×14 = 152×112 px | (New Era) | ~152×112 (rogné) |

**Les sources complètes existent toutes dans `RESERVE/`** (d13p03, d12p04, d09p03, d10p03, d23p01,
d15p01…) → régénération possible sans inventer de décor.

---

## 1. PROBLÈME 1 — BOSS AFFICHÉ AVEC LE MAUVAIS SPRITE (20 joueurs / 13 arènes)

Vérifié dans le moteur (`Character.cs:117-122`) : le sprite rendu = `CurrentForm` (pas `BaseForm`).

| Arène | Boss VOULU (Base) | Sprite AFFICHÉ (Current) |
|---|---|---|
| `tour_ciel_sommet` | rayquaza | **tsareena** |
| `frosty_forest_summit` | articuno | **zeraora** |
| `wish_cave_jirachi` | jirachi | **zeraora** |
| `crystal_sanctuary_boss` | diancie | **tsareena** |
| `forgotten_marsh_boss` | swampert | **tsareena** |
| `crystal_sanctuary_miniboss` | carbink + froslass | tsareena ×2 |
| `forgotten_marsh_miniboss` | swalot + toxicroak | tsareena ×2 |
| `cloven_ruins_regice/regirock/registeel` | regice/regirock/registeel | **regigigas** |
| `sanctuaire_titans` | regigigas (+ gardiens) | regigigas + hitmonlee×4 + bronzong×4 |

→ Le joueur combat **Tsareena** au lieu de Rayquaza/Diancie/Laggron, **Zeraora** au lieu
d'Articuno/Jirachi, **Regigigas** au lieu des Regis.

---

## 2. PROBLÈME 2 — BOSS DÉCALÉ / NON CENTRÉ (dont Groudon, Tornadus)

Mesuré par rapport au **centre réel du sol walkable** (pas le centre de la grille) :

| Arène | Boss | Position | Centre sol | Décalage |
|---|---|---|---|---|
| `magma_cavern_pit` | **groudon** | (10,7) | (10,10) | **(0,-3) → 3 tuiles au nord du centre** |
| `tour_ciel_sommet` | rayquaza(tsareena) | (7,9) | centre grille (11,12) | (-4,-3) |
| `frosty_forest_summit` | articuno(zeraora) | (7,5) | (11,10) | (-4,-5) |
| `mt_blaze_summit` | moltres | (11,5) | (11,11) | (0,-6) |
| `mount_windswept_guardian` | tornadus | (7,5) | centre grille (7,7) | (0,-2) — mais PERCHOIR volant (justifié) |
| `wish_cave_jirachi` | jirachi(zeraora) | (7,5) | (7,7) | (0,-2) |
| `gloomy_forest_boss` | zeraora | (7,5) | (10,8) | (-3,-3) |
| `sanctuaire_titans` | regigigas | (13,5) | (13,12) | (0,-7) |
| `vast_steppe_guardian` | absol | (8,4) | (8,11) | (0,-7) |
| `verdant_oath_arena` | zarude | (7,5) | (7,9) | (0,-4) |

**Tornadus** : le doc `ARENE_TORNADUS_PATRON_CROOKED_DEN` le place au **perchoir (216,24) dans la
bande ciel** → le décalage est VOLONTAIRE (boss volant). Mais les autres (Groudon 3 tuiles au nord,
Regigigas 7 tuiles au nord, absol 7 tuiles) sont des **décalages non justifiés** qui cassent la
composition (boss excentré, arrivée trop proche : `magma_cavern_pit` dist_arrivée=3, `verdant_oath`
=3, `chapter_3_boss_fight` =3).

---

## 3. PROBLÈME 3 — SPECTATEURS METANO DANS LES ARÈNES DE BOSS

6 arènes partagent le même `AllyTeam` de 8 PNJ L5 (mawile, quagsire, nidorina, azumarill, floatzel,
marill, venipede, electrike) :
- `metano_town_duel`, `metano_raid_1/2/3` → **légitime** (foule de Metano qui assiste).
- `mount_windswept_guardian` (Tornadus), `sanctuaire_voeu` → **hérité du template, INCOHÉRENT** :
  les 8 spectateurs spawnent à côté du joueur contre le légendaire. À **vider**.

---

## 4. PROBLÈME 4 — CHEVAUCHEMENTS ET HORS-BORNES (audit statique existant, 6 fails / 52)

| Arène | Problème |
|---|---|
| `metano_raid_1/2/3` | **ennemis empilés** : gastly@(5,8) sur shuppet@(5,8), duskull@(5,8) sur banette… (tous au même point = l'arrivée) |
| `forgotten_marsh_miniboss` | 2 mini-boss **hors de la carte** (7×7), EntryPoints hors bornes |
| `marais_errants_fond` | goodra **hors bornes** (7,3), EntryPoint (7,7) hors bornes |
| `crystal_sanctuary_miniboss` | 2 boss superposés (7,9) |
| `mount_windswept_guardian` | 4 alliés L5 sur tuile `unbreakable` |

---

## 5. CINÉMATIQUES VÉRIFIÉES (Tornadus, Groudon)

**Tornadus** (`mount_windswept_guardian_ch_5.lua`) : cinématique sur **ground** (45×42 = 360×336 px,
prend l'écran). Tornadus créé dès le début (caché) pour parler avant d'apparaître, descend des nuages
(`DescendSky`), caméra calée entre l'équipe (y=248) et le perchoir (y=136). **Bien construite**
(parle avant d'apparaître, orage, foudre, flash). Le problème n'est pas la ciné mais le **combat**
(rsmap 15×14 rogné + 8 spectateurs + boss excentré du centre de la grille).

**Groudon** (`magma_cavern/init.lua` + `fosse_ardente/init.lua`) : ciné sur `fosse_ardente` (ground),
VFX réveil (`VFX_Groudon_Awakening_Flame`), puis `EnterDungeon('magma_cavern',2,...)` → combat sur
`magma_cavern_pit` (rsmap 21×21 rogné de d12p04 63×63). **Groudon est à (10,7), 3 tuiles au nord du
centre du sol** (10,10) → excentré, et l'arrivée est à 3 tuiles → pas de respiration.

---

## 6. SYNTHÈSE — CORRECTIONS PROPOSÉES (méthode validée par le projet)

| # | Correction | Méthode | Impact |
|---|---|---|---|
| 1 | **Régénérer les arènes de combat rognées** depuis la source RESERVE complète (d13p03, d12p04, d09p03, d10p03, d23p01…) | `audit_battle_same_ground.py` : combat = même taille que le ground source. **Étendre le `.rsmap` à la carte source complète** (ou, si la source est un ground, recadrer la fenêtre du combat pour couvrir ≥ 240×160 px) | Supprime les bandes noires ; combat sur la même géométrie que la ciné |
| 2 | **Corriger les 13 arènes CurrentForm ≠ BaseForm** (sprite du boss) | Mettre `CurrentForm` = `BaseForm` (ou `ProxySprite` correct) | Le joueur voit le vrai boss |
| 3 | **Vider les AllyTeams des arènes de boss isolées** (`mount_windswept_guardian`, `sanctuaire_voeu`) | Retirer les 8 spectateurs L5 | Plus de foule contre les légendaires |
| 4 | **Recentrer les boss décalés** (Groudon → centre sol (10,10), Regigigas, absol, etc.) | Repositionner `serializationLoc` sur le centre du sol walkable, avec distance d'arrivée ≥ 5 | Composition esthétique |
| 5 | **Corriger chevauchements/hors-bornes** (raids Metano, forgotten_marsh_miniboss, marais_errants) | Séparer les positions (pas d'empilement), remettre dans la carte | Conforme audit statique |

**Aucune modification effectuée. En attente de validation pour lancer les correctifs (par lots).**
