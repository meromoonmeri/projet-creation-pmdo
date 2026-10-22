--[[
    init.lua
    Vast Steppe Mini-Boss Ground Map
    Stantler + Mudbray encounter — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.vast_steppe_miniboss.vast_steppe_miniboss_ch_5'

-- [NREPROBE] sonde locale : état complet de la scène à un point donné.
local function nre_snap(tag)
  local ok, msg = pcall(function()
    local zone = tostring(_ZONE.CurrentZoneID)
    local seg = tostring(_ZONE.CurrentMapID.Segment)
    local save_n = _DATA.Save.ActiveTeam.Players.Count
    local leader = '<nil>'
    if _DATA.Save.ActiveTeam.Leader ~= nil then
      leader = _DATA.Save.ActiveTeam.Leader:GetDisplayName(true)
    end
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    return string.format('[NREPROBE][%s] zone=%s seg=%s Save.Team=%d leader=%s hero=%s partner=%s',
      tag, zone, seg, save_n, leader,
      hero ~= nil and 'OK' or 'NIL', partner ~= nil and 'OK' or 'NIL')
  end)
  PrintInfo(ok and msg or ('[NREPROBE]['..tag..'] snapshot FAILED: '..tostring(msg)))
end

local vast_steppe_miniboss = {}

function vast_steppe_miniboss.Init(map)
  nre_snap('vast_steppe_miniboss.Init')
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vast_steppe_miniboss")

  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vast_steppe_miniboss.Enter(map)
  nre_snap('vast_steppe_miniboss.Enter')
	if SV.Chapter5.SteppeMiniBossDefeated == nil then SV.Chapter5.SteppeMiniBossDefeated = false end
	if SV.Chapter5.SteppeMiniBossLost == nil then SV.Chapter5.SteppeMiniBossLost = false end
	if SV.Chapter5.SteppeMiniBossSeen == nil then SV.Chapter5.SteppeMiniBossSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_vast_steppe_miniboss")

  if SV.Chapter5.SteppeMiniBossDefeated then
    SV.Chapter5.SteppeMiniBossDefeated = false
    vast_steppe_miniboss_ch_5.DefeatedBoss()
  elseif SV.Chapter5.SteppeMiniBossLost then
    SV.Chapter5.SteppeMiniBossLost = false
    vast_steppe_miniboss_ch_5.DiedToBoss()
  elseif SV.Chapter5.SteppeMiniBossSeen then
    vast_steppe_miniboss_ch_5.SecondPreBossScene()
  else
    vast_steppe_miniboss_ch_5.FirstPreBossScene()
  end
end

function vast_steppe_miniboss.Update(map, time)
end

function vast_steppe_miniboss.GameSave(map)
end

function vast_steppe_miniboss.GameLoad(map)
end

return vast_steppe_miniboss
