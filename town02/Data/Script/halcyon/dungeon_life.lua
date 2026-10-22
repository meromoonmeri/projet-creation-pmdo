--[[
    dungeon_life.lua — rencontres non hostiles + zones secretes
    Utilise les systemes existants : MapEffectStep, ActiveEffect, ScriptGenStep
]]
require 'origin.common'
DungeonLife = {}

-- 1. Marchand itinerant (Musharna) — 8% par etage non-boss
function DungeonLife.SpawnWanderingMerchant(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 8 then return end
    if zoneContext.CurrentID == 0 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_MerchantAppears"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 2. Groupe de danseurs (Spinda+Ludicolo) — 5% par etage
function DungeonLife.SpawnDancingGroup(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 5 then return end
    if zoneContext.CurrentID < 3 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_DancersAppear"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 3. Habitants pacifiques — 4% par etage
function DungeonLife.SpawnFriendlyResident(zoneContext, context, queue, seed, args)
    if seed:Next(100) >= 4 then return end
    if zoneContext.CurrentID < 2 then return end
    if zoneContext.CurrentSegment ~= 0 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_ResidentAppears"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- 4. Zone secrete par type Plante — 3% si type Plante equipe
function DungeonLife.CheckTeamForSecretZone(zoneContext, context, queue, seed, args)
    local hasType = false
    for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
        local m = GAME:GetPlayerPartyMember(i)
        if m.Element1 == "grass" or m.Element2 == "grass" then hasType = true; break end
    end
    if not hasType then return end
    if seed:Next(100) >= 3 then return end
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnMapStarts:Add(-10, RogueEssence.Dungeon.SingleCharScriptEvent("DungeonLife_SecretZone"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

-- ====================================================================
-- HANDLERS D'ENTREE (OnMapStarts) — référencés par les Spawn* ci-dessus.
-- DungeonLife_* est appelé au démarrage d'un étage qui a reçu le
-- MapEffectStep. Le module d'origine ne les définissait pas : sans eux,
-- tout étage porteur d'un de ces spawns levait « attempt to call a nil
-- value » (DungeonLife_MerchantAppears etc. inexistants) -> crash à la
-- génération. Implémentés ci-dessous : les PNJ sont posés dans AllyTeams
-- (Faction.Friend) donc neutres — le moteur les traite en non-hostiles,
-- comme les habitants de DazzlingPlaza (Map.ReconnectMapReference les
-- re-catégorise Friend et DSceneAction.GetMatchup renvoie Friend).
-- ====================================================================

-- Choisit une case libre sur la carte (pas bloquée, pas occupée), loin
-- de l'équipe. Repli silencieux si aucune case n'est trouvée.
local function Libre()
  local origine = GAME:GetPlayerPartyMember(0)
  if origine == nil then return nil end
  local ox, oy = origine.CharLoc.X, origine.CharLoc.Y
  local candidates = {}
  local W, H = _ZONE.CurrentMap.Width, _ZONE.CurrentMap.Height
  for dx = -6, 6, 1 do
    for dy = -6, 6, 1 do
      local x, y = ox + dx, oy + dy
      if x >= 0 and y >= 0 and x < W and y < H then
        local loc = RogueElements.Loc(x, y)
        if not _ZONE.CurrentMap:TileBlocked(loc) and _ZONE.CurrentMap:GetCharAtLoc(loc) == nil then
          table.insert(candidates, loc)
        end
      end
    end
  end
  if #candidates == 0 then return nil end
  return candidates[_DATA.Save.Rand:Next(1, #candidates)]
end

-- Construit et pose un PNJ allié (non-hostile) sur la carte. Retourne le
-- char, ou nil si aucune case n'est disponible.
local function PoserAllie(espece, niveau, anim)
  local loc = Libre()
  if loc == nil then return nil end
  local ok = pcall(function()
    local team = RogueEssence.Dungeon.MonsterTeam()
    local data = RogueEssence.Dungeon.CharData(true)
    data.BaseForm = RogueEssence.Dungeon.MonsterID(espece, 0, "normal", RogueEssence.Data.Gender.Unknown)
    data.Level = niveau or 5
    local form = _DATA:GetMonster(espece).Forms[0]
    local ab = form:RollIntrinsic(_DATA.Save.Rand, 3)
    data.BaseIntrinsics[0] = ab
    local mob = RogueEssence.Dungeon.Character(data)
    mob.CharLoc = loc
    mob.CantWalk = true
    mob.CantInteract = false
    if anim ~= nil then mob.Mobility = anim end
    team.Players:Add(mob)
    _ZONE.CurrentMap.AllyTeams:Add(team)
    mob:RefreshTraits()
    _ZONE.CurrentMap:UpdateExploration(mob)
  end)
  if not ok then return nil end
  return loc
end

function SINGLE_CHAR_SCRIPT.DungeonLife_MerchantAppears(owner, ownerChar, context, args)
  -- Un marchand itinérant (Musharna) s'est posé à l'écart.
  PoserAllie("musharna", 5)
end

function SINGLE_CHAR_SCRIPT.DungeonLife_DancersAppear(owner, ownerChar, context, args)
  -- Un duo de danseurs (Spinda + Ludicolo).
  PoserAllie("spinda", 5)
  PoserAllie("ludicolo", 5)
end

function SINGLE_CHAR_SCRIPT.DungeonLife_ResidentAppears(owner, ownerChar, context, args)
  -- Un habitant pacifique aléatoire.
  local residents = { "zigzagoon", "sentret", "lillipup", "meowth", "teddiursa", "marill" }
  local espece = residents[_DATA.Save.Rand:Next(1, #residents)]
  PoserAllie(espece, 4)
end

function SINGLE_CHAR_SCRIPT.DungeonLife_SecretZone(owner, ownerChar, context, args)
  -- Zone secrète par type Plante : marquée, mais aucun spawn (réservé).
  SV.TemporaryFlags.SecretZoneTriggered = true
end

return DungeonLife
