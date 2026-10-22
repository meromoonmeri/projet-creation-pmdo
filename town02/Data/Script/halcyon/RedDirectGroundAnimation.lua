-- Exact map-relative palette scheduler for PMD Red direct dungeon Grounds.
--
-- Generated map metadata groups cells by canonical CEL descriptor.  This
-- module changes a descriptor group's TileFrame only when its observable GBA
-- color-state key changes.  Start/Finish/Cancel explicitly own lifecycle; a
-- superseded coroutine observes its inactive token and exits after at most two
-- PMDO frames, so re-entry cannot leave a permanent animation task behind.

local RedDirectGroundAnimation = {}

local current = nil
local PMDO_FRAMES_PER_SECOND = 60

local function state_id(record, tick)
  if tick < record.d then
    return record.r
  end
  local expiry = math.floor(tick / record.d)
  local index = ((expiry - 1) % #record.c) + 1
  return record.c[index]
end

local function state_key(records, tick)
  local values = {}
  for index, record in ipairs(records) do
    values[index] = tostring(state_id(record, tick))
  end
  return table.concat(values, ',')
end

local function apply_descriptor(token, descriptor, tick)
  local key = state_key(descriptor.records, tick)
  if key == descriptor.key then
    return
  end
  local location = descriptor.states[key]
  assert(location ~= nil,
    string.format('État CANM absent pour %s au tick %d : %s', token.data.asset, tick, key))
  local layer = token.map.Layers[token.data.layer or 0]
  for index = 1, #descriptor.cells, 2 do
    local x = descriptor.cells[index]
    local y = descriptor.cells[index + 1]
    local tile = layer.Tiles[x][y]
    tile.Layers[0].Frames[0] = RogueEssence.Dungeon.TileFrame(
      RogueElements.Loc(location[1], location[2]), token.data.sheet)
  end
  descriptor.key = key
end

local function apply_tick(token, tick)
  for _, descriptor in ipairs(token.data.descriptors) do
    apply_descriptor(token, descriptor, tick)
  end
  token.tick = tick
end

local function run(token)
  -- Convert exact GBA frame time to nominal 60 Hz PMDO waits with an integer
  -- remainder.  numerator/denominator = 60 / GBA_FPS, so waits are normally
  -- one frame and occasionally two; accumulated timing error stays < 1 frame.
  local numerator = token.data.gba_cycles_per_frame * PMDO_FRAMES_PER_SECOND
  local denominator = token.data.gba_master_clock
  local remainder = 0
  while token.active and current == token do
    if token.paused then
      GAME:WaitFrames(1)
    else
      remainder = remainder + numerator
      local frames = math.floor(remainder / denominator)
      remainder = remainder - frames * denominator
      GAME:WaitFrames(frames)
      if token.active and current == token and not token.paused then
        apply_tick(token, token.tick + 1)
      end
    end
  end
end

function RedDirectGroundAnimation.Start(map, data)
  RedDirectGroundAnimation.Cancel()
  assert(map ~= nil, 'GroundMap absent pour RedDirectGroundAnimation.Start')
  assert(data ~= nil and data.asset ~= nil and data.sheet ~= nil,
    'Métadonnées invalides pour RedDirectGroundAnimation.Start')
  for _, descriptor in ipairs(data.descriptors) do
    descriptor.key = nil
  end
  local token = {active = true, paused = false, map = map, data = data, tick = 0, coroutine = nil}
  current = token
  apply_tick(token, 0)
  token.coroutine = TASK:BranchCoroutine(function() run(token) end)
  return token
end

function RedDirectGroundAnimation.Update(map)
  -- The scheduler coroutine continues during scripted scenes.  Update remains
  -- an explicit callback hook and lifecycle guard for integration with Grounds.
  if current ~= nil and map ~= nil and current.map ~= map then
    RedDirectGroundAnimation.Cancel(current.map)
  end
end

function RedDirectGroundAnimation.Cancel(map)
  if current == nil then
    return false
  end
  if map ~= nil and current.map ~= map then
    return false
  end
  local token = current
  current = nil
  token.active = false
  token.map = nil
  token.data = nil
  token.coroutine = nil
  return true
end

function RedDirectGroundAnimation.Finish(map)
  return RedDirectGroundAnimation.Cancel(map)
end

-- Deterministic inspection hooks.  They are also useful to pause palette motion
-- during menus/cutscenes without destroying the scheduler's ownership token.
function RedDirectGroundAnimation.Pause(map)
  if current == nil or (map ~= nil and current.map ~= map) then
    return false
  end
  current.paused = true
  return true
end

function RedDirectGroundAnimation.Resume(map)
  if current == nil or (map ~= nil and current.map ~= map) then
    return false
  end
  current.paused = false
  return true
end

function RedDirectGroundAnimation.Seek(map, tick)
  if current == nil or (map ~= nil and current.map ~= map) then
    return false
  end
  assert(type(tick) == 'number' and tick >= 0 and tick == math.floor(tick),
    'Tick CANM invalide pour RedDirectGroundAnimation.Seek')
  apply_tick(current, tick)
  return true
end

function RedDirectGroundAnimation.CurrentTick()
  if current == nil then
    return nil
  end
  return current.tick
end

function RedDirectGroundAnimation.ActiveAsset()
  if current == nil then
    return nil
  end
  return current.data.asset
end

return RedDirectGroundAnimation
