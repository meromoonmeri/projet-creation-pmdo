-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/s03p0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.ATTENDANT2_KIND = 0 -- $ATTENDANT2_KIND = 0 (ROM)
  SkyProg.set(29, 47) -- $SCENARIO_MAIN = scn[29,47] (ROM)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-140), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-140), p.Y+(0), false, 2) end
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 784, 208, Direction.Left, "NPC_MANAFI")
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-80), p.Y+(0), false, 1) end
  GROUND:EntTurn(partner, Direction.Right)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Come on, [CS:N]Manaphy[CR]. Over here.", french=" Viens, [CS:N]Manaphy[CR]. Par ici.", german="Komm schon, [CS:N]Manaphy[CR].\nHier drüben.", italian=" Forza, [CS:N]Manaphy[CR]. Di qua.", spanish=" Vamos, [CS:N]Manaphy[CR]. Por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Come on, [CS:N]Manaphy[CR]. Over here.", french=" Viens, [CS:N]Manaphy[CR]. Par ici.", german="Komm schon, [CS:N]Manaphy[CR].\nHier drüben.", italian=" Forza, [CS:N]Manaphy[CR]. Di qua.", spanish=" Vamos, [CS:N]Manaphy[CR]. Por aquí."})
  else
  SkySceneKit.say({english=" Come on, [CS:N]Manaphy[CR]. Over here.", french=" Viens, [CS:N]Manaphy[CR]. Par ici.", german="Komm schon, [CS:N]Manaphy[CR].\nHier drüben.", italian=" Forza, [CS:N]Manaphy[CR]. Di qua.", spanish=" Vamos, [CS:N]Manaphy[CR]. Por aquí."})
  end
  GROUND:EntTurn(hero, Direction.Right)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(504, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 528, 196, false, 2)
  GROUND:MoveToPosition(hero, 528, 212, false, 2)
  GROUND:MoveToPosition(npc_npc_manafi, 528, 204, false, 2)
  GROUND:MoveToPosition(partner, 480, 164, false, 2)
  GROUND:MoveToPosition(hero, 480, 188, false, 2)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" !!!", french=" !!!", german=" !!!", italian=" !!!", spanish=" (!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(504, 184, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_manafi, 528, 164, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Kyakya! ♪ Kyakya! ♪", french=" Hi hi hi hi hi! ♪ Kyakya! ♪", german=" Kyakya! ♪ Kyakya! ♪", italian=" Kyakya! ♪ Kyakya! ♪", spanish=" ¡Kyakya! ♪ ¡Kyakya! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Manaphy[CR], this is the sea. Sea...", french=" [CS:N]Manaphy[CR], c'est la mer. La mer...", german="[CS:N]Manaphy[CR], das ist das Meer.\nMeer...", italian=" [CS:N]Manaphy[CR], questo è il mare...", spanish="[CS:N]Manaphy[CR], esto es el mar.\nEl mar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Manaphy[CR], this is the sea. Sea...", french=" [CS:N]Manaphy[CR], c'est la mer. La mer...", german="[CS:N]Manaphy[CR], das ist das Meer.\nMeer...", italian=" [CS:N]Manaphy[CR], questo è il mare...", spanish="[CS:N]Manaphy[CR], esto es el mar.\nEl mar..."})
  else
  SkySceneKit.say({english=" [CS:N]Manaphy[CR], this is the sea. Sea...", french=" [CS:N]Manaphy[CR], c'est la mer. La mer...", german="[CS:N]Manaphy[CR], das ist das Meer.\nMeer...", italian=" [CS:N]Manaphy[CR], questo è il mare...", spanish="[CS:N]Manaphy[CR], esto es el mar.\nEl mar..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_manafi, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Sea?", french=" Mer?", german=" Meer?", italian=" Mare?", spanish=" ¿Mar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's right, sea.[K] That's where\nyou came from.", french="C'est ça, la mer.[K] C'est de là\nque tu viens.", german="Jawohl, das Meer.[K] Dort kommst\ndu her.", italian="Esatto, mare.[K] È da lì che vieni\ntu.", spanish="Sí, el mar.[K] De ahí es de donde\nhas venido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's right, sea.[K] That's where\nyou came from.", french="C'est ça, la mer.[K] C'est de là\nque tu viens.", german="Jawohl, das Meer.[K] Dort kommst\ndu her.", italian="Esatto, mare.[K] È da lì che vieni\ntu.", spanish="Sí, el mar.[K] De ahí es de donde\nhas venido."})
  else
  SkySceneKit.say({english="That's right, sea.[K] That's where\nyou came from.", french="C'est ça, la mer.[K] C'est de là\nque tu viens.", german="Jawohl, das Meer.[K] Dort kommst\ndu her.", italian="Esatto, mare.[K] È da lì che vieni\ntu.", spanish="Sí, el mar.[K] De ahí es de donde\nhas venido."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Sea! Sea!", french=" La mer! La mer!", german=" Meer! Meer!", italian=" Mare! Mare!", spanish=" ¡Mar! ¡Mar!"})
  -- message_Close
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-28), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" [partner]! ♪", french=" [partner]! ♪", german=" [partner]! ♪", italian=" [partner]! ♪", spanish=" ¡[partner]! ♪"})
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-8), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(partner, Direction.Up)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_manafi, Direction.DownRight)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-12), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GROUND:EntTurn(partner, Direction.Left)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.UpRight)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" [hero]! ♪", french=" [hero]! ♪", german=" [hero]! ♪", italian=" [hero]! ♪", spanish=" ¡[hero]! ♪"})
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.DownLeft)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  GROUND:EntTurn(hero, Direction.Right)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(12), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.UpLeft)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-8), p.Y+(8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  GROUND:EntTurn(hero, Direction.Down)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.UpRight)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(-8), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Right)
  GROUND:EntTurn(hero, Direction.Left)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.DownRight)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(8), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(24), p.Y+(0), false, 2) end
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Sea! Sea!", french=" La mer! La mer!", german=" Meer! Meer!", italian=" Mare! Mare!", spanish=" ¡Mar! ¡Mar!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ha, [hero].[K] [CS:N]Manaphy[CR]\nseems to be really happy.", french="Ha, [hero].[K] [CS:N]Manaphy[CR]\na l'air vraiment heureux.", german="Ha, [hero].[K] [CS:N]Manaphy[CR]\nscheint wirklich glücklich zu sein.", italian="Ah, [hero].[K] [CS:N]Manaphy[CR]\nsembra davvero contento.", spanish="Bueno, [hero].\nAl parecer...[K] [CS:N]Manaphy[CR] está muy contento."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ha, [hero].[K] [CS:N]Manaphy[CR]'s\nreally happy.", french="Ha, [hero].[K] [CS:N]Manaphy[CR]\na l'air vraiment heureux.", german="Ha, [hero].[K] [CS:N]Manaphy[CR]\nist wirklich glücklich.", italian="Ah, [hero].[K] [CS:N]Manaphy[CR]\nsembra davvero contento.", spanish="Bueno, [hero].\nAl parecer...[K] [CS:N]Manaphy[CR] está muy contento."})
  else
  SkySceneKit.say({english="Ha, [hero].[K] [CS:N]Manaphy[CR]'s\nreally happy to be here.", french="Ha, [hero].[K] [CS:N]Manaphy[CR]\na l'air vraiment heureux.", german="Ha, [hero].[K] [CS:N]Manaphy[CR]\nist wirklich glücklich.", italian="Ah, [hero].[K] [CS:N]Manaphy[CR]\nsembra davvero contento.", spanish="Bueno, [hero].\nAl parecer...[K] [CS:N]Manaphy[CR] está muy contento."})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm glad we brought him down to\nthe beach.", french="On a bien fait de l'emmener\nà la plage.", german="Ich bin froh, dass wir es zum\nStrand mitgenommen haben.", italian="Abbiamo fatto bene a portarlo\nin spiaggia.", spanish="Me alegro de haberle traído a la\nplaya."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's great we brought him down\nto the beach.", french="On a bien fait de l'emmener\nà la plage.", german="Ich bin froh, dass wir es zum\nStrand mitgenommen haben.", italian="Abbiamo fatto bene a portarlo\nin spiaggia.", spanish="Me alegro de haberle traído a la\nplaya."})
  else
  SkySceneKit.say({english="I'm glad we brought him down to\nthe beach.", french="On a bien fait de l'emmener\nà la plage.", german="Ich bin froh, dass wir es zum\nStrand mitgenommen haben.", italian="Abbiamo fatto bene a portarlo\nin spiaggia.", spanish="Me alegro de haberle traído a la\nplaya."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Sea! ♪ Sea! ♪", french=" La mer! ♪ La mer! ♪", german=" Meer! ♪ Meer! ♪", italian=" Mare! ♪ Mare! ♪", spanish=" ¡Mar! ♪ ¡Mar! ♪"})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GROUND:EntTurn(npc_npc_manafi, Direction.Down)
  GROUND:EntTurn(npc_npc_manafi, Direction.Up)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() SOUND:FadeOutBGM(180) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN]And so [CS:N]Manaphy[CR], [hero], and\n[CN][partner] played until sunset.", french="[CN]Et c'est ainsi que [CS:N]Manaphy[CR], [hero] et\n[CN][partner] jouèrent jusqu'au crépuscule.", german="[CN]Und so spielten [CS:N]Manaphy[CR], [hero] und\n[CN][partner], bis die Sonne unterging.", italian="[CN][CS:N]Manaphy[CR], [hero] e\n[CN][partner] giocano fino al tramonto.", spanish="[CN]Y [CS:N]Manaphy[CR], [hero] y\n[CN][partner] jugaron hasta el atardecer."})
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english="[CN]That night...", french="[CN]Cette nuit-là...", german="[CN]In dieser Nacht...", italian="[CN]Quella notte...", spanish="[CN]Esa noche..."})
  -- message_Close
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
