--[[
    nre_probe — Sonde runtime pour la boucle NullReferenceException IsGameOver().
    Audit 2026-07-27.

    Ce service s'abonne à TOUS les événements moteur accessibles depuis Lua
    (EServiceEvents de LuaEngine.cs) et journalise, à chaque transition :
      - zone courante, segment, étage/ground ;
      - état de l'équipe sauvegardée (_DATA.Save.ActiveTeam) : effectif, leader ;
      - état de la carte de donjon chargée : présente ou non, équipe ATTACHÉE
        ou non (c'est CE champ, Map.ActiveTeam, que IsGameOver() déréférence) ;
      - nombre d'équipes ennemies.

    Chaque ligne est préfixée [NREPROBE]. Dans le log du jeu :
      * la DERNIÈRE ligne [NREPROBE] avant la première NullReferenceException
        identifie la transition fautive ;
      * si AUCUNE ligne [NREPROBE] n'apparaît dans le log, la copie du mod
        installée dans MODS n'est PAS celle de ce dépôt (installation périmée).

    Tous les accès sont sous pcall : la sonde ne peut jamais crasher le jeu.
]]
require 'origin.common'
require 'origin.services.baseservice'

local NREProbe = Class('NREProbe', BaseService)

function NREProbe:initialize()
  BaseService.initialize(self)
  PrintInfo('NREProbe:initialize()')
end

--------------------------------------------------------------------
-- Collecte d'état, 100% défensive.
--------------------------------------------------------------------
local function safe(fn, fallback)
  local ok, res = pcall(fn)
  if ok then return res end
  return fallback
end

local function snapshot(tag)
  local zone   = safe(function() return _ZONE.CurrentZoneID end, '<?>') or '<nil>'
  local seg    = safe(function() return _ZONE.CurrentMapID.Segment end, '?')
  local mapid  = safe(function() return _ZONE.CurrentMapID.ID end, '?')

  -- Équipe de la SAUVEGARDE (source de vérité, jamais détachée)
  local save_count = safe(function() return _DATA.Save.ActiveTeam.Players.Count end, -1)
  local leader = safe(function() return _DATA.Save.ActiveTeam.Leader.Nickname end, '<nil>')
  if leader == '' then leader = safe(function() return _DATA.Save.ActiveTeam.Leader.BaseForm.Species end, '<anon>') end

  -- Carte de donjon en mémoire + équipe ATTACHÉE (Map.ActiveTeam, [NonSerialized]).
  -- C'est LA référence que DungeonScene.IsGameOver() déréférence sans garde.
  local map_state = 'nil'
  local attached = 'n/a'
  local foes = 'n/a'
  local okmap, curmap = pcall(function() return _ZONE.CurrentMap end)
  if okmap and curmap ~= nil then
    map_state = safe(function() return curmap.AssetName end, '<sans nom>') or '<sans nom>'
    local okat, at = pcall(function() return curmap.ActiveTeam end)
    if okat then
      if at ~= nil then
        attached = 'OUI(' .. tostring(safe(function() return at.Players.Count end, '?')) .. ')'
      elseif tag == 'DungeonModeBegin' then
        -- Cet instant precede normalement DungeonMapInit, qui attache l'equipe
        -- avant la premiere frame jouable. Ne pas le signaler comme un crash.
        attached = 'NON (transition avant DungeonMapInit, normale)'
      else
        attached = 'NON <- IsGameOver() CRASHERAIT ICI'
      end
    end
    foes = tostring(safe(function() return curmap.MapTeams.Count end, '?'))
  end

  PrintInfo(string.format(
    '[NREPROBE] %s | zone=%s seg=%s map=%s | Save.Team=%d leader=%s | DungeonMap=%s TeamAttachee=%s foes=%s',
    tag, tostring(zone), tostring(seg), tostring(mapid),
    save_count, tostring(leader), tostring(map_state), attached, tostring(foes)))
end

--------------------------------------------------------------------
-- Callbacks
--------------------------------------------------------------------
function NREProbe:OnInit()
  -- 2e ligne attendue, toujours au LANCEMENT (enregistrement du service).
  PrintInfo('[NREPROBE] service nre_probe ACTIF (EngineServiceEvents.Init) -- build 2026-07-27-C')
end
function NREProbe:OnLoadSavedData()
  snapshot('LoadSavedData <-- sauvegarde chargee (menu Continuer)')
end
function NREProbe:OnNewGame()
  snapshot('NewGame')
end
function NREProbe:OnZoneInit()            snapshot('ZoneInit') end
function NREProbe:OnDungeonModeBegin()    snapshot('DungeonModeBegin') end
function NREProbe:OnDungeonModeEnd()      snapshot('DungeonModeEnd  <-- ExitFloor vient de detacher l equipe (normal)') end
function NREProbe:OnDungeonMapInit(mapname)
  snapshot('DungeonMapInit map=' .. tostring(mapname))
end
function NREProbe:OnDungeonFloorEnter()   snapshot('DungeonFloorEnter <-- equipe DOIT etre attachee ici') end
function NREProbe:OnDungeonFloorExit()    snapshot('DungeonFloorExit') end
function NREProbe:OnDungeonSegmentStart() snapshot('DungeonSegmentStart (Lua EnterSegment va tourner)') end
function NREProbe:OnDungeonSegmentEnd()   snapshot('DungeonSegmentEnd (Lua ExitSegment a tourne)') end
function NREProbe:OnGroundModeBegin()     snapshot('GroundModeBegin') end
function NREProbe:OnGroundModeEnd()       snapshot('GroundModeEnd') end
function NREProbe:OnGroundMapEnter()      snapshot('GroundMapEnter') end
function NREProbe:OnGroundMapExit()       snapshot('GroundMapExit') end

function NREProbe:Subscribe(med)
  med:Subscribe("NREProbe", EngineServiceEvents.Init,                function() self.OnInit(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.NewGame,             function() self.OnNewGame(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.LoadSavedData,       function() self.OnLoadSavedData(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.ZoneInit,            function() self.OnZoneInit(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonModeBegin,    function() self.mode = 'dungeon' self.limbo_ticks = 0 self.OnDungeonModeBegin(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonModeEnd,      function() self.mode = 'limbo' self.limbo_ticks = 0 self.OnDungeonModeEnd(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonMapInit,      function(_, args) self.OnDungeonMapInit(self, args[0]) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonFloorEnter,   function() self.mode = 'dungeon' self.limbo_ticks = 0 self.OnDungeonFloorEnter(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonFloorExit,    function() self.OnDungeonFloorExit(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonSegmentStart, function() self.OnDungeonSegmentStart(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.DungeonSegmentEnd,   function() self.OnDungeonSegmentEnd(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.GroundModeBegin,     function() self.mode = 'ground' self.limbo_ticks = 0 self.OnGroundModeBegin(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.GroundModeEnd,       function() self.mode = 'limbo' self.limbo_ticks = 0 self.OnGroundModeEnd(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.GroundMapEnter,      function() self.mode = 'ground' self.limbo_ticks = 0 self.OnGroundMapEnter(self) end )
  med:Subscribe("NREProbe", EngineServiceEvents.GroundMapExit,       function() self.OnGroundMapExit(self) end )
end

function NREProbe:UnSubscribe(med)
end

--------------------------------------------------------------------
-- AUTO-RÉCUPÉRATION (filet de sécurité anti-boucle infinie).
--
-- Mécanisme du crash (prouvé par lecture des sources moteur) :
--   GameManager.exitMap() -> DSceneZone.ExitFloor() :
--     ligne 53 : CurrentMap.ActiveTeam = null   (équipe DÉTACHÉE)
--     ligne 64 : SetCurrentMap(SegLoc.Invalid)
--   Si la suite de la transition lève une exception (marker introuvable,
--   ground absent de la zone, erreur Lua dans OnEnterSegment...), la scène
--   reste DungeonScene : chaque frame, ProcessInput() (DungeonScene.cs:283)
--   appelle IsGameOver() (DSceneZone.cs:~46) qui déréférence
--   CurrentMap.ActiveTeam.Players -> NullReferenceException, À CHAQUE FRAME,
--   pour toujours. Le moteur n'a AUCUN chemin de récupération.
--
-- Ce filet détecte l'état "limbo" (mode quitté sans nouveau mode entré
-- pendant ~10 s) et force un retour propre au bourg, cassant la boucle.
--------------------------------------------------------------------
function NREProbe:Update(gtime)
  self.mode = self.mode or 'unknown'
  self.limbo_ticks = self.limbo_ticks or 0
  while true do
    if self.mode == 'limbo' then
      self.limbo_ticks = self.limbo_ticks + 1
      if self.limbo_ticks == 120 then
        PrintInfo('[NREPROBE] AVERTISSEMENT: transition en limbo depuis 120 ticks (mode quitte, aucun mode entre). Etat casse probable.')
        snapshot('limbo-check')
      end
      if self.limbo_ticks == 600 then
        PrintInfo('[NREPROBE] AUTO-RECUPERATION: boucle NRE detectee, renvoi force au bourg (master_zone -1 1).')
        local ok, err = pcall(function() GAME:EnterZone('master_zone', -1, 1, 0) end)
        PrintInfo('[NREPROBE] AUTO-RECUPERATION resultat: ' .. tostring(ok) .. ' ' .. tostring(err))
        self.limbo_ticks = -3600 -- pas de nouveau declenchement avant ~1 min
      end
    end
    coroutine.yield()
  end
end

-- Instantiate and add to the service stack
SCRIPT:AddService("NREProbe", NREProbe:new())
return NREProbe
