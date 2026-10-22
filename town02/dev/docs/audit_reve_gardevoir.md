# Audit — Scène du rêve de Gardevoir vs brief (section 3 du plan)

**Build `2026-08-03-J`** · **Rien n'a été testé en jeu.**

## Réponse courte

**Oui, la scène est intégrée** — elle existait déjà (`Data/Ground/hero_dream.rsground`
+ `Data/Script/halcyon/ground/hero_dream/init.lua`, 27 répliques, 8 sections). Mais
elle n'était **pas entièrement conforme** : l'audit a trouvé **3 écarts réels**, tous
corrigés ici.

## Conformité point par point

| Exigence du brief (section 3) | État avant | Action |
|---|---|---|
| Option B retenue (modèle Rescue Team, pas Ground riche) | ✅ conforme | — |
| **Parallax identique** au test de personnalité | ✅ conforme — `Dream_Back`, champ `Background` **identique** à `personality_test.rsground` (comparé en JSON) | — |
| **Même morceau de musique** | ❌ **écart** — jouait `I Saw Something Again....ogg` au lieu de `Welcome to the World of Pokémon!.ogg` | **corrigé** |
| Écran noir + « Cela faisait longtemps, » **totalement silencieux** avant le rêve | ❌ **absent** — on passait du noir directement au `FadeIn` + musique | **ajouté** (`DRM_000`) |
| Héros centré, pas de déplacement libre | ✅ conforme — `TeleportTo(152,112)`, aucun `MoveToPosition(hero)`, `CutsceneMode` tenu | — |
| Gardevoir en sprite, dialogue face au héros | ✅ conforme — `MonsterID("gardevoir")`, posée en (152,48) | — |
| Apparition progressive (clignotement, pas instantanée) | ✅ conforme — 3 paliers `Absent`→`Transparent`→opaque, SE, caméra attirée | — |
| **Mouvements élégants, jamais un PNJ banal** | ❌ **écart** — parfaitement immobile pendant les 17 répliques | **corrigé** |
| Temps de flottement/confusion avant son apparition | ✅ conforme — sections 1-2, `DRM_001`..`DRM_009` | — |
| Arc complet (intro / montée / moment fort / conclusion) | ✅ conforme — 8 sections | — |

## Les 3 corrections

**1. La musique.** Le brief est explicite : *« ce sont **les mêmes assets, réutilisés
à l'identique** : même parallax de couleur, **même morceau de musique** »*. Le
parallax l'était, pas la musique. Le joueur perdait donc la moitié du dispositif de
reconnaissance voulu. → `Welcome to the World of Pokémon!.ogg`, celui de
`personality_test/init.lua:141`.

**2. L'écran noir silencieux.** Beat entièrement absent. Ajouté avant la mise en
place, avec `DRM_000` = *« Cela faisait longtemps, si longtemps... »* (FR + EN).

Le silence est **réel**, pas supposé : `StopBGM` coupe la musique du camp, et
j'ajoute `FadeOutSE('AMB_Fire_Loud')` — sans ça on aurait entendu le feu de la
veillée tourner en boucle par-dessus l'écran noir, et le « totalement silencieux »
du brief aurait été faux. Aucun `PlayBGM` avant le `FadeIn` : la musique et le
parallax démarrent bien **ensemble**, à l'instant exact demandé.

**3. Le langage corporel de Gardevoir.** Elle apparaissait magnifiquement… puis ne
bougeait plus d'un pixel pendant 17 répliques. Un sprite figé redevient exactement
le « PNJ banal » que le brief refuse.

Trois gestes seulement, aux trois moments qui comptent (règle de dosage : la rareté
fait l'impact) :
- **`hoverEntity()`** sur « tu as fait tout ce chemin » — dérive de 4 px en
  `MoveToPosition` vitesse 1 (glissement, pas un pas ; `Hop` aurait fait un saut sec) ;
- **elle détourne le regard** avant « Et pourtant si. » — la seule fois où elle ne le
  fixe pas ; c'est ce que fait quelqu'un qui en sait plus qu'il n'en dit, et ça
  prépare la réplique sans qu'aucune ligne ne l'explique ;
- **elle s'élève de 6 px en s'effaçant** — elle ne *part* pas, elle se dissout en
  montant. Dernier geste de la scène, donc celui qu'on retient.

Positions vérifiées sur la grille d'obstacles de `hero_dream.rsground` (320×240) :
(152,48), (152,44), (152,42) toutes en sol libre.

## Ce qui reste ouvert

L'**Option A** du brief (Ground riche : végétation, eau, cascades) est marquée
obsolète par le document lui-même au profit de l'Option B. J'ai donc appliqué
l'Option B. Si tu veux finalement la A, c'est une refonte complète de la carte —
dis-le-moi.

## Baselines

| Contrôle | Valeur |
|---|---|
| `audit_bugs.py` | 12 (inchangé) |
| `audit_integrite.py` | 849 (inchangé) |
| `count_dialogue.py` ch5 | 1612 (inchangé) |
| Compilation Lua | 670 fichiers, 0 erreur |
| `verify_emotions.py` | aucun risque |
| Clés `DRM_*` | présentes en FR **et** EN, XML valide |

Verts : `verify_scene_positions`, `verify_lua_globals`, `verify_cutscene_guard`,
`verify_spawner_enabled`, `verify_legend`, `verify_bg_format`.
