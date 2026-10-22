--[[
    FutureScene.lua — opérations visuelles sûres pour les scènes importées.

    Les SSB canoniques animent parfois des performers d'objet appartenant aux
    SSA de Sky. Les Grounds PMDO officiels réutilisés par New Era ne contiennent
    pas toujours ces objets. Leur absence ne doit jamais interrompre la route :
    l'animation, purement visuelle, est alors ignorée et signalée une seule fois.
]]
require 'origin.common'

FutureScene = FutureScene or {}
FutureScene.ReportedObjectErrors = FutureScene.ReportedObjectErrors or {}

local function reportOnce(objectName, reason)
  local key = tostring(objectName) .. ':' .. tostring(reason)
  if FutureScene.ReportedObjectErrors[key] then return end
  FutureScene.ReportedObjectErrors[key] = true
  PrintInfo('[FutureScene] objet visuel ignoré (' .. tostring(objectName) .. ') : '
    .. tostring(reason))
end

function FutureScene.ObjectSetAnim(objectName, anim, startFrame, frameCount, direction, speed)
  local found, object = pcall(function() return OBJ(objectName) end)
  if not found or object == nil then
    reportOnce(objectName, found and 'absent du Ground importé' or object)
    return false
  end

  local applied, err = pcall(function()
    GROUND:ObjectSetAnim(object, anim, startFrame, frameCount, direction, speed)
  end)
  if not applied then reportOnce(objectName, err) end
  return applied
end

return FutureScene
