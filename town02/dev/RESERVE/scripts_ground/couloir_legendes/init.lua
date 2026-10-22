--[[ Eternatus, la Spirale Éternelle — cinématique d'Ancrage (Livre II, ch32).
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

local couloir_legendes = {}

function couloir_legendes.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function couloir_legendes.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 400, 352, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 376, 352, Direction.Up) end
  local eternatus = CharacterEssentials.MakeCharactersFromList({{'Eternatus', 400, 152, Direction.Down}})
  GROUND:Hide('Eternatus')
  GAME:MoveCamera(400, 144, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('eternal_coil') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Eternatus')
    UI:SetSpeaker(eternatus)
    UI:WaitShowDialogue("Les gardiens m'ont compté en siècles.[pause=20] Je vous compterai en secondes.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("nervure_monde", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("...ENFIN.[pause=40] LE SCEAU N'EST PLUS QU'UN FIL.[pause=30] ET VOUS M'APPORTEZ VOS LUMIÈRES VOUS-MÊMES.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.Rumble({hero, partner}, 4)
  BossFX.EmergeGround(eternatus, 400, 152)
  BossFX.ShakeScreen(5, 60)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Eternatus')
  GROUND:CharSetAnim(eternatus, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(eternatus, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('couloir_legendes')
  UI:WaitShowTitle("Eternatus, la Spirale Éternelle", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("Le couloir entier PULSE en pourpre...[pause=20] {0}, c'est ÇA que les Cœurs retenaient.[pause=10] Depuis toujours.", hero:GetDisplayName()))
  UI:SetSpeaker(eternatus)
  UI:WaitShowDialogue("Les gardiens m'ont compté en siècles.[pause=20] Je vous compterai en secondes.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("nervure_monde", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function couloir_legendes.Update(map, time) end
function couloir_legendes.GameSave(map) end
function couloir_legendes.GameLoad(map) end

return couloir_legendes
