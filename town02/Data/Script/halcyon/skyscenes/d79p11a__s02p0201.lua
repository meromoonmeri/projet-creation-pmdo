-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D79P11A/s02p0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 35) -- $SCENARIO_MAIN = scn[29,35] (ROM)
  -- back_SetGround(LEVEL_D79P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 300, 276, false, 2)
  GAME:WaitFrames(5)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 324, 296, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 276, 296, false, 2) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then GROUND:MoveToPosition(__slot, 300, 308, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(300, 140, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(300, 292, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There is a huge, jagged chasm\n[CN]cutting through the wall of ice!", french="[CN]Il y a une ouverture\n[CN]dans le mur de glace!", german="[CN]Dort zieht sich eine riesige\n[CN]zerklüftete Schlucht durch die Eiswand!", italian="[CN]C'è un enorme crepaccio frastagliato\n[CN]che attraversa il muro di ghiaccio!", spanish="[CN]¡Una enorme sima dentada\n[CN]atraviesa la pared de hielo!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It appears to lead into\n[CN]a series of caves.", french="[CN]Il semble qu'elle conduise\n[CN]à une série de grottes.", german="[CN]Anscheinend führt sie in\n[CN]eine Reihe von Höhlen.", italian="[CN]Sembra che conduca a una\n[CN]serie di caverne.", spanish="[CN]Parece conducir a\n[CN]una serie de cuevas."})
  -- message_KeyWait
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It's the entrance to another dungeon!", french="[CN]C'est l'entrée d'un nouveau donjon!", german="[CN]Das ist der Eingang zu einem weiteren Dungeon!", italian="[CN]È l'ingresso di un altro dungeon!", spanish="[CN]¡Es la entrada a otro territorio!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetLevel(8) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(48) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(48) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(48) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]You can now enter\n[CN][CS:P]Crevice Cave[CR]!", french="[CN]Vous pouvez maintenant entrer dans la\n[CN][CS:P]Grotte Lézarde[CR]!", german="[CN]Du kannst jetzt die\n[CN][CS:P]Gletscherhöhle[CR] betreten!", italian="[CN]Adesso potete entrare nella\n[CN][CS:P]Grotta dell'Abisso[CR]!", spanish="[CN]¡Ahora puedes entrar en la\n[CN][CS:P]Cueva Témpano[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[47] = 1 -- dungeon_mode(47) = DMODE_OPEN (ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
end
