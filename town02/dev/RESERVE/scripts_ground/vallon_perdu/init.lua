--[[ Deoxys, le Visiteur Tombé — cinématique d'Ancrage (Livre II, ch21).
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

local vallon_perdu = {}

function vallon_perdu.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vallon_perdu.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 200, 264, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 176, 264, Direction.Up) end
  local deoxys = CharacterEssentials.MakeCharactersFromList({{'Deoxys', 200, 192, Direction.Down}})
  GROUND:Hide('Deoxys')
  GAME:MoveCamera(200, 184, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('fallen_visitor') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Deoxys')
    UI:SetSpeaker(deoxys)
    UI:WaitShowDialogue("FORME : ATTAQUE.[pause=20] Vous êtes ma leçon du jour.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("meteor_cave", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("IL EST TOMBÉ DE PLUS LOIN QUE LE CIEL.[pause=30] IL APPREND ENCORE NOS FORMES.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.RockFall(200, 192 - 30)
  BossFX.Flash(200, 192, 4, 6, 10)
  GROUND:Unhide('Deoxys')
  BossFX.Impact(4, true)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Deoxys')
  GROUND:CharSetAnim(deoxys, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(deoxys, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('vallon_perdu')
  UI:WaitShowTitle("Deoxys, le Visiteur Tombé", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Ce cratère au milieu du vallon...[pause=20] ce n'est pas une météorite qui l'a creusé.[pause=10] C'est LUI.", hero:GetDisplayName()))
  UI:SetSpeaker(deoxys)
  UI:WaitShowDialogue("FORME : ATTAQUE.[pause=20] Vous êtes ma leçon du jour.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("meteor_cave", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vallon_perdu.Update(map, time) end
function vallon_perdu.GameSave(map) end
function vallon_perdu.GameLoad(map) end

return vallon_perdu
