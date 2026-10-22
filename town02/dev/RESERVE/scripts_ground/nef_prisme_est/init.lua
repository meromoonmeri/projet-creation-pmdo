--[[ Xerneas, la Vie Donnée — cinématique d'Ancrage (Livre II, ch30).
     Ground template d'origine conservé 1:1 ; dialogues New Era.
     Grammaire Rescue Team : signal -> irruption -> recul -> flash -> reveal
     -> titre -> ligne courte. Rematch : intro raccourcie. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.LegendZones'
require 'halcyon.BossMusic'

local nef_prisme_est = {}

function nef_prisme_est.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function nef_prisme_est.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 320, 520, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 296, 520, Direction.Up) end
  local xerneas = CharacterEssentials.MakeCharactersFromList({{'Xerneas', 320, 232, Direction.Down}})
  GROUND:Hide('Xerneas')
  GAME:MoveCamera(320, 224, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('given_life') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Xerneas')
    UI:SetSpeaker(xerneas)
    UI:WaitShowDialogue("La vie que je donne, je peux la reprendre.[pause=20] Montrez-moi que la vôtre est bien employée.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("iles_prismatiques", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("J'AI DONNÉ LA VIE SI SOUVENT QUE J'AI OUBLIÉ D'EN GARDER POUR MOI.[pause=20] CETTE NEF EST MON DERNIER JARDIN.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.AwakenCrystal(xerneas, 320, 232)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Xerneas')
  GROUND:CharSetAnim(xerneas, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(xerneas, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('nef_prisme_est')
  UI:WaitShowTitle("Xerneas, la Vie Donnée", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format("Les bois de la nef...[pause=10] ils FLEURISSENT sur son passage ![pause=20] Chaque pas fait pousser quelque chose !", hero:GetDisplayName()))
  UI:SetSpeaker(xerneas)
  UI:WaitShowDialogue("La vie que je donne, je peux la reprendre.[pause=20] Montrez-moi que la vôtre est bien employée.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("iles_prismatiques", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function nef_prisme_est.Update(map, time) end
function nef_prisme_est.GameSave(map) end
function nef_prisme_est.GameLoad(map) end

return nef_prisme_est
