--[[ Créfollet, le Sentiment Gardé — cinématique d'Ancrage (Livre II, ch13).
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

local lac_espoir = {}

function lac_espoir.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function lac_espoir.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 200, 448, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 176, 448, Direction.Up) end
  local crefollet = CharacterEssentials.MakeCharactersFromList({{'Crefollet', 200, 200, Direction.Down}})
  GROUND:Hide('Crefollet')
  GAME:MoveCamera(200, 192, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('kept_feeling') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Crefollet')
    UI:SetSpeaker(crefollet)
    UI:WaitShowDialogue("L'émotion est la première lumière.[pause=20] Prouve que la tienne ne vacille pas.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("sentier_espoir", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("TON CŒUR BAT TROP FORT POUR UN SIMPLE VOYAGEUR.[pause=20] QUE PROTÈGES-TU ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(crefollet, 200, 200)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Crefollet')
  GROUND:CharSetAnim(crefollet, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(crefollet, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('lac_espoir')
  UI:WaitShowTitle("Créfollet, le Sentiment Gardé", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Le lac reflète nos visages...[pause=20] mais pas nos expressions.[pause=10] Regarde, il nous montre... de l'espoir ?", hero:GetDisplayName()))
  UI:SetSpeaker(crefollet)
  UI:WaitShowDialogue("L'émotion est la première lumière.[pause=20] Prouve que la tienne ne vacille pas.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("sentier_espoir", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function lac_espoir.Update(map, time) end
function lac_espoir.GameSave(map) end
function lac_espoir.GameLoad(map) end

return lac_espoir
