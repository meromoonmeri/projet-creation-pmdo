-- Generated NNV→PMDO candidate; not a production route.
require 'origin.common'
require 'halcyon.LivingWorld'
require 'halcyon.TownLife'
require 'halcyon.TownPlace'
require 'halcyon.Seasons'
require 'halcyon.Weather'
require 'halcyon.TownNight'
local M = {}
function M.Init(map)
  LivingWorld.Ensure()
  TownNight.Ensure()
end
function M.Enter(map)
  LivingWorld.SyncStory()
  M.Context = LivingWorld.Context('no_name_village', 'nnv_rmvillage_winter')
  M.Day = TownLife.Today()
  -- Do not call Seasons.Apply here: its generic PMDO particles are not a
  -- substitute for No Name Village's canonical objstage/objwinter system.
  LivingWorld.ApplyOutdoor(false)
  M.SourceSeason = Seasons.Actuelle().id
  if M.SourceSeason ~= 'hiver' then
    error('NNV canonical season mismatch for nnv_rmvillage_winter: '..tostring(M.SourceSeason))
  end
  local preset = Weather.ForChapter((SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1)
  if preset ~= nil then Weather.Set(preset) end
end
function M.PlaceDialogue(inst)
  return TownPlace.Line(inst)
end
function M.Exit(map) end
function M.Update(map) end
function M.Exit_Door_106508_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_playerhouse', 'Entry_Door')
end
function M.Exit_Door_106509_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_hunterhouse', 'Entry_Door')
end
function M.Exit_Door_106510_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_loggerhouse', 'Entry_Door')
end
function M.Exit_Door_106511_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_carpenterhouse', 'Entry_Door')
end
function M.Exit_North_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm54', 'Entry_South')
end
function M.Exit_North_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm65', 'Entry_South')
end
function M.Exit_West_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm45', 'Entry_East')
end
function M.Exit_South_Touch(obj, activator)
  GAME:FadeOut(false, 20)
  GAME:EnterGroundMap('nnv_rm56', 'Entry_North')
end
function M.GameSave(map) end
function M.GameLoad(map) end
return M
