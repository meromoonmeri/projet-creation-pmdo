--[[ Créfadet, la Dernière Résolution — cinématique d'Ancrage (Livre II, ch13).
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

local lac_courage = {}

function lac_courage.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function lac_courage.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 224, 496, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 200, 496, Direction.Up) end
  local crefadet = CharacterEssentials.MakeCharactersFromList({{'Crefadet', 224, 224, Direction.Down}})
  GROUND:Hide('Crefadet')
  GAME:MoveCamera(224, 216, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('last_resolve') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Crefadet')
    UI:SetSpeaker(crefadet)
    UI:WaitShowDialogue("Bien.[pause=10] Tu n'as pas reculé.[pause=20] Voyons si c'est du courage ou de l'orgueil.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("sentier_courage", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA VOLONTÉ N'ATTEND PAS.[pause=10] MOI NON PLUS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — PSY : apparition douce et silencieuse, sans impact.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.WarpSpace(crefadet, 224, 224)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Crefadet')
  GROUND:CharSetAnim(crefadet, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(crefadet, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('lac_courage')
  UI:WaitShowTitle("Créfadet, la Dernière Résolution", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format("Il était déjà là ![pause=20] Depuis le début — il attendait de voir si on OSERAIT !", hero:GetDisplayName()))
  UI:SetSpeaker(crefadet)
  UI:WaitShowDialogue("Bien.[pause=10] Tu n'as pas reculé.[pause=20] Voyons si c'est du courage ou de l'orgueil.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("sentier_courage", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function lac_courage.Update(map, time) end
function lac_courage.GameSave(map) end
function lac_courage.GameLoad(map) end

return lac_courage
