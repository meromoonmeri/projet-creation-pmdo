-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m06a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  SkyProg.set(7, 1) -- $SCENARIO_MAIN = scn[7,1] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM06') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem! As I was explaining...\nthere is a lake far to the east.", french="Hum, hum! Comme je\nl'expliquais... il y a un lac loin à l'est.", german="Ähem! Wie ich schon erwähnte,\ngibt es weit im Osten einen See.", italian="Ahem! Come stavo dicendo...\nC'è un lago lontano da qui, a est.", spanish="¡Ejem! Como iba diciendo,\nhay un lago muy hacia el este."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="There are many aspects of that\nlake that remain mysterious.", french="Nombreux sont les mystères qui\nentourent ce lac encore aujourd'hui.", german="Um diesen See gibt es viele\nungelöste Rätsel.", italian="Quel lago ha ancora molti\naspetti che ci rimangono ignoti.", spanish="Y muchas cosas de ese lago\nsiguen siendo un misterio."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We hope to unravel those\nmysteries.", french="Nous espérons tirer au clair\nces mystères de l'Est.", german="Wir hoffen, dass wir diese\nRätsel lösen können.", italian="La nostra speranza è riuscire\na svelare questi misteri.", spanish="Pero nosotros planeamos\ndesvelar todos sus enigmas."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And so, our guild is planning to\nmount an expedition for the first time in\na while. ♪", french="Dans ce but, notre Guilde\nprépare donc une expédition, pour la\npremière fois depuis longtemps. ♪", german="Daher plant unsere Gilde zum\nersten Mal seit längerer Zeit wieder eine\nExpedition. ♪", italian="Quindi, la Gilda sta pianificando\nuna spedizione, per la prima volta da un po'\ndi tempo. ♪", spanish="Por eso, el [CS:N]Pokégremio[CR] planea\norganizar una expedición allí, la primera\nen bastante tiempo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="An expedition, you say? Yes,\nplease! Yes sirree!", french="Une expédition, qu'tu dis?\nSapristi! Ouaip ouaip! Génial!", german="Eine Expedition, sagst du? Ja,\nbitte! Au ja!", italian="Una spedizione? Sì,\nche bello! Sissignore!", spanish="¿Una expedición?\n¡Huy! ¡Sí, sí, por favor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="It's been a long time since we\nwent on an expedition!", french="Trop cool! Ça fait trop\nlongtemps qu'il n'y en a pas eu!", german="Unsere letzte Expedition ist\nschon lange her!", italian="È passato un sacco di tempo\ndall'ultima volta che abbiamo partecipato\na una spedizione!", spanish="¡Hace mucho tiempo que no\nsalimos de expedición!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="But... That means you're going to\nbe picking members for the expedition from\nALL of us again, right?", french="Alors... ça veut dire que vous\nallez choisir les membres de l'expédition\nparmi NOUS TOUS, exact?", german="Aber... Das heißt, ihr werdet\nwieder aus ALLEN von uns die Mitglieder für\ndie Expedition auswählen, oder?", italian="Ma... questo significa che\nsceglierete i membri della spedizione tra\nTUTTI noi, giusto?", spanish="Pero... Eso quiere decir que,\ncomo la otra vez, vais a seleccionar solo\na algunos de nosotros, ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Precisely! ♪", french=" Précisément! ♪", german=" Haargenau! ♪", italian=" Esatto! ♪", spanish=" ¡Precisamente! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We will depart in several days.", french="Nous partirons dans quelques\njours.", german="Wir werden in einigen Tagen\naufbrechen.", italian=" Partiremo tra qualche giorno.", spanish=" Saldremos en unos días."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Over these next few days, we\nwill choose the most worthy apprentices.", french="D'ici là, nous allons choisir\nles apprentis les plus méritants.", german="In den nächsten paar Tagen\nwerden wir die besten Lehrlinge auswählen.", italian="Nei prossimi giorni sceglieremo\ngli apprendisti più meritevoli.", spanish="En los próximos días elegiremos\na los aprendices más capaces."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The chosen members will form\nthe expedition party.", french="Les membres choisis feront\npartie de l'équipe pour l'expédition.", german="Die ausgewählten Mitglieder\nwerden das Expeditionsteam bilden.", italian="I membri che sceglieremo\nformeranno la squadra che prenderà\nparte alla spedizione.", spanish="Los miembros seleccionados\nformarán el grupo de la expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone, work hard so that you\nmay be chosen for the expedition!", french="Travaillez tous très dur\npour avoir une chance d'être retenus\npour l'expédition!", german="Gebt euch Mühe, dann werdet ihr\nvielleicht für die Expedition ausgewählt!", italian="Dovete mettercela tutta\nper essere scelti!", spanish="¡Trabajad todo lo que podáis\nsi queréis ser seleccionados!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! This is so exciting!", french="Ben mince alors! J'hallucine!\nJe suis trop impatiente, moi!", german=" Auweia! Oh, ist das aufregend!", italian=" Shock! È così emozionante!", spanish=" ¡Cómo mola! ¡Qué emocionante!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! I've yet to go on an\nexpedition. I would surely love to go this time!", french="Ouaip ouaip! Faut vraiment\nqu'j'parte en expédition c'te fois. J'serais\nhyper content, pour sûr!", german="Jawollja! Ich war noch auf\nkeiner Expedition. Ich würde diesmal wirklich\ngerne mitgehen!", italian="Ohibò! Non ho mai partecipato\na una spedizione. Mi piacerebbe moltissimo\nfarlo questa volta!", spanish="Todavía no he ido a ninguna\nexpedición. ¡Me encantaría hacerlo esta\nvez! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Let's work at it and get picked\nas members!", french=" Travaillons pour être choisis!", german="Versuchen wir unser Bestes,\ndamit wir ausgewählt werden!", italian="Diamoci da fare perché ci\nscelgano!", spanish="¡Vamos a esforzarnos para\nque nos escojan!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone. ♪ It's back\nto work as usual. ♪", french="Allez, tout le monde. ♪\nVaquez à vos occupations habituelles. ♪", german="In Ordnung, Pokémon. ♪ Nun\ngeht eurer gewohnten Arbeit nach. ♪", italian="Va bene, gente. ♪ Tornate al\nlavoro. ♪", spanish="Muy bien. ♪ Es hora\nde trabajar. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  -- SetAnimation(24) [anim idle native]
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
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
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 336, 232, Direction.Right, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 324, 132, false, 2)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 312, 224, Direction.DownRight, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 324, 132, false, 2)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 312, 248, Direction.Right, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 324, 132, false, 2)
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
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two.", french=" Hé, vous deux.", german=" Ah, ihr beide.", italian=" Ah, voi due.", spanish=" Ah, aquí estáis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Today, I want you two to check\nthe Job Bulletin Board and the Outlaw Notice\nBoard and handle their listed jobs.", french="Aujourd'hui, consultez le Tableau\ndes Missions et les Avis de Recherche et\nchargez-vous des missions affichées.", german="Heute möchte ich, dass ihr die\nJob- und Ganoven-Infobretter lest und die\naufgeführten Jobs erledigt.", italian="Oggi, voglio che controlliate la\nBacheca delle missioni e quella dei ricercati e\nche vi occupiate delle missioni elencate.", spanish="Hoy quiero que os concentréis\nen las misiones del Tablón de Anuncios y\nel Tablón \"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That will do for now. ♪", french=" Ce sera tout pour l'instant. ♪", german=" Das reicht fürs Erste. ♪", italian=" È tutto, per ora. ♪", spanish=" Eso es todo por ahora. ♪"})
  -- message_Close
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  SkySceneKit.cleanup_npcs()
end
