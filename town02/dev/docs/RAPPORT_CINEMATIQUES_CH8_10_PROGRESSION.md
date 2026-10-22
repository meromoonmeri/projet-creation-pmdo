# PROGRESSION — CINÉMATIQUES CHAPITRES 8-10 (vers +7k dialogues)

**Branche : `arena/019fd882-new-era-abyss-to-ascension-v4` — 2 commits poussés le 2026-08-09.**

---

## 1. ÉTAT MESURÉ AVANT (audit 2026-08-09)

| Chapitre | Dialogues | État |
|---|---|---|
| ch6 | ~2800 | riche |
| ch7 | ~2900 | riche |
| ch8 | ~220 | squelettique — **aucune cinématique de donjon** |
| ch9 | ~210 | squelettique — **pas de cinématique de boss** |
| ch10 | ~170 | squelettique — **pas de scène de relais** |

**Cause racine** : les arènes relais/miniboss/boss des ch8-10 n'avaient **aucun `OnMapStarts`**
→ on entrait dans les arènes sans mise en scène.

---

## 2. LOT A — `0bfb033` : 5 cinématiques d'étage créées

Nouveau module `halcyon/Ch6_10Scenes.lua` (patron `SINGLE_CHAR_SCRIPT` + `DonjonFX` + `BossFX`),
branché via `MapEffectStep`/`OnMapStarts` dans 3 zones, **61 clés de dialogue** (FR+EN) dans
`Strings/stringsEx.*.resx` :

| Scène | Hook | Contenu |
|---|---|---|
| `Ch8_RelaisArrivee` | waterfall_pond seg1 | émerveillement, fragment des premiers gardiens |
| `Ch8_MinibossEveil` | seg3 | éveil de Strassie & Momartik, leur serment |
| `Ch8_BossEveil` | seg5 | **Diancie se révèle**, gardienne du Cœur d'Anima |
| `Ch9_BossEveil` | poisonous_forest seg5 | **Mega-Blastoise émerge de la vase** |
| `Ch10_RelaisArrivee` | sky_tower seg1 | rivalité avec l'Escouade Fulgur |

Registres distincts : ch8 contemplation · ch9 malaise · ch10 urgence. Apparitions progressives,
tout sous pcall.

## 3. LOT B — `6d9a696` : veillée ch8 enrichie (4 → ~30 répliques)

`guild_heros_room_ch_8.lua` + 22 clés `GHR8_006-027` (FR+EN) : après Diancie, le duo parle du
Fragment tiède, du Cercle du Suaire, de l'hypothèse du **Cœur drainé de l'intérieur**, de la
crainte que les autres Cœurs s'éteignent, et du **rêve prismatique** (préparation du twist
Eternatus/Necrozma).

---

## 4. CE QUI RESTE (plan de conception : `PLAN_CINEMATIQUES_CH8_10_2026-08-09.md`)

Pour atteindre +7k dialogues/chapitre, il faut encore des **dizaines de scènes par chapitre** :
- **ch8** : briefing à la guilde, scène de retour à Metano, enrichissement PNJ MT8, relais enrichi
- **ch9** : scène du **Cercle du Suaire** (SawCercleDuSuaire), dispute Floatzel, enrichissement MT9,
  veillée ch9
- **ch10** : vision Necrozma (SawNecrozmaVision), enrichissement MT10, veillée ch10, retour triomphal

**Rythme réaliste** : chaque lot livré = 1-5 scènes de qualité (30-80 dialogues). Le +7k/chapitre
est un chantier de très longue haleine, chapitre par chapitre, à poursuivre sur plusieurs sessions.

---

## 5. VÉRIFICATIONS FAITES

- 61/61 clés CH8/9/10 référencées et présentes, aucune vide.
- resx intacts (1986 → 2047 clés, +61 exactement, XML valides).
- 12 scènes précédentes (routes + boss arc fugitif) + 5 nouvelles + veillée : syntaxe Lua validée
  (lupa).
- resx GHR8 : XML valides.

⚠️ **Rappel sécurité** : le token GitHub `ghp_ogyz…` a été utilisé en clair dans la conversation —
**à révoquer** par l'utilisateur.
