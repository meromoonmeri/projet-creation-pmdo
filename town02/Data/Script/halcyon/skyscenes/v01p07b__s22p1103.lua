-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V01P07B/s22p1103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V01P07B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-180), g.ViewCenter.Y+(0), 452, false) end) -- MovePositionOffset performer/caméra
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker("Darkrai", true, "darkrai", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_DAAKURAI) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Yes. You and [CS:N]Grovyle[CR] had an\naccident while traveling through time.", french="Oui. Vous avez eu un accident\nen voyageant dans le temps.", german="Ja. Du und [CS:N]Reptain[CR] hattet einen\nUnfall, als ihr durch die Zeit gereist seid.", italian="Sì. Tu e [CS:N]Grovyle[CR] avete avuto\nun incidente mentre viaggiavate nel tempo.", spanish="Sí. Tú y [CS:N]Grovyle[CR] tuvisteis\nun accidente viajando en el tiempo."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="You became separated as a\nresult of it.", french="Et c'est ainsi que vous avez été\nséparés.", german=" Dadurch wurdet ihr getrennt.", italian="E di conseguenza vi siete\nseparati.", spanish=" Y por eso os separasteis."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
end
