-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/s03p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkyProg.set(29, 49) -- $SCENARIO_MAIN = scn[29,49] (ROM)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-128), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-128), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huff-huff...", french=" Pff... pff...", german=" Hechel, hechel...", italian=" Uff-puff...", spanish=" Uf, uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huff-huff...", french=" Pff... pff...", german=" Hechel, hechel...", italian=" Uff-puff...", spanish=" Uf, uf..."})
  else
  SkySceneKit.say({english=" Huff-huff...", french=" Pff... pff...", german=" Hechel, hechel...", italian=" Uff-puff...", spanish=" Uf, uf..."})
  end
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Manaphy[CR]!", french=" Hé! [CS:N]Manaphy[CR]!", german=" Hey! [CS:N]Manaphy[CR]!", italian=" Ehi! [CS:N]Manaphy[CR]!", spanish=" ¡Oye! ¡[CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Manaphy[CR]!", french=" Hé! [CS:N]Manaphy[CR]!", german=" Hey! [CS:N]Manaphy[CR]!", italian=" Ehi! [CS:N]Manaphy[CR]!", spanish=" ¡Oye! ¡[CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" Oh! [CS:N]Manaphy[CR]!", french=" Hé! [CS:N]Manaphy[CR]!", german=" Oh! [CS:N]Manaphy[CR]!", italian=" Ehi! [CS:N]Manaphy[CR]!", spanish=" ¡Oye! ¡[CS:N]Manaphy[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(444, 204, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(444, 172, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:MoveToPosition(partner, 504, 196, false, 2)
  GROUND:MoveToPosition(hero, 476, 212, false, 2)
  GROUND:MoveToPosition(partner, 472, 156, false, 2)
  GROUND:MoveToPosition(hero, 444, 180, false, 2)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]! You had us worried!", french=" [CS:N]Manaphy[CR]! Tu nous as fait peur!", german="[CS:N]Manaphy[CR]! Wir haben uns\nSorgen gemacht!", italian="[CS:N]Manaphy[CR]! Quanto ci hai\nfatto stare in pena!", spanish="¡[CS:N]Manaphy[CR]! ¡Estábamos\npreocupados por ti!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]! You had us worried!", french=" [CS:N]Manaphy[CR]! Tu nous as fait peur!", german="[CS:N]Manaphy[CR]! Wir haben uns\nSorgen gemacht!", italian="[CS:N]Manaphy[CR]! Quanto ci hai\nfatto stare in pena!", spanish="¡[CS:N]Manaphy[CR]! ¡Estábamos\npreocupados por ti!"})
  else
  SkySceneKit.say({english="[CS:N]Manaphy[CR]! We were worried\nabout you!", french=" [CS:N]Manaphy[CR]! Tu nous as fait peur!", german="[CS:N]Manaphy[CR]! Wir haben uns\nSorgen um dich gemacht!", italian="[CS:N]Manaphy[CR]! Quanto ci hai\nfatto stare in pena!", spanish="¡[CS:N]Manaphy[CR]! ¡Nos habíamos\npreocupado muchísimo por ti!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What are you doing here\nanyway?!", french="Pourquoi tu es venu ici tout\nseul?!", german=" Was machst du eigentlich hier?", italian=" Ma cosa ci fai qui?!", spanish=" ¿Qué haces aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why did you come here by\nyourself?!", french="Pourquoi tu es venu ici tout\nseul?!", german="Warum bist du ganz allein\nhierhergekommen?!?", italian=" Ma cosa ci fai qui?!", spanish=" ¿Cómo has llegado hasta aquí?"})
  else
  SkySceneKit.say({english="Why did you decide to come\nhere by yourself?", french="Pourquoi tu es venu ici tout\nseul?!", german="Warum wolltest du ganz allein\nhierherkommen?!?", italian=" Ma cosa ci fai qui?!", spanish=" ¿Por qué has venido aquí?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [CS:N]Manaphy[CR]?", french=" Hé, [CS:N]Manaphy[CR]?", german=" Hey, [CS:N]Manaphy[CR]?", italian=" Ehi, [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [CS:N]Manaphy[CR]?", french=" Hé, [CS:N]Manaphy[CR]?", german=" Hey, [CS:N]Manaphy[CR]?", italian=" Ehi, [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english=" Hey, [CS:N]Manaphy[CR]?", french=" Hé, [CS:N]Manaphy[CR]?", german=" Hey, [CS:N]Manaphy[CR]?", italian=" Ehi, [CS:N]Manaphy[CR]?", spanish=" ¿[CS:N]Manaphy[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[CS:N]Manaphy[CR]?[K] What's wrong?", french="... [CS:N]Manaphy[CR]?[K] Qu'est-ce qui\nne va pas?", german=" ...[CS:N]Manaphy[CR]?[K] Was ist los?", italian=" ... [CS:N]Manaphy[CR]?[K] Cosa c'è?", spanish="¿[CS:N]Manaphy[CR]?[K] ¿Te encuentras\nbien?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[CS:N]Manaphy[CR]?[K] What's the matter?", french="... [CS:N]Manaphy[CR]?[K] Qu'est-ce qui\nne va pas?", german="...[CS:N]Manaphy[CR]?[K] Was stimmt\nmit dir nicht?", italian=" ... [CS:N]Manaphy[CR]?[K] Cosa c'è?", spanish="¿[CS:N]Manaphy[CR]?[K] ¿Te encuentras\nbien?"})
  else
  SkySceneKit.say({english=" ...[CS:N]Manaphy[CR]?[K] Is something wrong?", french="... [CS:N]Manaphy[CR]?[K] Qu'est-ce qui\nne va pas?", german="...[CS:N]Manaphy[CR]?[K] Stimmt irgendetwas\nnicht?", italian=" ... [CS:N]Manaphy[CR]?[K] Cosa c'è?", spanish="¿[CS:N]Manaphy[CR]?[K] ¿Te encuentras\nbien?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 448, 160, Direction.Up, "NPC_MANAFI")
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" !!! [CS:N]Manaphy[CR]!", french=" !!! [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!!!", italian=" [CS:N]Manaphy[CR]!!!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" !!! [CS:N]Manaphy[CR]!", french=" !!! [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!!!", italian=" [CS:N]Manaphy[CR]!!!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" !!! [CS:N]Manaphy[CR]!", french=" !!! [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!!!", italian=" [CS:N]Manaphy[CR]!!!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is bad, [hero]![K]\nHe's burning up with a fever!", french="C'est grave, [hero]![K]\nIl est brûlant de fièvre!", german="Das sieht nicht gut aus,\n[hero]![K] Es hat hohes Fieber!", italian="È una cosa grave,\n[hero]![K] Ha la febbre altissima!", spanish="¡No tiene buena cara,\n[hero]![K] ¡Está ardiendo!\n¡Tiene mucha fiebre!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Trouble, [hero]![K]\nHe's running a high fever!", french="C'est grave, [hero]![K]\nIl est brûlant de fièvre!", german="Schwierigkeiten, [hero]![K]\nEs leidet unter hohem Fieber!", italian="È una cosa grave,\n[hero]![K] Ha la febbre altissima!", spanish="¡Esto pinta mal, [hero]![K]\n¡Está ardiendo! ¡Tiene mucha fiebre!"})
  else
  SkySceneKit.say({english="This is bad, [hero]![K]\nHe's burning up with a fever!", french="C'est grave, [hero]![K]\nIl est brûlant de fièvre!", german="Das sieht nicht gut aus,\n[hero]![K] Es leidet unter hohem Fieber!", italian="È una cosa grave,\n[hero]![K] Ha la febbre altissima!", spanish="¡No tiene buena cara,\n[hero]![K] ¡Está ardiendo!\n¡Tiene mucha fiebre!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_manafi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]![K] Hang on, [CS:N]Manaphy[CR]!", french="[CS:N]Manaphy[CR]![K] Accroche-toi,\n[CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]![K] Durchhalten, [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]![K] Resisti, [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]![K] ¡Aguanta, [CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]![K] Hang on, [CS:N]Manaphy[CR]!", french="[CS:N]Manaphy[CR]![K] Accroche-toi,\n[CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]![K] Durchhalten, [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]![K] Resisti, [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]![K] ¡Aguanta, [CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]![K] Hold on, [CS:N]Manaphy[CR]!", french="[CS:N]Manaphy[CR]![K] Accroche-toi,\n[CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]![K] Durchhalten, [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]![K] Resisti, [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]![K] ¡Aguanta, [CS:N]Manaphy[CR]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
