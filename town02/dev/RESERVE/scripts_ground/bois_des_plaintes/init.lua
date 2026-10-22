--[[ Suicune, le Gué des Eaux Claires — cinématique d'Ancrage (Livre II, ch25).
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

local bois_des_plaintes = {}

function bois_des_plaintes.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function bois_des_plaintes.Enter(map)
  DEBUG.EnableDbgCoro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 160, 272, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 136, 272, Direction.Up) end
  local suicune = CharacterEssentials.MakeCharactersFromList({{'Suicune', 176, 136, Direction.Down}})
  GROUND:Hide('Suicune')
  GAME:MoveCamera(176, 128, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('clearwater_ford') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Suicune')
    UI:SetSpeaker(suicune)
    UI:WaitShowDialogue("Je purifie ce que je touche.[pause=20] Voyons ce qu'il restera de vous.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("northwind_field", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("L'EAU QUE VOUS AVEZ BUE AUJOURD'HUI M'A TRAVERSÉ HIER.[pause=20] NOUS SOMMES DÉJÀ LIÉS.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeMist(suicune, 176, 136)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Suicune')
  GROUND:CharSetAnim(suicune, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(suicune, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('bois_des_plaintes')
  UI:WaitShowTitle("Suicune, le Gué des Eaux Claires", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  UI:WaitShowDialogue(STRINGS:Format("L'eau du gué est devenue... parfaitement claire.[pause=20] On voit chaque pierre du fond. C'est LUI qui fait ça ?", hero:GetDisplayName()))
  UI:SetSpeaker(suicune)
  UI:WaitShowDialogue("Je purifie ce que je touche.[pause=20] Voyons ce qu'il restera de vous.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("northwind_field", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function bois_des_plaintes.Update(map, time) end
function bois_des_plaintes.GameSave(map) end
function bois_des_plaintes.GameLoad(map) end

return bois_des_plaintes
