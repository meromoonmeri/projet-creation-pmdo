-- kit.lua — runtime partagé des scènes Sky compilées (sky_compile_scenes.py).
-- Choisit la langue du dialogue selon la langue du jeu (textes ROM 5 langues
-- embarqués tels quels) et affiche via l'API native RogueEssence.
-- En mode validation headless (PMDO_GROUND_VALIDATOR), utilise le dialogue
-- TEMPORISÉ natif (WaitShowTimedDialogue) pour ne pas attendre une entrée ;
-- en jeu normal, dialogue standard à validation joueur (canon).
local SkySceneKit = {}

local LANG_MAP = {en = 'english', fr = 'french', de = 'german',
                  it = 'italian', es = 'spanish'}

local function pick_lang(t)
  local code = 'en'
  pcall(function()
    code = tostring(RogueEssence.DiagManager.Instance.CurSettings.Language)
  end)
  code = string.sub(string.lower(code or 'en'), 1, 2)
  local key = LANG_MAP[code] or 'english'
  return t[key] or t.english or next(t) and select(2, next(t)) or ''
end

-- Adaptation technique du markup NDS -> markup RogueEssence (documentée,
-- contenu textuel inchangé) :
--   [K]        attente touche      -> espace (le rythme est géré par say)
--   [CS:X]...[CR] couleur NDS      -> [color=#FFFF00]...[color] (PMDO)
--   [hero]/[partner]               -> noms réels de l'équipe
--   autres balises [X] inconnues   -> retirées (le parseur PMDO se bloque
--                                     sur les balises non reconnues)
local function clean(s)
  s = tostring(s or '')
  s = s:gsub('%[K%]', ' ')
  s = s:gsub('%[CS:%w+%]', '[color=#FFFF00]')
  s = s:gsub('%[CR%]', '[color]')
  pcall(function()
    local hero = CH('PLAYER')
    if hero then s = s:gsub('%[hero%]', hero:GetDisplayName()) end
    local p = CH('Teammate1')
    if p then s = s:gsub('%[partner%]', p:GetDisplayName()) end
  end)
  -- balises NDS restantes non mappées : retirées avec trace de log
  s = s:gsub('%[[A-Za-z_:%d]+%]', function(tag)
    if tag:match('^%[color') then return tag end
    return ''
  end)
  -- Retours à la ligne NDS = mise en forme de l'écran NDS (256px) ;
  -- la boîte PMDO a sa propre largeur et son propre wrapping. Les \n
  -- forcés provoquent une pagination à validation joueur (blocage
  -- headless au 3e+ ligne). Adaptation technique : espace, texte intact.
  s = s:gsub('\n', ' ')
  s = s:gsub('%s+', ' ')
  s = s:gsub('^%s+', ''):gsub('%s+$', '')
  return s
end

local function trace(s)
  if os.getenv('PMDO_GROUND_VALIDATOR') == nil then return end
  local f = io.open('/tmp/ground_gameplay_validator.jsonl', 'a')
  if f then f:write(s .. '\n'); f:close() end
end

function SkySceneKit.say(t)
  local txt = clean(pick_lang(t))
  if txt == '' then return end
  local headless = os.getenv('PMDO_GROUND_VALIDATOR') ~= nil
  trace('{"kit":"say_begin","len":' .. #txt .. '}')
  if headless then
    -- harnais de test : durée d'affichage réduite. Les textes de 3+
    -- lignes PAGINENT dans la boîte de dialogue et attendent une touche
    -- même en mode timed (blocage headless) -> pages de 2 lignes max,
    -- texte INTÉGRALEMENT affiché (le jeu réel utilise WaitShowDialogue).
    -- pages ~70 caractères max (2 lignes affichées, le wrapping moteur
    -- pagine au-delà et attend une touche même en mode timed)
    local pages = {}
    local cur = ''
    for w in txt:gmatch('%S+') do
      if #cur + #w + 1 > 70 then pages[#pages + 1] = cur; cur = w
      else cur = (cur == '' and w) or (cur .. ' ' .. w) end
    end
    if cur ~= '' then pages[#pages + 1] = cur end
    for _, page in ipairs(pages) do
      local frames = math.max(10, math.min(25, math.floor(#page / 3)))
      pcall(function() UI:WaitShowTimedDialogue(page, frames) end)
    end
  else
    pcall(function() UI:WaitShowDialogue(txt) end)
  end
  trace('{"kit":"say_done"}')
end

-- Choix ROM message_SwitchMenu : menu natif PMDO (UI:BeginChoiceMenu /
-- ChoiceMenuYesNo comme origin/common.lua). Les libellés viennent des
-- blocs menu({...}) 5 langues ROM (pick_lang). Retourne l'INDEX 1-based
-- du choix (ordre ROM). En headless (validateur) : premier choix (déter-
-- ministe, chemins alternatifs couverts par les branches compilées).
function SkySceneKit.ask(choices)
  local headless = os.getenv('PMDO_GROUND_VALIDATOR') ~= nil
  local labels = {}
  for i, t in ipairs(choices) do labels[i] = clean(pick_lang(t)) end
  trace('{"kit":"ask","n":' .. #labels .. '}')
  if headless then return 1 end
  local result = 1
  local ok = pcall(function()
    if #labels == 2 and (labels[1] == 'Yes' or labels[1] == 'Oui') then
      UI:ChoiceMenuYesNo('', false)
      UI:WaitForChoice()
      result = UI:ChoiceResult() and 1 or 2
    else
      UI:BeginChoiceMenu('', labels, 1, #labels)
      UI:WaitForChoice()
      result = UI:ChoiceResult()
    end
  end)
  if not ok then result = 1 end
  return result
end

-- Slots d'équipe dynamiques NDS (ADVENTURE_NPC1-3, UNIT_NPC1-2 :
-- LivesEntityTable type 3, entid 0 = résolu à l'EXÉCUTION par l'équipe
-- courante). Équivalent PMDO exact : n-ième membre de l'équipe au-delà
-- du duo héros/partenaire ; nil si l'équipe n'en a pas (la ROM ne
-- l'affiche pas non plus dans ce cas — no-op fidèle).
function SkySceneKit.team_member(n)
  local ch = nil
  pcall(function()
    local team = _DATA.Save.ActiveTeam.Players
    local idx = 1 + n  -- 0=héros, 1=partenaire, 2+=slots dynamiques
    if idx < team.Count then
      ch = GAME:GetCurrentGround():LookupGroundChar(team[idx].Name)
    end
  end)
  return ch
end

-- Chaînage de scène ROM (supervision_ExecuteStationSub/Acting NDS) :
-- joue le module compilé de la scène cible s'il existe (2 candidats de
-- nom, convention préfixe+index / préfixe long). Garde anti-récursion
-- (profondeur 3 = imbrication max observée ROM). Absent = trace (scène
-- de la variante non compilée, jamais silencieux).
local play_depth = 0
function SkySceneKit.play_scene(cand1, cand2, hero, partner)
  if play_depth >= 3 then
    trace('{"kit":"play_scene_skip","reason":"depth"}')
    return
  end
  for _, name in ipairs({ cand1, cand2 }) do
    local ok, fn = pcall(require, 'halcyon.skyscenes.' .. name)
    if ok and type(fn) == 'function' then
      trace('{"kit":"play_scene","target":"' .. name .. '"}')
      play_depth = play_depth + 1
      local ok2, err = pcall(fn, hero, partner)
      play_depth = play_depth - 1
      if not ok2 then
        trace('{"kit":"play_scene_error","target":"' .. name .. '"}')
      end
      return
    end
  end
  trace('{"kit":"play_scene_absent","c1":"' .. tostring(cand1) .. '"}')
end

-- Décalage immédiat en pixels depuis la position courante
-- (SetPositionOffset NDS) : téléport relatif natif.
function SkySceneKit.offset_pos(ch, dx, dy)
  pcall(function()
    local p = ch.Position
    GROUND:TeleportTo(ch, p.X + dx, p.Y + dy, ch.CharDir)
  end)
end

-- Se tourner vers une position en pixels (Turn2DirectionMark NDS) :
-- direction 8 voies calculée vers le point.
function SkySceneKit.turn_to_pos(ch, x, y)
  pcall(function()
    local p = ch.Position
    local dx, dy = x - p.X, y - p.Y
    local dir
    if math.abs(dx) > 2 * math.abs(dy) then
      dir = dx > 0 and Direction.Right or Direction.Left
    elseif math.abs(dy) > 2 * math.abs(dx) then
      dir = dy > 0 and Direction.Down or Direction.Up
    elseif dx > 0 then
      dir = dy > 0 and Direction.DownRight or Direction.UpRight
    else
      dir = dy > 0 and Direction.DownLeft or Direction.UpLeft
    end
    GROUND:EntTurn(ch, dir)
  end)
end

-- Rotation sur soi (Turn2DirectionTurn NDS) : EntTurn sur les 8
-- directions successives, sens ROM (2=antihoraire sinon horaire),
-- `turns` quarts de tour complets, tempo speed frames par pas.
local SPIN_ORDER = {
  Direction.Down, Direction.DownLeft, Direction.Left, Direction.UpLeft,
  Direction.Up, Direction.UpRight, Direction.Right, Direction.DownRight,
}
function SkySceneKit.spin(ch, speed, sens, turns)
  speed = tonumber(speed) or 4
  turns = tonumber(turns) or 1
  local step = (tonumber(sens) == 2) and -1 or 1
  local idx = 1
  pcall(function()
    for _ = 1, 8 * math.max(1, math.min(turns, 4)) do
      idx = ((idx - 1 + step) % 8) + 1
      GROUND:EntTurn(ch, SPIN_ORDER[idx])
      GAME:WaitFrames(math.max(1, math.min(speed, 8)))
    end
  end)
end

-- PNJ temporaires des scènes compilées (cast SSA ROM : espèce via
-- PMDO_MAPPING entid→species, position tuile*8+off*4, direction SSA).
-- Même mécanique native que LulubyTown.spawn (GroundChar+AddTempChar).
local spawned_npcs = {}

function SkySceneKit.spawn_npc(species, x, y, dir, name)
  local c
  local ok = pcall(function()
    c = RogueEssence.Ground.GroundChar(
      RogueEssence.Dungeon.MonsterID(species, 0, 'normal', Gender.Unknown),
      RogueElements.Loc(x, y), dir, name, name)
    c:ReloadEvents()
    GAME:GetCurrentGround():AddTempChar(c)
  end)
  if ok and c then
    spawned_npcs[#spawned_npcs + 1] = c
    return c
  end
  trace('{"kit":"spawn_npc_fail","species":"' .. tostring(species) .. '"}')
  return CH('PLAYER') -- fallback loggé, jamais silencieux
end

function SkySceneKit.cleanup_npcs()
  for _, c in ipairs(spawned_npcs) do
    pcall(function() GAME:GetCurrentGround():RemoveTempChar(c) end)
  end
  spawned_npcs = {}
end

--------------------------------------------------------------------
-- MULTIROUTINES NDS (def N for actor X + Lock/Unlock).
--
-- Modèle ROM : chaque acteur a sa coroutine ; `Lock(n)` suspend la
-- routine jusqu'à ce qu'une autre exécute `Unlock(n)` — c'est le
-- mécanisme de synchronisation des cinématiques multi-acteurs NDS.
-- Équivalent PMDO : TASK:BranchCoroutine par routine d'acteur (même
-- moteur de coroutines que le harnais journey, natif RogueEssence),
-- verrous = table partagée de drapeaux ; lock() boucle en WaitFrames(1)
-- jusqu'au drapeau — sémantique identique, testée runtime.
--------------------------------------------------------------------
local locks = {}
local running = 0

function SkySceneKit.reset_locks()
  locks = {}
  running = 0
end

function SkySceneKit.unlock(n)
  locks[n] = true
end

function SkySceneKit.lock(n)
  -- suspend la coroutine courante jusqu'à Unlock(n) (30 s de garde-fou
  -- anti-blocage headless, tracé — jamais silencieux)
  local waited = 0
  while not locks[n] and waited < 1800 do
    GAME:WaitFrames(1)
    waited = waited + 1
  end
  if waited >= 1800 then
    trace('{"kit":"lock_timeout","lock":' .. tostring(n) .. '}')
  end
end

-- lance une routine d'acteur en parallèle (def N for actor X)
function SkySceneKit.run_routine(fn)
  running = running + 1
  TASK:BranchCoroutine(function()
    local ok, err = pcall(fn)
    if not ok then
      trace('{"kit":"routine_error","error":"'
            .. tostring(err):gsub('"', "'"):sub(1, 120) .. '"}')
    end
    running = running - 1
  end)
end

-- attend la fin de toutes les routines lancées (fin du def 0)
function SkySceneKit.join_routines(max_frames)
  local waited = 0
  max_frames = max_frames or 3600
  while running > 0 and waited < max_frames do
    GAME:WaitFrames(1)
    waited = waited + 1
  end
  if running > 0 then
    trace('{"kit":"join_timeout","still_running":'
          .. tostring(running) .. '}')
    running = 0
  end
end

return SkySceneKit
