-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m21a0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 224, Direction.DownLeft, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 272, Direction.UpRight, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 376, 240, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 280, 264, Direction.Right, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 312, 272, Direction.Left, "NPC_GUREGGURU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 368, 264, Direction.DownLeft, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 240, Direction.UpRight, "NPC_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 224, Direction.Down, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's him![K] It's that nice old\nPokémon we met!", french="C'est lui![K] C'est ce vieux\nPokémon très gentil qu'on a rencontré\nune fois!", german="Der ist das![K] Dieses nette alte\nPokémon, das wir getroffen haben!", italian="È lui![K] Quel simpatico vecchio\nPokémon che abbiamo conosciuto!", spanish="¡Es él![K] ¡Ese anciano Pokémon tan\namable al que conocimos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's him![K] It's that nice old\nPokémon we met!", french="C'est lui![K] C'est ce vieux\nPokémon très gentil qu'on a rencontré\nune fois!", german="Der ist das![K] Dieses nette alte\nPokémon, das wir getroffen haben!", italian="È lui![K] Quel simpatico vecchio\nPokémon che abbiamo conosciuto!", spanish="¡Es él![K] ¡Ese anciano Pokémon tan\namable al que conocimos en la Terma!"})
  else
  SkySceneKit.say({english="It's him![K] It's that nice old\nPokémon we met!", french="C'est lui![K] C'est ce vieux\nPokémon très gentil qu'on a rencontré\nune fois!", german="Der ist das![K] Dieses nette alte\nPokémon, das wir getroffen haben!", italian="È lui![K] Quel simpatico vecchio\nPokémon che abbiamo conosciuto!", spanish="¡Sí![K] ¡Ese anciano Pokémon tan\namable al que conocimos en la Terma!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 352, 216, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="You should put his years of\nwisdom to use! ♪", french="Mettez à profit ses longues\nannées de sagesse! ♪", german="Ihr solltet euch die Weisheit\nseiner Jahre zunutze machen! ♪", italian="Dovreste cercare di far buon\nuso dei suoi anni di esperienza! ♪", spanish="¡Sus años de experiencia pueden\nresultaros muy útiles! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Go ask [CS:N]Torkoal[CR] for advice! ♪", french="Allez demander conseil à\n[CS:N]Chartor[CR]! ♪", german=" Fragt [CS:N]Qurtel[CR] um Rat! ♪", italian="Andate a chiedere consiglio a\n[CS:N]Torkoal[CR]! ♪", spanish=" ¡Id a pedir consejo a [CS:N]Torkoal[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think we got to the Hot Spring\nthrough [CS:P]Waterfall Cave[CR]. Right, [hero]?", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR]. Pas vrai, [hero]?", german="Wir sind durch die\n[CS:P]Wasserfallhöhle[CR] zur Heißen Quelle gelangt.\nRichtig, [hero]?", italian="Mi pare che si arrivi alla\nSorgente Termale passando per la [CS:P]Grotta[CR]\n[CS:P]della Cascata[CR]. Vero, [hero]?", spanish="Llegamos a la Terma a través de\nla [CS:P]Cueva Cascada[CR], ¿verdad, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The first time we went to the\nHot Spring, we had to get there through\n[CS:P]Waterfall Cave[CR], [hero].", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR]. Pas vrai, [hero]?", german="Als wir das erste Mal zur\nHeißen Quelle gegangen sind, mussten wir\ndurch die [CS:P]Wasserfallhöhle[CR], [hero].", italian="La prima volta che siamo andati\nalla Sorgente Termale, siamo passati per la\n[CS:P]Grotta della Cascata[CR], [hero].", spanish="La primera vez que fuimos a la\nTerma llegamos a través de la [CS:P]Cueva Cascada[CR],\n¿verdad, [hero]?"})
  else
  SkySceneKit.say({english="I think we got to the Hot Spring\nthe first time through [CS:P]Waterfall Cave[CR],\n[hero].", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR]. Pas vrai, [hero]?", german="Wir sind beim ersten Mal durch\ndie [CS:P]Wasserfallhöhle[CR] zur Heißen Quelle gelangt.\nRichtig, [hero]?", italian="Mi pare che si arrivi alla\nSorgente Termale passando per la [CS:P]Grotta[CR]\n[CS:P]della Cascata[CR]. Vero, [hero]?", spanish="Creo que llegamos a la Terma a\ntravés de la [CS:P]Cueva Cascada[CR], ¿verdad,\n[hero]?"})
  end
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go! Off to the Hot Spring!", french="C'est parti! En route pour\nla Source Chaude!", german="Gehen wir! Auf zur Heißen\nQuelle!", italian=" Forza! Alla Sorgente Termale!", spanish=" ¡Vamos! ¡Rumbo a la Terma!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go! Onward to the\nHot Spring!", french="C'est parti! En route pour\nla Source Chaude!", german="Gehen wir! Vorwärts zur\nHeißen Quelle!", italian="Forza! Andiamo alla Sorgente\nTermale!", spanish=" ¡Vamos! ¡Rumbo a la Terma!"})
  else
  SkySceneKit.say({english=" Let's go! Off to the Hot Spring!", french="C'est parti! En route pour\nla Source Chaude!", german="Gehen wir! Auf zur Heißen\nQuelle!", italian=" Forza! Alla Sorgente Termale!", spanish=" ¡Vamos! ¡Rumbo a la Terma!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(8), p.Y+(0), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" But first...!", french=" Mais d'abord...!", german=" Aber zuerst...", italian=" Ma prima...!", spanish=" No tan deprisa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 216, Direction.Down, "NPC_PERAPPU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" It is getting late. And besides...", french=" Il se fait tard. Et en plus...", german=" Es wird spät. Und außerdem...", italian=" Si sta facendo tardi.", spanish=" Ya es muy tarde. Además..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" You must be hungry!", french=" ... vous devez avoir faim!", german=" Ihr müsst Hunger haben!", italian=" E poi avrete una gran fame!", spanish="¡Sin duda tendréis mucha\nhambre!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Huch?", italian=" Eh?", spanish=" ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Huch?", italian=" Eh?", spanish=" ¿Eh?"})
  else
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Huch?", italian=" Eh?", spanish=" ¿Eh?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" My stomach growled!", french=" J'ai l'estomac qui gargouille!", german=" Mein Magen hat geknurrt!", italian=" La mia pancia ha brontolato!", spanish=" ¡Me ruge el estómago!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" My stomach growled!", french=" J'ai l'estomac qui gargouille!", german=" Mein Magen hat geknurrt!", italian=" La mia pancia ha brontolato!", spanish=" ¡Me ruge el estómago!"})
  else
  SkySceneKit.say({english=" My stomach growled!", french=" J'ai l'estomac qui gargouille!", german=" Mein Magen hat geknurrt!", italian=" La mia pancia ha brontolato!", spanish=" ¡Me ruge el estómago!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha ha! Yours did too!", french=" Ha ha! Toi aussi!", german=" Haha! Deiner auch!", italian=" Ah ah! Anche la tua!", spanish=" ¡Ja, ja! ¡Y a ti también!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha! Yours did too!", french=" Ha ha! Toi aussi!", german=" Haha! Deiner auch!", italian=" Ah ah! Anche la tua!", spanish=" ¡Ja, ja! ¡Y a ti también!"})
  else
  SkySceneKit.say({english=" Ha ha! Yours did too!", french=" Ha ha! Toi aussi!", german=" Haha! Deiner auch!", italian=" Ah ah! Anche la tua!", spanish=" ¡Ja, ja! ¡Y a ti también!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="You should have dinner.[K]\nThen get a good night's sleep.", french="Vous devriez dîner.[K]\nEnsuite, allez vous coucher.", german="Ihr solltet zu Abend essen.[K]\nUnd dann solltet ihr ordentlich schlafen.", italian="Dovete cenare.[K] E poi passare\nuna bella notte di sonno.", spanish="Deberíais cenar.[K]\nY luego dormir bien."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="We can all get to work\ntomorrow!", french="On se mettra tous au travail\ndemain!", german="Morgen können wir uns alle\nan die Arbeit machen!", italian="Possiamo metterci tutti al\nlavoro domani!", spanish="¡Ya nos pondremos todos a\ntrabajar mañana!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8720) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]'s belly\ngrowled...again!", french="Eh, l'estomac de [hero]\na encore gargouillé!", german="Hey, der Magen von\n[hero] hat schon wieder geknurrt!", italian="Ehi, la pancia di [hero] ha\nbrontolato... di nuovo!", spanish="Vaya, la tripa de [hero]\nha vuelto a rugir..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero]'s belly\ngrowled...again!", french="Eh, l'estomac de [hero]\na encore gargouillé!", german="Hey, der Magen von\n[hero] hat schon wieder geknurrt!", italian="Ehi, la pancia di [hero] ha\nbrontolato... di nuovo!", spanish="Vaya, a [hero] le sigue\nrugiendo la tripa..."})
  else
  SkySceneKit.say({english="Hey, [hero]'s belly\ngrowled...again!", french="Eh, l'estomac de [hero]\na encore gargouillé!", german="Hey, der Magen von\n[hero] hat schon wieder geknurrt!", italian="Ehi, la pancia di [hero] ha\nbrontolato... di nuovo!", spanish="Vaya, a [hero] le sigue\nrugiendo la tripa..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Ho-ho! Did everyone hear THAT?", french="Ho ho! Vous avez entendu ÇA,\ntout le monde?", german="Ho-ho! Habt ihr DAS gehört,\nLeute?", italian=" Oh-oh! Avete sentito TUTTI?", spanish=" ¡Jo, jo! ¿Lo habéis oído todos?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What a laugh, [hero]![K]\nLetting your belly bark back at [CS:N]Chimecho[CR], eh?", french="Ah ah! [hero]![K]\nTon estomac grogne contre [CS:N]Eoko[CR], hein?", german="Urkomisch, [hero]![K]\nDein Magen hat wohl [CS:N]Palimpalim[CR]\nangeknurrt, was?", italian="Che ridere, [hero]![K] Lasci\nche sia la tua pancia a rispondere a [CS:N]Chimecho[CR],\neh?", spanish="¡Qué risa, [hero]![K]\nTu tripa responde a [CS:N]Chimecho[CR] por ti, ¿eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HA HA HA!", french="[CS:N]Tous[CR]: HA HA HA!", german="[CS:N]Alle[CR]: HA HA HA!", italian="[CS:N]Tutti[CR]: AH AH AH!", spanish="[CS:N]Todos[CR]: ¡JA, JA, JA!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
