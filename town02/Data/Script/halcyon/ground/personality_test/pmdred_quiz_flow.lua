-- Integrated PMD Red EU personality-quiz presentation for New Era.
--
-- This module extends the one existing personality_test flow.  It is not a
-- route and does not create a second quiz.  Canonical Red behaviour and the
-- two required New Era adaptations are labelled at their point of use.
require 'origin.common'

local Engine = require 'halcyon.ground.personality_test.pmdred_quiz_engine'
local IntroText = require 'halcyon.pmdred_eu.FrenchText'

local QuizFlow = {}

-- PMD_RED_EU_CANON: gStarters[NUM_PERSONALITIES][MALE/FEMALE] from the pinned
-- pret source.  These are recommendations only; the integrated New Era hero
-- selector remains unrestricted to its complete configured starter catalogue.
local CANONICAL_RECOMMENDATIONS = {
  hardy = {'charmander', 'pikachu'},
  docile = {'bulbasaur', 'chikorita'},
  brave = {'machop', 'charmander'},
  jolly = {'squirtle', 'totodile'},
  impish = {'pikachu', 'cubone'},
  naive = {'totodile', 'eevee'},
  timid = {'cyndaquil', 'mudkip'},
  hasty = {'torchic', 'skitty'},
  sassy = {'treecko', 'torchic'},
  calm = {'mudkip', 'bulbasaur'},
  relaxed = {'psyduck', 'squirtle'},
  lonely = {'cubone', 'psyduck'},
  quirky = {'meowth', 'treecko'},
}

local function emit(options, event, payload)
  if options ~= nil and options.on_action ~= nil then
    options.on_action(event, payload or {})
  end
end

local function next_int(options, maximum, purpose)
  local value
  if options ~= nil and options.next_int ~= nil then
    value = options.next_int(maximum, purpose)
  else
    value = GAME.Rand:Next(0, maximum)
  end
  emit(options, 'QUIZ_RNG', {maximum = maximum, purpose = purpose, value = value})
  return value
end

local function present_segment(text, context, options)
  emit(options, 'QUIZ_TEXT_BEGIN', {
    context = context,
    text = text,
  })
  if options ~= nil and options.present_segment ~= nil then
    options.present_segment(text, context)
  else
    UI:WaitShowVoiceOver(STRINGS:Format(text), -1)
  end
  emit(options, 'QUIZ_TEXT_END', {context = context})
end

local function present_segments(payload, context, options, omit_last)
  local count = #payload.segments
  if omit_last then count = count - 1 end
  for index = 1, count do
    local segment = payload.segments[index]
    emit(options, 'QUIZ_CONTROL', {
      context = context,
      segment = index,
      after = segment.after or 'end',
    })
    present_segment(segment.text, context .. ':' .. tostring(index), options)
  end
end

local function flattened_answer_text(payload)
  local chunks = {}
  for _, segment in ipairs(payload.segments) do
    chunks[#chunks + 1] = segment.text
  end
  return table.concat(chunks, '\n')
end

local function choose(prompt, choices, context, options)
  emit(options, 'QUIZ_CHOICE_BEGIN', {
    context = context,
    prompt = prompt,
    choice_count = #choices,
  })
  local result
  if options ~= nil and options.choose ~= nil then
    result = options.choose(prompt, choices, context)
  else
    UI:SetCenter(false)
    UI:BeginChoiceMenu(STRINGS:Format(prompt), choices, 1, 1)
    UI:WaitForChoice()
    result = UI:ChoiceResult()
  end
  if type(result) ~= 'number' or result ~= math.floor(result)
      or result < 1 or result > #choices then
    error('invalid PMD Red EU quiz choice for ' .. context)
  end
  emit(options, 'QUIZ_CHOICE_END', {context = context, result = result})
  return result
end

local function ask_payload(payload, answers, context, options)
  present_segments(payload, context, options, true)
  local prompt = payload.segments[#payload.segments].text
  local choices = {}
  for _, answer in ipairs(answers) do
    choices[#choices + 1] = flattened_answer_text(answer.text or answer)
  end
  return choose(prompt, choices, context, options)
end

local function substituted(payload, replacement)
  local result = {segments = {}}
  for _, segment in ipairs(payload.segments) do
    result.segments[#result.segments + 1] = {
      text = segment.text:gsub('%$m0', replacement),
      after = segment.after,
    }
  end
  return result
end

function QuizFlow.PlayCanonicalPrelude(options)
  -- PMD_RED_EU_CANON: s01 MSG_ON_BG order, internal #W page, BGM switch,
  -- CMD_BYTE_22 palette fade-in duration 0x1e (30 frames).
  local pages = {
    {'PMDRED_EU_S01_001', IntroText.PMDRED_EU_S01_001},
    {'PMDRED_EU_S01_002', IntroText.PMDRED_EU_S01_002},
    {'PMDRED_EU_S01_003', IntroText.PMDRED_EU_S01_003},
    {'PMDRED_EU_S01_004', IntroText.PMDRED_EU_S01_004},
    {'PMDRED_EU_S01_005', IntroText.PMDRED_EU_S01_005},
    {'PMDRED_EU_S01_006_A', IntroText.PMDRED_EU_S01_006_A},
    {'PMDRED_EU_S01_006_B', IntroText.PMDRED_EU_S01_006_B},
  }
  UI:SetCenter(true)
  emit(options, 'QUIZ_PRELUDE_BEGIN', {page_count = #pages})
  for index, row in ipairs(pages) do
    present_segment(row[2], 'prelude:' .. row[1], options)
    emit(options, 'QUIZ_PRELUDE_PAGE', {index = index, key = row[1]})
  end
  UI:SetCenter(false)
  emit(options, 'QUIZ_BGM_SWITCH', {cue = 'Welcome to the World of Pokémon!.ogg'})
  if options == nil or not options.suppress_engine_presentation then
    SOUND:PlayBGM('Welcome to the World of Pokémon!.ogg', true)
    GAME:FadeIn(30)
    GAME:WaitFrames(30)
  end
  emit(options, 'QUIZ_PALETTE_FADE_IN_END', {frames = 30, source_opcode = 'CMD_BYTE_22'})
  emit(options, 'QUIZ_PRELUDE_END')
end

function QuizFlow.Run(options)
  local data = Engine.Data()
  while true do
    local state = Engine.NewState()
    local selected = Engine.SelectQuestions(function(maximum)
      return next_int(options, maximum, 'question')
    end)
    emit(options, 'QUIZ_QUESTIONS_SELECTED', {questions = selected})

    for asked_index, question_id in ipairs(selected) do
      local current_id = question_id
      while current_id ~= nil do
        local current = data.questions[current_id]
        local answer_index = ask_payload(
          current.text,
          current.answers,
          'question:' .. current_id,
          options
        )
        emit(options, 'QUIZ_ANSWER', {
          asked_index = asked_index,
          question = current_id,
          answer = answer_index,
        })
        current_id = Engine.ApplyAnswer(state, current_id, answer_index)
        if current_id ~= nil then
          emit(options, 'QUIZ_BRANCH', {
            source = question_id,
            target = current_id,
          })
        end
      end
    end

    -- PMD_RED_EU_CANON: Boy/Girl remain choices 1 and 2.
    -- NEW_ERA_ADAPTATION: preserve New Era's existing non-binary option as 3.
    local gender_answers = {
      data.gender.answers[1],
      data.gender.answers[2],
      {segments = {{text = 'Non-binaire.', after = nil}}},
    }
    local gender_choice = ask_payload(
      data.gender.question,
      gender_answers,
      'gender',
      options
    )
    local gender
    if gender_choice == 1 then gender = Gender.Male
    elseif gender_choice == 2 then gender = Gender.Female
    else gender = Gender.Genderless end
    emit(options, 'QUIZ_GENDER', {choice = gender_choice})

    local tie_start = next_int(options, #data.personalities, 'tie')
    local personality = Engine.ResolvePersonality(state, tie_start)
    emit(options, 'QUIZ_PERSONALITY', {
      personality = personality,
      tie_start = tie_start,
    })
    UI:SetCenter(true)
    present_segments(data.descriptions[personality], 'description:' .. personality, options, false)
    UI:SetCenter(false)

    -- The historical table has no non-binary column.  The first column is used
    -- only as a non-binding recommendation on that New Era path; species and
    -- gender remain freely editable in the complete New Era selector.
    local recommendation_column = gender_choice == 2 and 2 or 1
    local recommendation = CANONICAL_RECOMMENDATIONS[personality][recommendation_column]
    local recommendation_name = recommendation
    if options == nil or options.resolve_species_name == nil then
      recommendation_name = _DATA:GetMonster(recommendation):GetColoredName()
    else
      recommendation_name = options.resolve_species_name(recommendation)
    end
    emit(options, 'QUIZ_RECOMMENDATION', {
      personality = personality,
      species = recommendation,
      historical_gender_column = recommendation_column,
      new_era_non_binding = true,
    })

    local confirmation = substituted(data.eu_confirmation.question, recommendation_name)
    local confirmation_choice = ask_payload(
      confirmation,
      {
        data.eu_confirmation.confirm,
        data.eu_confirmation.restart,
      },
      'recommendation_confirmation',
      options
    )
    if confirmation_choice == 1 then
      UI:SetCenter(true)
      present_segments(
        substituted(data.presentation_text.starter_reveal, recommendation_name),
        'starter_reveal',
        options,
        false
      )
      UI:SetCenter(false)
      emit(options, 'QUIZ_COMPLETE', {
        personality = personality,
        gender_choice = gender_choice,
        recommendation = recommendation,
      })
      return {
        personality = personality,
        personality_label = data.personality_labels[personality],
        gender = gender,
        gender_choice = gender_choice,
        recommendation = recommendation,
        totals = state.totals,
        selected_questions = selected,
      }
    end
    emit(options, 'QUIZ_RESTART')
  end
end

function QuizFlow.ShowPartnerPrompt(options)
  local data = Engine.Data()
  UI:SetCenter(true)
  present_segments(data.presentation_text.partner_prompt, 'partner_prompt', options, false)
  UI:SetCenter(false)
end

function QuizFlow.PartnerNicknamePrompt()
  local data = Engine.Data()
  return flattened_answer_text(data.presentation_text.partner_nick_prompt)
end

function QuizFlow.ShowEndText(options)
  local data = Engine.Data()
  UI:SetCenter(true)
  present_segments(data.presentation_text.end_text, 'end_text', options, false)
  UI:SetCenter(false)
end

function QuizFlow.FadeOutCanonical(options)
  -- PMD_RED_EU_CANON: BGM_FADEOUT(30), then blocking CMD_BYTE_23(30).
  emit(options, 'QUIZ_BGM_FADEOUT', {frames = 30})
  emit(options, 'QUIZ_PALETTE_FADE_OUT_BEGIN', {
    frames = 30,
    source_opcode = 'CMD_BYTE_23',
  })
  if options == nil or not options.suppress_engine_presentation then
    SOUND:FadeOutBGM(30)
    GAME:FadeOut(false, 30)
    GAME:WaitFrames(30)
  end
  emit(options, 'QUIZ_PALETTE_FADE_OUT_END', {frames = 30})
end

function QuizFlow.PrioritizeRecommendation(values, recommendation, species_of)
  -- NEW_ERA_ADAPTATION: move, never filter. Every input catalogue entry is
  -- preserved exactly once and the Red result only determines the first row.
  local prioritized = {}
  local deferred = {}
  for _, value in ipairs(values) do
    local species = species_of ~= nil and species_of(value) or value
    if species == recommendation then
      prioritized[#prioritized + 1] = value
    else
      deferred[#deferred + 1] = value
    end
  end
  for _, value in ipairs(deferred) do prioritized[#prioritized + 1] = value end
  return prioritized
end

return QuizFlow
