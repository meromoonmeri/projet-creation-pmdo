-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/m02a0111.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 112, 176, Direction.Right, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is your room! ♪", french=" Voici votre dortoir! ♪", german=" Das ist euer Raum! ♪", italian=" Questa è la vostra stanza! ♪", spanish=" Este es vuestro cuarto. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 204, 184, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 156, 184, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(2, 10) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  -- message_FacePositionOffset(-2, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wow! We get beds!", french=" Waouh! On a des lits!", german=" Wow! Wir bekommen Betten!", italian=" Wow! Dei letti!", spanish=" ¡Vaya! ¡Nos dan camas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Great! We get beds!", french=" Waouh! On a des lits!", german=" Super! Wir bekommen Betten!", italian=" Wow! Dei letti!", spanish=" ¡Qué bien! ¡Nos dan camas!"})
  else
  SkySceneKit.say({english=" Yay! We get beds!", french=" Waouh! On a des lits!", german=" Hurra! Wir bekommen Betten!", italian=" Wow! Dei letti!", spanish=" ¡Bien! ¡Nos han dado camas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(partner, Direction.UpLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You will live here while you\nwork for us.", french="Tant que vous travaillerez\npour nous, vous vivrez ici.", german="Hier werdet ihr wohnen, solange\nihr für uns arbeitet.", italian="Fino a quando lavorerete per noi,\nquesta sarà la vostra stanza.", spanish="Viviréis aquí mientras trabajéis\npara nosotros."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Things will start getting busy\nfor you tomorrow! ♪[K] So rise early and start\nliving up to our code!", french="Les choses sérieuses\ncommencent demain! ♪[K] Donc levez-vous tôt\net commencez à vivre selon nos codes!", german="Ab morgen werdet ihr alle Hände\nvoll zu tun haben! ♪[K] Steht früh auf und fangt\nan, nach unserem strengen Kodex zu leben!", italian="Da domani non avrete molto\ntempo libero! ♪[K] Quindi alzatevi presto e\niniziate a vivere secondo le nostre regole!", spanish="A partir de mañana empezaréis\na trabajar duro. ♪[K] Así que madrugad,\ny cumplid con nuestro estricto código."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Don't stay up late. Get to sleep\nearly tonight! ♪[K] That is all.", french="Ne veillez pas trop tard. Allez\nvous coucher de bonne heure ce soir! ♪[K]\nVoilà, c'est tout.", german="Bleibt nicht lange auf. Geht\nheute früh ins Bett! ♪[K] Das ist alles.", italian="Non andate a letto tardi.\nStanotte dovete riposarvi il più possibile! ♪[K]\nÈ tutto.", spanish="No trasnochéis. ¡Hoy tenéis que\niros pronto a la cama! ♪[K] Eso es todo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-8), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Left)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-88), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
