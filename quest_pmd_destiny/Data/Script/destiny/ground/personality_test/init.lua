--[[ init.lua — Quiz de personnalité PMD Destiny (map personality_test)
     Arrivée : enchaînement depuis intro_halo (intro halo arc-en-ciel +
     titres voice-over + transition blanche) — voir
     Data/Script/destiny/ground/intro_halo/init.lua.
     Flux (schéma de sélection complet, code entièrement rédigé pour
     PMD Destiny) :
       purge de l'équipe par défaut → 15 questions → nature (max de points)
       → badge étoile coloré → starter selon la nature → sexe → talent
       → confirmation « Êtes-vous sûr… ? » avec mention MÉGA-ÉVOLUTION en
       lettres arc-en-ciel → choix du partenaire (pool complet, espèce
       différente du héros) → sexe + talent du partenaire → NOM du
       partenaire (NameMenu + confirmation) → cinématique « le réveil de
       nuit » (map reveil_nuit).
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

-- Menu de talent (Intrinsic1/2/3, talent caché inclus) pour un Pokémon.
local function choisir_talent(espece, forme)
  local fiche = _DATA:GetMonster(espece).Forms[forme]
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
  return talent
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
  -- arrivée depuis l'intro halo : le fondu blanc se lève sur le fond Dream
  SOUND:PlayBGM("Welcome to the World of Pokémon!.ogg", true)
  GAME:FadeIn(40)
  GAME:WaitFrames(20)

  -- purge de l'équipe par défaut créée par la Nouvelle partie (missingno) :
  -- le héros est créé par le quiz lui-même
  local party_count = _DATA.Save.ActiveTeam.Players.Count
  for ii = 1, party_count, 1 do
    _DATA.Save.ActiveTeam.Players:RemoveAt(0)
  end
  local assembly_count = GAME:GetPlayerAssemblyCount()
  for i = 1, assembly_count, 1 do
    _DATA.Save.ActiveTeam.Assembly.RemoveAt(i - 1)
  end

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

  -- sexe du héros
  local genre = Gender.Male
  UI:BeginChoiceMenu("Quel est ton sexe ?", { "Garçon", "Fille", "Non-binaire" }, 1, 1)
  UI:WaitForChoice()
  local g = UI:ChoiceResult()
  if g == 2 then
    genre = Gender.Female
  elseif g == 3 then
    genre = Gender.Genderless
  end

  -- talent du héros
  local talent = choisir_talent(starter.espece, starter.forme)

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

  -- création du héros (niveau 5, talent choisi)
  local mon_id = RogueEssence.Dungeon.MonsterID(starter.espece, starter.forme, 'normal', genre)
  _DATA.Save.ActiveTeam:SetRank("unranked")
  _DATA.Save.ActiveTeam.Money = 0
  _DATA.Save.NoSwitching = true
  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 5, talent, 0))
  _DATA.Save.ActiveTeam.Players[0].IsFounder = true
  GAME:SetTeamLeaderIndex(0)

  -- ---------------------------------------------------- choix du partenaire
  UI:WaitShowVoiceOver("Un Pokémon ne part jamais seul...\nQui sera ton partenaire ?", -1)

  -- pool trié : gen puis nom (espèce du héros exclue)
  local pool = {}
  for _, s in pairs(quiz_data.starters) do table.insert(pool, s) end
  table.sort(pool, function(a, b)
    if a.gen ~= b.gen then return a.gen < b.gen end
    return a.nom < b.nom
  end)
  local choix_ids = {}
  for _, s in ipairs(pool) do
    if s.espece ~= starter.espece then
      table.insert(choix_ids, RogueEssence.Dungeon.MonsterID(s.espece, s.forme, 'normal', Gender.Genderless))
    end
  end

  local partner_id = nil
  local ok_partenaire = false
  while not ok_partenaire do
    UI:ChooseMonsterMenu("Qui sera ton partenaire ?", choix_ids)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    if result.Species == starter.espece then
      UI:WaitShowDialogue("Ton partenaire doit être un autre Pokémon que ton héros ! Choisis encore.")
    else
      UI:ChoiceMenuYesNo("Est-ce que " ..
        _DATA:GetMonster(result.Species):GetColoredName() .. " convient comme partenaire ?", true)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
        partner_id = result
        ok_partenaire = true
      end
    end
  end

  -- sexe du partenaire
  UI:BeginChoiceMenu("Quel est le sexe de ton partenaire ?", { "Garçon", "Fille", "Non-binaire" }, 1, 1)
  UI:WaitForChoice()
  local g2 = UI:ChoiceResult()
  local pgenre = Gender.Male
  if g2 == 2 then
    pgenre = Gender.Female
  elseif g2 == 3 then
    pgenre = Gender.Genderless
  end
  partner_id = RogueEssence.Dungeon.MonsterID(partner_id.Species, partner_id.Form, partner_id.Skin, pgenre)

  -- talent du partenaire
  local ptalent = choisir_talent(partner_id.Species, partner_id.Form)

  -- création du partenaire
  _DATA.Save.ActiveTeam.Players:Add(_DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, partner_id, 5, ptalent, 0))

  -- ------------------------------------------------------- nom du partenaire
  local nom = ""
  local ok_nom = false
  while not ok_nom do
    UI:NameMenu("Quel est le nom de ton partenaire ?", "Un petit surnom, et l'aventure est lancée.", 60)
    UI:WaitForChoice()
    nom = UI:ChoiceResult()
    if nom == "" then
      nom = _DATA:GetMonster(partner_id.Species).Name:ToLocal()
    end
    UI:ChoiceMenuYesNo("Le nom [color=#FFFF00]" .. nom .. "[color] convient-il ?", true)
    UI:WaitForChoice()
    ok_nom = UI:ChoiceResult()
  end

  local hero = GAME:GetPlayerPartyMember(0)
  local partner = GAME:GetPlayerPartyMember(1)
  GAME:SetCharacterNickname(partner, nom)
  GAME:SetTeamName(nom)

  -- les deux restent dans l'équipe (fondateurs / partenaires inséparables)
  _DATA.Save.ActiveTeam.Players[0].IsFounder = true
  _DATA.Save.ActiveTeam.Players[0].IsPartner = true
  _DATA.Save.ActiveTeam.Players[1].IsFounder = true
  _DATA.Save.ActiveTeam.Players[1].IsPartner = true
  _DATA.Save.ActiveTeam.Players[0]:FullRestore()
  _DATA.Save.ActiveTeam.Players[1]:FullRestore()
  local hTbl = LTBL(hero)
  local pTbl = LTBL(partner)
  hTbl.Importance = 'Hero'
  pTbl.Importance = 'Partner'

  -- ------------------------------------- cinématique : le réveil de nuit
  SOUND:FadeOutBGM(120)
  GAME:FadeOut(false, 120)
  GAME:WaitFrames(60)
  GAME:CutsceneMode(false)
  GROUND:EnterGroundMap('reveil_nuit', 'Main_Entrance_Marker')
end

return personality_test
