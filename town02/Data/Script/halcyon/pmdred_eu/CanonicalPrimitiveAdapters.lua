-- Proven PMD Red primitive adapters for exact PMDO 0.8.12.
--
-- This module is dormant: it registers no route, mutates no Ground, and never
-- skips an unsupported source command.  Only equivalences certified in
-- PMD_RED_OPCODE_REGISTRY.json are executable here.
local Adapters = {}

Adapters.AUTHORITY = {
  pret_commit = 'bf0092d0e34fd8e49b859a0b5f96f00740faa42d',
  pmdo_runtime_commit = '61c005e1dc9fd4eee6e6e7fcde77364de33d291e',
  rogue_essence_commit = '4961b2271bb0cace74f40f6a85e799e8e4848ace',
}

Adapters.PROVEN = {
  WAIT = true,
  BGM_FADEOUT = true,
  SET_DIR_WAIT = true,
  ROTATE_TO = true,
  CMD_UNK_92 = true,
}

-- PMD Red and RogueElements enumerate east/west in opposite numeric order.
-- Source direction numbers must therefore never be cast directly to PMDO.
local DIRECTIONS = {
  DIRECTION_SOUTH = Direction.Down,
  DIRECTION_SOUTHEAST = Direction.DownRight,
  DIRECTION_EAST = Direction.Right,
  DIRECTION_NORTHEAST = Direction.UpRight,
  DIRECTION_NORTH = Direction.Up,
  DIRECTION_NORTHWEST = Direction.UpLeft,
  DIRECTION_WEST = Direction.Left,
  DIRECTION_SOUTHWEST = Direction.DownLeft,
}
local SOURCE_INDEX_BY_PMDO = {
  [Direction.Down] = 0,
  [Direction.DownRight] = 1,
  [Direction.Right] = 2,
  [Direction.UpRight] = 3,
  [Direction.Up] = 4,
  [Direction.UpLeft] = 5,
  [Direction.Left] = 6,
  [Direction.DownLeft] = 7,
}
local PMDO_BY_SOURCE_INDEX = {
  [0] = Direction.Down,
  [1] = Direction.DownRight,
  [2] = Direction.Right,
  [3] = Direction.UpRight,
  [4] = Direction.Up,
  [5] = Direction.UpLeft,
  [6] = Direction.Left,
  [7] = Direction.DownLeft,
}

local function nonnegative_integer(name, value)
  if type(value) ~= 'number' or value < 0 or value ~= math.floor(value) then
    error('PMD Red adapter expected non-negative integer ' .. name)
  end
  return value
end

local function positive_integer(name, value)
  value = nonnegative_integer(name, value)
  if value == 0 then
    error('PMD Red adapter expected positive integer ' .. name)
  end
  return value
end

function Adapters.ResolveDirection(source_direction)
  if source_direction == -1 then
    return nil
  end
  if type(source_direction) ~= 'string' then
    error('PMD Red directions must be mapped by symbol, never by numeric cast')
  end
  local mapped = DIRECTIONS[source_direction]
  if mapped == nil then
    error('unsupported PMD Red direction symbol: ' .. source_direction)
  end
  return mapped
end

function Adapters.WAIT(frames)
  GAME:WaitFrames(nonnegative_integer('frames', frames))
end

function Adapters.BGM_FADEOUT(frames)
  SOUND:FadeOutBGM(nonnegative_integer('frames', frames))
end

function Adapters.SET_DIR_WAIT(actor, source_direction, frames)
  if actor == nil then
    error('SET_DIR_WAIT requires the source parent actor')
  end
  local mapped = Adapters.ResolveDirection(source_direction)
  if mapped ~= nil then
    GROUND:EntTurn(actor, mapped)
  end
  frames = nonnegative_integer('frames', frames)
  if frames > 0 then
    GAME:WaitFrames(frames)
  end
end

local function shortest_source_step(current, target)
  if current == target then
    return current
  end
  local delta = (target + 8 - current) % 8
  if delta <= 3 then
    return (current + 1) % 8
  end
  return (current + 7) % 8
end

function Adapters.ROTATE_TO(actor, step_frames, transition, source_direction)
  if actor == nil then
    error('ROTATE_TO requires the source parent actor')
  end
  step_frames = positive_integer('step_frames', step_frames)
  local target = Adapters.ResolveDirection(source_direction)
  if transition == 'DIR_TRANS_SPINRIGHT1' then
    -- Source -1 is PMDO +1 because the horizontal enum ordering is mirrored.
    GROUND:CharAnimateTurn(actor, target, step_frames, false)
  elseif transition == 'DIR_TRANS_SPINLEFT1' then
    GROUND:CharAnimateTurn(actor, target, step_frames, true)
  elseif transition == 'DIR_TRANS_10' then
    GROUND:CharAnimateTurnTo(actor, target, step_frames)
  elseif transition == 'DIR_TRANS_11' then
    local target_index = SOURCE_INDEX_BY_PMDO[target]
    local current = SOURCE_INDEX_BY_PMDO[actor.Direction]
    if target_index == nil or current == nil then
      error('ROTATE_TO received an unsupported PMDO direction')
    end
    while current ~= target_index do
      -- The locked source deliberately applies its shortest one-step helper
      -- twice before each wait for transition policy 11.
      current = shortest_source_step(current, target_index)
      current = shortest_source_step(current, target_index)
      GROUND:EntTurn(actor, PMDO_BY_SOURCE_INDEX[current])
      GAME:WaitFrames(step_frames)
    end
  else
    error('unsupported PMD Red ROTATE_TO transition: ' .. tostring(transition))
  end
end

function Adapters.CMD_UNK_92(actor, step_frames, turn_step, target_transform)
  if actor == nil then
    error('CMD_UNK_92 requires the source parent actor')
  end
  step_frames = positive_integer('step_frames', step_frames)
  local current = SOURCE_INDEX_BY_PMDO[actor.Direction]
  if current == nil then
    error('CMD_UNK_92 received an unsupported PMDO direction')
  end
  local offset
  if target_transform == 'DIR_TRANS_SPINRIGHT2' then
    offset = 6
  elseif target_transform == 'DIR_TRANS_SPINLEFT2' then
    offset = 2
  elseif target_transform == 'DIR_TRANS_FLIP' then
    offset = 4
  else
    error('unsupported PMD Red CMD_UNK_92 target transform: ' .. tostring(target_transform))
  end
  local target = PMDO_BY_SOURCE_INDEX[(current + offset) % 8]
  if turn_step == 1 then
    GROUND:CharAnimateTurn(actor, target, step_frames, false)
  elseif turn_step == 2 then
    GROUND:CharAnimateTurn(actor, target, step_frames, true)
  else
    error('unsupported PMD Red CMD_UNK_92 turn step: ' .. tostring(turn_step))
  end
end

function Adapters.Execute(kind, operands, context)
  operands = operands or {}
  context = context or {}
  if kind == 'WAIT' then
    return Adapters.WAIT(operands.frames)
  elseif kind == 'BGM_FADEOUT' then
    return Adapters.BGM_FADEOUT(operands.frames)
  elseif kind == 'SET_DIR_WAIT' then
    return Adapters.SET_DIR_WAIT(context.actor, operands.direction, operands.frames)
  elseif kind == 'ROTATE_TO' then
    return Adapters.ROTATE_TO(
      context.actor, operands.step_frames, operands.transition, operands.direction
    )
  elseif kind == 'CMD_UNK_92' then
    return Adapters.CMD_UNK_92(
      context.actor, operands.step_frames, operands.turn_step, operands.target_transform
    )
  end
  error('unmapped PMD Red primitive (fail-closed): ' .. tostring(kind))
end

return Adapters
