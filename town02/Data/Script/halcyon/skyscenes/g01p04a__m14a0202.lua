-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m14a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_G01P04A, 'UM14') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 216, Direction.Left, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 384, 224, Direction.DownRight, "NPC_YONOWAARU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I'm sorry.", french=" Toutes mes excuses.", german=" Es tut mir leid.", italian=" Sono davvero spiacente.", spanish=" Lo siento."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="We are considering the possible\nplaces where Time Gears may be hidden.", french="Nous réfléchissons à la cachette\npotentielle des Rouages du Temps.", german="Wir ziehen die möglichen\nVerstecke der Zahnräder der Zeit in Betracht.", italian="Stiamo prendendo in\nconsiderazione tutti i luoghi dove potrebbero\ntrovarsi degli Ingranaggi del Tempo.", spanish="Estamos considerando todos\nlos lugares posibles en los que podrían\nestar los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But we haven't been able to\nnarrow our choices to any sites that appear\ntruly promising.", french="Mais nous avons été incapables\nd'arrêter notre choix sur des endroits\nvraiment prometteurs.", german="Aber wir konnten uns bisher\nauf keinen wirklich vielversprechenden\nStandort festlegen.", italian="Purtroppo però, finora non\nsiamo riusciti a concludere nulla.", spanish="Pero no hemos podido encontrar\nningún sitio que sea realmente prometedor."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_perappu, 456, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sorry, but that's where we are\nat now.", french="Navré, mais nous ne sommes\npas plus avancés pour l'instant.", german="Es tut mir leid, aber so stehen\ndie Dinge.", italian=" Mi dispiace, per ora è tutto.", spanish="Por desgracia, esa es la situación\nactual."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We ask you to search for the\nTime Gears on your own initiative.", french="Continuez les recherches\nde votre côté, s'il vous plaît.", german="Wir bitten euch, auf eigene\nFaust nach den Zahnrädern der Zeit zu suchen.", italian="Vi preghiamo di continuare le\nricerche per conto vostro.", spanish="Tenemos que pediros que sigáis\nbuscando los Engranajes del Tiempo donde\nconsideréis oportuno."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I sincerely apologize.", french="Veuillez agréer mes excuses\nles plus sincères.", german="Ich bitte aufrichtig um\nEntschuldigung.", italian=" Chiedo ancora perdono.", spanish=" Mis más sinceras disculpas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone! Do your\nbest, as always! ♪", french="Très bien, tout le monde! Faites\nde votre mieux, comme à l'accoutumée! ♪", german="In Ordnung, Pokémon! Gebt euer\nBestes, wie immer! ♪", italian="Coraggio, gente! Date del vostro\nmeglio, come sempre!", spanish="¡Muy bien! Ahora, ¡esforcémonos\ntanto como siempre! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  -- SetAnimation(23) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 456, 272, Direction.Up, "NPC_DIGUDA")
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: SÌÌÌÌÌÌÌ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
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
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 432, 240, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 224, 252, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 240, 272, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.UpRight)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_heigani, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 132, false, 2)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  if (SkyProg.cmp(15, 1) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [15, 1]
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should go back to\n[CS:P]Quicksand Cave[CR], [hero].", french="On devrait retourner à la [CS:P]Grotte\nSables Mouvants[CR], [hero].", german="Wir sollten uns wieder auf den\nWeg zur [CS:P]Treibsandhöhle[CR] machen, [hero].", italian="Dovremmo tornare alla [CS:P]Grotta[CR]\n[CS:P]delle Sabbie Mobili[CR], non credi, [hero]?", spanish="[hero], deberíamos volver\na la [CS:P]Cueva Arenas[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go back to\n[CS:P]Quicksand Cave[CR], [hero].", french="On devrait retourner à la [CS:P]Grotte\nSables Mouvants[CR], [hero].", german="Wir sollten zurück zur\n[CS:P]Treibsandhöhle[CR] gehen, [hero].", italian="Torniamo alla [CS:P]Grotta delle Sabbie[CR]\n[CS:P]Mobili[CR], [hero].", spanish="Deberíamos volver\na la [CS:P]Cueva Arenas[CR], [hero]."})
  else
  SkySceneKit.say({english="Let's go back to [CS:P]Quicksand Cave[CR],\n[hero].", french="On devrait retourner à la [CS:P]Grotte\nSables Mouvants[CR], [hero].", german="Wir sollten zurück zur\n[CS:P]Treibsandhöhle[CR] gehen, [hero].", italian="Torniamo alla [CS:P]Grotta delle Sabbie[CR]\n[CS:P]Mobili[CR], [hero].", spanish="Deberíamos volver\na la [CS:P]Cueva Arenas[CR], [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's search [CS:P]Quicksand Cave[CR]\ncarefully.", french="Passons la [CS:P]Grotte Sables\nMouvants[CR] au peigne fin.", german="Lass uns die [CS:P]Treibsandhöhle[CR]\ngründlich durchsuchen.", italian="Dobbiamo setacciare la [CS:P]Grotta[CR]\n[CS:P]delle Sabbie Mobili[CR].", spanish="Busquemos en la [CS:P]Cueva Arenas[CR]\nminuciosamente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's search [CS:P]Quicksand Cave[CR]\nthoroughly.", french="Passons la [CS:P]Grotte Sables\nMouvants[CR] au peigne fin.", german="Lass uns die [CS:P]Treibsandhöhle[CR]\ngründlich durchsuchen.", italian="Esploriamo la [CS:P]Grotta[CR]\n[CS:P]delle Sabbie Mobili[CR] da cima a fondo.", spanish="Busquemos en la [CS:P]Cueva Arenas[CR]\nminuciosamente."})
  else
  SkySceneKit.say({english="We should search [CS:P]Quicksand\nCave[CR] carefully.", french="Passons la [CS:P]Grotte Sables\nMouvants[CR] au peigne fin.", german="Wir sollten die [CS:P]Treibsandhöhle[CR]\ngründlich durchsuchen.", italian="Esploriamo la [CS:P]Grotta[CR]\n[CS:P]delle Sabbie Mobili[CR] da cima a fondo.", spanish="Busquemos en la [CS:P]Cueva Arenas[CR]\nminuciosamente."})
  end
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- @label_1 [étiquette de flux ExplorerScript]
  else
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We should head back to\n[CS:P]Quicksand Desert[CR], [hero].", french="On devrait retourner au [CS:P]Désert\nSables Mouvants[CR], [hero].", german="Wir sollten uns wieder auf den\nWeg zur [CS:P]Mahlsandwüste[CR] machen, [hero].", italian="Allora, [hero], si torna al\n[CS:P]Deserto delle Sabbie Mobili[CR]?", spanish="[hero], deberíamos volver\na las [CS:P]Arenas Movedizas[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go back to\n[CS:P]Quicksand Desert[CR], [hero].", french="On devrait retourner au [CS:P]Désert\nSables Mouvants[CR], [hero].", german="Wir sollten zurück zur\n[CS:P]Mahlsandwüste[CR] gehen, [hero].", italian="Torniamo al [CS:P]Deserto delle Sabbie[CR]\n[CS:P]Mobili[CR], [hero].", spanish="[hero], deberíamos volver\na las [CS:P]Arenas Movedizas[CR]."})
  else
  SkySceneKit.say({english="We should return to\n[CS:P]Quicksand Desert[CR], [hero].", french="On devrait retourner au [CS:P]Désert\nSables Mouvants[CR], [hero].", german="Wir sollten zurück zur\n[CS:P]Mahlsandwüste[CR] gehen, [hero].", italian="Torniamo al [CS:P]Deserto delle Sabbie[CR]\n[CS:P]Mobili[CR], [hero].", spanish="[hero], deberíamos volver\na las [CS:P]Arenas Movedizas[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's search [CS:P]Quicksand Desert[CR]\ncarefully.", french="Passons le [CS:P]Désert Sables\nMouvants[CR] au peigne fin.", german="Lass uns die [CS:P]Mahlsandwüste[CR]\ngründlich durchsuchen.", italian="Dobbiamo setacciare il [CS:P]Deserto[CR]\n[CS:P]delle Sabbie Mobili[CR].", spanish="Vamos a escudriñar cada rincón\nde las [CS:P]Arenas Movedizas[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's search [CS:P]Quicksand Desert[CR]\nthoroughly.", french="Passons le [CS:P]Désert Sables\nMouvants[CR] au peigne fin.", german="Lass uns die [CS:P]Mahlsandwüste[CR]\ngründlich durchsuchen.", italian="Mi raccomando, questa volta\ndobbiamo ispezionarlo per bene il [CS:P]Deserto delle[CR]\n[CS:P]Sabbie Mobili[CR]. Andiamo su!", spanish="Vamos a escudriñar cada rincón\nde las [CS:P]Arenas Movedizas[CR]."})
  else
  SkySceneKit.say({english="We should search [CS:P]Quicksand\nDesert[CR] carefully.", french="Passons le [CS:P]Désert Sables\nMouvants[CR] au peigne fin.", german="Wir sollten die [CS:P]Mahlsandwüste[CR]\ngründlich durchsuchen.", italian="Mi raccomando, questa volta\ndobbiamo ispezionarlo per bene il [CS:P]Deserto delle[CR]\n[CS:P]Sabbie Mobili[CR]. Andiamo su!", spanish="Vamos a escudriñar cada rincón\nde las [CS:P]Arenas Movedizas[CR]."})
  end
  -- message_Close
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
