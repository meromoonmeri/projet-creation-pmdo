--[[ Zone « Lost Wood » — structure aller/retour de la quête Destiny.
     1) Aller : le partenaire traverse les 7 étages seul (le héros, inconscient,
        est en réserve). Au succès, l'équipe est réunie sur le panorama nocturne.
     2) Retour : après la longue scène de retrouvailles, héros + partenaire
        retraversent les mêmes 7 étages ensemble. Au succès, ils reviennent au
        cliffdaytest_nuit. Échec de l'aller = croisement ; échec du retour =
        retrouvaille nocturne puis nouvelle tentative en duo.
     Honnêteté : runtime_tested false.
]]

require 'common'

local lost_wood = {}

function lost_wood.Init(zone)
end

function lost_wood.Rescued(zone, mail)
end

local function restaurer_heros()
  if SV.Destiny == nil or SV.Destiny.HeroAssemblyIndex == nil then return end
  local idx = SV.Destiny.HeroAssemblyIndex
  local heros = GAME:GetPlayerAssemblyMember(idx)
  if heros ~= nil then
    GAME:RemovePlayerAssembly(idx)
    GAME:AddPlayerTeam(heros)
    -- le héros devient PLAYER ; le partenaire devient Teammate1
    GAME:SetTeamLeaderIndex(1)
  end
  SV.Destiny.HeroAssemblyIndex = nil
end

local function terminer_et_entrer(result, zone_id, structure_id, map_id, entry_id)
  GAME:EndDungeonRun(result, zone_id, structure_id, map_id, entry_id, false, false)
  GAME:EnterZone(zone_id, structure_id, map_id, entry_id)
end

function lost_wood.ExitSegment(zone, result, rescue, segmentID, mapID)
  GAME:SetRescueAllowed(false)
  SV.Destiny = SV.Destiny or {}
  local aller_reussi = result == RogueEssence.Data.GameProgress.ResultType.Cleared
  local trajet = SV.Destiny.LostWoodTrip or 'aller'

  if trajet == 'retour' then
    -- Cette fois, l'équipe entière ressort de la forêt.
    if aller_reussi then
      SV.Destiny.LostWoodRetourEchec = false
      SV.Destiny.RetourAccompli = true
      SV.Destiny.LostWoodTrip = 'termine'
      terminer_et_entrer(result, 'destiny_cliff_tests', -1, 8, 0)
    else
      -- La scène ne recommence pas : elle reprend au panorama et propose
      -- une nouvelle tentative ensemble.
      SV.Destiny.LostWoodRetourEchec = true
      terminer_et_entrer(result, 'personality_test', -1, 2, 0)
    end
    return
  end

  -- Fin de l'aller solitaire : le héros revient de réserve avant la réunion.
  restaurer_heros()
  if aller_reussi then
    SV.Destiny.LostWoodTrip = 'rencontre'
    SV.Destiny.PartenaireParti = true
    SV.Destiny.LostWoodRetourEchec = false
    terminer_et_entrer(result, 'personality_test', -1, 2, 0)
  else
    SV.Destiny.LostWoodTrip = nil
    SV.Destiny.PartenaireParti = false
    terminer_et_entrer(result, 'destiny_cliff_tests', -1, 8, 0)
  end
end

return lost_wood
