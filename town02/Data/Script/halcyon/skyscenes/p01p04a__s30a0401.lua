-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/s30a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SUB30_TREASURE_DISCOVER = SV.SkyVars.SUB30_TREASURE_DISCOVER or {}; SV.SkyVars.SUB30_TREASURE_DISCOVER[0] = 0 -- $SUB30_TREASURE_DISCOVER[0] = 0 (ROM)
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_soonansu = SkySceneKit.spawn_npc("wobbuffet", 456, 152, Direction.Down, "NPC_SOONANSU")
  -- SetAnimation(2) [anim idle native]
  local npc_npc_soonano = SkySceneKit.spawn_npc("wynaut", 432, 152, Direction.Down, "NPC_SOONANO")
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Did you hear the happy news,\nwhy not?", french=" Excellente nouvelle, O.K.!", german=" Frohe Neuigkeiten, so isses!", italian=" È una bella notizia, vero no?", spanish=" Son buenas noticias, ¿no es así?"})
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_soonano, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Thanks to everyone's recycling\nefforts, Project P recently made a\nnew discovery!", french="Grâce à votre soutien pour\nnotre projet d'échanges, le Projet P\nvient de permettre une nouvelle découverte!", german="Weil alle so fleißig\nwiederverwertet haben, hat Projekt P\nkürzlich eine neue Entdeckung gemacht!", italian="Grazie agli sforzi di tutti,\nil Progetto P ha appena fatto una nuova\nscoperta!", spanish="¡Gracias al esfuerzo de todos, el\nProyecto P ha hecho un gran descubrimiento!"})
  -- message_Close
  -- GAP: se_Play(7944) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(5)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: SetEffect EFFECT_CONFETTI — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(60)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- se_FadeOut(7944, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="This time, treasure was\ndiscovered, so...", french="Cette fois-ci, c'est un trésor\nqui vient d'être découvert, donc...", german="Dieses Mal war es ein großer\nSchatz...", italian="Questa volta è stato rinvenuto\nun tesoro, quindi...", spanish="Esta vez se ha descubierto\nun tesoro, así que..."})
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="We're offering a higher grade\nof recycled items!", french="... nous proposons de nouveaux\ntypes d'objets!", german="Daher gibt es von nun an\nneue Wiederverwertungs-Items!", italian="... offriamo altri tipi di\nstrumenti riciclati!", spanish="¡Estamos ofreciendo objetos\nreciclados mucho mejores!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: BGM BGM_PERFECT_SENTRY_DUTY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_soonano) end)
  SkySceneKit.say({english="Please keep recycling! The more\nrecycling, the better!", french="S'il vous plaît, continuez à\néchanger! Plus vous échangerez,\nmieux ce sera!", german="Bitte macht weiter fleißig mit!\nJe mehr Wiederverwertung, desto besser!", italian="Continuate a riciclare!\nPiù lo fate e meglio è!", spanish="¡Sigue reciclando! ¡Cuanto más,\nmejor!"})
  -- message_Close
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySceneKit.cleanup_npcs()
end
