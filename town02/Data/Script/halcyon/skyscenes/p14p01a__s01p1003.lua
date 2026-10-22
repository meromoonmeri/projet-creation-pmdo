-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P14P01A/s01p1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P14P01A2) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(5)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It was [CS:N]Wigglytuff[CR] that put this\ntreasure here...)", french="(C'est [CS:N]Grodoudou[CR] qui a posé ce trésor ici...)", german="(Es war [CS:N]Knuddeluff[CR], der diesen Schatz hier\nplatziert hat...)", italian="(È stato [CS:N]Wigglytuff[CR] a mettere qui\nquesto forziere.)", spanish="(Fue [CS:N]Wigglytuff[CR] quien dejó aquí el tesoro...)"})
  else
  SkySceneKit.say({english="(It was [CS:N]Wigglytuff[CR] that put this\ntreasure here...)", french="(C'est [CS:N]Grodoudou[CR] qui a posé ce trésor ici...)", german="(Es war [CS:N]Knuddeluff[CR], der diesen Schatz hier\nplatziert hat...)", italian="(È stato [CS:N]Wigglytuff[CR] a mettere qui\nquesto forziere.)", spanish="(Fue [CS:N]Wigglytuff[CR] quien dejó aquí el tesoro...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That means...[K]inside this treasure box...)", french="(Ça veut dire...[K] qu'à l'intérieur de ce Coffre\nau Trésor...)", german="(Das bedeutet...[K] In dieser Schatzbox...)", italian="(Il che significa...[K] che dentro il forziere...)", spanish="(Lo que significa que...[K] en este cofre...)"})
  else
  SkySceneKit.say({english="(That means...[K]inside this treasure box...)", french="(Ça veut dire...[K] qu'à l'intérieur de ce Coffre\nau Trésor...)", german="(Das bedeutet...[K] In dieser Schatzbox...)", italian="(Il che significa...[K] che dentro il forziere...)", spanish="(Lo que significa que...[K] en este cofre...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][hero] opened\n[CN]the treasure box.", french="[CN][hero] ouvre\n[CN]le Coffre au Trésor.", german="[CN][hero] öffnet\n[CN]die Schatzbox.", italian="[CN][hero] apre\n[CN]il forziere.", spanish="[CN][hero] abrió\n[CN]el cofre del tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6411) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P05A1_106) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6413) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 280, 400, Direction.Right, "NPC_HIMEGUMA")
  -- SetAnimation(5) [anim idle native]
  local npc_npc_ringuma = SkySceneKit.spawn_npc("ursaring", 328, 400, Direction.Left, "NPC_RINGUMA")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_himeguma.Position; GROUND:MoveToPosition(npc_npc_himeguma, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_ringuma.Position; GROUND:MoveToPosition(npc_npc_ringuma, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_himeguma, Direction.DownRight)
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P02A1_128) [routine d'objet NDS non simulée - documenté]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Th-this is...", french=" C-C'est...", german=" D-das ist...", italian=" Qu-Questa è...", spanish=" Esto... Esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" It's a Perfect Apple.", french=" C'est une Pomme Parfaite.", german=" Es ist ein Perfekter Apfel.", italian=" È una Mela Perfetta.", spanish=" Es una Manzana Perfecta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The treasure of [CS:P]Luminous\nSpring[CR]...[K] It was a Perfect Apple.", french="Le trésor de la [CS:P]Source\nLumineuse[CR]...[K] est une Pomme Parfaite.", german="Der Schatz der [CS:P]Glitzerquelle[CR]...[K]\nEin Perfekter Apfel!", italian="Il tesoro della [CS:P]Sorgente\nLuccichio[CR]...[K] è una Mela Perfetta.", spanish="¡Anda! Resulta que el tesoro del\n[CS:P]Manantial Luminoso[CR] es...[K] una Manzana Perfecta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The treasure of [CS:P]Luminous\nSpring[CR]...[K] It was a Perfect Apple.", french="Le trésor de la [CS:P]Source\nLumineuse[CR]...[K] est une Pomme Parfaite.", german="Der Schatz der [CS:P]Glitzerquelle[CR]...[K]\nEin Perfekter Apfel!", italian="Il tesoro della [CS:P]Sorgente\nLuccichio[CR]...[K] è una Mela Perfetta.", spanish="¡Anda! Resulta que el tesoro del\n[CS:P]Manantial Luminoso[CR] es...[K] una Manzana Perfecta."})
  else
  SkySceneKit.say({english="The treasure of [CS:P]Luminous\nSpring[CR]...[K] It was a Perfect Apple.", french="Le trésor de la [CS:P]Source\nLumineuse[CR]...[K] est une Pomme Parfaite.", german="Der Schatz der [CS:P]Glitzerquelle[CR]...[K]\nEin Perfekter Apfel!", italian="Il tesoro della [CS:P]Sorgente\nLuccichio[CR]...[K] è una Mela Perfetta.", spanish="¡Anda! Resulta que el tesoro del\n[CS:P]Manantial Luminoso[CR] es...[K] una Manzana Perfecta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A Perfect Apple as the treasure...[K] It suits\n[CS:N]Wigglytuff[CR], I guess.)", french="(Une Pomme Parfaite comme trésor...[K] c'est\ndu [CS:N]Grodoudou[CR] tout craché.)", german="(Ein Perfekter Apfel als Schatz...[K] Das passt zu\n[CS:N]Knuddeluff[CR], denke ich.)", italian="(Una Mela Perfetta come tesoro...[K] non ci si\npoteva aspettare altro da [CS:N]Wigglytuff[CR].)", spanish="(Una Manzana Perfecta como tesoro...[K] Supongo\nque no podría esperarse otra cosa de\n[CS:N]Wigglytuff[CR].)"})
  else
  SkySceneKit.say({english="(A Perfect Apple as the treasure...[K] It suits\n[CS:N]Wigglytuff[CR], I guess.)", french="(Une Pomme Parfaite comme trésor...[K] c'est\ndu [CS:N]Grodoudou[CR] tout craché.)", german="(Ein Perfekter Apfel als Schatz...[K] Das passt zu\n[CS:N]Knuddeluff[CR], denke ich.)", italian="(Una Mela Perfetta come tesoro...[K] non ci si\npoteva aspettare altro da [CS:N]Wigglytuff[CR].)", spanish="(Una Manzana Perfecta como tesoro...[K] Supongo\nque no podría esperarse otra cosa de\n[CS:N]Wigglytuff[CR].)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wa-waah![K] What was that?!", french=" Ouaaah![K] C'était quoi, ça?!", german=" A-uaah![K] Was war das?!?", italian=" Wa-waah![K] Cosa è stato?!", spanish=" ¡Aaah![K] ¡¿Qué ha sido eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah![K] What was that?!", french=" Ouaaah![K] C'était quoi, ça?!", german=" A-uaah![K] Was war das?!?", italian=" Wa-waah![K] Cosa è stato?!", spanish=" ¡Aaah![K] ¡¿Qué ha sido eso?!"})
  else
  SkySceneKit.say({english=" Wa-waah![K] What was that?!", french=" Ouaaah![K] C'était quoi, ça?!", german=" A-uaah![K] Was war das?!?", italian=" Wa-waah![K] Cosa è stato?!", spanish=" ¡Aaah![K] ¡¿Qué ha sido eso?!"})
  end
  -- ExecuteCommon(CORO_LOOK_AROUND_FAST_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  pcall(function() GAME:MoveCamera(300, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  -- GAP: se_Play(5125) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- back_ChangeGround(LEVEL_P14P01A) [décor déjà chargé par EnterZone PMDO]
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  pcall(function() GAME:MoveCamera(300, 420, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(npc_npc_ringuma, Direction.Up)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's that...?", french=" Qu'est-ce que c'est...?", german=" Was für...", italian=" Che cos'è...?", spanish=" ¿Pero qué...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's that...?", french=" Qu'est-ce que c'est...?", german=" Was für...", italian=" Che cos'è...?", spanish=" ¿Pero qué...?"})
  else
  SkySceneKit.say({english=" What's that...?", french=" Qu'est-ce que c'est...?", german=" Was für...", italian=" Che cos'è...?", spanish=" ¿Pero qué...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Light...[K] Light is shining down!", french="De la lumière...[K] Un puits\nde lumière!", german=" Licht...[K] Es scheint Licht herab!", italian="Luce...[K] La luce sta illuminando\ntutto!", spanish="Luz...[K] ¡Está bajando un rayo de\nluz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Oh, then maybe...!", french=" Oh, alors peut-être...!", german=" Oh, dann vielleicht...", italian=" Oh, allora, forse...!", spanish=" ¡Oh! Entonces quizá..."})
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="Did [CS:P]Luminous Spring[CR] regain\nits power?", french="Est-ce que la [CS:P]Source Lumineuse[CR]\naurait recouvré son pouvoir?", german="Hat die [CS:P]Glitzerquelle[CR] vielleicht\nihre Kraft zurückgewonnen?", italian="Che la [CS:P]Sorgente Luccichio[CR] abbia\nrecuperato il suo potere?", spanish="¿Habrá recuperado su poder\nel [CS:P]Manantial Luminoso[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(300, 260, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_ringuma, 316, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_himeguma, 284, 244, false, 2)
  GROUND:MoveToPosition(partner, 276, 272, false, 2)
  GROUND:MoveToPosition(hero, 324, 272, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="[CN]Those that seek awakening...", french="[CN]Quiconque cherche l'éveil...", german="[CN]Jene, die erwachen wollen...", italian="[CN]Coloro che vogliono rinascere...", spanish="[CN]Aquellos que buscan despertar..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_ringuma, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa! Where's that voice\ncoming from?", french=" Oooh! D'où vient cette voix?", german="Uaah! Wo kommt diese Stimme\nher?", italian="Wow! Da dove viene\nquella voce?", spanish=" ¡Vaya! ¿De dónde viene esa voz?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! Who's saying that?!", french=" Oooh! D'où vient cette voix?", german=" Aaah! Wer hat das gesagt?!?", italian=" Aaah! Chi è che sta parlando?", spanish=" ¿Quéee? ¡¿Quién ha dicho eso?!"})
  else
  SkySceneKit.say({english=" Waah! Who's saying that?!", french=" Oooh! D'où vient cette voix?", german=" Aaah! Wer hat das gesagt?!?", italian=" Aaah! Chi è che sta parlando?", spanish=" ¿Quéee? ¡¿Quién ha dicho eso?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The resumption of time...", french="[CN]Le rétablissement du temps...", german="[CN]Das Fortschreiten der Zeit...", italian="[CN]Il ripristino del tempo...", spanish="[CN]La reanudación del tiempo..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]has brought light here again.", french="[CN]... a ramené la lumière en ce lieu.", german="[CN]Es brachte wieder Licht an diesen Ort.", italian="[CN]... ha riportato la luce qui.", spanish="[CN]ha devuelto la luz a este lugar."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]If you seek evolution, step forward.", french="[CN]Toi qui cherches l'évolution, avance.", german="[CN]So ihr Entwicklung sucht, tretet vor.", italian="[CN]Se è l'evoluzione ciò che agognate,\n[CN]avvicinatevi!", spanish="[CN]Si queréis evolucionar, dad un paso adelante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Lo sapevo!", spanish=" ¡Lo sabía!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_himeguma, npc_npc_ringuma, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_ringuma, npc_npc_himeguma, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english="I knew that [CS:P]Luminous Spring[CR]\nwould be revived!", french="Je savais que la\n[CS:P]Source Lumineuse[CR] pouvait renaître!", german="Ich wusste, dass die\n[CS:P]Glitzerquelle[CR] wieder zum Leben erweckt\nwerden würde!", italian="Sapevo che la [CS:P]Sorgente Luccichio[CR]\navrebbe recuperato il suo potere!", spanish="¡Sabía que el [CS:P]Manantial Luminoso[CR]\nreviviría!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english=" Good for you, [CS:N]Teddiursa[CR]!", french=" Tant mieux pour toi, [CS:N]Teddiursa[CR]!", german=" Schön für dich, [CS:N]Teddiursa[CR]!", italian=" Buon per te, [CS:N]Teddiursa[CR]!", spanish=" ¡Bien por ti, [CS:N]Teddiursa[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_ringuma) end)
  SkySceneKit.say({english="You've been looking forward to\nevolution for a long time!", french="Tu cherches à évoluer depuis si\nlongtemps!", german="Du hast schon sehr lange nach\nEntwicklung gestrebt!", italian="È da molto tempo che desideri\nevolverti!", spanish="¡Hace mucho tiempo que quieres\nevolucionar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_himeguma) end)
  SkySceneKit.say({english=" Yup!", french=" Oui!", german=" Stimmt!", italian=" Già!", spanish=" ¡Sí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Evolution?", french=" Evoluer?", german=" Entwicklung?", italian=" Evolverti?", spanish=" ¿Evolucionar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Evolution?", french=" Evoluer?", german=" Entwicklung?", italian=" Evolverti?", spanish=" ¿Evolucionar?"})
  else
  SkySceneKit.say({english=" Evolution?", french=" Evoluer?", german=" Entwicklung?", italian=" Evolverti?", spanish=" ¿Evolucionar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_ringuma, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_himeguma, Direction.Down)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh![K] That's right, [CS:N]Wigglytuff[CR]\nmentioned it before...", french="Oh![K] C'est vrai, [CS:N]Grodoudou[CR]\nen a parlé...", german="Oh![K] Das stimmt, [CS:N]Knuddeluff[CR]\nhat es mal erwähnt...", italian="Oh![K] È vero, [CS:N]Wigglytuff[CR]\nne ha già parlato...", spanish="¡Oh![K] Es verdad, [CS:N]Wigglytuff[CR]\nya lo había mencionado en una ocasión..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh![K] That's right, [CS:N]Wigglytuff[CR]\nmentioned it before...", french="Oh![K] C'est vrai, [CS:N]Grodoudou[CR]\nen a parlé...", german="Oh![K] Das stimmt, [CS:N]Knuddeluff[CR]\nhat es mal erwähnt...", italian="Oh![K] È vero, [CS:N]Wigglytuff[CR]\nne ha già parlato...", spanish="¡Oh![K] Es verdad, [CS:N]Wigglytuff[CR]\nya lo había mencionado en una ocasión..."})
  else
  SkySceneKit.say({english="Oh![K] That's right, [CS:N]Wigglytuff[CR]\nmentioned it before...", french="Oh![K] C'est vrai, [CS:N]Grodoudou[CR]\nen a parlé...", german="Oh![K] Das stimmt, [CS:N]Knuddeluff[CR]\nhat es mal erwähnt...", italian="Oh![K] È vero, [CS:N]Wigglytuff[CR]\nne ha già parlato...", spanish="¡Oh![K] Es verdad, [CS:N]Wigglytuff[CR]\nya lo había mencionado en una ocasión..."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
