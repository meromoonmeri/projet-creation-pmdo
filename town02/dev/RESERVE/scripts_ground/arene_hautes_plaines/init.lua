--[[ Raikou, la Cloche des Orages — cinématique d'Ancrage (Livre II, ch16).
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

local arene_hautes_plaines = {}

function arene_hautes_plaines.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function arene_hautes_plaines.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 496, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 496, Direction.Up) end
  local raikou = CharacterEssentials.MakeCharactersFromList({{'Raikou', 272, 224, Direction.Down}})
  GROUND:Hide('Raikou')
  GAME:MoveCamera(272, 216, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('storm_bell') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Raikou')
    UI:SetSpeaker(raikou)
    UI:WaitShowDialogue("Courez si vous voulez.[pause=10] L'orage, c'est moi.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("lightning_field", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE TONNERRE ARRIVE TOUJOURS APRÈS MOI.[pause=20] VOUS ÊTES DÉJÀ EN RETARD.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — ELECTRIQUE : la foudre tombe. Raikou EST la decharge, il n'arrive pas.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.StrikeThunder(raikou, 272, 224)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Raikou')
  GROUND:CharSetAnim(raikou, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(raikou, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('arene_hautes_plaines')
  UI:WaitShowTitle("Raikou, la Cloche des Orages", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Le tonnerre a claqué APRÈS l'éclair...[pause=20] non — APRÈS LUI !", hero:GetDisplayName()))
  UI:SetSpeaker(raikou)
  UI:WaitShowDialogue("Courez si vous voulez.[pause=10] L'orage, c'est moi.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("lightning_field", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function arene_hautes_plaines.Update(map, time) end
function arene_hautes_plaines.GameSave(map) end
function arene_hautes_plaines.GameLoad(map) end

return arene_hautes_plaines
