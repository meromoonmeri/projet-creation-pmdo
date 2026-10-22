-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/un0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(42, 4) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [42, 4]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="I've heard that you've been\nplaying with your new friend lately?", french="J'ai entendu dire que tu passes\nbeaucoup de temps avec ton nouvel ami\nen ce moment.", german="Ich habe gehört, dass du neulich\nmit deinem neuen Freund gespielt hast.", italian="Ho saputo che giochi spesso con\nil tuo nuovo amico.", spanish="He oído que últimamente vas mucho\na jugar con tu nuevo amigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep! ♪[K] But now he's not just\na friendly friend... He's Master [CS:N]Armaldo[CR]! ♪", french="Voui! ♪[K] Sauf que ce n'est plus\njuste un copain... C'est Maître [CS:N]Armaldo[CR]! ♪", german="Ja! ♪[K] Aber jetzt ist er nicht\nmehr nur ein lieber Freund... Er ist\nMeister [CS:N]Armaldo[CR]! ♪", italian="Sì! ♪[K] Ma ora non è più solo un\namicissimo... È il maestro [CS:N]Armaldo[CR]! ♪", spanish="¡Sí! ♪[K] Pero ahora ya no es solo\nun nuevo amigo... ¡Es el maestro [CS:N]Armaldo[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Master?[K] When you\nsay master...", french="Maître?[K] Par \"maître\",\ntu veux dire...", german="Meister?[K] Wenn du\nMeister sagst...", italian=" Maestro?[K] Cosa intendi?", spanish=" ¿Cómo?[K] Cuando dices maestro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Oh, I think I get it![K] You mean a\nfriend that you respect a great deal.", french="Oh, je crois que j'y suis![K]\nTu veux dire un ami que tu respectes beaucoup.", german="Oh, ich glaube, ich verstehe es![K]\nDu meinst einen Freund, der dir sehr viel\nbedeutet.", italian="Ah, forse ci sono![K] Intendi un\namico per cui hai un grande rispetto.", spanish="Ah, creo que ya lo entiendo.[K]\nTe refieres a un amigo al que respetas mucho."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="That's great, [CS:Y]Igglybuff[CR].[K]\nThat you've made a friend like that.", french="C'est formidable, [CS:Y]Toudoudou[CR],[K]\nque tu te sois fait un ami comme ça.", german="Es ist schön, [CS:Y]Fluffeluff[CR],[K] dass\ndu einen so guten Freund getroffen hast.", italian="È magnifico che tu ti sia fatto\nun amico così, [CS:Y]Igglybuff[CR].", spanish="Eso está muy bien, [CS:Y]Igglybuff[CR].[K]\nTener amigos así es importante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Voui voui! ♪", german=" Ja! ♪", italian=" Sì! ♪", spanish=" ¡Sí! ♪"})
  -- message_Close
  -- @label_4 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp_side(41, 6) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 6]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Are you headed out with friends\nagain today?", french="Tu sors avec des copains\naujourd'hui encore?", german="Wirst du heute wieder mit\ndeinen Freunden unterwegs sein?", italian="Esci di nuovo con i tuoi amici\noggi?", spanish="¿Hoy también vas a salir\ncon tus amiguitos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep! ♪[K] I made a new\nfriendly friend! ♪", french="Voui! ♪[K] Je me suis fait\nun nouveau copain de moi! ♪", german="Ja! ♪[K] Ich habe einen neuen\nlieben Freund! ♪", italian="Sì! ♪[K] Mi sono fatto un nuovo\namicissimo! ♪", spanish="¡Sí! ♪[K] ¡Tengo uno nuevo,\nlos amigos son lo mejor! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Oh, a new friend!", french=" Oh, un nouveau copain!", german=" Oh, ein neuer Freund!", italian=" Oh, un nuovo amico!", spanish=" ¡Anda, un amiguito nuevo!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" That's great!", french=" C'est merveilleux!", german=" Das ist toll!", italian=" È fantastico!", spanish=" ¡Eso está muy bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Voui voui! ♪", german=" Ja! ♪", italian=" Sì! ♪", spanish=" ¡Pues sí! ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(41, 3) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 3]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="Are you headed out with friends\nagain today?", french="Tu sors avec tes amis\naujourd'hui?", german="Wirst du heute wieder mit\ndeinen Freunden unterwegs sein?", italian="Esci di nuovo con i tuoi amici\noggi?", spanish="¿Hoy también vas a salir con\ntus amiguitos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪", french=" Voui voui! ♪", german=" Ja! ♪", italian=" Sì! ♪", spanish=" ¡Sí! ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp_side(41, 1) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [41, 1]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="[CS:Y]Igglybuff[CR], it's good to see\nyou have so many friends.", french="Je suis content que tu aies tant\nd'amis, [CS:Y]Toudoudou[CR].", german="Es ist schön zu sehen, dass du\nso viele Freunde hast, [CS:Y]Fluffeluff[CR].", italian="[CS:Y]Igglybuff[CR], è bello vedere\nche hai così tanti amici.", spanish="[CS:Y]Igglybuff[CR], me alegra saber que\ntienes tantos amiguitos."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Be nice to your friends, OK?", french="Sois gentil avec tes petits\ncamarades, entendu?", german=" Sei nett zu deinen Freunden, ja?", italian=" Sii gentile con loro, ok?", spanish=" Pórtate bien con tus amigos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep! ♪[K] My friendly\nfriends! ♪", french=" Voui! ♪[K] Les copains de moi! ♪", german=" Ja! ♪[K] Meine lieben Freunde! ♪", italian=" Certo! ♪[K] I miei amicissimi! ♪", spanish="¡Sí, sí! ♪[K] ¡Los amigos\nson lo mejor! ♪"})
  -- message_Close
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
