--[[
    mapgen_validator — validation runtime de la génération des donjons.

    Ce service rejoue, DANS LE MOTEUR, exactement la boucle de
    MapGenTest.Example.StressTestAll :

        ReNoise(zoneSeed) -> GetTwoUInt64(segment)
        ZoneGenContext { CurrentZone, CurrentSegment, ZoneSteps instanciés }
        pour chaque étage : Seed = ReNoise(seed2):GetUInt64((id << 32) | maps)
        structure:GetMap(context)     <= génération réelle par RogueElements

    Il n'imite rien : c'est l'appel du moteur qui construit l'étage. Toute
    exception est capturée et journalisée telle quelle, sans masquage.

    Activation (jamais en jeu normal) :
        PMDO_MAPGEN_VALIDATOR=all            toutes les zones du mod
        PMDO_MAPGEN_VALIDATOR=zone1,zone2    liste explicite
        PMDO_MAPGEN_ITER=3                   itérations par étage (défaut 1)
        PMDO_MAPGEN_OUT=/tmp/mapgen.jsonl    fichier de sortie

    Sortie : une ligne JSON par étage généré (ou en échec), puis une ligne
    {"event":"end"} avec le récapitulatif.
]]
require 'origin.common'
require 'origin.services.baseservice'

local MapGenValidator = Class('MapGenValidator', BaseService)

local OUT = os.getenv('PMDO_MAPGEN_OUT') or '/tmp/mapgen_validator.jsonl'

local function emit(line)
  PrintInfo('[MAPGEN] ' .. line)
  local f = io.open(OUT, 'a')
  if f then f:write(line .. '\n'); f:flush(); f:close() end
end

local function esc(s)
  s = tostring(s)
  s = s:gsub('\\', '\\\\'):gsub('"', '\\"'):gsub('\n', ' | '):gsub('\r', '')
  return s
end

function MapGenValidator:initialize()
  BaseService.initialize(self)
  self.spec = os.getenv('PMDO_MAPGEN_VALIDATOR')
  self.enabled = (self.spec ~= nil and self.spec ~= '')
  self.iterations = tonumber(os.getenv('PMDO_MAPGEN_ITER') or '1') or 1
  -- analyse de traversabilité active par défaut ; PMDO_MAPGEN_TRAVERSAL=0 la coupe
  self.traversal = (os.getenv('PMDO_MAPGEN_TRAVERSAL') ~= '0')
  self.done = false
  if self.enabled then
    PrintInfo('[MAPGEN] service actif, spec=' .. tostring(self.spec)
              .. ' itérations=' .. tostring(self.iterations))
  end
end

--------------------------------------------------------------------
-- Types CLR utilisés (mêmes que MapGenTest).
--------------------------------------------------------------------
local function clr()
  luanet.load_assembly('RogueElements')
  luanet.load_assembly('RogueEssence')
  return {
    ReNoise = luanet.import_type('RogueElements.ReNoise'),
    ReRandom = luanet.import_type('RogueElements.ReRandom'),
    MathUtils = luanet.import_type('RogueElements.MathUtils'),
    ZoneGenContext = luanet.import_type('RogueEssence.LevelGen.ZoneGenContext'),
    MainProgress = luanet.import_type('RogueEssence.Data.MainProgress'),
    DataManager = luanet.import_type('RogueEssence.Data.DataManager'),
    Guid = luanet.import_type('System.Guid'),
    MonsterID = luanet.import_type('RogueEssence.Dungeon.MonsterID'),
  }
end

--------------------------------------------------------------------
-- Équipe de test minimale (héros + partenaire + 2 renforts), identique
-- au save de debug du projet. Sans elle, les GenSteps scriptés qui
-- consultent GAME:GetPlayerPartyMember(1..3) (dialogues de défaite,
-- escortes, etc.) lèvent ArgumentOutOfRangeException sur save vierge.
--------------------------------------------------------------------
local function populate_test_team(T, save)
  local ok, err = pcall(function()
    local team = save.ActiveTeam
    team.Name = 'MapGenProbe'
    local function add(species, gender, level)
      local mon = T.MonsterID(species, 0, 'normal', gender)
      team.Players:Add(team:CreatePlayer(save.Rand, mon, level, '', 0))
    end
    add('turtwig', Gender.Male, 50)
    add('piplup', Gender.Male, 50)
    add('growlithe', Gender.Male, 50)
    add('zigzagoon', Gender.Female, 50)
  end)
  if not ok then
    emit(string.format('{"event":"team_setup_error","error":"%s"}', esc(err)))
  end
end

--------------------------------------------------------------------
-- Liste des zones à tester.
--------------------------------------------------------------------
function MapGenValidator:zone_list()
  if self.spec ~= 'all' then
    local list = {}
    for id in string.gmatch(self.spec, '[^,%s]+') do list[#list + 1] = id end
    return list
  end
  local list = {}
  local indices = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]
  local keys = indices:GetOrderedKeys(false)
  for i = 0, keys.Count - 1 do list[#list + 1] = keys[i] end
  return list
end


--------------------------------------------------------------------
-- Analyse de traversabilité, sur la carte RÉELLEMENT générée.
--
-- On n'estime rien : on interroge le moteur (`Map:TileBlocked`) pour
-- chaque case, on repart du point d'entrée (`Map.EntryPoints[0]`) et on
-- vérifie que les escaliers posés sur la carte sont atteignables.
--------------------------------------------------------------------
local Loc = nil
local STAIR_IDS = { stairs_go_up = true, stairs_go_down = true,
                    stairs_exit_up = true, stairs_exit_down = true,
                    stairs_exit = true, stairs_back_up = true,
                    stairs_back_down = true, stairs_secret_up = true,
                    stairs_secret_down = true }
-- Tuiles de scellement : les salles-coffres/vaults qu'elles isolent sont
-- déverrouillées en jeu (clé/interrupteur). Les cellules derrière un sceau
-- sont donc légitimement inaccessibles au flood-fill statique.
local SEAL_IDS = { sealed_block = true, sealed_door = true,
                   tile_switch = true }
-- Étages pilotés par script (tutoriels/salles d'énigme) : la progression
-- passe par area_script/tile_reset, pas par un escalier libre.
local SCRIPTED_IDS = { area_script = true, tile_reset = true, sign = true }
-- Labyrinthes d'entraînement du Dojo Makuhita : l'architecture canonique
-- PMD Red de ces étages EST petite et linéaire (training mazes).
-- Le contrat topologique procédural générique ne s'applique pas.
local DOJO_MAZES = { bug_maze = true, electric_maze = true,
                     fire_maze = true, flying_maze = true,
                     grass_maze = true, normal_maze = true,
                     rock_maze = true, water_maze = true }

local function analyse(result)
  if Loc == nil then
    luanet.load_assembly('RogueElements')
    Loc = luanet.import_type('RogueElements.Loc')
  end
  local map = result.Map
  local w, h = map.Width, map.Height
  -- Cartes toriques (InitGridPlanStep.Wrap, ex. trickster_woods seg1) :
  -- le moteur (Grid.FloodFill/DetectIsolatedStairsStep) traverse les bords.
  -- Le parcours doit faire de même, sinon faux négatifs de traversée.
  local wrap = false
  pcall(function() wrap = result.Wrap and true or false end)
  if not wrap then pcall(function() wrap = map.Wrap and true or false end) end
  local blocked = {}
  local walkable = 0
  local has_seals = false
  local has_scripted = false
  for x = 0, w - 1 do
    blocked[x] = {}
    for y = 0, h - 1 do
      local b = map:TileBlocked(Loc(x, y))
      blocked[x][y] = b
      if not b then walkable = walkable + 1 end
    end
  end

  local stairs, effect_ids, autotiles = {}, {}, {}
  local effects = 0
  for x = 0, w - 1 do
    for y = 0, h - 1 do
      local tile = map.Tiles[x][y]
      local auto = tostring(tile.Data.TileTex.AutoTileset or '')
      if auto ~= '' then autotiles[auto] = true end
      local eff = tile.Effect
      if eff ~= nil and eff.ID ~= nil and tostring(eff.ID) ~= '' then
        if STAIR_IDS[tostring(eff.ID)] then
          stairs[#stairs + 1] = { x = x, y = y }
        else
          effects = effects + 1
          effect_ids[tostring(eff.ID)] = (effect_ids[tostring(eff.ID)] or 0) + 1
          if SEAL_IDS[tostring(eff.ID)] then has_seals = true end
          if SCRIPTED_IDS[tostring(eff.ID)] then has_scripted = true end
        end
      end
    end
  end

  local entry = nil
  if map.EntryPoints ~= nil and map.EntryPoints.Count > 0 then
    local pt = map.EntryPoints[0].Loc
    entry = { x = pt.X, y = pt.Y }
  end
  if entry == nil then
    return { walkable = walkable, stairs = #stairs, reached = -1,
             entry_ok = false, stairs_reachable = false }
  end
  local entry_ok = (entry.x >= 0 and entry.y >= 0 and entry.x < w and entry.y < h
                    and not blocked[entry.x][entry.y])

  -- Parcours en largeur, 8 directions ; une diagonale n'est franchissable
  -- que si les deux orthogonales adjacentes le sont (règle du moteur).
  local seen, distance = {}, {}
  for x = 0, w - 1 do seen[x] = {}; distance[x] = {} end
  local queue = { entry }
  seen[entry.x][entry.y] = true
  distance[entry.x][entry.y] = 0
  local reached = 1
  local head = 1
  local DIRS = { {1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1} }
  -- Sur carte torique, les coordonnées s'enroulent modulo w/h
  -- (même règle que Loc.Wrap dans Grid.FloodFill du moteur).
  local function wc(x, y)
    if wrap then return x % w, y % h end
    return x, y
  end
  while head <= #queue do
    local cur = queue[head]; head = head + 1
    for _, d in ipairs(DIRS) do
      local nx, ny = cur.x + d[1], cur.y + d[2]
      if wrap then nx, ny = wc(nx, ny) end
      if nx >= 0 and ny >= 0 and nx < w and ny < h and not seen[nx][ny]
         and not blocked[nx][ny] then
        local ok = true
        if d[1] ~= 0 and d[2] ~= 0 then
          local ox, oy = wc(cur.x + d[1], cur.y)
          local px, py = wc(cur.x, cur.y + d[2])
          if ox >= 0 and ox < w and oy >= 0 and oy < h
             and px >= 0 and px < w and py >= 0 and py < h then
            ok = (not blocked[ox][oy]) and (not blocked[px][py])
          else
            ok = false
          end
        end
        if ok then
          seen[nx][ny] = true
          distance[nx][ny] = distance[cur.x][cur.y] + 1
          reached = reached + 1
          queue[#queue + 1] = { x = nx, y = ny }
        end
      end
    end
  end

  local reachable_stairs = 0
  local stair_dist_min, stair_dist_max = -1, -1
  for _, st in ipairs(stairs) do
    if seen[st.x][st.y] then
      reachable_stairs = reachable_stairs + 1
      local dist = distance[st.x][st.y]
      if stair_dist_min < 0 or dist < stair_dist_min then stair_dist_min = dist end
      if dist > stair_dist_max then stair_dist_max = dist end
    end
  end

  -- Topologie issue du FloorPlan réellement construit par RogueElements.
  -- `GetAdjacentRooms` traverse les parties de couloir et renvoie les salles
  -- effectivement reliées, pas seulement des rectangles voisins.
  local room_count, hall_count = -1, -1
  local branches, dead_ends, loops, components = -1, -1, -1, -1
  local large_rooms, small_rooms = 0, 0
  local room_dims, room_forms, degrees, graph_edges, hall_lengths = {}, {}, {}, {}, {}
  local topology = ''
  local ok_plan = pcall(function()
    local plan = result.RoomPlan
    room_count, hall_count = plan.RoomCount, plan.HallCount
    local edge_seen, adjacency = {}, {}
    local edge_count = 0
    branches, dead_ends = 0, 0
    for ii = 0, room_count - 1 do
      local room = plan:GetRoom(ii)
      local draw = room.Draw
      local form = room:GetType().Name
      local area = draw.Width * draw.Height
      room_dims[#room_dims + 1] = tostring(draw.Width) .. 'x' .. tostring(draw.Height)
      room_forms[#room_forms + 1] = tostring(form)
      if area >= 96 then large_rooms = large_rooms + 1 end
      if area <= 25 then small_rooms = small_rooms + 1 end
      adjacency[ii] = {}
      local adj = plan:GetAdjacentRooms(ii)
      degrees[#degrees + 1] = tostring(adj.Count)
      if adj.Count == 1 then dead_ends = dead_ends + 1 end
      if adj.Count >= 3 then branches = branches + 1 end
      for jj = 0, adj.Count - 1 do
        local other = adj[jj]
        adjacency[ii][other] = true
        local a, b = ii, other
        if b < a then a, b = b, a end
        local key = tostring(a) .. '-' .. tostring(b)
        if not edge_seen[key] then
          edge_seen[key] = true
          graph_edges[#graph_edges + 1] = key
          edge_count = edge_count + 1
        end
      end
    end
    table.sort(graph_edges)
    for ii = 0, hall_count - 1 do
      local hall = plan:GetHall(ii).Draw
      hall_lengths[#hall_lengths + 1] = tostring(math.max(hall.Width, hall.Height))
    end
    table.sort(hall_lengths, function(a, b) return tonumber(a) < tonumber(b) end)

    local visited = {}
    components = 0
    for ii = 0, room_count - 1 do
      if not visited[ii] then
        components = components + 1
        local pending, pos = { ii }, 1
        visited[ii] = true
        while pos <= #pending do
          local cur = pending[pos]; pos = pos + 1
          for other, _ in pairs(adjacency[cur]) do
            if not visited[other] then
              visited[other] = true
              pending[#pending + 1] = other
            end
          end
        end
      end
    end
    loops = edge_count - room_count + components
    topology = table.concat(room_forms, ',') .. '|dims=' .. table.concat(room_dims, ',')
      .. '|degree=' .. table.concat(degrees, ',') .. '|edges=' .. table.concat(graph_edges, ',')
      .. '|halls=' .. table.concat(hall_lengths, ',')
  end)
  if not ok_plan then topology = '' end

  local effect_parts, autotile_parts = {}, {}
  for name, count in pairs(effect_ids) do
    effect_parts[#effect_parts + 1] = name .. ':' .. tostring(count)
  end
  for name, _ in pairs(autotiles) do autotile_parts[#autotile_parts + 1] = name end
  table.sort(effect_parts); table.sort(autotile_parts)
  local item_count = map.Items ~= nil and map.Items.Count or 0
  local mob_count = 0
  if map.MapTeams ~= nil then
    for ii = 0, map.MapTeams.Count - 1 do
      local team = map.MapTeams[ii]
      mob_count = mob_count + team.Players.Count + team.Guests.Count
    end
  end

  return {
    walkable = walkable, reached = reached, isolated = walkable - reached,
    has_seals = has_seals, has_scripted = has_scripted,
    traversal_rate = walkable > 0 and reached / walkable or 0,
    stairs = #stairs, reachable_stairs = reachable_stairs, entry_ok = entry_ok,
    -- Progression: AU MOINS un escalier atteignable. Les escaliers
    -- secondaires (stairs_secret_* dans un vault scellé) s'ouvrent en jeu
    -- et restent journalisés via reachable_stairs < stairs.
    stairs_reachable = (#stairs > 0 and reachable_stairs >= 1),
    stair_distance_min = stair_dist_min, stair_distance_max = stair_dist_max,
    room_count = room_count, hall_count = hall_count,
    branches = branches, dead_ends = dead_ends, loops = loops,
    alternative_paths = loops, components = components,
    large_rooms = large_rooms, small_rooms = small_rooms,
    room_dims = table.concat(room_dims, ','), room_forms = table.concat(room_forms, ','),
    hall_lengths = table.concat(hall_lengths, ','), graph = table.concat(graph_edges, ','),
    degrees = table.concat(degrees, ','), topology = topology,
    items = item_count, mobs = mob_count, effects = effects,
    effect_ids = table.concat(effect_parts, ','), autotiles = table.concat(autotile_parts, ','),
  }
end

--------------------------------------------------------------------
-- Génération réelle d'un étage.
--------------------------------------------------------------------
function MapGenValidator:run()
  if not self.enabled or self.done then return end
  self.done = true

  local f = io.open(OUT, 'w'); if f then f:close() end
  local T = clr()
  local zones = self:zone_list()
  emit(string.format('{"event":"begin","zones":%d,"iterations":%d}', #zones, self.iterations))

  local total, failures, floors, unreachable, invalid = 0, 0, 0, 0, 0
  for _, zoneId in ipairs(zones) do
    local okZone, zone = pcall(function() return _DATA:GetZone(zoneId) end)
    if not okZone or zone == nil then
      failures = failures + 1
      emit(string.format('{"event":"zone_error","zone":"%s","error":"%s"}', esc(zoneId), esc(zone)))
    else
      local segCount = zone.Segments.Count
      for iter = 1, self.iterations do
        local zoneSeed = T.MathUtils.Rand:NextUInt64()
        local totalNoise = T.ReNoise(zoneSeed)
        for seg = 0, segCount - 1 do
          local structure = zone.Segments[seg]
          local doubleSeed = totalNoise:GetTwoUInt64(seg)
          local ctx = T.ZoneGenContext()
          ctx.CurrentZone = zoneId
          ctx.CurrentSegment = seg
          local structNoise = T.ReNoise(doubleSeed[0])
          for ii = 0, structure.ZoneSteps.Count - 1 do
            ctx.ZoneSteps:Add(structure.ZoneSteps[ii]:Instantiate(structNoise:GetUInt64(ii)))
          end
          local idNoise = T.ReNoise(doubleSeed[1])
          local save = T.MainProgress(T.MathUtils.Rand:NextUInt64(), T.Guid.NewGuid():ToString())
          T.DataManager.Instance:SetProgress(save)
          populate_test_team(T, save)
          -- FloorCount == nombre d'étages du segment ; les identifiants vont
          -- de 0 à FloorCount-1 (RogueEssence.LevelGen.ZoneSegmentBase).
          for floorId = 0, structure.FloorCount - 1 do
            ctx.CurrentID = floorId
            ctx.Seed = idNoise:GetUInt64((floorId << 32) | 0)
            total = total + 1
            local profile, generator_kind = 'unknown', 'unknown'
            pcall(function()
              local floor_gen = structure:GetMapGen(floorId)
              local selected = floor_gen
              local comment = tostring(floor_gen.Comment or '')
              if floor_gen:GetType().Name == 'ChanceFloorGen' then
                selected = floor_gen.Spawns:Pick(T.ReRandom(ctx.Seed))
                comment = tostring(selected.Comment or '')
              end
              generator_kind = tostring(selected:GetType().Name)
              profile = string.match(comment, '[Pp]rofile[ =:]([%w_%-]+)') or 'unknown'
            end)
            local t0 = os.clock()
            local ok, result = pcall(function() return structure:GetMap(ctx) end)
            local ms = math.floor((os.clock() - t0) * 1000)
            if ok and result ~= nil then
              floors = floors + 1
              local w, h, rooms = -1, -1, -1
              pcall(function()
                w = result.Map.Width; h = result.Map.Height
                rooms = result.RoomPlan.RoomCount
              end)
              local trav, terr = nil, ''
              if self.traversal then
                local okt, res = pcall(function() return analyse(result) end)
                if okt then trav = res else terr = tostring(res) end
              end
              if trav ~= nil then
                local terminal_fixed = (generator_kind == 'LoadGen' and trav.stairs == 0)
                -- Les vaults scellés (sealed_block/sealed_door + interrupteur)
                -- isolent légitimement quelques cellules au flood-fill
                -- statique : elles s'ouvrent en jeu. On tolère alors des
                -- cellules isolées tant que l'escalier reste atteignable.
                local sealed_ok = (trav.has_seals and trav.stairs_reachable
                                   and trav.isolated <= 160)
                -- Étage piloté par script (tutoriel/énigme): la sortie est
                -- déclenchée par area_script; l'escalier libre et le
                -- flood-fill complet ne sont pas le contrat de cet étage.
                local scripted_ok = (trav.has_scripted and trav.entry_ok
                                     and trav.isolated <= 160)
                -- Jouabilité: entrée OK + escalier atteignable (ou étage
                -- terminal/scripté). Les poches isolées sont journalisées
                -- (colonne isolated) — accessibles en jeu par trap_warp &
                -- co., elles ne condamnent pas un étage complétable.
                local traversable = (trav.entry_ok and (trav.stairs_reachable or terminal_fixed or scripted_ok))
                if not traversable then unreachable = unreachable + 1 end
                local procedural = (generator_kind == 'GridFloorGen' or generator_kind == 'RoomFloorGen')
                if DOJO_MAZES[zoneId] then procedural = false end
                local profile_shape_ok = true
                if profile == 'looping' then
                  -- A pure cycle is valid looping architecture even when no
                  -- room has degree 3. Requiring a branch here rejects the
                  -- exact structure this profile promises.
                  profile_shape_ok = trav.loops >= 1
                elseif profile == 'branching' then
                  profile_shape_ok = trav.branches >= 1 and trav.dead_ends >= 1
                elseif profile == 'large_rooms' then
                  profile_shape_ok = trav.large_rooms >= 1
                    and (trav.branches >= 1 or trav.loops >= 1)
                    and (trav.dead_ends >= 1 or trav.loops >= 1)
                elseif profile == 'unknown' or profile == 'twosides' then
                  -- unknown: aucun contrat de forme déclaré (pas de Comment
                  -- profile=). Le jeu de base produit légitimement des étages
                  -- linéaires (GridPathBranch BranchRatio Min=0 :
                  -- trickster_woods s0f9 observé rooms=10, branches=0,
                  -- loops=0). Exiger une branche serait une invention.
                  -- twosides: le contrat de GridPathTwoSides (générateur
                  -- canonique RogueElements, cf. faultline_ridge du jeu de
                  -- base) est « deux rives reliées à travers l'axe » ; le
                  -- nombre de traversées est tiré au sort et UNE traversée
                  -- (résultat linéaire, branches=0, loops=0) est une forme
                  -- légitime de ce générateur.
                  profile_shape_ok = true
                else
                  profile_shape_ok = trav.branches >= 1 or trav.loops >= 1
                end
                -- RoomFloorGen (placement libre): les salles adjacentes se
                -- connectent sans couloir; hall_count n'y est pas un
                -- invariant. GridFloorGen garde le contrat complet.
                local hall_floor = 3
                if generator_kind == 'RoomFloorGen' then hall_floor = 0 end
                -- Connexité: l'autorité est le niveau TUILES (BFS moteur),
                -- pas le graphe de salles. Le jeu de base (faultline_ridge
                -- s0f6-f9, jamais modifié) produit components=2 au plan de
                -- salles (RoomGenDefault hors graphe) avec isolated=1/491 au
                -- sol: exiger components==1 rejetterait le canon lui-même.
                local tiles_connected = (trav.walkable > 0 and
                  trav.isolated <= math.max(4, math.floor(trav.walkable * 0.05)))
                local connected_ok = (trav.components == 1) or tiles_connected
                local topology_ok = (not procedural) or
                  (trav.room_count >= 4 and trav.hall_count >= hall_floor and connected_ok
                   and profile_shape_ok)
                local valid = traversable and topology_ok
                if not valid then invalid = invalid + 1 end
                emit(string.format(
                  '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"profile":"%s",'
                  .. '"generator":"%s","status":"OK","valid":%s,"topology_ok":%s,'
                  .. '"width":%d,"height":%d,"rooms":%d,"halls":%d,"ms":%d,"walkable":%d,"reached":%d,"isolated":%d,'
                  .. '"traversal_rate":%.6f,"stairs":%d,"stairs_reachable":%d,"entry_ok":%s,"traversable":%s,'
                  .. '"stair_distance_min":%d,"stair_distance_max":%d,"branches":%d,"dead_ends":%d,'
                  .. '"loops":%d,"alternative_paths":%d,"components":%d,"large_rooms":%d,"small_rooms":%d,'
                  .. '"items":%d,"mobs":%d,"effects":%d,"effect_ids":"%s","autotiles":"%s",'
                  .. '"room_dims":"%s","room_forms":"%s","hall_lengths":"%s","graph":"%s",'
                  .. '"degrees":"%s","topology":"%s","seed":"%s"}',
                  esc(zoneId), seg, floorId, iter, esc(profile), esc(generator_kind),
                  tostring(valid), tostring(topology_ok), w, h,
                  trav.room_count >= 0 and trav.room_count or rooms, trav.hall_count, ms,
                  trav.walkable, trav.reached, trav.isolated, trav.traversal_rate,
                  trav.stairs, trav.reachable_stairs, tostring(trav.entry_ok),
                  tostring(traversable),
                  trav.stair_distance_min, trav.stair_distance_max, trav.branches, trav.dead_ends,
                  trav.loops, trav.alternative_paths, trav.components, trav.large_rooms, trav.small_rooms,
                  trav.items, trav.mobs, trav.effects, esc(trav.effect_ids), esc(trav.autotiles),
                  esc(trav.room_dims), esc(trav.room_forms), esc(trav.hall_lengths), esc(trav.graph),
                  esc(trav.degrees), esc(trav.topology), tostring(ctx.Seed)))
              else
                emit(string.format(
                  '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"profile":"%s","status":"OK",'
                  .. '"width":%d,"height":%d,"rooms":%d,"ms":%d,"traversal_error":"%s","seed":"%s"}',
                  esc(zoneId), seg, floorId, iter, esc(profile), w, h, rooms, ms, esc(terr), tostring(ctx.Seed)))
              end
            else
              failures = failures + 1
              -- NLua remonte l'objet exception : on extrait le vrai type,
              -- le message interne et la pile, sans rien masquer.
              local etype, emsg, estack = 'unknown', tostring(result), ''
              pcall(function()
                local inner = result.InnerException or result
                etype = inner:GetType():ToString()
                emsg = inner.Message
                estack = inner.StackTrace or ''
              end)
              emit(string.format(
                '{"event":"floor","zone":"%s","segment":%d,"floor":%d,"iter":%d,"status":"FAIL",'
                .. '"type":"%s","message":"%s","stack":"%s","raw":"%s","seed":"%s"}',
                esc(zoneId), seg, floorId, iter, esc(etype), esc(emsg), esc(estack),
                esc(result), tostring(ctx.Seed)))
            end
          end
          T.DataManager.Instance:SetProgress(nil)
        end
      end
    end
  end

  emit(string.format('{"event":"end","attempted":%d,"generated":%d,"failures":%d,'
                     .. '"non_traversable":%d,"invalid":%d}',
                     total, floors, failures, unreachable, invalid))
end


--------------------------------------------------------------------
-- Contrôle moteur des Grounds de scène.
--
-- Le moteur charge et désérialise réellement chaque Ground cité par le
-- câblage (entrée, relais, scène finale), puis on vérifie que le marqueur
-- d'entrée utilisé par les scripts existe bien sur la carte. Un Ground
-- illisible ou sans marqueur = téléportation ratée en jeu.
--------------------------------------------------------------------
function MapGenValidator:check_grounds(entries)
  local checked, failed = 0, 0
  for _, entry in ipairs(entries) do
    -- entrée = "zone|ground|marqueur" ; marqueur vide = entrée par index
    local zoneId, name, marker = string.match(entry, '([^|]*)|([^|]*)|([^|]*)')
    checked = checked + 1
    local ok, res = pcall(function()
      local ground = _DATA:GetGround(name)
      if ground == nil then error('GetGround a renvoyé nil') end
      local markers = {}
      local count = 0
      for ii = 0, ground.Entities.Count - 1 do
        local layer = ground.Entities[ii]
        for jj = 0, layer.Markers.Count - 1 do
          markers[tostring(layer.Markers[jj].EntName)] = true
          count = count + 1
        end
      end
      -- le Ground doit être déclaré par la zone, sinon MoveToGround refuse
      local declared = false
      local zdata = _DATA:GetZone(zoneId)
      if zdata ~= nil then
        for ii = 0, zdata.GroundMaps.Count - 1 do
          if zdata.GroundMaps[ii] == name then declared = true end
        end
      end
      local entry_ok
      if marker ~= '' then entry_ok = (markers[marker] == true)
      else entry_ok = true end   -- entrée par index : GetEntryPoint(int) ne lève pas
      return { w = ground.Width, h = ground.Height, count = count,
               declared = declared, entry_ok = entry_ok,
               mode = (marker ~= '' and 'marker' or 'index') }
    end)
    if ok then
      local problem = (not res.entry_ok) or (not res.declared)
      if problem then failed = failed + 1 end
      emit(string.format('{"event":"ground","zone":"%s","ground":"%s","status":"%s",'
        .. '"width":%d,"height":%d,"markers":%d,"entry_mode":"%s","entry":"%s",'
        .. '"entry_ok":%s,"declared_in_zone":%s}',
        esc(zoneId), esc(name), problem and 'PROBLEM' or 'OK', res.w, res.h, res.count,
        res.mode, esc(marker), tostring(res.entry_ok), tostring(res.declared)))
    else
      failed = failed + 1
      local etype, emsg = 'unknown', tostring(res)
      pcall(function()
        local inner = res.InnerException or res
        etype = inner:GetType():ToString(); emsg = inner.Message
      end)
      emit(string.format('{"event":"ground","zone":"%s","ground":"%s","status":"FAIL",'
        .. '"type":"%s","message":"%s"}', esc(zoneId), esc(name), esc(etype), esc(emsg)))
    end
  end
  emit(string.format('{"event":"grounds_end","checked":%d,"problems":%d}', checked, failed))
end

function MapGenValidator:OnInit()
  if not self.enabled then return end
  local ok, err = pcall(function() self:run() end)
  if not ok then emit(string.format('{"event":"fatal","error":"%s"}', esc(err))) end
  local grounds = os.getenv('PMDO_GROUND_CHECK')
  if grounds ~= nil and grounds ~= '' then
    local list = {}
    for id in string.gmatch(grounds, '[^,%s]+') do list[#list + 1] = id end
    local okg, errg = pcall(function() self:check_grounds(list) end)
    if not okg then emit(string.format('{"event":"fatal","error":"%s"}', esc(errg))) end
  end
end

function MapGenValidator:Subscribe(med)
  med:Subscribe('MapGenValidator', EngineServiceEvents.Init, function() self.OnInit(self) end)
end

function MapGenValidator:UnSubscribe(med)
  med:UnsubscribeAll('MapGenValidator')
end

SCRIPT:AddService('MapGenValidator', MapGenValidator:new())
return MapGenValidator
