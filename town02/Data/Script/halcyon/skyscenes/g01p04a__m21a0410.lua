-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m21a0410.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(22, 2) -- $SCENARIO_MAIN = scn[22,2] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM21') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem![K] So wrapping up...", french=" Hum![K] Alors, pour conclure...", german="Ähem![K] Noch einmal eine kurze\nZusammenfassung...", italian=" Ehm![K] Allora, riepilogando...", spanish="¡Ejem![K] Antes de acabar\nla reunión de hoy..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone's aware of their\nduties today?", french="Vous savez tous ce que\nvous avez à faire aujourd'hui?", german="Ist sich jeder über seine\nAufgabe heute im Klaren?", italian="Sapete tutti quali sono i vostri\ncompiti per oggi?", spanish="Todos sabéis bien lo que\ndebéis hacer hoy, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By golly, yes!", french=" Pour sûr, oui!", german=" Donnerwetter, ja!", italian=" Ohibò, sì!", spanish=" ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" I'm all ready to go!", french="Toujours prête! Ben mince\nalors!", german=" Ich bin so was von bereit!", italian=" Sono pronta a partire!", spanish=" ¡Estoy lista!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Good!", french=" Bien!", german=" Gut!", italian=" Bene!", spanish=" ¡Estupendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Those of you investigating the\n[CS:P]Hidden Land[CR]...", french="Ceux d'entre vous qui enquêtent\nsur les [CS:P]Terres Illusoires[CR]...", german="Die Leute, die nach dem\n[CS:P]Verborgenen Land[CR] forschen...", italian="Quelli che indagano sulla [CS:P]Terra[CR]\n[CS:P]Nascosta[CR]...", spanish="Tanto aquellos que busquéis\nla [CS:P]Tierra Oculta[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And those of you spreading the\nword about the true state of affairs...", french="Et ceux qui sont chargés\nd'annoncer la vérité aux habitants...", german="Und diejenigen, die das Wort\nzum wahren Stand der Dinge verbreiten...", italian="E quelli incaricati di diffondere\nla voce su come stanno veramente le cose...", spanish="Como los que os encarguéis de\ndifundir lo que ocurre entre los demás..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I expect you to organize your\nteams accordingly and get going!", french="Je compte sur vous pour\norganiser vos équipes comme il se doit\net pour vous mettre au travail!", german="Ich erwarte von euch, dass ihr\neure Teams der Aufgabe entsprechend\norganisiert und loslegt!", italian="Mi aspetto che organizziate\nle squadre di conseguenza e che vi mettiate\nin movimento!", spanish="¡Espero que os organicéis\nen equipos y que salgáis ahora mismo!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let's get right to it, everyone!", french=" Au travail, tout le monde!", german=" Packen wir es gleich an, Leute!", italian=" Impegnatevi al massimo, gente!", spanish=" ¡Pongamos manos a la obra!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
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
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:MoveToPosition(npc_npc_pukurin, 420, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We must go to the Hot Spring\nand get information from wise old [CS:N]Torkoal[CR].", french="On doit aller demander des\nrenseignements au vénérable [CS:N]Chartor[CR].", german="Wir müssen zur Heißen Quelle\ngehen und den weisen alten [CS:N]Qurtel[CR] nach\nInformationen fragen.", italian="Dobbiamo andare alla Sorgente\nTermale e recuperare informazioni dal vecchio\n[CS:N]Torkoal[CR].", spanish="Debemos ir a la Terma a ver\nqué puede contarnos el sabio [CS:N]Torkoal[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We must go to the Hot Spring\nand get information from wise old [CS:N]Torkoal[CR].", french="On doit aller demander des\nrenseignements au vénérable [CS:N]Chartor[CR].", german="Wir müssen zur Heißen Quelle\ngehen und den weisen alten [CS:N]Qurtel[CR] nach\nInformationen fragen.", italian="Dobbiamo andare alla Sorgente\nTermale e recuperare informazioni dal vecchio\n[CS:N]Torkoal[CR].", spanish="Debemos ir a la Terma a ver\nqué puede contarnos el sabio [CS:N]Torkoal[CR]."})
  else
  SkySceneKit.say({english="We must go to the Hot Spring\nand get information from wise old [CS:N]Torkoal[CR].", french="On doit aller demander des\nrenseignements au vénérable [CS:N]Chartor[CR].", german="Wir müssen zur Heißen Quelle\ngehen und den weisen alten [CS:N]Qurtel[CR] nach\nInformationen fragen.", italian="Dobbiamo andare alla Sorgente\nTermale e recuperare informazioni dal vecchio\n[CS:N]Torkoal[CR].", spanish="Debemos ir a la Terma a ver\nqué puede contarnos el sabio [CS:N]Torkoal[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think we had to go through\n[CS:P]Waterfall Cave[CR] to get to the Hot Spring.", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR].", german="Wir sind beim ersten Mal durch\ndie [CS:P]Wasserfallhöhle[CR] zur Heißen Quelle gelangt.", italian="Penso che per arrivare alla\nSorgente Termale si debba passare attraverso\nla [CS:P]Grotta della Cascata[CR].", spanish="Creo que teníamos que cruzar\nla [CS:P]Cueva Cascada[CR] para llegar a la Terma."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I think we had to go through\n[CS:P]Waterfall Cave[CR] to get to the Hot Spring.", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR].", german="Wir sind beim ersten Mal durch\ndie [CS:P]Wasserfallhöhle[CR] zur Heißen Quelle gelangt.", italian="Penso che per arrivare alla\nSorgente Termale si debba passare attraverso\nla [CS:P]Grotta della Cascata[CR].", spanish="Creo que teníamos que cruzar\nla [CS:P]Cueva Cascada[CR] para llegar a la Terma."})
  else
  SkySceneKit.say({english="I think we had to go through\n[CS:P]Waterfall Cave[CR] to get to the Hot Spring.", french="La dernière fois, je crois\nqu'on a rejoint la Source Chaude en passant\npar la [CS:P]Grotte Cascade[CR].", german="Wir sind beim ersten Mal durch\ndie [CS:P]Wasserfallhöhle[CR] zur Heißen Quelle gelangt.", italian="Penso che per arrivare alla\nSorgente Termale si debba passare attraverso\nla [CS:P]Grotta della Cascata[CR].", spanish="Creo que teníamos que cruzar\nla [CS:P]Cueva Cascada[CR] para llegar a la Terma."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So let's make our way toward\nthe Hot Spring!", french="Allez, en route pour la Source\nChaude!", german="Machen wir uns auf den Weg\nzur Heißen Quelle!", italian="Dobbiamo dirigerci verso la\nSorgente Termale!", spanish="¡Así que abrámonos paso hasta\nella!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So let's make our way toward\nthe Hot Spring!", french="Allez, en route pour la Source\nChaude!", german="Machen wir uns auf den Weg\nzur Heißen Quelle!", italian="Dobbiamo dirigerci verso la\nSorgente Termale!", spanish="¡Así que abrámonos paso hasta\nella!"})
  else
  SkySceneKit.say({english="So let's make our way toward\nthe Hot Spring!", french="Allez, en route pour la Source\nChaude!", german="Machen wir uns auf den Weg\nzur Heißen Quelle!", italian="Dobbiamo dirigerci verso la\nSorgente Termale!", spanish="¡Así que abrámonos paso hasta\nella!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
