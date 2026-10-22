--[[ Arceus, le Premier Souffle — cinématique d'Ancrage (Livre II, ch32).
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

local escalier_origine = {}

function escalier_origine.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function escalier_origine.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 424, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 424, Direction.Up) end
  local arceus = CharacterEssentials.MakeCharactersFromList({{'Arceus', 232, 184, Direction.Down}})
  GROUND:Hide('Arceus')
  GAME:MoveCamera(232, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('first_breath') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Arceus')
    UI:SetSpeaker(arceus)
    UI:WaitShowDialogue("Vous avez stabilisé ce que mes enfants gardaient.[pause=30] Une dernière question, alors :[pause=20] à qui confierai-je le monde, désormais ?")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("tour_origine", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("AVANT LE PREMIER ANCRAGE, AVANT LE PREMIER GARDIEN,[pause=20] IL Y EUT UN SOUFFLE.[pause=30] VOUS L'AVEZ SUIVI JUSQU'ICI.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — DIVIN : le seul effet ou l'ecran ne tremble pas. Rien ne s'impose.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.RadiantDawn(arceus, 232, 184)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Arceus')
  GROUND:CharSetAnim(arceus, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(arceus, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('escalier_origine')
  UI:WaitShowTitle("Arceus, le Premier Souffle", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Chaque marche qu'on a montée...[pause=20] je crois qu'elle n'existait pas avant qu'on la monte, {0}.", hero:GetDisplayName()))
  UI:SetSpeaker(arceus)
  UI:WaitShowDialogue("Vous avez stabilisé ce que mes enfants gardaient.[pause=30] Une dernière question, alors :[pause=20] à qui confierai-je le monde, désormais ?")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("tour_origine", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function escalier_origine.Update(map, time) end
function escalier_origine.GameSave(map) end
function escalier_origine.GameLoad(map) end

return escalier_origine
