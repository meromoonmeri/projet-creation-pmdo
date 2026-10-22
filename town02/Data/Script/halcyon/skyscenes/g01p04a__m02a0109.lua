-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m02a0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A2) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM02') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 224, Direction.Up, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is the guild's second\nunderground floor.", french="Nous voici au deuxième sous-sol\nde la Guilde.", german="Dies ist die Untere\nGildenebene 2.", italian="Questo è il Piano inferiore della\nGilda 2.", spanish="Esta es la planta -2\ndel [CS:N]Pokégremio[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This is mainly where the\napprentices work.", french="C'est principalement ici que\nnos apprentis travaillent.", german="Hier arbeiten die Lehrlinge die\nmeiste Zeit.", italian="È qui che gli apprendisti\nlavorano, di solito.", spanish="Aquí es donde nuestros\naprendices pasan buena parte de su tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Team registration is this way.\nCome along, please.", french="Pour l'inscription, c'est par là.\nVeuillez me suivre, je vous prie.", german="Zur Anmeldung bitte hier\nentlang. Kommt bitte mit.", italian="Per registrare la squadra\nsi va da questa parte. Seguitemi.", spanish="El registro de equipos\nes por aquí. Seguidme, por favor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(416, 220, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_perappu, 416, 220, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 384, 200, false, 2)
  GROUND:MoveToPosition(partner, 384, 224, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_perappu, 420, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 468, 224, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow! We're two floors under\nthe ground, but you can see outside!", french="Waouh! Alors qu'on est\nau deuxième sous-sol, on voit le ciel dehors!", german="Wow! Wir sind im zweiten\nUntergeschoss, und man kann trotzdem nach\ndraußen sehen!", italian="Wow! Siamo due piani sottoterra\nma si può vedere fuori!", spanish="¡Vaya! ¡Estamos a dos pisos\nbajo tierra, pero se ve el exterior!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! We're two floors under\nthe ground, but you can see outside!", french="Waouh! Alors qu'on est\nau deuxième sous-sol, on voit le ciel dehors!", german="Wow! Wir sind im zweiten\nUntergeschoss, und man kann trotzdem nach\ndraußen sehen!", italian="Wow! Siamo due piani sottoterra\nma si può vedere fuori!", spanish="¡Caramba! ¡Estamos a dos pisos\nbajo tierra, pero se puede ver el exterior!"})
  else
  SkySceneKit.say({english="Wow! We're two floors under\nthe ground, but you can see outside!", french="Waouh! Alors qu'on est\nau deuxième sous-sol, on voit le ciel dehors!", german="Wow! Wir sind im zweiten\nUntergeschoss, und man kann trotzdem nach\ndraußen sehen!", italian="Wow! Siamo due piani sottoterra\nma si può vedere fuori!", spanish="¡Mira! ¡Estamos a dos pisos\nbajo tierra, pero se ve el exterior!"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh, please! Hush now!", french="Oh, dites donc! Un peu\nde silence!", german=" Oh, bitte! Ruhe jetzt!", italian=" Bah! Ma è ovvio, cosa credi?", spanish="¡Por favor! ¡Un poquito\nde silencio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The guild is built into the side\nof a cliff.", french="La Guilde est construite dans\nle roc, au bord de la falaise.", german="Die Gilde ist in die Seite einer\nKlippe gebaut.", italian=" La Gilda è su un promontorio.", spanish="El [CS:N]Pokégremio[CR] se asienta en la\nladera de un acantilado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It's only natural that you would\nbe able to see outside.", french="C'est donc tout à fait normal\nque l'on puisse voir dehors.", german="Selbstverständlich kann man\nnach draußen sehen.", italian="È ovvio che si riesca a guardare\nfuori.", spanish="Es completamente lógico que\nse pueda ver el exterior."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh.", french=" Ah bon.", german=" Oh.", italian=" Oh.", spanish=" Ah."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh.", french=" Ah bon.", german=" Oh.", italian=" Oh.", spanish=" Ah."})
  else
  SkySceneKit.say({english=" Oh.", french=" Ah bon.", german=" Oh.", italian=" Oh.", spanish=" Ah."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(20)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(-16), false, 2) end -- Move2PositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now, here we are at Guildmaster\n[CS:N]Wigglytuff[CR]'s chamber.", french="Voilà, nous sommes arrivés\nà la salle du Maître de la Guilde, [CS:N]Grodoudou[CR].", german="Nun stehen wir vor der Kammer\ndes Gildenmeisters [CS:N]Knuddeluff[CR].", italian="Qui ci sono gli appartamenti del\nCapitano [CS:N]Wigglytuff[CR].", spanish="Ya estamos en la cámara de\nnuestro líder, el Gran Bluff."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="On no account...[K] I repeat, on no\naccount should you be discourteous to our\nGuildmaster.", french="En aucun cas...[K] je dis bien en\naucun cas, vous ne devez manquer de respect\nau Maître de la Guilde.", german="Seid auf keinen Fall,[K] ich\nwiederhole, auf keinen Fall dem Gildenmeister\ngegenüber respektlos.", italian="Per nessun motivo...[K] Ripeto,\nper nessun motivo dovete essere scortesi\nnei confronti del nostro Capitano.", spanish="Bajo ningún concepto...[K]\nRepito, bajo ningún concepto le faltéis\nal respeto al Gran Bluff."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster![K] It's [CS:N]Chatot[CR]! ♪\nI'm coming in!", french="Maître![K] C'est [CS:N]Pijako[CR]! ♪\nJ'entre!", german="Gildenmeister![K] Hier ist\n[CS:N]Plaudagei[CR]! ♪ Ich komme herein!", italian="Capitano![K] Sono [CS:N]Chatot[CR]! ♪\nSto entrando!", spanish="¡Gran Bluff![K] ¡Soy yo, [CS:N]Chatot[CR]! ♪\n¡Voy a entrar!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
