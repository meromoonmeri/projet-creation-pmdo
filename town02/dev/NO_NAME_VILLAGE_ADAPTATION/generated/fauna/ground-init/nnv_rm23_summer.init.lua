-- Generated NNV→PMDO candidate; not a production route.
require 'origin.common'
require 'halcyon.LivingWorld'
require 'halcyon.TownLife'
require 'halcyon.TownPlace'
require 'halcyon.Seasons'
require 'halcyon.Weather'
require 'halcyon.TownNight'
require 'halcyon.NNVEcology'
require 'halcyon.NNVDuel'
local M = {}
function M.Init(map)
  LivingWorld.Ensure()
  TownNight.Ensure()
end
function M.Enter(map)
  -- [NNVEcology] charge la faune de ce Ground ; roster vide si aucune entite.
  pcall(function()
    NNVEcology.Load('nnv_rm23_summer')
    NNVEcology.Setup()
  end)
  LivingWorld.SyncStory()
  M.Context = LivingWorld.Context('no_name_village', 'nnv_rm23_summer')
  M.Day = TownLife.Today()
  -- Do not call Seasons.Apply here: its generic PMDO particles are not a
  -- substitute for No Name Village's canonical objstage/objwinter system.
  LivingWorld.ApplyOutdoor(false)
  M.SourceSeason = Seasons.Actuelle().id
  if M.SourceSeason ~= 'ete' then
    error('NNV canonical season mismatch for nnv_rm23_summer: '..tostring(M.SourceSeason))
  end
  local preset = Weather.ForChapter((SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1)
  if preset ~= nil then Weather.Set(preset) end
end
function M.PlaceDialogue(inst)
  return TownPlace.Line(inst)
end
function M.Exit(map) end
function M.Update(map)
  -- [NNVEcology] fait vivre la faune : deplacements, rencontres, duels.
  pcall(function() NNVEcology.Update() end)
end
function M.Exit_North_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm22', 'Entry_South')
end
function M.Exit_North_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm33', 'Entry_South')
end
function M.Exit_West_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm13', 'Entry_East')
end
function M.Exit_South_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm24', 'Entry_North')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
