--[[
    init.lua
    Crooked Cavern midpoint — mid-dungeon relay (checkpoint) for chapter 3.
    Modeled on ground/searing_tunnel_midpoint/init.lua.
    See audit_checkpoint_crooked_cavern.md and docs/authoring_crooked_cavern_midpoint.md.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.ground.crooked_cavern_midpoint.crooked_cavern_midpoint_ch_3'

local crooked_cavern_midpoint = {}

------------------------------- 
-- Map Callbacks
-------------------------------
function crooked_cavern_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_crooked_cavern_midpoint <<=') 
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function crooked_cavern_midpoint.Enter(map)
  crooked_cavern_midpoint.PlotScripting()
end

function crooked_cavern_midpoint.Exit(map)
end

function crooked_cavern_midpoint.Update(map)
end

function crooked_cavern_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function crooked_cavern_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  crooked_cavern_midpoint.PlotScripting()
end

function crooked_cavern_midpoint.PlotScripting()
  if SV.ChapterProgression.Chapter == 3 then
    if not SV.Chapter3.CrookedPlayedMidpointIntro then
      crooked_cavern_midpoint_ch_3.FirstArrival()
    elseif SV.CrookedCavern.DiedPastCheckpoint then
      crooked_cavern_midpoint_ch_3.WipedCutscene()
    else
      crooked_cavern_midpoint_ch_3.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

------------------------------- 
-- Entities Callbacks
-------------------------------
-- Forward exit (the ONLY way out). Continues into segment 1 ("Profondeurs").
-- There is deliberately NO backward exit: the player cannot return to the first
-- half from the relay (see spec). Leaving the run entirely is done via the
-- Kangaskhan Rock's "Sauvegarder et quitter." option.
function crooked_cavern_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer vers les profondeurs ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    crooked_cavern_midpoint_ch_3.ContinueScene()
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Sortie sud : retour à l'entrée de la caverne (fix audit : l'objet South_Exit
-- existait sur la map sans callback — la sortie sud était muette).
function crooked_cavern_midpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("crooked_cavern")
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous revenir\nà l'entrée de " .. zone:GetColoredName() .. " ?", true)
  UI:WaitForChoice()
  local res = UI:ChoiceResult()
  UI:SetCenter(false)
  if res then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
    GROUND:CharEndAnim(hero)
    GAME:WaitFrames(60)
    GAME:EnterGroundMap("crooked_cavern_entrance", "Main_Entrance_Marker")
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage. Reuses the shared, already-French handler
-- (GeneralFunctions.Kangashkhan_Rock_Interact — note the original typo in the name).
function crooked_cavern_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

-- Partner dialogue.
function crooked_cavern_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  crooked_cavern_midpoint_ch_3.Partner_Action(chara, activator)
end

return crooked_cavern_midpoint
