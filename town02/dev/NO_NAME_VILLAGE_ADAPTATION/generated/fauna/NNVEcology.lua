--[[
    NNVEcology.lua — écosystème Pokémon autonome des zones No Name Village
    ==================================================================

    CE QUE C'EST
    ------------------------------------------------------------------
    Une couche de vie sauvage qui tourne sur les Grounds NNV. Les Pokémon
    ne sont pas des décors posés : chacun appartient à une COLONIE, la
    colonie a une ancre territoriale, et chaque individu suit un PROFIL
    COMPORTEMENTAL qui décide de ce qu'il fait à chaque réveil.

    LE MONDE CONTINUE SANS LE JOUEUR. Aucun comportement ci-dessous n'est
    déclenché par une action du joueur : les Pokémon errent, broutent,
    plongent, patrouillent, se rencontrent et s'évitent tout seuls. Le
    joueur peut s'arrêter et regarder.

    CONTRAINTES MOTEUR (vérifiées dans RogueEssence 0.8.12)
    ------------------------------------------------------------------
    * Un GroundChar n'a NI HP NI FACTION : aucun combat n'est possible ici.
      Les « affrontements » de cette couche sont des postures (se faire
      face, intimider, reculer). Un vrai duel passe par NNVDuel.lua, qui
      bascule sur une .rsmap via ContinueDungeon.
    * Init/Enter sont des endroits dangereux pour muter le moteur : tout
      est différé au premier Update normal (leçon de NNVLife).
    * Tout appel moteur est sous pcall : une room ne doit jamais crasher
      à cause de la faune.

    BUDGET CPU
    ------------------------------------------------------------------
    On ne met JAMAIS à jour tous les individus dans la même frame. Un
    curseur circulaire traite au plus BUDGET individus par tick actif, et
    seuls les individus proches du joueur reçoivent la simulation fine ;
    les autres avancent par un pas simplifié. Une room de 100 Pokémon
    coûte donc autant qu'une room de 12.
]]
require 'origin.common'

NNVEcology = {}
local E = NNVEcology

-- ======================================================================
-- RÉGLAGES GLOBAUX
-- ======================================================================
E.TICK_INTERVAL   = 20      -- frames entre deux passes (30 fps -> ~0.66 s)
E.BUDGET          = 6       -- individus simulés finement par passe
E.NEAR_RADIUS     = 640     -- distance joueur en deçà de laquelle on simule fin
E.INTERACT_COOLD  = 900     -- frames avant qu'un individu puisse re-interagir
E.SCENE_COOLDOWN  = 1800    -- frames entre deux scènes marquantes d'une room
E.DUEL_COOLDOWN   = 7200    -- frames entre deux duels sauvages d'une room

-- ======================================================================
-- PROFILS COMPORTEMENTAUX
-- ----------------------------------------------------------------------
-- speed      : vitesse de déplacement moteur
-- pause      : probabilité de rester immobile à ce réveil (0..1)
-- radius     : rayon max d'éloignement de l'ancre, en pixels
-- step       : amplitude d'un pas
-- flee       : distance de fuite face au joueur (0 = ne fuit pas)
-- grounded   : false = créature volante ou aquatique
-- Toute immobilité est VOLONTAIRE : elle correspond à un état nommé
-- (repos, guet, broutage, embuscade, ancrage), jamais à un trou du système.
-- ======================================================================
E.PROFILES = {
  ambient_flying = {speed=2, pause=0.10, radius=220, step=40, flee=0,   grounded=false,
                    states={'vol','vol','vol','virage','pose_breve'}},
  ambient_ground = {speed=1, pause=0.45, radius=96,  step=20, flee=0,   grounded=true,
                    states={'marche','arret','fouille','arret'}},
  timid          = {speed=2, pause=0.30, radius=128, step=28, flee=96,  grounded=true,
                    states={'marche','guet','marche','repos'}},
  grazer         = {speed=1, pause=0.60, radius=112, step=16, flee=72,  grounded=true,
                    states={'broute','broute','pas','releve_tete'}},
  flock          = {speed=2, pause=0.20, radius=160, step=36, flee=112, grounded=false,
                    states={'suit','suit','vire','pose_breve'}},
  territorial    = {speed=1, pause=0.40, radius=96,  step=24, flee=0,   grounded=true,
                    states={'patrouille','face','patrouille','marque'}},
  ambusher       = {speed=3, pause=0.85, radius=64,  step=32, flee=0,   grounded=true,
                    states={'embuscade','embuscade','embuscade','detente'}},
  aquatic_surface= {speed=1, pause=0.35, radius=128, step=22, flee=0,   grounded=false,
                    states={'derive','derive','tourne','affleure'}},
  aquatic_diver  = {speed=2, pause=0.25, radius=144, step=34, flee=80,  grounded=false,
                    states={'nage','plonge','remonte','nage'}},
  shoreline      = {speed=2, pause=0.35, radius=128, step=26, flee=88,  grounded=true,
                    states={'longe_rive','entre_eau','sort_eau','arret'}},
  wader          = {speed=1, pause=0.70, radius=160, step=18, flee=0,   grounded=true,
                    states={'immobile_eau','immobile_eau','pas_lent','pique'}},
  burrower       = {speed=2, pause=0.55, radius=80,  step=24, flee=64,  grounded=true,
                    states={'surgit','trotte','renfouit','sous_terre'}},
  canopy         = {speed=2, pause=0.40, radius=112, step=30, flee=80,  grounded=true,
                    states={'sous_couvert','change_tronc','guet','sous_couvert'}},
  nocturnal_glow = {speed=1, pause=0.25, radius=176, step=26, flee=0,   grounded=false,
                    states={'derive_lueur','derive_lueur','pulse','monte'}},
  predator       = {speed=3, pause=0.25, radius=224, step=44, flee=0,   grounded=true,
                    states={'patrouille_large','flaire','charge_courte','patrouille_large'}},
  sessile        = {speed=0, pause=1.00, radius=0,   step=0,  flee=0,   grounded=true,
                    states={'ancre','oscille','oriente','filtre'}},
}

-- ======================================================================
-- RELATIONS INTER-ESPÈCES
-- ----------------------------------------------------------------------
-- Ce que fait A quand B entre dans son rayon de détection.
--   ignore     : rien, les deux continuent (cas par défaut, le plus fréquent)
--   curieux    : A s'approche un peu, puis repart
--   evite      : A s'écarte sans paniquer
--   fuit       : A détale
--   chasse     : A poursuit brièvement B
--   rivalise   : les deux se font face, postures, puis se séparent
--   grege      : A rejoint B (formation de groupe mixte)
-- Les relations non déclarées valent 'ignore' : le monde est calme par
-- défaut, et c'est ce qui donne de la valeur aux rencontres.
-- ======================================================================
E.RELATIONS = {
  piloswine  = {swinub='grege', delibird='ignore', crabrawler='rivalise',
                ducklett='chasse', default='ignore'},
  ariados    = {ledyba='chasse', cutiefly='chasse', vivillon='chasse',
                illumise='chasse', default='ignore'},
  swanna     = {magikarp='chasse', barboach='chasse', surskit='chasse',
                ducklett='grege', lotad='ignore', default='ignore'},
  ducklett   = {swanna='grege', magikarp='chasse', piloswine='fuit', default='ignore'},
  wingull    = {magikarp='chasse', surskit='chasse', barboach='chasse',
                fletchling='ignore', default='ignore'},
  crabrawler = {crabrawler='rivalise', piloswine='evite', dwebble='rivalise',
                default='ignore'},
  dwebble    = {dwebble='rivalise', crabrawler='rivalise', default='ignore'},
  politoed   = {surskit='chasse', cutiefly='chasse', magikarp='ignore',
                default='ignore'},
  fletchling = {cutiefly='chasse', vivillon='curieux', fletchling='grege',
                ariados='evite', default='ignore'},
  cutiefly   = {ariados='fuit', fletchling='fuit', politoed='fuit',
                cutiefly='grege', vivillon='ignore', default='ignore'},
  vivillon   = {ariados='fuit', fletchling='evite', vivillon='grege', default='ignore'},
  ledyba     = {ariados='fuit', ledyba='grege', default='ignore'},
  illumise   = {ariados='fuit', volbeat='grege', illumise='grege', default='ignore'},
  volbeat    = {illumise='grege', volbeat='grege', ariados='evite', default='ignore'},
  magikarp   = {swanna='fuit', wingull='fuit', ducklett='fuit',
                chinchou='ignore', magikarp='grege', default='ignore'},
  barboach   = {swanna='fuit', wingull='fuit', barboach='grege', default='ignore'},
  surskit    = {politoed='fuit', wingull='fuit', swanna='fuit', surskit='grege',
                default='ignore'},
  swinub     = {piloswine='grege', swinub='grege', crabrawler='evite', default='ignore'},
  delibird   = {piloswine='evite', delibird='grege', default='ignore'},
  sandshrew  = {ariados='evite', sandshrew='ignore', default='ignore'},
  jumpluff   = {fletchling='evite', jumpluff='grege', default='ignore'},
  chinchou   = {chinchou='grege', swanna='evite', default='ignore'},
  lotad      = {lotad='grege', default='ignore'},
  cradily    = {default='ignore'},
  bellsprout = {default='ignore'},
}

-- Couples autorisés à produire un VRAI duel (bascule .rsmap). Volontairement
-- rare : deux territoriaux de force comparable qui se disputent un lieu.
E.DUEL_PAIRS = {
  crabrawler_dwebble    = true,
  crabrawler_crabrawler = true,
  dwebble_dwebble       = true,
  piloswine_crabrawler  = true,
}

-- ======================================================================
-- ÉTAT INTERNE
-- ======================================================================
E.tick     = 0
E.cursor   = 0
E.ready    = false
E.roster   = nil     -- liste plate {name, species, profile, anchor, colony}
E.colonies = nil
E.lastScene = -99999
E.lastDuel  = -99999
E.room      = nil

local function clamp(v, lo, hi) if v < lo then return lo elseif v > hi then return hi else return v end end

local function ch(name)
  local ok, c = pcall(function() return CH(name) end)
  if ok then return c end
  return nil
end

local function dist(a, b)
  local dx, dy = a.Position.X - b.Position.X, a.Position.Y - b.Position.Y
  return math.sqrt(dx * dx + dy * dy)
end

local function moveTo(c, x, y, speed)
  if not c then return false end
  return pcall(function()
    TASK:StartEntityTask(c, function() GROUND:MoveToPosition(c, x, y, false, speed) end)
  end)
end

local function turnTo(c, tx, ty)
  if not c then return end
  pcall(function()
    GROUND:EntTurn(c, GAME:VectorToDirection(tx - c.Position.X, ty - c.Position.Y))
  end)
end

local function setVisible(name, v)
  if v then pcall(function() GROUND:Unhide(name) end)
  else pcall(function() GROUND:Hide(name) end) end
end

-- ======================================================================
-- CONTEXTE MONDE : saison + moment de la journée + météo
-- ----------------------------------------------------------------------
-- POPULATION CONTEXTUELLE
--
-- Une même zone n'a pas la même vie selon biome + saison + heure + météo.
-- Trois leviers, appliqués aux entités DÉJÀ placées -- on ne déplace jamais
-- un individu certifié, on module sa présence et son activité :
--
--   1. PRÉSENCE  : l'individu est visible ou non (saison + heure).
--   2. DENSITÉ   : quelle proportion d'une colonie est active, via
--                  E.DENSITY[species][saison|heure|météo]. Une forêt d'été
--                  en plein jour est peuplée ; la même sous l'orage se vide.
--   3. ACTIVITÉ  : la météo module le rythme (pauses plus longues sous la
--                  pluie, activité accrue de Swinub sous la neige).
--
-- E.DENSITY est alimenté depuis config/fauna-context.json. S'il est vide,
-- le comportement est exactement celui d'avant : aucune régression.
-- ======================================================================

-- Facteurs de densité par espèce. Table plate, extensible sans toucher au
-- moteur : E.DENSITY.swinub = {seasons={winter=1.0,...}, time={...}, weather={...}}
-- Densités contextuelles, générées depuis config/fauna-context.json.
-- Modifier le JSON puis relancer tools/sync_fauna_context.py.
-- Densités contextuelles, générées depuis config/fauna-context.json.
-- Modifier le JSON puis relancer tools/sync_fauna_context.py.
-- Densités contextuelles, générées depuis config/fauna-context.json.
-- Modifier le JSON puis relancer tools/sync_fauna_context.py.
-- Densités contextuelles, générées depuis config/fauna-context.json.
-- Modifier le JSON puis relancer tools/sync_fauna_context.py.
-- Densités contextuelles, générées depuis config/fauna-context.json.
-- Modifier le JSON puis relancer tools/sync_fauna_context.py.
E.DENSITY = {
  ariados = {seasons={spring=0.2, summer=0.3, autumn=1.0, winter=0.1}, time={day=0.2, evening=0.8, night=1.0}, weather={clear=1.0, rain=0.4, storm=0.1, fog=1.0, snow=0.0}},
  barboach = {seasons={spring=1.0, summer=1.0, autumn=0.8, winter=0.5}, time={day=0.7, evening=1.0, night=1.0}, weather={clear=1.0, rain=1.0, storm=0.8, fog=1.0, snow=0.5}},
  bellsprout = {seasons={spring=1.0, summer=1.0, autumn=0.7, winter=0.2}, time={day=1.0, evening=1.0, night=1.0}, weather={clear=1.0, rain=1.0, storm=0.8, fog=1.0, snow=0.2}},
  chinchou = {seasons={spring=0.5, summer=0.6, autumn=1.0, winter=0.4}, time={day=0.2, evening=0.8, night=1.0}, weather={clear=1.0, rain=0.9, storm=0.6, fog=1.0, snow=0.3}},
  crabrawler = {seasons={spring=0.3, summer=0.2, autumn=0.5, winter=1.0}, time={day=1.0, evening=0.9, night=0.7}, weather={clear=1.0, rain=0.6, storm=0.4, fog=0.8, snow=1.0}},
  cradily = {seasons={spring=1.0, summer=1.0, autumn=1.0, winter=1.0}, time={day=1.0, evening=1.0, night=1.0}, weather={clear=1.0, rain=1.0, storm=1.0, fog=1.0, snow=1.0}},
  cutiefly = {seasons={spring=1.0, summer=1.0, autumn=0.4, winter=0.0}, time={day=1.0, evening=0.6, night=0.0}, weather={clear=1.0, rain=0.1, storm=0.0, fog=0.5, snow=0.0}},
  delibird = {seasons={spring=0.2, summer=0.0, autumn=0.4, winter=1.0}, time={day=1.0, evening=0.7, night=0.3}, weather={clear=1.0, rain=0.4, storm=0.2, fog=0.6, snow=1.0}},
  ducklett = {seasons={spring=0.5, summer=0.3, autumn=0.6, winter=1.0}, time={day=1.0, evening=0.7, night=0.3}, weather={clear=1.0, rain=1.0, storm=0.5, fog=0.8, snow=0.9}},
  dwebble = {seasons={spring=0.5, summer=0.6, autumn=1.0, winter=0.3}, time={day=1.0, evening=0.8, night=0.6}, weather={clear=1.0, rain=0.7, storm=0.4, fog=0.9, snow=0.2}},
  fletchling = {seasons={spring=1.0, summer=1.0, autumn=1.0, winter=0.5}, time={day=1.0, evening=0.6, night=0.0}, weather={clear=1.0, rain=0.5, storm=0.1, fog=0.7, snow=0.4}},
  illumise = {seasons={spring=0.6, summer=1.0, autumn=0.3, winter=0.0}, time={day=0.0, evening=0.6, night=1.0}, weather={clear=1.0, rain=0.3, storm=0.0, fog=0.9, snow=0.0}},
  jumpluff = {seasons={spring=1.0, summer=1.0, autumn=0.5, winter=0.0}, time={day=1.0, evening=0.7, night=0.2}, weather={clear=1.0, rain=0.3, storm=0.0, fog=0.6, snow=0.0}},
  ledyba = {seasons={spring=0.4, summer=0.3, autumn=1.0, winter=0.0}, time={day=1.0, evening=0.6, night=0.1}, weather={clear=1.0, rain=0.2, storm=0.0, fog=0.6, snow=0.0}},
  lotad = {seasons={spring=0.7, summer=0.8, autumn=1.0, winter=0.1}, time={day=1.0, evening=0.9, night=0.7}, weather={clear=1.0, rain=1.0, storm=0.7, fog=1.0, snow=0.1}},
  magikarp = {seasons={spring=1.0, summer=1.0, autumn=0.8, winter=0.4}, time={day=1.0, evening=1.0, night=0.8}, weather={clear=1.0, rain=1.0, storm=0.7, fog=1.0, snow=0.5}},
  piloswine = {seasons={spring=0.2, summer=0.0, autumn=0.3, winter=1.0}, time={day=1.0, evening=1.0, night=0.8}, weather={clear=1.0, rain=0.4, storm=0.3, fog=0.9, snow=1.0}},
  politoed = {seasons={spring=1.0, summer=1.0, autumn=0.7, winter=0.1}, time={day=0.8, evening=1.0, night=0.9}, weather={clear=0.8, rain=1.0, storm=0.9, fog=1.0, snow=0.1}},
  sandshrew = {seasons={spring=1.0, summer=1.0, autumn=0.8, winter=0.3}, time={day=1.0, evening=0.6, night=0.3}, weather={clear=1.0, rain=0.2, storm=0.0, fog=0.7, snow=0.1}},
  surskit = {seasons={spring=1.0, summer=1.0, autumn=0.4, winter=0.0}, time={day=1.0, evening=0.8, night=0.4}, weather={clear=1.0, rain=0.6, storm=0.2, fog=0.9, snow=0.0}},
  swanna = {seasons={spring=0.6, summer=0.5, autumn=1.0, winter=0.2}, time={day=1.0, evening=0.7, night=0.2}, weather={clear=1.0, rain=0.8, storm=0.3, fog=0.6, snow=0.2}},
  swinub = {seasons={spring=0.3, summer=0.0, autumn=0.4, winter=1.0}, time={day=1.0, evening=0.8, night=0.6}, weather={clear=1.0, rain=0.5, storm=0.3, fog=0.8, snow=1.0}},
  vivillon = {seasons={spring=1.0, summer=1.0, autumn=0.6, winter=0.0}, time={day=1.0, evening=0.5, night=0.0}, weather={clear=1.0, rain=0.2, storm=0.0, fog=0.6, snow=0.0}},
  volbeat = {seasons={spring=0.8, summer=1.0, autumn=0.6, winter=0.0}, time={day=0.0, evening=0.7, night=1.0}, weather={clear=1.0, rain=0.3, storm=0.0, fog=0.9, snow=0.0}},
  wingull = {seasons={spring=1.0, summer=1.0, autumn=0.9, winter=0.6}, time={day=1.0, evening=0.7, night=0.1}, weather={clear=1.0, rain=0.8, storm=0.4, fog=0.5, snow=0.4}},
}

-- Modulateur d'activité par météo (allonge ou raccourcit les pauses).
E.WEATHER_ACTIVITY = {
  clear = 1.0, rain = 0.75, storm = 0.45, snow = 0.7, fog = 0.8,
}

function E.Context()
  local season, time, weather = 'summer', 'day', 'clear'
  pcall(function()
    if LivingWorld and LivingWorld.Context then
      local c = LivingWorld.Context('no_name_village', E.room or '')
      if c then
        season = c.Season or season
        time   = c.Time   or time
      end
    end
  end)
  pcall(function()
    if Weather and Weather.Current then
      local w = Weather.Current()
      if type(w) == 'string' and E.WEATHER_ACTIVITY[w] then weather = w end
    end
  end)
  return season, time, weather
end

-- Facteur de densité d'une espèce dans le contexte courant (0..1).
function E.DensityFactor(species, season, time, weather)
  local d = E.DENSITY[species]
  if not d then return 1.0 end
  local f = 1.0
  if d.seasons and d.seasons[season] then f = f * d.seasons[season] end
  if d.time and d.time[time] then f = f * d.time[time] end
  if d.weather and d.weather[weather] then f = f * d.weather[weather] end
  return f
end

-- Un individu est-il présent dans le contexte courant ?
--
-- L'index du membre dans sa colonie sert de seuil déterministe : avec un
-- facteur de 0,5 la moitié de la colonie reste, toujours la même tant que le
-- contexte ne change pas. Pas de clignotement, pas d'aléatoire par frame.
local function present(entry, season, time, weather)
  if entry.seasons then
    local found = false
    for _, s in ipairs(entry.seasons) do if s == season then found = true break end end
    if not found then return false end
  end
  local t = entry.time or 'any'
  if t == 'day' and time == 'night' then return false end
  if t == 'night' and time ~= 'night' then return false end

  local f = E.DensityFactor(entry.species, season, time, weather or 'clear')
  if f <= 0 then return false end
  if f >= 1 then return true end
  -- seuil stable : le membre 1 reste toujours, les suivants sortent d'abord
  local size = entry.colonySize or 1
  local keep = math.max(1, math.floor(size * f + 0.5))
  return (entry.rank or 1) <= keep
end

-- ======================================================================
-- CHARGEMENT DU PEUPLEMENT
-- ----------------------------------------------------------------------
-- data = { colonies = { {species=, profile=, anchor={x,y}, seasons=, time=,
--                        members={ {name=, px={x,y}} , ... } }, ... } }
-- Les noms d'entités doivent correspondre aux GroundChar posés dans le
-- Ground. Un membre dont l'entité est absente est simplement ignoré.
-- ======================================================================
function E.Load(room, data)
  E.room     = room
  E.colonies = (data and data.colonies) or {}
  E.roster   = {}
  for ci, col in ipairs(E.colonies) do
    col.index = ci
    col.leader = col.members[1] and col.members[1].name or nil
    for mi, m in ipairs(col.members) do
      E.roster[#E.roster + 1] = {
        name    = m.name,
        species = col.species,
        profile = col.profile,
        prof    = E.PROFILES[col.profile] or E.PROFILES.timid,
        anchor  = {x = (m.px and m.px[1]) or 0, y = (m.px and m.px[2]) or 0},
        home    = {x = (col.anchor and col.anchor[1] or 0) * 64 + 32,
                   y = (col.anchor and col.anchor[2] or 0) * 64 + 32},
        colony  = ci,
        colonySize = #col.members,
        seasons = col.seasons,
        time    = col.time,
        state   = 'repos',
        -- rank : rang DANS la colonie, sert aux seuils de densité (le membre
        -- 1 reste toujours) et à la formation des groupes.
        rank    = mi,
        -- phase : horloge comportementale INDIVIDUELLE. Elle doit être unique
        -- dans tout le Ground, sinon deux individus de colonies différentes
        -- mais de même rang partagent la même séquence pause/direction et
        -- produisent des trajectoires clonées (mesuré : 4 491 clones sur
        -- 28 464 paires quand phase = rang). On mélange le rang, l'index de
        -- colonie et un multiplicateur premier pour désynchroniser.
        -- #E.roster est l'index global de l'individu dans le Ground : il est
        -- STRICTEMENT unique. Le décalage par colonie casse en plus toute
        -- régularité entre groupes voisins. Un modulo réintroduirait des
        -- collisions (mesuré : 114 clones résiduels avec % 997).
        phase   = #E.roster + 1 + (ci * 13),
        lastInteract = -99999,
        isLeader = (mi == 1),
      }
    end
  end
  E.tick, E.cursor, E.ready = 0, 0, false
  return #E.roster
end

-- ======================================================================
-- CYCLE DE VIE
-- ======================================================================
function E.Setup()
  E.tick, E.cursor, E.ready = 0, 0, false
end

local function initialise()
  if E.ready then return true end
  local season, time, weather = E.Context()
  E.season, E.timeOfDay, E.weather = season, time, weather
  for _, e in ipairs(E.roster) do
    e.visible = present(e, season, time, weather)
    setVisible(e.name, e.visible)
    local c = ch(e.name)
    if c then e.anchor = {x = c.Position.X, y = c.Position.Y} end
  end
  E.ready = true
  return true
end

-- ----------------------------------------------------------------------
-- Un pas de comportement pour un individu.
-- ----------------------------------------------------------------------
local function stepIndividual(e, hero, fine)
  local c = ch(e.name)
  if not c or not e.visible then return end
  local p = e.prof

  -- sessile : ne se déplace jamais, mais s'oriente et change d'état.
  if p.speed == 0 then
    e.state = p.states[(E.tick + e.phase) % #p.states + 1]
    if hero and fine and dist(c, hero) < 128 then
      turnTo(c, hero.Position.X, hero.Position.Y)
    end
    return
  end

  -- fuite : prioritaire sur tout le reste
  if hero and p.flee > 0 and fine then
    local d = dist(c, hero)
    if d < p.flee then
      local dx, dy = c.Position.X - hero.Position.X, c.Position.Y - hero.Position.Y
      local m = math.max(1, math.sqrt(dx * dx + dy * dy))
      e.state = 'fuite'
      moveTo(c, c.Position.X + math.floor(dx / m * p.step * 2),
                c.Position.Y + math.floor(dy / m * p.step * 2), p.speed + 1)
      return
    end
  end

  -- territorial : fait face au joueur proche sans reculer
  if p.flee == 0 and hero and fine and (e.profile == 'territorial'
      or e.profile == 'predator') and dist(c, hero) < 112 then
    e.state = 'face'
    turnTo(c, hero.Position.X, hero.Position.Y)
    return
  end

  -- Pause volontaire, modulée par la météo.
  -- Sous la pluie et l'orage les Pokémon s'abritent : les pauses s'allongent.
  -- Une espèce dont la météo courante augmente la densité (Swinub sous la
  -- neige) voit au contraire ses pauses raccourcir : elle est plus active.
  local act = E.WEATHER_ACTIVITY[E.weather or 'clear'] or 1.0
  local dens = E.DENSITY[e.species]
  if dens and dens.weather and dens.weather[E.weather or 'clear'] then
    act = act * (0.5 + dens.weather[E.weather or 'clear'])
  end
  local pause = p.pause + (1 - math.min(1.5, act)) * (1 - p.pause) * 0.6
  local r = ((E.tick * 7 + e.phase * 13) % 100) / 100
  if r < pause then
    e.state = p.states[(E.tick + e.phase) % #p.states + 1]
    return
  end

  -- membre de groupe : suit son meneur
  if e.profile == 'flock' and not e.isLeader then
    local col = E.colonies[e.colony]
    local lead = col and col.leader and ch(col.leader)
    if lead then
      local off = (e.phase % 8) * 45
      local rad = math.rad(off)
      e.state = 'suit'
      moveTo(c, lead.Position.X + math.floor(math.cos(rad) * 48),
                lead.Position.Y + math.floor(math.sin(rad) * 48), p.speed)
      return
    end
  end

  -- déambulation normale autour de l'ancre, bornée par le rayon du profil
  local ang = math.rad(((E.tick * 23 + e.phase * 61) % 360))
  local nx = c.Position.X + math.floor(math.cos(ang) * p.step)
  local ny = c.Position.Y + math.floor(math.sin(ang) * p.step)
  local ax, ay = e.anchor.x, e.anchor.y
  local dx, dy = nx - ax, ny - ay
  local dd = math.sqrt(dx * dx + dy * dy)
  if dd > p.radius then
    nx = ax + math.floor(dx / dd * p.radius)
    ny = ay + math.floor(dy / dd * p.radius)
  end
  e.state = p.states[(E.tick + e.phase) % #p.states + 1]
  moveTo(c, nx, ny, p.speed)
end

-- ----------------------------------------------------------------------
-- Rencontre entre deux individus proches : applique la relation.
-- Aucune de ces réactions n'implique le joueur.
-- ----------------------------------------------------------------------
local function relation(a, b)
  local t = E.RELATIONS[a]
  if not t then return 'ignore' end
  return t[b] or t.default or 'ignore'
end

local function encounter(e, other)
  local ca, cb = ch(e.name), ch(other.name)
  if not ca or not cb then return end
  local rel = relation(e.species, other.species)
  if rel == 'ignore' then return end

  e.lastInteract = E.tick
  other.lastInteract = E.tick
  local pa = e.prof

  if rel == 'fuit' then
    local dx, dy = ca.Position.X - cb.Position.X, ca.Position.Y - cb.Position.Y
    local m = math.max(1, math.sqrt(dx * dx + dy * dy))
    e.state = 'fuite'
    moveTo(ca, ca.Position.X + math.floor(dx / m * 96),
               ca.Position.Y + math.floor(dy / m * 96), pa.speed + 1)
  elseif rel == 'evite' then
    local dx, dy = ca.Position.X - cb.Position.X, ca.Position.Y - cb.Position.Y
    local m = math.max(1, math.sqrt(dx * dx + dy * dy))
    e.state = 'ecart'
    moveTo(ca, ca.Position.X + math.floor(dy / m * 48),
               ca.Position.Y - math.floor(dx / m * 48), pa.speed)
  elseif rel == 'chasse' then
    e.state = 'poursuite'
    turnTo(ca, cb.Position.X, cb.Position.Y)
    moveTo(ca, cb.Position.X, cb.Position.Y, pa.speed + 1)
  elseif rel == 'curieux' then
    e.state = 'curiosite'
    turnTo(ca, cb.Position.X, cb.Position.Y)
    moveTo(ca, (ca.Position.X + cb.Position.X) / 2,
               (ca.Position.Y + cb.Position.Y) / 2, pa.speed)
  elseif rel == 'grege' then
    e.state = 'regroupement'
    moveTo(ca, cb.Position.X + 32, cb.Position.Y + 16, pa.speed)
  elseif rel == 'rivalise' then
    e.state = 'confrontation'
    other.state = 'confrontation'
    turnTo(ca, cb.Position.X, cb.Position.Y)
    turnTo(cb, ca.Position.X, ca.Position.Y)
    E.MaybeDuel(e, other)
  end
end

-- ----------------------------------------------------------------------
-- Un affrontement peut, rarement, devenir un vrai duel sur .rsmap.
-- Toutes les conditions doivent être réunies ; sinon on reste en posture.
-- ----------------------------------------------------------------------
function E.MaybeDuel(a, b)
  if E.tick - E.lastDuel < E.DUEL_COOLDOWN then return false end
  local key1 = a.species .. '_' .. b.species
  local key2 = b.species .. '_' .. a.species
  if not (E.DUEL_PAIRS[key1] or E.DUEL_PAIRS[key2]) then return false end
  if not NNVDuel or not NNVDuel.Trigger then return false end
  E.lastDuel = E.tick
  local ok = false
  pcall(function() ok = NNVDuel.Trigger(E.room, a, b) end)
  return ok
end

-- ======================================================================
-- BOUCLE PRINCIPALE
-- ======================================================================
function E.Update()
  if not E.roster then return end
  E.tick = E.tick + 1
  if not initialise() then return end
  if E.tick % E.TICK_INTERVAL ~= 0 then return end

  -- bascule saison/heure : on montre ou cache sans recharger la room
  local season, time, weather = E.Context()
  if season ~= E.season or time ~= E.timeOfDay or weather ~= E.weather then
    E.season, E.timeOfDay, E.weather = season, time, weather
    for _, e in ipairs(E.roster) do
      local v = present(e, season, time, weather)
      if v ~= e.visible then
        e.visible = v
        setVisible(e.name, v)
      end
    end
  end

  local hero = ch('PLAYER')
  local n = #E.roster
  if n == 0 then return end

  local done = 0
  for _ = 1, n do
    E.cursor = (E.cursor % n) + 1
    local e = E.roster[E.cursor]
    if e.visible then
      local c = ch(e.name)
      local fine = false
      if c and hero then fine = dist(c, hero) < E.NEAR_RADIUS end
      stepIndividual(e, hero, fine)

      -- rencontres : seulement en simulation fine, et jamais en rafale
      if fine and c and E.tick - e.lastInteract > E.INTERACT_COOLD then
        for j = 1, n do
          local o = E.roster[j]
          if o ~= e and o.visible and o.colony ~= e.colony then
            local co = ch(o.name)
            if co and dist(c, co) < 112 then
              encounter(e, o)
              break
            end
          end
        end
      end
      done = done + 1
      if done >= E.BUDGET then break end
    end
  end
end

-- ======================================================================
-- INTERACTION JOUEUR (optionnelle, ne pilote pas la vie du monde)
-- ======================================================================
E.OBSERVE = {
  vol            = "Le Pokémon décrit un arc au-dessus des herbes.",
  virage         = "Il change de cap sans se poser.",
  pose_breve     = "Il se pose une seconde, puis repart.",
  marche         = "Il avance tranquillement, sans se presser.",
  arret          = "Il s'arrête et écoute les bruits du sous-bois.",
  fouille        = "Il fouille le sol du bout du museau.",
  guet           = "Il reste aux aguets, prêt à détaler.",
  repos          = "Il se repose, les yeux mi-clos.",
  broute         = "Il broute, la tête baissée dans l'herbe.",
  pas            = "Il fait quelques pas vers une autre touffe.",
  releve_tete    = "Il relève la tête et mâche lentement.",
  suit           = "Il reste dans le sillage du groupe.",
  vire           = "Le groupe vire d'un bloc et il suit.",
  patrouille     = "Il parcourt les limites de son territoire.",
  face           = "Il vous fait face sans reculer d'un pas.",
  marque         = "Il marque son passage sur une racine.",
  embuscade      = "Il ne bouge pas. Il attend quelque chose.",
  detente        = "Il se détend d'un coup, puis se fige à nouveau.",
  derive         = "Il se laisse porter par le courant.",
  tourne         = "Il décrit un cercle lent à la surface.",
  affleure       = "Il affleure, puis disparaît sous la surface.",
  nage           = "Il nage sous la surface, à peine visible.",
  plonge         = "Il plonge d'un coup de queue.",
  remonte        = "Il remonte respirer et replonge aussitôt.",
  longe_rive     = "Il longe la rive à petits pas.",
  entre_eau      = "Il entre dans l'eau sans hésiter.",
  sort_eau       = "Il ressort en secouant l'eau de son corps.",
  immobile_eau   = "Il reste planté dans l'eau peu profonde, immobile.",
  pas_lent       = "Il avance d'un pas très lent, sans troubler l'eau.",
  pique          = "Il pique brusquement le bec vers l'eau.",
  surgit         = "Il surgit de terre dans une gerbe de poussière.",
  trotte         = "Il trotte à découvert, l'oreille dressée.",
  renfouit       = "Il replonge sous la terre meuble.",
  sous_terre     = "Un léger monticule bouge : il est juste dessous.",
  sous_couvert   = "Il reste à l'ombre du couvert, hors de vue.",
  change_tronc   = "Il passe d'un tronc à l'autre en trois bonds.",
  derive_lueur   = "Sa lueur dérive doucement dans le noir.",
  pulse          = "Sa lumière pulse deux fois, puis faiblit.",
  monte          = "Il s'élève un peu plus haut dans l'air tiède.",
  patrouille_large = "Il couvre un large territoire d'un pas régulier.",
  flaire         = "Il flaire l'air, longuement.",
  charge_courte  = "Il fait une courte charge, puis s'arrête net.",
  ancre          = "Il est ancré au sol et ne bougera pas.",
  oscille        = "Il oscille lentement, comme au gré d'un courant.",
  oriente        = "Il s'oriente vers vous sans se déplacer.",
  filtre         = "Il filtre l'air de ses appendices.",
  fuite          = "Il détale sans demander son reste.",
  ecart          = "Il s'écarte de votre trajectoire.",
  poursuite      = "Il poursuit quelque chose que vous ne voyez pas.",
  curiosite      = "Il s'approche, curieux, puis se ravise.",
  regroupement   = "Il rejoint les siens.",
  confrontation  = "Deux Pokémon se font face, immobiles.",
}

function E.Observe(entityName)
  for _, e in ipairs(E.roster or {}) do
    if e.name == entityName then
      local c = ch(e.name)
      if not c then return false end
      local line = E.OBSERVE[e.state] or "Le Pokémon vaque à ses occupations."
      UI:SetSpeaker(c)
      UI:WaitShowDialogue(line)
      return true
    end
  end
  return false
end

return NNVEcology
