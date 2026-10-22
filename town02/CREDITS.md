# Crédits — New Era: Abyss to Ascension

## Projet de base
- **Halcyon** par [Palikadude](https://github.com/Palikadude/Halcyon) — base du mod
- **PMDO** par [audinowho](https://github.com/audinowho) — moteur RogueEssence / PMDC
- **RogueCollab** — [RogueEssence](https://github.com/RogueCollab/RogueEssence), [RogueElements](https://github.com/rogueessence/RogueElements), [PMDC](https://github.com/PMDCollab/PMDC)
- **PMDODump** / **DumpAsset** — contenu dumpé du jeu officiel

## Packs intégrés

### Mega_Stones
- **Auteur** : [Deeshura](https://github.com/Deeshura/Mega_Stones)
- **Description** : Système de Méga-Évolution pour PMDO
- **Contenu repris** : scripts Lua (`Data/Script/megastones/`), tileset `shady_shop.tile`, ground map, zone, musique `Shady Shop.ogg`
- **Crédits additionnels** : icônes d'objets par Ryveriel ; contributions de Trio-, FlowerSnek, Palika, Sh*tpost Sunkern, MistressNebula

### ZMDO (Zorua Mystery Dungeon Origins)
- **Auteur** : [RaoKurai](https://github.com/RaoKurai/ZMDO)
- **Description** : Démo de mod PMDO (thème Zorua)
- **Contenu repris** : tilesets `CrystalEntrance`, `CrystalExit`, `GardenEnd`, `MysteryEntrance`, `MysteryExit` (préfixés `ZMDO_`)

### Trio's Dungeon Pack
- **Auteur** : [DoubleTrio](https://github.com/DoubleTrio/dungeon-pack)
- **Description** : Pack de donjons + outillage Python
- **Contenu repris** : scripts Python d'outillage (`tools/dungeon_pack/`)
- **Note** : certains graphismes proviennent de craftpix.net (vérifier licence avant réutilisation directe)

### Project EoN
- **Auteur** : [Logical321](https://github.com/Logical321/ProjectEoN)
- **Description** : Fangame PMDO (non terminé)
- **Contenu repris** : tilesets sélectionnés pour biomes variés (DrenchedBluff, CrumblingCanyon, Mt Cleft, ForestDark, Cloudless, IntroRoad, IntroStormy, HedgeHides, BanditStealing, Dininghall, Guild) — préfixés `EoN_`
- **Note** : projet inachevé — contenu original vs rip officiel à documenter plus finement

### Resource Dungeon Pack (Imbion)
- **Auteur** : Imbion
- **Source** : [Codeberg](https://codeberg.org/Imbion/pmdoResourceDungeons) / [GameBanana #618475](https://gamebanana.com/mods/618475)
- **Licence** : CC BY-NC-ND 4.0 (pas de modification autorisée)
- **Contenu repris** : 7 zones (ashen_geode, berry_grove, coven_cave, gourmet_jungle, grainy_pasture, haunted_bazar, sentient_workshop), tileset Ashen Geode, 4 musiques, scripts
- **Fichiers** : préfixés `imbion_` dans Data/Zone/, `Imbion_` dans Content/Tile/

### Knightcore (Imbion)
- **Auteur** : Imbion
- **Source** : [GameBanana #623115](https://gamebanana.com/mods/623115)
- **Statut** : ❌ repo Codeberg inaccessible (authentification requise) — non intégré

### Friend Area Pack (Google Drive)
- **Source** : https://drive.google.com/drive/folders/1_MeXe1XD_wTxxBCYx1GluDYeV9uvLV7U
- **Statut** : ❌ inaccessible depuis le sandbox — à télécharger manuellement et intégrer

## Musiques
- `Team_Dazzling.ogg` — thème original de l'équipe Team Dazzling (Sucreine/Lockpin/Magiréve)

## Agents de développement
- Agent Arena.ai — développement scripts, maps, dialogues, correctifs (V4.5.1+)

## Direction musicale (2026-08-01)

Aucune piste externe n'a été ajoutée. `Data/Script/halcyon/BossMusic.lua`
**redistribue** les musiques déjà embarquées et déjà créditées ci-dessus :
48 arènes de gardiens sur 49 jouaient le même `Boss Battle!.ogg`, et
14 pistes n'étaient jamais jouées. La table attribue désormais 12 thèmes
distincts selon sept registres (cosmique, ciel, ombre, nature, tellurique,
machine, épreuve).

**Note de licence** — les remixes de chaînes YouTube (type GlitchxCity) ont
été écartés volontairement : un remixeur ne détient pas les droits de
l'œuvre d'origine et ne peut donc pas en autoriser la redistribution dans
un mod. Toute piste future doit venir d'un auteur autorisant explicitement
l'usage en fangame, et être créditée ici avec sa licence.
