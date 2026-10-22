-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s31a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  SkyProg.set(29, 8) -- $SCENARIO_MAIN = scn[29,8] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 76, 204, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(hero, 44, 180, false, 2)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, there's someone at the\ncafé entrance.", french="Hé, il y a quelqu'un à l'entrée\ndu café.", german="Sieh mal, da ist jemand am\nEingang des Cafés.", italian="Ehi, c'è qualcuno all'entrata\ndel caffè.", spanish="Mira, hay alguien en la entrada\nde la cafetería."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? There's someone at the\ncafé entrance.", french="Hé, il y a quelqu'un à l'entrée\ndu café.", german="Huch! Da ist jemand am\nEingang des Cafés.", italian="Eh? C'è qualcuno all'entrata\ndel caffè.", spanish="Anda, pero si hay alguien en\nla entrada de la cafetería."})
  else
  SkySceneKit.say({english="Oh? There's someone at the\ncafé entrance.", french="Hé, il y a quelqu'un à l'entrée\ndu café.", german="Oh? Da ist jemand am Eingang\ndes Cafés.", italian="Oh? C'è qualcuno all'entrata\ndel caffè.", spanish="Huy, hay alguien en la entrada\nde la cafetería."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 224, 204, false, 2)
  GAME:WaitFrames(25)
  GROUND:MoveToPosition(hero, 188, 196, false, 2)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(192, 220, 60, false) end) -- performer/caméra
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder what's up.", french=" Je me demande ce qui se passe.", german=" Ich frage mich, was los ist.", italian=" Chissà cosa bolle in pentola...", spanish=" ¿Qué estará pasando ahí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I wonder what's going on.", french=" Je me demande ce qui se passe.", german=" Was wohl los ist?", italian=" Mi chiedo cosa stia succedendo...", spanish=" ¿Qué pasará?"})
  else
  SkySceneKit.say({english=" I wonder what's going on.", french=" Je me demande ce qui se passe.", german=" Was wohl los ist?", italian=" Cosa starà succedendo?", spanish=" ¿Qué sucederá?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bariyaado = SkySceneKit.spawn_npc("mr_mime", 216, 256, Direction.UpLeft, "NPC_BARIYAADO")
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Up)
  GAME:WaitFrames(7)
  local npc_npc_okutan = SkySceneKit.spawn_npc("octillery", 176, 248, Direction.Up, "NPC_OKUTAN")
  GROUND:EntTurn(npc_npc_okutan, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english="It seems like there's some\nhappy news for all the explorers.", french="Il paraît qu'il y a une excellente\nnouvelle pour tous les explorateurs.", german="Juchhu. Anscheinend gibt es tolle\nNeuigkeiten für alle Erkunder.", italian="Pare che ci siano buone\nnotizie per tutti gli esploratori.", spanish="Pues por lo visto hay\nbuenas noticias para todos los exploradores."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="I wonder what kind of\nhappy news.", french="Je me demande quel genre\nd'excellente nouvelle.", german="Was denn für wundervolle\nNeuigkeiten?", italian=" Che cosa sarà?", spanish="Me gustaría saber cuáles son\nesas noticias."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_okutan, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(7)
  GROUND:EntTurn(npc_npc_bariyaado, Direction.Left)
  pcall(function() UI:SetSpeaker(npc_npc_okutan) end)
  SkySceneKit.say({english="Now I'm really interested.[K]\nI'm going to go find out.", french="Je serais bien curieuse de voir\nde quoi il s'agit. [K]J'y vais.", german="Jetzt bin ich wirklich neugierig.[K]\nIch werde es herausfinden.", italian="Questa cosa mi ha proprio\nincuriosita.[K] Vado a scoprire di che si tratta.", spanish="Ahora me pica la curiosidad.[K] Voy\na investigar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_okutan, 144, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_bariyaado) end)
  SkySceneKit.say({english=" I'm going too.", french=" J'y vais, moi aussi.", german=" Warte! Ich komme mit.", italian=" Vengo anch'io.", spanish=" Yo también me apunto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bariyaado, 144, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? Somehow this all seems\nfamiliar, like we've done this before...", french="Hein? J'ai une impression de\ndéjà-vu... comme si ça s'était déjà produit...", german="Hmmm, das kommt mir bekannt\nvor. Als ob wir das schon einmal erlebt\nhätten...", italian="Uh? Mi sembra tutto così\nfamiliare, come se fosse già accaduto\nprima...", spanish="Hum... Todo esto me suena,\ncomo si ya lo hubiéramos vivido..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? Somehow this all seems\nfamiliar, like we've done this before...", french="Hein? J'ai une impression de\ndéjà-vu... comme si ça s'était déjà produit...", german="Hmmm, das kommt mir bekannt\nvor. Als ob wir das schon einmal erlebt\nhätten...", italian="Uh? Mi sembra tutto così\nfamiliare, come se fosse già accaduto\nprima...", spanish="Hum... Todo esto me resulta\nfamiliar, como si ya lo hubiéramos vivido..."})
  else
  SkySceneKit.say({english="Huh? Somehow this all seems\nfamiliar, like we've done this before...", french="Hein? J'ai une impression de\ndéjà-vu... comme si ça s'était déjà produit...", german="Hmmm, das kommt mir bekannt\nvor. Als ob wir das schon einmal erlebt\nhätten...", italian="Uh? Mi sembra tutto così\nfamiliare, come se fosse già accaduto\nprima...", spanish="Hum... Todo esto me resulta\nfamiliar, como si ya lo hubiéramos hecho..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I wonder what's up this time.", french="Je me demande ce qui se passe,\ncette fois.", german=" Was wohl dieses Mal los ist?", italian="Chissà cosa succede\nquesta volta...", spanish=" ¿Qué pasará esta vez?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder what's going on\nthis time.", french="Je me demande ce qui se passe,\ncette fois.", german="Ich frage mich, was es wohl\ndieses Mal ist...", italian="Cosa starà succedendo\nquesta volta?", spanish=" ¿Qué ocurrirá esta vez?"})
  else
  SkySceneKit.say({english="I wonder what's going on\nthis time.", french="Je me demande ce qui se passe,\ncette fois.", german="Ich frage mich, was es wohl\ndieses Mal ist...", italian="Cosa starà succedendo\nquesta volta?", spanish="Me pregunto qué pasará\nesta vez."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]. Let's go too.", french="Hé, [hero]. Et si on allait\nvoir, nous aussi?", german="Hey, [hero].\nLass uns auch nachsehen.", italian="Ehi, [hero]. Andiamo\nanche noi!", spanish="Oye, [hero]...\nVamos también a ver qué pasa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero], we should\ngo too.", french="Hé, [hero]. Et si on allait\nvoir, nous aussi?", german="Hey, [hero].\nWir sollten auch nachsehen.", italian="Ehi [hero], dovremmo\nandare anche noi.", spanish="Oye, [hero], deberíamos\nir con ellos."})
  else
  SkySceneKit.say({english="Hey, [hero], I think we\nshould go and see too.", french="Hé, [hero]. Et si on allait\nvoir, nous aussi?", german="Hey, [hero].\nLass uns ihnen folgen und auch nachsehen.", italian="Ehi [hero], penso che\ndovremmo andare a controllare anche noi.", spanish="Escucha, [hero], creo que\ndeberíamos ir con ellos a ver qué pasa."})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 144, 236, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 144, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
