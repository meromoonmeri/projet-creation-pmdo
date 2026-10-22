-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P44A/s04p1901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D32P44A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- Destroy() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_rejigigasu = SkySceneKit.spawn_npc("regigigas", 304, 208, Direction.Down, "NPC_REJIGIGASU")
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(300, 308, 60, false) end) -- performer/caméra
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 232, 280, Direction.UpRight, "NPC_MIMIROPPU")
  -- SetAnimation(5) [anim idle native]
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 256, 288, Direction.UpRight, "NPC_SAANAITO")
  -- SetAnimation(5) [anim idle native]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 208, 288, Direction.UpRight, "NPC_CHAAREMU")
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  -- GAP: se_Play(6918) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" We did it!", french=" On a réussi!", german=" Wir haben es geschafft!", italian=" Ce l'abbiamo fatta!", spanish=" ¡Lo logramos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A2_85) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Wh-what is this?!", french=" Qu... qu'est-ce que c'est?!", german=" W-was ist das?!?", italian=" C-Cos'è?!", spanish=" ¡¿Qué es esto?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-5, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="There's an inscription on the\nstone marker!", french="Il y a une inscription sur la\nstèle!", german="Da ist eine Inschrift auf dem\nSteinwegweiser!", italian=" C'è un'iscrizione sulla Stele!", spanish=" ¡Hay una inscripción en la losa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 300, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CN][player] checked\n[CN]the stone marker.", french="[CN][player] examine\n[CN]la stèle.", german="[CN][player] prüft\n[CN]den Steinwegweiser.", italian="[CN][player] controlla\n[CN]la Stele.", spanish="[CN][player] miró la losa."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CN]\"Close your eyes, then let your\n[CN]aura flow into the ground.\"", french="[CN]\"Fermez les yeux et laissez votre aura\n[CN]s'écouler dans le sol.\"", german="[CN][F:S2]Schließ deine Augen und lass\n[CN]deine Aura in den Boden fließen.[F:E2]", italian="[CN]\"Chiudete gli occhi e fate\n[CN]scorrere la vostra aura sul pavimento.\"", spanish="[CN]\"Cierra los ojos y deja que\n[CN]tu aura fluya hacia el suelo.\""})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_2 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="[CN]Will you close your eyes?", french="[CN]Voulez-vous fermer les yeux?", german="[CN]Willst du deine Augen schließen?", italian="[CN]Vuoi chiudere gli occhi?", spanish="[CN]¿Vas a cerrar los ojos?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Now, hold on![K] You're not about\nto get cold feet now!", french="Hé attendez![K] Vous n'allez pas\njouer les poules mouillées maintenant!", german="Warte mal![K] Du wirst doch\njetzt keine kalten Füße bekommen!", italian="Adesso tenete duro![K] Non dovete\ncedere alla paura proprio ora!", spanish="¡Vamos, aguanta![K]\n¡Ahora no puedes echarte atrás!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  end
  end
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN][player] did as instructed.", french="[CN][player] suit les instructions.", german="[CN][player] folgt den Anweisungen.", italian="[CN][player] segue le istruzioni.", spanish="[CN][player] siguió las instrucciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7948) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(180)
  -- se_FadeOut(7948, 15) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(15)
  -- GAP: se_Play(7950) — id SE NDS sans portage PMDO identifié
  -- GAP: SetEffect 644 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="[CN]And [player]'s aura spread to the ground!", french="[CN]Et l'aura de [player]\n[CN]s'écoule dans le sol!", german="[CN]Und die Aura von [player]\n[CN]überträgt sich auf den Boden!", italian="[CN]E la sua aura si spande sul pavimento!", spanish="[CN]¡Y el aura de [player] se extendió\n[CN]por la superficie!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  SkySceneKit.say({english="[CN]GZZZ... GZZZZ...", french="[CN]GZZZ... GZZZZ...", german="[CN]GZZZ... GZZZZ...", italian="[CN]GZZZ... GZZZZ...", spanish="[CN]GZZZ... GZZZZ..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(15)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-40), 20, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:N]Regigigas[CR]!", french=" [CS:N]Regigigas[CR]!", german=" [CS:N]Regigigas[CR]!", italian=" [CS:N]Regigigas[CR]!", spanish=" ¡[CS:N]Regigigas[CR]!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" We're in for another round?", french=" C'est reparti pour un tour?", german="Müssen wir noch mal mit dir\nkämpfen?", italian=" Dobbiamo lottare un'altra volta?", spanish=" ¡Preparaos para otro asalto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7950, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_rejigigasu) end)
  SkySceneKit.say({english=" GRRRROOOOHHHH!", french=" GRRRROOOOHHHH!", german=" GRRRROOOOHHHH!", italian=" GRRRROOOOHHHH!", spanish=" GRRRRR..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  -- GAP: se_Play(7953) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  SkySceneKit.say({english="Gzzzz...ummmm...mmmm...", french="Gzzzz... hmmmm... mmmm...", german="Gzzzz...ummmm...mmmm...", italian="Gzzzz... Uhm... Mmmm... ", spanish="PLAAAAAF..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(40)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5131) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GAME:WaitFrames(60)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_CloseEnforce
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(40), 20, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  SkySceneKit.say({english="GRRRRR...OOOOHHHH...OOOOHHHH!", french="GRRRRR... OOOOHHHH... OOOOHHHH!", german="GRRRRR...OOOOHHHH...OOOOHHHH!", italian="GRRRRR... OOOOHHHH... OOOOHHHH!", spanish="GRRRRR... GRRRRR... GRRRRR..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(120)
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- bgm2_PlayFadeIn(BGM_EARTHQUAKE3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Wa-wa-waaah!", french=" Waaaaaaaaah!", german=" Ua-aa-waaah!", italian=" Wa-wa-waaah!", spanish=" ¡Aaaah!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-5, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Hurry, we have to get out!", french="Dépêchons-nous, nous devons\nsortir d'ici!", german=" Schnell, wir müssen hier raus!", italian=" Forza, dobbiamo andarcene!", spanish=" ¡Rápido, hay que salir de aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(0), p.Y+(160), false, 2) end
  do local p=npc_npc_saanaito.Position; GROUND:MoveToPosition(npc_npc_saanaito, p.X+(0), p.Y+(160), false, 2) end
  do local p=npc_npc_chaaremu.Position; GROUND:MoveToPosition(npc_npc_chaaremu, p.X+(0), p.Y+(160), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(160), false, 2) end
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(160), false, 2) end
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(160), false, 2) end
  do local p=SkySceneKit.team_member(3).Position; GROUND:MoveToPosition(SkySceneKit.team_member(3), p.X+(0), p.Y+(160), false, 2) end
  GAME:WaitFrames(60)
  -- se_FadeOut(5131, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(45)
  SkySceneKit.cleanup_npcs()
end
