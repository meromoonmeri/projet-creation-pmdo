--[[ Zygarde, l'Assemblée des Cellules — cinématique d'Ancrage (Livre II, ch30).
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

local terres_tues_porte = {}

function terres_tues_porte.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function terres_tues_porte.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 216, 392, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 392, Direction.Up) end
  local zygarde = CharacterEssentials.MakeCharactersFromList({{'Zygarde', 216, 232, Direction.Down}})
  GROUND:Hide('Zygarde')
  GAME:MoveCamera(216, 224, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('cells_gathering') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Zygarde')
    UI:SetSpeaker(zygarde)
    UI:WaitShowDialogue("Cent pour cent atteint.[pause=20] L'audit de vos intentions peut commencer.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("ciel_suspendu", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("L'ORDRE N'EST PAS UNE LOI.[pause=20] C'EST UNE SOMME.[pause=10] ET JE SUIS EN TRAIN DE M'ADDITIONNER.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeGround(zygarde, 216, 232)
  BossFX.Impact(2, false)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Zygarde')
  GROUND:CharSetAnim(zygarde, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(zygarde, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('terres_tues_porte')
  UI:WaitShowTitle("Zygarde, l'Assemblée des Cellules", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Ces points verts, partout...[pause=10] ils COULENT les uns vers les autres ![pause=20] Ça prend forme, {0} !", hero:GetDisplayName()))
  UI:SetSpeaker(zygarde)
  UI:WaitShowDialogue("Cent pour cent atteint.[pause=20] L'audit de vos intentions peut commencer.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("ciel_suspendu", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function terres_tues_porte.Update(map, time) end
function terres_tues_porte.GameSave(map) end
function terres_tues_porte.GameLoad(map) end

return terres_tues_porte
