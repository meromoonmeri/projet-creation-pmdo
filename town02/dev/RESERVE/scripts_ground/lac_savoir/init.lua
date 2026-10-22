--[[ Créhelf, la Mémoire du Lac — cinématique d'Ancrage (Livre II, ch13).
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

local lac_savoir = {}

function lac_savoir.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function lac_savoir.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 400, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 400, Direction.Up) end
  local crehelf = CharacterEssentials.MakeCharactersFromList({{'Crehelf', 176, 176, Direction.Down}})
  GROUND:Hide('Crehelf')
  GAME:MoveCamera(176, 168, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('quiet_ledger') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Crehelf')
    UI:SetSpeaker(crehelf)
    UI:WaitShowDialogue("Je n'ouvre les yeux qu'une fois.[pause=20] Fais que cela en vaille la peine.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("sentier_savoir", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("J'AI VU TOUT CE QUI FUT.[pause=30] VEUX-TU VRAIMENT QUE JE TE REGARDE ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeMist(crehelf, 176, 176)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Crehelf')
  GROUND:CharSetAnim(crehelf, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(crehelf, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('lac_savoir')
  UI:WaitShowTitle("Créhelf, la Mémoire du Lac", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("La brume...[pause=10] elle se souvient de nous, {0}.[pause=20] Comme si on était déjà venus.", hero:GetDisplayName()))
  UI:SetSpeaker(crehelf)
  UI:WaitShowDialogue("Je n'ouvre les yeux qu'une fois.[pause=20] Fais que cela en vaille la peine.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("sentier_savoir", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function lac_savoir.Update(map, time) end
function lac_savoir.GameSave(map) end
function lac_savoir.GameLoad(map) end

return lac_savoir
