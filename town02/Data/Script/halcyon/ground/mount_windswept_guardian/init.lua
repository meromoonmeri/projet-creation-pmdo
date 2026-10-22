--[[
    init.lua
    Mount Windswept Guardian Ground Map
    Tornadus, gardien du sommet — Chapitre 5
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ReplayEnding'
require 'halcyon.ground.mount_windswept_guardian.mount_windswept_guardian_ch_5'

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

local mount_windswept_guardian = {}

function mount_windswept_guardian.Init(map)
  nre_snap('mount_windswept_guardian.Init')
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_mount_windswept_guardian")

  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function mount_windswept_guardian.Enter(map)
  -- Sonde opt-in: l'appel est volontairement effectue depuis la coroutine
  -- Ground.Enter, seul contexte dans lequel ContinueDungeon peut yield.
  local probe = os.getenv('PMDO_GROUND_VALIDATOR')
  if probe == 'tornadus_battle' or (probe ~= nil and string.sub(probe,1,6) == 'arena:') then
    local zone, seg = 'mount_windswept', 2
    if probe ~= 'tornadus_battle' then
      zone, seg = string.match(probe, '^arena:([^:]+):(%d+)$')
      seg = tonumber(seg)
    end
    PrintInfo('[ARENA_RUNTIME] ground coroutine -> ContinueDungeon '..tostring(zone)..' segment='..tostring(seg))
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon(zone,seg,0,0,RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,false)
    return
  end
  if SV.RuntimeGroundAudit and SV.RuntimeGroundAudit.Active then GAME:CutsceneMode(false); GAME:FadeIn(1); return end
  nre_snap('mount_windswept_guardian.Enter')
  -- Purge explicite : cette sequence ne doit jamais afficher pluie ou fog,
  -- y compris apres retry, sauvegarde ou retour post-combat.
  pcall(function() GROUND:RemoveMapStatus('heavy_rain') end)
  pcall(function() GROUND:RemoveMapStatus('falling_rain') end)
  pcall(function() GROUND:RemoveMapStatus('light_rain') end)
  pcall(function() GROUND:RemoveMapStatus('fog') end)
	if SV.Chapter5.MountGuardianDefeated == nil then SV.Chapter5.MountGuardianDefeated = false end
	if SV.Chapter5.MountGuardianLost == nil then SV.Chapter5.MountGuardianLost = false end
	if SV.Chapter5.MountGuardianSeen == nil then SV.Chapter5.MountGuardianSeen = false end
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Enter_mount_windswept_guardian")

  -- Rejouabilite : l'expedition est bouclee, le sommet est vide.
  -- Northwind Field (360x336 px) : ellipse centrale libre x 104..248,
  -- y 80..264. Le duo reste dans la carte.
  if ReplayEnding.IsReplay('mount_windswept', 5) then
    SV.Chapter5.MountGuardianDefeated = false
    SV.Chapter5.MountGuardianLost = false
    ReplayEnding.EmptyArena({
      hero = {176, 248}, partner = {152, 248},
      camera = {176, 216}, look = {176, 168},
      walk = 40, title = true, music = 'Mt. Travail.ogg',
      lines = {
        { spk='partner', emo='Normal', key='MWG_R01', wait=10 },
        { spk='hero',    emo='Normal', key='MWG_R02', wait=10 },
        { spk='partner', emo='Normal', key='MWG_R03' },
        { spk='narrator',              key='MWG_R04' },
      },
    })
    return
  end

  -- Ne pas envelopper le dispatch dans pcall : une faute de scène doit être
  -- visible dans le journal runtime et corrigée, jamais transformée en faux
  -- retour au gameplay sans combat.
  if SV.Chapter5.MountGuardianDefeated then
    SV.Chapter5.MountGuardianDefeated = false
    mount_windswept_guardian_ch_5.DefeatedBoss()
  elseif SV.Chapter5.MountGuardianLost then
    SV.Chapter5.MountGuardianLost = false
    mount_windswept_guardian_ch_5.DiedToBoss()
  elseif SV.Chapter5.MountGuardianSeen then
    mount_windswept_guardian_ch_5.SecondPreBossScene()
  else
    mount_windswept_guardian_ch_5.FirstPreBossScene()
  end
end

function mount_windswept_guardian.Update(map, time)
end

function mount_windswept_guardian.GameSave(map)
end

function mount_windswept_guardian.GameLoad(map)
  -- Une sauvegarde chargée sur ce Ground doit toujours rendre l'image avant
  -- de reprendre le dispatch narratif.
  pcall(function() GAME:MoveCamera(176,196,1,false) end)
  pcall(function() GAME:FadeIn(20) end)
end

return mount_windswept_guardian
