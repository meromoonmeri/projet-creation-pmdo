--[[ Solgaleo, la Première Lumière — cinématique d'Ancrage (Livre II, ch31).
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

local ile_legendaire = {}

function ile_legendaire.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function ile_legendaire.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 248, 256, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 224, 256, Direction.Up) end
  local solgaleo = CharacterEssentials.MakeCharactersFromList({{'Solgaleo', 248, 168, Direction.Down}})
  GROUND:Hide('Solgaleo')
  GAME:MoveCamera(248, 160, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('two_lights') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Solgaleo')
    UI:SetSpeaker(solgaleo)
    UI:WaitShowDialogue("Chaque histoire a besoin d'un soleil.[pause=20] Prouvez que la vôtre mérite le sien.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("conte_sans_fin", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LE CONTE DIT :[pause=10] LE SOLEIL MARCHE, FAUVE À LA CRINIÈRE D'ACIER.[pause=20] LE CONTE NE MENT PAS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — LUMIERE : le soleil se leve dans la salle.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.RadiantDawn(solgaleo, 248, 168)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Solgaleo')
  GROUND:CharSetAnim(solgaleo, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(solgaleo, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('ile_legendaire')
  UI:WaitShowTitle("Solgaleo, la Première Lumière", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Happy")
  UI:WaitShowDialogue(STRINGS:Format("L'aube...[pause=10] en PLEIN midi ?![pause=20] Sa crinière — c'est elle qui éclaire l'île entière !", hero:GetDisplayName()))
  UI:SetSpeaker(solgaleo)
  UI:WaitShowDialogue("Chaque histoire a besoin d'un soleil.[pause=20] Prouvez que la vôtre mérite le sien.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("conte_sans_fin", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function ile_legendaire.Update(map, time) end
function ile_legendaire.GameSave(map) end
function ile_legendaire.GameLoad(map) end

return ile_legendaire
