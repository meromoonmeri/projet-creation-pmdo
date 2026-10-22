--[[ Manaphy, le Berceau des Mers — cinématique d'Ancrage (Livre II, ch16).
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

local recif_genereux = {}

function recif_genereux.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function recif_genereux.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 232, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 200, 232, Direction.Up) end
  local manaphy = CharacterEssentials.MakeCharactersFromList({{'Manaphy', 204, 168, Direction.Down}})
  GROUND:Hide('Manaphy')
  local phione = CharacterEssentials.MakeCharactersFromList({{'Phione', 244, 168, Direction.Down}})
  GROUND:Hide('Phione')
  GAME:MoveCamera(224, 160, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('sea_cradle') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Manaphy')
    GROUND:Unhide('Phione')
    UI:SetSpeaker(manaphy)
    UI:WaitShowDialogue("Le petit et moi, on protège le berceau.[pause=20] Prouvez que vous ne venez pas le briser !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("berceau_mers", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA MER BERCE SON PREMIER-NÉ.[pause=20] GARE À QUI RÉVEILLE LA BERCEUSE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(manaphy, 204, 168)
  GAME:WaitFrames(25)
  BossFX.EmergeWater(phione, 244, 168)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Manaphy')
  GROUND:CharSetAnim(manaphy, "Attack", false)
  GROUND:Unhide('Phione')
  GROUND:CharSetAnim(phione, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(manaphy, "Idle", true)
  GROUND:CharSetAnim(phione, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('recif_genereux')
  UI:WaitShowTitle("Manaphy, le Berceau des Mers", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Un chant...[pause=10] sous l'eau ?[pause=20] Le récif entier fredonne avec eux !", hero:GetDisplayName()))
  UI:SetSpeaker(manaphy)
  UI:WaitShowDialogue("Le petit et moi, on protège le berceau.[pause=20] Prouvez que vous ne venez pas le briser !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("berceau_mers", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function recif_genereux.Update(map, time) end
function recif_genereux.GameSave(map) end
function recif_genereux.GameLoad(map) end

return recif_genereux
