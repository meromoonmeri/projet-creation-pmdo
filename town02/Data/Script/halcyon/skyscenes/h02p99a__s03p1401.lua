-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p1401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_H02P99A, 'US03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  -- SetAnimation(46) [anim idle native]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 336, 184, Direction.DownLeft, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
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
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two![K] Have you obtained a\nPhione Dew?", french="Vous deux![K] Avez-vous trouvé\nune Rosée Phione?", german="Ihr beiden![K] Habt ihr Phione-Tau\nbekommen?", italian="Voi due![K] Avete trovato la\nBrina Phione?", spanish="¡Eh![K] ¿Habéis conseguido\nel Rocío Phione?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, sorry. Not yet...", french=" Malheureusement, pas encore...", german=" Nein, tut uns leid. Noch nicht...", italian=" No, purtroppo non ancora...", spanish=" No, todavía no..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, sorry. Not yet...", french=" Malheureusement, pas encore...", german=" Nein, tut uns leid. Noch nicht...", italian=" No, purtroppo non ancora...", spanish=" No, todavía no..."})
  else
  SkySceneKit.say({english=" No, sorry. Not yet...", french=" Malheureusement, pas encore...", german=" Nein, tut uns leid. Noch nicht...", italian=" No, purtroppo non ancora...", spanish=" No, todavía no..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Hay que encontrar a las hadas\n[CS:N]Phione[CR] como sea, [hero]! ¡Es la única\nforma de salvar a [CS:N]Manaphy[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Hay que encontrar a las hadas\n[CS:N]Phione[CR] como sea, [hero]! ¡Es la única\nforma de salvar a [CS:N]Manaphy[CR]!"})
  else
  SkySceneKit.say({english="We have to find the [CS:N]Phione[CR], no\nmatter what, [hero]! It's the only way\nwe can save [CS:N]Manaphy[CR]!", french="Nous devons trouver les [CS:N]Phione[CR]\ncoûte que coûte, [hero]! C'est le seul\nmoyen de sauver [CS:N]Manaphy[CR]!", german="Wir müssen um jeden Preis die\n[CS:N]Phione[CR] finden, [hero]! Es ist der\neinzige Weg, wie wir [CS:N]Manaphy[CR] retten können!", italian="Dobbiamo a tutti i costi trovare\ni [CS:N]Phione[CR], [hero]! È l'unico modo per\nsalvare [CS:N]Manaphy[CR]!", spanish="¡Hay que encontrar a las hadas\n[CS:N]Phione[CR] como sea, [hero]! ¡Es la única\nforma de salvar a [CS:N]Manaphy[CR]!"})
  end
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_manafi, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
