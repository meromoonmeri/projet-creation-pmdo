--[[ Mew et Hoopa, le Premier Berceau — cinématique d'Ancrage (Livre II, ch26).
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

local arene_clairiere_secrete = {}

function arene_clairiere_secrete.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function arene_clairiere_secrete.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 496, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 496, Direction.Up) end
  local mew = CharacterEssentials.MakeCharactersFromList({{'Mew', 252, 224, Direction.Down}})
  GROUND:Hide('Mew')
  local hoopa = CharacterEssentials.MakeCharactersFromList({{'Hoopa', 292, 224, Direction.Down}})
  GROUND:Hide('Hoopa')
  GAME:MoveCamera(272, 216, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('first_cradle') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Mew')
    GROUND:Unhide('Hoopa')
    UI:SetSpeaker(mew)
    UI:WaitShowDialogue("Alohomora ![pause=10] Tout ce qui entre dans mes anneaux est à moi ![pause=20] Toi aussi, si tu perds !")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("bois_enchevetres", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("HIHI.[pause=20] ILS SONT VENUS JUSQU'ICI.[pause=10] ON JOUE ?")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.Flash(252 - 40, 224, 3, 3, 6)
  BossFX.Flash(252 + 40, 224, 3, 3, 6)
  GROUND:Unhide('Mew')
  GAME:WaitFrames(25)
  BossFX.Flash(292 - 40, 224, 3, 3, 6)
  BossFX.Flash(292 + 40, 224, 3, 3, 6)
  GROUND:Unhide('Hoopa')
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Mew')
  GROUND:CharSetAnim(mew, "Attack", false)
  GROUND:Unhide('Hoopa')
  GROUND:CharSetAnim(hoopa, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(mew, "Idle", true)
  GROUND:CharSetAnim(hoopa, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('arene_clairiere_secrete')
  UI:WaitShowTitle("Mew et Hoopa, le Premier Berceau", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("Un anneau doré vient de... d'AVALER mon sac ?![pause=20] Et cette petite chose rose RIGOLE !", hero:GetDisplayName()))
  UI:SetSpeaker(mew)
  UI:WaitShowDialogue("Alohomora ![pause=10] Tout ce qui entre dans mes anneaux est à moi ![pause=20] Toi aussi, si tu perds !")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("bois_enchevetres", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function arene_clairiere_secrete.Update(map, time) end
function arene_clairiere_secrete.GameSave(map) end
function arene_clairiere_secrete.GameLoad(map) end

return arene_clairiere_secrete
