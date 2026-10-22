--[[ Keldeo, le Gué de la Résolution — cinématique d'Ancrage (Livre II, ch18).
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

local gue_poulain_autel = {}

function gue_poulain_autel.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function gue_poulain_autel.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 736, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 736, Direction.Up) end
  local keldeo = CharacterEssentials.MakeCharactersFromList({{'Keldeo', 272, 344, Direction.Down}})
  GROUND:Hide('Keldeo')
  GAME:MoveCamera(272, 336, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('resolute_ford') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Keldeo')
    UI:SetSpeaker(keldeo)
    UI:WaitShowDialogue("Mes maîtres m'ont appris à ne jamais fuir ![pause=20] Montrez-moi vos résolutions — je vous montrerai ma corne !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("gue_poulain", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("UN POULAIN S'ENTRAÎNE ICI POUR MÉRITER SA PROPRE CORNE.[pause=20] RESPECTEZ CELA.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(keldeo, 272, 344)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Keldeo')
  GROUND:CharSetAnim(keldeo, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(keldeo, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('gue_poulain_autel')
  UI:WaitShowTitle("Keldeo, le Gué de la Résolution", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("L'eau tient tête au courant...[pause=20] et lui, il tient tête à l'OCÉAN entier !", hero:GetDisplayName()))
  UI:SetSpeaker(keldeo)
  UI:WaitShowDialogue("Mes maîtres m'ont appris à ne jamais fuir ![pause=20] Montrez-moi vos résolutions — je vous montrerai ma corne !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("gue_poulain", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gue_poulain_autel.Update(map, time) end
function gue_poulain_autel.GameSave(map) end
function gue_poulain_autel.GameLoad(map) end

return gue_poulain_autel
