-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m00p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P03A, 'US01') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So what is this special service?", french=" En quoi ça consiste?", german="Was ist das denn für ein\nSonderservice?", italian="In cosa consiste questo servizio\nspeciale?", spanish="¿Y de qué se trata ese servicio\ntan especial?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So what is this special service?", french=" En quoi ça consiste?", german="Was ist das denn für ein\nSonderservice?", italian="In cosa consiste questo servizio\nspeciale?", spanish="¿Y en qué consiste este servicio\nespecial?"})
  else
  SkySceneKit.say({english="And what might this special\nservice be?", french=" En quoi ça consiste?", german="Und was hat es mit diesem\nSonderservice auf sich?", italian="In cosa consiste questo servizio\nspeciale?", spanish="¿En qué consiste este servicio\nespecial?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Down, "NPC_CHIRIIN")
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Well...it's special!", french="Eh bien... c'est un service...\neuh... spécial!", german=" Nun, etwas ganz Besonderes!", italian="Beh... è speciale!", spanish="Bueno...\n¡Pues es algo la mar de especial!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You can now change your leader\nbefore your team goes to a dungeon!", french="Dorénavant, vous pouvez\nchanger le meneur de l'équipe avant d'aller\ndans un donjon!", german="Ihr könnt jetzt einen anderen\nAnführer wählen, bevor euer Team in einen\nDungeon geht!", italian="Adesso potete cambiare il leader\ndella squadra prima di entrare in un dungeon!", spanish="¡Puedes cambiar de líder antes\nde enviar tu equipo a un territorio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The team leader?[K] We can change\nthe leader before going into a dungeon?", french="Le meneur de l'équipe?[K] On peut\nchanger notre meneur avant d'aller dans\nun donjon?", german="Einen anderen Anführer?[K] Wir\nkönnen den Anführer ändern, bevor wir in\neinen Dungeon gehen?", italian="Il leader della squadra?[K]\nPossiamo cambiare il leader prima di entrare\nin un dungeon?", spanish="¿Cambiar de líder?[K]\n¿Se puede escoger otro líder de grupo\nantes de ir a un territorio?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The team leader?[K] We can change\nthe leader before going into a dungeon?", french="Le meneur de l'équipe?[K] On peut\nchanger notre meneur avant d'aller dans\nun donjon?", german="Einen anderen Anführer?[K] Wir\nkönnen den Anführer ändern, bevor wir in\neinen Dungeon gehen?", italian="Il leader della squadra?[K]\nPossiamo cambiare il leader prima di entrare\nin un dungeon?", spanish="¿Cambiar de líder?[K]\n¿Se puede escoger otro líder de grupo\nantes de ir a un territorio?"})
  else
  SkySceneKit.say({english="The team leader?[K] We can change\nthe leader before going into a dungeon?", french="Le meneur de l'équipe?[K] On peut\nchanger notre meneur avant d'aller dans\nun donjon?", german="Einen anderen Anführer?[K] Wir\nkönnen den Anführer ändern, bevor wir in\neinen Dungeon gehen?", italian="Il leader della squadra?[K]\nPossiamo cambiare il leader prima di entrare\nin un dungeon?", spanish="¿Cambiar de líder?[K]\n¿Se puede escoger otro líder de grupo\nantes de ir a un territorio?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Yes!", french=" Exactement!", german=" Ja!", italian=" Sì!", spanish=" ¡Sí!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Up to now, [hero] was\nalways the team leader on explorations, right?", french="Jusqu'à maintenant, lors des\nexplorations, le meneur de l'équipe était\ntoujours [hero], n'est-ce pas?", german="Bis jetzt war [hero]\nimmer der Anführer bei euren Erkundungen,\nrichtig?", italian="Finora [hero] ha sempre\nguidato la squadra durante le esplorazioni,\ngiusto?", spanish="Hasta ahora, [hero]\nsiempre hacía el papel de líder del grupo\nen vuestras exploraciones, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Now, because the guild has\ngiven your team affiliate status...", french="A présent, comme la Guilde\na conféré à votre équipe le statut\nd'équipe affiliée...", german="Jetzt, wo euer Team mit der\nGilde kooperiert, habt ihr einen anderen\nStatus.", italian="Adesso, visto che la Gilda vi ha\nconferito la qualifica di affiliati...", spanish="Ahora, como el [CS:N]Pokégremio[CR] os ha\notorgado la categoría de equipo federado..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You can make any member of\nTeam [team:] the leader before going into\na dungeon![K] In other words...", french="... n'importe quel membre peut\ndevenir meneur de l'Equipe [team:] avant\nde partir dans un donjon![K] En d'autres termes...", german="Jedes Mitglied von Team\n[team:] kann Anführer werden, bevor ihr\neinen Dungeon betretet![K] Anders gesagt...", italian="... potete nominare leader\nqualsiasi membro del Team [team:] prima\ndi entrare in un dungeon![K] In altre parole...", spanish="¡Podéis convertir a cualquier\nmiembro del [CS:X]Equipo[CR] [team:] en líder\ndel grupo![K] En otras palabras..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You can assemble a dungeon\nteam from only Team [team:] recruits!", french="... vous pouvez composer\nune équipe pour un donjon avec uniquement\nde nouvelles recrues de l'Equipe [team:]!", german="Ihr könnt ein Team in einen\nDungeon schicken, das nur aus rekrutierten\nMitgliedern von Team [team:] besteht!", italian="... potete assemblare una\nsquadra composta solo da reclute del Team\n[team:]!", spanish="¡Ahora se puede reunir\nuna partida de exploración formada solo\npor reclutas del [CS:X]Equipo[CR] [team:]!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="An exploration team made that\nway will still be officially recognized!", french="Une équipe d'exploration\nconstituée de la sorte sera tout de même\nreconnue de manière officielle!", german="Ein so zusammengestelltes Team\nist genauso offiziell anerkannt!", italian="Una squadra così composta\nsarà sempre ufficialmente riconosciuta!", spanish="¡Un equipo explorador formado\nasí seguirá teniendo reconocimiento oficial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, cool![K] So that means...", french="Ah, je comprends![K] Ça veut\ndire que...", german=" Oh, cool![K] Das heißt also...", italian=" Oh, che bello![K] Significa...", spanish=" ¡Ah, genial![K] Eso significa que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, I get it![K] So that means...", french="Ah, je comprends![K] Ça veut\ndire que...", german=" Oh, verstehe![K] Das heißt also...", italian=" Oh, che bello![K] Significa...", spanish="¡Ah, ya lo entiendo![K] Eso\nsignifica que..."})
  else
  SkySceneKit.say({english=" Oh, I get it![K] So that means...", french="Ah, je comprends![K] Ça veut\ndire que...", german=" Oh, verstehe![K] Das heißt also...", italian=" Oh, capisco![K] Significa...", spanish="¡Ah, ya lo entiendo![K] Eso\nsignifica que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we plan to explore a dungeon\nwhere our current team will suffer type-based\ndisadvantages...", french="... si nous voulons explorer\nun donjon dans lequel notre équipe actuelle\naurait un désavantage lié au type...", german="Wenn wir einen Dungeon\nerkunden wollen, in dem unser jetziges Team\ntypspezifische Nachteile hätte...", italian="... che se intendiamo esplorare\nun dungeon dove la nostra squadra attuale\nha degli svantaggi legati al tipo...", spanish="Si planeamos explorar un\nterritorio donde nuestro equipo actual esté\nen desventaja por el tipo de sus miembros..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we plan to explore a dungeon\nwhere our current team will suffer type-based\ndisadvantages...", french="... si nous voulons explorer\nun donjon dans lequel notre équipe actuelle\naurait un désavantage lié au type...", german="Wenn wir einen Dungeon\nerkunden wollen, in dem unser jetziges Team\ntypspezifische Nachteile hätte...", italian="... che se intendiamo esplorare\nun dungeon dove la nostra squadra attuale\nha degli svantaggi legati al tipo...", spanish="Si planeamos explorar un\nterritorio donde nuestro equipo actual esté\nen desventaja por el tipo de sus miembros..."})
  else
  SkySceneKit.say({english="If we plan to explore a dungeon\nwhere our current team will suffer type-based\ndisadvantages...", french="... si nous voulons explorer\nun donjon dans lequel notre équipe actuelle\naurait un désavantage lié au type...", german="Wenn wir einen Dungeon\nerkunden wollen, in dem unser jetziges Team\ntypspezifische Nachteile hätte...", italian="... che se intendiamo esplorare\nun dungeon dove la nostra squadra attuale\nha degli svantaggi legati al tipo...", spanish="Si planeamos explorar un\nterritorio donde nuestro equipo actual esté\nen desventaja por el tipo de sus miembros..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We can build a totally different\nteam, even changing the team leader, so that\nwe can gain type advantages instead!", french="... nous pouvons former une\néquipe totalement différente ou changer de\nmeneur pour avoir un avantage lié au type!", german="Dann können wir ein völlig\nanderes Team mit einem anderen Anführer\nbilden und sogar Vorteile von Typen nutzen!", italian="... possiamo formare una\nsquadra completamente diversa, in modo\nda avere dei vantaggi!", spanish="¡Podemos hacer un grupo\ncompletamente distinto, y hasta cambiar\nel líder para ganar ventaja!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We can build a totally different\nteam, even changing the team leader, so that\nwe can gain type advantages instead!", french="... nous pouvons former une\néquipe totalement différente ou changer de\nmeneur pour avoir un avantage lié au type!", german="Dann können wir ein völlig\nanderes Team mit einem anderen Anführer\nbilden und sogar Vorteile von Typen nutzen!", italian="... possiamo formare una\nsquadra completamente diversa, in modo\nda avere dei vantaggi!", spanish="¡Podemos hacer un grupo\ncompletamente distinto, y hasta cambiar\nel líder para ganar ventaja!"})
  else
  SkySceneKit.say({english="We can build a totally different\nteam, even changing the team leader, so that\nwe can gain type advantages instead!", french="... nous pouvons former une\néquipe totalement différente ou changer de\nmeneur pour avoir un avantage lié au type!", german="Dann können wir ein völlig\nanderes Team mit einem anderen Anführer\nbilden und sogar Vorteile von Typen nutzen!", italian="... possiamo formare una\nsquadra completamente diversa, in modo\nda avere dei vantaggi!", spanish="¡Podemos hacer un grupo\ncompletamente distinto, y hasta cambiar\nel líder para ganar ventaja!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Absolutely!", french=" Absolument!", german=" Ganz genau!", italian=" Esatto!", spanish=" ¡Así es!"})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Of course, there are dungeons\nthat only [hero] and [partner]\nmay enter.", french="Bien évidemment, dans certains\ndonjons, seulement [hero] et\n[partner] auront le droit d'entrer.", german="Natürlich gibt es Dungeons, die\nnur [hero] und [partner] betreten\nkönnen.", italian="Naturalmente ci sono dei dungeon\naccessibili solo a [hero] e [partner].", spanish="Por supuesto, hay territorios en\nlos que solo pueden entrar [hero]\ny [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I hope you make use of my new\nservice...[K] Anyway, good luck with your\nexploration-team work!", french="J'espère que ce nouveau service\nvous sera utile...[K] En tout cas, bonne chance\npour vos futures explorations en équipe!", german="Ich hoffe, ihr nutzt den neuen\nService...[K] Auf jeden Fall viel Glück für eure\nArbeit als Erkundungsteam!", italian="Spero che farete uso del mio\nnuovo servizio...[K] In bocca al lupo per le\nvostre esplorazioni!", spanish="Espero que hagáis buen uso de\nmi nuevo servicio.[K] ¡Que tengáis buena suerte\ncon vuestras exploraciones!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
