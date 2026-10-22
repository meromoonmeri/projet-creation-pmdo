-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_NEXT_DAY, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_H02P99A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
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
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [CS:N]Mana[CR]...!", french=" Bonjour, [CS:N]Mana[CR]...!", german=" Guten Morgen, [CS:N]Mana[CR]...", italian=" Buongiorno, [CS:N]Mana[CR]...!", spanish=" Buenos días, [CS:N]Mana[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [CS:N]Mana[CR]...!", french=" Bonjour, [CS:N]Mana[CR]...!", german=" Guten Morgen, [CS:N]Mana[CR]...", italian=" Buongiorno, [CS:N]Mana[CR]...!", spanish=" Buenos días, [CS:N]Mana[CR]..."})
  else
  SkySceneKit.say({english=" Good morning, [CS:N]Mana[CR]...!", french=" Bonjour, [CS:N]Mana[CR]...!", german=" Guten Morgen, [CS:N]Mana[CR]...", italian=" Buongiorno, [CS:N]Mana[CR]...!", spanish=" Buenos días, [CS:N]Mana[CR]..."})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]?", french=" [CS:N]Manaphy[CR]?", german=" [CS:N]Manaphy[CR]?", italian=" [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  end
  -- message_Close
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", french=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", german=" Oh, [hero]![K] [CS:N]Manaphy[CR]...", italian=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", spanish="¡[hero]![K]\n¿Y [CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", french=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", german=" Oh, [hero]![K] [CS:N]Manaphy[CR]...", italian=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", spanish="¡[hero]![K]\n¿Y [CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", french=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", german=" Oh, [hero]![K] [CS:N]Manaphy[CR]...", italian=" Oh, [hero]![K] [CS:N]Manaphy[CR]...?", spanish="¡[hero]![K]\n¿Y [CS:N]Manaphy[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR] is missing!", french=" [CS:N]Manaphy[CR] a disparu!", german=" [CS:N]Manaphy[CR] ist weg!", italian=" [CS:N]Manaphy[CR] è scomparso!", spanish=" ¡[CS:N]Manaphy[CR] ha desaparecido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR] is missing!", french=" [CS:N]Manaphy[CR] a disparu!", german=" [CS:N]Manaphy[CR] ist weg!", italian=" [CS:N]Manaphy[CR] è scomparso!", spanish=" ¡[CS:N]Manaphy[CR] ha desaparecido!"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR] is missing!", french=" [CS:N]Manaphy[CR] a disparu!", german=" [CS:N]Manaphy[CR] ist weg!", italian=" [CS:N]Manaphy[CR] è scomparso!", spanish=" ¡[CS:N]Manaphy[CR] ha desaparecido!"})
  end
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What...[K]what should we do?![K]\nWhere did he go?", french="Que...[K] qu'allons-nous faire?![K]\nOù est-il parti?", german="Was...[K] Was sollen wir tun?!?[K]\nWo ist es hingegangen?", italian="Cosa...[K] Cosa facciamo?![K]\nDov'è andato?", spanish="¿Qué...?[K] ¿Qué hacemos?[K]\n¿Adónde habrá ido?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What...[K] What should we do?![K]\nWhere could he have gone?", french="Que...[K] qu'allons-nous faire?![K]\nOù est-il parti?", german="Was...[K] Was sollen wir tun?!?[K]\nWo ist es hingegangen?", italian="Cosa...[K] Cosa facciamo?![K]\nDove può essere andato?", spanish="¿Qué...?[K] ¿Qué hacemos?[K]\n¿Adónde habrá ido?"})
  else
  SkySceneKit.say({english="What...[K] What should we do?![K]\nWhere did he go?", french="Que...[K] qu'allons-nous faire?![K]\nOù est-il parti?", german="Was...[K] Was sollen wir tun?!?[K]\nWo ist es hingegangen?", italian="Cosa...[K] Cosa facciamo?![K]\nDov'è andato?", spanish="¿Qué...?[K] ¿Qué hacemos?[K]\n¿Adónde habrá ido?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="W-we'd better go look for\n[CS:N]Manaphy[CR]!", french="Vite... il faut qu'on retrouve\n[CS:N]Manaphy[CR]!", german="W-wir suchen besser nach\n[CS:N]Manaphy[CR]!", italian="D-D-Dobbiamo andare a cercare\n[CS:N]Manaphy[CR]!", spanish="¡Será mejor ir a buscar a\n[CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" L-let's go look for [CS:N]Manaphy[CR]!", french="Vite... il faut qu'on retrouve\n[CS:N]Manaphy[CR]!", german="L-los, suchen wir nach\n[CS:N]Manaphy[CR]!", italian=" A-A-Andiamo a cercare [CS:N]Manaphy[CR]!", spanish="¡Vamos a buscar a\n[CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" L-let's go look for [CS:N]Manaphy[CR]!", french="Vite... il faut qu'on retrouve\n[CS:N]Manaphy[CR]!", german="L-los, suchen wir nach\n[CS:N]Manaphy[CR]!", italian=" A-A-Andiamo a cercare [CS:N]Manaphy[CR]!", spanish="¡Vamos a buscar a\n[CS:N]Manaphy[CR]!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
