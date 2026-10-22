-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S01P01A/m20a0311.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(5) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetMark(184) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" From here...", french=" A partir d'ici...", german=" Hmm. Von hier aus...", italian=" Vediamo...", spanish=" Desde aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" From here...", french=" A partir d'ici...", german=" Hmm. Von hier aus...", italian=" Vediamo...", spanish=" Desde aquí..."})
  else
  SkySceneKit.say({english=" From here...", french=" A partir d'ici...", german=" Hmm. Von hier aus...", italian=" Vediamo...", spanish=" Desde aquí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_SetArrow(188) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess the [CS:P]Underground Lake[CR]\nwould be the closest.", french="Je pense que c'est le [CS:P]Lac\nSouterrain[CR] qui est le plus proche.", german="Nun, vermutlich liegt der\n[CS:P]Untergrundsee[CR] am nächsten.", italian="Credo che il [CS:P]Lago Sotterraneo[CR]\nsia il posto più vicino.", spanish="Supongo que lo más cercano\nsería el [CS:P]Lago Subterráneo[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The [CS:P]Underground Lake[CR] would\nbe the closest, I guess.", french="Je pense que c'est le [CS:P]Lac\nSouterrain[CR] qui est le plus proche.", german="Nun, vermutlich liegt der\n[CS:P]Untergrundsee[CR] am nächsten.", italian="Il [CS:P]Lago Sotterraneo[CR] dovrebbe\nessere il posto più vicino, credo.", spanish="Supongo que lo más cercano\nsería el [CS:P]Lago Subterráneo[CR]."})
  else
  SkySceneKit.say({english="The [CS:P]Underground Lake[CR] seems to\nbe the closest.", french="Je pense que c'est le [CS:P]Lac\nSouterrain[CR] qui est le plus proche.", german="Nun, vermutlich liegt der\n[CS:P]Untergrundsee[CR] am nächsten.", italian="Il [CS:P]Lago Sotterraneo[CR] sembra\nessere il posto più vicino.", spanish="Supongo que lo más cercano\nsería el [CS:P]Lago Subterráneo[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_DeleteArrow [flèche carte moteur NDS]
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="How about [CS:P]Treeshroud Forest[CR]?[K]\nThat was where I got my first Time Gear the\nlast time.", french="Et pourquoi pas la [CS:P]Forêt\nLinceul[CR]?[K] C'est là que j'ai déniché mon\npremier Rouage du Temps, la dernière fois.", german="Wie wäre es mit dem\n[CS:P]Schemengehölz[CR]?[K] Dort habe ich damals mein\nerstes Zahnrad der Zeit bekommen.", italian="E che ne pensi della [CS:P]Foresta[CR]\n[CS:P]Arcana[CR]?[K] È il posto in cui l'altra volta\nho preso il mio primo Ingranaggio del Tempo.", spanish="¿Qué tal el [CS:P]Bosque Enraizado[CR]?[K]\nAllí fue donde conseguí el primer\nEngranaje del Tiempo la otra vez."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Where is that?", french=" C'est où?", german=" Wo liegt das?", italian=" Dove si trova?", spanish=" ¿Dónde está eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Where is that?", french=" C'est où?", german=" Wo liegt das?", italian=" Dove si trova?", spanish=" ¿Dónde está eso?"})
  else
  SkySceneKit.say({english=" Where is that?", french=" C'est où?", german=" Wo liegt das?", italian=" Dove si trova?", spanish=" ¿Dónde está eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Here.", french=" Là.", german=" Hier.", italian=" Qua.", spanish=" Aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- worldmap_MoveCamera(35) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetMark(35) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(35) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It is a little far from here,\nbut...", french=" C'est un peu loin, mais...", german="Es ist etwas weit von hier,\naber...", italian=" È un po' lontana da qui, ma...", spanish=" Está un poco lejos, pero..."})
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="There is no one like [CS:N]Uxie[CR]\nguarding that Time Gear.", french="On ne risque pas de tomber sur\nquelqu'un comme [CS:N]Créhelf[CR], personne ne surveille\nce Rouage du Temps-là.", german="Dort passt niemand wie [CS:N]Selfe[CR]\nauf das Zahnrad der Zeit auf.", italian="Non c'è nessuno come [CS:N]Uxie[CR]\na fare la guardia a quell'Ingranaggio del Tempo.", spanish="Allí no hay nadie como [CS:N]Uxie[CR]\ncustodiando ese Engranaje del Tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Great!", french=" Génial!", german=" Super!", italian=" Grandioso!", spanish=" ¡Genial!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, great!", french=" Génial!", german=" Oh, super!", italian=" Oh, grandioso!", spanish=" ¡Genial!"})
  else
  SkySceneKit.say({english=" Oh, great!", french=" Génial!", german=" Oh, super!", italian=" Oh, grandioso!", spanish=" ¡Genial!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we have to fight someone\nover a Time Gear, that would attract\nattention.", french="S'il faut qu'on se batte pour\ns'emparer d'un Rouage du Temps, ça risque\nd'attirer l'attention.", german="Wenn wir wegen eines\nZahnrades der Zeit mit jemandem kämpfen\nwürden, könnte das Aufmerksamkeit erregen.", italian="Se dovessimo lottare con\nqualcuno per recuperare un Ingranaggio\ndel Tempo, attireremmo l'attenzione su di noi.", spanish="Si tuviéramos que enfrentarnos\na alguien para conseguir el Engranaje del\nTiempo, llamaríamos la atención."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we were to fight someone\nover a Time Gear, that would attract\nattention.", french="S'il faut qu'on se batte pour\ns'emparer d'un Rouage du Temps, ça risque\nd'attirer l'attention.", german="Wenn wir jemanden wegen eines\nZahnrades der Zeit bekämpfen würden, könnte\ndas Aufmerksamkeit erregen.", italian="Se dovessimo lottare con\nqualcuno per recuperare un Ingranaggio\ndel Tempo, attireremmo l'attenzione su di noi.", spanish="Si tuviéramos que enfrentarnos\na alguien para conseguir el Engranaje del\nTiempo, llamaríamos la atención."})
  else
  SkySceneKit.say({english="If we have to fight someone\nover a Time Gear, that would attract\nattention.", french="S'il faut qu'on se batte pour\ns'emparer d'un Rouage du Temps, ça risque\nd'attirer l'attention.", german="Wenn wir wegen eines\nZahnrades der Zeit mit jemandem kämpfen\nwürden, könnte das Aufmerksamkeit erregen.", italian="Se dovessimo lottare con\nqualcuno per recuperare un Ingranaggio\ndel Tempo, attireremmo l'attenzione su di noi.", spanish="Si tuviéramos que enfrentarnos\na alguien para conseguir el Engranaje del\nTiempo, llamaríamos la atención."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we wouldn't have to worry\nabout that here, right?", french="Mais là-bas, ce ne sera pas\nle cas, n'est-ce pas?", german="Aber hier müssten wir das nicht\nbefürchten, richtig?", italian="Ma là non c'è nulla di cui\npreoccuparsi, vero?", spanish="Y si vamos allí no tendríamos\nque preocuparnos por eso, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But that won't be a concern\nhere, right?", french="Mais là-bas, ce ne sera pas\nle cas, n'est-ce pas?", german="Aber hier wäre das kein\nProblem, oder?", italian="Ma là non c'è nulla di cui\npreoccuparsi, vero?", spanish="Y si vamos allí no tendríamos\nque preocuparnos por eso, ¿verdad?"})
  else
  SkySceneKit.say({english="But that won't be a problem\nhere, right?", french="Mais là-bas, ce ne sera pas\nle cas, n'est-ce pas?", german="Aber hier hätten wir damit keine\nProbleme, oder?", italian="Ma là non dovremmo avere\nproblemi, vero?", spanish="Y si vamos allí no tendríamos\nque preocuparnos por eso, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Exactly.", french=" Exact.", german=" Genau.", italian=" Esattamente.", spanish=" Exacto."})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
