-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s20p0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
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
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I guess the storm blew over.", french=" L'orage s'est éloigné.", german="Ich denke, der Sturm ist\nvorübergezogen.", italian=" La tempesta è finita.", spanish="Parece que ha amainado la\ntormenta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Looks like the storm blew over.", french=" L'orage s'est éloigné.", german="Sieht so aus, als sei der Sturm\nvorübergezogen.", italian=" La tempesta è finita.", spanish="Parece que ha amainado la\ntormenta."})
  else
  SkySceneKit.say({english=" I guess the storm blew over.", french=" L'orage s'est éloigné.", german="Ich denke, der Sturm ist\nvorübergezogen.", italian=" La tempesta è finita.", spanish="Parece que ha amainado la\ntormenta."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The weather's great again.", french=" Le temps s'est éclairci.", german=" Das Wetter ist wieder schön.", italian=" Il tempo è di nuovo bello.", spanish=" Ha vuelto el buen tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The weather has cleared up.", french=" Le temps s'est éclairci.", german="Das Wetter hat sich wieder\naufgeheitert.", italian=" Il tempo è di nuovo bello.", spanish=" Ha vuelto el buen tiempo."})
  else
  SkySceneKit.say({english=" The skies have cleared up.", french=" Le temps s'est éclairci.", german="Der Himmel hat sich\naufgeheitert.", italian=" Il tempo è di nuovo bello.", spanish=" Ha vuelto el buen tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's put in another good day of\nexploring, [hero]!", french="Un bon jour pour repartir\nen exploration, [hero]!", german="Lass uns einen weiteren guten\nErkundungstag hinlegen, [hero]!", italian="Possiamo tornare a\nesplorare, [hero]!", spanish="¡Vayamos a explorar un día\nmás, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Here's to another good day of\nexploring, [hero]!", french="Un bon jour pour repartir\nen exploration, [hero]!", german="Auf einen weiteren guten\nErkundungstag, [hero]!", italian="Possiamo tornare a\nesplorare, [hero]!", spanish="¡Vayamos a explorar un día\nmás, [hero]!"})
  else
  SkySceneKit.say({english="Let's put in another good day of\nexploring, [hero]!", french="Un bon jour pour repartir\nen exploration, [hero]!", german="Lass uns einen weiteren guten\nErkundungstag hinlegen, [hero]!", italian="Possiamo tornare a\nesplorare, [hero]!", spanish="¡Vayamos a explorar un día\nmás, [hero]!"})
  end
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
