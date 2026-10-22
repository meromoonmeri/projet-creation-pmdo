-- PMD Red EU isolated scene primitives.
--
-- This namespace is deliberately independent from FugitiveArc and the New Era
-- chapter flags.  It never edits a Ground: scene code may only assert the
-- certified Ground identity and stage transient UI/audio/actors over it.
require 'origin.common'

local ScenePlayer = {}

local function emit(options, event, payload)
  if options ~= nil and options.on_action ~= nil then
    options.on_action(event, payload or {})
  end
end

function ScenePlayer.StopBGM(options)
  emit(options, 'BGM_STOP_BEGIN')
  SOUND:StopBGM()
  emit(options, 'BGM_STOP_END')
end

function ScenePlayer.AssertGround(asset, options)
  local current = GAME:GetCurrentGround()
  if current == nil or current.AssetName ~= asset then
    error('PMD Red EU scene expected immutable Ground ' .. asset)
  end
  emit(options, 'SELECT_MAP_ASSERTED', {asset = asset})
end

function ScenePlayer.HideActiveTeamForPresentation(options)
  local hidden = 0
  for _, name in ipairs({'PLAYER', 'Teammate1', 'Teammate2', 'Teammate3'}) do
    local actor = CH(name)
    if actor ~= nil then
      GROUND:Hide(actor.EntName)
      hidden = hidden + 1
    end
  end
  emit(options, 'PRESENTATION_ACTORS_HIDDEN', {
    actor_count = hidden,
    adaptation = 'source_sector_has_no_lives',
  })
end

local function show_background_page(text, options)
  local duration = -1
  if options ~= nil and options.auto_advance_frames ~= nil then
    duration = options.auto_advance_frames
  end
  UI:WaitShowVoiceOver(text, duration)
end

function ScenePlayer.CenteredBackgroundText(key, pages, texts, options)
  emit(options, 'MSG_ON_BG_BEGIN', {key = key, page_count = #pages})
  UI:ResetSpeaker()
  UI:SetCenter(true)
  for page_index, page_key in ipairs(pages) do
    emit(options, 'MSG_ON_BG_PAGE_BEGIN', {key = key, page = page_index, page_key = page_key})
    local capture_task = nil
    if options ~= nil and options.on_page_present ~= nil then
      capture_task = TASK:BranchCoroutine(function()
        GAME:WaitFrames(options.capture_delay_frames or 4)
        options.on_page_present(key, page_index, page_key)
      end)
    end
    local text = texts[page_key]
    if text == nil then error('missing exact PMD Red EU French text: ' .. page_key) end
    show_background_page(STRINGS:Format(text), options)
    if capture_task ~= nil then
      TASK:JoinCoroutines({capture_task})
    end
    emit(options, 'MSG_ON_BG_PAGE_END', {key = key, page = page_index, page_key = page_key})
  end
  emit(options, 'MSG_ON_BG_END', {key = key, page_count = #pages})
end

function ScenePlayer.ClearText(options)
  UI:ResetSpeaker()
  UI:SetCenter(false)
  emit(options, 'TEXTBOX_CLEAR')
end

function ScenePlayer.SelectCertifiedGroundEntities(group, sector, options)
  -- The 219 certified Grounds are immutable. The selected Ground already owns
  -- its canonical visual/effect sector; no actor or entity is injected here.
  emit(options, 'SELECT_ENTITIES_ASSERTED', {
    group = group,
    sector = sector,
    adaptation = 'certified_ground_state_no_mutation',
  })
end

function ScenePlayer.PlayBGM(cue, options)
  emit(options, 'BGM_SWITCH_BEGIN', {cue = cue})
  SOUND:PlayBGM(cue, true)
  emit(options, 'BGM_SWITCH_END', {cue = cue})
end

function ScenePlayer.Dependency(id, source_opcode, options)
  local payload = {id = id, source_opcode = source_opcode}
  emit(options, 'DEPENDENCY_BLOCKED', payload)
  return {
    complete = false,
    dependency = id,
    source_opcode = source_opcode,
  }
end

return ScenePlayer
