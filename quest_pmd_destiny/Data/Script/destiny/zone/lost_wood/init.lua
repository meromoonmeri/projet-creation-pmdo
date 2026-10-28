--[[ init.lua — Zone « Lost Wood » (donjon de 7 étages)
     Traversé par le partenaire (scène de cliffdaytest_nuit) : au dernier
     étage, la sortie ne mène pas à un simple palier mais à la clairière
     où le héros est allongé (map reveil_nuit) — la scène du réveil.
     Échec = retour au croisement, la nuit est toujours là.
     Honnêteté : runtime_tested false.
]]

require 'common'

local lost_wood = {}

function lost_wood.Init(zone)
end

function lost_wood.Rescued(zone, mail)
end

function lost_wood.ExitSegment(zone, result, rescue, segmentID, mapID)
  GAME:SetRescueAllowed(false)
  if result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    -- le dernier étage s'ouvre sur la clairière du réveil
    -- (zone personality_test, ground 2 = reveil_nuit)
    GAME:EndDungeonRun(result, 'personality_test', -1, 2, 0, false, false)
    GAME:EnterZone('personality_test', -1, 2, 0)
  else
    -- échec : retour au croisement (destiny_cliff_tests, ground 8)
    GAME:EndDungeonRun(result, 'destiny_cliff_tests', -1, 8, 0, false, false)
    GAME:EnterZone('destiny_cliff_tests', -1, 8, 0)
  end
end

return lost_wood
