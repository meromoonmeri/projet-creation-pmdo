-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D05P31A/m07a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(7, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(8, 3) -- $SCENARIO_MAIN = scn[8,3] (ROM)
  -- back_SetGround(LEVEL_D05P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 256, 380, false, 2)
  GROUND:MoveToPosition(hero, 296, 380, false, 2)
  GAME:WaitFrames(15)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 420, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 308, 420, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is the deepest point in\n[CS:P]Apple Woods[CR], right?", french="Nous voilà au cœur du [CS:P]Bois\naux Pommes[CR], n'est-ce pas?", german="Dies ist der tiefste Punkt im\n[CS:P]Apfelwald[CR], oder?", italian="Questo è il cuore del\n[CS:P]Giardino dei Meli[CR], giusto?", spanish="Este es el lugar más profundo\ndel [CS:P]Manzanar[CR], ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is the farthest you can go\nin [CS:P]Apple Woods[CR], isn't it?", french="Nous voilà au cœur du [CS:P]Bois\naux Pommes[CR], n'est-ce pas?", german="Weiter als bis hier kann man\nim [CS:P]Apfelwald[CR] nicht gehen, oder?", italian="Questo è il cuore del\n[CS:P]Giardino dei Meli[CR], giusto?", spanish="Este es el lugar más profundo\ndel [CS:P]Manzanar[CR], ¿verdad?"})
  else
  SkySceneKit.say({english="This is the deepest point in\n[CS:P]Apple Woods[CR], isn't it?", french="Nous voilà au cœur du [CS:P]Bois\naux Pommes[CR], n'est-ce pas?", german="Dies ist der tiefste Punkt im\n[CS:P]Apfelwald[CR], oder?", italian="Questo è il cuore del\n[CS:P]Giardino dei Meli[CR], giusto?", spanish="Este es el lugar más profundo\ndel [CS:P]Manzanar[CR], ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="According to [CS:N]Chatot[CR], the Perfect\nApples should be around here somewhere...", french="Selon [CS:N]Pijako[CR], les Pommes\nParfaites devraient se trouver quelque part\npar ici...", german="Laut [CS:N]Plaudagei[CR] müssten die\nPerfekten Äpfel hier irgendwo sein.", italian="Secondo [CS:N]Chatot[CR], le Mele Perfette\ndovrebbero essere qui da qualche parte...", spanish="Según [CS:N]Chatot[CR], las Manzanas\nPerfectas tendrían que estar por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="According to [CS:N]Chatot[CR], the Perfect\nApples should be around here somewhere...", french="Selon [CS:N]Pijako[CR], les Pommes\nParfaites devraient se trouver quelque part\npar ici...", german="Laut [CS:N]Plaudagei[CR] müssten die\nPerfekten Äpfel hier irgendwo sein.", italian="Secondo [CS:N]Chatot[CR], le Mele Perfette\ndovrebbero essere qui da qualche parte...", spanish="Según [CS:N]Chatot[CR], las Manzanas\nPerfectas tendrían que estar por aquí."})
  else
  SkySceneKit.say({english="According to [CS:N]Chatot[CR], the Perfect\nApples should be around here...", french="Selon [CS:N]Pijako[CR], les Pommes\nParfaites devraient se trouver quelque part\npar ici...", german="Laut [CS:N]Plaudagei[CR] müssten die\nPerfekten Äpfel hier sein.", italian="Secondo [CS:N]Chatot[CR], le Mele Perfette\ndovrebbero essere qui da qualche parte...", spanish="Según [CS:N]Chatot[CR], las Manzanas\nPerfectas tendrían que estar por aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [hero], over there!", french="Hé! Regarde là-bas,\n[hero]!", german=" Hey! [hero], da!", italian="Ehi! [hero], da quella\nparte!", spanish=" ¡Mira! [hero], ¡allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! [hero], look there!", french="Hé! Regarde là-bas,\n[hero]!", german=" Oh! [hero], sieh mal da!", italian="Ehi! [hero], da quella\nparte!", spanish=" ¡Oh! [hero], ¡mira!"})
  else
  SkySceneKit.say({english=" Oh! [hero], look there!", french="Hé! Regarde là-bas,\n[hero]!", german=" Oh! [hero], sieh mal da!", italian="Ehi! [hero], da quella\nparte!", spanish=" ¡Oh! [hero], ¡fíjate!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hanging on that humongous\ntree...", french=" Sur cet arbre immense...", german="Was da an diesem riesengroßen\nBaum hängt...", italian=" Su quell'albero enorme...", spanish=" En ese árbol inmenso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hanging on that huge tree...", french=" Sur cet arbre immense...", german="Was da an diesem riesigen\nBaum hängt...", italian=" Su quell'albero enorme...", spanish=" En ese árbol inmenso..."})
  else
  SkySceneKit.say({english="Hanging on that humongous\ntree...", french=" Sur cet arbre immense...", german="Was da an diesem riesengroßen\nBaum hängt...", italian=" Su quell'albero enorme...", spanish=" En ese árbol inmenso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Those must be Perfect Apples.", french="... ce sont sûrement des\nPommes Parfaites.", german="Das müssen Perfekte Äpfel\nsein.", italian="Quelle devono essere Mele\nPerfette.", spanish="¡Ahí deben de estar\nlas Manzanas Perfectas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Those must be Perfect Apples.", french="... ce sont sûrement des\nPommes Parfaites.", german="Das müssen Perfekte Äpfel\nsein.", italian="Quelle devono essere Mele\nPerfette.", spanish="¡Ahí deben de estar\nlas Manzanas Perfectas!"})
  else
  SkySceneKit.say({english=" Those must be Perfect Apples.", french="... ce sont sûrement des\nPommes Parfaites.", german="Das müssen Perfekte Äpfel\nsein.", italian="Quelle devono essere Mele\nPerfette.", spanish="¡Ahí deben de estar\nlas Manzanas Perfectas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 140, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(276, 260, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 256, 268, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 296, 268, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 276, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 308, 324, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, then... How should we\nget those Perfect Apples?", french="Bon... comment est-ce qu'on va\ns'y prendre pour les cueillir?", german="Also gut. Wie sollen wir an\ndiese Perfekten Äpfel herankommen?", italian="Va bene... Come facciamo a\nprendere quelle Mele Perfette?", spanish="Bueno... ¿Y ahora cómo nos\nhacemos con esas Manzanas Perfectas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right, then... How should we\nget those Perfect Apples?", french="Bon... comment est-ce qu'on va\ns'y prendre pour les cueillir?", german="Also gut. Wie sollen wir an\ndiese Perfekten Äpfel herankommen?", italian="Va bene... Come facciamo a\nprendere quelle Mele Perfette?", spanish="Bueno... ¿Y ahora cómo nos\nhacemos con esas Manzanas Perfectas?"})
  else
  SkySceneKit.say({english="All right, then... How should we\nget those Perfect Apples?", french="Bon... comment est-ce qu'on va\ns'y prendre pour les cueillir?", german="Also gut. Wie sollen wir an\ndiese Perfekten Äpfel herankommen?", italian="Va bene... Come facciamo a\nprendere quelle Mele Perfette?", spanish="Bueno... ¿Y ahora cómo nos\nhacemos con esas Manzanas Perfectas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Chaw-haw-haw! Easily done!", french=" Gnark gnark gnark! Fastoche!", german=" Cha-ha-ha! Kinderleicht!", italian=" Ahr-ahr-ahr! È piuttosto facile!", spanish=" ¡Jua, jua, jua! Nosotros nos ocuparemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who said that?!", french=" Qui a dit ça?!", german=" Wer hat das gesagt?!?", italian=" Chi ha parlato?!", spanish=" ¡¿Quién ha dicho eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who said that?!", french=" Qui a dit ça?!", german=" Wer hat das gesagt?!?", italian=" Chi ha parlato?!", spanish=" ¡¿Quién ha dicho eso?!"})
  else
  SkySceneKit.say({english=" Who said that?!", french=" Qui a dit ça?!", german=" Wer hat das gesagt?!?", italian=" Chi ha parlato?!", spanish=" ¡¿Quién ha dicho eso?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Chaw-haw-haw!", french=" Gnark gnark gnark!", german=" Cha-ha-ha!", italian=" Ahr-ahr-ahr!", spanish=" ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(276, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(10)
  -- GAP: se_Play(6662) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D05P31A1_20) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  -- se_Stop(6662) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetOutputAttribute(2) [neutre/état moteur]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GAME:MoveCamera(276, 284, 60, false) end) -- performer/caméra
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 280, 144, Direction.Down, "NPC_SUKATANKU")
  -- SetAnimation(43) [anim idle native]
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 260, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(10)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 280, 120, Direction.Down, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 284, 228, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 248, 136, Direction.Down, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 244, 236, false, 2)
  GAME:WaitFrames(10)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(hero, 296, 296, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 256, 296, false, 2) -- SlidePositionMark (glissement)
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- GAP: se_Play(5124) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_zubatto, 304, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 248, 244, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?! You!", french=" Quoi?! Vous!", german=" Was?!? Ihr!", italian=" Cosa?! Voi!", spanish=" ¡¿Cómo?! ¡Vosotros!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?! You!", french=" Quoi?! Vous!", german=" Was?!? Ihr!", italian=" Cosa?! Voi!", spanish=" ¡¿Qué?! ¡Vosotros!"})
  else
  SkySceneKit.say({english=" What?! You!", french=" Quoi?! Vous!", german=" Was?!? Ihr!", italian=" Cosa?! Voi!", spanish=" ¡¿Cómo?! ¡Vosotros!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw! Team [CS:X]Skull[CR] at\nyour service!", french="Gnark gnark gnark! Equipe\n[CS:X]Crâne[CR], pour vous desservir!", german="Cha-ha-ha! Team [CS:X]Totenkopf[CR] zu\neuren Diensten!", italian="Ahr-ahr-ahr! Team [CS:X]Teschio[CR] al\nvostro servizio!", spanish="¡Jua, jua, jua! ¡Aquí está el\n[CS:X]Equipo Calavera[CR], para serviros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh. Hey, it's wimpy and\ncompany. What took you so long?", french="Hin hin! Tiens, voilà le club des\npoules mouillées. Vous en avez mis du temps.", german="Hehe. Hey, es ist die Memme\nund ihr Anhängsel. Wieso habt ihr so\nlange gebraucht?", italian="Eh-eh. Ehi, sono le mezze\ncalzette. Come mai ci avete messo così\ntanto?", spanish="¡Jue, jue...! Eh, enclenque y\ncompañía... ¿Por qué habéis tardado tanto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="We've been having us a picnic\nof Perfect Apples while waiting for you\nto show.", french="On s'est fait un petit pique-nique\nde Pommes Parfaites en vous attendant.", german="Wir haben uns ein paar Perfekte\nÄpfel genehmigt, während wir auf euch\ngewartet haben.", italian="Abbiamo fatto un bel picnic\na base di Mele Perfette mentre vi\naspettavamo.", spanish="Hemos estado dándonos un\nbanquete de Manzanas Perfectas mientras\nos esperábamos."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" What took you so long?", french="Vous êtes en retard pour\nla dégustation, vous savez!", german="Warum habt ihr so lange\ngebraucht?", italian=" Come mai ci avete messo tanto?", spanish=" ¡Pues sí que habéis tardado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Coooosa?!", spanish=" ¡¿Quéeee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Coooosa?!", spanish=" ¡¿Quéeee?!"})
  else
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoi?!", german=" Waaaas?!?", italian=" Coooosa?!", spanish=" ¡¿Quéeee?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho! You took so long, I\nstuffed myself![K] Buuurp!", french="Mouarf mouarf mouarf! Le\ntemps que vous arriviez, je me suis\ngoinfré![K] Buuurp!", german="Whoahoho! Ihr habt so lange\ngebraucht, dass ich mich völlig überfressen\nhabe![K] Rüüülps!", italian="Uooh-ho-ho! Ci avete impiegato\ntalmente tanto tempo che nel frattempo mi\nsono fatto un'abbuffata![K] Buuurp!", spanish="¡Jo, jo, jo! ¡Habéis tardado tanto\nque me he dado un buen atracón![K] ¡Buuurp!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're saying they ate the\nPerfect Apples, [hero].", french="Ils disent qu'ils ont mangé\nles Pommes Parfaites, [hero].", german="Sie haben gesagt, dass sie die\nPerfekten Äpfel aufgegessen haben,\n[hero].", italian="Stanno dicendo che hanno\nmangiato le Mele Perfette, [hero].", spanish="¡No me lo puedo creer! Se han\ncomido las Manzanas Perfectas, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They're saying they ate the\nPerfect Apples, [hero].", french="Ils disent qu'ils ont mangé\nles Pommes Parfaites, [hero].", german="Sie haben gesagt, dass sie die\nPerfekten Äpfel aufgegessen haben,\n[hero].", italian="Stanno dicendo che hanno\nmangiato le Mele Perfette, [hero].", spanish="¡No me lo puedo creer! Se han\ncomido las Manzanas Perfectas, [hero]."})
  else
  SkySceneKit.say({english="They're saying they ate the\nPerfect Apples, [hero].", french="Ils disent qu'ils ont mangé\nles Pommes Parfaites, [hero].", german="Sie haben gesagt, dass sie die\nPerfekten Äpfel aufgegessen haben,\n[hero].", italian="Stanno dicendo che hanno\nmangiato le Mele Perfette, [hero].", spanish="¡No me lo puedo creer! Se han\ncomido las Manzanas Perfectas, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But there are still a few left up\non the tree.", french="Mais il en reste quelques-unes\ndans l'arbre.", german="Aber ganz oben im Baum sind\nnoch ein paar.", italian="Ma ce n'è ancora qualcuna\nsull'albero.", spanish="Pero aún queda alguna en\nel árbol."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But there are still several left\non the tree.", french="Mais il en reste quelques-unes\ndans l'arbre.", german="Aber ganz oben im Baum sind\nnoch welche.", italian="Ma ce n'è ancora qualcuna\nsull'albero.", spanish="Pero aún queda alguna en\nel árbol."})
  else
  SkySceneKit.say({english="But there are still a few left on\nthe tree.", french="Mais il en reste quelques-unes\ndans l'arbre.", german="Aber ganz oben im Baum sind\nnoch ein paar.", italian="Ma ce n'è ancora qualcuna\nsull'albero.", spanish="Pero aún queda alguna en\nel árbol."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's knock those creeps out and\ntake home some Perfect Apples.", french="Donnons une raclée à ces sales\ntypes et rapportons des Pommes Parfaites à\nla Guilde.", german="Lass uns diese Widerlinge aus\ndem Weg räumen und ein paar von den\nPerfekten Äpfeln mitnehmen.", italian="Mettiamo KO questi brutti ceffi\ne torniamo alla Gilda con le Mele Perfette.", spanish="Vamos a darle lo suyo a\nestos granujas y consigamos alguna\nManzana Perfecta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's knock those creeps out and\ntake home some Perfect Apples.", french="Donnons une raclée à ces sales\ntypes et rapportons des Pommes Parfaites à\nla Guilde.", german="Lass uns diese Widerlinge aus\ndem Weg räumen und ein paar von den\nPerfekten Äpfeln mitnehmen.", italian="Mettiamo KO questi brutti ceffi\ne torniamo alla Gilda con le Mele Perfette.", spanish="Vamos a darle lo suyo a\nestos granujas y consigamos alguna\nManzana Perfecta."})
  else
  SkySceneKit.say({english="Let's knock those creeps out and\ntake home some Perfect Apples.", french="Donnons une raclée à ces sales\ntypes et rapportons des Pommes Parfaites à\nla Guilde.", german="Lass uns diese Widerlinge aus\ndem Weg räumen und ein paar von den\nPerfekten Äpfeln mitnehmen.", italian="Mettiamo KO questi brutti ceffi\ne torniamo alla Gilda con le Mele Perfette.", spanish="Vamos a darle lo suyo a\nestos granujas y consigamos alguna\nManzana Perfecta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw. Knock us out?\nThat's very rude of you!", french="Gnark gnark gnark! Nous mettre\nune raclée? Vous êtes de vraies brutes,\nma parole!", german="Cha-ha-ha. Uns aus dem Weg\nräumen? Wie unhöflich von dir!", italian="Ahr-ahr-ahr. Metterci KO?\nNon è molto gentile da parte vostra!", spanish="Jua, jua, jua. ¿Es que pensáis\nquitarnos las manzanas? ¡Qué feo por\nvuestra parte!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Why, I was even going to offer\nmy help for your mission.", french="Moi qui allais généreusement\nvous proposer mon aide pour accomplir votre\nmission.", german="Dabei wollte ich sogar anbieten,\neuch bei eurer Mission zu helfen.", italian="E io che volevo addirittura\noffrirvi il mio aiuto per la vostra missione.", spanish="Y yo que os iba a ayudar a coger\nalgunas y todo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Was?!?", italian=" Eh?!", spanish=" ¡¿Eh?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Was?!?", italian=" Eh?!", spanish=" ¡¿Cómo?!"})
  else
  SkySceneKit.say({english=" Pardon?!", french=" Hein?!", german=" Wie bitte?!?", italian=" Eh?!", spanish=" ¡¿Eh?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="You were wondering how you\ncould get the Perfect Apples?", french="Vous vous demandiez comment\nattraper ces Pommes Parfaites?", german="Ihr fragt euch, wie ihr an die\nPerfekten Äpfel herankommt?", italian="Vi stavate chiedendo come\nprendere le Mele Perfette?", spanish="¿No os preguntabais cómo\nconseguir alguna Manzana Perfecta?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Nothing could be easier.\nWatch.", french=" Rien de plus facile. Regardez!", german="Nichts leichter als das.\nPasst auf.", italian=" Niente di più facile. Guardate.", spanish=" No podría ser más fácil. Mirad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-64), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_sukatanku, 212, 188, false, 2)
  pcall(function() GAME:MoveCamera(276, 236, 60, false) end) -- performer/caméra
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_zubatto, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-24), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(56), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6663) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '1')
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(-56), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(56), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6663) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '1')
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- SetAnimation(9) [anim idle native]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- MovePositionOffset<object OBJECT_P03P02A1_131> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(5)
  -- MovePositionOffset<object OBJECT_P03P02A1_128> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  -- MovePositionOffset<object OBJECT_P03P02A1_132> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(5)
  -- MovePositionOffset<object OBJECT_P03P02A1_130> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(5)
  -- MovePositionOffset<object OBJECT_P03P02A1_129> [prop décor NDS, géré par le rendu du ground]
  pcall(function() GAME:MoveCamera(276, 284, 60, false) end) -- performer/caméra
  -- GAP: se_Play(6664) — id SE NDS sans portage PMDO identifié
  -- MoveHeight(3, 8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, 8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, -8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, -8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, 8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, -8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, 8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, -8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, 8) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(3, -8) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! Some Perfect Apples!", french=" Oh! Des Pommes Parfaites!", german=" Oh! Perfekte Äpfel!", italian=" Oh! Delle Mele Perfette!", spanish=" ¡Oh! ¡Manzanas Perfectas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! Some Perfect Apples!", french=" Oh! Des Pommes Parfaites!", german=" Oh! Perfekte Äpfel!", italian=" Oh! Delle Mele Perfette!", spanish=" ¡Oh! ¡Manzanas Perfectas!"})
  else
  SkySceneKit.say({english=" Oh! Some Perfect Apples!", french=" Oh! Des Pommes Parfaites!", german=" Oh! Perfekte Äpfel!", italian=" Oh! Delle Mele Perfette!", spanish=" ¡Oh! ¡Manzanas Perfectas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 212, 188, false, 2)
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(0), p.Y+(56), false, 2) end
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 260, false, 2)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" See? What'd I tell you?", french=" Qu'est-ce que je disais!", german=" Seht ihr? Was habe ich gesagt?", italian=" Visto? Cosa vi dicevo?", spanish=" ¿Veis? ¿Qué os decía?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Go on, now. Scoop up those\nPerfect Apples and scuttle back to the guild.\nChaw-haw-haw.", french="Allez. Dépêchez-vous de les\nramasser et de rentrer à la Guilde.\nGnark gnark gnark!", german="Macht schon. Sammelt die\nPerfekten Äpfel ein und eilt zurück zur Gilde.\nCha-ha-ha.", italian="Forza. Raccogliete quelle Mele\nPerfette e tornatevene alla Gilda.\nAhr-ahr-ahr.", spanish="Venga, ahora coged esas\nManzanas Perfectas y volved rápidamente\nal [CS:N]Pokégremio[CR]. Jua, jua, jua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho.", french=" Mouarf mouarf mouarf!", german=" Whoahoho.", italian=" Uooh-ho-ho.", spanish=" Jo, jo, jo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh.", french=" Hin hin.", german=" Hehe.", italian=" Eh-eh.", spanish=" Jue, jue."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  else
  SkySceneKit.say({english=" ...", french=" ...", german=" ...", italian=" ...", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Hm? What's the matter? Aren't\nyou going to pick them up?", french="Ben quoi? Quel est le problème?\nVous ne les ramassez pas?", german="Hmm? Was ist los? Wollt ihr\nsie nicht aufheben?", italian="Eh? Cosa c'è? Non volete\nraccoglierle?", spanish="¿Qué os pasa?\n¿No vais a cogerlas?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="And after I was so nice and\nhelped you out! Chaw-haw-haw.", french="Moi qui me suis montré si\naimable et serviable en vous proposant\nmon aide! Gnark gnark gnark!", german="Und dabei war ich so freundlich\nund habe euch geholfen! Cha-ha-ha.", italian="E io che sono stato così gentile\nda aiutarvi! Ahr-ahr-ahr.", spanish="¡Y yo que he sido tan majo\nque os he echado una mano! Jua, jua, jua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're going to pull another dirty\ntrick, aren't you!", french="Vous allez encore nous jouer un\nmauvais tour, c'est ça?", german="Ihr plant doch wieder\nirgendeinen miesen Trick!", italian="Volete giocarci qualche altro\nbrutto tiro, non è così?", spanish="Otra vez nos la vais a jugar,\n¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're going to pull another dirty\ntrick, aren't you!", french="Vous allez encore nous jouer un\nmauvais tour, c'est ça?", german="Ihr plant doch wieder\nirgendeinen miesen Trick!", italian="Volete giocarci qualche altro\nbrutto tiro, non è così?", spanish="Nos vais a hacer otra faena de\nlas vuestras, ¿verdad?"})
  else
  SkySceneKit.say({english="You're going to pull another dirty\ntrick, aren't you!", french="Vous allez encore nous jouer un\nmauvais tour, c'est ça?", german="Ihr plant doch wieder\nirgendeinen miesen Trick!", italian="Volete giocarci qualche altro\nbrutto tiro, non è così?", spanish="Otra vez vais a hacer de las\nvuestras, ¿verdad?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I won't be fooled again!", french="Vous ne nous aurez pas cette\nfois!", german="Ich falle nicht noch mal auf euch\nherein!", italian=" Non ci casco di nuovo!", spanish=" ¡No volveré a picar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You can't fool me again!", french="Vous ne nous aurez pas cette\nfois!", german="Ihr könnt mich nicht mehr\ntäuschen!", italian=" Non ci casco di nuovo!", spanish=" ¡A mí ya no me la jugáis!"})
  else
  SkySceneKit.say({english=" You won't fool me again!", french="Vous ne nous aurez pas cette\nfois!", german="Ich falle nicht noch mal auf euch\nherein!", italian=" Non ci casco di nuovo!", spanish=" ¡Pues esta vez no me engañáis!"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sukatanku, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "shock", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Up)
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Color me surprised! They didn't\nfall for it at all!", french="Ah ben ça pour une surprise!\nCette fois, vous tombez pas dans le panneau!", german="Mir bleibt die Spucke weg! Sie\nsind nicht darauf reingefallen!", italian="Non posso crederci! Quelle due\nschiappe non ci sono cascate.", spanish="¡Me he quedado a cuadros!\n¡Esta vez no han picado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Aww. How boring is that.", french=" Pff! C'est nul.", german=" Och, wie langweilig.", italian=" Aww. Che noia.", spanish=" Bah. Qué aburrido resulta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Lo sapevo!", spanish=" ¡Lo sabía!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I was right!", french=" Je le savais!", german=" Ich hatte recht!", italian=" Lo sapevo!", spanish=" ¡Me lo figuraba!"})
  else
  SkySceneKit.say({english=" I knew it!", french=" Je le savais!", german=" Ich wusste es!", italian=" Lo sapevo!", spanish=" ¡Estaba clarísimo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw. It's a little\ndisappointing you didn't fall for our act...", french="Gnark gnark gnark! Ah là là,\ncomme je suis déçu! Vous ne vous êtes pas\nfait avoir...", german="Cha-ha-ha. Ich bin ein wenig\nenttäuscht, dass ihr uns durchschaut habt...", italian="Ahr-ahr-ahr. È un po' deludente\nil fatto che non abbiate abboccato...", spanish="Jua, jua, jua. Es un poco\ndecepcionante que no hayáis caído en\nla trampa."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="But so what? What are you\ngonna do about it?", french="Et maintenant? Qu'allez-vous\nfaire?", german="Aber wie auch immer. Was\nwollt ihr schon dagegen tun?", italian=" E allora, cosa volete fare ora?", spanish="¿Pero qué más da? De todas\nformas, ¡no podéis hacer nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The only thing we can!", french="La seule chose que l'on puisse\nfaire!", german=" Das Einzige, was wir tun können!", italian="L'unica cosa che possiamo\nfare!", spanish=" ¡Sí que podemos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The only thing we can!", french="La seule chose que l'on puisse\nfaire!", german=" Das Einzige, was wir tun können!", italian="L'unica cosa che possiamo\nfare!", spanish=" ¡Sí que podemos!"})
  else
  SkySceneKit.say({english=" The only thing we can!", french="La seule chose que l'on puisse\nfaire!", german=" Das Einzige, was wir tun können!", italian="L'unica cosa che possiamo\nfare!", spanish=" ¡Sí que podemos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll knock out your team and\ntake the Perfect Apples back to the guild!", french="On va vous donner une petite\nleçon, puis on rapportera les Pommes\nParfaites à la Guilde!", german="Wir räumen euch aus dem Weg\nund bringen die Perfekten Äpfel zur Gilde!", italian="Metteremo KO la vostra\nsquadra e riporteremo le Mele Perfette\nalla Gilda!", spanish="¡Vamos a enfrentarnos a\ntu equipo, y después nos vamos a llevar\nlas Manzanas Perfectas al [CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're going to knock out your\nteam. Then we're taking the Perfect Apples\nback to the guild!", french="On va vous donner une petite\nleçon, puis on rapportera les Pommes\nParfaites à la Guilde!", german="Wir räumen euch aus dem Weg.\nDann bringen wir die Perfekten Äpfel zur\nGilde!", italian="Metteremo KO la vostra\nsquadra e riporteremo le Mele Perfette\nalla Gilda!", spanish="Primero nos vamos a enfrentar\na tu equipo, ¡y luego nos vamos a llevar\nlas Manzanas Perfectas al [CS:N]Pokégremio[CR]!"})
  else
  SkySceneKit.say({english="We'll knock out your team. Then\nwe're taking the Perfect Apples back to\nour guild!", french="On va vous donner une petite\nleçon, puis on rapportera les Pommes\nParfaites à la Guilde!", german="Wir räumen euch aus dem Weg.\nDann bringen wir die Perfekten Äpfel zur\nGilde!", italian="Metteremo KO la vostra\nsquadra e riporteremo le Mele Perfette\nalla Gilda!", spanish="¡Vamos a enfrentarnos a\ntu equipo y luego nos llevaremos\nlas Manzanas Perfectas al [CS:N]Pokégremio[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Well now. Aren't we feeling\npeppy today!", french="J'ai comme l'impression qu'on va\ns'amuser comme des petits fous, les gars!", german="Na so was. Ihr seid heute aber\nenergiegeladen!", italian=" Beh, quanta spavalderia oggi!", spanish="Vaya, vaya. Hoy te veo\ncon mucha energía."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="When we first met, you were\nshaking like a leaf too. Chaw-haw-haw.", french="Lors de notre première\nrencontre, tu tremblais comme une feuille.\nGnark gnark gnark!", german="Bei unserem ersten Treffen hast\ndu gezittert wie Espenlaub. Cha-ha-ha.", italian="La prima volta che ci siamo\nincontrati tremavi come una foglia.\nAhr-ahr-ahr.", spanish="El otro día en el [CS:N]Pokégremio[CR]\nestabas temblando como una hoja. Jua, jua, jua."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's true... That time, I did\nback down...", french="C'est vrai... Cette fois-là, j'ai eu\nla frousse...", german="Stimmt... Damals habe ich\ngekniffen.", italian="È vero... Quella volta avevo\npaura...", spanish="Es cierto... En aquella ocasión\nno me atreví a hacer nada..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's true... That time, I did\nback down...", french="C'est vrai... Cette fois-là, j'ai eu\nla frousse...", german="Stimmt... Damals habe ich\ngekniffen.", italian="È vero... Quella volta avevo\npaura...", spanish="Es cierto... En aquella ocasión\nno me atreví a hacer nada..."})
  else
  SkySceneKit.say({english="It's true... That time, I did\nback down...", french="C'est vrai... Cette fois-là, j'ai eu\nla frousse...", german="Stimmt... Damals habe ich\ngekniffen.", italian="È vero... Quella volta avevo\npaura...", spanish="Es cierto... En aquella ocasión\nno me atreví a hacer nada..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Even now I'm a little scared...", french="Même maintenant, j'ai un peu\npeur...", german="Und auch jetzt habe ich ein\nbisschen Angst...", italian=" Anche adesso ne ho un po'...", spanish="Incluso ahora estoy un poco\nasustado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Even now I'm a little scared...", french="Même maintenant, j'ai un peu\npeur...", german="Und auch jetzt habe ich ein\nbisschen Angst...", italian=" Anche adesso ne ho un po'...", spanish="Incluso ahora estoy un poco\nasustado..."})
  else
  SkySceneKit.say({english=" Even now I'm a little scared...", french="Même maintenant, j'ai un peu\npeur...", german="Und auch jetzt habe ich ein\nbisschen Angst...", italian=" Anche adesso ne ho un po'...", spanish="Incluso ahora estoy un poco\nasustada..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But I won't lose again!", french="Mais pas question de perdre\nencore une fois!", german="Aber ich werde nicht noch mal\nverlieren!", italian="Ma non mi farò sconfiggere\nancora!", spanish=" ¡Pero no pienso perder!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But I won't lose again!", french="Mais pas question de perdre\nencore une fois!", german="Aber ich werde nicht noch mal\nverlieren!", italian="Ma non mi farò sconfiggere\nancora!", spanish=" ¡Pero ya no voy a rendirme!"})
  else
  SkySceneKit.say({english=" But I won't lose again!", french="Mais pas question de perdre\nencore une fois!", german="Aber ich werde nicht noch mal\nverlieren!", italian="Ma non mi farò sconfiggere\nancora!", spanish=" ¡Pero no pienso perder!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I won't ever back down again!", french=" Plus jamais je ne reculerai!", german=" Ich werde nie wieder kneifen!", italian=" Non mi tirerò più indietro!", spanish=" ¡No volveré a retroceder!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I won't ever back down again!", french=" Plus jamais je ne reculerai!", german=" Ich werde nie wieder kneifen!", italian=" Non mi tirerò più indietro!", spanish=" ¡No volveré a retroceder!"})
  else
  SkySceneKit.say({english=" I won't ever back down again!", french=" Plus jamais je ne reculerai!", german=" Ich werde nie wieder kneifen!", italian=" Non mi tirerò più indietro!", spanish=" ¡No volveré a retroceder!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" So be it.", french=" Soit.", german=" So sei es.", italian=" Come vuoi.", spanish=" Que así sea."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" In recognition of your courage...", french="En reconnaissance de ton\ncourage...", german="Meine Anerkennung für deinen\nMut...", italian=" In omaggio al tuo coraggio...", spanish=" En reconocimiento a tu valor..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="We'll be honored to take you on\nfair and square. Chaw-haw-haw!", french="... nous allons être fair-play\navec vous. Gnark gnark gnark!", german="Wir werden euch in Zukunft\nunsere größte Hochachtung entgegenbringen.\nCha-ha-ha!", italian="Sarò onorato di mandarti KO\nin uno scontro leale. Ahr-ahr-ahr!", spanish="Estaré encantado de enfrentarme\na ti limpiamente. ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(12), p.Y+(0), false, 2) end
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(12), p.Y+(-16), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(16), p.Y+(16), false, 2) end
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(1).Position; GROUND:MoveToPosition(SkySceneKit.team_member(1), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(4)
  -- SetAnimation(5) [anim idle native]
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-watch out, [hero]!", french=" Fais attention, [hero]!", german=" P-pass auf, [hero]!", italian=" A-Attenzione, [hero]!", spanish=" ¡Cu... cuidado, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-watch out, [hero]!", french=" Fais attention, [hero]!", german=" P-pass auf, [hero]!", italian=" A-Attenzione, [hero]!", spanish=" ¡Cu... cuidado, [hero]!"})
  else
  SkySceneKit.say({english=" W-watch out, [hero]!", french=" Fais attention, [hero]!", german=" P-pass auf, [hero]!", italian=" A-Attenzione, [hero]!", spanish=" ¡Cu... cuidado, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" They're going to try something!", french=" Ils préparent quelque chose!", german=" Sie haben irgendetwas vor!", italian=" Stanno per combinare qualcosa!", spanish=" ¡Van a intentar algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" They're going to try something!", french=" Ils préparent quelque chose!", german=" Sie haben irgendetwas vor!", italian=" Stanno per combinare qualcosa!", spanish=" ¡Van a intentar algo!"})
  else
  SkySceneKit.say({english=" They're going to try something!", french=" Ils préparent quelque chose!", german=" Sie haben irgendetwas vor!", italian=" Stanno per combinare qualcosa!", spanish=" ¡Van a intentar algo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw-haw!", french=" Gnark gnark gnark!", german=" Cha-ha-ha!", italian=" Ahr-ahr-ahr!", spanish=" ¡Jua, jua, jua!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Let's see if you can withstand\nthis attack.", french="Voyons si vous pouvez\nsupporter cette attaque.", german="Mal sehen, ob ihr diesem Angriff\nstandhalten könnt.", italian="Vediamo se resistete a questo\nattacco.", spanish="Veamos si podéis resistir\neste ataque."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" [CS:N]Koffing[CR] and I will use our...", french="[CS:N]Smogo[CR] et moi, nous allons\nutiliser notre fameux...", german=" Hier kommen [CS:N]Smogon[CR] und ich...", italian="[CS:N]Koffing[CR] e io useremo la\nnostra...", spanish=" [CS:N]Koffing[CR] y yo usaremos..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" noxious gas combo!", french="... combo spécial au gaz\nnauséabond!", german=" Die giftige Gas-Spezial-Kombo!", italian="... micidiale combinazione di gas\npuzzolenti!", spanish="¡Nuestra combinación de gases\nnocivos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6913) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: SetEffect 639 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(68) [anim idle native]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  GAME:WaitFrames(15)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaah! WAAAAH!", french=" Aaah! AAAH!", german=" Waaaah! WAAAAH!", italian=" Waaaah! WAAAAH!", spanish=" ¡Aaaah! ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaah! WAAAAH!", french=" Aaah! AAAH!", german=" Waaaah! WAAAAH!", italian=" Waaaah! WAAAAH!", spanish=" ¡Aaaah! ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaaah! WAAAAH!", french=" Aaah! AAAH!", german=" Waaaah! WAAAAH!", italian=" Waaaah! WAAAAH!", spanish=" ¡Aaaah! ¡Aaaah!"})
  end
  GAME:FadeOut(true, 60) -- screen_WhiteOutAll
  -- message_CloseEnforce
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(24) [anim idle native]
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- se_FadeOut(6913, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(90)
  GAME:FadeIn(0)
  GAME:FadeIn(60)
  GAME:WaitFrames(90)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... That was awful...", french=" Pouah... Quelle horreur...", german=" Bah... Das war grauenhaft.", italian=" Ugh... È stato tremendo!", spanish=" Uf... ¡Qué asco!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... That was disgusting...", french=" Pouah... Quelle horreur...", german=" Bah... Das war ekelerregend.", italian=" Ugh... È stato disgustoso!", spanish=" Uf... ¡Vaya tufo!"})
  else
  SkySceneKit.say({english=" Ugh... That was awful...", french=" Pouah... Quelle horreur...", german=" Bah... Das war grauenhaft.", italian="Ugh... Che esperienza\nterrificante!", spanish=" Uf... ¡Qué asco!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Are you all right, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Are you OK, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  else
  SkySceneKit.say({english=" Are you OK, [hero]?", french=" Ça va, [hero]?", german=" Alles okay, [hero]?", italian=" Stai bene, [hero]?", spanish=" ¿Estás bien, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew!", french=" Heureux de l'entendre!", german=" Puh!", italian=" Fiuuu!", spanish=" ¡Menos mal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm glad!", french=" Heureux de l'entendre!", german=" Bin ich froh!", italian=" Meno male!", spanish=" ¡Me alegro!"})
  else
  SkySceneKit.say({english=" Thank goodness!", french=" Heureuse de l'entendre!", german=" Zum Glück!", italian=" Meno male!", spanish=" ¡Es un alivio!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Urrgh...", french=" Aaargh...", german=" Urrgh...", italian=" Urrgh...", spanish=" Grr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Aaaaah!", french=" Aaah!", german=" Aaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Waaah! They left without me!", french=" Aaah! Ils sont partis sans moi!", german="Waaah! Sie haben mich\nzurückgelassen!", italian="Waaah! Se ne sono andati senza\ndi me!", spanish=" ¡Nooo! ¡Se han ido sin mí!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(1024) [anim idle native]
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(0), p.Y+(200), false, 2) end
  GAME:WaitFrames(30)
  do local p=SkySceneKit.team_member(2).Position; GROUND:MoveToPosition(SkySceneKit.team_member(2), p.X+(48), p.Y+(0), false, 2) end
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.DownRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.DownRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.DownLeft) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, hero, 4) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, hero, 4) end) end end
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urf... We both got knocked out...", french=" Arf... On s'est fait avoir...", german=" Urf... Wir sind K.O. gegangen...", italian=" Ci hanno mandato KO...", spanish="Uf... Nos han dejado fuera\nde combate, ¿eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urf... We both got knocked out...", french=" Arf... On s'est fait avoir...", german=" Urf... Wir sind K.O. gegangen...", italian=" Ci hanno mandato KO...", spanish="Uf... Nos han dejado fuera\nde combate, ¿eh?"})
  else
  SkySceneKit.say({english=" Urf... We both got knocked out...", french=" Arf... On s'est fait avoir...", german=" Urf... Wir sind K.O. gegangen...", italian=" Ci hanno mandato KO...", spanish="Uf... Nos han dejado para\nel arrastre."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But, wow, that was an incredible\nstench.", french=" Mais quelle ignoble puanteur!", german="Wow, was für ein unglaublicher\nGestank das war.", italian=" Ma, ouch, che puzza incredibile.", spanish=" Pero es que... ¡menudo tufo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But what an overpowering\nstench.", french=" Mais quelle ignoble puanteur!", german="Was für ein überwältigender\nGestank das war.", italian=" Ma che puzza incredibile.", spanish=" Con ese hedor era inevitable."})
  else
  SkySceneKit.say({english=" But what a horrible stench.", french=" Mais quelle ignoble puanteur!", german="Was für ein entsetzlicher\nGestank das war.", italian=" Ma che puzza incredibile.", spanish="Con ese olor, ¿quién iba a\nresistir?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It still reeks a little...", french=" Il y a encore des relents...", german="Es mieft noch immer ein\nbisschen.", italian=" Si sente ancora un po'...", spanish=" Todavía huele mal..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The stench is still lingering...", french=" Il y a encore des relents...", german="Er liegt noch immer in der\nLuft.", italian=" Si sente ancora un po'...", spanish=" De hecho todavía apesta..."})
  else
  SkySceneKit.say({english=" It still reeks a little... Ewww...", french=" Il y a encore des relents...", german="Es mieft noch immer ein\nbisschen. Bah!", italian=" Si sente ancora un po'...", spanish=" Todavía apesta un poco. ¡Puaj!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey! What about the\nPerfect Apples?!", french="Hé! Où sont les Pommes\nParfaites?!", german="Hey! Was ist mit den Perfekten\nÄpfeln?!?", italian="Ehi! Che fine hanno fatto\nle Mele Perfette?!", spanish="¡Oye! ¿Qué pasa con las\nManzanas Perfectas?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh! What happened to the\nPerfect Apples?!", french="Hé! Où sont les Pommes\nParfaites?!", german="Oh! Was ist mit den Perfekten\nÄpfeln passiert?!?", italian="Ehi! Che fine hanno fatto\nle Mele Perfette?!", spanish="¡Oye! ¿Qué ha pasado con\nlas Manzanas Perfectas?"})
  else
  SkySceneKit.say({english="Oh! Where are the\nPerfect Apples?!", french="Hé! Où sont les Pommes\nParfaites?!", german="Oh! Wo sind die Perfekten\nÄpfel hin?!?", italian="Ehi! Che fine hanno fatto\nle Mele Perfette?!", spanish="¡Oh! ¿Qué ha pasado con\nlas Manzanas Perfectas?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Aw! They're gone!", french=" Ouah! Elles ont disparu!", german=" Ohh! Sie sind weg!", italian=" Ah! Sparite!", spanish=" ¡No! ¡Ya no están!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Aw! They're gone!", french=" Ouah! Elles ont disparu!", german=" Ohh! Sie sind weg!", italian=" Ah! Sparite!", spanish=" ¡No! ¡Ya no están!"})
  else
  SkySceneKit.say({english=" Aw! They're gone!", french=" Ouah! Elles ont disparu!", german=" Ohh! Sie sind weg!", italian=" Ah! Sparite!", spanish=" ¡No! ¡Ya no están!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, hero, 4) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharTurnToCharAnimated(__slot, hero, 4) end) end end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Did those bullies eat them all?", french="Ce sont ces brutes qui les\nauraient mangées?", german="Haben diese Fieslinge sie alle\naufgegessen?", italian="Quei bulli se le sono mangiate\ntutte?", spanish="¿Se las han comido esos\nabusones?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Did those bullies eat them all?", french="Ce sont ces brutes qui les\nauraient mangées?", german="Haben diese Fieslinge sie alle\naufgegessen?", italian="Quei bulli se le sono mangiate\ntutte?", spanish="¿Se las han comido esos\nabusones?"})
  else
  SkySceneKit.say({english=" Did those bullies eat them all?", french="Ce sont ces brutes qui les\nauraient mangées?", german="Haben diese Fieslinge sie alle\naufgegessen?", italian="Quei bulli se le sono mangiate\ntutte?", spanish="¿Se las han comido esos\nabusones?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If they're all gone, there's\nnothing we can do.", french="Elles ont toutes disparu, on ne\npeut plus rien faire.", german="Wenn sie alle weg sind, können\nwir nichts machen.", italian="Se non ce ne sono più, non\npossiamo farci niente.", spanish="Si ya no queda ninguna,\nno podemos hacer nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If they're all gone, there's\nnothing we can do.", french="Elles ont toutes disparu, on ne\npeut plus rien faire.", german="Wenn sie alle weg sind, können\nwir nichts machen.", italian="Se non ce ne sono più, non\npossiamo farci niente.", spanish="Si ya no queda ninguna,\nno hay nada que podamos hacer."})
  else
  SkySceneKit.say({english="If they're all gone, there's\nnothing we can do.", french="Elles ont toutes disparu, on ne\npeut plus rien faire.", german="Wenn sie alle weg sind, können\nwir nichts machen.", italian="Se non ce ne sono più, non\npossiamo farci niente.", spanish="Si ya no queda ninguna,\nno hay nada que podamos hacer."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're out of luck. Let's head\nback to the guild.", french="On n'a vraiment pas eu\nde chance. Rentrons à la Guilde.", german="Pech gehabt. Gehen wir zurück\nzur Gilde.", italian="Che sfortuna. Torniamo alla\nGilda.", spanish="No queda más remedio que\nvolver al [CS:N]Pokégremio[CR] sin ellas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's nothing we can do.\nLet's go back to the guild.", french="On n'a vraiment pas eu\nde chance. Rentrons à la Guilde.", german="Da kann man nichts machen.\nGehen wir zurück zur Gilde.", italian="Che sfortuna. Torniamo alla\nGilda.", spanish="No queda más remedio que\nvolver al [CS:N]Pokégremio[CR] con las manos vacías."})
  else
  SkySceneKit.say({english="We can't do anything else.\nLet's go back to our guild.", french="On n'a vraiment pas eu\nde chance. Rentrons à la Guilde.", german="Da kann man nichts machen.\nGehen wir zurück zur Gilde.", italian="Che sfortuna. Torniamo alla\nGilda.", spanish="No queda más remedio que\nvolver al [CS:N]Pokégremio[CR] con las manos vacías."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 4 -- $COMPULSORY_SAVE_POINT = 4 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
