-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P22A/s31a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 14) -- $SCENARIO_MAIN = scn[29,14] (ROM)
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 440, Direction.Up, "NPC_SHEIMI")
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Oh! I can see the\n2nd Station Clearing! [K]We can do it!", french="Oh! J'aperçois la trouée\ndu 2[F:E] Relais![K]\nOn peut y arriver!", german="Oh! Ich kann da drüben die\n2. Zwischenlagerlichtung sehen![K]\nWir schaffen das!", italian="Oh! Riesco a vedere\nil Bivacco 2![K] Possiamo farcela!", spanish="¡Anda! ¡Si ya veo la Base del\nSegundo Puerto![K] ¡Ánimo, que podemos hacerlo!"})
  -- message_Close
  -- back_SetGround(LEVEL_D73P22A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D73P22A, 'US31') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(40) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(42) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kinogassa = SkySceneKit.spawn_npc("breloom", 296, 224, Direction.UpLeft, "NPC_KINOGASSA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_kuchiito = SkySceneKit.spawn_npc("mawile", 184, 232, Direction.Left, "NPC_KUCHIITO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_goorikii = SkySceneKit.spawn_npc("machoke", 264, 216, Direction.UpRight, "NPC_GOORIKII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 348, false, 2)
  GROUND:MoveToPosition(hero, 228, 380, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 372, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 372, false, 2) end end
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Sky Peak Cave.ogg", true) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" Wow... Incredible!", french=" Ouah... Incroyable!", german=" Wow... Unglaublich!", italian=" Wow... Incredibile!", spanish=" Guau... ¡Es increíble!"})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english=" This is...", french=" C'est...", german=" Das ist...", italian=" Questo è...", spanish=" Es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(228, 284, 60, false) end) -- performer/caméra
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, "happy", 1) end)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_sheimi, 228, 268, false, 2)
  GAME:WaitFrames(7)
  GROUND:MoveToPosition(hero, 228, 300, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 308, false, 2) end end
  GAME:WaitFrames(3)
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 308, false, 2) end end
  pcall(function() GROUND:CharSetEmote(npc_npc_kinogassa, nil, 0) end) -- EFFECT_NONE
  -- SetAnimation(4) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_goorikii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kuchiito, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_kinogassa, 228, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kinogassa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Hey!\nWe're the Survey Team from Project P,\nTeam [CS:X]Frontier[CR]!", french="Hé!\nNous sommes l'équipe de reconnaissance\ndu Projet P, l'Equipe [CS:X]Eclaireurs[CR]!", german="Hey!\nWir sind das Vermessungsteam von Projekt P,\nTeam [CS:X]Grenzland[CR]!", italian="Ehi!\nSiamo la squadra di indagine del Progetto P,\nil Team [CS:X]Pioniere[CR]!", spanish="¡Hola! Somos el [CS:X]Equipo Frontera[CR],\nel equipo de reconocimiento del Proyecto P."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="This is a huge, tall mountain, you\nknow? So rescue missions can't be done...", french="C'est une montagne vraiment\ntrès haute, vous savez? C'est pour ça que les\nmissions de sauvetage sont impossibles ici...", german="Dies ist ein riesengroßer Berg,\nwisst ihr? Daher können hier keine\nRettungsmissionen durchgeführt werden...", italian="Questa montagna è immensa,\nlo sapete? Quindi non è possibile effettuare\nmissioni di Pronto Intervento...", spanish="Esta montaña es altísima y\ngigantesca, así que no se pueden llevar a\ncabo misiones de rescate..."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="So we've built a base at the\n2nd Station Clearing.", french="Alors on a établi un campement\nà la trouée du 2[F:E] Relais.", german="Aus diesem Grund haben wir\neine Basis auf der 2. Zwischenlagerlichtung\ngebaut.", italian="Ecco perché abbiamo costruito\nun campo base al Bivacco 2.", spanish="Por eso hemos levantado el\ncampamento en la Base del Segundo Puerto."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="We've set up a Kangaskhan Rock\nand [CS:K]Drifblim[CR]'s Gondola,\nso be sure to use them!", french="N'hésitez pas à utiliser la\nStatue Kangourex et la [CS:K]Navette Grodrive[CR]\nque nous y avons mis en place, d'accord?", german="Geht auf Nummer sicher und\nverwendet den Kangama-Speicher ebenso\nwie die [CS:K]Drifzepeli-Seilbahn[CR]!", italian="Qui troverete una Statua\nKangaskhan e l'Agenzia Viaggi [CS:K]Drifblim[CR]...\nUsatele pure a vostro piacimento!", spanish="Hemos colocado una Roca de\nKangaskhan y una [CS:K]Góndola Drifblim[CR],\n¡espero que os resulten útiles!"})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english="Project P's Recycle Shop is\ncovering it all too.", french="C'est la Bourse d'Echange du\nProjet P qui finance tous ces services.", german="Der Wiederverwertungsladen\nvon Projekt P trägt die Kosten.", italian="Non vi preoccupate per le spese,\nrientra tutto nel Progetto P del Centro Riciclo.", spanish="El Reciclaje Explorador del\nProyecto P cubre todos los gastos."})
  pcall(function() UI:SetSpeaker(npc_npc_kinogassa) end)
  SkySceneKit.say({english=" Everything's free!", french=" Tout est gratuit!", german=" Es ist alles kostenlos!", italian=" È tutto gratis!", spanish=" ¡Es todo gratis!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_kinogassa, 292, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_kinogassa, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="That's wonderful!\nThat's the spirit of cooperation.", french="C'est merveilleux!\nC'est ça, l'esprit d'équipe!", german="Wie wunderbar!\nDas nenne ich Teamgeist.", italian="Ma è meraviglioso!\nQuesto sì che è spirito di collaborazione.", spanish="¡Qué maravilla!\nA eso se le llama solidaridad."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Ah. The mountain is so\nbeautiful...", french=" Ah... La montagne est si belle...", german=" Ach. Der Berg ist so schön...", italian=" Ah... La montagna è così bella...", spanish=" Ah, qué bonita es la montaña..."})
  -- message_Close
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 284, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 172, 324, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpLeft) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
