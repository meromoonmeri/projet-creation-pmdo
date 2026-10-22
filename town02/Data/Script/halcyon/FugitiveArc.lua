--[[
    FugitiveArc.lua — Arc Fugitif (chapitre 11) : cheminement canon PMD Red.

    Restitution du cheminement CANON de l'Arc Fugitif de PMD Red/Blue
    Rescue Team, adapté à New Era. Les grounds sont les exports
    pixel-perfect du port PMD-RED-PMDO-PORT (géométrie, collision,
    positions d'entités 1:1 — aucun décalage possible en jeu).

    Cheminement canon (vérifié dans CINEMATICS_DATABASE.md) :
      A02P01 Fissure -> A02P02 Incendie -> A02P03 Grotte Lapis
      -> A02P04 Volcan                      (la fuite)
      -> D08 Lapis Cave (entrée -> fond)
      -> D09 Mt Blaze   (entrée -> relais -> sommet Moltres)
      -> A03P01 Route de neige -> A03P02 Forêt de neige
      -> A03P03 Route du blizzard (voix de Feunard)
      -> D10 Frosty Forest (entrée -> relais -> sommet Articuno)
      -> D11 Mt Freeze  (entrée -> relais -> autel Feunard)
      -> D12 Magma Cavern (entrée -> relais -> fosse Groudon)
      -> D13 Sky Tower  (entrée -> relais -> sommet Rayquaza)
      -> T01P01 Place Pokémon (panique)
      -> A04P01 Rêve (Gardevoir) -> A05P03 The End

    Les dialogues sont déclarés par clés SCENE_XXX (STRINGS:FormatKey) :
    à adopter plus tard — FormatKey renvoie la clé elle-même tant que
    le texte n'est pas écrit, aucune scène ne crashe.
]]

require 'origin.common'

FugitiveArc = {}

-- ---------------------------------------------------------------------
-- ÉTAPES DE L'ARC : ground New Era -> scène Lua source -> musique
-- (les musiques GBA sont documentées ; les .ogg manquants seront
-- importés ; tant qu'ils manquent, le morceau par défaut est joué)
-- ---------------------------------------------------------------------
FugitiveArc.SEQUENCE = {
  { ground = 'a02p01',            scene = 'a02p01', music = 'Rising Fear.ogg' },
  { ground = 'a02p02',            scene = 'a02p02', music = 'Rising Fear.ogg' },
  { ground = 'a02p03',            scene = 'a02p03', music = 'Rising Fear.ogg' },
  { ground = 'a02p04',            scene = 'a02p04', music = 'Rising Fear.ogg' },
  { ground = 'grotte_lazuli_seuil', scene = 'd08p01', music = 'Water Cave.ogg' },
  { ground = 'grotte_lazuli_fond',  scene = 'd08p02', music = 'Growing Anxiety.ogg' },
  { ground = 'mont_cendre_pied',    scene = 'd09p01', music = 'Treacherous Mountain.ogg' },
  { ground = 'd09p02',            scene = 'd09p02', music = 'Treacherous Mountain.ogg' },
  { ground = 'd09p03',            scene = 'd09p03', music = 'In the Depths of the Pit.ogg' },
  { ground = 'a03p01',            scene = 'a03p01', music = 'Glacial Path.ogg' },
  { ground = 'a03p02',            scene = 'a03p02', music = 'Snowbound Path.ogg' },
  { ground = 'a03p03',            scene = 'a03p03', music = 'Snowbound Path.ogg' },
  { ground = 'foret_givree_oree',   scene = 'd10p01', music = 'Snowbound Path.ogg' },
  { ground = 'd10p02',            scene = 'd10p02', music = 'Glacial Path.ogg' },
  { ground = 'd10p03',            scene = 'd10p03', music = 'In the Depths of the Pit.ogg' },
  { ground = 'mont_gele_pied',      scene = 'd11p01', music = 'Snowbound Path.ogg' },
  { ground = 'd11p02',            scene = 'd11p02', music = 'Snow Camp.ogg' },
  { ground = 'd11p03',            scene = 'd11p03', music = 'Mystifying Forest.ogg' },
  { ground = 'gorge_ardente_porte', scene = 'd12p01', music = 'Enraged Caldera.ogg' },
  { ground = 'gorge_ardente_coeur', scene = 'd12p02', music = 'Enraged Caldera.ogg' },
  { ground = 'fosse_ardente',       scene = 'd12p04', music = 'In the Depths of the Pit.ogg' },
  { ground = 'arc_parvis_celeste',    scene = 'd13p01', music = 'Sky Tower.ogg' },
  { ground = 'arc_palier_celeste',    scene = 'd13p02', music = 'Sky Tower.ogg' },
  { ground = 'arc_tour_ciel_sommet',  scene = 'd13p03', music = 'Sky Tower.ogg' },
  { ground = 't01p01',            scene = 't01p01', music = 'Treasure Town.ogg' },
  { ground = 'a04p01',            scene = 'a04p01', music = 'At the End of the Day.ogg' },
  { ground = 'a05p03',            scene = 'a05p03', music = '' },
}

-- index par ground
FugitiveArc.INDEX = {}
for i, step in ipairs(FugitiveArc.SEQUENCE) do
  FugitiveArc.INDEX[step.ground] = i
end

-- ---------------------------------------------------------------------
-- BEGIN : entrée dans l'arc (appelée depuis la fin du ch11 / la fuite)
-- ---------------------------------------------------------------------
function FugitiveArc.Begin()
  DEBUG.EnableDbgCoro()
  local sv = SV.FugitiveArc
  if sv == nil then SV.FugitiveArc = {} end
  if SV.FugitiveArc.Step == nil or SV.FugitiveArc.Step < 1 then SV.FugitiveArc.Step = 1 end
  SV.FugitiveArc.Started = true
  local step = FugitiveArc.SEQUENCE[SV.FugitiveArc.Step]
  if step == nil then
    -- arc terminé : retour au monde (à brancher)
    GAME:FadeIn(20)
    return
  end
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(30)
  GAME:EnterGroundMap(step.ground, 'Main_Entrance_Marker')
end

-- ---------------------------------------------------------------------
-- PLAY : joue la scène du ground courant puis enchaîne vers l'étape
-- suivante. Appelée par l'init.lua de chaque ground de l'arc.
-- ---------------------------------------------------------------------
function FugitiveArc.Play(currentGround)
  DEBUG.EnableDbgCoro()
  local idx = FugitiveArc.INDEX[currentGround]
  if idx == nil then
    PrintInfo('[FugitiveArc] ground inconnu : ' .. tostring(currentGround))
    GAME:FadeIn(20)
    return
  end

  local step = FugitiveArc.SEQUENCE[idx]
  local ok, err = pcall(function()
    -- musique canonique si disponible (pcall : une musique absente ne
    -- doit jamais interrompre l'arc ; RogueEssence logue et continue)
    if step.music ~= nil and step.music ~= '' then
      local ok2, err2 = pcall(function() SOUND:PlayBGM(step.music, true) end)
      if not ok2 then
        PrintInfo('[FugitiveArc] musique indisponible ' .. tostring(step.music) .. ' : ' .. tostring(err2))
      end
    end

    -- la scène (dialogues en clés, à adopter plus tard)
    local mod = require('halcyon.arc_fugitif.scene.' .. step.scene)
    if mod ~= nil and mod.Cutscene ~= nil then
      mod.Cutscene()
    end

    -- avancer dans l'arc
    if SV.FugitiveArc == nil then SV.FugitiveArc = {} end
    SV.FugitiveArc.Step = idx + 1
    local nextStep = FugitiveArc.SEQUENCE[SV.FugitiveArc.Step]
    GAME:FadeOut(false, 60)
    GAME:WaitFrames(30)
    if nextStep ~= nil then
      GAME:EnterGroundMap(nextStep.ground, 'Main_Entrance_Marker')
    else
      -- fin de l'arc : le duo débouche sur la Mare Altérée (suite du ch11)
      SV.FugitiveArc.Completed = true
      GAME:EnterGroundMap('altere_pond', 'Main_Entrance_Marker')
    end
  end)
  if not ok then
    PrintInfo('[FugitiveArc] étape ' .. tostring(idx) .. ' interrompue : ' .. tostring(err))
    -- sortie garantie : on avance quand même
    pcall(function()
      if SV.FugitiveArc == nil then SV.FugitiveArc = {} end
      SV.FugitiveArc.Step = idx + 1
      local nextStep = FugitiveArc.SEQUENCE[SV.FugitiveArc.Step]
      GAME:FadeOut(false, 30)
      GAME:WaitFrames(20)
      if nextStep ~= nil then
        GAME:EnterGroundMap(nextStep.ground, 'Main_Entrance_Marker')
      else
        GAME:CutsceneMode(false)
        GAME:EnterGroundMap('altere_pond', 'Main_Entrance_Marker')
      end
    end)
  end
end

return FugitiveArc
