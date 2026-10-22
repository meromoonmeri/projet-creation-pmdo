-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 160, 792, Direction.Up, "NPC_HEIGANI")
  GROUND:MoveToPosition(npc_npc_heigani, 156, 604, false, 2)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 200, 808, Direction.Up, "NPC_KIMAWARI")
  GROUND:MoveToPosition(npc_npc_kimawari, 200, 612, false, 2)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 120, 816, Direction.Up, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 120, 612, false, 2)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 160, 864, Direction.Up, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 160, 664, false, 2)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 144, 840, Direction.Up, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 136, 640, false, 2)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 104, 848, Direction.Up, "NPC_DOGOOMU")
  GROUND:MoveToPosition(npc_npc_dogoomu, 100, 636, false, 2)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 184, 832, Direction.Up, "NPC_GUREGGURU")
  GROUND:MoveToPosition(npc_npc_guregguru, 184, 636, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 192, 856, Direction.Up, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 200, 660, false, 2)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 120, 864, Direction.Up, "NPC_DIGUDA")
  GROUND:MoveToPosition(npc_npc_diguda, 120, 660, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- se_FadeOut(6916, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Whew! Here we are at last!", french=" Ouf! Nous y voilà enfin!", german=" Puh! Endlich sind wir da!", italian=" Fiuu! Eccoci qui finalmente!", spanish=" ¡Uf! ¡Por fin llegamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="No time to catch our breath.[K]\nWe've got to hurry!", french="Pas le temps de se reposer.[K]\nDépêchons!", german="Keine Zeit zum Verschnaufen.[K]\nWir müssen uns beeilen!", italian="Non c'è tempo da perdere.[K]\nDobbiamo sbrigarci!", spanish="No hay tiempo para descansar.[K]\n¡Hay que darse prisa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey![K] Someone's over there!", french="Eh dis donc![K] Il y a quelqu'un\nlà-bas!", german=" Hey, hey![K] Da drüben ist jemand!", italian=" Ehi, ehi![K] C'è qualcuno laggiù!", spanish=" ¡Oye, oye![K] ¡Hay alguien allí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let's go!", french=" Allons-y!", german=" Gehen wir!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6916) — id SE NDS sans portage PMDO identifié
  pcall(function() GAME:MoveCamera(156, 464, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_heigani, 156, 420, false, 2)
  GROUND:MoveToPosition(npc_npc_kimawari, 200, 428, false, 2)
  GROUND:MoveToPosition(npc_npc_perappu, 120, 428, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 160, 464, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 136, 448, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 100, 452, false, 2)
  GROUND:MoveToPosition(npc_npc_guregguru, 184, 444, false, 2)
  GROUND:MoveToPosition(npc_npc_dagutorio, 200, 460, false, 2)
  GROUND:MoveToPosition(npc_npc_diguda, 120, 460, false, 2)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_kimawari, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_chiriin, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(6931) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(4), 3, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_chiriin.Position; GROUND:MoveToPosition(npc_npc_chiriin, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(5)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_dagutorio.Position; GROUND:MoveToPosition(npc_npc_dagutorio, p.X+(0), p.Y+(16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Squ-squ-squawk?!", french=" C-c-couac?!", german=" K-k-kreisch?!?", italian=" Squ-Squ-Squack?!", spanish=" Cru... ¡¿Cruac?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" [CS:N]Gr[CR]-[CS:N]Gr[CR]-[CS:N]Gr[CR]-", french=" [CS:N]Gr[CR]-[CS:N]Gr[CR]-[CS:N]Gr[CR]...", german=" [CS:N]Gr[CR]-[CS:N]Gr[CR]-[CS:N]Gr[CR]-", italian=" [CS:N]Gr[CR]... [CS:N]Gr[CR]... [CS:N]Gr[CR]...", spanish=" Es [CS:N]Grou[CR]... [CS:N]Gro[CR]... [CS:N]Grou[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" It's [CS:N]Groudon[CR]! Spit it out!", french="C'est [CS:N]Groudon[CR]! Crache\nle morceau, à la fin!", german=" Sag es schon! Es ist [CS:N]Groudon[CR]!", italian=" Dillo! È [CS:N]Groudon[CR]!", spanish=" ¡Dilo de una vez! ¡Es [CS:N]Groudon[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" D-d-d-ding!", french=" D-d-d-ding!", german=" D-d-d-dargh!", italian=" Aaaaaah!", spanish=" ¡Tilín, tilín!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Don't eat me! I'm not tasty!", french="Ne me mange pas! J'ai mauvais\ngoût!", german="Friss mich nicht! Ich bin nicht\nsehr schmackhaft!", italian="Non mangiarmi! Non mangiarmi!\nNon ho un buon sapore!", spanish=" ¡No me comas! ¡No tengo buen sabor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 168, 352, Direction.Down, "NPC_YUKUSHII")
  GROUND:EntTurn(npc_npc_yukushii, Direction.Down)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 200, 360, Direction.Up, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(40), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Hello to one and all!\nSo what's wrong?", french="Amis du jour, bonjour!\nBah alors, quel est le problème?", german="Hallo, alle miteinander!\nStimmt etwas nicht?", italian="Bentrovati, amichevoli amici! ♪\nQualcosa non va?", spanish=" ¡Saludos a todos! ¿Qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweating", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" G-G-Guildmaster!", french=" M-Maître!", german=" G-G-Gildenmeister!", italian=" C-C-Capitano!", spanish=" Gran... ¡Gran Bluff!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Oh, never mind that![K]\nEveryone, look out there!", french="Oh, ne vous en faites pas\npour ça![K] Regardez par là, vous autres!", german="Oh, kümmert euch nicht darum![K]\nSeht euch das mal an!", italian="Oh, quello![K] Lasciate perdere\nquello! Guardate laggiù, invece!", spanish="¡Ah, eso! No os preocupéis.[K]\n¡Mirad eso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" It's spouting!", french="L'eau jaillit comme\nd'une fontaine!", german=" Er sprudelt!", italian=" Guardate! ♪", spanish=" ¡Mirad como brota!"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Pretty! Pretty!", french=" Ooooh, que c'est joli!", german=" Wie schön! Wie schön!", italian=" Chebellochebellochebello!", spanish=" ¡Bonito! ¡Bonito!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "question", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "question", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "question", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HUH?", french="[CS:N]Tous[CR]: HEIN?", german="[CS:N]Alle[CR]: HUCH?", italian="[CS:N]Tutti[CR]: EEEH?", spanish="[CS:N]Todos[CR]: ¿CÓMO?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
