-- progression.lua — Progression canonique PMD Sky EU portée en SV PMDO.
-- Source : Docs/PROGRESSION_GRAPH.json + STORY_PLAYABLE_CHAIN.json (états
-- $SCENARIO_MAIN décompilés de la ROM). Adaptation technique : la variable
-- scénario NDS (major.minor) devient SV.SkyScenario = {main=M, sub=S} ;
-- chaque franchissement d'étape débloque les zones du chapitre suivant —
-- même mécanique que les UnlockDungeon du mod (système natif SV).
-- AUCUNE étape inventée : la table CHAPTERS reflète STORY_PLAYABLE_CHAIN.
local SkyProgression = {}

-- chapitre -> {états déclencheurs (major), zones à débloquer}
-- (états = écritures $SCENARIO_MAIN de la ROM ; zones = Data/Zone validées)
local CHAPTERS = {
  {main=1,  zones={'beach_cave','beach_cave_pit'}},
  {main=3,  zones={'drenched_bluff'}},
  {main=4,  zones={'mt_bristle','mt_bristle_peak'}},
  {main=5,  zones={'waterfall_cave'}},
  {main=6,  zones={'apple_woods'}},
  {main=8,  zones={'craggy_coast','side_path','mt_horn','rock_path_sky',
                   'foggy_forest','forest_path','steam_cave',
                   'upper_steam_cave','steam_cave_peak'}},
  {main=10, zones={'amp_plains','far_amp_plains','amp_clearing'}},
  {main=11, zones={'northern_desert','quicksand_cave','quicksand_pit',
                   'underground_lake'}},
  {main=12, zones={'crystal_cave','crystal_crossing','crystal_lake'}},
  {main=13, zones={'chasm_cave','dark_hill','sealed_ruin',
                   'sealed_ruin_pit','spiritomb_room'}},
  {main=15, zones={'dusk_forest','deep_dusk_forest','treeshroud_forest'}},
  {main=17, zones={'brine_cave','lower_brine_cave','brine_cave_pit'}},
  {main=18, zones={'hidden_land','hidden_highland','old_ruins'}},
  {main=20, zones={'temporal_tower','temporal_spire','temporal_pinnacle'}},
}

function SkyProgression.init()
  SV.SkyScenario = SV.SkyScenario or {main=0, sub=0}
  SV.SkyUnlocked = SV.SkyUnlocked or {}
end

-- réservé aux harnais de test (nouvelle partie = SV neuve de toute façon)
function SkyProgression.reset_for_test()
  SV.SkyScenario = {main=0, sub=0}
  SV.SkyUnlocked = {}
end

-- écrit l'état scénario (équivalent SSB `$SCENARIO_MAIN = scn[M,S]`) puis
-- applique les déblocages canoniques du graphe.
function SkyProgression.set(main, sub)
  SkyProgression.init()
  local cur = SV.SkyScenario
  if main < cur.main or (main == cur.main and sub < cur.sub) then
    -- la ROM n'écrit jamais un état antérieur sur la chaîne principale
    -- (graphe vérifié) : on trace sans écraser.
    PrintInfo(string.format(
      '[SKY_PROGRESSION] set(%d,%d) ignoré: état courant %d.%d',
      main, sub, cur.main, cur.sub))
    return false
  end
  SV.SkyScenario = {main=main, sub=sub}
  local newly = {}
  for _, ch in ipairs(CHAPTERS) do
    if main >= ch.main then
      for _, z in ipairs(ch.zones) do
        if not SV.SkyUnlocked[z] then
          SV.SkyUnlocked[z] = true
          newly[#newly+1] = z
        end
      end
    end
  end
  PrintInfo(string.format('[SKY_PROGRESSION] %d.%d -> débloque {%s}',
                          main, sub, table.concat(newly, ',')))
  return true, newly
end

function SkyProgression.is_unlocked(zone)
  SkyProgression.init()
  return SV.SkyUnlocked[zone] == true
end

function SkyProgression.state()
  SkyProgression.init()
  return SV.SkyScenario.main, SV.SkyScenario.sub
end

-- comparaison d'état scénario (équivalent `scn($SCENARIO_MAIN) >= [M,S]`):
-- retourne <0 / 0 / >0 selon (état courant) - (M,S)
function SkyProgression.cmp(m, s)
  SkyProgression.init()
  local cur = SV.SkyScenario
  if cur.main ~= m then return cur.main - m end
  return (cur.sub or 0) - (s or 0)
end

-- comparaison d'état des épisodes spéciaux (équivalent
-- `scn($SCENARIO_SIDE) >= [M,S]`) : SV.SkyScenarioSide, défaut {0,0}
-- (même mécanique ROM que $SCENARIO_MAIN, variable ID 4 VAR_SCENARIO_SIDE)
function SkyProgression.cmp_side(m, s)
  SkyProgression.init()
  SV.SkyScenarioSide = SV.SkyScenarioSide or { main = 0, sub = 0 }
  local cur = SV.SkyScenarioSide
  if cur.main ~= m then return cur.main - m end
  return (cur.sub or 0) - (s or 0)
end

return SkyProgression
