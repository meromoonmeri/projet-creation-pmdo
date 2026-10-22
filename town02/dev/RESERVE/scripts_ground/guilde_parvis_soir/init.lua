--[[ Parvis de la Guilde — Soir — ground importe (format RogueEssence natif, vague 4).
     Assignation : RÉSERVE
     Squelette standard : a completer lors du cablage des cinematiques. ]]
local guilde_parvis_soir = {}

function guilde_parvis_soir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_guilde_parvis_soir")
  COMMON.RespawnAllies()
end

function guilde_parvis_soir.Enter(map)
  GAME:FadeIn(20)
end

function guilde_parvis_soir.Update(map, time)
end



function guilde_parvis_soir.Koffing_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhéhé ![pause=15] Mêlez-vous de ce qui vous regarde !", "Normal")
  GeneralFunctions.EndConversation(chara)
end

function guilde_parvis_soir.Zubat_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  GeneralFunctions.StartConversation(chara, "Héhé ![pause=15] Vous n'avez rien à faire par ici !", "Normal")
  GeneralFunctions.EndConversation(chara)
end
return guilde_parvis_soir
