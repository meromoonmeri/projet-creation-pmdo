# BIBLIOTHÈQUE TECHNIQUE DES CINÉMATIQUES CANONIQUES (PMD RED)

> **Document de référence pour l'implémentation de la mise en scène dans New Era (30 ans plus tard).**
> Ce document extrait les mécanismes C/ASM exacts utilisés par Game Freak / Chunsoft (mouvements de caméra, FX, musiques, flashes) pour créer des moments mémorables, afin de les transposer dans les scripts Lua de RogueEssence.

## Arc Fugitif : Embuscade d'Artikodin et intervention d'Absol (Forêt Givrée)
**Contexte originel** : La rencontre avec Artikodin au sommet, le combat, puis l'intervention d'Absol qui calme la situation et rejoint l'équipe.

### Ground : `D10P03`
- **Transitions / Cartes appelées** : SELECT_MAP(MAP_FROSTY_FOREST_END)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_FADEOUT(120), BGM_SWITCH(MUS_IN_THE_DEPTHS_OF_THE_PIT), BGM_FADEIN(150, 114), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_TO(FALSE, PALUTIL_KIND_05, 2, RGB_U32(0xCC, 0xCC, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 40, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0xCC, 0xCC, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0xCC, 0xCC, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0xFF, 0xFF, 0xFF))`
- **Directions Caméra** :
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 7 changements d'animation (chocs, idles, attaques).

### Ground : `D10P02`
- **Transitions / Cartes appelées** : EXECUTE_STATION(MAP_TEAM_BASE_INSIDE, 4, 0), SELECT_MAP(MAP_FROSTY_FOREST_MID)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_SWITCH(MUS_FROSTY_FOREST), BGM_FADEOUT(30)
- **Effets visuels et SFX (VFX)** :
- **Directions Caméra** :
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 1 changements d'animation (chocs, idles, attaques).

## Arc Fugitif : L'Autel de Feunard et la Révélation (Mont Gel)
**Contexte originel** : L'équipe atteint l'autel de Feunard. Alakazam tente de les éliminer, Feunard apparaît, révèle la vérité sur la légende et l'humain.

### Ground : `D11P03`
- **Transitions / Cartes appelées** : SELECT_MAP(203)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_FADEOUT(30), BGM_SWITCH(MUS_LEGEND_OF_NINETALES), BGM_SWITCH(MUS_THERES_TROUBLE), BGM_SWITCH(MUS_THE_ESCAPE), BGM_FADEOUT(150), BGM_FADEIN(60, 9), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_TO(FALSE, PALUTIL_KIND_05, 90, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_01, 30, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 3, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0xFF, 0xFF, 0xFF))`
- **Directions Caméra** :
  - `CAMERA_PAN(76, 10)`
  - `CAMERA_END_PAN()`
  - `CAMERA_PAN(76, 12)`
  - `CAMERA_PAN(76, 8)`
  - `CAMERA_PAN(76, 6)`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 10 changements d'animation (chocs, idles, attaques).

## Crise de la Météorite : Observation et Panique Mondiale (Place Pokémon, Colline des Anciens)
**Contexte originel** : Xatu observe la Météorite depuis la Colline des Anciens via Télépathie. Sur la Place Pokémon, la panique gagne la population devant le ciel qui s'assombrit.

### Ground : `T01P01`
- **Transitions / Cartes appelées** : EXECUTE_STATION(-1, -1, 1), EXECUTE_STATION(-1, 24, 1), EXECUTE_STATION(-1, 7, 1), EXECUTE_STATION(-1, -1, 4), EXECUTE_STATION(-1, 10, 0), EXECUTE_STATION(-1, 45, 1), EXECUTE_STATION(-1, 29, 1), EXECUTE_STATION(-1, 19, 0), EXECUTE_STATION(-1, 38, 1), EXECUTE_STATION(-1, 30, 1), EXECUTE_STATION(-1, 9, 0), EXECUTE_STATION(-1, 17, 0), EXECUTE_STATION(-1, 43, 0), SELECT_MAP(1), EXECUTE_STATION(-1, 8, 1)
- **Musiques / BGM utilisées** : BGM_SWITCH(MUS_POKEMON_SQUARE), BGM_FADEOUT(60), BGM_FADEOUT(120), BGM_FADEOUT(45), BGM_FADEOUT(30), BGM_SWITCH(MUS_RISING_FEAR), BGM_SWITCH(MUS_THERES_TROUBLE), BGM_SWITCH(MUS_WORLD_CALAMITY), BGM_SWITCH(MUS_IN_THE_DEPTHS_OF_THE_PIT), BGM_FADEOUT(150), BGM_FADEIN(60, 7), BGM_FADEIN(80, 7), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 32, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_01, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0x80, 0x80, 0x10))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 20, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_14, 30, RGB_U32(0x00, 0x00, 0x00))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_01, 15, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_14, 30, RGB_U32(0x00, 0x00, 0x00))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_01, 15, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0x80, 0x80, 0x10))`
- **Directions Caméra** :
  - `CAMERA_PAN(512, 10)`
  - `CAMERA_PAN(256, 22)`
  - `CAMERA_PAN(512, 9)`
  - `CAMERA_PAN(256, 23)`
  - `CAMERA_END_PAN()`
  - `CAMERA_PAN(256, 112)`
  - `CAMERA_PAN(256, 94)`
  - `CAMERA_PAN(512, 12)`
  - `CAMERA_PAN(512, 13)`
  - `CAMERA_PAN(512, 11)`
  - `CAMERA_PAN(256, 113)`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 18 changements d'animation (chocs, idles, attaques).

### Ground : `D07P02`
- **Transitions / Cartes appelées** : SELECT_MAP(192)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_FADEOUT(30), BGM_SWITCH(MUS_IN_THE_DEPTHS_OF_THE_PIT), BGM_FADEOUT(150), BGM_FADEIN(60, 6), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
- **Directions Caméra** :
  - `CAMERA_PAN(512, 10)`
  - `CAMERA_END_PAN()`
  - `CAMERA_PAN(512, 12)`
  - `CAMERA_PAN(512, 13)`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 6 changements d'animation (chocs, idles, attaques).

## L'Ascension Finale et l'Éveil de Rayquaza (Tour Céleste)
**Contexte originel** : L'équipe arrive au sommet. Rayquaza apparaît des nuages. Mise en scène épique, éclairs, tremblements de caméra.

### Ground : `D13P03`
- **Transitions / Cartes appelées** : SELECT_MAP(MAP_SKY_TOWER_END)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_FADEOUT(120), BGM_SWITCH(MUS_RAYQUAZAS_DOMAIN), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 8, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 30, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 16, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 8, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 4, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 4, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 16, RGB_U32(0xFF, 0xFF, 0xFF))`
- **Directions Caméra** :
  - `CAMERA_END_PAN()`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 7 changements d'animation (chocs, idles, attaques).

## La Destruction de la Météorite et le Retour sur Terre (Ciel, Espace, Terrain Inconnu)
**Contexte originel** : Rayquaza utilise Ultralaser, la météorite explose (Flash blanc, secousses extrêmes). Le Héros perd connaissance, rêve de Gardevoir (A04P01), puis se réveille entouré de ses amis.

### Ground : `D13P03`
- **Transitions / Cartes appelées** : SELECT_MAP(MAP_SKY_TOWER_END)
- **Musiques / BGM utilisées** : BGM_FADEOUT(60), BGM_FADEOUT(120), BGM_SWITCH(MUS_RAYQUAZAS_DOMAIN), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 8, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 30, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 16, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 8, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 4, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 4, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 16, RGB_U32(0xFF, 0xFF, 0xFF))`
- **Directions Caméra** :
  - `CAMERA_END_PAN()`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 7 changements d'animation (chocs, idles, attaques).

### Ground : `T01P01`
- **Transitions / Cartes appelées** : EXECUTE_STATION(-1, -1, 1), EXECUTE_STATION(-1, 24, 1), EXECUTE_STATION(-1, 7, 1), EXECUTE_STATION(-1, -1, 4), EXECUTE_STATION(-1, 10, 0), EXECUTE_STATION(-1, 45, 1), EXECUTE_STATION(-1, 29, 1), EXECUTE_STATION(-1, 19, 0), EXECUTE_STATION(-1, 38, 1), EXECUTE_STATION(-1, 30, 1), EXECUTE_STATION(-1, 9, 0), EXECUTE_STATION(-1, 17, 0), EXECUTE_STATION(-1, 43, 0), SELECT_MAP(1), EXECUTE_STATION(-1, 8, 1)
- **Musiques / BGM utilisées** : BGM_SWITCH(MUS_POKEMON_SQUARE), BGM_FADEOUT(60), BGM_FADEOUT(120), BGM_FADEOUT(45), BGM_FADEOUT(30), BGM_SWITCH(MUS_RISING_FEAR), BGM_SWITCH(MUS_THERES_TROUBLE), BGM_SWITCH(MUS_WORLD_CALAMITY), BGM_SWITCH(MUS_IN_THE_DEPTHS_OF_THE_PIT), BGM_FADEOUT(150), BGM_FADEIN(60, 7), BGM_FADEIN(80, 7), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 32, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_01, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0x80, 0x80, 0x10))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 20, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_14, 30, RGB_U32(0x00, 0x00, 0x00))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_01, 15, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_14, 30, RGB_U32(0x00, 0x00, 0x00))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_01, 15, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 2, RGB_U32(0x80, 0x80, 0x10))`
- **Directions Caméra** :
  - `CAMERA_PAN(512, 10)`
  - `CAMERA_PAN(256, 22)`
  - `CAMERA_PAN(512, 9)`
  - `CAMERA_PAN(256, 23)`
  - `CAMERA_END_PAN()`
  - `CAMERA_PAN(256, 112)`
  - `CAMERA_PAN(256, 94)`
  - `CAMERA_PAN(512, 12)`
  - `CAMERA_PAN(512, 13)`
  - `CAMERA_PAN(512, 11)`
  - `CAMERA_PAN(256, 113)`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 18 changements d'animation (chocs, idles, attaques).

### Ground : `A04P01`
- **Transitions / Cartes appelées** : SELECT_MAP(171)
- **Musiques / BGM utilisées** : BGM_FADEOUT(30), BGM_FADEOUT(180), BGM_SWITCH(MUS_AFTERMATH), BGM_FADEOUT(90), BGM_SWITCH(MUS_WORLD_CALAMITY), BGM_SWITCH(MUS_FAREWELL), BGM_FADEOUT(240), BGM_STOP()
- **Effets visuels et SFX (VFX)** :
  - `FLASH_FROM(FALSE, PALUTIL_KIND_05, 32, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_TO(TRUE, PALUTIL_KIND_05, 32, RGB_U32(0xFF, 0xFF, 0xFF))`
  - `FLASH_FROM(TRUE, PALUTIL_KIND_05, 60, RGB_U32(0xFF, 0xFF, 0xFF))`
- **Directions Caméra** :
  - `CAMERA_END_PAN()`
  - `CAMERA_INIT_PAN()`
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 7 changements d'animation (chocs, idles, attaques).

### Ground : `A05P03`
- **Transitions / Cartes appelées** : SELECT_MAP(MAP_THE_END)
- **Musiques / BGM utilisées** : BGM_STOP()
- **Effets visuels et SFX (VFX)** :
- **Directions Caméra** :
- **Mouvements & Animations** : 0 commandes de déplacement (MOVE_TO_POS) et 0 changements d'animation (chocs, idles, attaques).

---
## Traduction des Macros GBA vers RogueEssence (Guide Lua)

| Macro GBA (PMD Red) | Équivalent Lua (RogueEssence) | Commentaire |
|---|---|---|
| `BGM_SWITCH(MUS_RAYQUAZAS_DOMAIN)` | `GAME:PlayBGM('Rayquazas Domain', true)` | Changement de musique d'ambiance |
| `BGM_FADEOUT(120)` | `GAME:FadeOutBGM(120)` | Fondu de tension avant un impact |
| `FLASH_TO(TRUE, ..., RGB_U32(0xFF, 0xFF, 0xFF))` | `GAME:FadeOut(true, 10)` (Blanc) | Utilisé massivement pour les explosions (Météorite, Hyperlaser) |
| `SCREEN_SHAKE(1, 4, 30)` | `GAME:WaitFrames(10)` (Tremblement via Coroutine ou VFX spécial) | Le moteur GBA utilisait le scrolling de la VRAM pour secouer l'écran. |
| `CAMERA_INIT_PAN(...)` | `GAME:MoveCamera(X, Y, speed)` | Panoramas d'introduction de scène |
| `SELECT_ANIMATION(24)` | `GROUND:CharSetAction(ent, RogueEssence.Ground.Animations.AttackAction())` | Mouvements d'attaques, chocs, etc. |
| `SELECT_MAP(...)` | `GAME:EnterGroundMap('map_name', 'marker')` | Séquençage entre différentes cartes |
