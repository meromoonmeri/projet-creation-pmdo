-- ==========================================================================
-- Ground d'intro de la Quest « Pokemon Mystery Dungeon: Destiny » (PMDO 0.8.12).
-- Au lancement de la session de jeu (premier Enter de ce ground), la
-- cinematique d'Opening est jouee UNE fois avant le gameplay, puis le
-- ground rend la main (fondu d'entree).
-- ==========================================================================
local pmd_destiny_intro = {}

local function char_of(id)
  local ok, c = pcall(function() return GROUND:Char(id) end)
  if ok then
    return c
  end
  return nil
end

function pmd_destiny_intro.Init(map)
  DEBUG.EnableDbgCoro()
end

function pmd_destiny_intro.Enter(map)
  if _G.DESTINY_INTRO_PLAYED then
    GAME:FadeIn(20)
    return
  end
  _G.DESTINY_INTRO_PLAYED = true
  local ok, lib = pcall(function() return require('halcyon.ground.pmd_destiny_opening') end)
  if ok and lib ~= nil and lib.PlayOpeningCutscene ~= nil then
    pcall(function()
      lib.PlayOpeningCutscene(
        char_of('lucario'), char_of('riolu'), char_of('evoli'),
        char_of('sh_zoroark'), char_of('sh_massko'),
        char_of('tiplouf'), char_of('darkrai'), char_of('mega'))
    end)
  end
  GAME:FadeIn(30)
end

function pmd_destiny_intro.Exit(map) end
function pmd_destiny_intro.Update(map) end
function pmd_destiny_intro.GameSave(map) end
function pmd_destiny_intro.GameLoad(map) GAME:FadeIn(20) end

return pmd_destiny_intro
