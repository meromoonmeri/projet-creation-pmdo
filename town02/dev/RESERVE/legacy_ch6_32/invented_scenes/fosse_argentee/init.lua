-- [dungeon_builder] recâblage : scène du gardien puis combat sur l'étage d'arène du segment 2 de silver_trench : cinématique et combat au même endroit
--[[ Lugia, le Chœur Englouti — cinématique d'Ancrage (Livre II, ch19).
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

local fosse_argentee = {}

function fosse_argentee.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function fosse_argentee.Enter(map)
  DEBUG.EnableDbgCoro()
  -- === RESEAU DES ANCIENS CHEMINS (new_era_zone_20) ===
  -- Ce ground sert AUSSI de cinematique d'Ancrage (chemin d'origine, plus bas,
  -- inchange). Quand on y arrive depuis la zone Reseau, c'est le Veilleur
  -- qu'on rencontre, pas le gardien d'Ancrage.
  if tostring(_ZONE.CurrentZoneID) == 'new_era_zone_20' then
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    GAME:CutsceneMode(true)
    GROUND:TeleportTo(hero, 272, 336, Direction.Up)
    if partner ~= nil then GROUND:TeleportTo(partner, 248, 336, Direction.Up) end
    local lanterne = CharacterEssentials.MakeCharactersFromList({{'LanterneNoyee', 248, 296, Direction.Down}})
    GROUND:Hide('LanterneNoyee')
    local ancre = CharacterEssentials.MakeCharactersFromList({{'AncreMorte', 296, 296, Direction.Down}})
    GROUND:Hide('AncreMorte')
    GAME:MoveCamera(272, 316, 1, false)
    GAME:FadeIn(40)
    GAME:WaitFrames(30)

    if SV.Reseau ~= nil and SV.Reseau.Veilleurs ~= nil and SV.Reseau.Veilleurs['new_era_zone_20'] then
      GROUND:Unhide('LanterneNoyee')
      GROUND:Unhide('AncreMorte')
      UI:SetSpeaker(lanterne)
      UI:WaitShowDialogue("Encore une descente ?[pause=20] La fosse t'attendait.")
      COMMON.BossTransition()
      GAME:CutsceneMode(false)
      GAME:ContinueDungeon("silver_trench", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
      return
    end

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("DEUX LUEURS DANS L'EAU NOIRE.[pause=20] ELLES DESCENDENT AVEC VOUS.")
    UI:SetCenter(false)
    GAME:WaitFrames(30)

    BossFX.EmergeWater(lanterne, 248, 296)
    GAME:WaitFrames(12)
    BossFX.EmergeShadow(ancre, 296, 296)
    GAME:WaitFrames(20)
    BossFX.PushBack({hero, partner}, Direction.Down)
    GAME:WaitFrames(10)
      GROUND:Unhide('LanterneNoyee')
      GROUND:Unhide('AncreMorte')
    GAME:WaitFrames(18)

    BossMusic.Play('fosse_argentee')
    UI:WaitShowTitle("Lanterne-Noyée et Ancre-Morte, Veilleurs de la Fosse", 20)
    GAME:WaitFrames(50)
    UI:WaitHideTitle(20)

    UI:SetSpeaker(lanterne)
    UI:WaitShowDialogue("Nous éclairons le fond pour ceux qui descendent...")
    UI:SetSpeaker(ancre)
    UI:WaitShowDialogue("...et nous retenons ceux qui descendent trop vite.")

    if partner ~= nil then
      UI:SetSpeaker(partner)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue("Une lanterne et une ancre...[pause=20] L'une appelle, l'autre retient.")
    end
    GeneralFunctions.HeroDialogue(hero, "On descendra à notre rythme.", "Determined")

    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("silver_trench", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  GAME:CutsceneMode(true)
  GROUND:TeleportTo(hero, 272, 336, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 248, 336, Direction.Up) end
  local lugia = CharacterEssentials.MakeCharactersFromList({{'Lugia', 272, 296, Direction.Down}})
  GROUND:Hide('Lugia')
  GAME:MoveCamera(272, 288, 1, false)
  GAME:FadeIn(40)
  GAME:WaitFrames(30)

  if LegendZones.IsDefeated('sunken_choir') then
    -- REMATCH : le gardien connaît déjà l'équipe, pas de cérémonie.
    GROUND:Unhide('Lugia')
    UI:SetSpeaker(lugia)
    UI:WaitShowDialogue("Le fond de la mer n'oublie pas.[pause=20] Encore une fois, donc.")
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
    GAME:ContinueDungeon("silver_trench", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    return
  end

  -- 1. Le signal : la voix du gardien, avant toute image.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue("IL Y A UN SECOND CIEL SOUS LA MER.[pause=20] JE SUIS SON SEUL OISEAU.")
  UI:SetCenter(false)
  GAME:WaitFrames(30)

  -- 2. L'irruption (motif propre à ce gardien — fiche anti-répétition).
  BossFX.EmergeWater(lugia, 272, 296)
  GAME:WaitFrames(20)

  -- 3. Le recul du groupe.
  BossFX.PushBack({hero, partner}, Direction.Down)
  GAME:WaitFrames(10)

  -- 4/5. Reveal : pose figée puis garde.
  GROUND:Unhide('Lugia')
  GROUND:CharSetAnim(lugia, "Attack", false)
  GAME:WaitFrames(18)
  GROUND:CharSetAnim(lugia, "Idle", true)
  -- 6. Titre + thème.
  BossMusic.Play('fosse_argentee')
  UI:WaitShowTitle("Lugia, le Chœur Englouti", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  -- 7. L'échange — court, à la Explorers.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format("C'est... le même chant qu'au Pic Céleste ![pause=20] Mais... plus profond. Plus ancien. Plus TRISTE.", hero:GetDisplayName()))
  UI:SetSpeaker(lugia)
  UI:WaitShowDialogue("Tu m'as déjà rencontré là-haut.[pause=20] Ici, en bas, je ne juge pas :[pause=10] je pèse.")

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  GAME:ContinueDungeon("silver_trench", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function fosse_argentee.Update(map, time) end
function fosse_argentee.GameSave(map) end
function fosse_argentee.GameLoad(map) end

return fosse_argentee
