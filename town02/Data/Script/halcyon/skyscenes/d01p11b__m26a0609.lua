-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0609.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_MEMORIES_RETURNED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 660, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 660, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(60)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The view was like this that\ntime too...", french="C'était exactement comme\naujourd'hui...", german="Der Anblick war damals\ngenauso...", italian="La vista quella volta era più o\nmeno la stessa...", spanish=" La luz, el mar... Todo era igual."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The view was like this that\ntime too...", french="C'était exactement comme\naujourd'hui...", german="Der Anblick war damals\ngenauso...", italian="La vista quella volta era più o\nmeno la stessa...", spanish=" La luz, el mar... Es idéntico."})
  else
  SkySceneKit.say({english="The view was like this that\ntime too...", french="C'était exactement comme\naujourd'hui...", german="Der Anblick war damals\ngenauso...", italian="La vista quella volta era più o\nmeno la stessa...", spanish=" La luz, el mar... Todo era igual."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() GAME:MoveCamera(384, 180, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 384, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The [CS:N]Krabby[CR] blowing all those\nbubbles along the beach...", french="Les [CS:N]Krabby[CR] qui faisaient\ntoutes ces bulles le long de la plage...", german="Die [CS:N]Krabby[CR] pusteten all diese\nBlasen über den Strand...", italian="I [CS:N]Krabby[CR] facevano le bolle\nlungo la spiaggia...", spanish="Los [CS:N]Krabby[CR] soplando todas\nesas pompitas en la playa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The [CS:N]Krabby[CR] blowing all those\nbubbles along the beach...", french="Les [CS:N]Krabby[CR] qui faisaient\ntoutes ces bulles le long de la plage...", german="Die [CS:N]Krabby[CR] pusteten all diese\nBlasen über den Strand...", italian="I [CS:N]Krabby[CR] facevano le bolle\nlungo la spiaggia...", spanish="Los [CS:N]Krabby[CR] soplando todas\nesas pompitas en la playa..."})
  else
  SkySceneKit.say({english="The [CS:N]Krabby[CR] blowing all those\nbubbles along the beach...", french="Les [CS:N]Krabby[CR] qui faisaient\ntoutes ces bulles le long de la plage...", german="Die [CS:N]Krabby[CR] pusteten all diese\nBlasen über den Strand...", italian="I [CS:N]Krabby[CR] facevano le bolle\nlungo la spiaggia...", spanish="Los [CS:N]Krabby[CR] soplando todas\nesas pompitas en la playa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I noticed someone...right here...", french="J'ai remarqué quelqu'un...\njuste là...", german="Und dann sah ich jemanden...\nGenau hier...", italian="... e poi mi sono accorto che\nc'era qualcuno... proprio qui...", spanish=" Y vi a alguien... justo aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I noticed someone...right here...", french="J'ai remarqué quelqu'un...\njuste là...", german="Und dann sah ich jemanden...\nGenau hier...", italian="... e poi mi sono accorto che\nc'era qualcuno... proprio qui...", spanish="Entonces vi a alguien...\njusto aquí..."})
  else
  SkySceneKit.say({english=" I noticed someone...right here...", french="J'ai remarqué quelqu'un...\njuste là...", german="Und dann sah ich jemanden...\nGenau hier...", italian="... e poi mi sono accorta che\nc'era qualcuno... proprio qui...", spanish="En ese momento vi a alguien...\njusto aquí..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[hero] was...[K]\nunconscious...", french="[hero] gisait là...[K]\nsans connaissance...", german="[hero] war...[K]\nbewusstlos...", italian="[hero] era...[K]\na terra, incosciente...", spanish="[hero] estaba...[K]\ninconsciente..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[hero] was...[K]\nunconscious...", french="[hero] gisait là...[K]\nsans connaissance...", german="[hero] war...[K]\nbewusstlos...", italian="[hero] era...[K]\na terra, incosciente...", spanish="[hero] estaba...[K]\ninconsciente..."})
  else
  SkySceneKit.say({english="[hero] was...[K]\nunconscious...", french="[hero] gisait là...[K]\nsans connaissance...", german="[hero] war...[K]\nbewusstlos...", italian="[hero] era...[K]\na terra, incosciente...", spanish="[hero] estaba...[K]\ninconsciente..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That was when...[K][hero]\nand I...", french="C'est là que...[K] [hero]\net moi...", german="Das war, als...[K] [hero]\nund ich...", italian="È stato quando...[K] [hero]\ned io...", spanish="Fue entonces cuando...[K]\n[hero] y yo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That was when...[K][hero]\nand I...", french="C'est là que...[K] [hero]\net moi...", german="Das war, als...[K] [hero]\nund ich...", italian="È stato quando...[K] [hero]\ned io...", spanish="Fue entonces cuando...[K]\n[hero] y yo..."})
  else
  SkySceneKit.say({english="That was when...[K][hero]\nand I...", french="C'est là que...[K] [hero]\net moi...", german="Das war, als...[K] [hero]\nund ich...", italian="È stato quando...[K] [hero]\ned io...", spanish="Fue entonces cuando...[K]\n[hero] y yo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That was when our adventure\nbegan.", french="C'est là que notre périple\na commencé.", german=" Damit begann unser Abenteuer.", italian="Quando è cominciata la nostra\navventura.", spanish="En ese momento comenzaron\nnuestras aventuras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That was when our adventure\nbegan.", french="C'est là que notre périple\na commencé.", german=" Damit begann unser Abenteuer.", italian="Quando è cominciata la nostra\navventura.", spanish="Fue el comienzo de nuestras\naventuras."})
  else
  SkySceneKit.say({english="That was when our adventure\nbegan.", french="C'est là que notre périple\na commencé.", german=" Damit begann unser Abenteuer.", italian="Quando è cominciata la nostra\navventura.", spanish="Fue el inicio de nuestras\naventuras."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  SkySubScreen.Hide(60) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  GAME:WaitFrames(30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
