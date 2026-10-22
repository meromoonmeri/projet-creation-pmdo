-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P12A/n06a2802.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D56P12A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_LIMESTONE_CAVERN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 156, 228, false, 2)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 136, 312, Direction.Up, "NPC_CHAAREMU")
  GROUND:MoveToPosition(npc_npc_chaaremu, 132, 244, false, 2)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 184, 320, Direction.Up, "NPC_SAANAITO")
  GROUND:MoveToPosition(npc_npc_saanaito, 180, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_saanaito, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_chaaremu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(6)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(9)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(3)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Wh-where are we?!", french=" Où sommes-nous?!", german=" W-wo sind wir?!?", italian=" D-Dove siamo?!", spanish=" ¡¿Dó... dónde estamos?!"})
  -- message_Close
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" I-in a limestone cavern!", french=" Dans... une caverne de calcaire!", german=" I-in einer Kalksteinhöhle!", italian=" È-È una caverna calcarea!", spanish=" En... ¡En una caverna de caliza!"})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Past that wall...[K] This\nhuge limestone cave opens up!", french="Le mur dissimulait...[K] une\ngigantesque caverne!", german="Hinter dieser Mauer...[K] war\ndiese gewaltige Kalksteinhöhle versteckt!", italian="Oltre la parete...[K] si celava\nquesta enorme caverna calcarea!", spanish="Tras el muro...[K] se encuentra\nesta enorme cueva de caliza."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I knew it.", french=" Je le savais.", german=" Ich wusste es.", italian=" Lo sapevo.", spanish=" Lo sabía."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I knew that the wall held the\nsecret to finding the correct path onward...", french="Je savais que le mur était\nla clé de l'énigme...", german="Ich wusste, dass die Wand\ndas Geheimnis zum Weiterkommen\nbergen würde...", italian="Sapevo che quella parete\nnascondeva la soluzione per trovare\nla strada giusta...", spanish="Sabía que el muro escondía\nel secreto para hallar el camino adecuado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_saanaito, Direction.UpRight)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" ...[K][CS:N]Wigglytuff[CR] isn't here...", french=" ...[K] [CS:N]Grodoudou[CR] n'est pas là...", german=" ...[K][CS:N]Knuddeluff[CR] ist nicht hier...", italian=" ...[K] [CS:N]Wigglytuff[CR] non c'è...", spanish=" Hum...[K] [CS:N]Wigglytuff[CR] no está..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="He probably went on ahead.[K] We\nshould get going too.", french="Il a probablement poursuivi sa\nroute.[K] Et nous devrions l'imiter.", german="Er ist vielleicht schon weiter\nvoraus.[K] Wir sollten uns auch aufmachen.", italian="Forse è andato più avanti.[K]\nDovremmo proseguire anche noi.", spanish="Habrá seguido avanzando.[K]\nNosotras también deberíamos seguir."})
  -- message_Close
  pcall(function() GAME:MoveCamera(156, 76, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 156, 76, false, 2)
  GAME:WaitFrames(12)
  GROUND:MoveToPosition(npc_npc_chaaremu, 132, 100, false, 2)
  GAME:WaitFrames(6)
  GROUND:MoveToPosition(npc_npc_saanaito, 180, 100, false, 2)
  GAME:WaitFrames(20)
  -- main_EnterDungeon(155, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SkySceneKit.cleanup_npcs()
end
