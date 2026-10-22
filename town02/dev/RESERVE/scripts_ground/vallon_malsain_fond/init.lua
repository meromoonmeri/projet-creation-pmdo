--[[ Yveltal, le Cocon de la Ruine — cinématique d'Ancrage (Livre II, ch29).
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

local vallon_malsain_fond = {}

function vallon_malsain_fond.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function vallon_malsain_fond.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 248, 472, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 224, 472, Direction.Up) end
  local yveltal = CharacterEssentials.MakeCharactersFromList({{'Yveltal', 248, 208, Direction.Down}})
  GROUND:Hide('Yveltal')
  GAME:MoveCamera(248, 200, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('final_rest') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Yveltal')
    UI:SetSpeaker(yveltal)
    UI:WaitShowDialogue("Je dors pour que le monde vive.[pause=20] Vous m'avez réveillé.[pause=10] Assumez.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("vallon_malsain", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("TOUT CE QUI VIT M'EST PROMIS.[pause=30] JE NE PRENDS JAMAIS D'AVANCE.[pause=20] SAUF SI ON ME DÉRANGE.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  SOUND:StopBGM()
  GAME:WaitFrames(40)
  BossFX.DescendSky(yveltal, 248, 208, 160)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Yveltal')
  GROUND:CharSetAnim(yveltal, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(yveltal, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('vallon_malsain_fond')
  UI:WaitShowTitle("Yveltal, le Cocon de la Ruine", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Les arbres gris...[pause=10] ils ne pourrissent pas, ils sont VIDÉS.[pause=20] Et ce cocon géant vient de s'ouvrir...", hero:GetDisplayName()))
  UI:SetSpeaker(yveltal)
  UI:WaitShowDialogue("Je dors pour que le monde vive.[pause=20] Vous m'avez réveillé.[pause=10] Assumez.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("vallon_malsain", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function vallon_malsain_fond.Update(map, time) end
function vallon_malsain_fond.GameSave(map) end
function vallon_malsain_fond.GameLoad(map) end

return vallon_malsain_fond
