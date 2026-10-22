--[[ Artikodin, le Pas Dégelé — cinématique d'Ancrage (Livre II, ch17).
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

local champ_vent_boreal = {}

function champ_vent_boreal.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function champ_vent_boreal.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 176, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 176, Direction.Up) end
  local artikodin = CharacterEssentials.MakeCharactersFromList({{'Artikodin', 176, 136, Direction.Down}})
  GROUND:Hide('Artikodin')
  GAME:MoveCamera(176, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('thawed_step') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Artikodin')
    UI:SetSpeaker(artikodin)
    UI:WaitShowDialogue("Vous avez marché longtemps dans mon silence.[pause=20] Voyons si vous savez aussi y combattre.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("frosty_forest", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  -- Signature d'Artikodin : PAS de voix. Le silence est le signal.
  GAME:WaitFrames(80)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  SOUND:StopBGM()
  GAME:WaitFrames(40)
  BossFX.DescendSky(artikodin, 176, 136, 160)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Artikodin')
  GROUND:CharSetAnim(artikodin, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(artikodin, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('champ_vent_boreal')
  UI:WaitShowTitle("Artikodin, le Pas Dégelé", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Plus un bruit...[pause=30] même le vent s'est tu.[pause=20] Il neige VERS LE HAUT, {0}...", hero:GetDisplayName()))
  UI:SetSpeaker(artikodin)
  UI:WaitShowDialogue("Vous avez marché longtemps dans mon silence.[pause=20] Voyons si vous savez aussi y combattre.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("frosty_forest", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function champ_vent_boreal.Update(map, time) end
function champ_vent_boreal.GameSave(map) end
function champ_vent_boreal.GameLoad(map) end

return champ_vent_boreal
