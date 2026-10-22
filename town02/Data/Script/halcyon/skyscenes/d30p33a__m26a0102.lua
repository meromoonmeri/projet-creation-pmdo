-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P33A/m26a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_EARTHQUAKE2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_HEAVY_FEELING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D30P33A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 272, 288, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(25) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:FadeIn(1)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! Gotta hurry...", french="Argh! Je ferais mieux\nde me dépêcher...", german=" Umpf! Ich muss mich beeilen...", italian=" Uh! Devo sbrigarmi...", spanish=" Debo darme prisa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! I've got to hurry...", french="Argh! Je ferais mieux\nde me dépêcher...", german=" Umpf! Ich muss mich beeilen...", italian=" Uh! Devo fare in fretta...", spanish=" Debo darme prisa."})
  else
  SkySceneKit.say({english=" Urk! I've got to hurry...", french="Argh! Je ferais mieux\nde me dépêcher...", german=" Umpf! Ich muss mich beeilen...", italian=" Uh! Devo fare in fretta...", spanish=" Debo darme prisa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 212, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 244, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 300, 232, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 276, 164, false, 1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-16), false, 1) end
  GROUND:MoveToPosition(hero, 284, 200, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 1) end
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V25P04A) [décor sub chargé: Sub_v25p04a]
  -- camera2_SetPositionMark(Position<'m6', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v25p04a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! The floor's heaving...", french=" Aaah, le sol se soulève...", german=" Umpf! Der Boden hebt sich...", italian="Ah! Non riesco quasi a stare in\npiedi...", spanish=" El suelo se mueve."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! The floor's heaving...", french=" Aaah, le sol se soulève...", german=" Umpf! Der Boden hebt sich...", italian="Ah! Non riesco quasi a stare in\npiedi...", spanish=" El suelo se mueve."})
  else
  SkySceneKit.say({english=" Urk! The floor's heaving...", french=" Aaah, le sol se soulève...", german=" Umpf! Der Boden hebt sich...", italian="Ah! Non riesco quasi a stare in\npiedi...", spanish=" El suelo se mueve."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's hard to put the Time Gears\ninto place!", french="Je n'arrive pas à emboîter\nles Rouages du Temps!", german="Es ist schwierig, die Zahnräder\nder Zeit einzusetzen!", italian="È difficile mettere in posizione\ngli Ingranaggi del Tempo!", spanish="¡Resulta muy complicado encajar\nlos Engranajes del Tiempo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's hard to put the Time Gears\ninto place!", french="Je n'arrive pas à emboîter\nles Rouages du Temps!", german="Es ist schwierig, die Zahnräder\nder Zeit einzusetzen!", italian="È difficile mettere in posizione\ngli Ingranaggi del Tempo!", spanish="¡Resulta muy complicado encajar\nlos Engranajes del Tiempo!"})
  else
  SkySceneKit.say({english="It's hard to put the Time Gears\ninto place!", french="Je n'arrive pas à emboîter\nles Rouages du Temps!", german="Es ist schwierig, die Zahnräder\nder Zeit einzusetzen!", italian="È difficile mettere in posizione\ngli Ingranaggi del Tempo!", spanish="¡Resulta muy complicado encajar\nlos Engranajes del Tiempo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-8), false, 1) end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(6671) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(60)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I did it![K] They're all set!", french=" Ça y est![K] Ils sont en place!", german="Ich habe es geschafft![K]\nAlle sitzen richtig!", italian="Ce l'ho fatta![K] Sono tutti al loro\nposto!", spanish="¡Lo conseguí![K] ¡Ya están todos\ncolocados!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Done![K] They're all set!", french=" Ça y est![K] Ils sont en place!", german=" Fertig![K] Alle sitzen richtig!", italian="Fatto![K] Sono tutti al loro\nposto!", spanish="¡Lo conseguí![K] ¡Ya están todos\ncolocados!"})
  else
  SkySceneKit.say({english=" I did it![K] They're in place!", french=" Ça y est![K] Ils sont en place!", german="Ich habe es geschafft![K]\nAlle sitzen richtig!", italian="Ce l'ho fatta![K] Sono tutti al loro\nposto!", spanish="¡Lo conseguí![K] ¡Ya están todos\ncolocados!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8462) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V25P04A2_334) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(18) [anim idle native]
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:WaitFrames(45)
  -- back2_SetGround(V26P01A) [décor sub chargé: Sub_v26p01a]
  -- camera2_SetPositionMark(Position<'m7', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySubScreen.Show("v26p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitScreen2Fade (fondu sub déjà séquencé par SubScreen)
  GAME:WaitFrames(90)
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(20)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(79) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- SetAnimation(80) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  -- GAP: se_Play(8451) — id SE NDS sans portage PMDO identifié
  GROUND:MoveToPosition(partner, 260, 220, false, 2)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 284, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-why?!", french=" Mais qu'est-ce qui se passe?!", german=" W-warum?", italian=" P-Perché?!", spanish=" ¡¿Y ahora qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-why?!", french=" Mais qu'est-ce qui se passe?!", german=" W-warum?", italian=" P-Perché?!", spanish=" ¡¿Y ahora qué?!"})
  else
  SkySceneKit.say({english=" Wh-why?!", french=" Mais qu'est-ce qui se passe?!", german=" W-warum?", italian=" P-Perché?!", spanish=" ¡¿Y ahora qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I set the Time Gears in place!", french="J'ai pourtant remis les Rouages\ndu Temps à leur place!", german="Ich habe die Zahnräder der Zeit\neingesetzt!", italian="Ho messo gli Ingranaggi del\nTempo al loro posto!", spanish=" ¡Ya he colocado los engranajes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I put the Time Gears where\nthey're supposed to go!", french="J'ai pourtant remis les Rouages\ndu Temps à leur place!", german="Ich habe die Zahnräder der Zeit\ndort eingesetzt, wo sie hingehören!", italian="Ho messo gli Ingranaggi del\nTempo dove dovevano essere messi!", spanish=" ¡Ya he colocado los engranajes!"})
  else
  SkySceneKit.say({english=" I put the Time Gears in place!", french="J'ai pourtant remis les Rouages\ndu Temps à leur place!", german="Ich habe die Zahnräder der Zeit\neingesetzt!", italian="Ho messo gli Ingranaggi del\nTempo al loro posto!", spanish=" ¡Ya he colocado los engranajes!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Why isn't this quake stopping?!", french="Pourquoi est-ce que la terre\ncontinue à trembler?!", german="Warum hört dieses Beben nicht\nauf?", italian=" Perché le scosse non cessano?!", spanish="¿Por qué no se detienen los\ntemblores?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Why won't these tremors stop?!", french="Pourquoi est-ce que la terre\ncontinue à trembler?!", german="Warum hören diese\nErschütterungen nicht auf?", italian="Perché questi tremori non\ncessano?!", spanish="¿Por qué no se detienen los\ntemblores?"})
  else
  SkySceneKit.say({english="Why aren't these tremors\nstopping?!", french="Pourquoi est-ce que la terre\ncontinue à trembler?!", german="Warum wollen diese\nErschütterungen nicht aufhören?", italian="Perché questi tremori non\ncessano?!", spanish="¿Por qué no se detienen los\ntemblores?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It can't be...[K] Was I too late...?", french="J'espère que...[K] ça n'était pas\ntrop tard...?", german="Das kann nicht sein...[K] War es zu\nspät?", italian="Non può essere...[K] Era troppo\ntardi...?", spanish="No puede ser...[K] ¿Habré llegado\ndemasiado tarde?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It can't be...[K] Was I too late...?", french="J'espère que...[K] ça n'était pas\ntrop tard...?", german="Das kann nicht sein...[K] War es zu\nspät?", italian="Non può essere...[K] Era troppo\ntardi...?", spanish="No puede ser...[K] ¿Habré llegado\ndemasiado tarde?"})
  else
  SkySceneKit.say({english=" It can't be...[K] Was I too late...?", french="J'espère que...[K] ça n'était pas\ntrop tard...?", german="Das kann nicht sein...[K] War es zu\nspät?", italian="Non può essere...[K] Era troppo\ntardi...?", spanish="No puede ser...[K] ¿Habré llegado\ndemasiado tarde?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Will [CS:P]Temporal Tower[CR] keep\nfalling apart...?", french="Est-ce que la [CS:P]Tour du Temps[CR] va\nquand même s'effondrer...?", german="Bricht der [CS:P]Zeitturm[CR] weiterhin\nauseinander?", italian="La [CS:P]Torre del Tempo[CR] alla fine\ncrollerà comunque?", spanish="¿Se derrumbará de todas\nformas la [CS:P]Torre del Tiempo[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Will [CS:P]Temporal Tower[CR] continue\nto collapse...?", french="Est-ce que la [CS:P]Tour du Temps[CR] va\nquand même s'effondrer...?", german="Wird der [CS:P]Zeitturm[CR] weiter\nkollabieren?", italian="La [CS:P]Torre del Tempo[CR] alla fine\ncrollerà comunque?", spanish="¿Se derrumbará de todas\nformas la [CS:P]Torre del Tiempo[CR]?"})
  else
  SkySceneKit.say({english="Will [CS:P]Temporal Tower[CR] keep on\nbreaking apart...?", french="Est-ce que la [CS:P]Tour du Temps[CR] va\nquand même s'effondrer...?", german="Wird der [CS:P]Zeitturm[CR] weiter\nauseinanderfallen?", italian="La [CS:P]Torre del Tempo[CR] alla fine\ncrollerà comunque?", spanish="¿Se derrumbará de todas\nformas la [CS:P]Torre del Tiempo[CR]?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is it too late...[K]to stop the\nplanet's paralysis...?", french="Est-ce que nous arrivons trop\ntard...[K] pour empêcher la Paralysie\nde la Planète...?", german="Ist es bereits zu spät,[K] die\nLähmung des Planeten aufzuhalten?", italian="È troppo tardi...[K] per fermare\nla paralisi del pianeta...?", spanish="¿Es que ya...?[K] ¿Es que ya es\nimposible detener la parálisis del planeta?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is it too late...[K]to stop the\nplanet's paralysis...?", french="Est-ce que nous arrivons trop\ntard...[K] pour empêcher la Paralysie\nde la Planète...?", german="Ist es bereits zu spät,[K] die\nLähmung des Planeten aufzuhalten?", italian="È troppo tardi...[K] per fermare\nla paralisi del pianeta...?", spanish="¿Es que ya...?[K] ¿Es que ya es\nimposible detener la parálisis del planeta?"})
  else
  SkySceneKit.say({english="Is it too late...[K]to stop the\nplanet's paralysis...?", french="Est-ce que nous arrivons trop\ntard...[K] pour empêcher la Paralysie\nde la Planète...?", german="Ist es bereits zu spät,[K] die\nLähmung des Planeten aufzuhalten?", italian="È troppo tardi...[K] per fermare\nla paralisi del pianeta...?", spanish="¿Es que ya...?[K] ¿Es que ya es\nimposible detener la parálisis del planeta?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A4_78) [routine d'objet NDS non simulée - documenté]
  -- GAP: se_Play(8455) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 1) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
