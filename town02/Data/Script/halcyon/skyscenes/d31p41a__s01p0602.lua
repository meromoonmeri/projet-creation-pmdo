-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P41A/s01p0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    GROUND:EntTurn(hero, Direction.Up)
    -- SetAnimation(72) [anim idle native]
    -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 292, 220, false, 2) -- SlidePositionMark (glissement)
    -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- GAP: se_Play(7939) — id SE NDS sans portage PMDO identifié
    -- SetAnimation(11) [anim idle native]
    -- SlideHeight(2, 12) [neutre/état moteur]
    GAME:WaitFrames(2)
    -- SlideHeight(2, 0) [neutre/état moteur]
    GROUND:EntTurn(hero, Direction.Right)
    -- SetAnimation(68) [anim idle native]
    GAME:WaitFrames(60)
    SkySceneKit.lock(6) -- Lock(6) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(7) -- Lock(7) NDS
    GROUND:EntTurn(hero, Direction.UpRight)
    GAME:WaitFrames(20)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(8) -- Lock(8) NDS
    GAME:WaitFrames(1) -- hold
  end)
  SkySceneKit.run_routine(function() -- def 2 for actor ACTOR_ATTENDANT1
    GROUND:EntTurn(partner, Direction.Up)
    -- SetAnimation(72) [anim idle native]
    -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    SkySceneKit.lock(9) -- Lock(9) NDS
    GROUND:MoveToPosition(partner, 260, 220, false, 2) -- SlidePositionMark (glissement)
    -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- SetAnimation(11) [anim idle native]
    -- SlideHeight(2, 12) [neutre/état moteur]
    GAME:WaitFrames(2)
    -- SlideHeight(2, 0) [neutre/état moteur]
    GROUND:EntTurn(partner, Direction.Left)
    -- SetAnimation(68) [anim idle native]
    GAME:WaitFrames(45)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(11) -- Lock(11) NDS
    GROUND:EntTurn(partner, Direction.DownLeft)
    GAME:WaitFrames(12)
    -- CallCommon CORO_LOOK_AROUND_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(12) -- Lock(12) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D31P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7170) — id SE NDS sans portage PMDO identifié
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Owowow...", french=" Ouh là là...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Owowow...", french=" Ouh là là...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  else
  SkySceneKit.say({english=" Owowow...", french=" Ouh là là...", german=" Oh, oh, oh...", italian=" Ahiahiahi...", spanish=" Ay, ay, ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-this is...", french=" C-c'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-this is...", french=" C-c'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto es..."})
  else
  SkySceneKit.say({english=" Th-this is...", french=" C-c'est...", german=" D-das ist...", italian=" Q-Questa è...", spanish=" Esto es..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Was that...[K]a pitfall trap?)", french="(Qu'est-ce que c'était...[K] un Piège Trappe?)", german="(War das...[K] eine Gruben-Falle?)", italian="(Era una...[K] trappola?)", spanish="(Hum...[K] ¿Hemos caído en una trampa?)"})
  else
  SkySceneKit.say({english="(Was that...[K]a pitfall trap?)", french="(Qu'est-ce que c'était...[K] un Piège Trappe?)", german="(War das...[K] eine Gruben-Falle?)", italian="(Era una...[K] trappola?)", spanish="(Hum...[K] ¿Hemos caído en una trampa?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(We fell down a pitfall trap![K] That's what\nhappened to us...)", french="(Nous venons de tomber dans un Piège Trappe!\nVoilà ce qui nous est arrivé...)", german="(Wir sind in eine Gruben-Falle geraten![K] Das ist\nalso passiert...)", italian="(Abbiamo camminato su una trappola![K] Ecco\ncosa ci è successo...)", spanish="(¡Hemos caído en una trampa![K]\nDebe de ser eso...)"})
  else
  SkySceneKit.say({english="(We fell down a pitfall trap![K] That's what\nhappened to us...)", french="(Nous venons de tomber dans un Piège Trappe!\nVoilà ce qui nous est arrivé...)", german="(Wir sind in eine Gruben-Falle geraten![K] Das ist\nalso passiert...)", italian="(Abbiamo camminato su una trappola![K] Ecco\ncosa ci è successo...)", spanish="(¡Hemos caído en una trampa![K]\nDebe de ser eso...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7940) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:FadeOut(false, 120)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Arrgh![K] The hole!", french=" Aaah![K] Le trou!", german=" Arrgh![K] Das Loch!", italian=" Arrgh![K] Il buco!", spanish=" ¡Oh, no![K] ¡El agujero!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Arrgh![K] The hole!", french=" Aaah![K] Le trou!", german=" Arrgh![K] Das Loch!", italian=" Arrgh![K] Il buco!", spanish=" ¡Oh, no![K] ¡El agujero!"})
  else
  SkySceneKit.say({english=" Oh no![K] The hole!", french=" Aaah![K] Le trou!", german=" Oh nein![K] Das Loch!", italian=" Oh, no![K] Il buco!", spanish=" ¡Oh, no![K] ¡El agujero!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The hole's closing up!", french=" Il se referme!", german=" Das Loch schließt sich!", italian=" Il buco si sta chiudendo!", spanish=" ¡Se está cerrando!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The hole's closing up!", french=" Il se referme!", german=" Das Loch schließt sich!", italian=" Il buco si sta chiudendo!", spanish=" ¡Se está cerrando!"})
  else
  SkySceneKit.say({english=" The hole's closing up!", french=" Il se referme!", german=" Das Loch schließt sich!", italian=" Il buco si sta chiudendo!", spanish=" ¡Se está cerrando!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7940, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitScreenFade
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7941) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Whoa![K] It's pitch black in here!\nI can't see a thing!", french="Ouaaah![K] Il fait tout noir\nlà-dedans! On ne voit plus rien du tout!", german="Uaah![K] Hier herrscht\nrabenschwarze Dunkelheit! Ich sehe nichts!", italian="Gulp![K] Qui dentro è buio pesto!\nNon vedo niente!", spanish="¡Vaya![K] ¡Estamos a oscuras!\n¡No veo nada!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Waah![K] It's pitch black! I can't\nsee a thing!", french="Ouaaah![K] Il fait tout noir\nlà-dedans! On ne voit plus rien du tout!", german="Uaah![K] Hier herrscht\nrabenschwarze Dunkelheit! Ich sehe nichts!", italian="Aaah![K] Qui dentro è buio pesto!\nNon vedo niente!", spanish="¡Vaya![K] ¡Estamos a oscuras!\n¡No veo nada!"})
  else
  SkySceneKit.say({english="Waah![K] It's pitch black! I can't\nsee a thing!", french="Ouaaah![K] Il fait tout noir\nlà-dedans! On ne voit plus rien du tout!", german="Uaah![K] Hier herrscht\nrabenschwarze Dunkelheit! Ich sehe nichts!", italian="Aaah![K] Qui dentro è buio pesto!\nNon vedo niente!", spanish="¡Vaya![K] ¡Estamos a oscuras!\n¡No veo nada!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are we trapped?!", french=" C'est un piège?!", german=" Sind wir gefangen?!?", italian=" Siamo in trappola?!", spanish=" ¿Estamos atrapados?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are we trapped?!", french=" C'est un piège?!", german=" Sind wir gefangen?!?", italian=" Siamo in trappola?!", spanish=" ¿Estamos atrapados?"})
  else
  SkySceneKit.say({english=" Are we trapped?!", french=" C'est un piège?!", german=" Sind wir gefangen?!?", italian=" Siamo in trappola?!", spanish=" ¿Nos han atrapado aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Muah-hahahaha!", french=" Mouah ha ha ha ha!", german=" Mua-hahahaha!", italian=" Uah-ahahahah!", spanish=" ¡Jia, jia, jia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What...?[K] Someone's here!)", french="(Quoi...?[K] Il y a quelqu'un!)", german="(Was...[K] Hier ist jemand!)", italian="(Cosa...?[K] C'è qualcuno qui dentro!)", spanish="(¿Qué...?[K] ¡Hay alguien ahí!)"})
  else
  SkySceneKit.say({english="(What...?[K] Someone's here!)", french="(Quoi...?[K] Il y a quelqu'un!)", german="(Was...[K] Hier ist jemand!)", italian="(Cosa...?[K] C'è qualcuno qui dentro!)", spanish="(¿Qué...?[K] ¡Hay alguien ahí!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who is it?[K] Who are you?!", french=" Qui est là? [K]Qui êtes-vous?!", german=" Wer ist da?[K] Wer bist du?!?", italian=" Chi c'è qui?[K] Chi sei?!", spanish=" ¿Quién está ahí?[K] ¡¿Quién eres?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who is it?[K] Who are you?!", french=" Qui est là? [K]Qui êtes-vous?!", german=" Wer ist da?[K] Wer bist du?!?", italian=" Chi c'è qui?[K] Chi sei?!", spanish=" ¿Quién está ahí?[K] ¡¿Quién eres?!"})
  else
  SkySceneKit.say({english=" Who's there?[K] Who are you?!", french=" Qui est là? [K]Qui êtes-vous?!", german=" Wer ist da?[K] Wer bist du?!?", italian=" Chi c'è qui?[K] Chi sei?!", spanish="¿Quién está ahí?[K] ¡¿Quién eres\ntú?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Welcome...[K]to the world of darkness.", french="Je vous souhaite la bienvenue...[K] dans\nle monde de l'ombre.", german=" Willkommen...[K] in der Welt der Dunkelheit.", italian=" I miei saluti...[K] dal mondo dell'oscurità.", spanish="Os doy la bienvenida...[K] al mundo de la\noscuridad."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I am the grand master of all things bad.", french=" Je suis le grand maître de tous les maux.", german=" Ich bin der Großmeister allen Übels.", italian=" Sono Sua Malvagità.", spanish=" Soy el gran malo requetemalo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéeee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéeee?!"})
  else
  SkySceneKit.say({english=" Whaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéeee?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The G-g-g-[K]grand master of\nall things bad?!", french="Le g-g-g-[K]grand maître de\ntous les maux?!", german="Der G-g-g-[K]großmeister allen\nÜbels?!?", italian=" S-S-Sua[K] Malvagità?!", spanish="El gran...[K] ¡¿El gran malo\nrequetemalo?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The G-g-g-[K]grand master of\nall things bad?!", french="Le g-g-g-[K]grand maître de\ntous les maux?!", german="Der G-g-g-[K]großmeister allen\nÜbels?!?", italian=" S-S-Sua[K] Malvagità?!", spanish="El gran...[K] ¡¿El gran malo\nrequetemalo?!"})
  else
  SkySceneKit.say({english="The G-g-g-[K]grand master of\nall things bad?!", french="Le g-g-g-[K]grand maître de\ntous les maux?!", german="Der G-g-g-[K]großmeister allen\nÜbels?!?", italian=" S-S-Sua[K] Malvagità?!", spanish="El gran...[K] ¡¿El gran malo\nrequetemalo?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Humph![K] Not only the grand master, but\nmore of us besides! ♪", french="Hum, hum![K] Le grand maître n'est pas tout\nseul, il y a ses sbires aussi! ♪", german="Hmpf![K] Nicht nur der Großmeister, sondern\naußerdem noch mehr von uns! ♪", italian="Humph![K] Non solo Sua Malvagità! Siamo\nmolti di più! ♪", spanish="¡Ajá![K] ¡Y no solo el gran malo, hay muchos\nmás! ♪"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="A BUNCH of us minions of the grand\nmaster are here!", french="Les ARMEES de serviteurs du grand maître\nsont là!", german="Ein ganzer HAUFEN von Untergebenen des\nGroßmeisters ist hier!", italian="Siamo un ESERCITO di sgherri di Sua\nMalvagità!", spanish="¡Sí, también estamos unos cuantos\nsecuaces del gran malo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: You can't see us in the dark...[K]but you're\ncompletely surrounded!", french="[CS:N]Sbire[CR]: Vous ne pouvez pas nous voir dans\nl'obscurité...[K] mais nous vous encerclons\ncomplètement!", german="[CS:N]Untergebener[CR]: Ihr könnt uns in der Dunkelheit\nnicht sehen,[K] aber ihr seid vollständig\numzingelt!", italian="[CS:N]Sgherro[CR]: Non potete vederci al buio...[K]\nma siamo tutti intorno a voi!", spanish="[CS:N]Secuaz[CR]: No podéis vernos...[K] ¡pero os hemos\nrodeado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Muah-hahahaha![K]\nMuah-hahahaha-hahahaha!", french="[CS:N]Grand maître[CR]: Mouah ha ha ha ha![K]\nMouah ha ha ha ha ha ha ha ha!", german="[CS:N]Großmeister[CR]: Mua-hahahaha![K]\nMua-hahahaha-hahahaha!", italian="[CS:N]Sua Malvagità[CR]: Uah-ahahahah![K]\nUah-ahahahah-ahahahah!", spanish="[CS:N]Gran malo[CR]: ¡Jia, jia, jia![K]\n¡Jia, jia, jia!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Coming to our lair is the last\nmistake you will ever make.[K] You're not\nwalking out of here.", french="[CS:N]Grand maître[CR]: Pénétrer dans notre repaire\nsera votre dernière erreur.[K] Vous ne quitterez\njamais ces lieux.", german="[CS:N]Großmeister[CR]: In unsere Höhle zu kommen, war\neuer letzter Fehler.[K] Hier kommt ihr nicht\nmehr heraus.", italian="[CS:N]Sua Malvagità[CR]: Venire qui è stato il vostro\nultimo errore.[K] Non uscirete mai di qui.", spanish="[CS:N]Gran malo[CR]: Venir a nuestra guarida ha sido un\ncraso error.[K] No saldréis de aquí."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Prepare to...", french="[CS:N]Grand maître[CR]: Préparez-vous à...", german="[CS:N]Großmeister[CR]: Bereitet\neuch vor, zu...", italian="[CS:N]Sua Malvagità[CR]: Preparatevi a...", spanish="[CS:N]Gran malo[CR]: Preparaos para..."})
  -- message_Close
  -- supervision_Acting(1) [neutre/état moteur]
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7940) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(45)
  -- se_FadeOut(7940, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeIn(60)
  -- camera_SetEffect(0): arrêt d'effet caméra
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Grand Master[CR]: Uh...", french="[CS:N]Grand maître[CR]: Hein...", german="[CS:N]Großmeister[CR]: Uh...", italian="[CS:N]Sua Malvagità[CR]: Eh...", spanish="[CS:N]Gran malo[CR]: Eh..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] [CS:N]Wigglytuff[CR]?!", french=" Quoi?![K] [CS:N]Grodoudou[CR]?!", german=" Hä?!?[K] [CS:N]Knuddeluff[CR]?!?", italian=" Eh?![K] [CS:N]Wigglytuff[CR]?!", spanish=" ¡¿Eh?![K] ¡¿[CS:N]Wigglytuff[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?![K] [CS:N]Wigglytuff[CR]?!", french=" Quoi?![K] [CS:N]Grodoudou[CR]?!", german=" Was?!?[K] [CS:N]Knuddeluff[CR]?!?", italian=" Eh?![K] [CS:N]Wigglytuff[CR]?!", spanish=" ¡¿Qué?![K] ¡¿[CS:N]Wigglytuff[CR]?!"})
  else
  SkySceneKit.say({english=" What?![K] [CS:N]Wigglytuff[CR]?!", french=" Quoi?![K] [CS:N]Grodoudou[CR]?!", german=" Was?!?[K] [CS:N]Knuddeluff[CR]?!?", italian=" Eh?![K] [CS:N]Wigglytuff[CR]?!", spanish=" ¡¿Qué?![K] ¡¿[CS:N]Wigglytuff[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And everyone else?!", french=" Et tous les autres aussi?!", german=" Und alle anderen?!?", italian=" E tutti gli altri?!", spanish=" ¡Y todos los demás!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And everyone else?!", french=" Et tous les autres aussi?!", german=" Und alle anderen?!?", italian=" E tutti gli altri?!", spanish=" ¿Y todos los demás?"})
  else
  SkySceneKit.say({english=" And everyone else?!", french=" Et tous les autres aussi?!", german=" Und alle anderen?!?", italian=" E tutti gli altri?!", spanish=" ¿Y todos los demás?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's going on here?!", french=" Mais qu'est-ce qui se passe ici?!", german=" Was geht hier vor sich?!?", italian=" Cosa sta succedendo qui?!", spanish=" ¡¿Qué está pasando aquí?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's going on here?!", french=" Mais qu'est-ce qui se passe ici?!", german=" Was geht hier vor sich?!?", italian=" Cosa sta succedendo qui?!", spanish=" ¡¿Qué está pasando aquí?!"})
  else
  SkySceneKit.say({english=" What's going on here?!", french=" Mais qu'est-ce qui se passe ici?!", german=" Was geht hier vor sich?!?", italian=" Cosa sta succedendo qui?!", spanish=" ¡¿Qué está pasando aquí?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 280, 176, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 224, 208, Direction.DownRight, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 320, 240, Direction.UpLeft, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 256, 256, Direction.Up, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "sweating", 1) end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 312, 184, Direction.DownLeft, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.UpRight)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:ResetSpeaker() end)
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: H-hey![K] [CS:N]Bidoof[CR]!", french="[CS:N]Sbire[CR]: H-hé![K] [CS:N]Keunotor[CR]!", german="[CS:N]Untergebener[CR]: H-hey![K] [CS:N]Bidiza[CR]!", italian="[CS:N]Sgherro[CR]: E-Ehi![K] [CS:N]Bidoof[CR]!", spanish="[CS:N]Secuaz[CR]: ¡Eh![K] ¡[CS:N]Bidoof[CR]!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Minion[CR]: Why did you take the cover off?", french="[CS:N]Sbire[CR]: Mais pourquoi as-tu ouvert?!", german="[CS:N]Untergebener[CR]: Warum hast du die Abdeckung\nentfernt?!?", italian="[CS:N]Sgherro[CR]: Perché hai aperto lassù?!", spanish="[CS:N]Secuaz[CR]: ¡¿Por qué has destapado el agujero?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Bidoof", true, "bidoof", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_BIPPA) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Uh, what?[K] Whoops!", french=" Heiiin, quoi?[K] Oups!", german=" Ähm, was?[K] Hoppla!", italian=" Eh, cosa?[K] Ooops!", spanish=" ¿Cómo?[K] ¡Vaya!"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
