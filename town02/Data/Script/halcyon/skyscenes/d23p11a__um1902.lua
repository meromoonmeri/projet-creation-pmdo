-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/um1902.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp(29, 94) >= 0) or (SkyProg.cmp(29, 93) >= 0) or (SkyProg.cmp(29, 92) >= 0) or (SkyProg.cmp(29, 91) >= 0) or (SkyProg.cmp(29, 90) >= 0) or (SkyProg.cmp(29, 89) >= 0) or (SkyProg.cmp(29, 88) >= 0) or (SkyProg.cmp(29, 87) >= 0) or (SkyProg.cmp(29, 85) >= 0) or (SkyProg.cmp(29, 84) >= 0) or (SkyProg.cmp(29, 83) >= 0) or (SkyProg.cmp(29, 82) >= 0) or (SkyProg.cmp(29, 81) >= 0) or (SkyProg.cmp(29, 80) >= 0) or (SkyProg.cmp(29, 78) >= 0) or (SkyProg.cmp(29, 76) >= 0) or (SkyProg.cmp(29, 75) >= 0) or (SkyProg.cmp(29, 73) >= 0) or (SkyProg.cmp(29, 72) >= 0) or (SkyProg.cmp(29, 71) >= 0) or (SkyProg.cmp(29, 70) >= 0) or (SkyProg.cmp(29, 69) >= 0) or (SkyProg.cmp(29, 67) >= 0) or (SkyProg.cmp(29, 56) >= 0) or (SkyProg.cmp(29, 55) >= 0) or (SkyProg.cmp(29, 54) >= 0) or (SkyProg.cmp(29, 53) >= 0) or (SkyProg.cmp(29, 52) >= 0) or (SkyProg.cmp(29, 50) >= 0) or (SkyProg.cmp(29, 49) >= 0) or (SkyProg.cmp(29, 48) >= 0) or (SkyProg.cmp(29, 47) >= 0) or (SkyProg.cmp(29, 46) >= 0) or (SkyProg.cmp(29, 45) >= 0) or (SkyProg.cmp(29, 44) >= 0) or (SkyProg.cmp(29, 43) >= 0) or (SkyProg.cmp(29, 42) >= 0) or (SkyProg.cmp(29, 41) >= 0) or (SkyProg.cmp(29, 40) >= 0) or (SkyProg.cmp(29, 39) >= 0) or (SkyProg.cmp(29, 33) >= 0) or (SkyProg.cmp(29, 32) >= 0) or (SkyProg.cmp(29, 31) >= 0) or (SkyProg.cmp(29, 30) >= 0) or (SkyProg.cmp(29, 29) >= 0) or (SkyProg.cmp(29, 28) >= 0) or (SkyProg.cmp(29, 27) >= 0) or (SkyProg.cmp(29, 26) >= 0) or (SkyProg.cmp(29, 25) >= 0) or (SkyProg.cmp(29, 24) >= 0) or (SkyProg.cmp(29, 23) >= 0) or (SkyProg.cmp(29, 22) >= 0) or (SkyProg.cmp(29, 21) >= 0) or (SkyProg.cmp(29, 20) >= 0) or (SkyProg.cmp(29, 19) >= 0) or (SkyProg.cmp(29, 18) >= 0) or (SkyProg.cmp(29, 17) >= 0) or (SkyProg.cmp(29, 16) >= 0) or (SkyProg.cmp(29, 15) >= 0) or (SkyProg.cmp(29, 14) >= 0) or (SkyProg.cmp(29, 13) >= 0) or (SkyProg.cmp(29, 12) >= 0) or (SkyProg.cmp(29, 11) >= 0) or (SkyProg.cmp(29, 10) >= 0) or (SkyProg.cmp(29, 8) >= 0) or (SkyProg.cmp(29, 6) >= 0) or (SkyProg.cmp(29, 5) >= 0) or (SkyProg.cmp(29, 4) >= 0) or (SkyProg.cmp(29, 3) >= 0) or (SkyProg.cmp(29, 2) >= 0) or (SkyProg.cmp(29, 1) >= 0) or (SkyProg.cmp(25, 4) >= 0) or (SkyProg.cmp(25, 3) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 2) >= 0) or (SkyProg.cmp(25, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(24, 1) >= 0) or (SkyProg.cmp(23, 3) >= 0) or (SkyProg.cmp(23, 2) >= 0) or (SkyProg.cmp(23, 1) >= 0) or (SkyProg.cmp(22, 3) >= 0) or (SkyProg.cmp(22, 2) >= 0) or (SkyProg.cmp(21, 2) >= 0) or (SkyProg.cmp(21, 1) >= 0) or (SkyProg.cmp(20, 4) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 94] || scn($SCENARIO_MAIN) >= [2
  if ((SV.SkyTalkBitFlags or {})[28] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[28]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 280, 488, Direction.Up, "NPC_SEREBII")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_serebii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I don't have any special feelings\nfor him or anything!", french="Je ne ressens rien de particulier\npour lui!", german="Ich hege keine besonderen\nGefühle für ihn oder dergleichen!", italian="Non provo nulla di speciale\nper lui!", spanish=" ¡No siento nada especial por él!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Let's go already!", french=" Allons-y!", german=" Jetzt aber los!", italian=" Forza, muoviamoci!", spanish=" ¡Vámonos ya!"})
  -- message_Close
  -- @label_130 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[28] = 1 -- $SCENARIO_TALK_BIT_FLAG[28] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_serebii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" Ugh! We couldn't get through...", french=" Aaaah! Nous avons échoué...", german="Urgs! Wir sind nicht\ndurchgekommen.", italian=" Uh! Non ce l'abbiamo fatta...", spanish=" ¡Ay! No hemos podido pasar..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="But I'm not disappointed. I'm\neven a little happy.", french="Mais je ne suis pas déçue.\nAu contraire, je suis plutôt contente.", german="Aber ich bin nicht enttäuscht.\nIch bin sogar ein wenig froh.", italian="Ma non sono triste. Anzi, sono\nanche un po' felice.", spanish="Pero no estoy decepcionada.\nEstoy hasta un poquito contenta."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="It means I get to spend a little\nmore time with [CS:N]Grovyle[CR]! ♪", french="Ça veut dire que je vais pouvoir\npasser plus de temps avec [CS:N]Massko[CR]! ♪", german="Das bedeutet, dass ich ein wenig\nmehr Zeit mit [CS:N]Reptain[CR] verbringen kann! ♪", italian="Vorrà dire che passerò un po'\ndi tempo in più con [CS:N]Grovyle[CR]! ♪", spanish="¡Eso significa que así estoy\nun rato más con [CS:N]Grovyle[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(npc_npc_serebii, 1, 10, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Uh... Oh![K] Don't take it the wrong\nway! That's not what I meant!", french="Euh... oh![K] Ne le prenez pas\ndans ce sens-là! Ce n'est pas du tout ce que\nje voulais dire!", german="Ah... Oh![K] Versteht das nicht\nfalsch! Das war nicht das, was ich gemeint\nhabe!", italian="Uh... Oh![K] Non pensate male!\nNon intendevo quello!", spanish="¡Oh! Esto...[K] No lo interpretéis\nmal, ¿eh? ¡Eso no es lo que quería decir!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(20, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 3]
  if ((SV.SkyTalkBitFlags or {})[27] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[27]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_serebii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I don't have any special feelings\nfor him or anything!", french="Je ne ressens rien de particulier\npour lui!", german="Ich hege keine besonderen\nGefühle für ihn oder dergleichen!", italian="Non provo nulla di speciale\nper lui!", spanish=" ¡No hay nada entre nosotros!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english=" We need to keep moving!", french=" Il faut continuer à avancer!", german=" Wir müssen weiter!", italian=" Forza, muoviamoci!", spanish=" ¡Hay que seguir adelante!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[27] = 1 -- $SCENARIO_TALK_BIT_FLAG[27] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_serebii, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Hi, hi! So listen.[K] This is just a\nlittle secret...", french="Hi, hi! Ecoutez bien.[K] J'ai un\npetit secret à vous confier...", german="Hi, hi! Also hört mal zu![K] Hier ist\nein kleines Geheimnis...", italian="Hi, hi! Ascoltate allora.[K] Solo\nun piccolo segreto...", spanish="¡Hola, hola! Escuchadme.[K] Tengo\nun secretito..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Did you know that [CS:N]Grovyle[CR] is\nreally impatient and hasty?", french="Saviez-vous que [CS:N]Massko[CR] est\nun Pokémon très impatient qui a souvent\ntendance à précipiter les choses?", german="Wusstet ihr, dass [CS:N]Reptain[CR]\nwirklich ungeduldig und ungestüm ist?", italian="Lo sapete che [CS:N]Grovyle[CR] è davvero\nimpaziente e frettoloso?", spanish="¿Sabíais que [CS:N]Grovyle[CR] es muy\nimpaciente y siempre va con prisas?"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I know that he wants to hurry,\nbut I do wish he would slow down a little...", french="Je sais bien qu'il veut toujours\nfaire vite, mais j'aimerais quand même qu'il\nralentisse un peu le pas...", german="Ich weiß, dass er es eilig hat,\naber ich wünschte mir, er würde es etwas\nlangsamer angehen lassen.", italian="So che vuole sempre fare tutto\ndi fretta, ma mi piacerebbe che ogni tanto\nrallentasse un po'...", spanish="Ya sé que quiere acabar con\nesto cuanto antes, pero a veces me\ngustaría que frenara un poco..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="It would sure make me happier\nif he did...", french="Je serais heureuse s'il le\nfaisait...", german="Wenn er es täte, würde mich\ndas auf jeden Fall glücklicher machen...", italian=" Sarei felice se lo facesse...", spanish="A mí, desde luego, me haría\nmucho más feliz..."})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I want to spend as much time as\nI can with him...", french="Je veux passer autant de temps\nque possible avec lui...", german="Ich möchte so viel Zeit wie\nmöglich mit ihm verbringen...", italian="Voglio passare con lui tutto il\ntempo che posso...", spanish="Quiero pasar todo el tiempo\nque pueda con él..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(npc_npc_serebii, 1, 10, 5)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_serebii, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_serebii, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="Uh... Oh![K] That's not how I meant\nit! Not at all!", french="Oui... euh![K] Ce n'est pas ce que\nje voulais dire! Pas du tout! Je n'ai rien dit!", german="Ah... Oh![K] So war das nicht\ngemeint! Ganz und gar nicht!", italian="Uh... Oh![K] Non intendevo quello!\nAssolutamente!", spanish="Esto... ¡Oh![K] ¡Eso no es lo que\nquería decir! ¡Para nada!"})
  pcall(function() UI:SetSpeaker(npc_npc_serebii) end)
  SkySceneKit.say({english="I don't have any special feelings\nfor him or anything!", french="Je ne ressens rien de particulier\npour lui!", german="Ich hege keine besonderen\nGefühle für ihn oder dergleichen!", italian="Non provo nulla di speciale\nper lui!", spanish=" ¡No hay nada entre nosotros!"})
  -- message_Close
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(20, 2) >= 0) or (SkyProg.cmp(20, 1) >= 0) or (SkyProg.cmp(17, 3) >= 0) or (SkyProg.cmp(17, 1) >= 0) or (SkyProg.cmp(16, 2) >= 0) or (SkyProg.cmp(16, 0) >= 0) or (SkyProg.cmp(15, 4) >= 0) or (SkyProg.cmp(15, 1) >= 0) or (SkyProg.cmp(14, 5) >= 0) or (SkyProg.cmp(14, 4) >= 0) or (SkyProg.cmp(14, 2) >= 0) or (SkyProg.cmp(14, 1) >= 0) or (SkyProg.cmp(13, 2) >= 0) or (SkyProg.cmp(13, 1) >= 0) or (SkyProg.cmp(12, 4) >= 0) or (SkyProg.cmp(12, 3) >= 0) or (SkyProg.cmp(12, 1) >= 0) or (SkyProg.cmp(10, 2) >= 0) or (SkyProg.cmp(10, 1) >= 0) or (SkyProg.cmp(9, 5) >= 0) or (SkyProg.cmp(9, 4) >= 0) or (SkyProg.cmp(9, 2) >= 0) or (SkyProg.cmp(9, 1) >= 0) or (SkyProg.cmp(8, 7) >= 0) or (SkyProg.cmp(8, 6) >= 0) or (SkyProg.cmp(8, 5) >= 0) or (SkyProg.cmp(8, 3) >= 0) or (SkyProg.cmp(8, 2) >= 0) or (SkyProg.cmp(8, 1) >= 0) or (SkyProg.cmp(7, 6) >= 0) or (SkyProg.cmp(7, 3) >= 0) or (SkyProg.cmp(7, 2) >= 0) or (SkyProg.cmp(7, 1) >= 0) or (SkyProg.cmp(6, 5) >= 0) or (SkyProg.cmp(6, 1) >= 0) or (SkyProg.cmp(5, 5) >= 0) or (SkyProg.cmp(4, 7) >= 0) or (SkyProg.cmp(4, 5) >= 0) or (SkyProg.cmp(4, 3) >= 0) or (SkyProg.cmp(4, 2) >= 0) or (SkyProg.cmp(4, 1) >= 0) or (SkyProg.cmp(4, 0) >= 0) or (SkyProg.cmp(3, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 2] || scn($SCENARIO_MAIN) >= [20
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_130 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
