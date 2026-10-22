-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P31A/m23a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(37, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(24, 3) -- $SCENARIO_MAIN = scn[24,3] (ROM)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]we've gone deep, but...", french="Eh bien...[K] ça fait un moment\nqu'on descend, mais...", german="Nun...[K] Wir sind tief\nhinabgestiegen, aber...", italian="Beh...[K] Abbiamo fatto parecchia\nstrada...", spanish="Bueno...[K] Ya hemos descendido\nbastante, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well...[K]we've descended quite a\nways, but...", french="Eh bien...[K] ça fait un moment\nqu'on descend, mais...", german="Nun...[K] Wir sind tief\nhinabgestiegen, aber...", italian="Beh...[K] Siamo scesi abbastanza\nin profondità...", spanish="Bueno...[K] Ya hemos descendido\nbastante, pero..."})
  else
  SkySceneKit.say({english="Well...[K]we've descended quite a\nways, but...", french="Eh bien...[K] ça fait un moment\nqu'on descend, mais...", german="Nun...[K] Wir sind tief\nhinabgestiegen, aber...", italian="Beh...[K] Siamo abbastanza in\nprofondità...", spanish="Bueno...[K] Ya hemos descendido\nbastante, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We still haven't caught up to\n[CS:N]Chatot[CR] or Team [CS:X]Skull[CR].", french="... toujours aucune trace de\n[CS:N]Pijako[CR] ni de l'Equipe [CS:X]Crâne[CR].", german="Wir haben weder zu [CS:N]Plaudagei[CR]\nnoch zu Team [CS:X]Totenkopf[CR] aufgeholt.", italian="Però non abbiamo ancora\nraggiunto né [CS:N]Chatot[CR], né il Team [CS:X]Teschio[CR].", spanish="Aún no hemos alcanzado a [CS:N]Chatot[CR]\nni al [CS:X]Equipo Calavera[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We haven't caught up to [CS:N]Chatot[CR]\nor Team [CS:X]Skull[CR] yet.", french="... toujours aucune trace de\n[CS:N]Pijako[CR] ni de l'Equipe [CS:X]Crâne[CR].", german="Wir haben weder zu [CS:N]Plaudagei[CR]\nnoch zu Team [CS:X]Totenkopf[CR] aufgeholt.", italian="Però non abbiamo ancora\nraggiunto né [CS:N]Chatot[CR], né il Team [CS:X]Teschio[CR].", spanish="Aún no hemos alcanzado a [CS:N]Chatot[CR]\nni al [CS:X]Equipo Calavera[CR]."})
  else
  SkySceneKit.say({english="We still haven't caught up to\n[CS:N]Chatot[CR] or Team [CS:X]Skull[CR]...", french="... toujours aucune trace de\n[CS:N]Pijako[CR] ni de l'Equipe [CS:X]Crâne[CR].", german="Wir haben weder zu [CS:N]Plaudagei[CR]\nnoch zu Team [CS:X]Totenkopf[CR] aufgeholt.", italian="Però non abbiamo ancora\nraggiunto né [CS:N]Chatot[CR], né il Team [CS:X]Teschio[CR].", spanish="Aún no hemos alcanzado a [CS:N]Chatot[CR]\nni al [CS:X]Equipo Calavera[CR]."})
  end
  -- message_Close
  -- back_SetGround(LEVEL_D26P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 280, 264, Direction.Down, "NPC_SUKATANKU")
  -- SetAnimation(24) [anim idle native]
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 248, 256, Direction.Down, "NPC_ZUBATTO")
  -- SetAnimation(24) [anim idle native]
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 328, 288, Direction.Down, "NPC_DOGAASU")
  -- SetAnimation(24) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 292, 532, false, 2)
  GROUND:MoveToPosition(partner, 260, 532, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This place...[K] It's really hot\nand humid!", french="Et cet endroit...[K] Quelle étuve!\nQu'est-ce qu'il fait chaud!", german="Aber... Dieser Ort...[K] Er ist\nunheimlich heiß und feucht!", italian="In questo posto...[K] c'è un'afa\ntremenda!", spanish="Uf...[K] ¡Menuda humedad! ¡Y qué\ncalor que hace aquí dentro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This place...[K] It's horribly hot\nand humid in here!", french="Et cet endroit...[K] Quelle étuve!\nQu'est-ce qu'il fait chaud!", german="Aber... Dieser Ort...[K] Es ist\nfurchtbar heiß und feucht hier!", italian="Questo posto...[K] è terribilmente\ncaldo e umido!", spanish="Uf...[K] ¡Menuda humedad! ¡Y qué\ncalor que hace aquí dentro!"})
  else
  SkySceneKit.say({english="This place...[K] It's horribly hot\nand humid!", french="Et cet endroit...[K] Quelle étuve!\nQu'est-ce qu'il fait chaud!", german="Aber... Dieser Ort...[K] Es ist\nfurchtbar heiß und feucht hier!", italian="Questo posto...[K] è terribilmente\ncaldo e umido!", spanish="Uf...[K] ¡Menuda humedad! ¡Y qué\ncalor que hace aquí dentro!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Gggh...", french=" Gggh...", german=" Gggh...", italian=" Gggh...", spanish=" Grr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! I heard a voice over there!", french="Eh, j'ai entendu une voix\npar là-bas!", german="Hey! Ich habe da drüben eine\nStimme gehört!", italian="Ehi! Ho sentito una voce venire\nda là!", spanish=" ¡Vaya! ¡He oído algo por allí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! I heard a voice over there!", french="Eh, j'ai entendu une voix\npar là-bas!", german="Hey! Ich habe da drüben eine\nStimme gehört!", italian="Ehi! Ho sentito una voce venire\nda là!", spanish=" ¡Vaya! ¡He oído algo por allí!"})
  else
  SkySceneKit.say({english="Oh! That voice came from\nover there!", french="Eh, j'ai entendu une voix\npar là-bas!", german="Oh! Diese Stimme kam von\ndort drüben.", italian=" Ah! Quella voce veniva da là!", spanish=" ¡Vaya! ¡He oído algo por allí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's check it out, [hero]!", french="Allons voir,\n[hero]!", german="Finden wir heraus, was oder\nwer es ist, [hero]!", italian="Andiamo a controllare,\n[hero]!", spanish=" ¡Vamos para allá, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero]!", french="Allons voir,\n[hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos para allá, [hero]!"})
  else
  SkySceneKit.say({english=" Let's go, [hero]!", french="Allons voir,\n[hero]!", german=" Gehen wir, [hero]!", italian=" Andiamo, [hero]!", spanish=" ¡Vamos para allá, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 260, 308, false, 2)
  pcall(function() GAME:MoveCamera(276, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 292, 308, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! It's Team [CS:X]Skull[CR]!", french=" Eh, c'est l'Equipe [CS:X]Crâne[CR]!", german=" Hey! Es ist Team [CS:X]Totenkopf[CR]!", italian=" Ehi! È il Team [CS:X]Teschio[CR]!", spanish=" ¡Mira! ¡Es el [CS:X]Equipo Calavera[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! It's Team [CS:X]Skull[CR]!", french=" Eh, c'est l'Equipe [CS:X]Crâne[CR]!", german=" Wow! Es ist Team [CS:X]Totenkopf[CR]!", italian=" Wow! È il Team [CS:X]Teschio[CR]!", spanish=" ¡Mira! ¡Es el [CS:X]Equipo Calavera[CR]!"})
  else
  SkySceneKit.say({english=" Oh! It's Team [CS:X]Skull[CR]!", french=" Eh, c'est l'Equipe [CS:X]Crâne[CR]!", german=" Oh! Es ist Team [CS:X]Totenkopf[CR]!", italian=" Oh! È il Team [CS:X]Teschio[CR]!", spanish=" ¡Mira! ¡Es el [CS:X]Equipo Calavera[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Urggghhh...", french=" Arggghhh...", german=" Urggghhh...", italian=" Urggghhh...", spanish=" Ayyyyy..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 260, 276, false, 2)
  GROUND:MoveToPosition(hero, 304, 284, false, 2)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogaasu, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what happened here?!", french="Mais... qu'est-ce qui s'est passé\nici?!", german=" W-was ist hier passiert?", italian=" C-Cosa è successo qui?!", spanish=" ¡¿Qué ha pasado aquí?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what happened to you guys?!", french="Mais... qu'est-ce qui s'est passé\nici?!", german="W-was ist mit euch geschehen,\nLeute?", italian=" C-Cosa vi è successo ragazzi?!", spanish=" ¡¿Qué os ha pasado?!"})
  else
  SkySceneKit.say({english=" Wh-what happened to you?!", french="Mais... qu'est-ce qui s'est passé\nici?!", german=" W-was ist mit euch geschehen?", italian=" C-Cosa vi è successo?!", spanish=" ¡¿Qué os ha pasado?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No way![K] Were you taken down\nby a mysterious bunch of enemies?", french="Pas possible![K] C'est une bande\nd'ennemis mystérieux qui vous a flanqué\ncette raclée?", german="Oh nein![K] Seid ihr von einem\nmysteriösen Haufen von Gegnern erledigt\nworden?", italian="Aspetta![K] Sono stati quei nemici\nmisteriosi a ridurvi così?", spanish="¡Oh, no![K] ¿Os ha atacado un grupo\nmisterioso de enemigos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh! No way![K] Were you\nattacked by a mysterious gang of enemies?", french="Pas possible![K] C'est une bande\nd'ennemis mystérieux qui vous a flanqué\ncette raclée?", german="Oh! Nein![K] Seid ihr von einer\ngeheimnisvollen Gruppe von Gegnern\nangegriffen worden?", italian="Aspetta![K] Sono stati quei nemici\nmisteriosi a ridurvi così?", spanish="¡Oh, no![K] ¿Os ha atacado un grupo\nmisterioso de enemigos?"})
  else
  SkySceneKit.say({english="Wait! It can't be![K] Were you\nattacked by a mysterious gang of enemies?", french="Pas possible![K] C'est une bande\nd'ennemis mystérieux qui vous a flanqué\ncette raclée?", german="Warte! Das kann nicht sein![K] Seid\nihr von einer geheimnisvollen Gruppe von\nGegnern angegriffen worden?", italian="Aspetta![K] Sono stati quei nemici\nmisteriosi a ridurvi così?", spanish="¡No puede ser![K] ¿Os ha atacado\nun grupo misterioso de enemigos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho...[K] You knew it was\ncoming? Would've been good to know that...", french="Mouarf...[K] Quoi, vous étiez\nau courant? Vous auriez pu nous\nprévenir, ça aurait été sympa...", german="Whoaho...[K] Hast du das\nvorhersehen können? Wäre hilfreich gewesen,\ndas zu wissen...", italian="Uooh-oh...[K] Voi sapevate che\nc'erano? Sarebbe stato bello saperlo...", spanish="Jo, jo...[K] ¿Ya sabíais que iba a\npasar algo así? Hubiera estado bien saberlo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Not that you'd...[K]tell us...[K]heh-heh.", french="Je m'attendais pas...[K] à mieux\nde votre part...[K] hin hin.", german="Nicht, dass ihr...[K] es uns erzählt\nhättet...[K] Hehe.", italian="Non potevate...[K] dircelo?[K]\nEh-eh.", spanish="Claro, tampoco ibais a...[K]\ndecírnoslo...[K] Jue, jue."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]! Are you all right?!", french=" [CS:N]Moufflair[CR]! Tu vas bien?!", german=" [CS:N]Skuntank[CR]! Alles okay mit dir?!?", italian=" [CS:N]Skuntank[CR]! Stai bene?!", spanish=" ¡[CS:N]Skuntank[CR]! ¡¿Estás bien?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]! Are you all right?!", french=" [CS:N]Moufflair[CR]! Tu vas bien?!", german=" [CS:N]Skuntank[CR]! Alles okay mit dir?!?", italian=" [CS:N]Skuntank[CR]! Stai bene?!", spanish=" ¡[CS:N]Skuntank[CR]! ¡¿Estás bien?!"})
  else
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]! Are you all right?!", french=" [CS:N]Moufflair[CR]! Tu vas bien?!", german=" [CS:N]Skuntank[CR]! Alles okay mit dir?!?", italian=" [CS:N]Skuntank[CR]! Stai bene?!", spanish=" ¡[CS:N]Skuntank[CR]! ¡¿Estás bien?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw...[K] You find us at\nyour mercy...[K]and you're worried how we are?", french="Gnark gnark gnark...[K] Nous\nvoilà à votre merci...[K] et vous vous inquiétez\nde notre santé?", german="Cha-ha-ha...[K] Wir sind eurer\nGnade ausgeliefert...[K] Und du fragst mich, ob\nwir okay sind?", italian="Ahr-ahr-ahr...[K] Siamo in vostro\npotere...[K] e vi preoccupate di chiederci come\nstiamo?", spanish="Jua, jua, jua...[K]\nNos tenéis a vuestra merced...[K]\n¿y os preocupa cómo estamos?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="How sickeningly generous can\nyou nitwits be!", french="C'est écœurant ce que vous\npouvez dégouliner de générosité, bande\nd'imbéciles!", german="Wie ekelerregend großzügig\nkönnt ihr Trottel denn noch sein?!?", italian="Voi schiappe riuscite ad essere\ngenerose fino alla nausea!", spanish=" ¡Lo vuestro es enfermizo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're not about to walk away\nfrom anyone when they're down.", french="Ce n'est pas notre genre\nd'abandonner un Pokémon à terre.", german="Wir lassen niemanden zurück,\nder am Boden liegt.", italian="Non possiamo ignorare qualcuno\nche è ferito.", spanish="No vamos a abandonar\na su suerte a alguien que ha caído."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're not about to walk away\nfrom anyone if they're hurt.", french="Ce n'est pas notre genre\nd'abandonner un Pokémon à terre.", german="Wir lassen niemanden zurück,\nwenn er verletzt ist.", italian="Non possiamo ignorare qualcuno\nche è ferito.", spanish="No vamos a abandonar\na su suerte a alguien que ha caído."})
  else
  SkySceneKit.say({english="We can't just ignore someone if\nthey're hurt.", french="Ce n'est pas notre genre\nd'abandonner un Pokémon à terre.", german="Wir können jemanden nicht\neinfach ignorieren, wenn er verletzt ist.", italian="Non possiamo ignorare qualcuno\nche è ferito.", spanish="No vamos a abandonar\na su suerte a alguien que ha caído."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw...[K] Your concern's\nwasted on us. We'll be fine.", french="Gnark gnark gnark...[K] Inutile\nde vous faire du mouron pour nous.\nÇa va aller!", german="Cha-ha-ha...[K] Eure Sorge zielt\nins Leere. Wir kommen wieder auf die Beine.", italian="Ahr-ahr-ahr...[K] Le vostre\npreoccupazioni sono sprecate. Presto staremo\nbene.", spanish="Jua, jua, jua...[K]\nVuestra preocupación es del todo\ninnecesaria. Vamos a salir de esta."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That pompous [CS:N]Chatot[CR]...[K] He riled\nme up enough to keep me going!", french="C'est l'autre prétentieux de\n[CS:N]Pijako[CR]...[K] Il m'a mis les nerfs en boule, alors\nje vais m'accrocher!", german="Dieser aufgeblasene [CS:N]Plaudagei[CR]...[K]\nEr hat mich genug geärgert, damit ich\ndurchhalte!", italian="Quel presuntuoso di [CS:N]Chatot[CR]...[K]\nMi ha infastidito a tal punto che ho deciso di\nproseguire!", spanish="Ese pesado de [CS:N]Chatot[CR]...[K]\n¡Me ha irritado tanto que no he tenido\nni ocasión de perder el conocimiento!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? [CS:N]Chatot[CR] did what?!", french=" Hein? [CS:N]Pijako[CR] a fait quoi?!", german="Häh? Was hat [CS:N]Plaudagei[CR]\ngetan?!?", italian=" Eh? Cos'ha fatto [CS:N]Chatot[CR]?!", spanish=" ¿Qué? ¡¿Que [CS:N]Chatot[CR] hizo qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? [CS:N]Chatot[CR] did what?!", french=" Hein? [CS:N]Pijako[CR] a fait quoi?!", german="Häh? Was hat [CS:N]Plaudagei[CR]\ngetan?!?", italian=" Eh? Cos'ha fatto [CS:N]Chatot[CR]?!", spanish=" ¿Qué? ¡¿Que [CS:N]Chatot[CR] hizo qué?!"})
  else
  SkySceneKit.say({english=" Pardon?! [CS:N]Chatot[CR] did what?!", french=" Hein? [CS:N]Pijako[CR] a fait quoi?!", german="Bitte? Was hat [CS:N]Plaudagei[CR]\ngetan?!?", italian=" Scusa? Cos'ha fatto [CS:N]Chatot[CR]?!", spanish=" ¿Qué? ¡¿Que [CS:N]Chatot[CR] hizo qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Here's what he did!", french=" Voilà ce qu'il a fait!", german=" Das hat er getan!", italian=" Che cosa ha fatto?!", spanish=" ¡Eso fue lo que hizo!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That [CS:N]Chatot[CR] came along after\nwe got wiped out!", french="[CS:N]Pijako[CR] est arrivé juste après\nnotre déculottée!", german="Dieser [CS:N]Plaudagei[CR] kam erst lange\nnachdem wir niedergestreckt wurden vorbei!", italian="[CS:N]Chatot[CR] è arrivato dopo\nche eravamo stati sconfitti!", spanish="Ese [CS:N]Chatot[CR] llegó justo después\nde que nos dejaran fuera de combate."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="When he spotted us down and\nout...", french=" Quand il nous a vus à terre...", german=" Als er uns am Boden liegen sah...", italian="Quando ci ha visto qui senza\nforze...", spanish=" Cuando nos vio aquí tirados..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="he scolded us with all sorts of\nchoice words...chaw-haw-haw!", french="... il nous a remonté les\nbretelles, sans prendre de gants...\nGnark gnark gnark!", german="Da beschimpfte er uns mit einer\nReihe sehr gewählter Worte... Cha-ha-ha!", italian="... ce ne ha dette di tutti i\ncolori... Ahr-ahr-ahr!", spanish="¡Empezó a echarnos la bronca\ncon todo su repertorio de improperios!\n¡Jua, jua, jua!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="After giving us that blistering\ntongue-lashing, he went on his way.", french=" Après ça, il a continué sa route.", german="Nach seiner Schimpftirade ging\ner seines Weges.", italian="Dopo averci fatto questa\nirritante lavata di capo, ha proseguito per\nla sua strada.", spanish="Tras obsequiarnos con una buena\nración de exabruptos, siguió su camino."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="The things he said about us...\nI'm still seeing red.", french="Toutes ces choses qu'il nous a\ndites... Quand j'y pense, je suis vert!", german="Was er über uns gesagt hat...\nIch sehe immer noch rot.", italian="Le cose che ha detto su di noi...\nCi vedo ancora rosso!", spanish="Me sacó de quicio con todo lo\nque dijo."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="I am so steaming mad that I\nrefuse to give up here.", french="Je suis si furax que je refuse\nde baisser les bras.", german="Ich schäume so sehr vor Wut,\ndass ich auf keinen Fall hier aufgeben will.", italian="Mi ha fatto infuriare a tal punto,\nche ho deciso di proseguire.", spanish="Me ha irritado tanto que me\nniego a quedarme aquí tirado."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="I'm getting out of here if I\nhave to crawl...[K]so I can deliver my payback\nto that blasted [CS:N]Chatot[CR]!", french="Je sortirai d'ici en rampant\ns'il le faut...[K] juste pour rendre la monnaie\nde sa pièce à ce [CS:N]Pijako[CR]!", german="Ich komme hier heraus, und\nwenn ich kriechen muss...[K] Damit ich es diesem\nmiesen [CS:N]Plaudagei[CR] heimzahlen kann!", italian="Uscirò di qui, anche\nstrisciando...[K] così gliela farò pagare a quello\nsputasentenze di [CS:N]Chatot[CR]!", spanish="Voy a salir aunque tenga que\narrastrarme...[K] ¡para poder vengarme de\nese condenado [CS:N]Chatot[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" But...[K]if you think about it...", french=" Pourtant...[K] il faut avouer...", german="Aber...[K] bei längerem\nNachdenken...", italian=" Ma...[K] se ci pensi...", spanish=" Aunque...[K] ahora que lo pienso..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="We were close to giving up,\nwhen that [CS:N]Chatot[CR] saved us by riling us up...[K]\nChaw-haw-haw!", french="... qu'on était sur le point de se\nrendre quand [CS:N]Pijako[CR] est venu nous sauver\nen nous haranguant...[K] Gnark gnark gnark!", german="Wir waren nah am Aufgeben, als\nuns dieser [CS:N]Plaudagei[CR] mit seiner Schimpferei\nrettete...[K] Cha-ha-ha!", italian="Stavamo per mollare tutto e\n[CS:N]Chatot[CR] con la sua rampogna\nci ha fatto cambiare idea...[K] Ahr-ahr-ahr!", spanish="Sin la reprimenda de [CS:N]Chatot[CR] lo\nmismo nos habríamos rendido y estaríamos ya\npara el arrastre...[K] ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But even though you say\nyou've been saved...", french="Vous avez beau dire qu'il vous a\nsauvés...", german="Aber auch, wenn ihr sagt, ihr\nwärt gerettet worden...", italian=" Dite di voler continuare...", spanish="Tal vez pienses que os ha\nsalvado, pero aun así..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But even though you say\nyou've been saved...", french="Vous avez beau dire qu'il vous a\nsauvés...", german="Aber auch, wenn ihr sagt, ihr\nwärt gerettet worden...", italian=" Dite di voler continuare...", spanish="Tal vez pienses que os ha\nsalvado, pero aun así..."})
  else
  SkySceneKit.say({english="But even though you say\nyou've been saved...", french="Vous avez beau dire qu'il vous a\nsauvés...", german="Aber auch, wenn ihr sagt, ihr\nwärt gerettet worden...", italian=" Dite di voler continuare...", spanish="Tal vez pienses que os ha\nsalvado, pero aun así..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You still look pretty badly hurt.", french="... vous avez quand même l'air\nmal en point.", german="Ihr seht immer noch recht\nschwer verletzt aus.", italian="Però sembrate ancora piuttosto\nmalconci.", spanish="Lo cierto es que tenéis\nun aspecto lamentable."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You look like you're still in a lot\nof pain.", french="... vous avez quand même l'air\nmal en point.", german="Ihr seht aus, als hättet ihr\nimmer noch starke Schmerzen.", italian="Però sembrate ancora piuttosto\nmalconci.", spanish="Lo cierto es que tenéis\nun aspecto lamentable."})
  else
  SkySceneKit.say({english="You look like you're still\nsuffering.", french="... vous avez quand même l'air\nmal en point.", german="Ihr seht aus, als würdet ihr\nimmer noch leiden.", italian="Però sembrate ancora piuttosto\nmalconci.", spanish="Lo cierto es que tenéis\nun aspecto lamentable."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw...[K] We've been\nbad to you two all this time.", french="Gnark gnark gnark...[K] On n'a pas\nété sympas avec vous pendant tout ce temps.", german="Cha-ha-ha...[K] Wir waren all die\nZeit gemein zu euch.", italian="Ahr-ahr-ahr...[K] Siamo stati\ncrudeli con voi per tutto questo tempo.", spanish="Jua, jua, jua...[K]\nOs hemos tratado realmente mal."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="You went through downright\nrotten times because of us.", french="On peut même dire qu'on a tout\nfait pour vous pourrir la vie.", german="Unseretwegen musstet ihr ein\npaar ziemlich schlimme Dinge durchmachen.", italian="Ve la siete vista brutta più\nvolte per colpa nostra.", spanish="Lo habéis pasado fatal por\nnuestra culpa."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="But...[K]you two still can bring\nyourselves to worry about the likes of us?", french="Et pourtant...[K] vous vous\ninquiétez encore pour des types de\nnotre genre?", german="Aber...[K] Ihr zwei könnt euch\nimmer noch dazu durchringen, euch um Leute\nwie unsereins zu sorgen?", italian="Ma...[K] voi due vi preoccupate\nlo stesso di come stiamo?", spanish="Y aun así...[K] ¿sois capaces\nde preocuparos por lo que nos pueda pasar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yup.[K] Sure, there were lots of\nthings you did that made us angry.", french="Ouais.[K] C'est sûr que vous avez\ntout fait pour qu'on vous déteste.", german="Jep.[K] Sicher gab es einiges,\nwomit ihr uns geärgert habt.", italian="Già.[K] Certo, ci avete fatto\narrabbiare un sacco di volte.", spanish="Sí.[K] Desde luego nos habéis hecho\ntodo tipo de faenas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] You did make us furious\nover this and that.", french="Ouais.[K] C'est sûr que vous avez\ntout fait pour qu'on vous déteste.", german="Ja.[K] Ihr habt uns mit der ein\noder anderen Sache wirklich wütend gemacht.", italian="Sì.[K] Ci avete fatto infuriare\ndiverse volte.", spanish="Sí.[K] Desde luego nos habéis hecho\ntodo tipo de faenas."})
  else
  SkySceneKit.say({english="Yep.[K] Sure, there were times\nthat you made us angry.", french="Ouais.[K] C'est sûr que vous avez\ntout fait pour qu'on vous déteste.", german="Jep.[K] Sicher habt ihr uns einige\nMale wütend gemacht.", italian="Già.[K] Certo, a volte ci avete\nfatto arrabbiare.", spanish="Sí.[K] Desde luego nos habéis hecho\ntodo tipo de faenas."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But when we see you down and\nout like this...[K]we can't just walk away.", french="Mais quand on vous voit à terre\ncomme ça...[K] on ne peut pas vous laisser\ntomber.", german="Aber wenn wir euch so am\nBoden liegen sehen...[K] Dann können wir nicht\neinfach so vorbeigehen.", italian="Ma vedendovi messi così\nmale...[K] non riusciamo a far finta di nulla.", spanish="Pero, al veros así...[K]\nNo podemos dejaros ahí tirados."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But when we see you down and\nout like this...[K]we can't just walk away.", french="Mais quand on vous voit à terre\ncomme ça...[K] on ne peut pas vous laisser\ntomber.", german="Aber wenn wir euch so am\nBoden liegen sehen...[K] Dann können wir nicht\neinfach so vorbeigehen.", italian="Ma vedendovi messi così\nmale...[K] non riusciamo a far finta di nulla.", spanish="Pero, al veros así...[K]\nNo podemos dejaros ahí tirados."})
  else
  SkySceneKit.say({english="But when we see you down and\nout like this...[K]we can't just walk away.", french="Mais quand on vous voit à terre\ncomme ça...[K] on ne peut pas vous laisser\ntomber.", german="Aber wenn wir euch so am\nBoden liegen sehen...[K] Dann können wir nicht\neinfach so vorbeigehen.", italian="Ma vedendovi messi così\nmale...[K] non riusciamo a far finta di nulla.", spanish="Pero, al veros así...[K]\nNo podemos dejaros ahí tirados."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw-haw...[K]haw-haw...", french=" Gnark gnark gnark...[K] hé hé...", german=" Cha-ha-ha...[K] ha-ha...", italian=" Ahr-ahr-ahr...[K] Ahr-ahr...", spanish=" Jua, jua, jua...[K] jua, jua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6406) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- Move2PositionMark<object OBJECT_G01P01A1_93> [prop décor NDS, géré par le rendu du ground]
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! The Relic Fragment!", french=" Eh, le Fragment de Relique!", german=" Hey! Das Reliktfragment!", italian=" Ehi! Il Frammento Antico!", spanish=" ¡Eh! ¡La Reliquia de Piedra!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! The Relic Fragment!", french=" Eh, le Fragment de Relique!", german=" Hey! Das Reliktfragment!", italian=" Ehi! Il Frammento Antico!", spanish=" ¡Eh! ¡La Reliquia de Piedra!"})
  else
  SkySceneKit.say({english=" Hey! The Relic Fragment!", french=" Eh, le Fragment de Relique!", german=" Hey! Das Reliktfragment!", italian=" Ehi! Il Frammento Antico!", spanish=" ¡Eh! ¡La Reliquia de Piedra!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sukatanku, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw-haw...oops![K]\nHow unlike me!", french="Hum... oups![K] Voilà qui\nne me ressemble pas!", german="Cha-ha-ha... Ups![K] Das ist sonst\ngar nicht meine Art!", italian="Ahr-ahr-ahr... oops![K]\nChe sbadato!", spanish="Jua, jua, jua... ¡Oh, vaya![K]\n¿Cómo me ha podido pasar?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That Relic Fragment slipped out\nof my grip...", french="Le Fragment de Relique m'a\néchappé...", german="Das Reliktfragment ist mir aus\nder Hand gerutscht...", italian="Il Frammento Antico mi è\ncaduto...", spanish="Se me ha escapado de\nlas manos..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw...[K]and I can't move yet.", french="Oh là là...[K] je suis incapable\nde faire le moindre geste.", german="Cha-ha...[K] Und ich kann mich\nimmer noch nicht bewegen.", italian="Ahr-ahr...[K] Non riesco ancora\na muovermi.", spanish="Jua, jua...[K]\nY no puedo ni moverme."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That [partner] is going to\nsteal it back...chaw-haw-haw...", french="Oh non, je parie que\n[partner] va s'en emparer...", german="[partner] wird es\nzurückstehlen... Cha-ha-ha...", italian="[partner] potrà\nriprenderselo... Ahr-ahr-ahr...", spanish="[partner] va a recuperarla...\nJua, jua, jua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...", french=" [CS:N]Moufflair[CR]...", german=" [CS:N]Skuntank[CR]...", italian=" [CS:N]Skuntank[CR]...", spanish=" [CS:N]Skuntank[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...", french=" [CS:N]Moufflair[CR]...", german=" [CS:N]Skuntank[CR]...", italian=" [CS:N]Skuntank[CR]...", spanish=" [CS:N]Skuntank[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...", french=" [CS:N]Moufflair[CR]...", german=" [CS:N]Skuntank[CR]...", italian=" [CS:N]Skuntank[CR]...", spanish=" [CS:N]Skuntank[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="I only dropped the Relic\nFragment by accident...", french="Je ne l'ai pas fait exprès,\nle Fragment de Relique m'a glissé des mains...", german="Ich habe das Reliktfragment nur\naus Versehen fallen lassen...", italian="Ho fatto cadere il Frammento\nAntico solo per sbaglio...", spanish="Solo se me ha caído por\naccidente..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="You're free to pick it up.\nOr not.", french="Vous êtes libres de le ramasser.\nOu pas.", german="Du kannst es jetzt aufheben.\nOder auch nicht.", italian=" Puoi prenderlo. O lasciarlo lì.", spanish="Ahora es cosa vuestra.\nPodéis cogerla o no."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...[K] Thanks.", french=" [CS:N]Moufflair[CR]...[K] Merci.", german=" [CS:N]Skuntank[CR]...[K] Danke.", italian=" [CS:N]Skuntank[CR]...[K] Grazie.", spanish=" [CS:N]Skuntank[CR]...[K] Gracias."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...[K] Thanks.", french=" [CS:N]Moufflair[CR]...[K] Merci.", german=" [CS:N]Skuntank[CR]...[K] Danke.", italian=" [CS:N]Skuntank[CR]...[K] Grazie.", spanish=" [CS:N]Skuntank[CR]...[K] Gracias."})
  else
  SkySceneKit.say({english=" [CS:N]Skuntank[CR]...[K] Thanks.", french=" [CS:N]Moufflair[CR]...[K] Merci.", german=" [CS:N]Skuntank[CR]...[K] Danke.", italian=" [CS:N]Skuntank[CR]...[K] Grazie.", spanish=" [CS:N]Skuntank[CR]...[K] Gracias."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Humph. Why thank me?", french=" Pfff! Merci pour quoi?", german=" Grmpf. Wofür der Dank?", italian=" Uff... Perché mi ringrazi?", spanish="Vaya. ¿Por qué me das\nlas gracias?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="The next time we meet, we're\ngoing to be back to our old tricks of messing\nwith you...chaw-haw-haw...", french="La prochaine fois qu'on se verra,\non se remettra à vous jouer des sales tours...", german="Beim nächsten Mal greifen wir\nwieder auf unsere alten Tricks zurück, um\nes mit euch aufzunehmen. Cha-ha-ha...", italian="La prossima volta che ci\nincontriamo, torneremo a usare i nostri\nvecchi trucchi per gabbarvi... Ahr-ahr-ahr...", spanish="La próxima vez que os veamos,\nvamos a volver a tratar de haceros alguna\nperrería... Jua, jua, jua..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Besides, don't waste your time\nworrying about us.", french="Et pas la peine de perdre votre\ntemps à vous en faire pour nous.", german="Ah ja, verschwendet nicht eure\nZeit damit, euch um uns Sorgen zu machen.", italian="E poi, non sprecate tempo a\npreoccuparvi per noi.", spanish="Además, no os preocupéis tanto\npor nosotros..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="You should be worrying about\n[CS:N]Chatot[CR] instead.", french=" Souciez-vous plutôt de [CS:N]Pijako[CR].", german="Ihr solltet euch lieber Sorgen\num [CS:N]Plaudagei[CR] machen.", italian="Dovreste preoccuparvi per\n[CS:N]Chatot[CR], piuttosto.", spanish=" Y centraros mejor en [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_OH_NO non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's right![K] Where is [CS:N]Chatot[CR]?", french=" C'est vrai![K] Où est parti [CS:N]Pijako[CR]?", german=" Das stimmt![K] Wo ist [CS:N]Plaudagei[CR]?", italian=" È vero![K] Dov'è [CS:N]Chatot[CR]?", spanish=" ¡Es verdad![K] ¿Dónde está?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's right![K] Where did\n[CS:N]Chatot[CR] go?", french=" C'est vrai![K] Où est parti [CS:N]Pijako[CR]?", german="Das stimmt![K] Wo ist [CS:N]Plaudagei[CR]\nhingegangen?", italian=" È vero![K] Dov'è andato [CS:N]Chatot[CR]?", spanish=" ¡Es verdad![K] ¿Dónde está?"})
  else
  SkySceneKit.say({english="That's right![K] Where did\n[CS:N]Chatot[CR] go?", french=" C'est vrai![K] Où est parti [CS:N]Pijako[CR]?", german="Das stimmt![K] Wo ist [CS:N]Plaudagei[CR]\nhingegangen?", italian=" È vero![K] Dov'è andato [CS:N]Chatot[CR]?", spanish=" ¡Es verdad![K] ¿Dónde está?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="He went deeper... He's going\nafter those enemies...", french="Il a continué... Il s'est lancé\nà la poursuite des ennemis...", german="Er ist tiefer hinuntergegangen...\nEr ist hinter diesen Gegnern her...", italian="Ha proseguito verso il fondo\ndella grotta... Sta andando incontro a quei\nnemici...", spanish="Ha seguido adelante.\nVa tras esos Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" You two hurry up and go too.", french=" Dépêchez-vous de le rejoindre.", german="Ihr zwei solltet euch beeilen und\nhinterhergehen.", italian=" Spicciatevi e andate anche voi.", spanish=" Daos prisa y alcanzadle."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 276, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thanks, [CS:N]Skuntank[CR].", french=" Merci, [CS:N]Moufflair[CR].", german=" Danke, [CS:N]Skuntank[CR].", italian=" Grazie, [CS:N]Skuntank[CR].", spanish=" Gracias, [CS:N]Skuntank[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thanks, [CS:N]Skuntank[CR].", french=" Merci, [CS:N]Moufflair[CR].", german=" Danke, [CS:N]Skuntank[CR].", italian=" Grazie, [CS:N]Skuntank[CR].", spanish=" Gracias, [CS:N]Skuntank[CR]."})
  else
  SkySceneKit.say({english=" Thanks, [CS:N]Skuntank[CR].", french=" Merci, [CS:N]Moufflair[CR].", german=" Danke, [CS:N]Skuntank[CR].", italian=" Grazie, [CS:N]Skuntank[CR].", spanish=" Gracias, [CS:N]Skuntank[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're going in deeper\nafter them.", french=" On les suit.", german="Wir gehen tiefer hinein und\nnehmen es mit ihnen auf.", italian=" Lo seguiremo più in profondità.", spanish=" Vamos a seguirles la pista."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're going in deeper\nafter them.", french=" On les suit.", german="Wir gehen tiefer hinein und\nnehmen es mit ihnen auf.", italian=" Lo seguiremo più in profondità.", spanish=" Vamos a seguirles la pista."})
  else
  SkySceneKit.say({english="We're going in deeper\nafter them.", french=" On les suit.", german="Wir gehen tiefer hinein und\nnehmen es mit ihnen auf.", italian=" Lo seguiremo più in profondità.", spanish=" Vamos a seguirles la pista."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Skuntank[CR], make sure you get\nyour team out. Don't give up.", french="[CS:N]Moufflair[CR], sors ton équipe de là.\nCourage!", german="[CS:N]Skuntank[CR], sieh zu, dass du dein\nTeam hier herausbringst. Und nicht aufgeben!", italian="[CS:N]Skuntank[CR], porta in salvo la tua\nsquadra. Non mollate.", spanish="[CS:N]Skuntank[CR], procura sacar\na tu equipo de aquí. ¡Aguantad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Skuntank[CR], be sure to get\nyour team out. Don't give up.", french="[CS:N]Moufflair[CR], sors ton équipe de là.\nCourage!", german="[CS:N]Skuntank[CR], sieh zu, dass du dein\nTeam hier herausbringst. Und nicht aufgeben!", italian="[CS:N]Skuntank[CR], porta in salvo la tua\nsquadra. Non mollate.", spanish="[CS:N]Skuntank[CR], procura sacar\na tu equipo de aquí. ¡Aguantad!"})
  else
  SkySceneKit.say({english="[CS:N]Skuntank[CR], be sure to get\nyour team out. Don't give up.", french="[CS:N]Moufflair[CR], sors ton équipe de là.\nCourage!", german="[CS:N]Skuntank[CR], sieh zu, dass du dein\nTeam hier herausbringst. Und nicht aufgeben!", italian="[CS:N]Skuntank[CR], porta in salvo la tua\nsquadra. Non mollate.", spanish="[CS:N]Skuntank[CR], procura sacar\na tu equipo de aquí. ¡Aguantad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Humph![K] I'll ask you to not\npatronize Team [CS:X]Skull[CR]. Chaw-haw-haw...", french="Pfff![K] Ne jouez pas les grands\nseigneurs avec l'Equipe [CS:X]Crâne[CR], s'il vous\nplaît. Gnark gnark gnark...", german="Grmpf![K] Ich verbitte mir die\nBevormundung von Team [CS:X]Totenkopf[CR].\nCha-ha-ha...", italian="Uff![K] Non trattate il Team\n[CS:X]Teschio[CR] come se fosse una squadra di\npivelli... Ahr-ahr-ahr...", spanish="¡Vaya![K] Voy a tener que pediros\nque no seáis condescendientes con\nel [CS:X]Equipo Calavera[CR]. Jua, jua, jua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go, [hero].", french=" Allons-y, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vamos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We have to go, [hero].", french=" Allons-y, [hero].", german="Wir müssen gehen,\n[hero].", italian=" Dobbiamo andare, [hero].", spanish=" Vamos, [hero]."})
  else
  SkySceneKit.say({english=" Let's go, [hero].", french=" Allons-y, [hero].", german=" Gehen wir, [hero].", italian=" Andiamo, [hero].", spanish=" Vamos, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 304, 140, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 304, 284, false, 2)
  GROUND:MoveToPosition(partner, 304, 140, false, 2)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" ...You two, can you move?", french="... Vous pouvez bouger, vous\nautres?", german="Ihr beide, könnt ihr euch\nbewegen?", italian=" Voi due, riuscite a muovervi?", spanish="A ver, ¿vosotros dos podéis\nmoveros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho... You can't be serious!", french="Mouarf mouarf... Vous\nplaisantez, chef!", german="Whoaho... Das ist nicht dein\nErnst!", italian="Uooh-oh... Non parlerai\nseriamente?!", spanish=" Jo, jo... ¡Estarás de broma!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh-heh... The way they\ntrounced us, I'm just too wiped out...", french="Hin hin hin... Après la raclée\nqu'on s'est prise, je suis H.S...", german="Hehehe... Die Art, wie sie uns\nzerlegt haben. Ich bin immer noch zu erledigt...", italian="Eh-eh-eh... Dopo che ci hanno\ntravolto a quel modo, sono troppo malandato...", spanish="Jue, jue, jue... Nos han dado\ntanta leña que no puedo ni moverme..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" So that's it...", french=" Et voilà le travail...", german=" Das war es also...", italian=" È finita, allora...", spanish=" Ya lo creo..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Well, we must really look like a\nmess...[K] Chaw-haw-haw...", french="On doit pas être beaux à voir\nà l'heure actuelle...[K] Gnark gnark gnark...", german="Wir geben bestimmt einen\nschlimmen Anblick ab...[K] Cha-ha-ha...", italian="Beh, siamo proprio messi\nmale...[K] Ahr-ahr-ahr...", spanish="Debemos de tener un aspecto\nlamentable...[K] Jua, jua, jua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho...but, Chief...", french="Mouarf mouarf mouarf...\nAu fait, chef...", german=" Whoahoho... Aber Boss...", italian=" Uooh-oh-oh... Però, capo...", spanish=" Jo, jo, jo... pero... Jefe..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="I like how you kept it to\nyourself until the very end...", french="J'ai bien aimé la façon dont\nvous l'avez dissimulé jusqu'à la fin...", german="Mir gefällt es, wie du das bis\nzum Schluss für dich behalten hast...", italian="Mi è piaciuto il modo in cui\nti sei comportato perché in fondo in fondo...", spanish=" Te lo tenías calladito, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="That you're a little bit of a good\nguy. You redeemed yourself!", french="... que vous avez un bon fond,\nen fait. C'est la rédemption, chef!", german="Dass du auch eine gute Seite\nhast. Du hast dich rehabilitiert!", italian="Beh, c'è del buono anche in te.\nTi sei riscattato!", spanish="En el fondo también eres bueno.\n¡Puedes estar muy orgulloso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Shut it...[K] Chaw-haw-haw...", french="La ferme...[K] Gnark gnark\ngnark...", german=" Klappe halten...[K] Cha-ha-ha...", italian=" Chiudi il becco...[K] Ahr-ahr-ahr...", spanish=" Cállate...[K] Jua, jua, jua..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="But I gotta say, Chief, there's\nsomething to be said about you doing that![K]\nHeh-heh-heh...", french="Mais faut avouer, chef, vous\nvoir faire ça, c'est pas rien![K]\nHin hin hin...", german="Aber ehrlich gesagt, Boss, sollte\nman dazu noch etwas sagen![K] Hehehe...", italian="Ciò che hai fatto, capo, è...\nCome dire...[K] Eh-eh-eh...", spanish="Pero Jefe, ¿por qué no hablar\nde eso? Si ha estado bien...[K]\nJue, jue, jue..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Shut up...[K] Chaw-haw-haw...", french="Mais vous allez la fermer,\nà la fin...[K] Gnark gnark gnark...", german=" Klappe zu...[K] Cha-ha-ha...", italian=" Chiudi il becco...[K] Ahr-ahr-ahr...", spanish=" Que te calles...[K] Jua, jua, jua..."})
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
