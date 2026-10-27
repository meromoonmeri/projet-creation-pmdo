--[[ init.lua — Quiz de personnalité PMD Destiny (map personality_test)
     Flux observé sur le personality_test de Halcyon (structure seulement,
     code entièrement rédigé pour PMD Destiny — aucun fichier Halcyon copié) :
       15 questions → nature (max de points) → badge étoile coloré →
       starter selon la nature → choix du sexe → choix du talent
       (Intrinsic1/2/3) → confirmation « Êtes-vous sûr… ? » avec mention
       MÉGA-ÉVOLUTION en lettres arc-en-ciel (balises [color=#RRGGBB] du
       moteur — RogueEssence/Text.cs : ouverture [color=#hex], fermeture [color]).
     Données : quiz_data.lua (généré par OUTILS/generer_quiz_destiny.py).
     Honnêteté : runtime_tested false (non lancé en jeu depuis le sandbox).
]]

require 'common'

local quiz_data = require 'ground.personality_test.quiz_data'

local personality_test = {}

-- ----------------------------------------------------------------- helpers

-- Chaque lettre reçoit une couleur de l'arc-en-ciel (itération UTF-8 sûre).
local function arc_en_ciel(texte)
  local teintes = { '#FF4D4D', '#FF9E2B', '#FFE12B', '#8CE02B', '#2BD9FF', '#3B76FF', '#A64DFF' }
  local out, i = {}, 0
  for car in texte:gmatch('[%z\1-\127\194-\244][\128-\191]*') do
    if car == ' ' or car == '-' then
      table.insert(out, car)
    else
      table.insert(out, '[color=' .. teintes[(i % #teintes) + 1] .. ']' .. car .. '[color]')
      i = i + 1
    end
  end
  return table.concat(out)
end

local function nature_par_slug(slug)
  for _, n in ipairs(quiz_data.natures) do
    if n.slug == slug then return n end
  end
  return nil
end

local function calculer_nature(scores)
  local best, best_score = nil, -1
  for _, n in ipairs(quiz_data.natures) do
    local s = scores[n.slug] or 0
    if s > best_score then
      best, best_score = n.slug, s
    end
  end
  return best
end

-- ------------------------------------------------------------- map callbacks

function personality_test.Init(map)
end

function personality_test.Enter(map)
  personality_test.PlotScripting()
end

function personality_test.Exit(map)
end

function personality_test.Update(map)
end

function personality_test.GameSave(map)
end

function personality_test.GameLoad(map)
  personality_test.PlotScripting()
end

function personality_test.PlotScripting()
  if SV.Chapter1 ~= nil and SV.Chapter1.PlayedIntroCutscene then
    -- fail-safe : déjà passé par l'intro → renvoi vers le monde
    GROUND:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
    return
  end
  personality_test.Quiz()
end

-- ------------------------------------------------------------ scène du quiz

function personality_test.Quiz()
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  SOUND:FadeOutBGM()
  GAME:WaitFrames(30)
  UI:WaitShowVoiceOver("Bienvenue dans le monde des Pokémon !", -1)
  UI:WaitShowVoiceOver("Avant de partir à l'aventure, réponds sincèrement\nà ces quinze questions.", -1)
  SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)
  GAME:FadeIn(40)

  -- 15 questions — chaque choix distribue +4/+2 sur les 16 natures
  local scores = {}
  for _, n in ipairs(quiz_data.natures) do scores[n.slug] = 0 end

  for num, q in ipairs(quiz_data.questions) do
    local intitules = {}
    for _, c in ipairs(q.choix) do table.insert(intitules, c.texte) end
    UI:BeginChoiceMenu('(' .. num .. '/15) ' .. q.texte, intitules, 1, 1)
    UI:WaitForChoice()
    local choix = UI:ChoiceResult()
    for slug, pts in pairs(q.choix[choix].points) do
      scores[slug] = (scores[slug] or 0) + pts
    end
  end

  -- nature = score maximal ; le badge étoile prend sa couleur
  local slug = calculer_nature(scores)
  local nature = nature_par_slug(slug)
  local starter_id = quiz_data.mapping[slug]
  local starter = quiz_data.starters[starter_id]

  UI:WaitShowVoiceOver("L'analyse est terminée...", -1)
  UI:WaitShowVoiceOver("Ton aura révèle une nature de couleur\n" .. nature.couleur ..
    " ! Le badge étoile s'illumine.", -1)
  -- TODO visuel : afficher Content/UI/quiz_badges/badge_etoile_<slug>.png
  -- (menu image custom) — la scène est fonctionnelle en dialogues sans.

  UI:WaitShowVoiceOver("Le starter qui te correspond est...\n" .. starter.nom .. " !", -1)

  -- choix du sexe (structure observée chez Halcyon)
  local genre = Gender.Male
  UI:BeginChoiceMenu("Quel est ton sexe ?", { "Garçon", "Fille", "Non-binaire" }, 1, 1)
  UI:WaitForChoice()
  local g = UI:ChoiceResult()
  if g == 2 then
    genre = Gender.Female
  elseif g == 3 then
    genre = Gender.Genderless
  end

  -- choix du talent : les intrinsèques viennent des données du jeu
  -- (Intrinsic1/2/3, talent caché inclus — comme chez Halcyon)
  local fiche = _DATA:GetMonster(starter.espece).Forms[starter.forme]
  local talent = fiche.Intrinsic1
  local candidats, affiches = { fiche.Intrinsic1 }, { _DATA:GetIntrinsic(fiche.Intrinsic1):GetColoredName() }
  for _, cand in ipairs({ fiche.Intrinsic2, fiche.Intrinsic3 }) do
    if cand ~= nil and cand ~= 'none' then
      table.insert(candidats, cand)
      table.insert(affiches, _DATA:GetIntrinsic(cand):GetColoredName())
    end
  end
  if #affiches > 1 then
    UI:BeginChoiceMenu("Quel talent veux-tu ?", affiches, 1, 1)
    UI:WaitForChoice()
    talent = candidats[UI:ChoiceResult()]
  end

  -- confirmation, avec la mention méga-évolution en lettres arc-en-ciel
  local ok = false
  while not ok do
    local msg = "Êtes-vous sûr de sélectionner ce Pokémon ?\n" ..
      _DATA:GetMonster(starter.espece):GetColoredName()
    if starter.mega ~= nil then
      msg = msg .. "\nCe Pokémon est compatible avec la " .. arc_en_ciel(quiz_data.mega_texte) .. " !"
    end
    UI:ChoiceMenuYesNo(msg, true)
    UI:WaitForChoice()
    ok = UI:ChoiceResult()
    if not ok then
      UI:WaitShowDialogue("Reprenons le choix de ton sexe.")
      UI:BeginChoiceMenu("Quel est ton sexe ?", { "Garçon", "Fille", "Non-binaire" }, 1, 1)
      UI:WaitForChoice()
      g = UI:ChoiceResult()
      if g == 2 then genre = Gender.Female elseif g == 3 then genre = Gender.Genderless else genre = Gender.Male end
    end
  end

  -- création du héros (comme Halcyon : niveau 5, talent choisi)
  local mon_id = RogueEssence.Dungeon.MonsterID(starter.espece, starter.forme, 'normal', genre)
  _DATA.Save.ActiveTeam:SetRank("unranked")
  _DATA.Save.ActiveTeam.Money = 0
  _DATA.Save.NoSwitching = true
  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, talent, 0))
  _DATA.Save.ActiveTeam.Players[0].IsFounder = true
  GAME:SetTeamLeaderIndex(0)

  UI:WaitShowVoiceOver("Ton aventure commence maintenant...\nBonne route, " .. starter.nom .. " !", -1)
  GAME:CutsceneMode(false)
  GROUND:EnterGroundMap('metano_town', 'Main_Entrance_Marker')
end

return personality_test
