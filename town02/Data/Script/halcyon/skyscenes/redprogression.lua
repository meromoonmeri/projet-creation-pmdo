-- redprogression.lua — Progression canonique PMD Red EU portée en SV PMDO.
-- Source : Docs/PLAYABLE_PROGRESSION.json (chaîne EVENT_* décodée de la ROM
-- EU, états $SCENARIO_MAIN 1:1 pret) + annotations event_flag.h. Adaptation
-- technique identique au modèle Sky (skyscenes/progression.lua) : l'état
-- scénario GBA (major.minor) devient SV.RedScenario = {main=M, sub=S} ;
-- chaque franchissement débloque les zones du chapitre — système natif SV.
-- AUCUNE étape inventée : la table CHAPTERS = ordre SCENARIO_MAIN du
-- redjourney (RED_GLOBAL_JOURNEY_PASS, 13 chapitres prouvés).
local RedProgression = {}

-- chapitre -> {état majeur déclencheur, zones du chapitre}
-- (états = écritures SCENARIO_MAIN pret ; zones = Data/Zone runtime-validées)
local CHAPTERS = {
  {main=2,  zones={'tiny_woods'}},
  {main=3,  zones={'thunderwave_cave'}},
  {main=4,  zones={'mt_steel'}},
  {main=5,  zones={'gloomy_forest'}},
  {main=6,  zones={'silent_chasm'}},
  {main=7,  zones={'mt_thunder','mt_thunder_peak'}},
  {main=8,  zones={'great_canyon'}},
  {main=11, zones={'lapis_cave'}},
  {main=12, zones={'mt_blaze','mt_blaze_peak'}},
  {main=13, zones={'frosty_forest'}},
  {main=14, zones={'mt_freeze','mt_freeze_peak'}},
  {main=15, zones={'magma_cavern','magma_cavern_pit','magma_pit_groudon'}},
  {main=16, zones={'sky_tower','sky_tower_summit','sky_summit_rayquaza'}},
}

function RedProgression.init()
  SV.RedScenario = SV.RedScenario or {main=0, sub=0}
  SV.RedUnlocked = SV.RedUnlocked or {}
end

-- réservé aux harnais de test (nouvelle partie = SV neuve de toute façon)
function RedProgression.reset_for_test()
  SV.RedScenario = {main=0, sub=0}
  SV.RedUnlocked = {}
end

-- écrit l'état scénario (équivalent GBA `SCENARIO_MAIN = M.S`) puis applique
-- les déblocages canoniques ; la chaîne principale ne régresse jamais
-- (graphe EVENT_* vérifié).
function RedProgression.set(main, sub)
  RedProgression.init()
  local cur = SV.RedScenario
  if main < cur.main or (main == cur.main and sub < cur.sub) then
    PrintInfo(string.format(
      '[RED_PROGRESSION] set(%d,%d) ignoré: état courant %d.%d',
      main, sub, cur.main, cur.sub))
    return false
  end
  SV.RedScenario = {main=main, sub=sub}
  local newly = {}
  for _, ch in ipairs(CHAPTERS) do
    if main >= ch.main then
      for _, z in ipairs(ch.zones) do
        if not SV.RedUnlocked[z] then
          SV.RedUnlocked[z] = true
          newly[#newly+1] = z
        end
      end
    end
  end
  PrintInfo(string.format('[RED_PROGRESSION] %d.%d -> débloque {%s}',
                          main, sub, table.concat(newly, ',')))
  return true, newly
end

function RedProgression.is_unlocked(zone)
  RedProgression.init()
  return SV.RedUnlocked[zone] == true
end

function RedProgression.state()
  RedProgression.init()
  return SV.RedScenario.main, SV.RedScenario.sub
end

return RedProgression
