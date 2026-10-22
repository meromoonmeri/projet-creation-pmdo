-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D31P31A/s01p0603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  -- back_SetGround(LEVEL_D31P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 232, 240, Direction.Down, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="B-but I thought it'd be too dark\ndown there for you all, so I opened it up.", french="Bah, j'pensais qu'il f'sait\ntrop noir et qu'vous alliez vous marcher sur\nles pieds! Alors j'me suis dit, j'vais ouvrir!", german="I-ich dachte, es sei zu dunkel\nfür euch alle da unten, also habe ich sie\naufgemacht.", italian="M-Ma pensavo che qui dentro\nfosse troppo buio per voi, quindi ho aperto.", spanish="Pe... pensaba que estaría muy\noscuro ahí abajo... por eso..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="M-maybe I did something I\nshouldn't have...?", french="Pourquoi... j'aurais pas dû?\nJ'ai fait une gaffe?", german="V-vielleicht hätte ich das nicht\ntun sollen?", italian="F-Forse ho commesso\nun errore... Ohibò...", spanish="¿Qui... quizás no debería\nhaber...?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Uh, helping out with the\ngraduation exam and all...", french="Vous savez, vous filer un coup\nd'main pour l'examen et tout ça...", german="Ähm, die ganze Sache mit dem\nAushelfen bei der Abschlussprüfung und so...", italian="Eh, dare una mano con\nl'esame e tutto il resto...", spanish="Esto de colaborar en el gran reto\ndel [CS:N]Pokégremio[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="This is all so new to me, I don't\nhave the foggiest idea about what I should\nbe doing...", french="... j'l'avais jamais fait, moi.\nJ'capte rien du tout à c'que j'dois faire...", german="Das ist alles so neu für mich.\nIch habe nicht den leisesten Schimmer, was\nich hier machen soll...", italian="È tutto così nuovo per me,\nnon ho la più pallida idea di cosa dovrei fare...", spanish="Es toda una novedad para mí, y\nno tengo ni idea de qué debo hacer..."})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
