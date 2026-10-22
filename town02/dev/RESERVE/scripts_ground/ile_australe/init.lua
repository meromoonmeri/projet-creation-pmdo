--[[ Lunala, l'Autre Lumière — cinématique d'Ancrage (Livre II, ch31).
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

local ile_australe = {}

function ile_australe.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function ile_australe.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 168, 328, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 144, 328, Direction.Up) end
  local lunala = CharacterEssentials.MakeCharactersFromList({{'Lunala', 224, 192, Direction.Down}})
  GROUND:Hide('Lunala')
  GAME:MoveCamera(224, 184, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('two_lights_lunala') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Lunala')
    UI:SetSpeaker(lunala)
    UI:WaitShowDialogue("Mon frère vous a jugés au soleil.[pause=20] Moi, je regarde ce que vous êtes dans le noir.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("chapelle_nuit", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("ET LA LUNE VOLE, DIT LE CONTE,[pause=10] SUR DES AILES DE NUIT COUSUES D'ÉTOILES.[pause=30] LA VOICI.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  SOUND:StopBGM()
  BossFX.EmergeShadow(lunala, 224, 192)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Lunala')
  GROUND:CharSetAnim(lunala, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(lunala, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('ile_australe')
  UI:WaitShowTitle("Lunala, l'Autre Lumière", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Il fait nuit d'un coup...[pause=10] mais quelle nuit ![pause=20] Chaque étoile est à sa place — comme un ciel RANGÉ exprès.", hero:GetDisplayName()))
  UI:SetSpeaker(lunala)
  UI:WaitShowDialogue("Mon frère vous a jugés au soleil.[pause=20] Moi, je regarde ce que vous êtes dans le noir.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("chapelle_nuit", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function ile_australe.Update(map, time) end
function ile_australe.GameSave(map) end
function ile_australe.GameLoad(map) end

return ile_australe
