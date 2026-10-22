-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P06B/m07a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P06B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(192, 212, 60, false) end) -- performer/caméra
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 208, Direction.Left, "NPC_PERAPPU")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 240, 184, Direction.Down, "NPC_DOGOOMU")
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
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 320, 192, Direction.Down, "NPC_CHIRIIN")
  -- SetAnimation(42) [anim idle native]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 216, 232, Direction.Up, "NPC_ZUBATTO")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 192, 232, Direction.Up, "NPC_DOGAASU")
  -- SetAnimation(43) [anim idle native]
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 168, 208, Direction.Down, "NPC_SUKATANKU")
  -- SetAnimation(42) [anim idle native]
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
  -- SetAnimation(21) [anim idle native]
  -- GAP: BGM BGM_EATING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  -- message_ResetActor() [neutre/état moteur]
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Gnam-gnam! Ingurg-ingurg! Slurp-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  SkySceneKit.say({english="Crunch munch! Chomp chomp! Gobble gulp![K]\nCrunch munch! Chomp chomp! Gobble gulp!", french="Cronch cronch! Miam miam! Slurp slurp![K]\nCronch cronch! Miam miam! Slurp slurp!", german="Stopf-schling! Schmatz! Schlabber-schlürf![K]\nStopf-schling! Schmatz! Schlabber-schlürf!", italian="Crunch-munch! Ingurg ingurg! Snuffle-slurp![K]\nGnam-gnam! Crunch-crunch! Slurp-slurp!", spanish="¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem![K]\n¡Ñam, ñam! ¡Glup, glup! ¡Ñem, ñem!"}) -- message_ImitationSound (onomatopée)
  -- message_CloseEnforce
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  else
  SkySceneKit.say({english=" Urf...", french=" Arf...", german=" Urf...", italian=" Urf...", spanish=" Ay..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
