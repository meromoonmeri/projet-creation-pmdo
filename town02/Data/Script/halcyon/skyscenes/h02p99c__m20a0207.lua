-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99C/m20a0207.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FIRE_CRACKLING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe I couldn't envision anything that time\nwe were in the future...)", french="(Peut-être que si rien ne m'est apparu quand\non était dans le futur...)", german="(Vielleicht konnte ich nichts vor meinem\ngeistigen Auge sehen, als wir in der Zukunft\nwaren, weil...)", italian="(Quando eravamo nel futuro, non riuscivo\na vedere nulla...)", spanish="(Tal vez por eso no pude sentir nada en aquella\nocasión...)"})
  else
  SkySceneKit.say({english="(Maybe I couldn't envision anything that time\nwe were in the future...)", french="(Peut-être que si rien ne m'est apparu quand\non était dans le futur...)", german="(Vielleicht konnte ich nichts vor meinem\ngeistigen Auge sehen, als wir in der Zukunft\nwaren, weil...)", italian="(Quando eravamo nel futuro, non riuscivo\na vedere nulla...)", spanish="(Tal vez por eso no pude sentir nada en aquella\nocasión...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Because we were in a place that wasn't tied\nto any Time Gears!)", french="(... c'est parce qu'on se trouvait dans\nun endroit qui n'était pas lié à un Rouage\ndu Temps!)", german="(Weil wir nicht an einem Ort waren, der eine\nVerbindung zu den Zahnrädern der Zeit hatte!)", italian="(Forse perché eravamo in un luogo che non era\nlegato a nessun Ingranaggio del Tempo!)", spanish="(¡Estábamos en un lugar que no tenía nada\nque ver con los Engranajes del Tiempo!)"})
  else
  SkySceneKit.say({english="(Because we were in a place that wasn't tied\nto any Time Gears!)", french="(... c'est parce qu'on se trouvait dans\nun endroit qui n'était pas lié à un Rouage\ndu Temps!)", german="(Weil wir nicht an einem Ort waren, der eine\nVerbindung zu den Zahnrädern der Zeit hatte!)", italian="(Forse perché eravamo in un luogo che non era\nlegato a nessun Ingranaggio del Tempo!)", spanish="(¡Estábamos en un lugar que no tenía nada\nque ver con los Engranajes del Tiempo!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe that's why my Dimensional Scream\nfailed to work.)", french="(Si ça se trouve, c'est pour ça que le Cri\nDimensionnel n'a pas marché.)", german="(Vielleicht funktionierte deshalb mein\nDimensionaler Schrei nicht.)", italian="(Deve essere il motivo per cui lo Squarcio\nDimensionale non ha funzionato.)", spanish="(Y por ese motivo no funcionó.)"})
  else
  SkySceneKit.say({english="(Maybe that's why my Dimensional Scream\nfailed to work.)", french="(Si ça se trouve, c'est pour ça que le Cri\nDimensionnel n'a pas marché.)", german="(Vielleicht funktionierte deshalb mein\nDimensionaler Schrei nicht.)", italian="(Deve essere il motivo per cui lo Squarcio\nDimensionale non ha funzionato.)", spanish="(Y por ese motivo no funcionó.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe [CS:N]Grovyle[CR] is right about the future and\nthe past being different...)", french="([CS:N]Massko[CR] a peut-être raison de dire\nque le passé et le futur sont différents...)", german="(Und vielleicht sagt [CS:N]Reptain[CR] die Wahrheit,\nwenn er behauptet, Zukunft und Vergangenheit\nseien verschieden.)", italian="(Forse ha ragione [CS:N]Grovyle[CR] quando dice che\nnel passato e nel futuro le cose funzionano\nin modo diverso...)", spanish="(Quizá [CS:N]Grovyle[CR] tiene razón al decir\nque el futuro y el pasado son diferentes...)"})
  else
  SkySceneKit.say({english="(Maybe [CS:N]Grovyle[CR] is right about the future and\nthe past being different...)", french="([CS:N]Massko[CR] a peut-être raison de dire\nque le passé et le futur sont différents...)", german="(Und vielleicht sagt [CS:N]Reptain[CR] die Wahrheit,\nwenn er behauptet, Zukunft und Vergangenheit\nseien verschieden.)", italian="(Forse ha ragione [CS:N]Grovyle[CR] quando dice che\nnel passato e nel futuro le cose funzionano\nin modo diverso...)", spanish="(Quizá [CS:N]Grovyle[CR] tiene razón al decir\nque el futuro y el pasado son diferentes...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Or different enough to make my Dimensional\nScream ability work differently.)", french="(Ou du moins, assez différents pour influer\nsur le fonctionnement du Cri Dimensionnel.)", german="(Oder verschieden genug, um meinen\nDimensionalen Schrei unterschiedlich\nfunktionieren zu lassen.)", italian="(O abbastanza diverso da cambiare il\nfunzionamento dello Squarcio Dimensionale.)", spanish="(Al menos, lo suficiente, como para que la\nPercepción de Cronos funcione de forma\ndistinta.)"})
  else
  SkySceneKit.say({english="(Or different enough to make my Dimensional\nScream ability work differently.)", french="(Ou du moins, assez différents pour influer\nsur le fonctionnement du Cri Dimensionnel.)", german="(Oder verschieden genug, um meinen\nDimensionalen Schrei unterschiedlich\nfunktionieren zu lassen.)", italian="(O abbastanza diverso da cambiare il\nfunzionamento dello Squarcio Dimensionale.)", spanish="(Al menos, lo suficiente, como para que la\nPercepción de Cronos funcione de forma\ndistinta.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 544, 232, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Anyway...", french=" Enfin bref...", german=" Wie dem auch sei...", italian=" Ad ogni modo...", spanish=" Bueno..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Like I was saying, we were\ninvestigating the planet's paralysis.", french="Comme je le disais, on enquêtait\nsur la Paralysie de la Planète.", german="Wie ich schon sagte, wir haben\ndie Lähmung des Planeten untersucht.", italian="Come stavo dicendo,\nindagavamo sulla paralisi del pianeta.", spanish="Como iba diciendo, estábamos\ninvestigando la parálisis del planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We used the Dimensional Scream\nability to...", french="On s'est servis du Cri\nDimensionnel...", german="Dazu setzten wir den\nDimensionalen Schrei ein.", italian="Usavamo lo Squarcio\nDimensionale...", spanish="Y utilizamos la Percepción de\nCronos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="identify the locations of the\nTime Gears in your world while we were in\nthe future.", french="... pour localiser les Rouages\ndu Temps dans votre monde, alors qu'on était\nencore dans le futur.", german="So bestimmten wir die Standorte\nder Zahnräder der Zeit in eurer Welt, als wir\nnoch in der Zukunft waren.", italian="Grazie ad esso identificavamo\ndal futuro i luoghi in cui gli Ingranaggi del\nTempo erano posizionati nel presente.", spanish="Así, pudimos saber la ubicación\nde todos los Engranajes del Tiempo de vuestro\nmundo cuando aún estábamos en el futuro."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]That's it!", french="[CN]Ça y est!", german="[CN]Das ist es!", italian="[CN]È tutto!", spanish="[CN]¡Eso es!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]Here!", french="[CN]Il est là!", german="[CN]Hier!", italian="[CN]Ecco qui!", spanish="[CN]¡Aquí!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]A Time Gear is here!", french="[CN]Le Rouage du Temps est là!", german="[CN]Hier ist ein Zahnrad der Zeit!", italian="[CN]Qui c'è un Ingranaggio del Tempo!", spanish="[CN]¡Aquí hay un Engranaje del Tiempo!"})
  -- message_Close
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]I see!", french="[CN]Je vois!", german="[CN]Ich verstehe!", italian="[CN]Ho capito!", spanish="[CN]¡Ya lo veo!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]Place the Drought Stone\n[CN]in Groudon's heart.", french="[CN]Place la Pierre-Sèche\n[CN]dans le cœur de Groudon.", german="[CN]Setze den Melioriestein\n[CN]in das Herz von Groudon.", italian="[CN]Metti la Pietra del Sole\n[CN]nel cuore di Groudon.", spanish="[CN]Coloca la Piedra Sequía\n[CN]en el corazón de Groudon."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]That lifts the fog!", french="[CN]Le brouillard se lève!", german="[CN]Das löst den Nebel auf!", italian="[CN]Così la nebbia si alzerà!", spanish="[CN]¡Eso disipará la niebla!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="[CN]Very well done!\n[CN]Good job, partner!", french="[CN]Très bien joué!\n[CN]Beau travail, partenaire!", german="[CN]Sehr gut gemacht!\n[CN]Gute Arbeit, Partner!", italian="[CN]Ben fatto!\n[CN]Buon lavoro, partner!", spanish="[CN]¡Muy bien hecho!\n[CN]¡Buen trabajo, camarada!"})
  -- message_Close
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FIRE_CRACKLING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="After identifying the locations\nwhere the Time Gears would be in the past...", french="Après avoir localisé les Rouages\ndu Temps dans le passé...", german="Erst ermittelten wir,\nwo sich die Zahnräder der Zeit in der\nVergangenheit befinden würden.", italian="Dopo aver identificato i luoghi\nin cui, nel passato, erano posizionati gli\nIngranaggi del Tempo...", spanish="Tras averiguar dónde estarían\nlos Engranajes del Tiempo en el pasado..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We took the Passage of Time.", french="... on a emprunté le Couloir\ndu Temps.", german=" Dann nahmen wir den Zeittunnel.", italian="... abbiamo attraversato il\nPortale del Tempo.", spanish=" Cruzamos el Pasaje del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That brought us from our world\nin your future to this world.", french="Il nous a téléportés\nde notre monde dans le futur vers\nce monde-ci.", german="Der brachte uns aus unserer\nWelt, also deiner Zukunft, in diese Welt.", italian="Così siamo passati dal nostro\nmondo nel futuro a questo mondo.", spanish=" Para llegar a vuestro mundo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" However...", french=" Cependant...", german=" Allerdings...", italian=" Comunque sia...", spanish=" Sin embargo..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(2) -- join WaitBgm
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  -- GAP: BGM BGM_STORM non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Whoa! Wh-wh-whoa...!", french=" Wouaaah! Aaah...!", german=" Boah! B-b-boah!", italian=" Wow! Wo-wo-wow...!", spanish=" ¡Cuidado! ¡Mucho cuidado!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Are...[K] Are you OK?!", french=" Ça...[K] ça va?!", german=" Bist...[K] Bist du in Ordnung?!?", italian=" Stai...[K] Stai bene?!", spanish=" ¿Estás...?[K] ¿Estás bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" No![K] Don't let go!", french=" Non![K] Tiens bon!", german=" Nein![K] Nicht aufgeben!", italian=" No![K] Non mollare!", spanish=" ¡No![K] ¡No te sueltes!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Just a little longer...[K] Come on! Hang on!", french="Allez, encore un effort...[K] Allez!\nTiens le coup!", german="Nur noch ein bisschen...[K] Komm schon!\nHalte durch!", italian=" Ancora per poco...[K] Forza! Devi farcela!", spanish=" Solo un poco más...[K] ¡Vamos! ¡Aguanta!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" N-n-no![K] I can't...[K]hold on...!", french=" N-non![K] Je ne peux pas...[K] continuer...!", german=" N-n-nein![K] Ich kann...[K] nicht mehr!", italian=" N-N-No![K] Non ce la...[K] faccio...!", spanish="¡No![K] No puedo...[K]\n¡No puedo sujetarme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(6402) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(6402) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(20)
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Waaaaaah!", french=" Wouaaah!", german=" Uaaaaaah!", italian=" Waaaaaah!", spanish=" ¡Aaaaaah!"})
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(true, 90) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(120)
  GAME:WaitFrames(2) -- join WaitBgm
  -- back_SetGround(LEVEL_H02P99C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_FIRE_CRACKLING non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We encountered turbulence while\nwe were traveling through time...", french="Il y a eu des turbulences au\ncours de notre voyage dans le temps...", german="Es gab Turbulenzen während\nunserer Reise durch die Zeit...", italian="Mentre viaggiavamo\nattraverso il tempo abbiamo incontrato\ndelle turbolenze...", spanish="El viaje en el tiempo fue muy\nturbulento."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Thus [hero] and I became\nseparated.", french="Et c'est comme ça qu'on a été\nséparés, [hero] et moi.", german="Deswegen wurden [hero]\nund ich getrennt.", italian="Così [hero] ed io siamo\nstati separati.", spanish="Y [hero] y yo terminamos\nseparándonos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="For some reason, [hero]\ngot amnesia and was turned into a Pokémon.", french="Pour une raison que j'ignore,\n[hero] a perdu la mémoire et a pris la\nforme d'un Pokémon.", german="Aus irgendeinem Grund\nverlor [hero] das Gedächtnis und\nverwandelte sich in ein Pokémon.", italian="Per qualche ragione,\n[hero] ha perso la memoria e\nal risveglio era un Pokémon.", spanish="Por algún motivo, [hero]\nperdió la memoria y se convirtió en un\nPokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I can only guess that it had\nsomething to do with our accident while\ntraveling in time.", french="J'imagine que c'est lié à ce\nqui s'est passé pendant notre voyage dans\nle temps.", german="Ich kann nur vermuten, dass das\netwas mit unserem Unfall während der\nZeitreise zu tun hatte.", italian="Posso solo immaginare che tutto\nquesto abbia a che fare con il nostro incidente\ndurante il viaggio nel tempo.", spanish="Supongo que habrá tenido algo que\nver con el accidente que sufrimos al viajar\nen el tiempo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I...[K]I came from the future...)", french="(Alors je...[K] je viens du futur...)", german="(Ich...[K] Ich bin aus der Zukunft gekommen...)", italian="(Io...[K] Io vengo dal futuro...)", spanish="(Entonces...[K] soy del futuro.)"})
  else
  SkySceneKit.say({english="(I...[K]I came from the future...)", french="(Alors je...[K] je viens du futur...)", german="(Ich...[K] Ich bin aus der Zukunft gekommen...)", italian="(Io...[K] Io vengo dal futuro...)", spanish="(Entonces...[K] soy del futuro.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(And not just that! I came with the mission of\npreventing the planet's paralysis.)", french="(Et ce n'est pas tout! Je suis venu ici avec\npour mission d'empêcher la Paralysie de la\nPlanète.)", german="(Und nicht nur das! Ich bin mit der Mission\nhergekommen, die Lähmung des Planeten zu\nverhindern.)", italian="(E non solo! Vengo con il compito di prevenire\nla paralisi del pianeta.)", spanish="(¡Y no solo eso! Vine con la misión de evitar\nla parálisis del planeta.)"})
  else
  SkySceneKit.say({english="(And not just that! I came with the mission of\npreventing the planet's paralysis.)", french="(Et ce n'est pas tout! Je suis venue ici avec\npour mission d'empêcher la Paralysie de la\nPlanète.)", german="(Und nicht nur das! Ich bin mit der Mission\nhergekommen, die Lähmung des Planeten zu\nverhindern.)", italian="(E non solo! Vengo con il compito di prevenire\nla paralisi del pianeta.)", spanish="(¡Y no solo eso! Vine con la misión de evitar\nla parálisis del planeta.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know... It seems so outlandish...[K]\nIt doesn't feel real, somehow...)", french="(Incroyable... Tout ça paraît si saugrenu...[K]\nOn dirait que ce n'est pas réel...)", german="(Ich weiß nicht... Es fühlt sich so fremd an...[K]\nEs erscheint mir irgendwie nicht real...)", italian="(Non so... È tutto così strano...[K]\nIn un certo senso, non mi sembra vero...)", spanish="(No sé... Parece tan descabellado...[K]\nCasi irreal.)"})
  else
  SkySceneKit.say({english="(I don't know... It seems so outlandish...[K]\nIt doesn't feel real, somehow...)", french="(Incroyable... Tout ça paraît si saugrenu...[K]\nOn dirait que ce n'est pas réel...)", german="(Ich weiß nicht... Es fühlt sich so fremd an...[K]\nEs erscheint mir irgendwie nicht real...)", italian="(Non so... È tutto così strano...[K]\nIn un certo senso, non mi sembra vero...)", spanish="(No sé... Parece tan descabellado...[K]\nCasi irreal.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="So, [hero]...[K] You may not\nremember any of this, but...", french="Eh oui, [hero]...[K]\nTu ne t'en souviens peut-être pas, mais...", german="Also, [hero]...[K] Du magst\ndich vielleicht an nichts erinnern, aber...", italian="Dunque, [hero]...[K] Forse\nnon ricorderai nulla di tutto ciò, ma...", spanish="[hero]...[K] puede que ya no\nlo recuerdes, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" You were my closest friend.", french="... nous étions les meilleurs\namis du monde.", german=" Du warst mein engster Freund.", italian=" Per me eri la persona più cara.", spanish=" Yo era tu mejor amigo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I worried about you when we\nwere separated.[K] I'm glad to see you're safe.", french="Je me suis beaucoup inquiété\npour toi après notre séparation.[K] Content\nde voir que tu vas bien.", german="Ich habe mir Sorgen gemacht,\nals wir getrennt wurden.[K] Ich bin froh, dass\nich dich wohlbehalten sehe.", italian="Quando ci siamo separati ero\nmolto preoccupato per te.[K] Sono contento di\nvedere che stai bene.", spanish="Me preocupé mucho por ti\ncuando nos separamos.[K]\nMe alegra ver que estás bien."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Your appearance may have\nchanged...[K] And though you have lost your\nmemory...[K] You're still you.", french="Tu as changé...[K] Et tu as perdu\nla mémoire...[K] Mais tu es toujours toi-même.", german="Deine Erscheinung mag sich\nverändert haben...[K] Und trotz deines verlorenen\nGedächtnisses...[K] bist du noch ganz du selbst.", italian="Il tuo aspetto può\nessere cambiato...[K] Hai anche perso la\nmemoria...[K] Ma sei sempre tu.", spanish="Puede que hayas cambiado de\naspecto...[K] y que hayas perdido la memoria...[K]\npero sigues siendo quien eres."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="And none of this alters the fact\nthat you remain my friend.", french="Et tout ça ne change rien\nà la profonde amitié que je te porte.", german="Und nichts ändert etwas an der\nTatsache, dass wir Freunde sind.", italian="Questo non cambia il fatto che\ntengo molto a te.", spanish="Seguimos siendo amigos.\nLo ocurrido no cambia nada."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Oh, [hero].[K] I'm glad to\nsee you again.", french="Oh, [hero].[K] Comme je suis\ncontent de te revoir.", german="Oh, [hero].[K] Ich bin so\nfroh, dich wiederzusehen.", italian="Oh, [hero].[K] Sono\ncontento di rivederti.", spanish="Oh, [hero].[K]\nMe alegro de volver a verte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Now.[K] We have to decide on our\ncourse of action.", french="Bon.[K] Il faut qu'on mette au point\nun plan d'action.", german="Okay.[K] Wir müssen über unser\nweiteres Vorgehen entscheiden.", italian="Bene.[K] Dobbiamo decidere come\nmuoverci.", spanish="Bueno.[K] Ahora tenemos que\ndecidir lo que vamos a hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Like I've told you before...[K]\nI'm going to collect the Time Gears again.", french="Comme je vous l'ai dit...[K] je vais\nme remettre à rassembler les Rouages\ndu Temps.", german="Wie ich bereits sagte...[K]\nIch werde wieder Zahnräder der Zeit sammeln.", italian="Come vi ho già detto,[K]\nvoglio raccogliere gli Ingranaggi del Tempo.", spanish="Tal y como os he dicho...[K] Voy\na buscar de nuevo los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What are you going to do?", french="Et vous, qu'est-ce que vous allez\nfaire?", german=" Was habt ihr denn vor?", italian=" Come facciamo?", spanish="¿Habéis decidido ya lo que vais\na hacer?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Umm...", french=" Euh...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Umm...", french=" Euh...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Umm...", french=" Euh...", german=" Ähm...", italian=" Uhm...", spanish=" Hum..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_juputoru, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm a bit worried about how\ntime stops in the region where its Time Gear\nis removed.", french="Ça m'inquiète un peu que\nle temps s'arrête dans les régions privées\nde leur Rouage du Temps.", german="Ich bin etwas besorgt darüber,\ndass die Zeit in Regionen stillsteht, denen das\nZahnrad der Zeit genommen wurde.", italian="Mi preoccupa un po' il fatto che\nnelle regioni in cui viene rimosso l'Ingranaggio\ndel Tempo, il tempo si ferma.", spanish="A mí me preocupa que el tiempo\nse pare en las regiones donde se quitan los\nEngranajes del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm a little worried about how\ntime stops in the region where its Time Gear\nis removed.", french="Ça m'inquiète un peu que\nle temps s'arrête dans les régions privées\nde leur Rouage du Temps.", german="Ich bin etwas besorgt darüber,\ndass die Zeit in Regionen stillsteht, denen das\nZahnrad der Zeit genommen wurde.", italian="Mi preoccupa un po' il fatto che\nil tempo si fermi nelle regioni in cui viene\nrimosso l'Ingranaggio del Tempo.", spanish="A mí me preocupa que el tiempo\nse pare en las regiones donde se quitan los\nEngranajes del Tiempo."})
  else
  SkySceneKit.say({english="I'm a little worried about how\ntime stops in the region where its Time Gear\nis removed.", french="Ça m'inquiète un peu que\nle temps s'arrête dans les régions privées\nde leur Rouage du Temps.", german="Ich bin etwas besorgt darüber,\ndass die Zeit in Regionen stillsteht, denen das\nZahnrad der Zeit genommen wurde.", italian="Mi preoccupa un po' il fatto che\nil tempo si ferma nelle regioni in cui viene\nrimosso l'Ingranaggio del Tempo.", spanish="A mí me preocupa que el tiempo\nse pare en las regiones donde se quitan los\nEngranajes del Tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But that's really a temporary\nthing?", french="Mais, on est bien d'accord,\nce n'est que temporaire?", german="Ist das wirklich nur eine\nvorübergehende Sache?", italian="Davvero è solo una situazione\ntemporanea?", spanish="Aunque ese efecto es solo\ntemporal, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But you're sure that it will only\nbe temporary?", french="Mais, on est bien d'accord,\nce n'est que temporaire?", german="Aber du bist sicher, dass das\nnur zeitweilig ist?", italian="Sei sicuro che sarà solo una\ncosa temporanea?", spanish="Aunque ese efecto es solo\ntemporal, ¿verdad?"})
  else
  SkySceneKit.say({english="But you're sure that it will only\nbe temporary?", french="Mais, on est bien d'accord,\nce n'est que temporaire?", german="Aber du bist sicher, dass das\nnur zeitweilig ist?", italian="Sei sicuro che sarà solo una\ncosa temporanea?", spanish="Aunque ese efecto es solo\ntemporal, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="That's right. As soon as the Time\nGears are set in place at [CS:P]Temporal Tower[CR]...", french="C'est exact. Dès que les Rouages\ndu Temps auront repris leur place dans\nla [CS:P]Tour du Temps[CR]...", german="Ganz sicher. Man muss nur die\nZahnräder der Zeit wieder in den [CS:P]Zeitturm[CR]\neinsetzen.", italian="È così. Non appena gli Ingranaggi\ndel Tempo saranno posizionati al loro posto\nnella [CS:P]Torre del Tempo[CR]...", spanish="Así es. En cuanto coloque los\nEngranajes del Tiempo en la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="time will be restored to its\nnormal state everywhere.", french="... le temps reprendra son cours\nnormal dans le monde entier.", german="Dann kehrt die Zeit überall\nin ihren normalen Zustand zurück.", italian="... tutto quanto tornerà come\nprima.", spanish="Se volverá a la normalidad en\ntodas partes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well then!", french=" Alors ça me va!", german=" Na dann!", italian=" Bene allora!", spanish=" ¡Estupendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well then!", french=" Alors ça me va!", german=" Na dann!", italian=" Bene allora!", spanish=" ¡Estupendo!"})
  else
  SkySceneKit.say({english=" Well then!", french=" Alors ça me va!", german=" Na dann!", italian=" Bene allora!", spanish=" ¡Estupendo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll go too.[K] We'll go with you,\n[CS:N]Grovyle[CR].", french="Nous aussi on vient.[K]\nOn t'accompagne, [CS:N]Massko[CR].", german="Dann gehen wir auch.[K] Wir gehen\nmit dir, [CS:N]Reptain[CR].", italian="Veniamo anche noi.[K] Veniamo con\nte, [CS:N]Grovyle[CR].", spanish="Lo mejor será que...[K]\nIremos contigo, [CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We'll go too.[K] We'll go with you,\n[CS:N]Grovyle[CR].", french="Nous aussi on vient.[K]\nOn t'accompagne, [CS:N]Massko[CR].", german="Dann gehen wir auch.[K] Wir gehen\nmit dir, [CS:N]Reptain[CR].", italian="Veniamo anche noi.[K] Veniamo con\nte, [CS:N]Grovyle[CR].", spanish="Lo mejor será que...[K]\nIremos contigo, [CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english="We'll go too.[K] We'll go with you,\n[CS:N]Grovyle[CR].", french="Nous aussi on vient.[K]\nOn t'accompagne, [CS:N]Massko[CR].", german="Dann gehen wir auch.[K] Wir gehen\nmit dir, [CS:N]Reptain[CR].", italian="Veniamo anche noi.[K] Veniamo con\nte, [CS:N]Grovyle[CR].", spanish="Lo mejor será que...[K]\nIremos contigo, [CS:N]Grovyle[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Taking a Time Gear will cause\ntrouble for Pokémon that live in that area...", french="S'emparer des Rouages du Temps\nva causer beaucoup d'ennuis aux Pokémon\nqui vivent dans les régions concernées...", german="Wenn ein Zahnrad der Zeit\nweggenommen wird, wird das negative Folgen\nfür die Pokémon in jener Gegend haben.", italian="Rimuovere un Ingranaggio del\nTempo causerà qualche problema ai Pokémon\nche vivono in quella zona...", spanish="Causaremos algunos problemas a\nlos Pokémon que vivan en la zona cercana a\nlos engranajes..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Taking a Time Gear will badly\naffect the Pokémon that live in that area...", french="S'emparer des Rouages du Temps\nva causer beaucoup d'ennuis aux Pokémon\nqui vivent dans les régions concernées...", german="Wenn ein Zahnrad der Zeit\nweggenommen wird, wird das negative Folgen\nfür die Pokémon in jener Gegend haben.", italian="Rimuovere un Ingranaggio del\nTempo causerà qualche problema ai Pokémon\nche vivono in quella zona...", spanish="Causaremos algunos problemas a\nlos Pokémon que vivan en la zona cercana a\nlos engranajes..."})
  else
  SkySceneKit.say({english="Stealing a Time Gear will cause\ntrouble for Pokémon that live in that area...", french="S'emparer des Rouages du Temps\nva causer beaucoup d'ennuis aux Pokémon\nqui vivent dans les régions concernées...", german="Wenn ein Zahnrad der Zeit\nweggenommen wird, wird das negative Folgen\nfür die Pokémon in jener Gegend haben.", italian="Rimuovere un Ingranaggio del\nTempo causerà qualche problema ai Pokémon\nche vivono in quella zona...", spanish="Causaremos algunos problemas a\nlos Pokémon que vivan en la zona cercana a\nlos engranajes..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we have to stop the planet's\nparalysis!", french="Mais on doit empêcher\nla Paralysie de la Planète!", german="Aber wir müssen die Lähmung\ndes Planeten aufhalten!", italian="Ma dobbiamo arrestare la\nparalisi del pianeta!", spanish="¡Pero tenemos que detener la\nparálisis del planeta!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we have to prevent the\nplanet's paralysis!", french="Mais on doit empêcher\nla Paralysie de la Planète!", german="Aber wir müssen die Lähmung\ndes Planeten verhindern!", italian="Ma dobbiamo prevenire la\nparalisi del pianeta!", spanish="¡Pero tenemos que detener la\nparálisis del planeta!"})
  else
  SkySceneKit.say({english="But we have to prevent the\nplanet's paralysis!", french="Mais on doit empêcher\nla Paralysie de la Planète!", german="Aber wir müssen die Lähmung\ndes Planeten verhindern!", italian="Ma dobbiamo prevenire la\nparalisi del pianeta!", spanish="¡Pero tenemos que detener la\nparálisis del planeta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" OK, then. We'll go together.", french="C'est entendu. On ira tous\nles trois.", german=" Na gut. Wir gehen zusammen.", italian=" E va bene. Andremo insieme.", spanish=" Entonces decidido. Iremos juntos."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" But the hour is late.", french=" Mais il est tard.", german=" Aber es ist spät am Abend.", italian=" Ma si sta facendo tardi.", spanish=" Aunque ya es muy tarde."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're also exhausted from all\nthe running we've done.", french="Et cette course-poursuite\nnous a tous épuisés.", german="Außerdem sind wir von der\nganzen Lauferei ziemlich erschöpft.", italian="E siamo anche esausti per tutte\nle corse che abbiamo fatto.", spanish="Y estamos agotados por todos\nlos esfuerzos que hemos hecho."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We should rest up tonight. We'll\nleave in the morning.", french="Reposons-nous pour la nuit.\nOn partira demain matin.", german="Wir sollten uns heute Abend\nausruhen. Morgen früh ziehen wir los.", italian="È meglio che stanotte ci\nriposiamo. Partiremo domani mattina.", spanish="Esta noche debemos descansar.\nSaldremos por la mañana."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(60)
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 17 -- $COMPULSORY_SAVE_POINT = 17 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
