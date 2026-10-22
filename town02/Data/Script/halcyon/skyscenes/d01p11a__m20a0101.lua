-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m20a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V31P01A, 0, 152, 120, 16) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  SkyProg.set(21, 1) -- $SCENARIO_MAIN = scn[21,1] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03A) [décor sub chargé: Sub_v01p03a]
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 416, 176, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(29) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v01p03a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(120)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...............)", french="(...............)", german="(...............)", italian="(...............)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This...[K] This is...)", french="(Ce...[K] C'est...)", german="(Das...[K] Das ist...)", italian="(Questo...[K] è...)", spanish="(Esto...[K] Esto es...)"})
  else
  SkySceneKit.say({english="(This...[K] This is...)", french="(Ce...[K] C'est...)", german="(Das...[K] Das ist...)", italian="(Questo...[K] è...)", spanish="(Esto...[K] Esto es...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Urk...", french=" ... Argh...", german=" ...Uff...", italian=" Ah...", spanish=" ¡Ay!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Urk...", french=" ... Argh...", german=" ...Uff...", italian=" Ah...", spanish=" ¡Ay!"})
  else
  SkySceneKit.say({english=" ...Urk...", french=" ... Argh...", german=" ...Uff...", italian=" Ah...", spanish=" ¡Ay!"})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(60)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh...[K] [hero], where...?", french=" Euh...[K] [hero], où...?", german=" Hä...[K] [hero], wo?", italian=" Eh...[K] [hero], dove...?", spanish=" Eh...[K] [hero], ¿dónde...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What...[K] [hero], where...?", french=" Euh...[K] [hero], où...?", german=" Was...[K] [hero], wo?", italian=" Cosa...[K] [hero], dove...?", spanish=" Eh...[K] [hero], ¿dónde...?"})
  else
  SkySceneKit.say({english=" What...[K] [hero], where...?", french=" Euh...[K] [hero], où...?", german=" Was...[K] [hero], wo?", italian=" Cosa...[K] [hero], dove...?", spanish=" Eh...[K] [hero], ¿dónde...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Isn't this...[K]where I met you,\n[hero]...?", french="C'est...[K] là qu'a eu lieu notre\npremière rencontre, [hero], non?", german="Ist das nicht...[K] Ist das nicht die\nStelle, an der wir uns zum ersten Mal trafen,\n[hero]?", italian="Non è il posto in cui...[K] ci siamo\nincontrati, [hero]...?", spanish="¿No es aquí donde...?[K] ¿No es\naquí donde te conocí, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Isn't this...[K]where I met you,\n[hero]...?", french="C'est...[K] là qu'a eu lieu notre\npremière rencontre, [hero], non?", german="Ist das nicht...[K] Ist das nicht die\nStelle, an der wir uns zum ersten Mal trafen,\n[hero]?", italian="Non è il posto in cui...[K] ci siamo\nincontrati, [hero]...?", spanish="¿No es aquí donde...?[K] ¿No es\naquí donde te conocí, [hero]?"})
  else
  SkySceneKit.say({english="Isn't this...[K]where I met you,\n[hero]...?", french="C'est...[K] là qu'a eu lieu notre\npremière rencontre, [hero], non?", german="Ist das nicht...[K] Ist das nicht die\nStelle, an der wir uns zum ersten Mal trafen,\n[hero]?", italian="Non è il luogo...[K] del nostro\nprimo incontro, [hero]...?", spanish="¿No es aquí donde...?[K] ¿No es\naquí donde te conocí, [hero]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's like...that beach...", french=" On dirait... la plage...", german=" Es ist wie dieser Strand...", italian=" Sembra... quella spiaggia...", spanish=" Es como... aquella playa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's like...that beach...", french=" On dirait... la plage...", german=" Es ist wie dieser Strand...", italian=" Sembra... quella spiaggia...", spanish=" Es como... aquella playa..."})
  else
  SkySceneKit.say({english=" It's like...that beach...", french=" On dirait... la plage...", german=" Es ist wie dieser Strand...", italian=" Sembra... quella spiaggia...", spanish=" Es como... aquella playa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So that means...[K] Could it be?", french=" Mais alors... [K]non, impossible!", german=" Das bedeutet...[K] Kann das sein?", italian=" Quindi significa...[K] È possibile?", spanish="Eso significa que...[K]\n¿Estamos...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So that means...[K] Could it be?", french=" Mais alors... [K]non, impossible!", german=" Das bedeutet...[K] Kann das sein?", italian=" Quindi significa...[K] È possibile?", spanish="Eso significa que...[K]\n¿Estamos...?"})
  else
  SkySceneKit.say({english=" So that means...[K] Could it be?", french=" Mais alors... [K]non, impossible!", german=" Das bedeutet...[K] Kann das sein?", italian=" Quindi significa...[K] È possibile?", spanish="Eso significa que...[K]\n¿Estamos...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, it is!", french=" Oui, c'est bien ça!", german=" Nein, es ist wahr!", italian=" Sì, lo è!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, it is!", french=" Oui, c'est bien ça!", german=" Nein, es ist wahr!", italian=" Sì, lo è!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" No, it is!", french=" Oui, c'est bien ça!", german=" Nein, es ist wahr!", italian=" Sì, lo è!", spanish=" ¡Sí!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're...[K]in the past!", french=" On est...[K] dans le passé!", german=" Wir sind...[K] in der Vergangenheit!", italian=" Siamo...[K] nel passato!", spanish=" Estamos...[K] ¡en el pasado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're...[K]in the past!", french=" On est...[K] dans le passé!", german=" Wir sind...[K] in der Vergangenheit!", italian=" Siamo...[K] nel passato!", spanish=" Estamos...[K] ¡en el pasado!"})
  else
  SkySceneKit.say({english=" We're...[K]in the past!", french=" On est...[K] dans le passé!", german=" Wir sind...[K] in der Vergangenheit!", italian=" Siamo...[K] nel passato!", spanish=" Estamos...[K] ¡en el pasado!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're back in our world!", french=" On est rentrés chez nous!", german="Wir sind zurück in unserer\nWelt!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We made it back to our world!", french=" On est rentrés chez nous!", german="Wir haben es in unsere Welt\nzurückgeschafft!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  else
  SkySceneKit.say({english=" We're back in our world!", french=" On est de retour chez nous!", german="Wir sind zurück in unserer\nWelt!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes![K] We did it, [hero]!", french=" Oui![K] On a réussi, [hero]!", german="Ja![K] Wir haben es geschafft,\n[hero]!", italian="Sì![K] Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Sí![K] ¡Lo logramos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes![K] We made it, [hero]!", french=" Oui![K] On a réussi, [hero]!", german="Ja![K] Wir haben es geschafft,\n[hero]!", italian="Sì![K] Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Sí![K] ¡Lo logramos, [hero]!"})
  else
  SkySceneKit.say({english=" Yes![K] We made it, [hero]!", french=" Oui![K] On a réussi, [hero]!", german="Ja![K] Wir haben es geschafft,\n[hero]!", italian="Sì![K] Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Sí![K] ¡Lo logramos, [hero]!"})
  end
  -- message_Close
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Ugh...", french=" Euh...", german=" Schluck...", italian=" Ah...", spanish=" Uf..."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hey! [CS:N]Grovyle[CR]!", french=" Eh! [CS:N]Massko[CR]!", german=" Hey! [CS:N]Reptain[CR]!", italian=" Ehi! [CS:N]Grovyle[CR]!", spanish=" ¡Mira! ¡[CS:N]Grovyle[CR]!"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(392, 180, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 376, 164, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 376, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look around![K] We made it home!", french=" Regarde un peu![K] On est rentrés!", german="Sieh dich um![K] Wir sind zu\nHause!", italian="Guardati attorno![K] Siamo tornati\na casa!", spanish=" ¡Mira esto![K] ¡Estamos en casa!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look![K] We made it home!", french=" Regarde un peu![K] On est rentrés!", german="Sieh dich um![K] Wir sind zu\nHause!", italian=" Guarda![K] Siamo tornati a casa!", spanish=" ¡Mira esto![K] ¡Estamos en casa!"})
  else
  SkySceneKit.say({english=" Look around![K] We made it home!", french=" Regarde un peu![K] On est rentrés!", german="Sieh dich um![K] Wir sind zu\nHause!", italian="Guardati attorno![K] Siamo tornati\na casa!", spanish=" ¡Mira esto![K] ¡Estamos en casa!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Back to our world!", french="Nous voilà de retour dans\nnotre monde!", german=" Zurück in unserer Welt!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Back to our world!", french="Nous voilà de retour dans\nnotre monde!", german=" Zurück in unserer Welt!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  else
  SkySceneKit.say({english=" Back to our world!", french="Nous voilà de retour dans\nnotre monde!", german=" Zurück in unserer Welt!", italian="Siamo di nuovo nel nostro\ntempo!", spanish=" ¡Hemos vuelto a nuestro mundo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" So we did it...?", french=" Alors, c'est vrai, on a réussi...?", german=" Also haben wir es geschafft?", italian=" Allora ce l'abbiamo fatta...?", spanish=" ¿Así que lo logramos?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We made it through...", french=" On a pu passer...", german=" Wir sind durchgekommen...", italian=" Siamo tornati...", spanish=" Hemos conseguido volver..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" back to this world?", french=" ... et revenir dans ce monde?", german=" Zurück in die Vergangenheit...", italian=" Siamo di nuovo nel passato?", spanish=" ¿Al pasado?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup!", french=" Ouaip!", german=" Jep!", italian=" Già!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes!", french=" Ouaip!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  else
  SkySceneKit.say({english=" Yep!", french=" Ouaip!", german=" Jep!", italian=" Già!", spanish=" ¡Sí!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is where I met\n[hero].", french="C'est ici que j'ai fait\nla connaissance de [hero].", german="Hier habe ich zum ersten Mal\n[hero] getroffen.", italian="Questo è il posto in cui ho\nconosciuto [hero].", spanish="Aquí fue donde conocí a\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is where I met\n[hero].", french="C'est ici que j'ai fait\nla connaissance de [hero].", german="Hier habe ich zum ersten Mal\n[hero] getroffen.", italian="Questo è il posto in cui ho\nconosciuto [hero].", spanish="Aquí fue donde conocí a\n[hero]."})
  else
  SkySceneKit.say({english="This is where I met\n[hero].", french="C'est ici que j'ai fait\nla connaissance de [hero].", german="Hier habe ich zum ersten Mal\n[hero] getroffen.", italian="Questo è il posto in cui ho\nconosciuto [hero].", spanish="Aquí fue donde conocí a\n[hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's see...", french=" Voyons voir...", german=" Mal sehen...", italian=" Vediamo...", spanish=" Vamos a ver..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's see...", french=" Voyons voir...", german=" Wollen wir mal sehen...", italian=" Vediamo...", spanish=" Vamos a ver..."})
  else
  SkySceneKit.say({english=" Let me see...", french=" Voyons voir...", german=" Sehen wir mal...", italian=" Vediamo un po'...", spanish=" Vamos a ver..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(360, 180, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 296, 164, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It was around here.", french=" Je devais être par là.", german=" Es war ungefähr hier.", italian=" Era qui vicino.", spanish=" Fue por aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I think it was right here.", french=" Je devais être par là.", german=" Ich denke, es war genau hier.", italian=" Penso fosse proprio qui.", spanish=" Creo que fue por aquí..."})
  else
  SkySceneKit.say({english=" It would be around here.", french=" Je devais être par là.", german="Es muss ungefähr hier gewesen\nsein.", italian=" Era da queste parti.", spanish=" Debió de ser por aquí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This was where I found\n[hero] out cold.", french="Et c'est ici que j'ai trouvé\n[hero] sans connaissance.", german="Hier habe ich [hero]\ngefunden, tief und fest schlafend.", italian="Ho trovato [hero] qui,\nin stato di confusione.", spanish="Aquí fue donde encontré\na [hero] sin conocimiento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This was where I found\n[hero] out cold.", french="Et c'est ici que j'ai trouvé\n[hero] sans connaissance.", german="Hier habe ich [hero]\ngefunden, tief und fest schlafend.", italian="Ho trovato [hero] qui,\nin stato di confusione.", spanish="Aquí fue donde encontré\na [hero] sin conocimiento."})
  else
  SkySceneKit.say({english="[hero] was out cold\nright here.", french="Et c'est ici que j'ai trouvé\n[hero] sans connaissance.", german="Hier habe ich [hero]\ngefunden, tief und fest schlafend.", italian="[hero] era proprio qui,\nin stato di confusione.", spanish="Aquí fue donde encontré\na [hero] sin conocimiento."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" So that's what happened.", french="Alors c'est comme ça que\nça s'est passé.", german=" Das ist also geschehen.", italian=" Quindi è andata così.", spanish=" Así que eso fue lo que ocurrió."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That trip through time sent me\ninto the Eastern Forest.", french="Après le voyage dans le temps,\nj'ai atterri dans la Forêt de l'Est.", german="Diese Zeitreise führte mich in\ndie Östlichen Wälder.", italian="Io mi sono ritrovato nella\nForesta Orientale.", spanish=" Yo aparecí en el Bosque del Este."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And [hero] and I both\nreached your world far away from each other.", french="En fait, [hero] et moi\nsommes tous les deux arrivés dans ton monde,\nmais à des lieues l'un de l'autre.", german="Und [hero] und ich\nerreichten so, fern voneinander, deine Welt.", italian="E [hero] qui. Così\nabbiamo raggiunto il tuo mondo ma in due\nluoghi molto distanti tra loro.", spanish="[hero] y yo llegamos a\nlugares distintos de este mundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, that's right!", french=" Oh, c'est vrai!", german=" Oh, richtig!", italian=" Eh, sì!", spanish=" ¡Claro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, that's right!", french=" Oh, c'est vrai!", german=" Oh, richtig!", italian=" Eh, sì!", spanish=" ¡Claro!"})
  else
  SkySceneKit.say({english=" Oh, that's right!", french=" Oh, c'est vrai!", german=" Oh, richtig!", italian=" Eh, sì!", spanish=" ¡Claro!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's a lot I don't understand!\nLike the whole time-travel thing!", french="Il y a plein de choses que\nje ne comprends pas! Comme toute cette\nhistoire de voyage dans le temps!", german="Es gibt vieles, was ich nicht\nverstehe! Wie diese ganze Zeitreise-Sache!", italian="Ci sono molte cose che non mi\nsono chiare! Come tutta questa storia dei\nviaggi nel tempo!", spanish="Hay muchas cosas que aún no\nentiendo, como todo eso del viaje en el\ntiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's a lot I don't understand!\nLike the whole concept of time travel!", french="Il y a plein de choses que\nje ne comprends pas! Comme toute cette\nhistoire de voyage dans le temps!", german="Es gibt vieles, was ich nicht\nverstehe! Wie diese ganze Zeitreise-Sache!", italian="Ci sono molte cose che non mi\nsono chiare! Come l'intero concetto dei viaggi\nnel tempo!", spanish="Hay muchas cosas que aún no\nentiendo, como todo eso del viaje en el\ntiempo."})
  else
  SkySceneKit.say({english="I'm really confused by a lot of\nthings! Like this whole concept of time travel!", french="Il y a plein de choses que\nje ne comprends pas! Comme toute cette\nhistoire de voyage dans le temps!", german="Es gibt vieles, was ich nicht\nverstehe! Wie diese ganze Zeitreise-Sache!", italian="Ci sono molte cose che non mi\nsono chiare! Come l'intero concetto dei viaggi\nnel tempo!", spanish="Hay muchas cosas que aún no\nentiendo, como todo eso del viaje en el\ntiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can you explain it to us, please?", french=" Tu pourrais nous expliquer?", german="Kannst du uns das bitte\nerklären?", italian=" Puoi spiegarcele, per favore?", spanish=" ¿Nos lo podrías explicar?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Will you please explain it to us?", french=" Tu pourrais nous expliquer?", german="Kannst du uns das bitte\nerklären?", italian=" Ce le puoi spiegare, per favore?", spanish=" ¿Nos lo podrías explicar?"})
  else
  SkySceneKit.say({english=" Will you please explain it to us?", french=" Tu pourrais nous expliquer?", german="Kannst du uns das bitte\nerklären?", italian=" Ce le puoi spiegare, per favore?", spanish=" ¿Nos lo podrías explicar?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But this isn't really the place to\ntalk, so...", french="Mais ça n'est pas vraiment\nl'endroit idéal pour en discuter, alors...", german="Aber das sind weder der Ort\nnoch die Zeit, um sich in Ruhe zu unterhalten...", italian="Questo non è il posto adatto\nper parlare...", spanish="Bueno, este no es el mejor sitio\npara hablar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But this isn't really the place to\ntalk, so...", french="Mais ça n'est pas vraiment\nl'endroit idéal pour en discuter, alors...", german="Aber das sind weder der Ort\nnoch die Zeit, um sich in Ruhe zu unterhalten...", italian="Questo non è il posto adatto\nper parlare...", spanish="Bueno, este no es el mejor sitio\npara hablar..."})
  else
  SkySceneKit.say({english="But this isn't really the place to\ntalk, so...", french="Mais ça n'est pas vraiment\nl'endroit idéal pour en discuter, alors...", german="Aber das sind weder der Ort\nnoch die Zeit, um sich in Ruhe zu unterhalten...", italian="Questo non è il posto adatto\nper parlare...", spanish="Bueno, este no es el mejor sitio\npara hablar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go to [CS:N]Wigglytuff[CR]'s Guild\nand talk there.", french="Allons à la Guilde de [CS:N]Grodoudou[CR]\npour parler de tout ça.", german="Lass uns zur [CS:N]Knuddeluff-Gilde[CR]\ngehen und dort reden.", italian="Andiamo alla Gilda di [CS:N]Wigglytuff[CR]\ne parliamone là.", spanish="¡Vamos al [CS:N]Pokégremio de[CR]\n[CS:N]Exploradores[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go to [CS:N]Wigglytuff[CR]'s Guild\nand talk there.", french="Allons à la Guilde de [CS:N]Grodoudou[CR]\npour parler de tout ça.", german="Lass uns zur [CS:N]Knuddeluff-Gilde[CR]\ngehen und dort reden.", italian="Andiamo alla Gilda di [CS:N]Wigglytuff[CR]\ne parliamone là.", spanish="¡Venga! Vayamos al [CS:N]Pokégremio[CR]\n[CS:N]de Exploradores[CR]."})
  else
  SkySceneKit.say({english="Let's go to [CS:N]Wigglytuff[CR]'s Guild\nand talk there.", french="Allons à la Guilde de [CS:N]Grodoudou[CR]\npour parler de tout ça.", german="Lass uns zur [CS:N]Knuddeluff-Gilde[CR]\ngehen und dort reden.", italian="Andiamo alla Gilda di [CS:N]Wigglytuff[CR]\ne parliamone là.", spanish="Será mejor que esperemos a\nllegar al [CS:N]Pokégremio de Exploradores[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Before we went to the future,\nwe trained there and lived there. It's the\nperfect place.", french="C'est là qu'on vivait avant de\npartir dans le futur. C'est l'endroit idéal.", german="Bevor wir in die Zukunft gingen,\nhaben wir dort gelebt und trainiert. Es ist der\nperfekte Ort.", italian="Prima di andare nel futuro,\nvivevamo e ci allenavamo là. È il\nposto più adatto.", spanish="Allí es donde vivíamos y nos\nentrenábamos antes de ir al futuro.\nEs el sitio perfecto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Before we went to the future,\nwe trained there and roomed there. It will be\nthe perfect place!", french="C'est là qu'on vivait avant de\npartir dans le futur. C'est l'endroit idéal.", german="Bevor wir in die Zukunft gingen,\nhaben wir dort gelebt und trainiert. Es ist der\nperfekte Ort.", italian="Prima di andare nel futuro,\nvivevamo e ci allenavamo là. Sarà il\nposto più adatto!", spanish="Allí es donde vivíamos y nos\nentrenábamos antes de ir al futuro.\nEs el sitio perfecto."})
  else
  SkySceneKit.say({english="Before we went to the future,\nwe trained there and roomed there. It will be\nthe perfect place!", french="C'est là qu'on vivait avant de\npartir dans le futur. C'est l'endroit idéal.", german="Bevor wir in die Zukunft gingen,\nhaben wir dort gelebt und trainiert. Es ist der\nperfekte Ort.", italian="Prima di andare nel futuro,\nvivevamo e ci allenavamo là. Sarà il\nposto più adatto!", spanish="Allí es donde vivíamos y nos\nentrenábamos antes de ir al futuro.\nEs el sitio perfecto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. Let's go to\n[CS:N]Wigglytuff[CR]'s Guild.", french="Allez. En route pour la Guilde\nde [CS:N]Grodoudou[CR].", german="Alles klar. Gehen wir zur\n[CS:N]Knuddeluff-Gilde[CR].", italian="Va bene. Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Pues, en marcha.\n¡Al [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK. Let's go to [CS:N]Wigglytuff[CR]'s\nGuild.", french="Allez. En route pour la Guilde\nde [CS:N]Grodoudou[CR].", german="Alles klar. Gehen wir zur\n[CS:N]Knuddeluff-Gilde[CR].", italian="Va bene. Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Estupendo. Pongámonos en\ncamino hacia el [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="OK. Let's go to [CS:N]Wigglytuff[CR]'s\nGuild.", french="Allez. En route pour la Guilde\nde [CS:N]Grodoudou[CR].", german="Alles klar. Gehen wir zur\n[CS:N]Knuddeluff-Gilde[CR].", italian="Va bene. Andiamo alla Gilda di\n[CS:N]Wigglytuff[CR].", spanish="Muy bien. Vámonos al\n[CS:N]Pokégremio[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(32), p.Y+(32), false, 2) end
  GROUND:MoveToPosition(partner, 400, 196, false, 2)
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(392, 180, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.DownRight)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Hold on.", french=" Attendez.", german=" Warte mal.", italian=" Aspetta.", spanish=" Espera un segundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Will I be well received if I go\nto the guild?", french="Vous croyez que je serai bien\naccueilli à la Guilde?", german="Wird man mich freundlich\nempfangen, wenn wir zur Gilde gehen?", italian="Come mi accoglieranno alla\nGilda?", spanish="¿Crees que voy a ser bien\nrecibido en el [CS:N]Pokégremio[CR]?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="After all, I'm a wanted outlaw in\nthis world.", french="Après tout, dans ce monde-ci,\nma tête est mise à prix.", german="Immerhin bin ich ein gesuchter\nGesetzloser in dieser Welt.", italian="Del resto, in questo mondo sono\nun fuorilegge ricercato.", spanish="Al fin y al cabo, en este mundo\nsoy un malhechor buscado por la ley."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If I went to your guild...[K]won't\neveryone be shocked?", french="Si nous allons dans votre\nGuilde...[K] ça risque de créer un choc, non?", german="Wenn ich zu eurer Gilde\nginge...[K] Wären die anderen nicht schockiert?", italian="Se vengo alla vostra Gilda...[K]\nnon rimarranno tutti scioccati?", spanish="Si apareciera en el [CS:N]Pokégremio[CR]...[K]\n¿no crees que todos se quedarían de piedra?"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Don't you think they'd try to\ncapture me?", french="Vous ne croyez pas qu'ils vont\nessayer de me mettre sous les verrous?", german="Glaubt ihr nicht, sie würden\nversuchen, mich gefangen zu nehmen?", italian="Non credi che proveranno a\ncatturarmi?", spanish="¿No te parece que intentarían\nentregarme a la justicia?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urk! Come to think of it, you're\nright...[K] What to do...?", french="Ah! Tu as raison, je n'y avais\npas pensé...[K] Qu'est-ce qu'on va faire...?", german="Umpf! Wenn ich so darüber\nnachdenke...[K] Es stimmt. Was sollen wir tun?", italian="Oh! Ora che ci penso, hai\nragione...[K] Come fare...?", spanish="¡Vaya! Ahora que lo pienso...\nTienes razón.[K] ¿Qué podemos hacer?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urk! Come to think of it, you're\nright...[K] What to do...?", french="Ah! Tu as raison, je n'y avais\npas pensé...[K] Qu'est-ce qu'on va faire...?", german="Umpf! Wenn ich so darüber\nnachdenke...[K] Es stimmt. Was sollen wir tun?", italian="Oh! Ora che ci penso, hai\nragione...[K] Come fare...?", spanish="¡Vaya! Ahora que lo pienso...\nTienes razón.[K] ¿Qué podemos hacer?"})
  else
  SkySceneKit.say({english="Urk! Come to think of it, you're\nright...[K] What should we do?", french="Ah! Tu as raison, je n'y avais\npas pensé...[K] Qu'est-ce qu'on va faire...?", german="Umpf! Wenn ich so darüber\nnachdenke...[K] Es stimmt. Was sollen wir tun?", italian="Oh! Ora che ci penso, hai\nragione...[K] Come fare...?", spanish="¡Vaya! Ahora que lo pienso...\nTienes razón.[K] ¿Qué podemos hacer?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, I know![K] There's a good place.", french="Ça y est, je sais![K] Je connais\nun endroit où on peut aller.", german="Oh, ich weiß![K] Es gibt einen\nguten Ort.", italian="Oh, mi è venuta un'idea![K] C'è un\nposto adatto.", spanish="¡Ah, ya sé![K]\nConozco un lugar perfecto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, I know![K] There's a good place.", french="Ça y est, je sais![K] Je connais\nun endroit où on peut aller.", german="Oh, ich weiß![K] Es gibt einen\nguten Ort.", italian="Oh, mi è venuta un'idea![K] C'è un\nposto adatto.", spanish="¡Ah, ya sé![K]\nConozco un lugar perfecto."})
  else
  SkySceneKit.say({english=" Oh, I know![K] There's a good place.", french="Ça y est, je sais![K] Je connais\nun endroit où on peut aller.", german="Oh, ich weiß![K] Es gibt einen\nguten Ort.", italian="Oh, mi è venuta un'idea![K] C'è un\nposto adatto.", spanish="¡Ah, ya sé![K]\nSé de un lugar perfecto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it will mean cutting through\nTreasure Town...", french="Mais on sera obligés de passer\npar Bourg-Trésor pour y aller...", german="Aber dazu müssen wir durch\nSchatzstadt gehen...", italian="Ma per arrivarci dobbiamo\npassare per Borgo Tesoro...", spanish="Pero habría que cruzar Aldea\nTesoro..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it will involve going through\nTreasure Town...", french="Mais on sera obligés de passer\npar Bourg-Trésor pour y aller...", german="Aber wir müssen durch\nSchatzstadt, um ihn zu erreichen...", italian="Ma dobbiamo attraversare\nBorgo Tesoro...", spanish="Pero habría que cruzar Aldea\nTesoro..."})
  else
  SkySceneKit.say({english="But we'll need to go through\nTreasure Town...", french="Mais on sera obligés de passer\npar Bourg-Trésor pour y aller...", german="Aber der Weg dorthin führt\ndurch Schatzstadt...", italian="Ma dobbiamo attraversare\nBorgo Tesoro...", spanish="Pero habría que cruzar Aldea\nTesoro..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="It shouldn't be a problem if we\nlie low and sneak through.", french="Ça devrait aller si on se faufile\nen faisant profil bas.", german="Es dürfte kein Problem sein,\nwenn wir uns unauffällig durchschleichen.", italian="Non dovrebbe essere un\nproblema se l'attraversiamo di soppiatto.", spanish="Si somos discretos y escogemos\nel momento adecuado, no nos pasará nada."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Lead the way.", french=" Ouvrez la marche.", german=" Dann geh mal voran.", italian=" Facci strada.", spanish=" Te seguimos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right. It's this way.", french=" D'accord, c'est par là.", german=" Alles klar. Es geht hier lang.", italian=" Va bene. Da questa parte.", spanish=" Muy bien. Es por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK. It's this way.", french=" D'accord, c'est par là.", german=" Okay. Es geht hier lang.", italian=" Va bene. Da questa parte.", spanish=" Muy bien. Es por aquí."})
  else
  SkySceneKit.say({english=" OK. It's this way.", french=" D'accord, c'est par là.", german=" Okay. Es geht hier lang.", italian=" Va bene. Da questa parte.", spanish=" Muy bien. Es por aquí."})
  end
  -- message_Close
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(160), p.Y+(0), false, 2) end
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(60)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  GAME:WaitFrames(2) -- join WaitBgm
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SPECIAL_EPISODE_OPEN = SV.SkyVars.SPECIAL_EPISODE_OPEN or {}; SV.SkyVars.SPECIAL_EPISODE_OPEN[3] = 1 -- $SPECIAL_EPISODE_OPEN[3] = 1 (ROM)
  pcall(function() SOUND:PlayFanfare("Fanfare/Note") end) -- me_Play(7) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]There's a message from the\n[CN]Exploration Team Federation.[W:30]", french="[CN]La Fédération des Equipes d'Exploration\n[CN]a envoyé un message...[W:30]", german="[CN]Der Erkundungsteamverband\n[CN]hat eine Nachricht geschickt.[W:30]", italian="[CN]C'è un messaggio della Federazione\n[CN]Squadre d'Esplorazione![W:30]", spanish="[CN]Hay un mensaje de la\n[CN]Federación de Exploradores.[W:30]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P26P01A) [neutre/état moteur]
  -- supervision_Acting(10) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/JoinTeam") end) -- me_Play(5) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]Special Episode\n[CN]\"Here Comes Team Charm!\"\n[CN]has been unlocked![W:90]", french="[CN]L'Episode Spécial\n[CN]\"Voilà l'Equipe Charme!\"\n[CN]est maintenant disponible![W:90]", german="[CN]Die Bonusepisode\n[CN][F:S2]Platz für Team Charme![F:E2]\n[CN]wurde freigeschaltet![W:90]", italian="[CN]L'episodio speciale\n[CN]\"Arriva il Team Malia!\"\n[CN]è ora disponibile![W:90]", spanish="[CN]Se ha desbloqueado\n[CN]el capítulo especial\n[CN]\"¡Llega el Equipo Carisma!\".[W:90]"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]To play a Special Episode,\n[CN]select it from the Episode List\n[CN]on the Top Menu.", french="[CN]Pour jouer à un Episode Spécial,\n[CN]sélectionnez-le dans la Liste des épisodes\n[CN]à partir du menu principal.", german="[CN]Um eine Bonusepisode zu spielen,\n[CN]wähle sie in der Episodenliste\n[CN]im Hauptmenü aus.", italian="[CN]Per giocare a un episodio speciale,\n[CN]selezionalo dalla lista episodi\n[CN]nel menu principale.", spanish="[CN]Para jugar a un capítulo especial,\n[CN]elígelo en la lista de capítulos\n[CN]del menú principal."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]If you would like to play the Special Episode,\n[CN]save your adventure progress, and\n[CN]return to the Top Menu.", french="[CN]Si vous souhaitez jouer à cet Episode Spécial,\n[CN]sauvegardez d'abord votre aventure\n[CN]puis retournez au menu principal.", german="[CN]Wenn du eine Bonusepisode spielen\n[CN]möchtest, speichere deinen Spielstand\n[CN]und kehre zum Hauptmenü zurück.", italian="[CN]Se vuoi giocare all'episodio speciale,\n[CN]salva i progressi della tua avventura\n[CN]e torna al menu principale.", spanish="[CN]Si quieres jugar al capítulo especial,\n[CN]guarda tu progreso y\n[CN]vuelve al menú principal."})
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 16 -- $COMPULSORY_SAVE_POINT = 16 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
