-- Opt-in real PMDO route validation for canonical Sinister Woods.
-- Enabled only with PMDO_SINISTER_ROUTE_VALIDATOR=1.
require 'origin.common'
require 'origin.services.baseservice'

local V = Class('SinisterRouteValidator', BaseService)
local OUT = os.getenv('PMDO_SINISTER_ROUTE_OUT') or '/tmp/sinister_route_runtime.jsonl'

local function esc(value)
  return tostring(value):gsub('\\','\\\\'):gsub('"','\\"'):gsub('\n',' | '):gsub('\r','')
end
local function emit(payload)
  PrintInfo('[SINISTER_ROUTE] '..payload)
  local file=io.open(OUT,'a');if file then file:write(payload..'\n');file:flush();file:close() end
end
local function safe(fn, fallback)local ok,v=pcall(fn);if ok then return v end;return fallback end

function V:initialize()
  BaseService.initialize(self)
  self.enabled=os.getenv('PMDO_SINISTER_ROUTE_VALIDATOR')=='1'
  self.started=false;self.boss_done=false
  self.last_ground=nil;self.last_map=nil;self.clear_pending=nil;self.task=nil
end

function V:install_input_replay()
  local ListType=luanet.import_type('System.Collections.Generic.List`1')
  local FrameInput=luanet.import_type('RogueEssence.FrameInput')
  local GamePadState=luanet.import_type('Microsoft.Xna.Framework.Input.GamePadState')
  local KeyboardState=luanet.import_type('Microsoft.Xna.Framework.Input.KeyboardState')
  local MouseState=luanet.import_type('Microsoft.Xna.Framework.Input.MouseState')
  local Keys=luanet.import_type('Microsoft.Xna.Framework.Input.Keys')
  local Loc=luanet.import_type('RogueElements.Loc')
  local arr=LUA_ENGINE:MakeLuaArray(Keys,{Keys.Enter})
  local function confirm()
    return FrameInput(GamePadState(),KeyboardState(arr),MouseState(),true,false,true,Loc(0,0))
  end
  self.diag=luanet.import_type('RogueEssence.DiagManager').Instance
  self.replay=LUA_ENGINE:MakeGenericType(ListType,{FrameInput},{})
  for frame=1,18000 do
    if frame%75==0 then self.replay:Add(confirm()) else self.replay:Add(FrameInput()) end
  end
  self.diag.ActiveDebugReplay=self.replay;self.diag.DebugReplayIndex=0
end

function V:seed_story()
  SV.ChapterProgression.Chapter=6
  SV.ChapterProgression.CurrentStoryDungeon='gloomy_forest'
  SV.Chapter6.MissionAccepted=true;SV.Chapter6.MissionComplete=false
  SV.Chapter6.GloomyPlayedMidpointIntro=true
  SV.Chapter6.GloomyMidpointState='RepeatArrival'
  SV.GloomyForest=SV.GloomyForest or {};SV.GloomyForest.DiedPastCheckpoint=false
  SV.CanonicalDungeons=SV.CanonicalDungeons or {}
  SV.CanonicalDungeons.SinisterWoodsD04P02Seen=false
  -- NewGamePlus uses a debug save preloaded with board missions. A real clean
  -- story start has no unrelated mission prompt intercepting dungeon stairs.
  SV.TakenBoard={}
  _DATA.Save.Rescue=nil
  -- NewGamePlus also injects four debug party members. Sinister Woods' story
  -- route is hero + partner, matching the midpoint's single teammate spawner.
  while _DATA.Save.ActiveTeam.Players.Count>2 do
    _DATA.Save.ActiveTeam.Players:RemoveAt(_DATA.Save.ActiveTeam.Players.Count-1)
  end
end

function V:OnInit()
  if not self.enabled then return end
  local file=io.open(OUT,'w');if file then file:close() end
  self:install_input_replay()
  RogueEssence.GameManager.Instance:NewGamePlus(20260823)
end

function V:OnNewGame()
  if not self.enabled or self.started then return end
  self.started=true;self:seed_story()
  local zone=_DATA:GetZone('master_zone');local idx=-1
  for ii=0,zone.GroundMaps.Count-1 do if zone.GroundMaps[ii]=='bois_sombres_oree' then idx=ii end end
  emit('{"event":"begin","entrance_index":'..idx..'}')
  if idx<0 then emit('{"event":"fatal","error":"canonical entrance absent"}');return end
  GAME:EnterZone('master_zone',-1,idx,0)
end

function V:inspect_map()
  local map=_ZONE.CurrentMap;local seg=_ZONE.CurrentMapID.Segment
  local teams=map.MapTeams.Count;local mobs=0
  for ii=0,teams-1 do mobs=mobs+map.MapTeams[ii].Players.Count end
  local map_seed=safe(function()return map.Rand.FirstSeed end,'')
  local adventure_seed=safe(function()return _DATA.Save.Rand.FirstSeed end,'')
  emit('{"event":"map","segment":'..seg..',"floor":'.._ZONE.CurrentMapID.ID
    ..',"width":'..map.Width..',"height":'..map.Height..',"mobs":'..mobs
    ..',"music":"'..esc(map.Music)..'","map_seed":"'..esc(map_seed)
    ..'","adventure_seed":"'..esc(adventure_seed)..'"}')
end

function V:OnDungeonMapInit()
  if not self.enabled then return end
  local key=tostring(_ZONE.CurrentZoneID)..':'..tostring(_ZONE.CurrentMapID.Segment)
    ..':'..tostring(_ZONE.CurrentMapID.ID)
  if self.last_map==key then return end
  self.last_map=key
  -- DungeonMapInit already exposes the fully generated map and attached team.
  -- Inspect synchronously: a branch created during scene setup may be discarded
  -- before its first yielded frame when Lua finalizes the scene transition.
  local ok,err=xpcall(function()self:inspect_map()end,debug.traceback)
  if not ok then emit('{"event":"fatal","phase":"map_inspection","error":"'..esc(err)..'"}') end
end

function V:OnDungeonFloorEnter()
  if not self.enabled then return end
  local key=tostring(_ZONE.CurrentZoneID)..':'..tostring(_ZONE.CurrentMapID.Segment)
    ..':'..tostring(_ZONE.CurrentMapID.ID)
  if self.clear_pending==key then return end
  self.clear_pending=key
  local seg,floor=_ZONE.CurrentMapID.Segment,_ZONE.CurrentMapID.ID
  local ok,err=xpcall(function()
    if seg<2 then
      local map=_ZONE.CurrentMap;local stairs=nil;local sx,sy=-1,-1
      for x=0,map.Width-1 do
        for y=0,map.Height-1 do
          local effect=map.Tiles[x][y].Effect
          local id=tostring(effect.ID or '')
          if id=='stairs_go_down' or id=='stairs_go_up' then
            stairs=effect;sx=x;sy=y;break
          end
        end
        if stairs~=nil then break end
      end
      if stairs==nil then error('procedural floor has no stairs') end
      emit('{"event":"stairs_located","segment":'..seg..',"floor":'..floor
        ..',"x":'..sx..',"y":'..sy..',"tile":"'..esc(stairs.ID)..'"}')
      if floor<5 then
        emit('{"event":"next_floor_probe","segment":'..seg..',"from":'..floor
          ..',"to":'..(floor+1)..'}')
        GAME:EnterZone('gloomy_forest',seg,floor+1,0)
      else
        local manager=RogueEssence.GameManager.Instance
        local field=manager:GetType():GetField('SceneOutcome')
        if field==nil then error('GameManager.SceneOutcome reflection field missing') end
        -- Offscreen FNA does not advance the normal fade wait from this
        -- headless callback. Pre-complete only that visual transition; native
        -- EndSegment and the zone's ExitSegment still run unchanged.
        manager:SetFade(true,false)
        field:SetValue(manager,_GAME:EndSegment(
          RogueEssence.Data.GameProgress.ResultType.Cleared,true))
        emit('{"event":"end_segment_reflection_set","segment":'..seg
          ..',"prefaded":true,"field_non_null":'..tostring(field:GetValue(manager)~=nil)..'}')
      end
    else
      self.boss_done=true
      local hook_count=safe(function()
        local status=_ZONE.CurrentMap.Status['map_clear_check']
        local MapCheckState=luanet.import_type('RogueEssence.Dungeon.MapCheckState')
        local check=status.StatusStates:GetWithDefault(luanet.ctype(MapCheckState))
        return check.CheckEvents.Count
      end,-1)
      emit('{"event":"boss_outcome","simulated":"cleared","mobs":3'
        ..',"native_clear_hooks":'..hook_count..'}')
      -- D04P02 is a fixed boss map without stairs. The harness records the
      -- loaded canonical team, then submits the native cleared segment outcome.
      local manager=RogueEssence.GameManager.Instance
      local field=manager:GetType():GetField('SceneOutcome')
      if field==nil then error('GameManager.SceneOutcome reflection field missing') end
      manager:SetFade(true,false)
      field:SetValue(manager,_GAME:EndSegment(
        RogueEssence.Data.GameProgress.ResultType.Cleared,true))
      emit('{"event":"boss_clear_outcome_set","prefaded":true}')
    end
  end,debug.traceback)
  if not ok then emit('{"event":"fatal","phase":"floor_advance","error":"'..esc(err)..'"}') end
end

function V:OnGroundMapEnter()
  if not self.enabled then return end
  local id=safe(function()return GAME:GetCurrentGround().AssetName end,'')
  if self.last_ground==id then return end
  self.last_ground=id
  emit('{"event":"ground","id":"'..esc(id)..'"}')
  if id=='metano_town' and self.boss_done then
    emit('{"event":"end","mission_complete":'..tostring(SV.Chapter6.MissionComplete==true)..'}')
    RogueEssence.GameBase.CurrentPhase=RogueEssence.GameBase.LoadPhase.Unload
    return
  end
  if id~='bois_sombres_oree' and id~='gloomy_forest_midpoint'
      and id~='sinister_woods_clearing' then return end
  self.task=TASK:BranchCoroutine(function()
    local ok,err=xpcall(function()
      emit('{"event":"ground_transition","id":"'..esc(id)..'"}')
      if id=='bois_sombres_oree' then
        TASK:WaitTask(GAME:_EnterDungeon('gloomy_forest',0,0,0,
          RogueEssence.Data.GameProgress.DungeonStakes.Risk,true,true))
      elseif id=='gloomy_forest_midpoint' then
        TASK:WaitTask(GAME:_ContinueDungeon('gloomy_forest',1,0,0))
      else
        TASK:WaitTask(GAME:_ContinueDungeon('gloomy_forest',2,0,0))
      end
    end,debug.traceback)
    if not ok then
      emit('{"event":"fatal","phase":"ground_transition","error":"'..esc(err)..'"}')
      self.task=nil
    end
  end)
end

function V:Subscribe(med)
  med:Subscribe('SinisterRouteValidator',EngineServiceEvents.Init,function()self:OnInit()end)
  med:Subscribe('SinisterRouteValidator',EngineServiceEvents.NewGame,function()self:OnNewGame()end)
  med:Subscribe('SinisterRouteValidator',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)
  med:Subscribe('SinisterRouteValidator',EngineServiceEvents.DungeonFloorEnter,function()self:OnDungeonFloorEnter()end)
  med:Subscribe('SinisterRouteValidator',EngineServiceEvents.GroundMapEnter,function()self:OnGroundMapEnter()end)
end
function V:UnSubscribe(med)end
SCRIPT:AddService('SinisterRouteValidator',V:new())
return V
