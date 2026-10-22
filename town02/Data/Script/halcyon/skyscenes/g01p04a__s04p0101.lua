-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/s04p0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkyProg.set(29, 55) -- $SCENARIO_MAIN = scn[29,55] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'US04') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 376, 232, Direction.DownRight, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 464, 272, Direction.UpLeft, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 432, 216, Direction.Down, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 400, 224, Direction.DownRight, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 440, 272, Direction.Up, "NPC_HEIGANI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 464, 224, Direction.DownLeft, "NPC_KIMAWARI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 408, 272, Direction.Up, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 376, 264, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 480, 248, Direction.Left, "NPC_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? What's going on?[K] Why's\neveryone gathered around?", french="Hein? Qu'est-ce qui se passe?[K]\nPourquoi ce rassemblement?", german="Was passiert hier?[K] Warum\nkommen alle hier zusammen?", italian="Eh? Cosa succede?[K] Perché sono\ntutti riuniti qui?", spanish="¿Eh? ¿Qué ocurre?[K] ¿Por qué\nestán todos reunidos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Huh? What's going on?[K]\nI wonder what everyone's doing here.", french="Hein? Qu'est-ce qui se passe?[K]\nPourquoi ce rassemblement?", german="Was passiert hier?[K] Warum\nversammeln sich alle hier?", italian="Eh? Cosa succede?[K] Perché sono\ntutti riuniti qui?", spanish="¿Eh? ¿Qué ocurre?[K] ¿Por qué\nestán todos reunidos?"})
  else
  SkySceneKit.say({english="Oh? What's going on?[K] What's\neveryone doing here?", french="Hein? Qu'est-ce qui se passe?[K]\nPourquoi ce rassemblement?", german="Was passiert hier?[K] Was\nmachen die alle hier?", italian="Eh? Cosa succede?[K] Perché sono\ntutti riuniti qui?", spanish="¿Eh? ¿Qué ocurre?[K] ¿Por qué\nestán todos reunidos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  pcall(function() GAME:MoveCamera(420, 248, 60, false) end) -- performer/caméra
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(32), false, 2) end
  GROUND:MoveToPosition(partner, 348, 252, false, 2)
  GROUND:MoveToPosition(hero, 348, 228, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! It's unbelievable!", french="Ben mince alors! C'est\ncarrément hallucinant!", german=" Auweia! Es ist unglaublich!", italian=" Shock! È incredibile!", spanish="¡No me lo puedo creer!\n¡Increíble!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" They're the real deal, by golly!", french="C't'équipe, c'est pas d'la\ngnognote, pour sûr!", german="Die haben es drauf,\nDonnerwetter!", italian=" Sono proprio le migliori, ohibò!", spanish=" ¡Huyuyuy! ¡Son la bomba!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Wow! Can I get your autographs,\nPLEASE?", french="Waouh! Dites, je peux avoir\nvos autographes, S'IL VOUS PLAIT!", german="Wow! Kann ich Autogramme von\neuch haben, BITTE?", italian="Wow! Posso avere i vostri\nautografi, PER FAVORE?", spanish="¡Eh! ¿Podéis firmarme un\nautógrafo, por favor?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(388, 248, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Who are\nthose Pokémon?", french="Hé, [CS:N]Pijako[CR].[K] Qui sont ces\nPokémon?", german="Hey, [CS:N]Plaudagei[CR].[K] Wer sind diese\nPokémon?", italian="Ehi, [CS:N]Chatot[CR].[K] Chi sono quei\nPokémon?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Quiénes son\nestos Pokémon?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [CS:N]Chatot[CR].[K] Who are\nthose Pokémon?", french="Hé, [CS:N]Pijako[CR].[K] Qui sont ces\nPokémon?", german="Hey, [CS:N]Plaudagei[CR].[K] Wer sind diese\nPokémon?", italian="Ehi, [CS:N]Chatot[CR].[K] Chi sono quei\nPokémon?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Quiénes son\nestos Pokémon?"})
  else
  SkySceneKit.say({english="Say, [CS:N]Chatot[CR].[K] Who are\nthose Pokémon?", french="Hé, [CS:N]Pijako[CR].[K] Qui sont ces\nPokémon?", german="Hey, [CS:N]Plaudagei[CR].[K] Wer sind diese\nPokémon?", italian="Ehi, [CS:N]Chatot[CR].[K] Chi sono quei\nPokémon?", spanish="Oye, [CS:N]Chatot[CR].[K] ¿Quiénes son\nestos Pokémon?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Huh?![K] There you go sticking your\nfoot in your mouth again!", french="Pardon?![K] Ne me dites pas que\nvous recommencez à mettre les pattes dans\nle plat, vous deux?", german="Äh?!?[K] Da seid ihr aber wieder\nmal mächtig ins Fettnäpfchen getreten!", italian="Eh?![K] Ecco che come al solito\nfai la tua figura da ignorante!", spanish="¡¿Cómo?![K] ¡Ya estáis otra vez\nmetiendo la pata!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That lovely trio is Team [CS:X]Charm[CR],\nthe ultrafamous treasure hunters!", french="Ce trio adorable est l'Equipe\n[CS:X]Charme[CR], les célébrissimes chasseuses\nde trésors!", german="Dieses entzückende Trio ist\nTeam [CS:X]Charme[CR], die superberühmten\nSchatzjäger!", italian="Quello è il fantastico\nTeam [CS:X]Malia[CR], composto dalle famosissime\ncacciatrici di tesori!", spanish="Este trío es el [CS:X]Equipo Carisma[CR],\n¡las ultra famosas buscadoras de tesoros!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They've earned the Master Rank,\nwhich is reserved solely for teams of\nextraordinary merit.", french="Elles ont remporté le Grade\nMaître, qui est réservé exclusivement aux\néquipes de grand mérite.", german="Sie haben den Meister-Rang\nerlangt, der nur Teams mit außergewöhnlichen\nVerdiensten verliehen wird.", italian="Hanno raggiunto il Rango Master,\nriservato solamente alle squadre di eccezionale\ntalento.", spanish="Han alcanzado el Rango Experto,\nreservado solamente para equipos con grandes\nméritos en su haber."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As expert treasure hunters,\nthey've discovered countless treasures.", french="Elles comptent parmi les plus\ngrands experts de la chasse aux trésors,\net leurs découvertes sont innombrables.", german="Als Experten der Schatzsuche\nhaben sie unzählige Schätze entdeckt.", italian="Come esperte cacciatrici\ndi tesori, hanno scoperto un'infinità di\nbottini.", spanish="Como expertas que son, han\ndescubierto infinidad de tesoros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Moreover, they don't just find\ntreasures. Oh, no!", french="Qui plus est, elles ne font pas\nque dénicher des trésors, oh non!", german="Außerdem finden sie nicht\neinfach nur Schätze. Oh nein!", italian="Inoltre, non si limitano\na trovare tesori. Oh, no!", spanish=" Y no solo eso. ¡Qué va!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Strong! Smart! Beautiful![K]\nThe sheer style of their treasure hunts is what\nmakes them celebrities! ♪", french="Elles sont belles! Fortes!\nElégantes![K] Tel est leur style inimitable\nqui les a rendues célèbres! ♪", german="Stark! Clever! Schön![K]\nEs ist der Stil, mit dem sie ihre Schätze\nfinden, der sie zu Berühmtheiten macht! ♪", italian="Forti! Belle! Scaltre![K]\nÈ il loro stile che le rende delle celebrità! ♪", spanish="¡Fuertes! ¡Astutas! ¡Hermosas![K]\nSu refinado estilo las ha convertido en\nestrellas. ¡Son famosísimas! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(420, 248, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end) -- message_SetActor(ACTOR_NPC_PERAPPU)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In the middle is [CS:N]Lopunny[CR]. She's\nthe gorgeous one with the long ears.", french="Au milieu, c'est [CS:N]Lockpin[CR], aux\nlongues oreilles et à la beauté sans pareille.", german="In ihrer Mitte steht [CS:N]Schlapor[CR].\nSie ist das reizende Pokémon mit den langen\nOhren.", italian="Quella in mezzo è [CS:N]Lopunny[CR]. È\nquella bellissima con le orecchie lunghe.", spanish="La del medio, esa preciosidad de\nlargas orejas, es [CS:N]Lopunny[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(444, 248, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Next to her is the serenely\nelegant [CS:N]Gardevoir[CR]! ♪[K] Ah, she is so beautiful...", french="A côté d'elle, [CS:N]Gardevoir[CR],\nau charme serein et élégant! ♪[K] Comme elle\nest belle...", german="Neben ihr steht in ihrer stillen\nEleganz [CS:N]Guardevoir[CR]! ♪[K] Ah, sie ist\nwunderschön...", italian="Accanto a lei c'è l'elegantissima\n[CS:N]Gardevoir[CR]! ♪[K] Ah, è così affascinante...", spanish="Junto a ella se encuentra la\nelegante [CS:N]Gardevoir[CR]. ♪[K] Es tan bella..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(396, 248, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Finally, there's [CS:N]Medicham[CR].[K]\nShe moves and flows as if she's dancing all\nthe time. Irresistibly cool!", french="Et enfin, [CS:N]Charmina[CR], à la grâce\ninégalée.[K] Lorsqu'elle se déplace, elle semble\ndanser et flotter. Elle est irrésistible!", german="Und dann ist da noch [CS:N]Meditalis[CR].[K]\nSie schwebt und bewegt sich wie eine\nTänzerin. Unwiderstehlich cool!", italian="E per finire, l'altra è\n[CS:N]Medicham[CR].[K] Si muove leggiadra come se stesse\nsempre danzando. Ha un fascino irresistibile!", spanish="Y por último, [CS:N]Medicham[CR].[K]\nSe mueve como si estuviera bailando\npermanentemente. ¡Irresistible!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But I must wonder... Why would\nthe beauties of Team [CS:X]Charm[CR] visit here?", french="Mais je me pose une question...\nPourquoi les enchanteresses de l'Equipe [CS:X]Charme[CR]\nnous rendent-elles visite?", german="Eines muss man sich jedoch\nfragen. Warum kommen die Schönheiten von\nTeam [CS:X]Charme[CR] hierher zu Besuch?", italian="Ma... Chissà perché il Team\n[CS:X]Malia[CR] è venuto qui?", spanish="Lo que me pregunto es por qué\nlas bellezas del [CS:X]Equipo Carisma[CR] habrán\nvenido hasta aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 176, Direction.Down, "NPC_PUKURIN")
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(2, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Hiya!", french=" Amis du jour, bonjour!", german=" Hallo ihr!", italian=" Ullalà!", spanish=" ¿Qué hay?"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_mimiroppu = SkySceneKit.spawn_npc("lopunny", 424, 248, Direction.Down, "NPC_MIMIROPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 400, 248, Direction.DownLeft, "NPC_CHAAREMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "exclaim", 1) end)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 448, 248, Direction.DownRight, "NPC_SAANAITO")
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_mimiroppu, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_pukurin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(420, 248, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Oh! [CS:N]Wigglytuff[CR], darling! It's\nbeen a long time, sweetie!", french="Oh! [CS:N]Grodoudou[CR], mon chéri!\nÇa fait une éternité, mon biquet!", german="Oh! [CS:N]Knuddeluff[CR], Liebling!\nEs ist so lange her, Süßer!", italian="Oh! [CS:N]Wigglytuff[CR], caro! È\npassato parecchio tempo!", spanish="¡[CS:N]Wigglytuff[CR], cariño!\n¡Cuánto tiempo sin verte, encanto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 216, false, 2)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(16), p.Y+(-12), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(-12), p.Y+(-12), false, 2) end
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Oh, [CS:N]Wigglytuff[CR]! You haven't\nchanged one bit!", french="Oh, mon cher [CS:N]Grodoudou[CR]!\nTu n'as pas changé d'un poil!", german="Oh, [CS:N]Knuddeluff[CR]! Du hast dich\nkein Stückchen verändert!", italian="Oh, [CS:N]Wigglytuff[CR]! Non sei\ncambiato di una virgola!", spanish="¡[CS:N]Wigglytuff[CR]! ¡No has\ncambiado nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Seeing you as a Guildmaster...\nImagine that! That's amazing!", french="Te voilà aujourd'hui maître\nd'une guilde... Voyez-vous ça! C'est\nincroyable!", german="Du, ein Gildenmeister...\nDas stell sich mal einer vor! Unglaublich!", italian="Vederti come Capitano...\nChi l'avrebbe detto! È incredibile!", spanish="El Gran Bluff...\n¡Impresionante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It has been a long time,\n[CS:N]Wigglytuff[CR].", french="Cela fait longtemps,\n[CS:N]Grodoudou[CR].", german="Es ist lange her,\n[CS:N]Knuddeluff[CR].", italian="Ne è passato di tempo,\n[CS:N]Wigglytuff[CR].", spanish="Ha pasado tanto tiempo,\n[CS:N]Wigglytuff[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yup. Long time no see! ♪[K]\nHave you all been well?", french="Oui. Ça fait un bail qu'on ne\ns'est pas vus! ♪[K] Comment allez-vous,\nmesdemoiselles?", german="Jep. Lange nicht gesehen! ♪[K]\nIst es euch gut ergangen?", italian="Già. È da un bel po' che non\nci vediamo! ♪[K] State tutte bene?", spanish="Sí. ¡Tanto tiempo! ♪[K]\n¿Vosotras qué tal, todo bien?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(24), g.ViewCenter.Y+(0), 24, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ...[K]Long time...?[K] You mean...", french=" ...[K] Un bail...?[K] Mais alors...", german=" ...[K]Lange nicht?[K] Du meinst...", italian="...[K] Un bel po'...?[K] Vuol dire\nche...", spanish="¿Eh?[K] ¿Cómo que tanto tiempo?[K]\nEs que..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="Guildmaster...[K] Are you already\nacquainted with Team [CS:X]Charm[CR]?", french="Maître...[K] Vous connaissez déjà\nl'Equipe [CS:X]Charme[CR]?", german="Gildenmeister...[K] Kennst du\nTeam [CS:X]Charme[CR] etwa schon?", italian="Capitano...[K] Conoscevi già il\nTeam [CS:X]Malia[CR]?", spanish="Gran Bluff...[K] ¿Ya conocías al\n[CS:X]Equipo Carisma[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-24), g.ViewCenter.Y+(0), 24, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Oh! [CS:N]Wigglytuff[CR] was a real\ngo-getter back in the day. Like, grrrowl![K]\nSo how are you nowadays?", french="Oh! [CS:N]Grodoudou[CR] était un vrai\nbattant autrefois. Férrrroce, tu vois le\ngenre![K] Et aujourd'hui, que deviens-tu?", german="Oh! [CS:N]Knuddeluff[CR] war ein echter\nDraufgänger damals. Hehe, roaaaaar![K]\nWie bist du denn heutzutage so?", italian="Oh! [CS:N]Wigglytuff[CR] era un gran bel\nfusto all'epoca![K] Allora, come te la passi?", spanish="¡Claro! [CS:N]Wigglytuff[CR] era todo\nun elemento en su época. ¡Sí, sí![K]\nCuéntanos, ¿cómo te va?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Back then, [CS:N]Wigglytuff[CR] was\nsomething else. No one could beat him. So cool!", french="Ah, [CS:N]Grodoudou[CR]! Il était\ncoquet, mais personne ne pouvait le battre!\nC'était la claaaaaasse!", german="Damals war [CS:N]Knuddeluff[CR] eine\nechte Marke. Niemand konnte ihn besiegen.\nEr war wirklich cool!", italian="Ai tempi, [CS:N]Wigglytuff[CR] era un\nfenomeno. Nessuno poteva batterlo. Era così\natletico!", spanish="Por aquel entonces, [CS:N]Wigglytuff[CR]\nera increíble, invencible. ¡Era genial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Ha ha ha! ♪", french=" Ha ha ha! ♪", german=" Ha ha ha! ♪", italian=" Ah ah ah! ♪", spanish=" ¡Ja, ja, ja! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Uh, Guildmaster...[K] Uh, how do\nyou know the beauties of Team [CS:X]Charm[CR]?", french="Euh, Maître...[K] euh, comment\navez-vous fait la connaissance de l'Equipe\n[CS:X]Charme[CR]?", german="Ähem, Gildenmeister...[K] Äh,\nkennst du die Hübschen von Team [CS:X]Charme[CR]\netwa?", italian="Eh, Capitano...[K] Eh, come fa a\nconoscere le bellezze del Team [CS:X]Malia[CR]?", spanish="Esto... Gran Bluff...[K] ¿Cómo es\nque conoces a las bellas integrantes del\n[CS:X]Equipo Carisma[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.UpLeft)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Well, they're my friends.[K]\nFriends from long ago! ♪", french="Eh bien, ce sont mes amies.[K]\nDes amies de longue date! ♪", german="Nun, sie sind meine Freunde.[K]\nGute, alte Freunde! ♪", italian="Beh, sono mie amiche.[K]\nAmiche da tanto tempo! ♪", spanish="Son amigas mías.[K]\n¡Viejas amigas! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="That's right. We were partners\nin exploration with [CS:N]Wigglytuff[CR].", french="C'est exact. Nous étions\nles partenaires d'exploration de [CS:N]Grodoudou[CR].", german="Das stimmt. Wir waren Partner\nvon [CS:N]Knuddeluff[CR] bei Erkundungen.", italian="Esatto. Eravamo compagne\nd'esplorazione di [CS:N]Wigglytuff[CR].", spanish="Exacto. Fuimos compañeras de\n[CS:N]Wigglytuff[CR] en una expedición."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Whaaaat?!", french=" Quoiii?!", german=" Waaaas?!?", italian=" Cooosa?!", spanish=" ¡¿Quéeee?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster...[K]\nAnd Team [CS:X]Charm[CR]...?", french="Le Maître de la Guilde...[K]\net l'Equipe [CS:X]Charme[CR]...?", german="Der Gildenmeister...[K]\nUnd Team [CS:X]Charme[CR]?", italian=" Il Capitano...[K] e il Team [CS:X]Malia[CR]?", spanish="Gran Bluff de expedición...[K]\n¿Con el [CS:X]Equipo Carisma[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" So what brings you all here?", french="Sinon, y a-t-il quelque chose que\nje puisse faire pour vous, les filles?", german=" Was führt euch denn hierher?", italian=" Allora, qual buon vento vi porta?", spanish=" ¿Y qué os trae por aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_chaaremu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="So astute of you. We came about\nan important matter.", french="Quelle perspicacité. Nous\nvenons pour un problème important.", german="Du bist ein cleveres Kerlchen.\nWir kommen in einer wichtigen Angelegenheit.", italian="Astuto come un tempo! Siamo\nvenute per una faccenda importante.", spanish="No se te escapa una, ¿eh?\nVenimos por un asunto importante."})
  -- message_KeyWait
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Do you recall, when we were\nexploring a long time ago, that we found a\nmysterious key?", french="Tu te souviens de cette clé\nmystérieuse que nous avons trouvée lors\nde cette exploration, il y a longtemps?", german="Erinnerst du dich, als wir\nvor langer Zeit auf einer Erkundung waren und\neinen seltsamen Schlüssel gefunden haben?", italian="Ti ricordi che nel corso di una\nesplorazione, tanto tempo fa, avevamo\ntrovato una chiave misteriosa?", spanish="¿Recuerdas que una vez, en\nuna exploración hace ya mucho tiempo,\nencontramos una llave?"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="At the time, we didn't know what\nthe key was for. Well, we've finally found\nout where it should be used.", french="Nous n'avons pas su à quoi elle\nservait à l'époque. Mais aujourd'hui, nous\nl'avons découvert.", german="Zu der Zeit wussten wir nicht,\nwozu dieser Schlüssel passt. Aber wir haben\nes nun endlich herausgefunden.", italian="All'epoca, non sapevamo a cosa\nservisse. Beh, abbiamo finalmente scoperto\ndove dev'essere usata.", spanish="No pudimos averiguar para qué\nservía. Bueno, pues el caso es que ahora ya\nsabemos qué podría abrir."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="You see, we discovered a place\ncalled [CS:P]Aegis Cave[CR]. That key is a perfect fit\nfor the keyhole to its entrance.", french="Nous avons découvert un endroit\nappelé la [CS:P]Grotte Egide[CR]. Cette clé correspond\nparfaitement à la serrure de l'entrée.", german="Wir entdeckten einen Ort namens\n[CS:P]Ägishöhle[CR]. Der Schlüssel passt perfekt in\ndas Schlüsselloch an ihrem Eingang.", italian="Abbiamo scoperto un luogo\nchiamato [CS:P]Grotta Egida[CR]. La chiave si adatta\nperfettamente al meccanismo di entrata.", spanish="Hemos descubierto un lugar\nllamado [CS:P]Cueva Regia[CR]. Creemos que esa llave\npodría encajar en la cerradura de la entrada."})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="There's more. It's said that the\ncave holds a vast trove of treasure.", french="De plus, on raconte que la grotte\nrecèle moult trésors.", german="Das war noch nicht alles. Es\nheißt, die Höhle beherberge einen reichhaltigen\nVorrat an Schätzen.", italian="C'è di più. Si dice che la\ncaverna contenga un tesoro immenso.", spanish="Se dice que en la cueva hay\nun gran tesoro oculto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" A vast trove of...", french=" MOULT trésors...", german=" Einen reichhaltigen Vorrat an...", italian=" Un tesoro...", spanish=" Un gran tesoro..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Treasure?!", french=" Des trésors?!", german=" Schätzen?!?", italian=" ... immenso?!", spanish=" ¡¿Tesoro?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Say, [CS:N]Wigglytuff[CR], darling...[K]\nThat key we found then...[K] You've still got it,\nhaven't you?", french="Dis, [CS:N]Grodoudou[CR], chéri...[K]\nLa clé que nous avons trouvée...[K] tu l'as\ntoujours, n'est-ce pas?", german="Du, [CS:N]Knuddeluff[CR], Liebling...[K]\nDiesen Schlüssel, den wir gefunden haben...[K]\nDen hast du doch noch, oder nicht?", italian="Di' un po', [CS:N]Wigglytuff[CR], tesoro...[K]\nLa chiave che avevamo trovato...[K] Ce l'hai\nancora, vero?", spanish="[CS:N]Wigglytuff[CR], cielo...[K]\nAquella llave que encontramos...[K] aún la\nconservas, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Key?[K] Um... What kind of key?", french="La clé?[K] Hum... A quoi\nressemble-t-elle?", german="Schlüssel?[K]\nÄhem... Was für einen Schlüssel denn?", italian="Chiave?[K] Ehm... Che tipo\ndi chiave?", spanish="¿Llave?[K] ¿Qué clase de\nllave?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I don't remember. Ha ha ha!", french="Je ne m'en souviens plus du tout.\nHa ha ha!", german="Ich kann mich nicht erinnern.\nHa ha ha!", italian=" Non mi ricordo. Ah ah ah!", spanish=" No me acuerdo. ¡Ja, ja, ja!"})
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  GAME:WaitFrames(5)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "angry", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hey![K] We went through a lot to\nget that key! Are you saying you've lost it?", french="Hé![K] Nous avons beaucoup\nlutté pour avoir cette clé! Et toi, tu oses\nnous dire que tu l'as perdue?", german="Hey![K] Wir haben eine Menge\ndurchgemacht, um an diesen Schlüssel zu\ngelangen! Heißt das, du hast ihn verloren?", italian="Ehi![K] Ne abbiamo passate un\nsacco per ottenere quella chiave! Stai dicendo\nche l'hai persa?", spanish="¡¿Cómo?![K] ¡Nos costó mucho\nconseguir esa llave! ¿No la habrás perdido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="...[K]That's typical for [CS:N]Wigglytuff[CR].\nSome things haven't changed at all, it seems.", french="...[K] Je reconnais bien là\n[CS:N]Grodoudou[CR]. Il semblerait que certaines choses\nne changent jamais.", german="...[K]Das ist mal wieder typisch,\n[CS:N]Knuddeluff[CR]. Manche Dinge ändern sich eben nie.", italian="...[K] È tipico di [CS:N]Wigglytuff[CR].\nCerte cose non cambiano mai, a quanto pare.", spanish="Vaya...[K] Típico de [CS:N]Wigglytuff[CR].\nParece que algunas cosas nunca cambian."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" [CS:N]Lopunny[CR], it's time for our gift...", french=" [CS:N]Lockpin[CR], le cadeau...", german="[CS:N]Schlapor[CR], Zeit für unser\nGeschenk...", italian="[CS:N]Lopunny[CR], è ora del nostro\nregalo...", spanish="[CS:N]Lopunny[CR], es la hora del\nregalo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" I hear you, [CS:N]Gardevoir[CR].", french=" J'ai compris, [CS:N]Gardevoir[CR].", german=" Schon verstanden, [CS:N]Guardevoir[CR].", italian=" Sono d'accordo, [CS:N]Gardevoir[CR].", spanish=" Sí, [CS:N]Gardevoir[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Here you go, [CS:N]Wigglytuff[CR].[K]\nWe've brought you a little gift.", french="Voici pour toi, [CS:N]Grodoudou[CR].[K]\nNous t'avons apporté un petit cadeau.", german="Bitte schön, [CS:N]Knuddeluff[CR].[K]\nWir haben ein kleines Geschenk für dich.", italian="Ecco a te, [CS:N]Wigglytuff[CR].[K]\nTi abbiamo portato un piccolo regalo.", spanish="Toma, [CS:N]Wigglytuff[CR].[K]\nTe hemos traído un regalo."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="It's your favorite!\nA Perfect Apple.", french="C'est ton mets préféré! Une\nPomme Parfaite!", german="Das magst du doch am liebsten!\nEinen Perfekten Apfel!", italian="È la tua cosa preferita! Una\nMela Perfetta.", spanish="¡Tu favorito! Una Manzana\nPerfecta."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(0), p.Y+(-8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_mimiroppu.Position; GROUND:MoveToPosition(npc_npc_mimiroppu, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Wow! A Perfect Apple![K] This is\nfor me?", french="Waaaouh! Une Pomme Parfaite![K]\nC'est pour moi?", german="Wow! Ein Perfekter Apfel![K]\nDer ist für mich?", italian="Wow! Una Mela Perfetta![K]\nÈ per me?", spanish="¡Vaya! ¡Una Manzana Perfecta![K]\n¿Es para mí?"})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay! Thank you!", french=" Youhouuuuuu! Merci!", german=" Juchhu! Danke sehr!", italian=" Grande! Grazie!", spanish=" ¡Genial! ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(4), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(60)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" So...[K]about that key...", french=" Bon alors...[K] cette clé...", german=" So...[K] Wegen des Schlüssels...", italian="Allora,[K] a proposito di\nquella chiave...", spanish=" Bueno...[K] en cuanto a la llave..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh! I remember now![K] That key!\nThe one shaped like an [CS:K]Unown[CR].", french="Oh! Je m'en souviens![K] C'est\ncette clé-là! Celle qui est en forme de [CS:K]Zarbi[CR].", german="Oh! Jetzt fällt es mir wieder\nein![K] Dieser Schlüssel in der Form eines\n[CS:K]Icognito[CR].", italian="Oh! Adesso mi ricordo![K]\nLa chiave! Quella a forma di [CS:K]Unown[CR].", spanish="¡Oh! ¡Ahora me acuerdo![K]\n¡La llave! Aquella con forma de [CS:K]Unown[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" I'll go look!", french=" Je reviens!", german=" Ich seh mal nach ihm!", italian=" Vado a guardare!", spanish=" ¡Voy a ver!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:FadeOutBGM(90) end)
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 172, false, 2)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end) -- message_SetActor(ACTOR_NPC_PUKURIN)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" YOOM...TAH!", french=" TA-DAAA!", german=" LUUUU... FIIII!", italian=" BADABUM!", spanish=" ¡Genial!"})
  -- message_Close
  -- GAP: se_Play(7947) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(50)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(60)
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 216, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Left)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(12), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Here you go! ♪", french=" Et... hooop là! ♪", german=" Bitte sehr! ♪", italian=" Ecco a voi! ♪", spanish=" ¡Aquí tenéis! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 216, false, 2) -- SlidePositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Yes, darling! This is the key.[K]\nThis will open the way into [CS:P]Aegis Cave[CR].", french="Bravo, chéri! C'est la clé.[K]\nNous allons pouvoir entrer dans la\n[CS:P]Grotte Egide[CR].", german="Genau, Liebling! Das ist der\nSchlüssel.[K] Er öffnet den Weg zur [CS:P]Ägishöhle[CR].", italian="Sì, caro! È proprio lei.[K]\nQuesta chiave ci aprirà le porte\ndella [CS:P]Grotta Egida[CR].", spanish="¡Sí, encanto! Esta es la llave.[K]\nNos abrirá la entrada de la [CS:P]Cueva Regia[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Thank you, [CS:N]Wigglytuff[CR]!", french=" Merci, [CS:N]Grodoudou[CR]!", german=" Danke schön, [CS:N]Knuddeluff[CR]!", italian=" Grazie, [CS:N]Wigglytuff[CR]!", spanish=" ¡Gracias, [CS:N]Wigglytuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
  -- SetAnimation(5) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Say, why don't you join us?\nIt will be like old times.", french="Dis, pourquoi ne pas te joindre\nà nous? Comme au bon vieux temps?", german="Sag mal, warum kommst du nicht\nmit? Es wäre wie in alten Zeiten.", italian="Ehi, perché non vieni con noi?\nSarà come ai vecchi tempi.", spanish="¿Por qué no te vienes con\nnosotras? Sería como en los viejos\ntiempos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Yay! A Perfect Apple! ♪\nThank you!", french="Youhouuu! Une Pomme\nParfaite! ♪ Merci! Amies de moi!", german="Juchhu! Ein Perfekter Apfel! ♪\nDanke schön!", italian="Grande! Una Mela Perfetta! ♪\nGrazie!", spanish="¡Caray! ¡Una Manzana Perfecta!\n¡Gracias! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" ...[K]You really haven't changed...", french="...[K] Toi alors, tu n'as vraiment\npas changé...", german="...[K]Du hast dich wirklich nicht\nverändert...", italian=" ...[K] Non sei proprio cambiato...", spanish=" Vaya...[K] No has cambiado nada..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" We'll be going now, sweetie.", french=" Nous y allons, mon biquet.", german=" Wir gehen jetzt, Süßer.", italian=" Adesso ce ne andiamo, tesoro.", spanish=" Nos vamos, cariño."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" See you, [CS:N]Wigglytuff[CR]!", french=" A bientôt, [CS:N]Grodoudou[CR]!", german=" Bis dann, [CS:N]Knuddeluff[CR]!", italian=" Ciao, [CS:N]Wigglytuff[CR]!", spanish=" ¡Adiós, [CS:N]Wigglytuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(180) end)
  pcall(function() GAME:MoveCamera(356, 248, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_chaaremu, 324, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 324, 244, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 348, 244, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 300, 244, false, 2)
  GROUND:MoveToPosition(partner, 324, 268, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_heigani, 396, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 420, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 428, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 444, 260, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:MoveToPosition(npc_npc_chaaremu, 324, 220, false, 2)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...[K] Excuse me!", french=" Euh...[K] excusez-moi!", german=" Äh...[K] Verzeihung bitte!", italian=" Eh...[K] Scusatemi!", spanish=" Eh...[K] ¡Perdonad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh...[K] Excuse me!", french=" Euh...[K] excusez-moi!", german=" Äh...[K] Verzeihung bitte!", italian=" Eh...[K] Scusatemi!", spanish=" Eh...[K] ¡Perdonad!"})
  else
  SkySceneKit.say({english=" Uh...[K] Excuse me!", french=" Euh...[K] excusez-moi!", german=" Äh...[K] Verzeihung bitte!", italian=" Eh...[K] Scusatemi!", spanish=" Eh...[K] ¡Perdonad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Yes?", french=" Oui?", german=" Ja?", italian=" Sì?", spanish=" ¿Sí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Um...[K] Would it be all right if we\njoined you? For exploring, I mean.", french="Hum...[K] Peut-on se joindre\nà vous? Pour l'exploration?", german="Ähem...[K] Wäre es okay, wenn\nwir euch begleiten würden? Auf der\nErkundung, meine ich.", italian="Ehm...[K] Vi va bene se ci uniamo\na voi? Intendo per l'esplorazione.", spanish="Hum...[K] ¿Podríamos ir con\nvosotras? Para explorar, claro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Um...[K] May we go exploring\nwith you?", french="Hum...[K] Peut-on se joindre\nà vous? Pour l'exploration?", german="Ähem...[K] Dürfen wir mit euch\nauf Erkundung gehen?", italian="Ehm...[K] Vi va bene se ci uniamo\na voi?", spanish="Hum...[K] ¿Podríamos ir con\nvosotras? Para explorar, claro."})
  else
  SkySceneKit.say({english="Um...[K] Would it be all right if we\nwent exploring with you?", french="Hum...[K] Peut-on se joindre\nà vous? Pour l'exploration?", german="Ähem...[K] Hättet ihr etwas\ndagegen, wenn wir mit euch auf Erkundung\ngehen würden?", italian="Ehm...[K] Vi va bene se ci uniamo\na voi?", spanish="Hum...[K] ¿Podríamos ir con\nvosotras? Para explorar, claro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" ME TOO!", french=" MOI AUSSI!", german=" ICH AUCH!", italian=" OH! ANCH'IO!", spanish=" ¡Yo también quiero!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" And me!", french=" Et moi!", german=" Und ich!", italian=" Anch'io!", spanish=" ¡Y yo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! I want to go too!", french="Ben mince alors! Je veux trop\ny aller, moi aussi!", german=" Auweia! Ich möchte auch mit!", italian=" Shock! Voglio venire anch'io!", spanish="¡No me lo puedo perder!\n¡Jo, yo también quiero ir!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 5) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And you, [hero]?", french=" Et toi, [hero]?", german=" Und du, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Y tú, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And you, [hero]?", french=" Et toi, [hero]?", german=" Und du, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Y tú, [hero]?"})
  else
  SkySceneKit.say({english=" And you, [hero]?", french=" Et toi, [hero]?", german=" Und du, [hero]?", italian=" E tu, [hero]?", spanish=" ¿Y tú, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You want to go explore this new\nplace too, right, [hero]?", french="Tu veux aussi explorer cet\nendroit, n'est-ce pas, [hero]?", german="Du möchtest diesen neuen Ort\ndoch auch erkunden, [hero], oder?", italian="Anche tu vuoi andare a esplorare\nquesto nuovo posto, non è così [hero]?", spanish="¿No te gustaría explorar esa\nzona?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You'd like to go explore this new\ndungeon too, right, [hero]?", french="Tu veux aussi explorer cet\nendroit, n'est-ce pas, [hero]?", german="Du möchtest den neuen Dungeon\ndoch auch erkunden, [hero], oder?", italian="Anche tu vuoi andare a esplorare\nquesto nuovo posto, non è così [hero]?", spanish="¿No te gustaría explorar esa\nzona?"})
  else
  SkySceneKit.say({english="You'd like to go explore this new\ndungeon too, right, [hero]?", french="Tu veux aussi explorer cet\nendroit, n'est-ce pas, [hero]?", german="Du möchtest den neuen Dungeon\ndoch auch erkunden, [hero], oder?", italian="Anche tu vuoi andare a esplorare\nquesto nuovo posto, non è così [hero]?", spanish="¿No te gustaría explorar esa\nzona?"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 5) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, that's right!\nThat's the spirit!", french="Oui, c'est ça! C'est la réponse\nque j'attendais!", german="Ja! Das ist die richtige\nEinstellung!", italian="Sì! Questo è l'atteggiamento\ngiusto!", spanish=" ¡Sí! ¡Así se habla!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yeah, that's right! That's the\nright answer!", french="Oui, c'est ça! C'est la réponse\nque j'attendais!", german=" Ja! Das ist die richtige Antwort!", italian="Sì! Questo è l'atteggiamento\ngiusto!", spanish=" ¡Buena respuesta!"})
  else
  SkySceneKit.say({english="Yep, good answer!\nThat's the spirit!", french="Oui, c'est ça! C'est la réponse\nque j'attendais!", german="Jep, gute Antwort! Das ist die\nrichtige Einstellung!", italian="Sì! Questo è l'atteggiamento\ngiusto!", spanish=" ¡Respuesta correcta!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Please let us join you!", french="S'il vous plaît, est-ce qu'on\npourrait se joindre à vous?", german="Dürfen wir uns euch bitte\nanschließen?", italian=" Per favore...", spanish="¡Dejad que os acompañemos,\npor favor!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Please let us join you!", french="S'il vous plaît, est-ce qu'on\npourrait se joindre à vous?", german="Dürfen wir uns euch bitte\nanschließen?", italian=" Per favore...", spanish="¡Dejad que os acompañemos,\npor favor!"})
  else
  SkySceneKit.say({english=" Please let us join you!", french="S'il vous plaît, est-ce qu'on\npourrait se joindre à vous?", german="Dürfen wir uns euch bitte\nanschließen?", italian=" Per favore...", spanish="¡Dejad que os acompañemos,\npor favor!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Please let us go exploring\nwith you!", french="On voudrait tant partir\nen exploration avec vous!", german="Bitte lasst uns mit euch auf\nErkundung gehen!", italian="Fateci venire a esplorare\ncon voi!", spanish="¡Dejadnos ir a explorar con\nvosotras, anda!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Please let us go exploring\nwith you!", french="On voudrait tant partir\nen exploration avec vous!", german="Bitte lasst uns mit euch auf\nErkundung gehen!", italian="Fateci venire a esplorare\ncon voi!", spanish="¡Dejadnos ir a explorar con\nvosotras, anda!"})
  else
  SkySceneKit.say({english="Please let us go exploring\nwith you!", french="On voudrait tant partir\nen exploration avec vous!", german="Bitte lasst uns mit euch auf\nErkundung gehen!", italian="Fateci venire a esplorare\ncon voi!", spanish="¡Dejadnos ir a explorar con\nvosotras, anda!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: PLEASE?", french="[CS:N]Tous[CR]: S'IL VOUS PLAIT?", german="[CS:N]Alle[CR]: BITTE!", italian="[CS:N]Tutti[CR]: PER FAVORE?", spanish="[CS:N]Todos[CR]: ¡VENGA!"})
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  GAME:WaitFrames(60)
  GROUND:EntTurn(npc_npc_mimiroppu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_saanaito, Direction.DownLeft)
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="Tee-hee! Everyone is so earnest.\nYou are all so adorable!", french="Hi hi hi! Quelle détermination!\nVous êtes tous adorables!", german="Hihi! Jeder hier ist so engagiert!\nIhr seid alle so liebenswert!", italian="Eeh-eeh! Sono tutti così\nvolenterosi. Siete adorabili!", spanish="¡Ji, ji! Todos al unísono.\n¡Sois encantadores!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_mimiroppu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english=" Of course you may!", french=" Ce sera avec plaisir!", german=" Natürlich dürft ihr!", italian=" Certo che potete!", spanish=" ¡Por supuesto que sí!"})
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5127) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wa-hah! Yes! Thank you!", french=" Super! Merci beaucoup!", german=" Ha-ha! Jaaa! Danke schön!", italian=" Wow! Sì! Grazie!", spanish=" ¡Fantástico! ¡Gracias!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yay! Yes! Thank you!", french=" Super! Merci beaucoup!", german=" Juchhu! Ja! Danke schön!", italian=" Sì! Grande! Grazie!", spanish=" ¡Fantástico! ¡Gracias!"})
  else
  SkySceneKit.say({english=" Yay! Yes! Thank you!", french=" Super! Merci beaucoup!", german=" Juchhu! Ja! Danke schön!", italian=" Sì! Grande! Grazie!", spanish=" ¡Fantástico! ¡Gracias!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="OK, sweeties. We'll go ahead and\nopen the entrance. You can go in after we do.", french="D'accord, mes mignons. Nous\npartons devant ouvrir la porte.\nVous pourrez entrer après nous.", german="Okay, ihr Süßen. Wir gehen vor\nund öffnen die Tür. Ihr könnt dann nach uns\nhineingehen.", italian="Ok, tesorini. Noi andremo avanti\nper aprire la porta. Voi potrete entrare dopo\ndi noi.", spanish="Muy bien, encantos. Nosotras\nnos adelantaremos y abriremos la entrada.\nPodréis acceder después de nosotras."})
  pcall(function() UI:SetSpeaker(npc_npc_mimiroppu) end)
  SkySceneKit.say({english="The cave is located southeast\nof here.", french=" La grotte est au sud-est d'ici.", german="Die Höhle liegt südöstlich von\nhier.", italian="La caverna si trova a sud-est\ndi qui.", spanish="La cueva se encuentra al\nsureste."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_chaaremu, 324, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_mimiroppu, 324, 124, false, 2)
  GROUND:MoveToPosition(npc_npc_saanaito, 324, 244, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_saanaito, 324, 124, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_FacePositionOffset(1, 5) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, [hero]!", french="Ça va être magnifique,\n[hero]!", german=" Alles klar, [hero]!", italian=" Fantastico, [hero]!", spanish=" ¡Muy bien, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is great, [hero]!", french="Ça va être magnifique,\n[hero]!", german=" Klasse, [hero]!", italian=" Fantastico, [hero]!", spanish=" ¡Estupendo, [hero]!"})
  else
  SkySceneKit.say({english="This will be great,\n[hero]!", french="Ça va être magnifique,\n[hero]!", german="Das wird klasse,\n[hero]!", italian=" Fantastico, [hero]!", spanish=" ¡Estupendo, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get ready now! We should\nleave right away!", french="Préparons-nous pour partir\nle plus vite possible!", german="Machen wir uns jetzt bereit!\nWir sollten baldmöglichst losziehen.", italian="Prepariamoci! Dovremmo\npartire subito!", spanish="¡Y ahora a prepararse! ¡Habrá\nque marcharse enseguida!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get ready in a hurry so we\ncan join in the exploration!", french="Préparons-nous pour partir\nle plus vite possible!", german="Machen wir uns schnell fertig,\ndamit wir an der Erkundung teilnehmen können!", italian="Prepariamoci! Dovremmo\npartire subito!", spanish="¡Y ahora a prepararse! ¡Habrá\nque marcharse enseguida!"})
  else
  SkySceneKit.say({english="Let's get ready right away!\nWe should be exploring with them!", french="Préparons-nous pour partir\nle plus vite possible!", german="Machen wir uns sofort fertig!\nWir sollten mit ihnen auf Erkundung gehen!", italian="Prepariamoci! Dovremmo\npartire subito!", spanish="¡Y ahora a prepararse! ¡Habrá\nque marcharse enseguida!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(55) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(55) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(55) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN][CS:P]Aegis Cave[CR]!", french="[CN]Désormais, vous avez accès\n[CN]à la [CS:P]Grotte Egide[CR]!", german="[CN]Du kannst jetzt zur\n[CN][CS:P]Ägishöhle[CR] gehen!", italian="[CN]Adesso potete andare alla\n[CN][CS:P]Grotta Egida[CR]!", spanish="[CN]¡Ya puedes ir a la [CS:P]Cueva Regia[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[54] = 1 -- dungeon_mode(54) = DMODE_OPEN (ROM)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GROUND:TeleportTo(npc_npc_guregguru, 228, 220, Direction.Down)
  GROUND:TeleportTo(hero, 340, 204, Direction.Down)
  GROUND:TeleportTo(partner, 308, 204, Direction.Down)
  GROUND:TeleportTo(npc_npc_dogoomu, 228, 284, Direction.Down)
  GROUND:TeleportTo(npc_npc_diguda, 204, 284, Direction.Down)
  GROUND:TeleportTo(npc_npc_pukurin, 452, 196, Direction.Down)
  GROUND:TeleportTo(npc_npc_kimawari, 356, 284, Direction.Down)
  GROUND:TeleportTo(npc_npc_heigani, 332, 300, Direction.Down)
  GROUND:TeleportTo(npc_npc_bippa, 332, 276, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 452, 220, Direction.Down)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_diguda, Direction.Right)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:FadeIn(30)
  else -- default/annulation
  -- @label_1 [étiquette de flux ExplorerScript]
  -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 5) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Huh? Why?[K] It's a chance at\nfinding awesome treasure!", french="Hein? Pourquoi pas?[K] C'est\nl'occasion de trouver des trésors fabuleux!", german="Aber warum?[K] Es ist eine\nRiesenchance, tolle Schätze zu finden!", italian="Eh? Perché?[K] È un'occasione\nper trovare un tesoro eccezionale!", spanish="¿Qué? ¿Por qué?[K] ¡Es una gran\noportunidad para encontrar un tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What? Why?[K] It's a new dungeon\nwhere we might find some amazing treasure!", french="Hein? Pourquoi pas?[K] C'est\nl'occasion de trouver des trésors fabuleux!", german="Was? Warum?[K] Es ist ein neuer\nDungeon, in dem wir fantastische Schätze\nfinden könnten!", italian="Eh? Perché?[K] È un'occasione\nper trovare un tesoro eccezionale!", spanish="¿Qué? ¿Por qué?[K] ¡Es una gran\noportunidad para encontrar un tesoro!"})
  else
  SkySceneKit.say({english="What? Why?[K] We may be able\nto discover incredible treasure!", french="Hein? Pourquoi pas?[K] C'est\nl'occasion de trouver des trésors fabuleux!", german="Was? Warum?[K] Wir könnten\ndort auf fantastische Schätze stoßen!", italian="Eh? Perché?[K] È un'occasione\nper trovare un tesoro eccezionale!", spanish="¿Qué? ¿Por qué?[K] ¡Es una gran\noportunidad para encontrar un tesoro!"})
  end
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Don't be that way! Let's go\nexploring with them!", french="Allez, sois sympa! On part\nen exploration avec elles, d'accord?", german="Sei mal nicht so! Lass uns mit\nihnen auf Erkundung gehen!", italian="Non fare così! Andiamo a\nesplorare con loro!", spanish="¡No seas así! ¡Vayamos con\nellas a explorar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Don't be so negative! Let's go\nexploring with them!", french="Allez, sois sympa! On part\nen exploration avec elles, d'accord?", german="Sei nicht so negativ! Lass uns\nmit ihnen auf Erkundung gehen!", italian="Non fare così! Andiamo a\nesplorare con loro!", spanish="¡No seas así! ¡Vayamos con\nellas a explorar!"})
  else
  SkySceneKit.say({english="Oh, don't be that way! Let's go\nexploring with them!", french="Allez, sois sympa! On part\nen exploration avec elles, d'accord?", german="Sei mal nicht so! Lass uns mit\nihnen auf Erkundung gehen!", italian="Non fare così! Andiamo a\nesplorare con loro!", spanish="¡No seas así! ¡Vayamos con\nellas a explorar!"})
  end
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- continue [contrôle de boucle forever NDS: une itération compilée]
  -- may be redundant
  else -- default/annulation
  -- break_loop [contrôle de boucle forever NDS: une itération compilée]
  end
  end
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
