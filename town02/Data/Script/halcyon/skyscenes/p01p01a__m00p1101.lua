-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/m00p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 216, 56, Direction.Down, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 216, 156, false, 2)
  GROUND:MoveToPosition(hero, 216, 132, false, 2)
  GROUND:MoveToPosition(partner, 216, 108, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(6)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(256, 164, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I hear you can make a record of\nyour adventure at that Watering Hole.", french="Paraît qu'on peut sauvegarder\nson aventure au Point d'Eau.", german="Ich habe gehört, dass man\nden Fortschritt seines Abenteuers dort\nbeim Wasserloch sichern kann.", italian="Mi hanno detto che al pozzo puoi\nsalvare i progressi della tua avventura.", spanish="He oído que puedes guardar tu\naventura en esa fuente."})
  -- message_KeyWait
  GROUND:MoveToPosition(partner, 236, 116, false, 2)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Usually, you make a record of\nyour adventure by going to your bed at\nthe guild, yup yup.", french="D'habitude, on sauvegarde son\naventure en allant à son lit, à la Guilde, pardi!", german="Normalerweise sichert man den\nFortschritt seines Abenteuers, indem man sich\nzu seinem Bett in der Gilde begibt, jawollja.", italian="Di solito devi andare nella\ntua stanza alla Gilda e usare il letto... già, già.", spanish="Normalmente la aventura se\nguarda yendo a tu cama del [CS:N]Pokégremio[CR].\n¡Sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Seems you can make a record\nof your adventure over there too.", french="Faut croire qu'on peut\nsauvegarder son aventure ici aussi.", german="Anscheinend kann man dort\nvorne aber auch sichern.", italian="Ma pare che tu possa salvare\nla partita anche qui.", spanish="Pero por lo visto también puedes\nguardar tu aventura en la fuente."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="By golly, it's a handy spot when\nyou want to record your adventure frequently.", french="Sapristi, c'est bien pratique\ncomme coin pour sauvegarder\nson aventure plus souvent.", german="Donnerwetter, das ist ein\npraktischer Ort, wenn man den Fortschritt\nseines Abenteuers häufig sichern will.", italian="Ohibò, è davvero comodo se vuoi\nsalvare spesso i progressi della tua avventura.", spanish="Es un lugar muy práctico si te\ngusta guardar la aventura con frecuencia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GAME:WaitFrames(3)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_bippa, 216, 196, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 216, 156, false, 2)
  GAME:WaitFrames(18)
  GROUND:MoveToPosition(partner, 216, 156, false, 2)
  GAME:WaitFrames(80)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
