--[[
    Passage du Temps (D55) — donjon natif de l'épisode spécial Équipe Charme.

    La zone possède trois LayeredSegment natifs (index 0, 1 et 2), chacun de
    trois étages. SV.FutureSpecialEpisode sélectionne le segment correspondant
    et ne valide son fragment que sur ResultType.Cleared.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.future_arc.dungeon55_events'

local passage_temps = {}

function passage_temps.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo('=>> Init_passage_temps')
  SV.TemporaryFlags.LastDungeonEntered = 'passage_temps'
end

function passage_temps.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function passage_temps.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function passage_temps.ExitSegment(zone, result, rescue, segmentID, mapID)
  Dungeon55Events.HandleExit(result, rescue, zone, segmentID)
end

return passage_temps
