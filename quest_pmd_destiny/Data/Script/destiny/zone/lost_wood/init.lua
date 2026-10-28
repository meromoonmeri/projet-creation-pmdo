--[[ init.lua — Zone « Lost Wood » (donjon de 7 étages)
     Le partenaire part seul du croisement. Le héros est retiré de l'équipe
     active et placé en réserve pour rester inconscient jusqu'à la sortie.
     Au dernier étage, l'équipe est restaurée, le héros redevient le leader,
     puis la sortie mène au ground reveil_nuit. Échec : retour au croisement.
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

function lost_wood.ExitSegment(zone, result, rescue, segmentID, mapID)
  GAME:SetRescueAllowed(false)
  restaurer_heros()

  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- le dernier étage s'ouvre sur la clairière du réveil
    -- (zone personality_test, ground 2 = reveil_nuit)
    GAME:EndDungeonRun(result, 'personality_test', -1, 2, 0, false, false)
    GAME:EnterZone('personality_test', -1, 2, 0)
  else
    -- échec : retour au croisement, avec possibilité de retenter le donjon
    SV.Destiny.PartenaireParti = false
    GAME:EndDungeonRun(result, 'destiny_cliff_tests', -1, 8, 0, false, false)
    GAME:EnterZone('destiny_cliff_tests', -1, 8, 0)
  end
end

return lost_wood
