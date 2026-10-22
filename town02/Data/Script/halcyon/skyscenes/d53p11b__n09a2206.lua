-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P11B/n09a2206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 4 for actor ACTOR_NPC_YAMIRAMI4
    local npc_npc_yamirami4 = SkySceneKit.spawn_npc("sableye", 296, 160, Direction.Up, "NPC_YAMIRAMI4")
    -- SetAnimation(2) [anim idle native]
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(math.random(45, 60))
    GROUND:EntTurn(npc_npc_yamirami4, Direction.DownLeft)
    pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, "happy", 1) end)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(math.random(30, 40))
    pcall(function() GROUND:CharSetEmote(npc_npc_yamirami4, nil, 0) end) -- EFFECT_NONE
    GAME:WaitFrames(10)
    GROUND:EntTurn(npc_npc_yamirami4, Direction.Up)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  -- GAP: BGM BGM_A_NEW_WORLD non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D53P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FadeIn(0, 60) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(60)
  GAME:WaitFrames(160)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
