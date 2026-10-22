-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D14P12A/m14a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER
    GROUND:EntTurn(hero, Direction.Up)
    -- SetAnimation(72) [anim idle native]
    -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 320, 220, false, 2) -- SlidePositionMark (glissement)
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
    GROUND:MoveToPosition(partner, 272, 220, false, 2) -- SlidePositionMark (glissement)
    -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
    -- SetAnimation(11) [anim idle native]
    -- SlideHeight(2, 12) [neutre/état moteur]
    GAME:WaitFrames(2)
    -- SlideHeight(2, 0) [neutre/état moteur]
    GROUND:EntTurn(partner, Direction.Left)
    -- SetAnimation(68) [anim idle native]
    GAME:WaitFrames(60)
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(10) -- Lock(10) NDS
    -- SetAnimation(63) [anim idle native]
    GAME:WaitFrames(2) -- join WaitAnimation
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.unlock(3) -- Unlock(3) NDS
    SkySceneKit.lock(11) -- Lock(11) NDS
    GROUND:EntTurn(partner, Direction.DownLeft)
    GAME:WaitFrames(12)
    -- CallCommon CORO_LOOK_AROUND_LEFT_FUNC (fermeture/attente message: géré par say())
    SkySceneKit.lock(12) -- Lock(12) NDS
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D14P12A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
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
  SkySceneKit.say({english=" Ow! My backside!", french=" Ouille! Mon dos!!", german=" Autsch! Mein Hintern!", italian=" Ohi ohi! Il mio fondoschiena!", spanish=" ¡Ay! ¡Mi espalda!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ow! My backside!", french=" Ouille! Mon dos!!", german=" Autsch! Mein Hintern!", italian=" Ohi! Che male!", spanish=" ¡Ay! ¡Mi espalda!"})
  else
  SkySceneKit.say({english=" Ow! My backside!", french=" Ouille! Mon dos!!", german=" Autsch! Mein Hintern!", italian=" Ohi! Che male!", spanish=" ¡Ay! ¡Mi espalda!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(10)
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(30)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  GAME:WaitFrames(5)
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  pcall(function() SOUND:PlayBGM("Quicksand Cave.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-where are we?", french=" Mais où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Dónde? ¿Dónde estamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-where are we?", french=" Mais où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Dónde? ¿Dónde estamos?"})
  else
  SkySceneKit.say({english=" Wh-where are we?", french=" Mais où... où sommes-nous?", german=" W-wo sind wir?", italian=" D-Dove siamo?", spanish=" ¿Dónde? ¿Dónde estamos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is this a cave?", french=" C'est une caverne?", german=" Ist das eine Höhle?", italian=" È una caverna, questa?", spanish=" ¿Es una cueva?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is this a cave?", french=" C'est une caverne?", german=" Ist das eine Höhle?", italian=" È una caverna, questa?", spanish=" ¿Es una cueva?"})
  else
  SkySceneKit.say({english=" Is this a cave?", french=" C'est une caverne?", german=" Ist das eine Höhle?", italian=" È una caverna, questa?", spanish=" ¿Es una cueva?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(73) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(73) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We dropped through from way\nup there!", french="On a traversé les sables pour\natterrir ici!", german="Wir sind von ganz oben\nheruntergefallen!", italian=" Abbiamo fatto un bel volo, eh?", spanish=" ¡Hemos caído desde allí arriba!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We fell through from up there...", french="On a traversé les sables pour\natterrir ici!", german="Wir sind von oben\nheruntergefallen...", italian=" Abbiamo fatto un bel volo, eh?", spanish=" ¡Hemos caído desde allí arriba!"})
  else
  SkySceneKit.say({english="We dropped through from way\nup there...", french="On a traversé les sables pour\natterrir ici!", german="Wir sind von ganz oben\nheruntergefallen...", italian=" Abbiamo fatto un bel volo, eh?", spanish=" ¡Hemos caído desde allí arriba!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You had it right, [hero]!", french=" Tu avais raison, [hero]!", german=" Du hattest recht, [hero]!", italian="Ma avevi ragione tu,\n[hero]!", spanish=" Tenías razón, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You were right, [hero]!", french=" Tu avais raison, [hero]!", german=" Du hattest recht, [hero]!", italian="Ma era proprio come avevi detto\ntu, [hero]!", spanish=" Tenías razón, [hero]."})
  else
  SkySceneKit.say({english=" You were right, [hero]!", french=" Tu avais raison, [hero]!", german=" Du hattest recht, [hero]!", italian="Ma era proprio come avevi detto\ntu, [hero]!", spanish=" Tenías razón, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You were right about the secret\nbeing in the quicksand!", french="Tu avais raison à propos du\nsecret des sables mouvants!", german="Du hattest recht, das Geheimnis\nlag im Treibsand!", italian="La chiave di tutto stava nelle\nsabbie mobili!", spanish="Era cierto que la clave estaba\nen las arenas movedizas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You were right! The secret\nswirled within the quicksand!", french="Tu avais raison à propos du\nsecret des sables mouvants!", german="Du hattest recht, das Geheimnis\nlag im Treibsand!", italian="La chiave di tutto stava nelle\nsabbie mobili!", spanish="Era cierto que la clave estaba\nen las arenas movedizas."})
  else
  SkySceneKit.say({english="You were right! The secret\nswirled within the quicksand!", french="Tu avais raison à propos du\nsecret des sables mouvants!", german="Du hattest recht, das Geheimnis\nlag im Treibsand!", italian="La chiave di tutto stava nelle\nsabbie mobili!", spanish="Era cierto que la clave estaba\nen las arenas movedizas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's roll! It's time to go\nexploring, [hero]!", french="Allez, on bouge! C'est le moment\nde partir en exploration, [hero]!", german="Auf geht's! Das Erkunden\nkann losgehen, [hero]!", italian="Beh, è ora di andare a esplorare,\ngiusto, [hero]? Rock'n'roll!", spanish="¡Adelante! ¡Es hora de explorar,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's move it! It's time to go\nexploring, [hero]!", french="Allez, on bouge! C'est le moment\nde partir en exploration, [hero]!", german="Legen wir los! Das Erkunden\nkann losgehen, [hero]!", italian="Forza, [hero]! Andiamo a\nesplorare!", spanish="¡Adelante! ¡Es hora de explorar,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's move it! It's time to go\nexploring, [hero]!", french="Allez, on bouge! C'est le moment\nde partir en exploration, [hero]!", german="Legen wir los! Das Erkunden\nkann losgehen, [hero]!", italian="Forza, [hero]! Andiamo a\nesplorare!", spanish="¡Adelante! ¡Es hora de explorar,\n[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's find that Time Gear!", french="La chasse au Rouage du Temps\nest ouverte!", german="Lass uns das Zahnrad der Zeit\nfinden!", italian="Vediamo di trovare\nquell'Ingranaggio del Tempo!", spanish="¡Vamos a buscar ese Engranaje\ndel Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let our Time Gear search begin!", french="La chasse au Rouage du Temps\nest ouverte!", german="Lass uns unsere Suche nach dem\nZahnrad der Zeit beginnen!", italian="Che la nostra ricerca\ndell'Ingranaggio del Tempo abbia inizio!", spanish="¡Vamos a buscar ese Engranaje\ndel Tiempo!"})
  else
  SkySceneKit.say({english=" Let's search for that Time Gear!", french="La chasse au Rouage du Temps\nest ouverte!", german="Lass uns das Zahnrad der Zeit\nsuchen!", italian="Che la nostra ricerca\ndell'Ingranaggio del Tempo abbia inizio!", spanish="¡Vamos a buscar ese Engranaje\ndel Tiempo!"})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-180), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-180), p.Y+(0), false, 2) end
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(21, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.join_routines()
end
