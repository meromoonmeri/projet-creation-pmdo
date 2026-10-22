-- [dungeon_builder] recâblage : scène de mi-parcours des Bois Sombres : elle rend la main au dernier segment, où se trouve l'étage d'arène
--[[
    gloomy_forest_miniboss_ch_6.lua
    Forêt Lugubre — Mini-Boss : Tengalice + Cornèbre (gardiens du cœur)
    Simple : flash blanc + dialogues (directive utilisateur).
    Salle 456x456 px, ring de 2 tuiles de murs : plancher de (48,48) à (408,408).
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

gloomy_forest_miniboss_ch_6 = {}

-- Positions étalonnées : équipe au sud (y≈348), gardiens au nord (y≈150),
-- caméra foyer entre les deux groupes.
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

function gloomy_forest_miniboss_ch_6.FirstPreBossScene()
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

  SOUND:PlayBGM('Mystifying Forest.ogg', false)

  -- L'équipe s'avance vers le nord de la salle.
  GAME:WaitFrames(30)
  local t2 = CH('Teammate2')
  local t3 = CH('Teammate3')
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_001']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GFM_002']), "Worried")
  GAME:WaitFrames(15)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_003']))
  GAME:WaitFrames(20)

  -- Ordre imposé : Gardien qui parle -> Flash -> Apparition.
  -- Tengalice existe AVANT de parler (mais reste caché) : c'est lui qui
  -- interpelle le duo, pas un oracle. Patron du clan Limagma au Creuset
  -- (searing_crucible_ch_5.lua:626-629).
  local shiftry = CharacterEssentials.MakeCharactersFromList({
    {'Shiftry', BOSS_1[1], BOSS_1[2], Direction.DownRight}
  })
  GROUND:Hide('Shiftry')

  BossFX.GuardianVoice(shiftry, 'GFM_004')
  GAME:WaitFrames(20)

  -- Tengalice apparaît sous un flash blanc.
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  BossFX.Flash(BOSS_1[1], BOSS_1[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Shiftry')
  BossFX.Impact(7)

  GAME:WaitFrames(20)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_005']))
  GAME:WaitFrames(20)

  -- Cornèbre apparaît sous un flash blanc.
  local murkrow = CharacterEssentials.MakeCharactersFromList({
    {'Cornebre_Boss', BOSS_2[1], BOSS_2[2], Direction.DownLeft}
  })
  GROUND:Hide('Cornebre_Boss')
  SOUND:PlayBattleSE('_UNK_EVT_102')
  GAME:WaitFrames(10)
  BossFX.Flash(BOSS_2[1], BOSS_2[2], 3, 5, 20)
  GAME:WaitFrames(8)
  GROUND:Unhide('Cornebre_Boss')
  BossFX.Impact(7)

  GAME:WaitFrames(20)
  GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Surprised")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_006']))
  GAME:WaitFrames(20)

  -- Les gardiens prennent la parole.
  UI:SetSpeaker(shiftry)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_007']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(murkrow)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_008']))
  GAME:WaitFrames(20)

  GAME:MoveCamera(CAM_TEAM[1], CAM_TEAM[2] - 40, 40, false)
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_009'], hero:GetDisplayName()))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  SV.Chapter6.GloomyMiniBossSeen = true
  -- Segment 2 : l'arène de combat proprement dite.
  PrintInfo("[BossSeq][gloomy_miniboss] ContinueDungeon('gloomy_forest', 2)")
  GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gloomy_forest_miniboss_ch_6.SecondPreBossScene()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local shiftry = CharacterEssentials.MakeCharactersFromList({
    {'Shiftry', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local murkrow = CharacterEssentials.MakeCharactersFromList({
    {'Cornebre_Boss', BOSS_2[1], BOSS_2[2], Direction.Down}
  })

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:FadeOutBGM(60)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GROUND:CharSetAnim(shiftry, "Idle", true)
  GROUND:CharSetAnim(murkrow, "Idle", true)
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
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_010']))

  COMMON.BossTransition()
  GAME:CutsceneMode(false)
  PrintInfo("[BossSeq][gloomy_miniboss] ContinueDungeon('gloomy_forest', 2)")
  GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

-- Corps de la cinématique de victoire, appelé sous pcall : aucune erreur ne
-- doit laisser le joueur sur un écran noir.
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
  local shiftry = CharacterEssentials.MakeCharactersFromList({
    {'Shiftry', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  local murkrow = CharacterEssentials.MakeCharactersFromList({
    {'Cornebre_Boss', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(shiftry, "Idle", true)
  GROUND:CharSetAnim(murkrow, "Idle", true)

  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  PlaceTeam(hero, partner)
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:CutsceneMode(true)
  GAME:WaitFrames(60)
  GAME:FadeIn(40)

  SOUND:PlayBGM('Mystifying Forest.ogg', false)

  GAME:WaitFrames(30)
  UI:SetSpeaker(shiftry)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_011']))
  GAME:WaitFrames(12)
  UI:SetSpeaker(murkrow)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_012']))
  GAME:WaitFrames(20)

  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Determined")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_013']))
  GAME:WaitFrames(15)
  GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings['GFM_014']), "Normal")
  GAME:WaitFrames(20)

  -- Les gardiens s'effacent dans un flash blanc : la voie du cœur s'ouvre.
  BossFX.Flash(248, 150, 2, 2, 20)
  GAME:WaitFrames(16)
  pcall(function() GROUND:Hide('Shiftry') end)
  pcall(function() GROUND:Hide('Cornebre_Boss') end)
  GAME:WaitFrames(30)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
end

function gloomy_forest_miniboss_ch_6.DefeatedBoss()
  PrintInfo("[BossSeq][gloomy_forest_miniboss_ch_6] DefeatedBoss start")

  local ok, err = pcall(DefeatedBossBody)
  if not ok then
    PrintInfo("[BossSeq] DefeatedBoss ERREUR: "..tostring(err))
    pcall(function() GAME:FadeOut(false, 20) end)
  end

  GAME:CutsceneMode(false)
  -- Segment 3 : les 3F au-dessus du mini-boss, vers le cœur de la forêt.
  PrintInfo("[BossSeq][gloomy_forest_miniboss_ch_6] -> ContinueDungeon(seg 3)")
  GAME:ContinueDungeon("gloomy_forest", 2, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
end

function gloomy_forest_miniboss_ch_6.DiedToBoss()
  PrintInfo("[BossSeq][gloomy_forest_miniboss_ch_6] DiedToBoss start")
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:StopBGM()

  local shiftry = CharacterEssentials.MakeCharactersFromList({
    {'Shiftry', BOSS_1[1], BOSS_1[2], Direction.Down}
  })
  GROUND:CharSetAnim(shiftry, "Idle", true)
  local murkrow = CharacterEssentials.MakeCharactersFromList({
    {'Cornebre_Boss', BOSS_2[1], BOSS_2[2], Direction.Down}
  })
  GROUND:CharSetAnim(murkrow, "Idle", true)

  -- L'équipe est au sol, vaincue.
  PlaceTeam(hero, partner)
  GROUND:CharSetAnim(hero, "EventSleep", true)
  if partner ~= nil then GROUND:CharSetAnim(partner, "EventSleep", true) end
  GAME:MoveCamera(CAM_FOYER[1], CAM_FOYER[2], 1, false)

  GAME:FadeIn(60)
  GAME:WaitFrames(40)

  -- Triomphe des gardiens, puis la Voix.
  UI:SetSpeaker(shiftry)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['GFM_015']))
  GAME:WaitFrames(20)
  BossFX.GuardianVoice(shiftry, 'GFM_016')
  GAME:WaitFrames(20)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)

  GROUND:CharEndAnim(hero)
  if partner ~= nil then GROUND:CharEndAnim(partner) end
  GAME:CutsceneMode(false)

  -- Checkpoint : réveil au relais (WipedCutscene du midpoint).
  SV.Chapter6.GloomyMidpointState = 'DeathArrival'
  PrintInfo("[BossSeq][gloomy_forest_miniboss_ch_6] DiedToBoss -> gloomy_forest_midpoint")
  GAME:EnterGroundMap("gloomy_forest_midpoint", "Main_Entrance_Marker")
end

return gloomy_forest_miniboss_ch_6
