--[[ Marshadow, la Seule Ombre — cinématique d'Ancrage (Livre II, ch26).
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

local creux_ombres_scelle = {}

function creux_ombres_scelle.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function creux_ombres_scelle.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 320, 520, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 296, 520, Direction.Up) end
  local marshadow = CharacterEssentials.MakeCharactersFromList({{'Marshadow', 320, 232, Direction.Down}})
  GROUND:Hide('Marshadow')
  GAME:MoveCamera(320, 224, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('only_shadow') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Marshadow')
    UI:SetSpeaker(marshadow)
    UI:WaitShowDialogue("...")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("creux_ombres", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("VOUS M'AVEZ MARCHÉ DESSUS DEPUIS LE PREMIER ÉTAGE.[pause=30] JE SUIS TOUTES LES OMBRES ICI.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeShadow(marshadow, 320, 232)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Marshadow')
  GROUND:CharSetAnim(marshadow, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(marshadow, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('creux_ombres_scelle')
  UI:WaitShowTitle("Marshadow, la Seule Ombre", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("{0}...[pause=20] ton ombre.[pause=10] ELLE S'EST LEVÉE TOUTE SEULE.", hero:GetDisplayName()))
  UI:SetSpeaker(marshadow)
  UI:WaitShowDialogue("...")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("creux_ombres", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function creux_ombres_scelle.Update(map, time) end
function creux_ombres_scelle.GameSave(map) end
function creux_ombres_scelle.GameLoad(map) end

return creux_ombres_scelle
