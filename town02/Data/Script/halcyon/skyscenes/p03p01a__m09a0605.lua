-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09a0605.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Could the Drought Stone be...)", french="(Serait-il possible que la Pierre-Sèche...)", german="(Könnte der Melioriestein...)", italian="(Che la Pietra del Sole sia...)", spanish="(¿Será la Piedra Sequía...?)"})
  else
  SkySceneKit.say({english="(Could the Drought Stone be...)", french="(Serait-il possible que la Pierre-Sèche...)", german="(Könnte der Melioriestein...)", italian="(Che la Pietra del Sole sia...)", spanish="(¿Será la Piedra Sequía...?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe it's that stone [partner] found...)", french="(... soit cette pierre qu'a trouvée\n[partner]...)", german="(Vielleicht ist es der Stein, den [partner]\ngefunden hat...)", italian="(Potrebbe essere quella pietra che\nha trovato [partner]...)", spanish="(Tal vez sea la piedra que encontró\n[partner]...)"})
  else
  SkySceneKit.say({english="(Maybe it's that stone [partner] found...)", french="(... soit cette pierre qu'a trouvée\n[partner]...)", german="(Vielleicht ist es der Stein, den [partner]\ngefunden hat...)", italian="(Potrebbe essere quella pietra che\nha trovato [partner]...)", spanish="(Tal vez sea la piedra que encontró\n[partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(376, 468, 60, false) end) -- performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(28), false, 2) end
  GAME:WaitFrames(5)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 416, 472, Direction.Up, "NPC_HEIGANI")
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(hero, 360, 468, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(24), false, 2) end
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(24), false, 2) end
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Oh! Here!)", french="(Oh! Ici!)", german="(Oh! Hier!)", italian="(Sì! Qui!)", spanish="(¡Oh! ¡Aquí está!)"})
  else
  SkySceneKit.say({english="(Oh! Here!)", french="(Oh! Ici!)", german="(Oh! Hier!)", italian="(Sì! Qui!)", spanish="(¡Oh! ¡Aquí está!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(There's a small hollow in the statue's chest.)", french="(Il y a un petit creux dans le buste de la\nstatue.)", german="(Da ist eine kleine Aushöhlung in der Brust\nder Statue.)", italian="(C'è una piccola cavità nel petto della statua.)", spanish="(Hay un pequeño hueco en el pecho de\nla estatua.)"})
  else
  SkySceneKit.say({english="(There's a small hollow in the statue's chest.)", french="(Il y a un petit creux dans le buste de la\nstatue.)", german="(Da ist eine kleine Aushöhlung in der Brust\nder Statue.)", italian="(C'è una piccola cavità nel petto della statua.)", spanish="(Hay un pequeño hueco en el pecho de\nla estatua.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 396, 468, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_heigani, 420, 468, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Did you figure something out,\n[hero]?", french="Tu as compris quelque chose,\n[hero]?", german="Hast du etwas herausgefunden,\n[hero]?", italian="Hai scoperto qualcosa,\n[hero]?", spanish="¿Ya sabes lo que pasa,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Did you figure something out,\n[hero]?", french="Tu as compris quelque chose,\n[hero]?", german="Hast du etwas herausgefunden,\n[hero]?", italian="Hai scoperto qualcosa,\n[hero]?", spanish="¿Ya sabes lo que pasa,\n[hero]?"})
  else
  SkySceneKit.say({english="Did you figure something out,\n[hero]?", french="Tu as compris quelque chose,\n[hero]?", german="Hast du etwas herausgefunden,\n[hero]?", italian="Hai scoperto qualcosa,\n[hero]?", spanish="¿Ya sabes lo que pasa,\n[hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_EXPLANATION_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh?[K] That stone I found at the\nbase camp?", french="Hein?[K] La pierre que j'ai trouvée\nau camp de base?", german="Huch?[K] Der Stein, den ich beim\nBasislager gefunden habe?", italian="Eh?[K] La pietra che ho trovato al\nCampo Base?", spanish="¿Cómo?[K] ¿Esa piedra que\nencontré en el campamento base?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What?[K] That stone I found at the\nbase camp?", french="Hein?[K] La pierre que j'ai trouvée\nau camp de base?", german="Was?[K] Der Stein, den ich beim\nBasislager gefunden habe?", italian="Eh?[K] La pietra che ho trovato al\nCampo Base?", spanish="¿Eh?[K] ¿Esa piedra que encontré\nen el campamento base?"})
  else
  SkySceneKit.say({english="What?[K] That stone I found at the\nbase camp?", french="Hein?[K] La pierre que j'ai trouvée\nau camp de base?", german="Was?[K] Der Stein, den ich beim\nBasislager gefunden habe?", italian="Eh?[K] La pietra che ho trovato al\nCampo Base?", spanish="¿Eh?[K] ¿Esa piedra que encontré\nen el campamento base?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You want me to fit that stone\ninto this statue's chest?", french="Tu veux que je mette cette\npierre dans le buste de la statue?", german="Ich soll den Stein in die Brust\nder Statue einsetzen?", italian="Vuoi che inserisca la pietra nel\npetto della statua?", spanish="¿Quieres que coloque la piedra\nen el pecho de la estatua?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You want me to fit that stone\ninto this statue's chest?", french="Tu veux que je mette cette\npierre dans le buste de la statue?", german="Ich soll den Stein in die Brust\nder Statue einsetzen?", italian="Vuoi che inserisca la pietra nel\npetto della statua?", spanish="¿Quieres que coloque la piedra\nen el pecho de la estatua?"})
  else
  SkySceneKit.say({english="I should fit that stone into this\nstatue's chest?", french="Tu veux que je mette cette\npierre dans le buste de la statue?", german="Ich soll den Stein in die Brust\nder Statue einsetzen?", italian="Vuoi che inserisca la pietra nel\npetto della statua?", spanish="¿Quieres que coloque la piedra\nen el pecho de la estatua?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Sure thing! I'll try it!", french=" D'accord! Essayons!", german=" Na klar! Ich versuche es!", italian=" Sicuro! Ci proverò!", spanish=" ¡Claro! ¡Voy a probar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Sure! I'll try it!", french=" D'accord! Essayons!", german=" Sicher! Ich versuche es!", italian=" Sicuro! Ci proverò!", spanish=" ¡Claro! ¡Voy a probar!"})
  else
  SkySceneKit.say({english=" Sure thing! Let's try that!", french=" D'accord! Essayons!", german=" Na klar! Versuchen wir es!", italian=" Sicuro! Ci proverò!", spanish=" ¡Claro! ¡Vamos a intentarlo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 336, 468, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 360, 468, false, 2)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-4, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So put it into this hollow place?", french="Je la mets dans ce creux,\nc'est ça?", german="Ich soll ihn in die Aushöhlung\neinsetzen?", italian="Dici che devo inserirla in\nquesta cavità?", spanish="¿Entonces la pongo en este\nhueco?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So I should put it into this\nindentation?", french="Je la mets dans ce creux,\nc'est ça?", german="Ich soll ihn in die Aushöhlung\neinsetzen?", italian="Dici che devo inserirla in\nquesta cavità?", spanish="¿La tengo que poner en este\nhueco?"})
  else
  SkySceneKit.say({english="So I should put it into this\nhollow space?", french="Je la mets dans ce creux,\nc'est ça?", german="Ich soll ihn in die Aushöhlung\neinsetzen?", italian="Dici che devo inserirla in\nquesta cavità?", spanish="¿La encajo entonces en este\nhueco de aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-16), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- GAP: se_Play(6671) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] placed the strange\n[CN]stone in the statue's stone chest.", french="[CN][partner] met la pierre étrange\n[CN]dans le buste de la statue.", german="[CN][partner] setzt den seltsamen Stein\n[CN]in die Brust der Statue ein.", italian="[CN][partner] inserisce la strana\n[CN]pietra nel petto della statua.", spanish="[CN][partner] colocó la extraña\n[CN]piedra en el pecho de la estatua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(90)
  -- GAP: se_Play(6672) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P01A1_127) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  -- message_FacePositionOffset(-4, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wa-waah! Watch out! Everyone,\nget back!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nGeht alle zurück!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Apartaos todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wa-waah! Watch out! Step back,\neveryone!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nGeht in Deckung!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Hay que retroceder!"})
  else
  SkySceneKit.say({english="Wa-waah! Watch out! Everyone,\nwe have to get back!", french=" Wouah! Attention! Reculez!", german="Waaaah! Passt auf!\nWir müssen zurückgehen!", italian="Wa-waah! A-Attenti!\nState indietro!", spanish="¿Quéee? ¡Cuidado!\n¡Atrás!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(200), 200, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(200), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(200), false, 2) end
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(200), false, 2) end
  pcall(function() SOUND:FadeOutBGM(160) end)
  -- GAP: se_Play(6673) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P03P01A1_127) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(80)
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah!", french=" Wouaaah!", german=" Waaaah!", italian=" Waaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah!", french=" Wouaaah!", german=" Waaaah!", italian=" Waaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah!", french=" Wouaaah!", german=" Waaaah!", italian=" Waaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(90)
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(90)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
end
