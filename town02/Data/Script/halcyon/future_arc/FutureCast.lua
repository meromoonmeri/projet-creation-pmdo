--[[
    FutureCast.lua — cycle de vie sûr des acteurs temporaires de l'arc futur.

    Les positions viennent exclusivement de spawns.lua (SSB/SSA canonique).
    PLAYER et ATTENDANT1 réutilisent l'équipe vivante : ils ne sont jamais
    supprimés du Ground. Les autres acteurs suivent le même cycle que
    CharacterEssentials.MakeCharactersFromList, événement EntSpawned compris.
]]
require 'origin.common'

FutureCast = {}

FutureCast.ANTAGONIST = {
  ['p05p03a_m17a0302'] = true,
  ['p05p03a_m26a06d3'] = true,
  ['p09p01a_m19b1001'] = true,
  ['p09p01a_m19b1007'] = true,
  ['p09p01a_m19b1009'] = true,
  ['p09p01a_m19d1072'] = true,
}

-- spawns.lua retourne directement la table. L'ancien accès
-- require(...).FutureCast_SPAWNS rendait donc FutureCast.SPAWNS toujours nil.
FutureCast.SPAWNS = require 'halcyon.future_arc.spawns'
FutureCast.SPAWN_INDEX = {}
FutureCast.Managed = {}

for sceneKey, actors in pairs(FutureCast.SPAWNS) do
  FutureCast.SPAWN_INDEX[string.lower(sceneKey)] = actors
end

-- Certaines SSA de l'original ne redéclarent pas les acteurs conservés par la
-- SSA précédente. PMDO recharge ici un cast temporaire à chaque scène afin de
-- garantir le nettoyage après interruption/reprise : on complète donc
-- explicitement ces cinq scènes avec la dernière position canonique connue.
-- spawns.lua reste l'inventaire brut SSB/SSA ; cette table documente uniquement
-- les dépendances inter-SSA prouvées par les appels CH(...) des scènes actives.
FutureCast.INHERITED_SPAWNS = {
  ['d18p11a_m17a0701'] = {
    NPC_JUPUTORU = { species='grovyle', gender='Male', name='Grovyle', x=388, y=140, dir=Direction.Down },
  },
  ['d21p41a_m18b0902'] = {
    NPC_MIKARUGE = { species='spiritomb', gender='Genderless', name='Spiritomb', x=324, y=196, dir=Direction.Down },
  },
  ['d21p41a_m18b1101'] = {
    NPC_MIKARUGE = { species='spiritomb', gender='Genderless', name='Spiritomb', x=324, y=196, dir=Direction.Down },
  },
  ['d22p11a_m19a0403'] = {
    NPC_JUPUTORU = { species='grovyle', gender='Male', name='Grovyle', x=276, y=4, dir=Direction.Up },
  },
  ['p08p01a_m19a0601'] = {
    NPC_SEREBII = { species='celebi', gender='Genderless', name='Celebi', x=276, y=208, dir=Direction.Down },
  },
}

-- Noms d'acteurs du scénario spécial n06 (Équipe Charme). Ces corrections
-- conservent les coordonnées extraites et remplacent seulement les anciens
-- Dusknoir de substitution. Les scènes D55 restent séparées du parcours héros.
FutureCast.D55_ACTORS = {
  NPC_AABOKKU       = { species='arbok',      gender='Unknown',    name='Arbok' },
  NPC_BUUBAAN       = { species='magmortar',  gender='Unknown',    name='Magmortar' },
  NPC_CHAAREMU      = { species='medicham',   gender='Female',     name='Medicham' },
  NPC_DORAPION      = { species='drapion',    gender='Unknown',    name='Drapion' },
  NPC_HERUGAA       = { species='houndoom',   gender='Unknown',    name='Houndoom' },
  NPC_MANYUURA      = { species='weavile',    gender='Unknown',    name='Weavile' },
  NPC_METAMON_OTACHI= { species='ditto',      gender='Genderless', name='Ditto' },
  NPC_NOKOTCHI      = { species='dunsparce',  gender='Unknown',    name='Dunsparce' },
  NPC_NOKUTASU      = { species='cacturne',   gender='Unknown',    name='Cacturne' },
  NPC_SAANAITO      = { species='gardevoir',  gender='Female',     name='Gardevoir' },
  NPC_PUKURIN       = { species='wigglytuff', gender='Unknown',    name='Wigglytuff' },
  NPC_BOSUGODORA    = { species='aggron',     gender='Unknown',    name='Aggron' },
  NPC_KODORA        = { species='lairon',     gender='Unknown',    name='Lairon_1' },
  NPC_KODORA2       = { species='lairon',     gender='Unknown',    name='Lairon_2' },
  NPC_KODORA3       = { species='lairon',     gender='Unknown',    name='Lairon_3' },
  NPC_KODORA4       = { species='lairon',     gender='Unknown',    name='Lairon_4' },
  NPC_KODORA5       = { species='lairon',     gender='Unknown',    name='Lairon_5' },
  NPC_KODORA6       = { species='lairon',     gender='Unknown',    name='Lairon_6' },
  PLAYER_CHARMS     = { species='lopunny',    gender='Female',     name='Lopunny' },
}

local function normalize(value)
  return string.lower(tostring(value or ''))
end

function FutureCast.FindSpawn(sceneKey)
  return FutureCast.SPAWN_INDEX[normalize(sceneKey)]
end

-- Retire uniquement les personnages que ce module a lui-même ajoutés.
function FutureCast.Cleanup()
  local ground = GAME:GetCurrentGround()
  for _, chara in ipairs(FutureCast.Managed) do
    pcall(function()
      if chara ~= nil then ground:RemoveTempChar(chara) end
    end)
  end
  FutureCast.Managed = {}
  pcall(function()
    local hero = CH('PLAYER')
    local partner = CH('Teammate1')
    if hero ~= nil then GROUND:Unhide(hero.EntName) end
    if partner ~= nil then GROUND:Unhide(partner.EntName) end
  end)
end

-- Cycle complet exigé par RogueEssence pour un GroundChar temporaire.
function FutureCast.Create(species, gender, displayName, entityName, x, y, dir)
  local genders = RogueEssence.Data.Gender
  local actorGender = genders[gender] or genders.Unknown
  local monster = RogueEssence.Dungeon.MonsterID(species, 0, 'normal', actorGender)
  local chara = RogueEssence.Ground.GroundChar(
    monster, RogueElements.Loc(x, y), dir, displayName, entityName)
  chara:ReloadEvents()
  GAME:GetCurrentGround():AddTempChar(chara)
  chara:OnMapInit()
  local result = RogueEssence.Script.TriggerResult()
  TASK:WaitTask(chara:RunEvent(
    RogueEssence.Script.LuaEngine.EEntLuaEventTypes.EntSpawned, result, chara))
  AI:DisableCharacterAI(chara)
  table.insert(FutureCast.Managed, chara)
  return chara
end

-- Place le cast de la scène. La recherche de clé est insensible à la casse,
-- indispensable sur Linux car les modules D55 utilisent un préfixe majuscule.
function FutureCast.Spawn(sceneKey)
  FutureCast.Cleanup()
  local sp = FutureCast.FindSpawn(sceneKey)
  if sp == nil then
    PrintInfo('[FutureCast] données de spawn absentes : ' .. tostring(sceneKey))
    return {}
  end

  local out = {}
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local heroSpecies = 'bulbasaur'
  if hero ~= nil then heroSpecies = hero.CurrentForm.Species end
  local antagonist = FutureCast.ANTAGONIST[normalize(sceneKey)] == true

  local effective = {}
  for entityId, sourceInfo in pairs(sp) do effective[entityId] = sourceInfo end
  local inherited = FutureCast.INHERITED_SPAWNS[normalize(sceneKey)] or {}
  for entityId, sourceInfo in pairs(inherited) do
    if effective[entityId] == nil then effective[entityId] = sourceInfo end
  end

  for entityId, sourceInfo in pairs(effective) do
    if entityId ~= 'PLAYER' and entityId ~= 'ATTENDANT1' then
      local info = sourceInfo
      local corrected = FutureCast.D55_ACTORS[entityId]
      local species = corrected and corrected.species or info.species
      local gender = corrected and corrected.gender or info.gender
      local expectedName = corrected and corrected.name or info.name
      local displayName = expectedName
      local entityName = expectedName

      if species == '__HERO__' then species = heroSpecies end
      if antagonist and (entityId == 'NPC_YONOWAARU' or entityId == 'NPC_YONOWAARU_N8') then
        species, gender, displayName, entityName = 'necrozma', 'Genderless', 'Necrozma', 'Necrozma'
      end

      local chara = FutureCast.Create(
        species, gender, displayName, entityName, info.x, info.y, info.dir)
      out[entityId] = chara
      out[expectedName] = chara
      out[normalize(entityId)] = chara
      out[normalize(expectedName)] = chara
    end
  end

  -- L'équipe du joueur reste constituée des acteurs vivants. La direction
  -- canonique fait partie de la téléportation (surcharge à quatre arguments).
  local heroPos = sp.PLAYER
  if heroPos ~= nil and hero ~= nil then
    GROUND:Unhide(hero.EntName)
    GROUND:TeleportTo(hero, heroPos.x, heroPos.y, heroPos.dir)
  end
  local partnerPos = sp.ATTENDANT1
  if partnerPos ~= nil and partner ~= nil then
    GROUND:Unhide(partner.EntName)
    GROUND:TeleportTo(partner, partnerPos.x, partnerPos.y, partnerPos.dir)
  end

  return out
end

return FutureCast
