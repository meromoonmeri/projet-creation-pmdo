-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/s23p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 656, 196, false, 2)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 776, 232, Direction.Left, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 672, 228, false, 2)
  GROUND:MoveToPosition(hero, 688, 212, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(456, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 504, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 512, 228, false, 2)
  GROUND:MoveToPosition(hero, 520, 212, false, 2)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 400, 176, Direction.Up, "NPC_MANAFI")
  GROUND:EntTurn(npc_npc_manafi, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(60)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-24), g.ViewCenter.Y+(0), 81, false) end) -- MovePositionOffset performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-24), p.Y+(-24), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-30), p.Y+(-16), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-24), p.Y+(-12), false, 1) end -- Move2PositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]...", french=" [CS:N]Manaphy[CR]...", german=" [CS:N]Manaphy[CR]...", italian=" [CS:N]Manaphy[CR]...", spanish=" [CS:N]Manaphy[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]...", french=" [CS:N]Manaphy[CR]...", german=" [CS:N]Manaphy[CR]...", italian=" [CS:N]Manaphy[CR]...", spanish=" [CS:N]Manaphy[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]...", french=" [CS:N]Manaphy[CR]...", german=" [CS:N]Manaphy[CR]...", italian=" [CS:N]Manaphy[CR]...", spanish=" [CS:N]Manaphy[CR]..."})
  end
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" [hero]...[K] [partner]...", french=" [hero]...[K] [partner]...", german=" [hero]...[K] [partner]...", italian=" [hero]...[K] [partner]...", spanish=" [hero]...[K] [partner]..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR]!", french=" [CS:N]Manaphy[CR]!", german=" [CS:N]Manaphy[CR]!", italian=" [CS:N]Manaphy[CR]!", spanish=" ¡[CS:N]Manaphy[CR]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 448, 172, false, 2)
  GROUND:MoveToPosition(hero, 448, 196, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 436, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_manafi, 424, 184, false, 2)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're really...[K]that little\n[CS:N]Manaphy[CR]?", french="C'est vraiment toi...[K] notre petit\n[CS:N]Manaphy[CR]?", german="Du bist wirklich...[K] das kleine\n[CS:N]Manaphy[CR]?", italian="Sei davvero...[K] il nostro piccolo\n[CS:N]Manaphy[CR]?", spanish="Eres realmente...[K] ¿el pequeño\n[CS:N]Manaphy[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're really...[K]that little\n[CS:N]Manaphy[CR]?", french="C'est vraiment toi...[K] notre petit\n[CS:N]Manaphy[CR]?", german="Du bist wirklich...[K] das kleine\n[CS:N]Manaphy[CR]?", italian="Sei davvero...[K] il nostro piccolo\n[CS:N]Manaphy[CR]?", spanish="Eres realmente...[K] ¿el pequeño\n[CS:N]Manaphy[CR]?"})
  else
  SkySceneKit.say({english="You're really...[K]that little\n[CS:N]Manaphy[CR]?", french="C'est vraiment toi...[K] notre petit\n[CS:N]Manaphy[CR]?", german="Du bist wirklich...[K] das kleine\n[CS:N]Manaphy[CR]?", italian="Sei davvero...[K] il nostro piccolo\n[CS:N]Manaphy[CR]?", spanish="Eres realmente...[K] ¿el pequeño\n[CS:N]Manaphy[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Yup, yup!", french=" Ouaip ouaip!", german=" Jep, jep!", italian=" Sì, sì!", spanish=" ¡Sí, sí!"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" I grew big in the sea!", french="J'ai beaucoup grandi dans\nla mer!", german=" Ich bin groß geworden im Meer!", italian=" Sono cresciuto nel mare!", spanish=" ¡En el mar me he hecho mayor!"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="It's all...[K] It's all because of you,\n[hero] and [partner]!", french="Je...[K] je vous dois tout,\n[hero] et [partner]!", german="Das habe...[K] Das habe ich alles\neuch zu verdanken, [hero] und\n[partner]!", italian="È tutto...[K] È tutto merito\nvostro, [hero] e [partner]!", spanish="Y todo...[K] Todo gracias a vuestros\ncuidados, [hero] y [partner]."})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh![K] You remembered us!", french=" Oh![K] Tu t'es souvenu de nous!", german=" Oh![K] Du erinnerst dich an uns!", italian=" Oh![K] Ti ricordi di noi!", spanish=" ¡Oh![K] ¡Nos recuerdas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh![K] You remembered us!", french=" Oh![K] Tu t'es souvenu de nous!", german=" Oh![K] Du erinnerst dich an uns!", italian=" Oh![K] Ti ricordi di noi!", spanish=" ¡Oh![K] ¡Nos recuerdas!"})
  else
  SkySceneKit.say({english=" Oh![K] You remembered us!", french=" Oh![K] Tu t'es souvenu de nous!", german=" Oh![K] Du erinnerst dich an uns!", italian=" Oh![K] Ti ricordi di noi!", spanish=" ¡Oh![K] ¡Nos recuerdas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Of course! I didn't forget you!", french="Bien sûr, je ne pouvais pas vous\noublier!", german="Natürlich habe ich euch nicht\nvergessen!", italian=" Certo che mi ricordo!", spanish=" ¡Claro que os recuerdo!"})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Not once...[K] Not ever...", french=" Jamais...[K] de la vie...", german="Nicht ein einziges Mal...[K]\nNiemals...", italian=" Sempre!", spanish=" Nunca...[K] os olvidaré..."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" I missed you!", french=" Vous m'avez tellement manqué!", german=" Ich habe euch vermisst!", italian=" Ho sentito la vostra mancanza!", spanish=" ¡Os he echado de menos!"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(0), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
end
