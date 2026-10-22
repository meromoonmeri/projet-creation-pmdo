--[[ Shaymin, Là où Fleurit le Merci — cinématique d'Ancrage (Livre II, ch15).
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

local champ_sacre = {}

function champ_sacre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function champ_sacre.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 304, Direction.Up) end
  local shaymin = CharacterEssentials.MakeCharactersFromList({{'Shaymin', 232, 176, Direction.Down}})
  GROUND:Hide('Shaymin')
  GAME:MoveCamera(232, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('thanks_bloom') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Shaymin')
    UI:SetSpeaker(shaymin)
    UI:WaitShowDialogue("La gratitude, ça s'arrose.[pause=20] Voyons si la vôtre a des racines !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("jardin_gratitude", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CE CHAMP POUSSE SUR TOUS LES MERCIS DU MONDE.[pause=20] LE VÔTRE EST EN RETARD.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeMist(shaymin, 232, 176)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Shaymin')
  GROUND:CharSetAnim(shaymin, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(shaymin, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('champ_sacre')
  UI:WaitShowTitle("Shaymin, Là où Fleurit le Merci", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format("Des fleurs s'ouvrent PARTOUT où on marche ![pause=20] C'est... c'est le plus joli Ancrage qu'on ait vu !", hero:GetDisplayName()))
  UI:SetSpeaker(shaymin)
  UI:WaitShowDialogue("La gratitude, ça s'arrose.[pause=20] Voyons si la vôtre a des racines !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("jardin_gratitude", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function champ_sacre.Update(map, time) end
function champ_sacre.GameSave(map) end
function champ_sacre.GameLoad(map) end

return champ_sacre
