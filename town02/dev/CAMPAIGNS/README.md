# CAMPAIGNS — les deux ROM canoniques rejouées par le contenu PMDO

Deux campagnes complètes, chacune contenant l'entièreté du contenu canonique
d'une ROM, dans le format que le moteur PMDO/RogueEssence consomme
(`.rsground`/`.tile`) plus les rendus PNG pixel-perfect et le manifest
narratif. Objectif : que le moteur puisse « jouer » chaque ROM dans son
système, avec la traçabilité complète vers les sources.

## PMD_RED_RESCUE_TEAM — Pokémon Donjon Mystère : Équipe de Secours Rouge (EU)

- **Grounds** : 428 (source : commit réserve `0ec8129` de ce dépôt —
  campagne de validation exhaustive **219/219 Grounds canoniques PASS dans
  PMDO 0.8.12 réel**, 0 pixel mismatch, promotion non destructive).
- **Renders/** : 422 grounds rendus en PNG pixel-perfect (cellules 8 px
  blittées sans transformation), **frames d'animation incluses** (cycle
  global par ground, LCM des cycles de tuiles, cap 6 frames ; ex. Place
  Pokémon 6 frames, Fosse Ardente 8→6 frames de lave). 6 grounds sans
  planche dans la source sont documentés en erreur, rien n'est inventé.
- **Cinematics/** : 133 séquences `.cif.json` extraites de la ROM (musiques
  `MUS_*`, dialogues, animations, flashes) + 133 squelettes de scène Lua +
  `eu_scene_cast.json` (casting canonique ROM EU : entités, espèces,
  positions pixel exactes, directions — gMapScriptTable + table
  gGroundLivesTypeData 0x27BEEC).
- **Docs/** : CINEMATICS_DATABASE.md (mise en scène C/ASM : BGM, FLASH_*,
  CAMERA_PAN, MOVE_TO_POS par Ground), MAP_DATABASE.md (les 245 cartes),
  CINEMATIC_CHOREOGRAPHY_GUIDE.md.
- **MANIFEST.json / MANIFEST.md** : par ground — nom humain EN/FR, donjon +
  rôle (entrée/relais/fin-arène), boss, rendu (dimensions, frames, tuiles
  animées), cinématique liée (nb dialogues, musiques), casting ROM,
  validation runtime ; + narration globale en 6 arcs (Prologue, Bois
  Sinistres, Mont Foudre/légende, Arc Fugitif, Météorite, Post-game).

## PMD_SKY_EXPLORERS — Pokémon Donjon Mystère : Explorateurs du Ciel (EU)

- **Grounds** : 460 (source : `meromoonmeri/PMD-SKY-PMDO-PORT@master` —
  458 MAP_BG NDS convertis via skytemple-files `bma.to_pil(bpc,bpl,bpas)`,
  collisions BMA source unique, 0 erreur, toutes les frames BPA).
- **Renders/** : 459 grounds rendus en PNG pixel-perfect avec frames
  (eau, lave, cascades, drapeaux animés).
- **Cinematics/** : scènes Lua du port (traductions de scènes NDS).
- **Docs/** : rapports de conversion et de renommage canonique du port,
  audit ROM (1387 fichiers identiques pret/ROM), graphe monde
  (Treasure Town ↔ Croisée ↔ Guilde ↔ Grotte Plage), mapping audio.
- **MANIFEST.json / MANIFEST.md** : par ground — nom humain (rsground Name
  quand posé par le port, sinon identité `enum dungeon_id` de pret/pmd-sky,
  préfixe d## == DUNGEON_ID vérifié 1:1), groupe de zone (Bourg-Trésor,
  Guilde…), rendu ; + narration globale en 6 arcs (Prologue plage, Guilde,
  Grovyle et les Gears, Terres Illusoires/Tour du Temps, post-game,
  Épisodes Spéciaux).
- **Conflit documenté** : `d32` = DUSK_FOREST chez pret, renommé
  `aegis_cave_*` par instruction projet — les deux identités sont exposées
  dans le manifest, aucune n'est effacée.

## Ce qui reste marqué non décodé (aucune invention)

- Red : le texte des dialogues des `.cif.json` (les boîtes sont comptées et
  positionnées dans la séquence ; le texte 5 langues vit dans
  `converter/rom_cache/eu_ground_scripts_27.json`, régénérable par
  `dev/tools/audit_pmdred_eu_all_ground_scripts.py` avec la ROM).
- Sky : le détail des cutscenes NDS (SSB scripts) n'est pas encore extrait
  script par script — seuls les squelettes portés existent. Marqué
  REVIEW_REQUIRED dans le manifest.

## Régénération

```bash
# rendus (nécessite les sources dans .runtime-cache, voir dev/tools/*.py)
python3 dev/tools/campaign_render_grounds.py <Grounds> <Tiles> <out> --max-frames 6
python3 dev/tools/campaign_build_manifest_red.py
python3 dev/tools/campaign_build_manifest_sky.py
```
