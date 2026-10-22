# [ARCHIVE — fusionné dans DOCUMENT_MAITRE_donjons_externes.md le 2026-07-27]
# Ne plus mettre à jour ce fichier ; il est conservé comme trace historique.

# Curation — Filtre à 3 questions appliqué à chaque ressource externe

**Date :** 26/07/2026 — **Commit :** suite à intégration complète

---

## Principe
Pour chaque élément : **(1) Où ça va ?** → **(2) Quelle adaptation ?** → **(3) Quelle règle respectée ?**
Si une des 3 réponses est vide ou faible → l'élément reste dehors.

---

## ✅ INTÉGRÉ (après curation)

### MEGA_STONES — Mécanique complète

- **(1)** → District marchand de Metano Town. « L'Échoppe de Saphir » (Alakazam), ruelle derrière le Café Metano.
- **(2)** → PNJ « Saphir » réécrit (FR), dialogue d'intro post-Ch5, monnaie = Éclats d'Âme (boss drops), pas de Poke$.
- **(3)** → Aucun légendaire. Lié à un lieu/PNJ existant. Économie équilibrée. Ton cohérent.

### ZMDO — Tilesets Crystal*

- **(1)** → Crystal Sanctuary (variantes futures du biome de Diancie)
- **(2)** → Aucune. Tilesets cohérents avec le thème.
- **(3)** → Biome déjà nommé. Distinct de First_Core_Location.

### PROJECT EON — 6 tilesets retenus / 68

| Tileset | Lieu |
|---|---|
| DrenchedBluffEnd | future zone côtière |
| CrumblingCanyon | canyon post-Ch10 |
| ForestDark | Forêt Lugubre (variante) |
| Cloudless* | Pic Celeste (variante) |
| GuildMesshallAnims, GuildmasterRoomNight | Metano Guild |

Rejetés : 62 tilesets numériques (rips Explorers of Sky), BanditStealing, Dininghall, HedgeHides, IntroRoad, etc. (pas de lieu assigné/doublons).

### DUNGEON-PACK — Outils Python

- **(1)** → `tools/dungeon_pack/` — pipeline de production
- **(2)** → Aucune (outils, pas contenu jeu)
- **(3)** → N'affecte pas le jeu.

### RESOURCE DUNGEONS (Imbion) — 7 donjons

- **(1)** → Job board (missions secondaires)
- **(2)** → Noms FR attribués (Géode Cendrée, Bosquet aux Baies, Grotte du Coven, Jungle Gourmet, Pâturage Céréalier, Bazar Hanté, Atelier Sensible) via notre système de missions — fichiers originaux NON modifiés (licence CC BY-NC-ND).
- **(3)** → Aucun légendaire. Donjons secondaires = pas de boss narratif.

### FRIEND AREA — 8 tilesets + 5 musiques + 1 pattern Lua

- **(1)** → Tilesets assignés : Volcanic_Pit → Searing Crucible, Peanut/Poison_Swamp → Forgotten Marsh, Rainbow_Peak → Celestial Peak Lugia, Stratos_Lookout → Celestial Peak Fulgur, Ancient_Relic → Aegis Cave, Frigid_Cavern → futur donjon glace, Furnace_Desert → futur donjon désert. Musiques → relais et scènes.
- **(2)** → Pattern `allowed_species` extrait dans `FriendAreaUtils.lua` (utilitaire). Aucune autre adaptation — le système Friend Area complet est incompatible.
- **(3)** → Biomes déjà nommés. Pas de conflit avec les camps existants.

### OBJECT RAW ASSET — 74 VFX PNGs

- **(1)** → Cinématiques de boss (mapping documenté : c_magma→Searing Crucible, sp_fire→Torkoal/Magmar, ef_energy→Diancie, tm_thunder→Fulgur, ff_cloud→Lugia, ps_bubble→Swampert, dsc_light→flashs génériques)
- **(2)** → Aucune (sprites d'effets purs)
- **(3)** → Chaque boss a une animation unique renforcée.

---

## ❌ REJETÉ (avec justification)

| Élément | Source | Raison |
|---|---|---|
| GardenEnd, MysteryEntrance, MysteryExit | ZMDO | Pas de zone assignée |
| 62 tilesets numériques (D01P11A, G01P01A3, etc.) | ProjectEoN | Rips officiels sans usage |
| BanditStealing, DininghallNight, HedgeHides, IntroRoad, IntroStormy, Mt Cleft | ProjectEoN | Pas de lieu, doublons |
| 55 maps Friend Area (plaine, grotte, mer, île, forêt, carte hub) | Friend Area | Doublons de nos biomes / système incompatible |
| rescue_base_camp, rescue_base_camp_inside | Friend Area | Doublon de nos camps |
| CustomMenu.lua | Friend Area | Surcharge dangereuse de COMMON.ShowAssemblyMenu |
| Knightcore | GameBanana #623115 | Repo Codeberg privé (auth requise) |
