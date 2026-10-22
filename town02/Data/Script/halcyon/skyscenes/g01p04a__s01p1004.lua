-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s01p1004.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  else
  SkySceneKit.say({english=" [CS:P]Luminous Spring[CR]?", french=" La [CS:P]Source Lumineuse[CR]?", german=" [CS:P]Glitzerquelle[CR]?", italian=" [CS:P]Sorgente Luccichio[CR]?", spanish=" ¿[CS:P]Manantial Luminoso[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 224, Direction.DownRight, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yup! ♪[K] It was where Pokémon\nonce went to evolve.", french="Ouiii! ♪[K] C'est à cet endroit que\nles Pokémon partaient autrefois pour évoluer.", german="Ja! ♪[K] Dort gingen einst die\nPokémon hin, um sich zu entwickeln.", italian="Sì! ♪[K] È lì che una volta i\nPokémon andavano a evolversi.", spanish="Sí. ♪[K] Allí es donde antaño\niban los Pokémon a evolucionar."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="But maybe because of the time\ntroubles we had...[K]no sunlight shines on the\nspring now.", french="Mais peut-être à cause des\ndérèglements temporels...[K] le soleil a cessé\nde briller sur la source.", german="Vielleicht scheint wegen der\nSchwierigkeiten, die wir mit der Zeit hatten,[K]\nkein Sonnenlicht mehr auf die Quelle.", italian="Ma forse a causa dei problemi\nlegati al tempo che abbiamo avuto...[K] adesso\nla luce del sole non raggiunge più la sorgente.", spanish="Aunque ya no brilla la luz del sol\nen el manantial.[K] Quizás debido a los problemas\ncon el tiempo..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Now nothing can evolve there.", french="Maintenant, c'est complètement\nimpossible d'évoluer là-bas.", german="Im Moment kann sich dort nichts\nentwickeln.", italian="Non si può più evolvere\nnessuno lì.", spanish="El caso es que, ahora, ningún\nPokémon puede evolucionar allí."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
