--[[
    Weather.lua — couche météo unifiée de New Era.

    POURQUOI CE MODULE PLUTÔT QU'UN SYSTÈME NEUF
    --------------------------------------------
    Le moteur RogueEssence fournit déjà 23 émetteurs, dont deux couvrent
    tout ce dont une météo 2D a besoin :

      * ScreenRainEmitter  — chutes. Expose ParticlesPerBurst (densité),
        BurstTime (fréquence), HeightSpeed (vitesse) et SpeedDiff, qui
        est la dérive horizontale, c'est-à-dire la direction du vent.
      * OverlayEmitter     — nappes plein écran. Expose Color (teinte et
        luminosité), Movement (défilement), FadeIn/FadeOut (transitions).

    Le recyclage des particules est fait par le moteur, dans sa boucle de
    rendu. Un mod de type Quest — ce qu'est New Era, cf. Mod.xml — livre
    du JSON et du Lua, jamais de C# : réécrire un système de particules
    depuis Lua serait plus lent, pas plus rapide.

    Ce module est donc une couche de CONFIGURATION, pas un moteur : il
    nomme des combinaisons (MapStatus de chute + nappe teintée + son) et
    garantit qu'on ne laisse jamais deux météos actives en même temps.

    PIÈGE À CONNAÎTRE
    -----------------
    GROUND:AddMapStatus échoue EN SILENCE sur un nom absent : pas
    d'erreur, pas d'effet. Toute météo passe donc par Weather.Set, qui
    vérifie le nom contre Weather.STATUS avant de l'envoyer au moteur.

    USAGE
    -----
      Weather.Set('storm')                  -- pose orage
      Weather.Set('light_rain')             -- remplace proprement
      Weather.Clear()                       -- retire tout
      Weather.Thunder()                     -- un éclair ponctuel
      Weather.StormLoop(4)                  -- 4 éclairs espacés

    Appelable depuis un Ground (Init/Enter), une cinématique, ou une zone.
]]

require 'origin.common'

Weather = {}

--------------------------------------------------------------------
-- MapStatus réellement présents dans Data/MapStatus/.
-- Toute entrée ajoutée ici doit exister ET être déclarée dans
-- Data/MapStatus/index.idx, sinon l'effet est silencieusement ignoré.
--------------------------------------------------------------------
Weather.STATUS = {
  -- chutes (ScreenRainEmitter)
  light_rain    = true,   -- bruine
  falling_rain  = true,   -- pluie franche
  heavy_rain    = true,   -- averse violente
  winter_snow   = true,   -- neige calme
  blizzard      = true,   -- neige chassée
  falling_ash   = true,   -- cendre
  sandstorm     = true,   -- sable
  -- nappes (OverlayEmitter)
  fog           = true,   -- brouillard
  gloom         = true,   -- ciel d'orage
  steam         = true,   -- vapeur
  blowing_wind  = true,
  blowing_wind_fast = true,
  -- ambiances
  darkness      = true,
  dusk          = true,
  autumn_leaves = true,
  sakura_drift  = true,
  mysterious_distortion = true,
}

--------------------------------------------------------------------
-- Les neuf météos. Chacune est une liste de MapStatus superposés :
-- c'est la superposition qui donne la richesse, pas un émetteur unique.
--------------------------------------------------------------------
Weather.PRESETS = {
  pluie_legere = { layers = {'light_rain'} },
  pluie        = { layers = {'falling_rain'} },
  pluie_forte  = { layers = {'heavy_rain', 'gloom'} },
  orage        = { layers = {'heavy_rain', 'gloom'}, thunder = true },
  neige        = { layers = {'winter_snow'} },
  blizzard     = { layers = {'blizzard', 'fog'} },
  brouillard   = { layers = {'fog'} },
  sable        = { layers = {'sandstorm', 'blowing_wind_fast'} },
  vent         = { layers = {'blowing_wind'} },
}

-- Mémoire des couches posées, pour pouvoir les retirer proprement.
Weather.active = {}

--------------------------------------------------------------------
-- Retire toutes les couches posées par ce module.
-- On ne touche pas aux MapStatus posés ailleurs (héritage de carte).
--------------------------------------------------------------------
function Weather.Clear()
  for name, _ in pairs(Weather.active) do
    pcall(function() GROUND:RemoveMapStatus(name) end)
  end
  Weather.active = {}
end

--------------------------------------------------------------------
-- Pose une météo. Remplace la précédente.
--   preset : clé de Weather.PRESETS, ou nil pour tout retirer.
-- Renvoie true si au moins une couche a été posée.
--------------------------------------------------------------------
function Weather.Set(preset)
  Weather.Clear()
  if preset == nil then return false end

  local cfg = Weather.PRESETS[preset]
  if cfg == nil then
    PrintInfo("[Weather] preset inconnu : " .. tostring(preset))
    return false
  end

  local posed = 0
  for _, name in ipairs(cfg.layers) do
    if not Weather.STATUS[name] then
      -- Le garde-fou : AddMapStatus serait ignoré en silence.
      PrintInfo("[Weather] MapStatus absent, couche ignoree : " .. tostring(name))
    else
      local ok = pcall(function() GROUND:AddMapStatus(name) end)
      if ok then
        Weather.active[name] = true
        posed = posed + 1
      else
        PrintInfo("[Weather] echec AddMapStatus : " .. tostring(name))
      end
    end
  end

  if posed > 0 then
    PrintInfo("[Weather] " .. tostring(preset) .. " — " .. tostring(posed) .. " couche(s)")
  end
  return posed > 0
end

--------------------------------------------------------------------
-- Un éclair : flash blanc, silence, puis tonnerre.
-- Le décalage entre l'éclair et le son est ce qui rend l'orage
-- crédible — la lumière arrive avant le bruit.
--------------------------------------------------------------------
function Weather.Thunder(delay)
  delay = delay or 12
  pcall(function()
    local c = GAME:GetCameraCenter()
    local f = RogueEssence.Content.FlashEmitter()
    f.FadeInTime = 2
    f.HoldTime = 3
    f.FadeOutTime = 18
    f.StartColor = Color(255, 255, 255, 0)
    f.Layer = DrawLayer.Top
    GROUND:PlayVFX(f, c.X, c.Y)
  end)
  GAME:WaitFrames(delay)
  -- DUN_Shock_Wave : SE de la foudre dans le jeu de base (c'est celui que
  -- la capacite thunderbolt declenche). DUN_Thunderbolt n'existe pas —
  -- l'employer aurait produit un eclair muet, sans erreur.
  pcall(function() SOUND:PlayBattleSE('DUN_Shock_Wave') end)
end

--------------------------------------------------------------------
-- Série d'éclairs irrégulièrement espacés. L'irrégularité compte :
-- un orage rythmé à intervalle fixe sonne mécanique.
--------------------------------------------------------------------
function Weather.StormLoop(count, minGap)
  count = count or 3
  minGap = minGap or 90
  local gaps = {0, 40, 25, 60, 15, 50}
  for i = 1, count, 1 do
    Weather.Thunder(8 + (i % 3) * 6)
    GAME:WaitFrames(minGap + (gaps[(i % #gaps) + 1] or 30))
  end
end

--------------------------------------------------------------------
-- Météo saisonnière d'un ground, sans avoir à la choisir à la main.
-- Rend la clé de preset, ou nil si la carte doit rester au sec.
--------------------------------------------------------------------
function Weather.ForChapter(chapter)
  if chapter == nil then return nil end
  if chapter == 11 then return 'pluie_forte' end   -- la nuit de la fuite
  return nil
end

return Weather
