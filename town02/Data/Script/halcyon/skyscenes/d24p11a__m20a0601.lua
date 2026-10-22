-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D24P11A/m20a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh! We blew that attempt!", french=" Argh! Ça s'est mal fini!", german=" Uff! Das war nichts!", italian=" Uff! Abbiamo fallito!", spanish=" ¡Ay! ¡La hemos pifiado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! We didn't make it.", french=" Argh! Ça s'est mal fini!", german="Uff! Wir haben es nicht\ngeschafft.", italian=" Uff! Non ce l'abbiamo fatta.", spanish=" ¡Vaya! ¡Otra vez hemos fallado!"})
  else
  SkySceneKit.say({english=" Ugh! That ended badly.", french=" Argh! Ça s'est mal fini!", german=" Uff! Das endete schlimm.", italian=" Uff! È andata male.", spanish=" ¡No lo hemos logrado esta vez!"})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D24P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D24P11A, 'UM20') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treeshroud Forest.ogg", true) end)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 192, Direction.Down, "NPC_JUPUTORU")
  GROUND:EntTurn(npc_npc_juputoru, Direction.Down)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...we were careless.", french="Argh... on aurait dû être plus\nprudents.", german="Uff... Wir waren zu\nunvorsichtig.", italian="Oh... Non abbiamo fatto\nabbastanza attenzione.", spanish=" Ay... Nos hemos descuidado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh...we were caught being\ncareless.", french="Argh... on aurait dû être plus\nprudents.", german="Uff... Wir sind auf dem falschen\nFuß erwischt worden.", italian="Oh... Non abbiamo fatto\nabbastanza attenzione.", spanish="Ay... Nos han cogido\ndesprevenidos."})
  else
  SkySceneKit.say({english="Ugh...we should have been\nmore careful.", french="Argh... on aurait dû faire preuve\nde plus de prudence.", german="Uff... Wir hätten vorsichtiger\nsein sollen.", italian="Oh... Avremmo dovuto fare più\nattenzione.", spanish="Ay... Tendríamos que haber\ntenido más cuidado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is pretty rough going...", french=" C'est plus dur que je le croyais...", german="Das ist eine ziemlich raue\nGangart hier...", italian=" È piuttosto difficile...", spanish=" Es una ruta complicada..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This isn't quite so easy...", french=" C'est plus dur que je le croyais...", german=" Das ist nicht ganz so einfach...", italian=" Non è molto facile...", spanish=" Esto no es tan fácil..."})
  else
  SkySceneKit.say({english=" It's harder than I thought...", french=" C'est plus dur que je le croyais...", german="Das ist schwerer, als ich\ndachte...", italian="È più difficile di quel che\npensassi...", spanish="Es más difícil de lo que me\nesperaba..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" I thought so.", french=" C'est bien ce que je pensais.", german=" Das dachte ich mir.", italian=" È come pensavo.", spanish=" Lo sabía."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="This place does feel different\ncompared to my last time through.", french="Cet endroit a bel et bien changé\ndepuis la dernière fois que j'y suis venu.", german="Dieser Ort fühlte sich anders an,\nals ich das letzte Mal hier durchgegangen bin.", italian="Questo posto è diverso\ndall'ultima volta.", spanish="Notaba algo distinto a la última\nvez que estuve aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The Pokémon here weren't so\nsavage before.", french="Les Pokémon qui y vivent\nn'étaient pas aussi féroces avant.", german="Die Pokémon hier waren damals\nnicht ganz so wild.", italian="Prima i Pokémon non erano\ncosì feroci da queste parti.", spanish="Los Pokémon de esta zona\nno solían ser tan feroces."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="There may be something taking\nplace here...", french="Il doit sûrement se passer\nquelque chose ici...", german=" Irgendetwas geht hier vor sich...", italian=" Dev'essere successo qualcosa.", spanish="Tiene que estar pasando algo\nen este lugar..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...somewhere in its depths.", french=" ... au cœur de cette forêt.", german=" Irgendwo in den Tiefen...", italian="Da qualche parte, nel cuore\ndella foresta...", spanish=" En algún rincón..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh! We should pick up the\npace then.", french="Argh! On ferait mieux de\nse dépêcher alors.", german="Uff! Dann sollten wir einen\nSchritt zulegen.", italian="Eh! Dovremmo aumentare\nil passo allora.", spanish="¡Entonces tendremos que ir más\nrápido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh! We'd better hurry up then.", french="Argh! On ferait mieux de\nse dépêcher alors.", german="Uff! Dann beeilen wir uns\nbesser.", italian="Oh! Dobbiamo cercare di fare\npiù in fretta allora.", spanish="¡Entonces tendremos que ir más\nrápido!"})
  else
  SkySceneKit.say({english=" Ugh! We'd better hurry then.", french="Argh! On ferait mieux de\nse dépêcher alors.", german="Uff! Dann beeilen wir uns\nbesser.", italian="Oh! Dobbiamo cercare di fare\npiù in fretta.", spanish="¡Entonces tendremos que ir más\nrápido!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When you're ready, we have to\ngo back into the forest, [hero].", french="On repart dans la forêt quand\ntu veux, [hero].", german="Wenn du bereit bist, sollten wir\nwieder zurück in den Wald gehen,\n[hero].", italian="Quando siamo pronti, dobbiamo\ntornare nella foresta, [hero].", spanish="Cuando estés a punto, tenemos\nque seguir internándonos en el bosque,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="When you're ready, let's go back\ninto the forest, [hero].", french="On repart dans la forêt quand\ntu veux, [hero].", german="Wenn du bereit bist, dann lass\nuns wieder in den Wald gehen, [hero].", italian="Quando siamo pronti, torniamo\nnella foresta, [hero].", spanish="Cuando estés a punto, tenemos\nque seguir internándonos en el bosque,\n[hero]."})
  else
  SkySceneKit.say({english="When you're ready, let's go back\ninto the forest, [hero].", french="On repart dans la forêt quand\ntu veux, [hero].", german="Wenn du bereit bist, dann lass\nuns wieder in den Wald gehen, [hero].", italian="Quando è tutto pronto, torniamo\nnella foresta, [hero].", spanish="Cuando estés a punto, tenemos\nque seguir internándonos en el bosque,\n[hero]."})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
