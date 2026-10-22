--[[ Sulfura, la Longue Cendre — cinématique d'Ancrage (Livre II, ch14).
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

local champ_braises = {}

function champ_braises.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function champ_braises.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 176, 176, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 152, 176, Direction.Up) end
  local sulfura = CharacterEssentials.MakeCharactersFromList({{'Sulfura', 176, 136, Direction.Down}})
  GROUND:Hide('Sulfura')
  GAME:MoveCamera(176, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('long_ash') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Sulfura')
    UI:SetSpeaker(sulfura)
    UI:WaitShowDialogue("Mon feu ne détruit que ce qui doit tomber.[pause=20] Tenez debout, et il vous éclairera.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("mt_blaze", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("LES CENDRES MONTENT.[pause=20] C'EST QUE LE FEU, EN BAS, S'EST SOUVENU DE VOUS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeFire(sulfura, 176, 136)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Sulfura')
  GROUND:CharSetAnim(sulfura, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(sulfura, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('champ_braises')
  UI:WaitShowTitle("Sulfura, la Longue Cendre", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Ces flammes ne brûlent pas la pierre...[pause=20] elles l'ÉCLAIRENT. C'est un gardien, {0} !", hero:GetDisplayName()))
  UI:SetSpeaker(sulfura)
  UI:WaitShowDialogue("Mon feu ne détruit que ce qui doit tomber.[pause=20] Tenez debout, et il vous éclairera.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("mt_blaze", 5, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function champ_braises.Update(map, time) end
function champ_braises.GameSave(map) end
function champ_braises.GameLoad(map) end

return champ_braises
