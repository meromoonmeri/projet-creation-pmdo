--[[ Giratina, le Versant Inversé — cinématique d'Ancrage (Livre II, ch29).
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

local grotte_cryptique = {}

function grotte_cryptique.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function grotte_cryptique.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 304, Direction.Up) end
  local giratina = CharacterEssentials.MakeCharactersFromList({{'Giratina', 176, 184, Direction.Down}})
  GROUND:Hide('Giratina')
  GAME:MoveCamera(176, 176, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('reverse_slope') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Giratina')
    UI:SetSpeaker(giratina)
    UI:WaitShowDialogue("Perdus ?[pause=10] Non.[pause=20] Vous êtes exactement là où le monde vous a rangés :[pause=10] à l'envers.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("labyrinthe_perdus", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("ILS M'ONT JETÉ DE L'AUTRE CÔTÉ DU MIROIR.[pause=30] J'AI FAIT DU MIROIR MON ROYAUME.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeShadow(giratina, 176, 184)
  BossFX.ShakeScreen(3, 30)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Giratina')
  GROUND:CharSetAnim(giratina, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(giratina, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('grotte_cryptique')
  UI:WaitShowTitle("Giratina, le Versant Inversé", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Il vient de traverser le MUR ![pause=20] Pas une brèche, pas une porte — le mur PLEIN !", hero:GetDisplayName()))
  UI:SetSpeaker(giratina)
  UI:WaitShowDialogue("Perdus ?[pause=10] Non.[pause=20] Vous êtes exactement là où le monde vous a rangés :[pause=10] à l'envers.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("labyrinthe_perdus", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function grotte_cryptique.Update(map, time) end
function grotte_cryptique.GameSave(map) end
function grotte_cryptique.GameLoad(map) end

return grotte_cryptique
