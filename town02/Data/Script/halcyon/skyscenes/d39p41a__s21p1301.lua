-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D39P41A/s21p1301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(66, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D39P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1')
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(8195) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(80)
  local npc_npc_parukia = SkySceneKit.spawn_npc("palkia", 376, 240, Direction.Down, "NPC_PARUKIA")
  -- ResetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  do local p=npc_npc_parukia.Position; GROUND:MoveToPosition(npc_npc_parukia, p.X+(0), p.Y+(56), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(5128) — id SE NDS sans portage PMDO identifié
  GAME:FadeIn(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetFunctionAttribute(256) [attribut interne de l'interpréteur SSB NDS - sans objet PMDO]
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="THERE WILL BE NO MISTAKE\nTHIS TIME! I WILL FINISH YOU!", french="CETTE FOIS-CI SERA LA BONNE!\nJE VAIS EN FINIR AVEC VOUS!", german="DIESES MAL GIBT ES KEIN\nVERTUN! ICH BIN EUER ENDE!", italian="QUESTA VOLTA NON\nCOMMETTERÒ ERRORI! VI FINIRÒ!", spanish=" ¡ESTA VEZ NO HABRÁ ERRORES!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR], wait! Please!", french=" [CS:N]P-Palkia[CR], attends! S'il te plaît!", german=" [CS:N]P-Palkia[CR], warte! Bitte!", italian=" [CS:N]P-Palkia[CR], aspetta! Per favore!", spanish="¡[CS:N]Pa[CR]... [CS:N]Palkia[CR], espera!\n¡Por favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR], wait! Please!", french=" [CS:N]P-Palkia[CR], attends! S'il te plaît!", german=" [CS:N]P-Palkia[CR], warte! Bitte!", italian=" [CS:N]P-Palkia[CR], aspetta! Per favore!", spanish="¡[CS:N]Pa[CR]... [CS:N]Palkia[CR], espera!\n¡Por favor!"})
  else
  SkySceneKit.say({english=" [CS:N]P-Palkia[CR], wait! Please!", french=" [CS:N]P-Palkia[CR], attends! S'il te plaît!", german=" [CS:N]P-Palkia[CR], warte! Bitte!", italian=" [CS:N]P-Palkia[CR], aspetta! Per favore!", spanish="¡[CS:N]Pa[CR]... [CS:N]Palkia[CR], espera!\n¡Por favor!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Please tell us how we can get\nout of this place!", french=" Dis-nous comment sortir d'ici!", german="Bitte sag uns, wie wir hier\nherauskommen!", italian="Dicci come fare per uscire da\nquesto posto!", spanish="¡Dinos cómo se sale de aquí,\npor favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Please tell us how we can leave\nthis place!", french=" Dis-nous comment sortir d'ici!", german="Bitte sag uns, wie wir diesen\nOrt verlassen können!", italian="Dicci come fare per uscire da\nquesto posto!", spanish="¡Dinos cómo se sale de aquí,\npor favor!"})
  else
  SkySceneKit.say({english="Please tell us how we can leave\nthis place!", french=" Dis-nous comment sortir d'ici!", german="Bitte sag uns, wie wir diesen\nOrt verlassen können!", italian="Dicci come fare per uscire da\nquesto posto!", spanish="¡Dinos cómo se sale de aquí,\npor favor!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" HOW TO LEAVE THIS PLACE?", french=" COMMENT SORTIR D'ICI?", german=" DIESEN ORT VERLASSEN?", italian="COME USCIRE DA\nQUESTO POSTO?", spanish=" ¿CÓMO SE SALE DE AQUÍ?"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english="WHAT?![K] WHY WOULD I TELL\nYOU SUCH A THING?!", french="COMMENT?![K] POURQUOI VOUS LE\nDIRAIS-JE?!", german="WAS?!?[K] WARUM SOLLTE ICH\nEUCH DAS SAGEN?", italian="COSA?![K] PERCHÉ DOVREI\nFARLO?!", spanish="¡¿QUÉ?![K] ¡¿POR QUÉ IBA A\nDECÍROSLO?!"})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" BECAUSE...", french=" AU CONTRAIRE...", german=" DENN...", italian=" VISTO CHE...", spanish=" SI..."})
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" IT IS YOUR FATE...", french=" ... LE DESTIN VEUT...", german=" ES IST EUER SCHICKSAL...", italian=" IL VOSTRO DESTINO È...", spanish=" VUESTRO DESTINO ES..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" TO BE...[K]OBLITERATED!", french=" QUE JE VOUS...[K] ANEANTISSE!", german="HIER...[K] AUSGELÖSCHT ZU\nWERDEN!", italian=" QUELLO DI...[K] SPARIRE!", spanish=" ¡DESAPARECER!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS TIME I WILL FINISH YOU!", french=" FINISSONS-EN!", german="DIESMAL MACHE ICH EUCH\nFERTIG!", italian=" QUESTA VOLTA VI ANNIENTERÒ!", spanish=" ¡ESTA VEZ NO HABRÁ ERRORES!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_parukia) end)
  SkySceneKit.say({english=" THIS IS IT FOR YOU!", french=" C'EN EST FAIT DE VOUS!", german=" DAS WAR ES FÜR EUCH!", italian=" PER VOI È LA FINE!", spanish=" ¡AQUÍ SE ACABA TODO!"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
