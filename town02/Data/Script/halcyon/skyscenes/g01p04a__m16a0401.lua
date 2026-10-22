-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m16a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  SkyProg.set(17, 3) -- $SCENARIO_MAIN = scn[17,3] (ROM)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM16') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem...[K]so here's where it stands.", french="Hum...[K] voilà donc l'état actuel\ndes choses.", german="Ähem...[K] So ist der Stand der\nDinge.", italian="Ahem...[K] Ecco il punto della\nsituazione.", spanish="Ejem...[K] Entonces la situación\nes la siguiente."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We have not yet received word\nof [CS:N]Grovyle[CR]'s capture.", french="A ce jour, rien n'indique que\n[CS:N]Massko[CR] ait été capturé.", german="Wir haben noch nicht gehört, ob\n[CS:N]Reptain[CR] schon gefasst wurde.", italian="Non abbiamo ancora ricevuto\nnotizia della cattura di [CS:N]Grovyle[CR].", spanish="Aún no tenemos noticias sobre\nla captura de [CS:N]Grovyle[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Are [CS:N]Mesprit[CR] and his\nfriends all right?", french="Eh dis donc, comment vont\n[CS:N]Créfollet[CR] et ses amis?", german="Hey, hey! Geht es [CS:N]Vesprit[CR] und\nseinen Freunden gut?", italian="Ehi, ehi! Ma [CS:N]Mesprit[CR] e gli altri\nstanno bene?", spanish="¡Oye, oye! ¿Están bien [CS:N]Mesprit[CR] y\nsus amigos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" We don't know that either.", french="Ça non plus, nous n'en avons\naucune idée.", german=" Das wissen wir auch nicht.", italian=" Non sappiamo nemmeno questo.", spanish=" Tampoco lo sabemos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We've received no information\nat all. We're in the dark.", french="Nous n'avons reçu aucune\nnouvelle. Nous sommes dans l'expectative.", german="Wir haben überhaupt keine\nInformationen bekommen. Wir tappen im\nDunkeln.", italian="Non abbiamo alcuna notizia,\nsiamo all'oscuro di tutto.", spanish="No tenemos ninguna información.\nNo sabemos nada de nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That said, we can't go off on\nour own and spoil the trap.", french="Cela dit, nous ne pouvons pas\nnous permettre de prendre des initiatives\nau risque de compromettre le plan.", german="Trotzdem können wir nicht\nauf eigene Faust losziehen und die Falle\ngefährden.", italian="Nonostante questo, non possiamo\nintervenire e rischiare di mandare tutto a\nmonte.", spanish="Sin embargo, no podemos ir a\nver qué pasa y estropear la trampa."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We will have to stand down\nuntil we receive word of some sort.", french="Contentons-nous de faire profil\nbas jusqu'à nouvel ordre.", german="Wir werden abwarten müssen,\nbis wir irgendetwas hören.", italian="Dovremo tenerci alla larga\nfinché non avremo ricevuto nuove istruzioni.", spanish="Tendremos que quedarnos donde\nestamos hasta que sepamos algo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Until then, we should carry on\nwith our usual work.", french="En attendant, attelons-nous\nà nos tâches habituelles.", german="Bis dahin sollten wir unserer\ngewohnten Arbeit nachgehen.", italian="Fino ad allora, dovremo\ncontinuare come sempre.", spanish="Hasta entonces, debemos seguir\ncon nuestro trabajo de cada día."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So, everyone! Let's get back to\nwork today! ♪", french=" Au travail, tout le monde! ♪", german="Also, Pokémon! Machen wir uns\nan die Arbeit! ♪", italian=" Pertanto, si torna al lavoro!", spanish="Bueno, pues entonces...\n¡Volvamos todos al trabajo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ah, you two!", french=" Ah, vous deux!", german=" Ah, ihr zwei!", italian=" Ah, voi due!", spanish=" ¡Ah, aquí estáis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Today, take jobs from the Job\nBulletin Board and the Outlaw Notice Board.", french="Aujourd'hui, occupez-vous\ndes missions du Tableau des Missions et\ndes Avis de Recherche.", german="Erledigt heute die Jobs an\nden Job- und Ganoven-Infobrettern.", italian="Oggi dovreste tornare a dare\nun'occhiata alla Bacheca delle missioni e a\nquella dei ricercati.", spanish="Hoy os toca realizar misiones del\nTablón de Anuncios y el Tablón \"Se Busca\"."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That will do! ♪", french=" Ce sera tout! ♪", german=" Das müsste reichen! ♪", italian=" Fate del vostro meglio.", spanish=" Eso será suficiente. ♪"})
  -- message_Close
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
