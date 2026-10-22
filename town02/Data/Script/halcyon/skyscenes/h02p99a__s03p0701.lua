-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manafi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manafi, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_manafi, hero, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Goomi! Goomi!", french=" Jélé! Jélé!", german=" Dummi! Dummi!", italian=" Gooma! Gooma!", spanish=" ¡Gumi! ¡Gumi!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN]Would you like to give a\n[CN][CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR]?", french="[CN]Voulez-vous donner une\n[CN][CS:I]Gelée Bleue[CR] à [CS:N]Manaphy[CR]?", german="[CN]Möchtest du [CS:N]Manaphy[CR]\n[CN]ein [CS:I]Blaugummi[CR] geben?", italian="[CN]Vuoi dare una\n[CN][CS:I]Gommablu[CR] a [CS:N]Manaphy[CR]?", spanish="[CN]¿Quieres darle una [CS:I]Gomi Azul[CR]\n[CN]a [CS:N]Manaphy[CR]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 121, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(308, 204, 1, false) end) -- SetPositionMark performer/caméra
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:TeleportTo(hero, 324, 204, Direction.Down)
  GROUND:TeleportTo(partner, 292, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_manafi, 308, 180, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm_ChangeVolume(0,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN][hero] gave a\n[CN][CS:I]Blue Gummi[CR] to [CS:N]Manaphy[CR].", french="[CN][hero] donne une [CS:I]Gelée Bleue[CR]\n[CN]à [CS:N]Manaphy[CR].", german="[CN][hero] gibt [CS:N]Manaphy[CR]\n[CN]ein [CS:I]Blaugummi[CR].", italian="[CN][hero] dà una\n[CN][CS:I]Gommablu[CR] a [CS:N]Manaphy[CR].", spanish="[CN][hero] le dio una [CS:I]Gomi Azul[CR]\n[CN]a [CS:N]Manaphy[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkyProg.set(29, 46) -- $SCENARIO_MAIN = scn[29,46] (ROM)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Goomi! ♪", french=" Jélé! ♪", german=" Dummi! ♪", italian=" Gooma! ♪", spanish=" ¡Gumi! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Chew, chew...", french=" Miam, miam...", german=" Kau, kau...", italian=" Gnam, gnam...", spanish=" Ñam, ñam..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is it tasty? Er...[K] Goomi tasty?", french="Est-ce que c'est bon? Euh...[K]\nGelée bonne?", german="Na, schmeckt das? Öh...[K]\nLecker Dummi?", italian=" È buona? Ehm...[K] buona gooma?", spanish=" ¿Está buena? Esto...[K] ¿la gumi?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is it tasty? Er...[K] Goomi tasty?", french="Est-ce que c'est bon? Euh...[K]\nGelée bonne?", german="Na, schmeckt das? Öh...[K]\nLecker Dummi?", italian=" È buona? Ehm...[K] buona gooma?", spanish=" ¿Está buena? Esto...[K] ¿la gumi?"})
  else
  SkySceneKit.say({english=" Is it tasty? Er...[K] Goomi tasty?", french="Est-ce que c'est bon? Euh...[K]\nGelée bonne?", german="Na, schmeckt das? Öh...[K]\nLecker Dummi?", italian=" È buona? Ehm...[K] buona gooma?", spanish=" ¿Está buena? Esto...[K] ¿la gumi?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Tasty?", french=" Jélé bonne?", german=" Lecker?", italian=" Buona?", spanish=" ¿Buena?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. Tasty?", french=" Oui. Gelée bonne?", german=" Jep. Lecker?", italian=" Sì. Buona?", spanish=" Sí. ¿Está buena?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's right. Tasty?", french=" Oui. Gelée bonne?", german=" So ist es. Lecker?", italian=" Sì. Buona?", spanish=" Sí. ¿Está buena?"})
  else
  SkySceneKit.say({english=" Yes. Tasty?", french=" Oui. Gelée bonne?", german=" Ja. Lecker?", italian=" Sì. Buona?", spanish=" Sí. ¿Está buena?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Tasty! ♪ Goomi tasty! ♪", french=" Jélé! ♪ Jélé bonne! ♪", german=" Lecker! ♪ Dummi lecker! ♪", italian=" Buona! ♪ Gooma buona! ♪", spanish=" ¡Buena! ♪ ¡Gumi buena! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ha![K] The little guy's going to\ngrow up in no time at this pace!", french="Ha![K] Ce petit va grandir\nen moins de deux à ce rythme!", german="Ha![K] Das kleine Kerlchen wächst\nbei dem Tempo bestimmt in Windeseile auf!", italian="Ah![K] Di questo passo, il piccolo\ncrescerà in un battibaleno!", spanish="¡Ja![K] ¡A este paso va a crecer\nen un periquete!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ha![K] The little guy's going to\ngrow up in no time at this pace!", french="Ha![K] Ce petit va grandir\nen moins de deux à ce rythme!", german="Ha![K] Das kleine Kerlchen wächst\nbei dem Tempo bestimmt in Windeseile auf!", italian="Ah![K] Di questo passo, il piccolo\ncrescerà in un battibaleno!", spanish="¡Ja![K] ¡A este paso va a crecer\nen un periquete!"})
  else
  SkySceneKit.say({english="Ha![K] The little cutie's going to\ngrow up in no time at this rate!", french="Ha![K] Ce petit va grandir\nen moins de deux à ce rythme!", german="Ha![K] Bei diesem Tempo wächst\ndas Kleine bestimmt superschnell heran!", italian="Ah![K] Di questo passo, il piccolo\ncrescerà in un battibaleno!", spanish="¡Ja![K] ¡A este paso esta monada\nva a crecer en un periquete!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Is something the matter?", french=" Hein? Quel est le problème?", german=" Ist irgendetwas?", italian=" Eh? C'è qualcosa che non va?", spanish=" ¿Qué? ¿Pasa algo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? Is something wrong?", french=" Hein? Quel est le problème?", german=" Was? Stimmt etwas nicht?", italian=" Eh? C'è qualcosa che non va?", spanish=" ¿Qué? ¿Pasa algo?"})
  else
  SkySceneKit.say({english=" Oh? Is something the matter?", french=" Hein? Quel est le problème?", german=" Oh? Stimmt etwas nicht?", italian=" Eh? C'è qualcosa che non va?", spanish=" ¿Qué? ¿Pasa algo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" ...Yawn...[K] Snuffle...", french=" ... Waaaaaaaah...[K] Rrrzzz...", german=" ...Gähn...[K] Schnarch...", italian=" Yawn...[K] Snuffle...", spanish=" Uuaa...[K] Bzz..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ha! I guess the little guy got\nfull, and now he's sleepy.", french="Ha! Il doit être repu, et\nmaintenant il s'endort.", german="Ha! Wahrscheinlich hat sich das\nKleine vollgefuttert und wird jetzt müde.", italian="Ah! Il piccolo è sazio e adesso\nha bisogno di dormire.", spanish="¡Ja! Ahora que está lleno le\nha entrado sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ha! The little guy ate his fill.\nNow he needs to sleep it off.", french="Ha! Il doit être repu, et\nmaintenant il s'endort.", german="Ha! Das Kleine hat seine\nFütterung gehabt, jetzt will es schlafen.", italian="Ah! Il piccolo è sazio e adesso\nha bisogno di dormire.", spanish="¡Ja! Ahora que está lleno le\nha entrado sueño."})
  else
  SkySceneKit.say({english="Ha! The little cutie must be\nfull. He's gone to sleep now.", french="Ha! Il doit être repu, et\nmaintenant il s'endort.", german="Ha! Das süße Kerlchen muss\nsatt sein. Es ist eingeschlafen.", italian="Ah! Il piccolo è sazio e adesso\nha bisogno di dormire.", spanish="¡Ja! Ahora que está lleno le\nha entrado sueño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's let him sleep.", french=" Laissons-le dormir.", german=" Lassen wir es schlafen.", italian=" Lasciamolo riposare.", spanish=" Dejémosle dormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's be quiet and let him sleep.", french=" Laissons-le dormir.", german="Seien wir ruhig und lassen es\nschlafen.", italian=" Lasciamolo riposare.", spanish="No hagamos ruido. Dejémosle\nque descanse."})
  else
  SkySceneKit.say({english=" We should let him sleep.", french=" Laissons-le dormir.", german=" Wir sollten es schlafen lassen.", italian=" Lasciamolo riposare.", spanish=" Dejémosle dormir."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manafi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_manafi, 4) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sleep tight, [CS:N]Manaphy[CR].", french=" Dors bien, [CS:N]Manaphy[CR].", german=" Schlaf gut, [CS:N]Manaphy[CR].", italian=" Sogni d'oro, [CS:N]Manaphy[CR].", spanish=" Que duermas bien, [CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sleep tight, [CS:N]Manaphy[CR].", french=" Dors bien, [CS:N]Manaphy[CR].", german=" Schlaf gut, [CS:N]Manaphy[CR].", italian=" Sogni d'oro, [CS:N]Manaphy[CR].", spanish=" Que duermas bien, [CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english=" Sleep tight, [CS:N]Manaphy[CR].", french=" Dors bien, [CS:N]Manaphy[CR].", german=" Schlaf gut, [CS:N]Manaphy[CR].", italian=" Sogni d'oro, [CS:N]Manaphy[CR].", spanish=" Que duermas bien, [CS:N]Manaphy[CR]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_NEXT_DAY, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT2_KIND = 10 -- $ATTENDANT2_KIND = 10 (ROM)
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera2_SetPositionMark(Position<'m4', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() GAME:MoveCamera(288, 220, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 308, 220, Direction.Down)
  GROUND:TeleportTo(partner, 260, 220, Direction.Down)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Hi!", french=" Bonjour!", german=" Hallo!", italian=" Ciao!", spanish=" ¡Hola!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR].", french=" Bonjour, [CS:N]Manaphy[CR].", german=" Guten Morgen, [CS:N]Manaphy[CR].", italian=" Buongiorno, [CS:N]Manaphy[CR].", spanish=" Buenos días, [CS:N]Manaphy[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR].", french=" Bonjour, [CS:N]Manaphy[CR].", german=" Guten Morgen, [CS:N]Manaphy[CR].", italian=" Buongiorno, [CS:N]Manaphy[CR].", spanish=" Buenos días, [CS:N]Manaphy[CR]."})
  else
  SkySceneKit.say({english=" Good morning, [CS:N]Manaphy[CR].", french=" Bonjour, [CS:N]Manaphy[CR].", german=" Guten Morgen, [CS:N]Manaphy[CR].", italian=" Buongiorno, [CS:N]Manaphy[CR].", spanish=" Buenos días, [CS:N]Manaphy[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="Morning! [hero]!\n[partner]!", french="Bonjour! [hero]!\n[partner]!", german="Morgen! [hero]!\n[partner]!", italian="Buongiorno! [hero]!\n[partner]!", spanish="¡Días! ¡[hero]!\n¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa! The little guy called us\nby name!", french=" Oooh! Il connaît nos noms!", german="Nanu! Das kleine Kerlchen hat\nuns mit unseren Namen angeredet!", italian="Wow! Il cucciolo ha detto i\nnostri nomi!", spanish="¡Oye! ¡Nos ha llamado por\nnuestro nombre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! The little guy called us\nby name!", french=" Oooh! Il connaît nos noms!", german="Nanu! Das kleine Kerlchen hat\nuns mit unseren Namen angeredet!", italian="Wow! Il cucciolo ha detto i\nnostri nomi!", spanish="¡Oye! ¡Nos ha llamado por\nnuestro nombre!"})
  else
  SkySceneKit.say({english="Wow! The little cutie greeted us\nby name!", french=" Oooh! Il connaît nos noms!", german="Nanu! Das kleine Kerlchen hat\nuns mit unseren Namen angeredet!", italian="Wow! Il cucciolo ha detto i\nnostri nomi!", spanish="¡Oye! ¡Nos ha llamado por\nnuestro nombre!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's awesome, [CS:N]Manaphy[CR]!", french=" C'est incroyable, [CS:N]Manaphy[CR]!", german=" Das ist toll, [CS:N]Manaphy[CR]!", italian=" Bravissimo, [CS:N]Manaphy[CR]!", spanish=" ¡Bien hecho, [CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's awesome, [CS:N]Manaphy[CR]!", french=" C'est incroyable, [CS:N]Manaphy[CR]!", german=" Das ist toll, [CS:N]Manaphy[CR]!", italian=" Bravissimo, [CS:N]Manaphy[CR]!", spanish=" ¡Bien hecho, [CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" That's awesome, [CS:N]Manaphy[CR]!", french=" C'est incroyable, [CS:N]Manaphy[CR]!", german=" Das ist toll, [CS:N]Manaphy[CR]!", italian=" Bravissimo, [CS:N]Manaphy[CR]!", spanish=" ¡Bien hecho, [CS:N]Manaphy[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Awesome!", french=" Incroyaaable!", german=" Toll!", italian=" Bravissimo!", spanish=" ¡Bien!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, [hero].[K] What should\nwe do with him today?", french="Alors, [hero].[K]\nQu'allons-nous faire de lui aujourd'hui?", german="Nun, [hero].[K] Was sollen\nwir heute mit ihm unternehmen?", italian="Beh, [hero].[K] Cosa\nfacciamo fare a Manaphy oggi?", spanish="Bueno, [hero].[K]\n¿Qué vamos a hacer hoy con él?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, [hero].[K] What should\nwe do with him today?", french="Alors, [hero].[K]\nQu'allons-nous faire de lui aujourd'hui?", german="Nun, [hero].[K] Was sollen\nwir heute mit ihm unternehmen?", italian="Beh, [hero].[K] Cosa\nfacciamo fare a Manaphy oggi?", spanish="Bueno, [hero].[K]\n¿Qué vamos a hacer hoy con él?"})
  else
  SkySceneKit.say({english="Well, [hero].[K] What should\nwe do with him today?", french="Alors, [hero].[K]\nQu'allons-nous faire de lui aujourd'hui?", german="Nun, [hero].[K] Was sollen\nwir heute mit ihm unternehmen?", italian="Beh, [hero].[K] Cosa\nfacciamo fare a Manaphy oggi?", spanish="Bueno, [hero].[K]\n¿Qué vamos a hacer hoy con él?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Eating and sleeping all the time\ndoesn't seem healthy enough...", french="Manger et dormir tout le temps,\nce n'est pas très sain...", german="Nur essen und schlafen kann\nauf Dauer nicht gesund sein...", italian="Mangiare e dormire tutto il\ngiorno non dev'essere troppo salutare...", spanish="Tanto comer y dormir no puede\nser bueno..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Eating and sleeping all the time\ndoesn't seem healthy enough...", french="Manger et dormir tout le temps,\nce n'est pas très sain...", german="Nur essen und schlafen kann\nauf Dauer nicht gesund sein...", italian="Mangiare e dormire tutto il\ngiorno non dev'essere troppo salutare...", spanish="Tanto comer y dormir no puede\nser bueno..."})
  else
  SkySceneKit.say({english="Eating and sleeping all the time\ndoesn't seem healthy enough...", french="Manger et dormir tout le temps,\nce n'est pas très sain...", german="Nur essen und schlafen kann\nauf Dauer nicht gesund sein...", italian="Mangiare e dormire tutto il\ngiorno non dev'essere troppo salutare...", spanish="Tanto comer y dormir no puede\nser bueno..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I know![K] Let's take the little guy\nfor a walk at the beach!", french="Je sais![K] Emmenons-le se\npromener à la plage!", german="Ich weiß![K] Wir gehen mit dem\nKleinen am Strand spazieren!", italian="Ci sono![K] Portiamo il cucciolo a\nfare una passeggiata sulla spiaggia!", spanish="¡Ya sé![K] ¡Llevemos al pequeño a\ndar un paseo por la playa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I know![K] Let's take the little guy\nfor a walk at the beach!", french="Je sais![K] Emmenons-le se\npromener à la plage!", german="Ich weiß![K] Wir gehen mit dem\nKleinen am Strand spazieren!", italian="Ci sono![K] Portiamo il cucciolo a\nfare una passeggiata sulla spiaggia!", spanish="¡Ya sé![K] ¡Llevemos al pequeño a\ndar un paseo por la playa!"})
  else
  SkySceneKit.say({english="I know![K] Let's take the little cutie\nfor a walk at the beach!", french="Je sais![K] Emmenons-le se\npromener à la plage!", german="Ich weiß![K] Wir gehen mit dem\nKleinen am Strand spazieren!", italian="Ci sono![K] Portiamo il cucciolo a\nfare una passeggiata sulla spiaggia!", spanish="¡Ya sé![K] ¡Llevemos al pequeño a\ndar un paseo por la playa!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Walk! ♪", french=" Promener! ♪", german=" Spazieren! ♪", italian=" Passeggiata! ♪", spanish=" ¡Paseo! ♪"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  elseif true then -- default
  -- @label_3 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN][hero] doesn't have a [CS:I]Blue Gummi[CR]...", french="[CN][hero] n'a pas de [CS:I]Gelée Bleue[CR]...", german="[CN][hero] hat kein [CS:I]Blaugummi[CR]...", italian="[CN][hero] non ha una [CS:I]Gommablu[CR]...", spanish="[CN][hero] no tiene ninguna [CS:I]Gomi Azul[CR]..."})
  -- message_Close
  end
  end
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Weh...[K] Weh...[K] Waaaah!", french=" Ouin...[K] Ouin...[K] Ouiiiiiiin!", german=" Uäh...[K] Uäh...[K] Buuuuhuhu!", italian=" Weh...[K] Weh...[K] Waaaah!", spanish=" Snif...[K] snif...[K] ¡Buaaaa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa, whoa... Please don't cry!", french=" Oh non... Ne pleure pas!", german=" Oooh, uaah... Bitte nicht weinen!", italian="Ehi, ehi... Per favore,\nnon piangere!", spanish=" Oye, oye... ¡no llores!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh no... Please don't cry!", french=" Oh non... Ne pleure pas!", german=" Oh nein! Bitte nicht weinen!", italian="Oh, no... Per favore,\nnon piangere!", spanish=" Anda, anda... ¡no llores!"})
  else
  SkySceneKit.say({english=" Oh, no no... Please don't cry!", french=" Oh non... Ne pleure pas!", german="Oh nein! Nein! Bitte nicht\nweinen!", italian="Oh, no... Per favore,\nnon piangere!", spanish=" No, por favor... ¡no llores!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't worry, little guy.[K] We'll be\nback soon with a tasty [CS:I]Blue Gummi[CR] for you.", french="Ne t'inquiète pas.[K] Nous serons de\nretour bientôt avec une bonne [CS:I]Gelée Bleue[CR].", german="Keine Sorge, kleines Kerlchen.[K]\nWir sind bald zurück mit einem leckeren\n[CS:I]Blaugummi[CR] für dich.", italian="Non preoccuparti, piccolo.[K]\nTorneremo presto con una gustosa [CS:I]Gommablu[CR]\ntutta per te.", spanish="No te preocupes, pequeño.[K]\nPronto estaremos de vuelta con una sabrosa\n[CS:I]Gomi Azul[CR] para ti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't you cry, little guy.[K] We'll be\nback soon with a tasty [CS:I]Blue Gummi[CR] for you.", french="Ne t'inquiète pas.[K] Nous serons de\nretour bientôt avec une bonne [CS:I]Gelée Bleue[CR].", german="Nicht weinen, süßes Kerlchen.[K]\nWir sind bald zurück mit einem leckeren\n[CS:I]Blaugummi[CR] für dich.", italian="Non preoccuparti, piccolo.[K]\nTorneremo presto con una gustosa [CS:I]Gommablu[CR]\ntutta per te.", spanish="No te preocupes, pequeño.[K]\nPronto estaremos de vuelta con una sabrosa\n[CS:I]Gomi Azul[CR] para ti."})
  else
  SkySceneKit.say({english="Don't you cry, cutie.[K] We'll be\nback soon with a tasty [CS:I]Blue Gummi[CR] for you.", french="Ne t'inquiète pas.[K] Nous serons de\nretour bientôt avec une bonne [CS:I]Gelée Bleue[CR].", german="Nicht weinen, du süßer Fratz.[K]\nWir sind bald zurück mit einem leckeren\n[CS:I]Blaugummi[CR] für dich.", italian="Non preoccuparti, piccolo.[K]\nTorneremo presto con una gustosa [CS:I]Gommablu[CR]\ntutta per te.", spanish="No te preocupes, pequeño.[K]\nPronto estaremos de vuelta con una sabrosa\n[CS:I]Gomi Azul[CR] para ti."})
  end
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  end
  end
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
