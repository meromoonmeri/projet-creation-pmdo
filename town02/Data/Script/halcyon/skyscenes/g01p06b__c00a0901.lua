-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06B/c00a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_NPC_PUKURIN
    local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 368, 232, Direction.Down, "NPC_PUKURIN")
    -- SetAnimation(5) [anim idle native]
    -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
    SkySceneKit.lock(5) -- Lock(5) NDS
    -- @label_3 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
    GAME:WaitFrames(20)
    GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
    GAME:WaitFrames(20)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-200), g.ViewCenter.Y+(0), 400, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(1)
  -- SetAnimation(64) [anim idle native]
  -- SetAnimation(64) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 208, Direction.Left, "NPC_PERAPPU")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 248, 184, Direction.Down, "NPC_DOGOOMU")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 232, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 296, 232, Direction.Up, "NPC_DAGUTORIO")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 248, 232, Direction.Up, "NPC_KIMAWARI")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 296, 184, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 272, 184, Direction.Down, "NPC_BIPPA")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 272, 232, Direction.Up, "NPC_GUREGGURU")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 320, 184, Direction.Down, "NPC_CHIRIIN")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 216, 232, Direction.Up, "NPC_ZUBATTO")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 192, 232, Direction.Up, "NPC_DOGAASU")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 168, 208, Direction.Right, "NPC_SUKATANKU")
  -- SetAnimation(42) [anim idle native]
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_EATING_SLOW — VFX sans émote PMDO équivalente
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- Destroy() [neutre/état moteur]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- SetAnimation(20) [anim idle native]
  -- GAP: BGM BGM_EATING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch-munch! Chew-chew! Snuffle-slurp!\nCrunch-munch! Chew-chew! Snuffle-slurp!", french="Cronch cronch! Miam miam! Slurp slurp!\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf!\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp!\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  elseif true then -- default
  -- @label_1 [étiquette de flux ExplorerScript]
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
