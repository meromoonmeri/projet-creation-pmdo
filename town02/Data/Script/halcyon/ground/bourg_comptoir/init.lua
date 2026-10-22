--[[
     Bourg du Comptoir — carte de ville (chapitre 11 et au-dela).

     Provenance : ground converti depuis le lot Explorers (treasure_town).
     La geometrie et les collisions sont celles de la source, au bit pres.
     Les entites (18 habitants, panneaux, echoppes, sorties) ont ete
     restaurees depuis la source le 2026-08-02 par
     tools/restore_eoso_entities.py, avec application de la table
     d'evolution : le Bourg est visite une dizaine d'annees plus tard,
     ses habitants ont grandi.

     Reseau canonique restaure (identique a la source) :
       ouest  -> cap_dents_mer       (falaise du bord de mer)
       est    -> carrefour_assemblee (carrefour de l'Assemblee)
       centre -> dojo_ossatueur      (dojo de Maitre Ossovan)
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.ComptoirVoices'
require 'halcyon.LivingWorld'
require 'halcyon.future_arc.FutureArc'
require 'halcyon.future_arc.dungeon55_events'
require 'halcyon.ground.bourg_comptoir.bourg_comptoir_ch_11'

local bourg_comptoir = {}

function bourg_comptoir.Init(map)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_bourg_comptoir")
  pcall(function() LivingWorld.SyncStory(); LivingWorld.ApplyOutdoor(true) end)
  pcall(function() GAME:FadeOut(false, 1) end)
  pcall(function() GAME:CutsceneMode(true) end)
  COMMON.RespawnAllies()
  pcall(function() PartnerEssentials.InitializePartnerSpawn() end)

  -- Si aucune cinematique n'est a venir, on rend la main tout de suite.
  pcall(function()
    local sceneAVenir = false
    if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter >= 11 then
      sceneAVenir = not SV.Chapter11.FinishedTreasureTownIntro
        or FutureArc.IsPresentReturnPending()
        or Dungeon55Events.IsReturnPending()
    end
    if not sceneAVenir then GAME:CutsceneMode(false) end
  end)
end

function bourg_comptoir.Enter(map)
  bourg_comptoir.PlotScripting()
end

function bourg_comptoir.Update(map, time) end

function bourg_comptoir.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function bourg_comptoir.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  bourg_comptoir.PlotScripting()
end

function bourg_comptoir.PlotScripting()
  -- Migration des sauvegardes créées avec l'ancien flag posé à la Mare :
  -- aucune d'elles n'a pu voir l'arrivée, on la rejoue exactement une fois.
  if SV.Chapter11 ~= nil
      and (tonumber(SV.Chapter11.TreasureTownArrivalVersion) or 0) < 1 then
    SV.Chapter11.FinishedTreasureTownIntro = false
  end

  if SV.ChapterProgression ~= nil and SV.ChapterProgression.Chapter >= 11 then
    if not SV.Chapter11.FinishedTreasureTownIntro then
      bourg_comptoir_ch_11.ArrivalCutscene()
      return
    end

    bourg_comptoir_ch_11.SetupGround()
    if FutureArc.IsPresentReturnPending() then
      FutureArc.PlayPresentReturn()
    elseif Dungeon55Events.IsReturnPending() then
      Dungeon55Events.PlayReturn()
    end
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- HABITANTS
-- Un handler par entite de la carte. Le propos est tenu par
-- ComptoirVoices, qui gere les variantes et le repli.
--------------------------------------------------------------------
local HABITANTS = {
  'Bibarel', 'Azumarill', 'Marill_Jeune', 'Hypno', 'Dusclops',
  'Banette', 'Beautifly', 'Nuzleaf', 'Pidgeot', 'Crawdaunt',
  'Slaking', 'Swellow', 'Electivire', 'Xatu', 'Kangaskhan',
  'Kecleon', 'PurpleKecleon', 'Murkrow',
}

for _, nom in ipairs(HABITANTS) do
  bourg_comptoir[nom .. '_Action'] = function(chara, activator)
    DEBUG.EnableDbgCoro()
    ComptoirVoices.Talk(chara, nom)
  end
end

--------------------------------------------------------------------
-- PANNEAUX ET ECHOPPES
--------------------------------------------------------------------
local function Panneau(texte)
  return function(obj, activator)
    DEBUG.EnableDbgCoro()
    pcall(function()
      UI:ResetSpeaker()
      UI:WaitShowDialogue(texte)
    end)
  end
end

bourg_comptoir.SignKangaskhan_Action =
  Panneau("« Depot de la Mere Kanga.[pause=15] Confiez, retirez, l'entrepot ne dort jamais. »")
bourg_comptoir.SignKecleonShop_Action =
  Panneau("« Etals jumeaux.[pause=15] Un frere, une soeur, deux inventaires. »")
bourg_comptoir.SignElectivire_Action =
  Panneau("« Reparations et rachats.[pause=15] Frappez fort, l'enseigne est mal fixee. »")
bourg_comptoir.SignCrossRoads_Action =
  Panneau("« Vers le carrefour de l'Assemblee.[pause=15] De la, toutes les routes. »")

function bourg_comptoir.Shop_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  local chara = CH('Kecleon')
  if chara ~= nil then
    ComptoirVoices.Talk(chara, 'Kecleon')
  else
    pcall(function()
      UI:ResetSpeaker()
      UI:WaitShowDialogue("L'etal est ferme pour le moment.")
    end)
  end
end

function bourg_comptoir.TM_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  local chara = CH('PurpleKecleon')
  if chara ~= nil then
    ComptoirVoices.Talk(chara, 'PurpleKecleon')
  else
    pcall(function()
      UI:ResetSpeaker()
      UI:WaitShowDialogue("L'etal est ferme pour le moment.")
    end)
  end
end

--------------------------------------------------------------------
-- SORTIES — reseau canonique restaure.
--------------------------------------------------------------------
function bourg_comptoir.HabitatSharpedoBluffDayEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("cap_dents_mer", "TreasureTownEntranceMarker")
end

function bourg_comptoir.MarowakDojoEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("dojo_ossatueur", "MarowakDojoExitMarker")
end

function bourg_comptoir.CrossRoadsAssemblyEntrance_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  GAME:EnterGroundMap("carrefour_assemblee", "TreasureTownEntranceMarker")
end

-- Declencheur herite de la scene du chapitre 3 de la source : sans objet
-- dans New Era. Neutralise explicitement plutot que laisse orphelin.
function bourg_comptoir.CH3AzrullSceneMarker_Touch(obj, activator) end

--------------------------------------------------------------------
-- Retour vers Metano Town par Loaklass.
--------------------------------------------------------------------
function bourg_comptoir.Lapras_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then
    partner.IsInteracting = true
    GROUND:CharSetAnim(partner, 'None', true)
  end
  GROUND:CharSetAnim(hero, 'None', true)

  -- Après l'arrivée réparée, Loaklass devient le point d'activation normal
  -- des résonances. Un refus conserve toujours le voyage ordinaire vers Métano.
  if FutureArc.CanOffer() then
    if FutureArc.Offer(chara) then return end
  elseif Dungeon55Events.CanOffer() then
    if Dungeon55Events.Offer(chara) then return end
  end

  UI:SetSpeaker(chara)
  UI:ChoiceMenuYesNo("Souhaitez-vous regagner Metano Town ?", true)
  UI:WaitForChoice()

  if UI:ChoiceResult() then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)

    if partner ~= nil then
      partner.IsInteracting = false
      GROUND:CharEndAnim(partner)
    end
    GROUND:CharEndAnim(hero)

    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue("Le Bourg s'efface derriere la houle, et le continent revient lentement a l'horizon.")
    UI:SetCenter(false)
    GAME:WaitFrames(40)

    GAME:EnterGroundMap("altere_pond", "Main_Entrance_Marker")
  else
    UI:SetSpeaker(chara)
    UI:WaitShowDialogue("Prenez votre temps.[pause=15] La mer ne bougera pas d'ici.")
  end

  if partner ~= nil then
    partner.IsInteracting = false
    GROUND:CharEndAnim(partner)
  end
  GROUND:CharEndAnim(hero)
end

return bourg_comptoir
