--[[
    cloven_ruins_miniboss_ch_5.lua
    Aegis Cave — Mini-Boss : Kaorine + Golemastoc (gardiens antiques)
    Simple : flash blanc + dialogues (directive utilisateur).
    Salle 456x456 px, ring de 2 tuiles de murs : plancher de (48,48) à (408,408).
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

cloven_ruins_miniboss_ch_5 = {}

local HERO_SPAWN = {220, 348}
local PARTNER_SPAWN = {252, 348}
local T2_SPAWN = {188, 364}
local T3_SPAWN = {284, 364}
local CAM_TEAM = {236, 310}
local CAM_FOYER = {248, 220}
local BOSS_1 = {196, 150}
local BOSS_2 = {300, 138}

local function PlaceTeam(hero, partner)
  GROUND:TeleportTo(hero, HERO_SPAWN[1], HERO_SPAWN[2], Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, PARTNER_SPAWN[1], PARTNER_SPAWN[2], Direction.Up) end
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
  if t2 ~= nil then GROUND:TeleportTo(t2, T2_SPAWN[1], T2_SPAWN[2], Direction.Up) end
  if t3 ~= nil then GROUND:TeleportTo(t3, T3_SPAWN[1], T3_SPAWN[2], Direction.Up) end
end

function cloven_ruins_miniboss_ch_5.FirstPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  -- NOIR AVANT LA MISE EN PLACE (patron searing_tunnel_miniboss : teleports
  -- et camera sous le fondu, plus de flash de la carte a l'arrivee).
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_TEAM[1], CAM_TEAM[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Deep Dark Crater.ogg', false)

  -- L'équipe s'avance vers le nord de la salle.
  GAME:WaitFrames(30)
  local coro1 = TASK:BranchCoroutine(function()
    if partner ~= nil then GROUND:MoveInDirection(partner, Direction.Up, 64, false, 1) end
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, 64, false, 1)
  end)
  local coro3 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 90, false)
  end)
  TASK:JoinCoroutines({coro1, coro2, coro3})

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Worried")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_001']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRM_002']), "Worried")
  GAME:WaitFrames(20)

  -- Ordre imposé : Voix -> Flash -> Apparition.
  -- Kaorine existe AVANT de parler (mais reste caché) : la sentinelle
  -- s'adresse au duo, ce n'est pas un oracle. Patron du clan Limagma au
  -- Creuset (searing_crucible_ch_5.lua:626-629).
  local claydol = CharacterEssentials.MakeCharactersFromList({
    {'Claydol', BOSS_1[1], BOSS_1[2], Direction.DownRight}
  })
  GROUND:Hide('Claydol')

  BossFX.GuardianVoice(claydol, 'CRM_003')
  GAME:WaitFrames(20)

  -- Kaorine apparaît sous un flash blanc.
  SOUND:PlayBattleSE('_UNK_EVT_102')
  BossFX.Flash(BOSS_1[1], BOSS_1[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Claydol')
  BossFX.Impact(7)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_004']))
  GAME:WaitFrames(20)

  -- Golemastoc apparaît sous un flash blanc.
  local golurk = CharacterEssentials.MakeCharactersFromList({
    {'Golurk', BOSS_2[1], BOSS_2[2], Direction.DownLeft}
  })
  GROUND:Hide('Golurk')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(10)
  BossFX.Flash(BOSS_2[1], BOSS_2[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Golurk')
  BossFX.Impact(9)

  GAME:WaitFrames(20)
  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_005']))
  GAME:WaitFrames(20)

  -- Les gardiens prennent la parole.
  UI:SetSpeaker(claydol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_006']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(golurk)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_007']))
  GAME:WaitFrames(20)

  GAME:MoveCamera(CAM_TEAM[1], CAM_TEAM[2] - 40, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_008'], hero:GetDisplayName()))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter5.RuinsMiniBossSeen = true
  -- Segment 3 : l'arène de combat proprement dite.
  PrintInfo("[BossSeq][cloven_miniboss] ContinueDungeon('cloven_ruins', 3)")
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_miniboss_ch_5.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local claydol = CharacterEssentials.MakeCharactersFromList({
    {'Claydol', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local golurk = CharacterEssentials.MakeCharactersFromList({
    {'Golurk', BOSS_2[1], BOSS_2[2], Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(claydol, "Idle", true)
  GROUND:CharSetAnim(golurk, "Idle", true)
  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)

  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Rising Fear.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_009']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][cloven_miniboss] ContinueDungeon('cloven_ruins', 3)")
  GAME:ContinueDungeon("cloven_ruins", 3, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

local function DefeatedBossBody()

	--LE NOIR AVANT TOUTE MISE EN PLACE (correctif de retour de boss,
	--2026-07-30). Cette scene est jouee juste apres un EndSegment /
	--EnterZone : le moteur a pose le noir, mais rien ne le REPOSE ici.
	--Elle enchaine pourtant plusieurs appels moteur (creation de PNJ,
	--TeleportTo, MoveCamera, StopBGM) avant son FadeIn. GAME:FadeOut
	--etant bloquant (ScriptGame.cs:1590) et FadeInternal rendant la
	--main a chaque frame (FadeEffect.cs:30-42), ces appels laissent
	--passer des frames RENDUES sur une carte en cours de montage —
	--c'est l'apercu de zone signale en jeu. FadeOut(false,1) sur un
	--ecran deja noir est un no-op (FadeEffect.cs:63) : gratuit si le
	--noir a tenu, salvateur sinon.
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local claydol = CharacterEssentials.MakeCharactersFromList({
    {'Claydol', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local golurk = CharacterEssentials.MakeCharactersFromList({
    {'Golurk', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(claydol, "Idle", true)
  GROUND:CharSetAnim(golurk, "Idle", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Deep Dark Crater.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(claydol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_010']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(golurk)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_011']))
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_012']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['CRM_013']), "Normal")
  GAME:WaitFrames(20)

  -- Les gardiens s'éteignent dans un flash blanc.
  BossFX.Flash(248, 150, 2, 2, 20)
  GAME:WaitFrames(16)
  pcall(function() GROUND:Hide('Claydol') end)
  pcall(function() GROUND:Hide('Golurk') end)
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function cloven_ruins_miniboss_ch_5.DefeatedBoss()
  PrintInfo("[BossSeq][cloven_ruins_miniboss_ch_5] DefeatedBoss start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  GAME:CutsceneMode(false)
  -- Segment 4 : les 3F au-dessus du mini-boss, vers le sanctuaire des titans.
  PrintInfo("[BossSeq][cloven_ruins_miniboss_ch_5] -> ContinueDungeon(seg 4)")
  GAME:ContinueDungeon("cloven_ruins", 4, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function cloven_ruins_miniboss_ch_5.DiedToBoss()
  PrintInfo("[BossSeq][cloven_ruins_miniboss_ch_5] DiedToBoss start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local claydol = CharacterEssentials.MakeCharactersFromList({
    {'Claydol', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  GROUND:CharSetAnim(claydol, "Idle", true)
  local golurk = CharacterEssentials.MakeCharactersFromList({
    {'Golurk', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(golurk, "Idle", true)

  PlaceTeam(hero, partner)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  UI:SetSpeaker(claydol)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CRM_014']))
  GAME:WaitFrames(20)
  BossFX.GuardianVoice(claydol, 'CRM_015')
  GAME:WaitFrames(20)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  GROUND:CharEndAnim(hero)
  if partner ~= nil then GROUND:CharEndAnim(partner) end
  GAME:CutsceneMode(false)

  -- Checkpoint : réveil au relais (WipedCutscene du midpoint).
  SV.Chapter5.RuinsMidState = 'DeathArrival'
  PrintInfo("[BossSeq][cloven_ruins_miniboss_ch_5] DiedToBoss -> cloven_ruins_midpoint")
  GAME:EnterGroundMap("cloven_ruins_midpoint", "Main_Entrance_Marker")
end

return cloven_ruins_miniboss_ch_5
