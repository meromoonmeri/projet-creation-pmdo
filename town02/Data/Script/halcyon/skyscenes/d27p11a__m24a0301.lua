-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D27P11A/m24a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D27P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D27P11A, 'UM24') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 232, 408, Direction.Up, "NPC_RAPURASU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 264, 344, Direction.DownRight, "NPC_JUPUTORU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  -- ResetHitAttribute(256) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Th-this...[K] This is the [CS:P]Hidden\nLand[CR]...", french="Ce...[K] ce sont donc les [CS:P]Terres\nIllusoires[CR]...", german="D-das...[K] Das ist das\n[CS:P]Verborgene Land[CR]...", italian="Q-Questa...[K] Questa è la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]...", spanish="Así que...[K]\nEsto es la [CS:P]Tierra Oculta[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Th-this...[K] This is the [CS:P]Hidden\nLand[CR]...", french="Ce...[K] ce sont donc les [CS:P]Terres\nIllusoires[CR]...", german="D-das...[K] Das ist das\n[CS:P]Verborgene Land[CR]...", italian="Q-Questa...[K] Questa è la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]...", spanish="Así que...[K]\nEsto es la [CS:P]Tierra Oculta[CR]..."})
  else
  SkySceneKit.say({english="Th-this...[K] This is the [CS:P]Hidden\nLand[CR]...", french="Ce...[K] ce sont donc les [CS:P]Terres\nIllusoires[CR]...", german="D-das...[K] Das ist das\n[CS:P]Verborgene Land[CR]...", italian="Q-Questa...[K] Questa è la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]...", spanish="Así que...[K]\nEsto es la [CS:P]Tierra Oculta[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We finally made it here.", french=" Nous y voilà enfin.", german="Wir haben es endlich geschafft,\nhierherzukommen.", italian=" Alla fine ce l'abbiamo fatta.", spanish=" Por fin hemos llegado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Please...look ahead.", french=" Regardez par là.", german=" Bitte... Seht in diese Richtung.", italian=" Guardate là!", spanish=" Por favor... Mirad hacia allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! What's that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Hey! Was ist das?", italian=" Ehi! Cos'è quella?!", spanish=" ¡Eh! ¡¿Qué es eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! What's that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Hey! Was ist das?", italian=" Ehi! Cos'è quella?!", spanish=" ¡Eh! ¡¿Qué es eso?!"})
  else
  SkySceneKit.say({english=" Oh! What's that?!", french=" Eh, qu'est-ce que c'est que ça?!", german=" Oh! Was ist das?", italian=" Ehi! Cos'è quella?!", spanish=" ¡Eh! ¡¿Qué es eso?!"})
  end
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P07A) [décor sub chargé: Sub_v24p07a]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v24p07a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  pcall(function() SOUND:PlayBGM("Hidden Land.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Is that...[K] Is that perhaps...", french="Serait-ce...[K] serait-ce\npar hasard...", german=" Ist das...[K] Ist das vielleicht...", italian=" Quella è...[K] Forse quella è...", spanish=" Eso de ahí...[K] ¿Es quizás...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Yes.[K] It's [CS:P]Temporal Tower[CR].", french="Exact.[K] Vous avez devant vous\nla [CS:P]Tour du Temps[CR].", german=" Ja.[K] Es ist der [CS:P]Zeitturm[CR].", italian=" Sì.[K] È la [CS:P]Torre del Tempo[CR].", spanish="En efecto.[K]\nEs la [CS:P]Torre del Tiempo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[K]That's where [CS:N]Dialga[CR] is...", french=" ...[K] Le repaire de [CS:N]Dialga[CR]...", german=" ...[K]Dort, wo [CS:N]Dialga[CR] ist...", italian="...[K] È il posto in cui si trova\n[CS:N]Dialga[CR]...", spanish=" Allí...[K] se encuentra [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's where we have to go.[K]\nThe Time Gears have to be taken there.", french="C'est là qu'on doit aller.[K]\nPour y apporter les Rouages du Temps.", german="Das ist unser Ziel.[K] Die\nZahnräder der Zeit müssen dahin gebracht\nwerden.", italian="È il posto che cercavamo.[K]\nDobbiamo portare là gli Ingranaggi del Tempo.", spanish="Es nuestro destino.[K]\nDebemos llevar hasta allí los Engranajes del\nTiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...[K] Take a closer look...", french="Mais...[K] à y regarder de plus\nprès...", german="Aber...[K] Seht euch das mal\ngenauer an...", italian=" Ma...[K] guardate meglio...", spanish=" Pero...[K] Si os fijáis..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...[K]if you take a close look...", french="Mais...[K] à y regarder de plus\nprès...", german="Aber...[K] Wenn ihr mal genauer\nhinseht...", italian=" Ma...[K] se guardate meglio...", spanish=" Pero...[K] Si os fijáis..."})
  else
  SkySceneKit.say({english=" But...[K]if you take a close look...", french="Mais...[K] à y regarder de plus\nprès...", german="Aber...[K] Wenn ihr mal genauer\nhinseht...", italian=" Ma...[K] se guardate meglio...", spanish=" Pero...[K] Si os fijáis..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That place...[K]seems to be floating\nin the sky!", french="On dirait que...[K] cet endroit\nflotte dans le ciel!", german="Dieser Ort...[K] Er scheint in der\nLuft zu schweben!", italian="Quel posto...[K] sembra galleggiare\nnel cielo!", spanish="Parece...[K]\n¡Parece estar flotando en el cielo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That place...[K]seems to be floating\nin the sky!", french="On dirait que...[K] cet endroit\nflotte dans le ciel!", german="Dieser Ort...[K] Er scheint in der\nLuft zu schweben!", italian="Quel posto...[K] sembra galleggiare\nnel cielo!", spanish="Parece...[K]\n¡Parece estar flotando en el cielo!"})
  else
  SkySceneKit.say({english="That place...[K]seems to be floating\nin the sky!", french="On dirait que...[K] cet endroit\nflotte dans le ciel!", german="Dieser Ort...[K] Er scheint in der\nLuft zu schweben!", italian="Quel posto...[K] sembra galleggiare\nnel cielo!", spanish="Parece...[K]\n¡Parece estar flotando en el cielo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="How are we supposed to\nget there?", french=" Et comment on fait pour y aller?", german="Wie sollen wir diesen Ort\nerreichen?", italian=" Come facciamo ad arrivarci?", spanish="¿Cómo vamos a llegar hasta\nallí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder how we're supposed to\nget there?", french=" Et comment on fait pour y aller?", german="Ich frage mich, wie wir diesen\nOrt erreichen sollen?", italian="Mi chiedo come faremo ad\narrivarci...", spanish="¿Cómo vamos a llegar hasta\nallí?"})
  else
  SkySceneKit.say({english="How are we supposed to\nget there?", french=" Et comment on fait pour y aller?", german="Wie sollen wir diesen Ort\nerreichen?", italian=" Come facciamo ad arrivarci?", spanish="¿Cómo vamos a llegar hasta\nallí?"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="You must take the Rainbow\nStoneship.", french="Il faut vous servir\ndu Vaisseau Arc-en-Ciel.", german="Ihr müsst das\nRegenbogen-Steinschiff nehmen.", italian="Dovete prendere il Vascello\nArcobaleno.", spanish=" Debéis tomar la Barca Arcoiris."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_rapurasu, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" The Rainbow Stoneship?", french=" Le Vaisseau Arc-en-Ciel?", german=" Das Regenbogen-Steinschiff?", italian=" Il Vascello Arcobaleno?", spanish=" ¿La Barca Arcoiris?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Yes.[K] Far ahead, you\nwill find the [CS:P]Old Ruins[CR].", french="Oui.[K] Plus loin, vous trouverez\nles [CS:P]Ruines Anciennes[CR].", german="Ja.[K] Fernab von hier findet ihr\ndie [CS:P]Alten Ruinen[CR].", italian="Sì.[K] Proseguendo in questa\ndirezione, troverete le [CS:P]Antiche Rovine[CR].", spanish="Sí.[K] Más adelante encontrarás\nlas [CS:P]Ruinas Arcanas[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="There you will find an ancient,\nmystical vessel,[K] the Rainbow Stoneship.", french="C'est là que se trouve\nun antique vaisseau mystique:[K]\nle Vaisseau Arc-en-Ciel.", german="Dort findet ihr ein uraltes\nmystisches Schiff.[K] Das Regenbogen-Steinschiff.", italian="Là troverete un antico, mistico\nmezzo di trasporto.[K] Il Vascello Arcobaleno.", spanish="Allí hallaréis una antigua\nembarcación mística...[K] la Barca Arcoiris."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="It will take you to [CS:P]Temporal\nTower[CR].", french="Il vous emmènera à la [CS:P]Tour\ndu Temps[CR].", german="Es wird euch zum [CS:P]Zeitturm[CR]\nbringen.", italian=" Vi porterà alla [CS:P]Torre del Tempo[CR].", spanish="Esa embarcación os llevará\nhasta la [CS:P]Torre del Tiempo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR]!", french=" Merci, [CS:N]Lokhlass[CR]!", german=" Danke, [CS:N]Lapras[CR]!", italian=" Grazie, [CS:N]Lapras[CR]!", spanish=" ¡Gracias, [CS:N]Lapras[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR]!", french=" Merci, [CS:N]Lokhlass[CR]!", german=" Danke, [CS:N]Lapras[CR]!", italian=" Grazie, [CS:N]Lapras[CR]!", spanish=" ¡Gracias, [CS:N]Lapras[CR]!"})
  else
  SkySceneKit.say({english=" Thank you, [CS:N]Lapras[CR]!", french=" Merci, [CS:N]Lokhlass[CR]!", german=" Danke, [CS:N]Lapras[CR]!", italian=" Grazie, [CS:N]Lapras[CR]!", spanish=" ¡Gracias, [CS:N]Lapras[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="This is the extent of what I can\ndo for you.", french="C'est tout ce que je peux faire\npour vous.", german="Damit habe ich meine\nMöglichkeiten erschöpft, euch zu helfen.", italian="Questo è tutto quello che posso\nfare per voi.", spanish="Esto es todo lo que puedo hacer\npara ayudaros."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="From here, you're on your\nown.[K] Good luck on reaching [CS:P]Temporal Tower[CR]!", french="A partir d'ici, vous ne pouvez\ncompter que sur vous-mêmes.[K] Bonne chance\npour atteindre la [CS:P]Tour du Temps[CR]!", german="Ab hier seid ihr auf euch allein\ngestellt.[K] Viel Glück beim Erreichen des\n[CS:P]Zeitturms[CR]!", italian="Da qui in avanti, ve la dovrete\ncavare con le vostre forze.[K] Buona fortuna\nper il viaggio verso la [CS:P]Torre del Tempo[CR]!", spanish="A partir de aquí no os puedo\nacompañar.[K] ¡Buena suerte en\nvuestro viaje a la [CS:P]Torre del Tiempo[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" Merci encore!", german=" Okay!", italian=" Ok!", spanish=" ¡Gracias!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" Merci encore!", german=" Okay!", italian=" Ok!", spanish=" ¡Gracias!"})
  else
  SkySceneKit.say({english=" OK!", french=" Merci encore!", german=" Okay!", italian=" Ok!", spanish=" ¡Gracias!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]! [hero]!", french=" [CS:N]Massko[CR]! [hero]!", german=" [CS:N]Reptain[CR]! [hero]!", italian=" [CS:N]Grovyle[CR]! [hero]!", spanish=" ¡[CS:N]Grovyle[CR]! ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]! [hero]!", french=" [CS:N]Massko[CR]! [hero]!", german=" [CS:N]Reptain[CR]! [hero]!", italian=" [CS:N]Grovyle[CR]! [hero]!", spanish=" ¡[CS:N]Grovyle[CR]! ¡[hero]!"})
  else
  SkySceneKit.say({english=" [CS:N]Grovyle[CR]! [hero]!", french=" [CS:N]Massko[CR]! [hero]!", german=" [CS:N]Reptain[CR]! [hero]!", italian=" [CS:N]Grovyle[CR]! [hero]!", spanish=" ¡[CS:N]Grovyle[CR]! ¡[hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We don't have far to go now!\nLet's keep it up!", french="Ce n'est plus très loin!\nAccrochons-nous!", german="Wir müssen nicht mehr weit\ngehen! Lasst uns weitermachen.", italian="Non manca più molta strada!\nDiamoci dentro!", spanish="¡Ya no queda mucho!\n¡Hay que seguir adelante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We don't have far to go now!\nLet's keep it up!", french="Ce n'est plus très loin!\nAccrochons-nous!", german="Wir müssen nicht mehr weit\ngehen! Lasst uns weitermachen.", italian="Non manca più molta strada!\nDiamoci dentro!", spanish="¡Ya no queda mucho!\n¡Hay que seguir adelante!"})
  else
  SkySceneKit.say({english="We're almost there! Let's keep\nit up!", french="Ce n'est plus très loin!\nAccrochons-nous!", german="Wir müssen nicht mehr weit\ngehen! Lasst uns weitermachen.", italian="Non manca più molta strada!\nDiamoci dentro!", spanish="¡Ya no queda mucho!\n¡Hay que seguir adelante!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
