-- Canonical PMD Red personality-question selection and scoring for New Era.
--
-- PMD_RED_EU_CANON: question order, category rejection, BraveQuest2B,
-- effects, and strict-greater tie resolution mirror pret/pmd-red.
-- NEW_ERA_ADAPTATION: RNG is injected so production can use GAME.Rand while
-- the isolated PMDO validator can replay an exact deterministic timeline.
local Data = require 'halcyon.ground.personality_test.pmdred_quiz_data'

local QuizEngine = {}

local function require_integer(value, message)
  if type(value) ~= 'number' or value ~= math.floor(value) then
    error(message)
  end
end

local function question(question_id)
  local value = Data.questions[question_id]
  if value == nil then
    error('unknown PMD Red EU personality question: ' .. tostring(question_id))
  end
  return value
end

function QuizEngine.NewState()
  local state = {
    totals = {},
    asked = {},
    history = {},
  }
  for _, personality in ipairs(Data.personalities) do
    state.totals[personality] = 0
  end
  return state
end

function QuizEngine.SelectQuestions(next_int)
  if type(next_int) ~= 'function' then
    error('PMD Red EU question selection requires an injected next_int function')
  end

  local selected = {}
  local used_categories = {}
  while #selected < Data.asked_question_count do
    local index = next_int(#Data.selectable)
    require_integer(index, 'PMD Red EU question RNG returned a non-integer')
    if index < 0 or index >= #Data.selectable then
      error('PMD Red EU question RNG returned an out-of-range index')
    end
    local question_id = Data.selectable[index + 1]
    local category = question(question_id).category
    if not used_categories[category] then
      used_categories[category] = true
      selected[#selected + 1] = question_id
    end
  end
  return selected
end

function QuizEngine.ApplyAnswer(state, question_id, answer_index)
  if type(state) ~= 'table' or type(state.totals) ~= 'table' then
    error('invalid PMD Red EU quiz state')
  end
  require_integer(answer_index, 'PMD Red EU answer index must be an integer')
  local current = question(question_id)
  local answer = current.answers[answer_index]
  if answer == nil then
    error('answer index out of range for ' .. question_id)
  end

  local history = {
    question = question_id,
    answer = answer_index,
    value = answer.value,
  }
  state.history[#state.history + 1] = history
  state.asked[question_id] = true

  if answer.value == Data.branch_trigger then
    history.branch = Data.branch_question
    return Data.branch_question
  end

  for personality, points in pairs(answer.effects) do
    if state.totals[personality] == nil then
      error('unknown PMD Red EU personality effect: ' .. tostring(personality))
    end
    state.totals[personality] = state.totals[personality] + points
  end
  return nil
end

function QuizEngine.ResolvePersonality(state, tie_start)
  if type(state) ~= 'table' or type(state.totals) ~= 'table' then
    error('invalid PMD Red EU quiz state')
  end
  require_integer(tie_start, 'PMD Red EU tie RNG returned a non-integer')
  if tie_start < 0 or tie_start >= #Data.personalities then
    error('PMD Red EU tie RNG returned an out-of-range index')
  end

  -- RevealPersonality initializes playerNature randomly, then visits the other
  -- twelve natures cyclically and replaces the winner only for a strict >.
  local best_index = tie_start + 1
  for offset = 1, #Data.personalities - 1 do
    local candidate_index = ((tie_start + offset) % #Data.personalities) + 1
    local candidate = Data.personalities[candidate_index]
    local best = Data.personalities[best_index]
    if state.totals[candidate] > state.totals[best] then
      best_index = candidate_index
    end
  end
  return Data.personalities[best_index]
end

function QuizEngine.Data()
  return Data
end

return QuizEngine
