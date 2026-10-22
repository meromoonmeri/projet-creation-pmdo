--[[
    init.lua
    Gloomy Forest midpoint — mid-dungeon relay (checkpoint) for chapter 6.
    Modeled on ground/crooked_cavern_midpoint/init.lua (itself modeled on searing_tunnel_midpoint).
    See docs/audit_checkpoint_crooked_cavern.md (reusable pattern).
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ground.gloomy_forest_midpoint.gloomy_forest_midpoint_ch_6'

local gloomy_forest_midpoint = {}

-------------------------------
-- Map Callbacks
-------------------------------
function gloomy_forest_midpoint.Init(map)
  DEBUG.EnableDbgCoro()
  print('=>> Init_gloomy_forest_midpoint <<=')
  PrintInfo('[SINISTER_ROUTE] midpoint Init before RespawnAllies')
  COMMON.RespawnAllies(true)
  PrintInfo('[SINISTER_ROUTE] midpoint Init after RespawnAllies')
  PartnerEssentials.InitializePartnerSpawn()
  PrintInfo('[SINISTER_ROUTE] midpoint Init after InitializePartnerSpawn')
end

function gloomy_forest_midpoint.Enter(map)
	if SV.Chapter5.PlayedMidpointIntro == nil then SV.Chapter5.PlayedMidpointIntro = false end
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.Exit(map)
end

function gloomy_forest_midpoint.Update(map)
end

function gloomy_forest_midpoint.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

-- Reprise d'une sauvegarde faite AU relais (rocher de Kangourex).
-- Ce relais n'a pas de sortie arriere : la sauvegarde est donc le seul
-- retour « a l'amiable » possible ici. On arme l'etat correspondant,
-- sauf si l'intro n'a pas encore tourne ou si un reveil apres KO attend.
function gloomy_forest_midpoint.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  if SV.ChapterProgression.Chapter == 6
     and SV.Chapter6.GloomyPlayedMidpointIntro
     and not SV.GloomyForest.DiedPastCheckpoint then
    SV.Chapter6.GloomyMidReturn = true
  end
  gloomy_forest_midpoint.PlotScripting()
end

function gloomy_forest_midpoint.PlotScripting()
  -- Canonical validation route: the New Era Dazzling trial is supplemental
  -- and disabled. This Ground only provides checkpoint/heal/save/rest.

  -- ROUTEUR DU POINT MEDIAN — meme ordre de branches que le Tunnel
  -- Incandescent et le Mont Venteux (template partage).
  if SV.ChapterProgression.Chapter == 6 then
    if not SV.Chapter6.GloomyPlayedMidpointIntro then
      gloomy_forest_midpoint_ch_6.FirstArrival()
    elseif SV.GloomyForest.DiedPastCheckpoint then
      SV.Chapter6.GloomyMidReturn = false
      gloomy_forest_midpoint_ch_6.WipedCutscene()
    elseif SV.Chapter6.GloomyMidReturn then
      --Retour a l'amiable : reprise d'une sauvegarde faite au relais.
      --Drapeau consomme aussitot pour ne jouer qu'une fois par retour.
      SV.Chapter6.GloomyMidReturn = false
      gloomy_forest_midpoint_ch_6.RepeatArrival()
    else
      gloomy_forest_midpoint_ch_6.SetupGround()
    end
  else
    GAME:FadeIn(20)
  end
end

------------------------------- 
-- Entities Callbacks
-------------------------------
-- Forward exit (the ONLY way out). Continues into segment 1 (depth floors).
-- No backward exit (spec: no return to the first half). Leaving the run entirely
-- is done via the Kangaskhan Rock's "Sauvegarder et quitter." option.
function gloomy_forest_midpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  partner.IsInteracting = true
  GROUND:CharSetAnim(partner, 'None', true)
  GROUND:CharSetAnim(hero, 'None', true)
  UI:ChoiceMenuYesNo("Souhaitez-vous continuer vers les profondeurs de la forêt ?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    gloomy_forest_midpoint_ch_6.ContinueScene()
  end
  partner.IsInteracting = false
  GROUND:CharEndAnim(partner)
  GROUND:CharEndAnim(hero)
end

-- Kangaskhan Rock: save + storage. Reuses the shared, already-French handler.
function gloomy_forest_midpoint.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

-- Partner dialogue.
function gloomy_forest_midpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Partner_Action(chara, activator)
end

-- L'Epreuve des Trois. Adagio lance le duel, les deux autres commentent.
function gloomy_forest_midpoint.Adagio_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Adagio_Action(chara, activator)
end

function gloomy_forest_midpoint.Aria_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Aria_Action(chara, activator)
end

function gloomy_forest_midpoint.Sonata_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  gloomy_forest_midpoint_ch_6.Sonata_Action(chara, activator)
end

return gloomy_forest_midpoint
