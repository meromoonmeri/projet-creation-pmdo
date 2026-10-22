--[[ Électhor, le Grand Conducteur — cinématique d'Ancrage (Livre II, ch17).
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

local porte_plaines_foudre = {}

function porte_plaines_foudre.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function porte_plaines_foudre.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 400, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 200, 400, Direction.Up) end
  local electhor = CharacterEssentials.MakeCharactersFromList({{'Electhor', 224, 176, Direction.Down}})
  GROUND:Hide('Electhor')
  GAME:MoveCamera(224, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('high_conductor') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Electhor')
    UI:SetSpeaker(electhor)
    UI:WaitShowDialogue("L'Antenne chante quand je passe.[pause=20] Écoutez-la une dernière fois.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("mt_thunder", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("CHAQUE ÉCLAIR DE CE MONDE PASSE PAR MOI.[pause=20] MÊME CELUI QUI VOUS TUERA.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — ELECTRIQUE : l'oiseau de foudre se forme dans l'orage.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.StrikeThunder(electhor, 224, 176)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Electhor')
  GROUND:CharSetAnim(electhor, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(electhor, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('porte_plaines_foudre')
  UI:WaitShowTitle("Électhor, le Grand Conducteur", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Mes poils se dressent...[pause=10] l'air entier est CHARGÉ ![pause=20] Il ne descend pas — il EST la foudre !", hero:GetDisplayName()))
  UI:SetSpeaker(electhor)
  UI:WaitShowDialogue("L'Antenne chante quand je passe.[pause=20] Écoutez-la une dernière fois.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mt_thunder", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function porte_plaines_foudre.Update(map, time) end
function porte_plaines_foudre.GameSave(map) end
function porte_plaines_foudre.GameLoad(map) end

return porte_plaines_foudre
