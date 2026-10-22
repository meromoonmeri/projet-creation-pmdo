-- Engine-independent state-machine tests for FutureArc and D55.
-- Run with a standalone Lua 5.4 interpreter from the repository root:
--   lua tools/test_future_arc_mock.lua

local checks = 0
local function check(condition, message)
  checks = checks + 1
  if not condition then error('check failed: ' .. message, 2) end
end

local events = {}
local function event(kind, ...)
  table.insert(events, { kind, ... })
end
local function resetEvents() events = {} end
local function lastEvent(kind)
  for index = #events, 1, -1 do
    if events[index][1] == kind then return events[index] end
  end
  return nil
end

local cleared = 'CLEARED'
RogueEssence = {
  Data = {
    GameProgress = {
      ResultType = { Cleared = cleared },
      DungeonStakes = { Risk = 'RISK' },
    },
    DataManager = { DataType = { Zone = 'ZONE' } },
  },
}

DEBUG = { EnableDbgCoro = function() end }
PrintInfo = function(message) event('print', message) end
CH = function() return nil end

GAME = {
  CutsceneMode = function(_, value) event('cutscene', value) end,
  WaitFrames = function(_, frames) event('wait', frames) end,
  FadeOut = function(_, ...) event('fade_out', ...) end,
  FadeIn = function(_, ...) event('fade_in', ...) end,
  EnterGroundMap = function(_, ground, marker) event('ground', ground, marker) end,
  EnterDungeon = function(_, zone, segment, map, entry, stakes, ...) event('dungeon', zone, segment, map, entry, stakes, ...) end,
}
SOUND = setmetatable({}, { __index = function(_, key)
  return function(_, ...) event('sound_' .. key, ...) end
end })
UI = setmetatable({
  choice = false,
  ChoiceResult = function(self) return self.choice end,
}, { __index = function(_, key)
  return function(_, ...) event('ui_' .. key, ...) end
end })
GROUND = setmetatable({}, { __index = function(_, key)
  return function(_, ...) event('ground_' .. key, ...) end
end })
GeneralFunctions = {
  SetEmotion = function() end,
  HeroDialogue = function() end,
  RestoreIdleAnim = function() event('restore_idle') end,
  EndDungeonRun = function(_, ...) event('end_dungeon', ...) end,
}
FutureCast = {
  Spawn = function(spawn) event('spawn', spawn) end,
  Cleanup = function() event('cast_cleanup') end,
}
COMMON = {
  rescueExit = false,
  ExitDungeonMissionCheck = function()
    event('mission_check')
    return COMMON.rescueExit
  end,
}
SV = { adventure = { Thief = false } }

package.preload['origin.common'] = function() return {} end
package.preload['halcyon.GeneralFunctions'] = function() return GeneralFunctions end
package.preload['halcyon.future_arc.FutureCast'] = function() return FutureCast end
local baseRequire = require
require = function(name)
  if string.match(name, '^halcyon%.future_arc%.scene%.') then
    return { Cutscene = function() event('scene', name); return true end }
  end
  return baseRequire(name)
end

local futureArcPath = 'Data/Script/halcyon/future_arc/FutureArc.lua'
local dungeon55Path = 'Data/Script/halcyon/future_arc/dungeon55_events.lua'
local FutureArcModule = assert(loadfile(futureArcPath))()
check(FutureArcModule == FutureArc, 'FutureArc module export')
check(#FutureArc.ROUTE == 37, 'canonical route has 37 actions')
local dungeonCount = 0
for _, action in ipairs(FutureArc.ROUTE) do
  if action.kind == 'dungeon' then dungeonCount = dungeonCount + 1 end
end
check(dungeonCount == 6, 'canonical route has six native dungeons')

local function chapter11State()
  return {
    ChapterProgression = { Chapter = 11 },
    Chapter11 = { FinishedTreasureTownIntro = true, TreasureTownArrivalVersion = 1 },
    adventure = { Thief = false },
  }
end

-- Eligibility and normal activation.
SV = chapter11State()
check(FutureArc.CanOffer(), 'FutureArc is offered after the repaired Chapter 11 arrival')
resetEvents()
check(FutureArc.Begin('bourg_comptoir'), 'Begin accepts an eligible normal-game offer')
check(SV.FutureArc.Active and SV.FutureArc.Cursor == 1, 'Begin initializes the active route')
check(lastEvent('ground')[2] == 'p05p01a', 'Begin enters the first canonical Ground')

-- A v2 pending run must survive the v3 migration byte-for-state.
SV = chapter11State()
SV.FutureArc = {
  Version = 2, Active = true, Completed = false, Cursor = 18,
  CurrentScene = 'kept_scene', PendingDungeon = 'sealed_ruin',
  DungeonState = 'running', DungeonReturnGround = 'd20p11a',
  LastOutcome = 'kept_result', ReturnGround = 'custom_return',
  Attempts = { sealed_ruin = 4 }, LastError = 'kept_error',
}
local migrated = FutureArc.EnsureState()
check(migrated.Version == 3 and migrated.Cursor == 18, 'v2 cursor survives v3 migration')
check(migrated.CurrentScene == 'kept_scene' and migrated.PendingDungeon == 'sealed_ruin', 'v2 pending scene and dungeon survive')
check(migrated.DungeonState == 'running' and migrated.DungeonReturnGround == 'd20p11a', 'v2 run and return Ground survive')
check(migrated.LastOutcome == 'kept_result' and migrated.ReturnGround == 'custom_return', 'v2 result and final return survive')
check(migrated.Attempts.sealed_ruin == 4 and migrated.LastError == 'kept_error', 'v2 attempts and error survive')

-- Legacy Step saves resume from the first action on their current Ground.
SV = chapter11State()
SV.FutureArc = { Step = 99, Completed = false }
resetEvents()
FutureArc.Resume('p07p01a')
check(SV.FutureArc.Version == 3 and SV.FutureArc.Active, 'legacy Step save activates during migration')
check(SV.FutureArc.Cursor == 28, 'legacy P07 save runs P07 then advances to action 28')
check(SV.FutureArc.Step == nil and not SV.FutureArc.LegacyNeedsGround, 'legacy migration fields are consumed')
check(lastEvent('ground')[2] == 'p05p01a', 'legacy P07 save follows the next canonical Ground')

-- A completed legacy Spiritomb battle must not be replayed.
SV = chapter11State()
SV.FutureArc = { Step = 1, Completed = false, SpiritombBattleDone = true }
resetEvents()
FutureArc.Resume('d21p41a')
check(SV.FutureArc.Cursor == 27, 'legacy Spiritomb victory resumes after its post-battle scene')
check(SV.FutureArc.SpiritombBattleDone == nil and not SV.FutureArc.LegacySpiritombDone, 'Spiritomb migration flag is consumed')
check(lastEvent('ground')[2] == 'p07p01a', 'legacy Spiritomb victory continues to P07')

local function activeDungeon(cursor, zone, ground, dungeonState)
  SV = chapter11State()
  SV.FutureArc = {
    Version = 3, Active = true, Completed = false, Cursor = cursor,
    CurrentScene = '', PendingDungeon = zone, DungeonState = dungeonState,
    DungeonReturnGround = ground, ReturnGround = 'bourg_comptoir',
    Attempts = { [zone] = 1 }, LastOutcome = '', LastError = '',
  }
end

-- Clear advances once and uses the saved return Ground.
activeDungeon(11, 'chasm_cave', 'd18p11a', 'running')
check(FutureArc.OnDungeonExit('chasm_cave', cleared), 'matching clear is accepted')
check(SV.FutureArc.DungeonState == 'cleared', 'clear is persisted before EndDungeonRun')
check(FutureArc.GetDungeonReturnGround('wrong') == 'd18p11a', 'saved dungeon return Ground wins over fallback')
resetEvents()
FutureArc.Resume('d18p11a')
check(SV.FutureArc.Cursor == 12 and SV.FutureArc.DungeonState == 'idle', 'clear advances exactly one route action')
check(SV.FutureArc.PendingDungeon == '' and SV.FutureArc.DungeonReturnGround == '', 'clear consumes pending dungeon fields')
check(lastEvent('ground')[2] == 'd19p11a', 'clear enters the next canonical Ground')

-- Failure and an interrupted running save both replay the checkpoint and retry.
activeDungeon(11, 'chasm_cave', 'd18p11a', 'running')
check(FutureArc.OnDungeonExit('chasm_cave', 'FAILED'), 'matching failure is accepted')
resetEvents()
FutureArc.Resume('d18p11a')
check(SV.FutureArc.Cursor == 11 and SV.FutureArc.DungeonState == 'running', 'failure does not advance')
check(SV.FutureArc.Attempts.chasm_cave == 2, 'failure increments attempts on retry')
check(lastEvent('scene') ~= nil and lastEvent('dungeon')[2] == 'chasm_cave', 'failure plays retry scene and re-enters expected dungeon')

activeDungeon(11, 'chasm_cave', 'd18p11a', 'running')
resetEvents()
FutureArc.Resume('d18p11a')
check(SV.FutureArc.Cursor == 11 and SV.FutureArc.Attempts.chasm_cave == 2, 'reload of interrupted running state retries without advancing')
check(lastEvent('dungeon')[2] == 'chasm_cave', 'interrupted run re-enters its dungeon')

-- A wrong zone can never clear the current route action.
activeDungeon(11, 'chasm_cave', 'd18p11a', 'running')
check(not FutureArc.OnDungeonExit('dark_hill', cleared), 'mismatched zone is rejected')
check(SV.FutureArc.Cursor == 11 and SV.FutureArc.DungeonState == 'failed', 'mismatched zone leaves cursor and forces retry')
check(string.find(SV.FutureArc.LastError, 'donjon inattendu', 1, true) ~= nil, 'mismatched zone records a diagnostic')

-- Rescue takeover happens before state mutation or normal EndDungeonRun.
activeDungeon(11, 'chasm_cave', 'd18p11a', 'running')
COMMON.rescueExit = true
resetEvents()
local fakeZone = { ID = 'chasm_cave' }
package.preload['halcyon.future_arc.FutureArc'] = function() return FutureArc end
local FutureDungeonCommon = assert(loadfile('Data/Script/halcyon/future_arc/_future_dungeons_common.lua'))()
check(FutureDungeonCommon.HandleExit('FAILED', true, fakeZone, 0, 'd18p11a'), 'rescue takeover is acknowledged')
check(SV.FutureArc.DungeonState == 'running' and SV.FutureArc.LastOutcome == '', 'rescue takeover preserves the suspended FutureArc run')
check(lastEvent('end_dungeon') == nil, 'rescue takeover does not start a second transition')
COMMON.rescueExit = false

-- Route completion and the isolated present-return path both nil-safely unlock D55.
SV = chapter11State()
SV.FutureArc = {
  Version = 3, Active = true, Completed = false, Cursor = 38,
  ReturnGround = 'bourg_comptoir', Attempts = {}, DungeonState = 'idle',
}
resetEvents()
FutureArc.Resume('p09p01a')
check(SV.FutureArc.Completed and not SV.FutureArc.Active, 'route completion is persisted')
check(SV.FutureArc.PresentReturnPending, 'route completion schedules the present return')
check(SV.FutureSpecialEpisode ~= nil and SV.FutureSpecialEpisode.Unlocked, 'route completion initializes and unlocks D55')
check(lastEvent('ground')[2] == 'bourg_comptoir', 'route completion returns to the saved Ground')

SV = chapter11State()
SV.FutureArc = { Version = 3, PresentReturnPending = true, Attempts = {}, DungeonState = 'idle' }
resetEvents()
check(FutureArc.PlayPresentReturn(), 'isolated present-return scene is playable')
check(SV.FutureArc.PresentReturnSeen and not SV.FutureArc.PresentReturnPending, 'present-return flags are consumed')
check(SV.FutureSpecialEpisode ~= nil and SV.FutureSpecialEpisode.Unlocked, 'present-return path independently initializes and unlocks D55')

-- D55 state and fragment mapping.
local Dungeon55Module = assert(loadfile(dungeon55Path))()
check(Dungeon55Module == Dungeon55Events, 'D55 module export')
check(Dungeon55Events.NATIVE_SEGMENTS[1] == 0 and Dungeon55Events.NATIVE_SEGMENTS[2] == 1
  and Dungeon55Events.NATIVE_SEGMENTS[3] == 2, 'D55 maps fragments 1..3 to native segments 0..2')

SV = chapter11State()
SV.FutureSpecialEpisode = {
  Version = 1, Unlocked = true, Active = true, CurrentSegment = 2,
  PendingSegment = 2, Segment1Done = true, Segment2Done = false,
  Segment3Done = false, Completed = false, ReturnPending = true,
  Attempts = 7, LastResult = 'legacy',
}
check(Dungeon55Events.CanOffer(), 'v1 D55 state upgrades to an offerable safe checkpoint')
check(SV.FutureSpecialEpisode.Version == 2 and SV.FutureSpecialEpisode.Segment1Done, 'D55 upgrade preserves completed fragments')
check(not SV.FutureSpecialEpisode.Active and SV.FutureSpecialEpisode.PendingSegment == 0
  and not SV.FutureSpecialEpisode.ReturnPending, 'D55 upgrade clears unsafe pending-run state')
check(SV.FutureSpecialEpisode.Attempts == 7, 'D55 upgrade preserves attempt count')

local function d55State(fragment)
  SV = chapter11State()
  SV.FutureSpecialEpisode = {
    Version = 2, Unlocked = true, Active = true,
    CurrentSegment = fragment, PendingSegment = fragment,
    Segment1Done = fragment > 1, Segment2Done = fragment > 2,
    Segment3Done = false, Completed = false, ReturnPending = false,
    Attempts = 1, LastResult = '',
  }
end

d55State(1)
check(Dungeon55Events.OnDungeonExit(cleared, 0), 'D55 accepts the matching native segment clear')
check(SV.FutureSpecialEpisode.Segment1Done and SV.FutureSpecialEpisode.CurrentSegment == 2, 'D55 clear advances to the next fragment')
check(SV.FutureSpecialEpisode.ReturnPending and SV.FutureSpecialEpisode.LastResult == 'cleared', 'D55 clear schedules a return scene')
resetEvents()
check(Dungeon55Events.PlayReturn(), 'D55 clear return scene is consumed')
check(SV.FutureSpecialEpisode.PendingSegment == 0 and not SV.FutureSpecialEpisode.ReturnPending, 'D55 return clears pending fields')

d55State(2)
check(Dungeon55Events.OnDungeonExit('FAILED', 1), 'D55 accepts a matching failure')
check(not SV.FutureSpecialEpisode.Segment2Done and SV.FutureSpecialEpisode.CurrentSegment == 2, 'D55 failure never advances')
check(SV.FutureSpecialEpisode.LastResult == 'failed' and SV.FutureSpecialEpisode.ReturnPending, 'D55 failure schedules retry feedback')

d55State(2)
check(not Dungeon55Events.OnDungeonExit(cleared, 2), 'D55 rejects a clear from the wrong native segment')
check(not SV.FutureSpecialEpisode.Active and SV.FutureSpecialEpisode.ReturnPending, 'invalid D55 segment safely returns control')
check(SV.FutureSpecialEpisode.LastResult == 'invalid_segment' and not SV.FutureSpecialEpisode.Segment2Done, 'invalid D55 segment cannot grant progress')

-- Full D55 sequence completes only after all three matching clears.
SV = chapter11State()
SV.FutureSpecialEpisode = {
  Version = 2, Unlocked = true, Active = false, CurrentSegment = 1,
  PendingSegment = 0, Segment1Done = false, Segment2Done = false,
  Segment3Done = false, Completed = false, ReturnPending = false,
  Attempts = 0, LastResult = '',
}
for fragment = 1, 3 do
  SV.FutureSpecialEpisode.Active = true
  SV.FutureSpecialEpisode.PendingSegment = fragment
  check(Dungeon55Events.OnDungeonExit(cleared, fragment - 1), 'D55 sequence clears fragment ' .. fragment)
  check(Dungeon55Events.PlayReturn(), 'D55 sequence returns from fragment ' .. fragment)
end
check(SV.FutureSpecialEpisode.Completed and SV.FutureSpecialEpisode.Segment1Done
  and SV.FutureSpecialEpisode.Segment2Done and SV.FutureSpecialEpisode.Segment3Done,
  'D55 completes only after all three fragments')
check(not Dungeon55Events.CanOffer(), 'completed D55 cannot be offered again')

-- D55 rescue takeover also leaves its suspended state untouched.
d55State(1)
COMMON.rescueExit = true
resetEvents()
Dungeon55Events.HandleExit('FAILED', true, { ID = 'passage_temps' }, 0)
check(SV.FutureSpecialEpisode.Active and not SV.FutureSpecialEpisode.ReturnPending
  and SV.FutureSpecialEpisode.LastResult == '', 'D55 rescue takeover preserves the suspended fragment')
check(lastEvent('end_dungeon') == nil, 'D55 rescue takeover does not start a second transition')
COMMON.rescueExit = false

print(string.format('OK: %d FutureArc/D55 runtime-mock checks passed', checks))
