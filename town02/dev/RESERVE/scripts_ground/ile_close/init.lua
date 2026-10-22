--[[ Necrozma, la Lumière Empruntée — cinématique d'Ancrage (Livre II, ch32).
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

local ile_close = {}

function ile_close.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function ile_close.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 328, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 328, Direction.Up) end
  local necrozma = CharacterEssentials.MakeCharactersFromList({{'Necrozma', 232, 200, Direction.Down}})
  GROUND:Hide('Necrozma')
  GAME:MoveCamera(232, 192, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('borrowed_light') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Necrozma')
    UI:SetSpeaker(necrozma)
    UI:WaitShowDialogue("Chaque lumière que j'ai prise dort dans mes prismes,[pause=10] loin de LUI.[pause=30] Battez-moi si vous voulez.[pause=10] Mais quand les prismes tomberont...[pause=20] courez.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("sentier_eteint", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("ON M'A TRAITÉ DE VOLEUR.[pause=30] MAIS QUAND ON EMPRUNTE POUR SCELLER UN MONSTRE...[pause=20] QUI EST LE VOLEUR ? MOI, OU CELUI QUI REPREND ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — LUMIERE VOLEE : meme montee, mais le flash est long et froid.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.RadiantDawn(necrozma, 232, 200)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Necrozma')
  GROUND:CharSetAnim(necrozma, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(necrozma, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('ile_close')
  UI:WaitShowTitle("Necrozma, la Lumière Empruntée", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("C'est lui...[pause=20] celui des visions du Pic Céleste.[pause=10] Celui qui LUTTAIT.[pause=20] {0}... et si on s'était trompés depuis le début ?", hero:GetDisplayName()))
  UI:SetSpeaker(necrozma)
  UI:WaitShowDialogue("Chaque lumière que j'ai prise dort dans mes prismes,[pause=10] loin de LUI.[pause=30] Battez-moi si vous voulez.[pause=10] Mais quand les prismes tomberont...[pause=20] courez.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("sentier_eteint", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function ile_close.Update(map, time) end
function ile_close.GameSave(map) end
function ile_close.GameLoad(map) end

return ile_close
