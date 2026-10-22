-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V02P03A/m02a0104.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(5) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_V02P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(128, 556, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 136, 552, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Umm...[K] The footprint is...", french="Hum...[K] C'est l'empreinte\nde...", german=" Ähm...[K] Der Fußabdruck ist...", italian=" Uhm...[K] È la zampa di...", spanish=" Hum...[K] La huella..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Maybe [c_kind:PLAYER]'s![K]\nMaybe [c_kind:PLAYER]'s!", french="Peut-être celle de [c_kind:PLAYER]!\nPeut-être celle de [c_kind:PLAYER]!", german="Vielleicht ist er von\n[c_kind:PLAYER]![K] Vielleicht von [c_kind:PLAYER]!", italian="Forse è di [c_kind:PLAYER]![K]\nForse è di [c_kind:PLAYER]!", spanish="¡Podría ser de [c_kind:PLAYER]![K]\n¡Podría ser de [c_kind:PLAYER]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" What?! MAYBE?!", french=" Quoi?! Comment ça, PEUT-ETRE?!", german=" Was?!? VIELLEICHT?!?", italian=" Cosa?! FORSE?!", spanish=" ¿Cómo? ¡¿Cómo que podría ser?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="B-but...[K] It's not a footprint that\nyou normally see around here...", french="M-mais...[K] ce n'est pas\nune empreinte qu'on voit souvent par ici...", german="A-aber...[K] So einen Fußabdruck\nsieht man hier für gewöhnlich nicht...", italian="M-Ma...[K] è una zampa che si\nvede di rado da queste parti...", spanish="Es que...[K] no es una huella que se\nvea a menudo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" UGH! That's pretty crummy!", french=" BAAAH! Quelle excuse à deux Poké!", german=" HACH! Faule Ausrede!", italian=" UGH! Molto deludente!", spanish=" ¡Desde luego, menudo inútil!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Checking the footprints of visiting\nPokémon...", french="Vérifier les empreintes des Pokémon\nqui arrivent...", german="Die Fußabdrücke von Besuchern zu\nbestimmen...", italian="Controllare la forma delle zampe dei\nPokémon che vengono qui...", spanish="¡Pero si lo único que tienes que hacer es\ncomprobar las huellas de los Pokémon que\nquieren entrar!"})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" That's your job, ISN'T it, [CS:N]Diglett[CR]?", french="... c'est ton BOULOT, pas vrai,\n[CS:N]Taupiqueur[CR]?", german=" Das ist doch dein JOB, [CS:N]Digda[CR], oder NICHT?", italian=" ... è il tuo lavoro, NON È VERO [CS:N]Diglett[CR]?", spanish=" Ese es tu trabajo, ¿no, [CS:N]Diglett[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweating", 1) end)
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(45)
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Yes, but...[K] I don't know what\nI don't know.", french="Oui, mais...[K] quand je ne sais pas,\nje ne sais pas!", german="Ja, aber...[K] Wenn ich einen\nFußabdruck nicht kenne, erkenne ich ihn nicht.", italian="Sì, ma...[K] se non lo so, non lo\nso.", spanish="Sí, pero...[K] y si no lo sé... ¿qué\nhago, me lo invento?"})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
end
