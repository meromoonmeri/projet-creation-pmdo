--[[ Plage du Crépuscule — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE cinématique
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local plage_crepuscule = {}

function plage_crepuscule.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_plage_crepuscule")
  COMMON.RespawnAllies()
end

function plage_crepuscule.Enter(map)
  GAME:FadeIn(20)
end

function plage_crepuscule.Update(map, time)
end



function plage_crepuscule.Koffing_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhéhé ![pause=15] Mêlez-vous de ce qui vous regarde !", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function plage_crepuscule.Zubat_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhé ![pause=15] Vous n'avez rien à faire par ici !", "Normal")
  GeneralFunctions.EndConversation(chara)
end
return plage_crepuscule
