--[[
    init.lua
    Vast Steppe Guardian Ground Map
    Absol — Gardien Alpha de la Grande Steppe — Chapter 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
require 'halcyon.ground.vast_steppe_guardian.vast_steppe_guardian_ch_5'

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

local vast_steppe_guardian = {}

function vast_steppe_guardian.Init(map)
  nre_snap('vast_steppe_guardian.Init')
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_vast_steppe_guardian")

  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vast_steppe_guardian.Enter(map)
  nre_snap('vast_steppe_guardian.Enter')
	if SV.Chapter5.SteppeGuardianDefeated == nil then SV.Chapter5.SteppeGuardianDefeated = false end
	if SV.Chapter5.SteppeGuardianLost == nil then SV.Chapter5.SteppeGuardianLost = false end
	if SV.Chapter5.SteppeGuardianSeen == nil then SV.Chapter5.SteppeGuardianSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_vast_steppe_guardian")

  -- Rejouabilite : l'expedition est bouclee, le Gardien n'est plus la. On joue
  -- le constat de salle vide, puis l'ecran de resultats et le retour a la guilde.
  -- Sans cette branche, la carte hors chapitre 5 n'avait AUCUNE sortie.
  if ReplayEnding.IsReplay('vast_steppe', 5) then
    SV.Chapter5.SteppeGuardianDefeated = false
    SV.Chapter5.SteppeGuardianLost = false
    ReplayEnding.EmptyArena({
      hero = {200, 348}, partner = {168, 348},
      camera = {184, 344}, look = {184, 262},
      walk = 60, title = true, music = 'Sky Peak Prairie.ogg',
      lines = {
        { spk='partner', emo='Normal',  key='VSG_R01', wait=10 },
        { spk='hero',    emo='Normal',  key='VSG_R02', wait=10 },
        { spk='partner', emo='Happy',   key='VSG_R03' },
        { spk='narrator',               key='VSG_R04' },
      },
    })
    return
  end

  if SV.Chapter5.SteppeGuardianDefeated then
    SV.Chapter5.SteppeGuardianDefeated = false
    vast_steppe_guardian_ch_5.DefeatedBoss()
  elseif SV.Chapter5.SteppeGuardianLost then
    SV.Chapter5.SteppeGuardianLost = false
    vast_steppe_guardian_ch_5.DiedToBoss()
  elseif SV.Chapter5.SteppeGuardianSeen then
    vast_steppe_guardian_ch_5.SecondPreBossScene()
  else
    vast_steppe_guardian_ch_5.FirstPreBossScene()
  end
end

function vast_steppe_guardian.Update(map, time)
end

function vast_steppe_guardian.GameSave(map)
end

function vast_steppe_guardian.GameLoad(map)
end

return vast_steppe_guardian
