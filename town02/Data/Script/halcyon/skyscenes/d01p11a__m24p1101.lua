-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/m24p1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 26 then
  -- supervision_LoadStation(LEVEL_D01P11A, 'UM25') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_LoadStation(LEVEL_D01P11A, 'UM24') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 416, 176, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 504, 152, Direction.Down, "NPC_RAPURASU")
  -- SetAnimation(2) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hurry! We have to go to the\n[CS:P]Hidden Land[CR]!", french=" Vite! Aux [CS:P]Terres Illusoires[CR]!", german="Beeilung! Wir müssen zum\n[CS:P]Verborgenen Land[CR] gehen!", italian="Presto! Dobbiamo andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Rápido! ¡Tenemos que ir a\nla [CS:P]Tierra Oculta[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hurry! We have to go to the\n[CS:P]Hidden Land[CR]!", french=" Vite! Aux [CS:P]Terres Illusoires[CR]!", german="Beeilung! Wir müssen zum\n[CS:P]Verborgenen Land[CR] gehen!", italian="Presto! Dobbiamo andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Rápido! ¡Tenemos que ir a\nla [CS:P]Tierra Oculta[CR]!"})
  else
  SkySceneKit.say({english="Hurry! We have to go to the\n[CS:P]Hidden Land[CR]!", french=" Vite! Aux [CS:P]Terres Illusoires[CR]!", german="Beeilung! Wir müssen zum\n[CS:P]Verborgenen Land[CR] gehen!", italian="Presto! Dobbiamo andare alla\n[CS:P]Terra Nascosta[CR]!", spanish="¡Rápido! ¡Tenemos que ir a\nla [CS:P]Tierra Oculta[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's move when you're ready,\n[hero]!", french="On se met en route quand tu\nveux, [hero]!", german="Lass uns losgehen, wenn du\nbereit bist, [hero]!", italian="Quando tutto è pronto\nci muoviamo, [hero]!", spanish="¡Avanzaremos cuando tú digas,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go when you're ready,\n[hero]!", french="On se met en route quand tu\nveux, [hero]!", german="Lass uns losgehen, wenn du\nbereit bist, [hero]!", italian="Quando tutto è pronto andiamo,\n[hero]!", spanish="¡Avanzaremos cuando tú digas,\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go when you're ready,\n[hero]!", french="On se met en route quand tu\nveux, [hero]!", german="Lass uns losgehen, wenn du\nbereit bist, [hero]!", italian="Quando tutto è pronto andiamo,\n[hero]!", spanish="¡Avanzaremos cuando tú digas,\n[hero]!"})
  end
  -- message_Close
  end
  end
  SkySceneKit.cleanup_npcs()
end
