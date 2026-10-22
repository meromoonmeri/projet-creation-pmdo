require 'origin.common'
require 'origin.services.baseservice'
local V=Class('SinisterWoodsB41StartupAdapter',BaseService)
local CATS={'sinister_woods_b41_floor','sinister_woods_b41_wall','sinister_woods_b41_secondary'}
local FIELDS={'Tilex00','Tilex01','Tilex02','Tilex03','Tilex13','Tilex04','Tilex05','Tilex06','Tilex26','Tilex07','Tilex17','Tilex27','Tilex37','Tilex08','Tilex09','Tilex89','Tilex0A','Tilex0B','Tilex1B','Tilex8B','Tilex9B','Tilex0C','Tilex4C','Tilex0D','Tilex4D','Tilex8D','TilexCD','Tilex0E','Tilex2E','Tilex4E','Tilex6E','Tilex0F','Tilex1F','Tilex2F','Tilex3F','Tilex4F','Tilex5F','Tilex6F','Tilex7F','Tilex8F','Tilex9F','TilexAF','TilexBF','TilexCF','TilexDF','TilexEF','TilexFF'}
local function each_layer(fn)
  for _,cat in ipairs(CATS) do
    local auto=_DATA:GetAutoTile(cat)
    for _,field in ipairs(FIELDS) do
      local variants=auto.Tiles[field]
      for vi=0,variants.Count-1,1 do
        local layers=variants[vi]
        for li=0,layers.Count-1,1 do fn(layers[li]) end
      end
    end
  end
end
local function frame(x,y)return RogueEssence.Dungeon.TileFrame(RogueElements.Loc(x,y),'SinisterWoodsB41')end
local function clock()return tonumber(RogueEssence.Content.GraphicsManager.TotalFrameTick)end
local function restore_raw_startup()
  local count=0
  each_layer(function(layer)
    if layer.Frames.Count==16 and (layer.FrameLength==8 or layer.FrameLength==12) then
      local first=layer.Frames[0]
      local x=first.TexLoc.X;local y=first.TexLoc.Y;local row=y%16
      local group=math.floor(y/16)
      local record=math.floor((group-15)/16)-1
      if record>=0 and record<16 then
        layer.Frames:RemoveAt(0)
        layer.Frames:Add(frame(x,((1+record)*16+15)*16+row))
        layer.Frames:Insert(0,frame(x,(17*16+record)*16+row))
        count=count+1
      end
    end
  end)
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] raw_startup_restored='..tostring(count)..' tick='..tostring(clock()))
end
local function publish_record(duration,origin)
  local count=0
  each_layer(function(layer)
    if layer.Frames.Count==17 and layer.FrameLength==duration then
      layer.Frames:RemoveAt(0)
      local last=layer.Frames[layer.Frames.Count-1]
      layer.Frames:RemoveAt(layer.Frames.Count-1)
      layer.Frames:Insert(0,last)
      count=count+1
    end
  end)
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] published_duration='..tostring(duration)..' layers='..tostring(count)..' tick='..tostring(clock())..' delta='..tostring(clock()-(origin or clock())))
end
function V:initialize()BaseService.initialize(self);self.enabled=true;self.running=false end
function V:OnDungeonMapInit()
  if not self.enabled or tostring(_ZONE.CurrentZoneID)~='gloomy_forest' or self.running then return end
  self.running=true
  local origin=clock()
  PrintInfo('[SINISTER_WOODS_B41_ADAPTER] map_start_tick='..tostring(origin))
  TASK:BranchCoroutine(function()
    local ok,err=xpcall(function()
      restore_raw_startup()
      GAME:WaitFrames(8);publish_record(8,origin)
      GAME:WaitFrames(4);publish_record(12,origin)
    end,debug.traceback)
    if not ok then PrintInfo('[SINISTER_WOODS_B41_ADAPTER] FAIL '..tostring(err)) end
    self.running=false
  end)
end
function V:Subscribe(med)med:Subscribe('SinisterWoodsB41StartupAdapter',EngineServiceEvents.DungeonMapInit,function()self:OnDungeonMapInit()end)end
function V:UnSubscribe(med)end
SCRIPT:AddService('SinisterWoodsB41StartupAdapter',V:new())
return V
