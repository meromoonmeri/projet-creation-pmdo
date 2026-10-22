-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04C/m02a0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 424, 208, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, this could just be a wild\nguess on my part, but...", french=" Je peux me tromper, mais...", german="Nun, vielleicht irre ich mich ja,\naber...", italian="Potrei benissimo sbagliarmi,\nma...", spanish="Tal vez solo estoy dando palos\nde ciego, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I would guess that it's because\nyou fail so often. Our Guildmaster must be\nseething with anger over you.", french="... je pense que c'est parce que\nvous échouez si souvent. Notre Maître doit\nêtre furieux contre vous.", german="Ich würde sagen, dass es an\neurem Versagen liegt. Der Gildenmeister muss\nvor Wut schäumen.", italian="... penso abbia qualcosa a che\nfare con il fatto che fallite così spesso.\nIl Capitano dev'essere arrabbiatissimo.", spanish="Me parece que se debe a\nvuestros continuos fracasos. El Gran Bluff\ndebe de estar bastante enfadado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our Guildmaster is truly a\nterror when enraged...", french="Notre Maître est vraiment\neffrayant quand il est en colère...", german="Unser Gildenmeister ist nicht\nmehr zu bremsen, wenn er in Wut gerät.", italian="Il Capitano diventa davvero una\nfuria quando si arrabbia...", spanish="Y resulta terrorífico cuando se\nirrita..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So watch yourself and do your\nbest to avoid displeasing our Guildmaster.", french="Comportez-vous donc\ncorrectement et évitez d'agacer notre Maître.", german="Also seid vorsichtig und\nverärgert den Gildenmeister nicht.", italian="Quindi fate attenzione a ciò che\ndite e cercate di non farlo arrabbiare.", spanish="Así que mucho cuidado.\n¡No le saquéis de sus casillas!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
