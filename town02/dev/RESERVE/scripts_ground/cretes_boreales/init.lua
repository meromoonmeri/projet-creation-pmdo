--[[ Latios et Latias, la Faille Jumelle — cinématique d'Ancrage (Livre II, ch24).
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

local cretes_boreales = {}

function cretes_boreales.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function cretes_boreales.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 248, 256, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 224, 256, Direction.Up) end
  local latios = CharacterEssentials.MakeCharactersFromList({{'Latios', 228, 184, Direction.Down}})
  GROUND:Hide('Latios')
  local latias = CharacterEssentials.MakeCharactersFromList({{'Latias', 268, 184, Direction.Down}})
  GROUND:Hide('Latias')
  GAME:MoveCamera(248, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('twin_rift') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Latios')
    GROUND:Unhide('Latias')
    UI:SetSpeaker(latios)
    UI:WaitShowDialogue("Mon frère fonce, je corrige.[pause=10] Il frappe, je protège.[pause=20] Voyons si votre duo vaut le nôtre !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("ile_eon", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("DEUX SILLAGES, UN SEUL CIEL.[pause=20] NE LES SÉPAREZ JAMAIS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.DescendSky(latios, 228, 184, 160)
  GAME:WaitFrames(25)
  BossFX.DescendSky(latias, 268, 184, 160)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Latios')
  GROUND:CharSetAnim(latios, "Attack", false)
  GROUND:Unhide('Latias')
  GROUND:CharSetAnim(latias, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(latios, "Idle", true)
  GROUND:CharSetAnim(latias, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('cretes_boreales')
  UI:WaitShowTitle("Latios et Latias, la Faille Jumelle", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format("Là ![pause=10] Deux traînées de lumière — elles se CROISENT sans jamais se toucher !", hero:GetDisplayName()))
  UI:SetSpeaker(latios)
  UI:WaitShowDialogue("Mon frère fonce, je corrige.[pause=10] Il frappe, je protège.[pause=20] Voyons si votre duo vaut le nôtre !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("ile_eon", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cretes_boreales.Update(map, time) end
function cretes_boreales.GameSave(map) end
function cretes_boreales.GameLoad(map) end

return cretes_boreales
