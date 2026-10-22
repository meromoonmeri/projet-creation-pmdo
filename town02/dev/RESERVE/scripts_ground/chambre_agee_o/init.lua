--[[ Palkia, la Colline Spatiale — cinématique d'Ancrage (Livre II, ch28).
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

local chambre_agee_o = {}

function chambre_agee_o.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function chambre_agee_o.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 232, 304, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 208, 304, Direction.Up) end
  local palkia = CharacterEssentials.MakeCharactersFromList({{'Palkia', 232, 200, Direction.Down}})
  GROUND:Hide('Palkia')
  GAME:MoveCamera(232, 192, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('spatial_hill') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Palkia')
    UI:SetSpeaker(palkia)
    UI:WaitShowDialogue("L'espace plie où je veux.[pause=20] Voyons où VOUS pliez.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("grotte_gravee", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LA DISTANCE EST UN MENSONGE QUE JE RACONTE AU MONDE.[pause=20] APPROCHEZ.[pause=10] OU L'AI-JE DÉJÀ FAIT POUR VOUS ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption — ESPACE : l'espace se plie. Il n'arrive jamais — il est simplement la.
  --    Avant ce lot : un BossFX.Flash generique, identique a 10 autres
  --    arenes. Toutes les particules employees sont attestees.
  BossFX.WarpSpace(palkia, 232, 200)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Palkia')
  GROUND:CharSetAnim(palkia, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(palkia, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('chambre_agee_o')
  UI:WaitShowTitle("Palkia, la Colline Spatiale", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("La salle est plus GRANDE à l'intérieur ![pause=20] On a marché dix pas et reculé de cent !", hero:GetDisplayName()))
  UI:SetSpeaker(palkia)
  UI:WaitShowDialogue("L'espace plie où je veux.[pause=20] Voyons où VOUS pliez.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("grotte_gravee", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function chambre_agee_o.Update(map, time) end
function chambre_agee_o.GameSave(map) end
function chambre_agee_o.GameLoad(map) end

return chambre_agee_o
