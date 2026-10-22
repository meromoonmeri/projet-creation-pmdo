--[[
    init.lua — poisonous_forest_entrance
    Entrée de donjon (patron cloven_ruins_entrance) : Dungeon_Entrance (Touch),
    rocher Kangourex (Action), spawners équipiers.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.ChapterScenes'

local poisonous_forest_entrance = {}

function poisonous_forest_entrance.Init(map)
  COMMON.RespawnAllies()
  PartnerEssentials.InitializePartnerSpawn()
end

function poisonous_forest_entrance.Enter(map)
  --Scene d'arrivee du chapitre : jouee une seule fois, elle etablit le lieu
  --avant que le joueur ne touche l'entree du donjon. Si elle a deja ete vue
  --(ou si on n'est pas dans le bon chapitre), fondu simple.
  if not ChapterScenes.MarshArrival() then
    GAME:FadeIn(20)
  end
end

function poisonous_forest_entrance.Update(map) end

function poisonous_forest_entrance.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function poisonous_forest_entrance.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

function poisonous_forest_entrance.Dungeon_Entrance_Touch(obj, activator)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(CH('PLAYER'), 'None', true)
  UI:ChoiceMenuYesNo("Entrer dans le Marais de l'Oubli ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(CH('PLAYER'))
    GAME:EnterDungeon("poisonous_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(CH('PLAYER'))
end

function poisonous_forest_entrance.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function poisonous_forest_entrance.Teammate1_Action(chara, activator)
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

function poisonous_forest_entrance.Teammate2_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

function poisonous_forest_entrance.Teammate3_Action(chara, activator)
  GeneralFunctions.GroundInteract(activator, chara)
end

return poisonous_forest_entrance
