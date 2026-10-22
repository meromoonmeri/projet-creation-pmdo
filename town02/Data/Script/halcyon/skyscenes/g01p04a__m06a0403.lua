-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m06a0403.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 168, 288, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="Look, all you two have to do is\ninspect the footprints of visitors, then tell me\nwhat Pokémon they are.", french="Votre travail consiste à\nexaminer les empreintes des visiteurs et à\nme dire de quel Pokémon il s'agit.", german="Also, ihr müsst nur die\nFußabdrücke der Besucher inspizieren und mir\nsagen, welchem Pokémon sie gehören.", italian="Tutto ciò che dovete fare è\nispezionare le zampe dei visitatori e dirmi\na quali Pokémon appartengono.", spanish="Lo único que tenéis que hacer\nes inspeccionar las huellas de los visitantes,\ny luego decirme de qué Pokémon se trata."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" All right? Understood?", french=" D'accord? C'est compris?", german=" In Ordnung? Verstanden?", italian=" Va bene? Tutto chiaro?", spanish=" ¿Entendido?"})
  do local __choice = SkySceneKit.ask({{english="Yes, no problem!", french="Oui, pas de problème!", german="Ja, kein Problem!", italian="Nessun problema", spanish="Entendido"}, {english="No, please explain...", french="Non, réexplique-nous, s'il te plaît...", german="Nein, bitte noch mal erklären...", italian="Spiega di nuovo, per favore...", spanish="Explícalo otra vez"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitSe
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What?! You need me to explain\nit again?!", french="QUOI?! Vous avez encore besoin\nd'une explication?!", german="WAS?!? Ihr wollt alles noch mal\nerklärt bekommen?!?", italian="Cosa?! Volete che ve lo spieghi\ndi nuovo?!", spanish="¡¿Qué?! ¡¿Tengo que explicarlo\notra vez?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(20)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="All right. I've got a BIG heart.\nI'll explain as much as you want.", french="Bon. J'ai BON cœur.\nJe vous expliquerai donc autant de fois que\nvous voulez.", german="Na gut. Weil ich so GÜTIG bin,\nwerde ich es so oft erklären, wie ihr wollt.", italian="Va bene. Sono TROPPO buono.\nVe lo spiegherò quante volte volete.", spanish="Tenéis suerte de que sea buena\npersona. Os explicaré esto tantas veces como\nqueráis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeOut(false, 15)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Good![K] Then, let's get to WORK!", french=" Bien![K] Alors, au BOULOT!", german=" Gut![K] Na dann, an die ARBEIT!", italian=" Bene![K] Allora, al LAVORO!", spanish=" Estupendo.[K] Ahora, ¡a trabajar!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Buck up and do a GOOD job!", french="Grouillez-vous et faites du BON\nboulot!", german=" Los, und macht eure Sache GUT!", italian="Rimboccatevi le maniche e fate\nun BUON LAVORO!", spanish=" ¡Espabilad y hacedlo bien!"})
  -- message_Close
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:MoveToPosition(hero, 200, 292, false, 2)
  GROUND:MoveToPosition(partner, 224, 316, false, 2)
  GROUND:MoveToPosition(hero, 192, 300, false, 2)
  GROUND:MoveToPosition(partner, 208, 300, false, 2)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
  SkyProg.set(7, 5) -- $SCENARIO_MAIN = scn[7,5] (ROM)
  -- @label_2 [étiquette de flux ExplorerScript]
  end
  end
  SkySceneKit.cleanup_npcs()
end
