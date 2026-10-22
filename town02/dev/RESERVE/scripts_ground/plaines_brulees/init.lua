--[[ Entei et Victini, la Veillée des Braises — cinématique d'Ancrage (Livre II, ch22).
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

local plaines_brulees = {}

function plaines_brulees.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function plaines_brulees.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 216, 328, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 328, Direction.Up) end
  local entei = CharacterEssentials.MakeCharactersFromList({{'Entei', 196, 216, Direction.Down}})
  GROUND:Hide('Entei')
  local victini = CharacterEssentials.MakeCharactersFromList({{'Victini', 236, 216, Direction.Down}})
  GROUND:Hide('Victini')
  GAME:MoveCamera(216, 208, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('ember_vigil') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Entei')
    GROUND:Unhide('Victini')
    UI:SetSpeaker(entei)
    UI:WaitShowDialogue("Il dit que vous allez perdre.[pause=10] Moi je dis que non ![pause=20] Départagez-nous !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("fiery_field", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("DEUX FEUX VEILLENT ICI.[pause=20] LE GRAND QUI GRONDE.[pause=10] ET LE PETIT QUI NE PERD JAMAIS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeFire(entei, 196, 216)
  GAME:WaitFrames(25)
  BossFX.EmergeFire(victini, 236, 216)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Entei')
  GROUND:CharSetAnim(entei, "Attack", false)
  GROUND:Unhide('Victini')
  GROUND:CharSetAnim(victini, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(entei, "Idle", true)
  GROUND:CharSetAnim(victini, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('plaines_brulees')
  UI:WaitShowTitle("Entei et Victini, la Veillée des Braises", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Un volcan qui marche...[pause=20] et une étincelle qui DANSE autour de lui ?!", hero:GetDisplayName()))
  UI:SetSpeaker(entei)
  UI:WaitShowDialogue("Il dit que vous allez perdre.[pause=10] Moi je dis que non ![pause=20] Départagez-nous !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("fiery_field", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function plaines_brulees.Update(map, time) end
function plaines_brulees.GameSave(map) end
function plaines_brulees.GameLoad(map) end

return plaines_brulees
