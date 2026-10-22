# AUDIT CRITIQUE — New Era : Abyss to Ascension
## 2026-07-26 — État réel vs Exigences

---

## 🔴 BUGS CRITIQUES

### 1. Team Dazzling — Branche DÉFAITE ABSENTE
- **Fichier** : `metano_town_ch_6.lua:363` — `PostMissionCutscene()`
- **Problème** : Seule la victoire (`MissionComplete`) est gérée. Aucun dialogue pour la défaite.
- **Impact** : Si le joueur perd contre Zarude, l'histoire avance sans réaction de Team Dazzling.
- **Fix** : Ajouter `PostDefeatCutscene()` avec moqueries de Team Dazzling.

### 2. Grodoudou — Entité OK mais position éloignée de Kecleon
- **Fichier** : `Data/Ground/metano_town.rsground` (38 Mo, restauré)
- **État** : ✅ `Legend_Merchant` MapChar présent à (656, 1232)
- ✅ `Legend_Stand` GroundObject présent
- ✅ `metano_town_legend.lua` (10730 octets) — logique complète
- ✅ `LegendZones.lua` (13661 octets) — catalogue
- ✅ `init.lua:2735-2742` — dispatchers
- **Problème** : Kecleon Shop_Owner à (1056, 832) — ~17 tiles de distance
- **Fix** : Rapprocher à ~3 tiles de Kecleon OU accepter emplacement actuel

### 3. metano_town.rsground — ÉTAIT MANQUANT, MAINTENANT RESTAURÉ
- Le fichier 38 Mo n'était pas dans le dépôt. Restauré depuis git.
- ✅ 62 GroundObjects, 12 MapChars, tous les commerces OK

---

## 🟡 TAILLE DES CHAPITRES — TRÈS EN DESSOUS DE L'OBJECTIF

| Chapitre | Lignes | Fonctions | Clés RESX | Objectif | % atteint |
|----------|--------|-----------|-----------|----------|-----------|
| Ch1 | 523 | 13 | 44 | 6000+ | 8.7% |
| Ch2 | 1431 | 48 | 152 | 6000+ | 23.8% |
| Ch3 | 1380 | 39 | 150 | 6000+ | 23.0% |
| Ch4 | 945 | 37 | 116 | 6000+ | 15.7% |
| **Ch5** | **352** | **27** | **40** | **6000+** | **5.9%** |
| Ch6 | 815 | 51 | 102 | 6000+ | 13.6% |
| Ch7 | 1102 | 54 | 183 | 6000+ | 18.4% |
| Ch8 | 1017 | 54 | 216 | 6000+ | 16.9% |
| Ch9 | 975 | 54 | 194 | 6000+ | 16.2% |
| Ch10 | 587 | 54 | 132 | 6000+ | 9.8% |
| **TOTAL** | **9127** | **431** | **1329** | **60000+** | **15.2%** |

**Constats** :
- Ch5 est le plus petit (352 lignes) — chapitre d'expédition pourtant central
- Aucun chapitre n'atteint 1500 lignes
- Le volume 6000-10000 par chapitre nécessite un facteur ×6 à ×17
- Le RESX actuel a 1329 clés totales — viser 6000/clés par chapitre est irréaliste sans production massive

---

## 🟢 CE QUI FONCTIONNE

- ✅ `BossFX.lua` — 14 fonctions d'effets visuels
- ✅ `dungeon_life.lua` — 4 types de rencontres
- ✅ `npc_routines.lua` — 16 PNJ mobiles
- ✅ Zones Ch8-10 : JSON + init.lua + entrance maps
- ✅ 10 metano_town_ch_N.lua complets
- ✅ 219 tilesets, 61 ground maps, 40 musiques
- ✅ Boss Zarude cinématique Ch6 (170 lignes, belle scène)
- ✅ Tous les scripts valident AST Lua correct

---

## 🎯 PLAN D'ACTION (ordre de priorité)

### Priorité 1 — BUGS (maintenant)
1. Ajouter branche défaite Team Dazzling à Ch6
2. Intégrer Team Skull.ogg comme thème Team Dazzling
3. Rapprocher Grodoudou de Kecleon

### Priorité 2 — CHAPITRE 5 (le plus petit, 352→6000+)
- Scènes de campement (4 donjons × camp)
- Cinématiques mid-donjon (4 checkpoints Kangourex)
- Dialogues village enrichis (30+ PNJ)
- Scènes du soir (feu de camp, discussions)

### Priorité 3 — CHAPITRES 6-10 (scale up)
- Ajouter grosses cinématiques à chaque chapitre
- Cutscenes d'entrée de donjon
- Title cards animées
- Scènes post-boss développées

### Chiffre réaliste par session
6000 dialogues = ~2000 lignes Lua + 400 clés RESX. Par session productive, environ 1500-2000 lignes sont atteignables sans sacrifier la qualité.
