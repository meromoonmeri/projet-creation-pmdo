--[[
    SceneDebug.lua — ARMEMENT DES SCENES POUR TEST EN JEU

    -------------------------------------------------------------------
    POURQUOI CE FICHIER
    -------------------------------------------------------------------
    Toutes les cinematiques du mod ne se testent pas de la meme facon,
    et la difference n'est pas documentee. Deux exemples reels :

      Mont Windsep (mount_windswept_entrance/init.lua:163)
          if not SV.Chapter5.FinishedMountWindsweptIntro then
        Condition NEGATIVE. Defaut du drapeau = false, donc `not false`
        = vrai : la scene part toute seule des qu'on arrive sur la
        carte. Testable en mode dev sans rien preparer.

      Camp des Ruines (cloven_ruins_entrance/init.lua:91)
          if c5.RuinsCampPending and not c5.RuinsCampDone then
        Condition POSITIVE. RuinsCampPending vaut false par defaut
        (scriptvars.lua:935) et n'est pose qu'a UN SEUL endroit du mod :
        mount_windswept_guardian_ch_5.lua:858, apres la victoire sur
        Tornadus. En arrivant sur la carte par le mode dev, le drapeau
        est faux, le routeur tombe dans la branche « camp deja visite »
        et la cinematique ne se joue jamais.

    Les deux comportements sont CORRECTS : le camp doit etre arme, sinon
    il se rejouerait en rejouabilite. Mais sans outil, la seule facon de
    voir la scene est de rejouer tout le Mont Venteux, Tornadus compris.

    Ce module arme un etat de scene precis, puis depose le joueur sur la
    carte concernee. Il ne modifie AUCUNE logique de jeu : il se contente
    d'ecrire dans SV exactement ce que la progression normale y ecrirait.

    -------------------------------------------------------------------
    USAGE
    -------------------------------------------------------------------
    Depuis n'importe quel script, ou depuis la console Lua du mode dev :

        require 'halcyon.SceneDebug'
        SceneDebug.Menu()             -- menu de selection
        SceneDebug.Arm('ruins_camp')  -- arme sans se deplacer
        SceneDebug.Go('ruins_camp')   -- arme ET se teleporte

    -------------------------------------------------------------------
    REGLE DE SURETE
    -------------------------------------------------------------------
    Chaque entree pose l'ETAT COMPLET attendu par le routeur de sa carte,
    y compris les drapeaux qui doivent rester FAUX. Sans cela, une
    branche prioritaire (retour de reve, retour apres KO) capterait le
    routage avant la scene visee — c'est le piege principal de ces
    routeurs, qui testent leurs branches dans un ordre fixe.
]]--
require 'origin.common'

SceneDebug = {}

--------------------------------------------------------------------
-- CATALOGUE DES SCENES
--
-- Chaque entree decrit :
--   label   : intitule affiche dans le menu
--   chapter : chapitre a forcer (nil = ne pas toucher)
--   ground  : carte de destination
--   entry   : nom du marqueur d'entree
--   set     : table SV.Chapter<N> a ecrire, valeurs comprises
--   note    : rappel de la condition lue par le routeur
--
-- Les conditions citees ont ete relevees dans le code, fichier et
-- ligne a l'appui. Si un routeur change, MettreA jour ici aussi.
--------------------------------------------------------------------
SceneDebug.scenes = {
  {
    key = 'ruins_camp',
    label = "Ch5 — Camp des Ruines : arrivee",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua — not RuinsCampDone (condition assouplie le 2026-08-02)",
    set = { Chapter5 = {
      RuinsCampPending = true,
      RuinsCampDone = false,
      RuinsCampNightDone = false,
      PlayTempRuinsScene = false,
      RuinsLastExitReason = '',
    }},
  },
  {
    key = 'ruins_ko',
    label = "Ch5 — Camp des Ruines : reveil apres KO",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:78 — PlayTempRuinsScene, raison 'Died'",
    set = { Chapter5 = {
      PlayTempRuinsScene = true,
      RuinsLastExitReason = 'Died',
      RuinsCampPending = false,
      RuinsCampDone = true,
      RuinsCampNightDone = false,
    }},
  },
  {
    key = 'ruins_retreat',
    label = "Ch5 — Camp des Ruines : repli volontaire",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:79 — PlayTempRuinsScene, raison 'Retreated'",
    set = { Chapter5 = {
      PlayTempRuinsScene = true,
      RuinsLastExitReason = 'Retreated',
      RuinsCampPending = false,
      RuinsCampDone = true,
      RuinsCampNightDone = false,
    }},
  },
  {
    key = 'ruins_morning',
    label = "Ch5 — Camp des Ruines : matin apres le reve",
    chapter = 5, ground = 'cloven_ruins_entrance', entry = 'Main_Entrance_Marker',
    note = "cloven_ruins_entrance/init.lua:64 — RuinsCampNightDone and not RuinsCampDone",
    set = { Chapter5 = {
      RuinsCampNightDone = true,
      RuinsCampDone = false,
      RuinsCampPending = false,
      PlayTempRuinsScene = false,
    }},
  },
  {
    key = 'mount_intro',
    label = "Ch5 — Mont Windsep : arrivee",
    chapter = 5, ground = 'mount_windswept_entrance', entry = 'Main_Entrance_Marker',
    note = "mount_windswept_entrance/init.lua:163 — not FinishedMountWindsweptIntro",
    set = { Chapter5 = {
      FinishedMountWindsweptIntro = false,
      CampNightWatchDone = false,
      PlayTempMountScene = false,
    }},
  },
  {
    key = 'mount_ko',
    label = "Ch5 — Mont Windsep : retour apres KO",
    chapter = 5, ground = 'mount_windswept_entrance', entry = 'Main_Entrance_Marker',
    note = "mount_windswept_entrance/init.lua:165 — PlayTempMountScene",
    set = { Chapter5 = {
      FinishedMountWindsweptIntro = true,
      PlayTempMountScene = true,
      MountLastExitReason = 'Died',
      CampNightWatchDone = false,
    }},
  },
  {
    key = 'colline_xatu',
    label = "Ch7 — Colline des Anciens : vision de Xatu",
    chapter = 7, ground = 'colline_anciens', entry = 'Main_Entrance_Marker',
    note = "scene jouee inconditionnellement dans colline_anciens.Enter",
    set = { Chapter7 = { VisitedXatu = false }},
  },
  {
    key = 'dazzling',
    label = "Ch6 — Foret Lugubre : arrivee de la Team Dazzling",
    chapter = 6, ground = 'gloomy_forest_entrance', entry = 'Main_Entrance_Marker',
    note = "gloomy_forest_entrance/init.lua:30 — chapitre 6 et not FinishedGloomyForestIntro",
    set = { Chapter6 = { FinishedGloomyForestIntro = false }},
  },
  {
    key = 'kirlia',
    label = "Ch8 — Cafe Spinda : quizz de Kirlia",
    chapter = 8, ground = 'metano_cafe', entry = 'Main_Entrance_Marker',
    note = "metano_cafe.KirliaQuiz — chapitre >= 8 et QuizScore == nil",
    set = { Chapter8 = { QuizScore = nil }},
  },
  {
    key = 'ch1_intro',
    label = "Ch1 — Forêt des Reliques : arrivée du duo",
    chapter = 1, ground = 'relic_forest', entry = 'Main_Entrance_Marker',
    note = "relic_forest/init.lua:69 — not PlayedIntroCutscene",
    set = { Chapter1 = { PlayedIntroCutscene = false, PartnerMetHero = false, PartnerEnteredForest = false, PartnerCompletedForest = false, TeamCompletedForest = false }},
  },
  {
    key = 'ch2_riviere',
    label = "Ch2 — Rivière Lumineuse : arrivée",
    chapter = 2, ground = 'illuminant_riverbed_entrance', entry = 'Main_Entrance_Marker',
    note = "illuminant_riverbed_entrance — première visite ch2",
    set = { Chapter2 = { FinishedRiver = false }},
  },
  {
    key = 'ch3_caverne',
    label = "Ch3 — Caverne Tortueuse : arrivée",
    chapter = 3, ground = 'crooked_cavern_entrance', entry = 'Main_Entrance_Marker',
    note = "crooked_cavern_entrance — première visite ch3",
    set = { Chapter3 = { FinishedOutlawIntro = false }},
  },
  {
    key = 'ch4_noigrumes',
    label = "Ch4 — Forêt des Noigrumes : arrivée",
    chapter = 4, ground = 'apricorn_grove_entrance', entry = 'Main_Entrance_Marker',
    note = "apricorn_grove_entrance/init.lua:78 — not EnteredGrove",
    set = { Chapter4 = { EnteredGrove = false, FinishedGrove = false, ReachedGlade = false }},
  },
  {
    key = 'ch10_rayquaza',
    label = "Ch10 — Sommet de la Tour : climax Rayquaza",
    chapter = 10, ground = 'tour_ciel_sommet', entry = 'Main_Entrance_Marker',
    note = "tour_ciel_sommet/init.lua — Enter() acte 1 (PeakVictory)",
    set = { Chapter10 = { CelestialPeakComplete = true, PlayedLugiaTalk = false }},
  },

  -- ================================================================
  -- ARC FUGITIF (ch11) — scenes standalone jouables directement.
  -- Dialogues = cles SCENE_* (a adopter) ; le menu permet de voir le
  -- deroule, les fondus et les musiques.
  -- ================================================================
  {
    key = 'arc_fuite_fissure',
    label = "Ch11 — Arc Fugitif : la fissure (A02P01)",
    ground = 'a02p01', entry = 'Main_Entrance_Marker',
    note = "scène standalone a02p01.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a02p01')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_fuite_feu',
    label = "Ch11 — Arc Fugitif : l'incendie (A02P02)",
    ground = 'a02p02', entry = 'Main_Entrance_Marker',
    note = "scène standalone a02p02.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a02p02')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_fuite_lapis',
    label = "Ch11 — Arc Fugitif : grotte Lapis (A02P03)",
    ground = 'a02p03', entry = 'Main_Entrance_Marker',
    note = "scène standalone a02p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a02p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_fuite_volcan',
    label = "Ch11 — Arc Fugitif : le volcan (A02P04)",
    ground = 'a02p04', entry = 'Main_Entrance_Marker',
    note = "scène standalone a02p04.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a02p04')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_lapis_entree',
    label = "Ch11 — Arc Fugitif : Lapis entrée (D08P01)",
    ground = 'grotte_lazuli_seuil', entry = 'Main_Entrance_Marker',
    note = "scène standalone grotte_lazuli_seuil.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.grotte_lazuli_seuil')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_lapis_fond',
    label = "Ch11 — Arc Fugitif : Lapis fond (D08P02)",
    ground = 'grotte_lazuli_fond', entry = 'Main_Entrance_Marker',
    note = "scène standalone grotte_lazuli_fond.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.grotte_lazuli_fond')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_brasier_entree',
    label = "Ch11 — Arc Fugitif : Mt Brasier entrée (D09P01)",
    ground = 'mont_cendre_pied', entry = 'Main_Entrance_Marker',
    note = "scène standalone mont_cendre_pied.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.mont_cendre_pied')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_brasier_relais',
    label = "Ch11 — Arc Fugitif : Mt Brasier relais (D09P02)",
    ground = 'd09p02', entry = 'Main_Entrance_Marker',
    note = "scène standalone d09p02.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d09p02')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_brasier_sommet',
    label = "Ch11 — Arc Fugitif : sommet Moltres (D09P03)",
    ground = 'd09p03', entry = 'Main_Entrance_Marker',
    note = "scène standalone d09p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d09p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_givree_entree',
    label = "Ch11 — Arc Fugitif : Forêt Givrée entrée (D10P01)",
    ground = 'foret_givree_oree', entry = 'Main_Entrance_Marker',
    note = "scène standalone foret_givree_oree.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.foret_givree_oree')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_givree_relais',
    label = "Ch11 — Arc Fugitif : Forêt Givrée relais (D10P02)",
    ground = 'd10p02', entry = 'Main_Entrance_Marker',
    note = "scène standalone d10p02.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d10p02')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_givree_sommet',
    label = "Ch11 — Arc Fugitif : sommet Artikodin (D10P03)",
    ground = 'd10p03', entry = 'Main_Entrance_Marker',
    note = "scène standalone d10p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d10p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_gele_entree',
    label = "Ch11 — Arc Fugitif : Mt Gelé entrée (D11P01)",
    ground = 'mont_gele_pied', entry = 'Main_Entrance_Marker',
    note = "scène standalone mont_gele_pied.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.mont_gele_pied')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_gele_relais',
    label = "Ch11 — Arc Fugitif : Mt Gelé relais (D11P02)",
    ground = 'd11p02', entry = 'Main_Entrance_Marker',
    note = "scène standalone d11p02.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d11p02')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_gele_autel',
    label = "Ch11 — Arc Fugitif : autel Feunard (D11P03)",
    ground = 'd11p03', entry = 'Main_Entrance_Marker',
    note = "scène standalone d11p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d11p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_magma_entree',
    label = "Ch11 — Arc Fugitif : Caverne Magma entrée (D12P01)",
    ground = 'gorge_ardente_porte', entry = 'Main_Entrance_Marker',
    note = "scène standalone gorge_ardente_porte.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.gorge_ardente_porte')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_magma_coeur',
    label = "Ch11 — Arc Fugitif : Caverne Magma cœur (D12P02)",
    ground = 'gorge_ardente_coeur', entry = 'Main_Entrance_Marker',
    note = "scène standalone gorge_ardente_coeur.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.gorge_ardente_coeur')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_magma_fosse',
    label = "Ch11 — Arc Fugitif : fosse Groudon (D12P04)",
    ground = 'fosse_ardente', entry = 'Main_Entrance_Marker',
    note = "scène standalone fosse_ardente.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.fosse_ardente')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_tour_entree',
    label = "Ch11 — Arc Fugitif : Tour Céleste entrée (D13P01)",
    ground = 'arc_parvis_celeste', entry = 'Main_Entrance_Marker',
    note = "scène standalone d13p01.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d13p01')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_tour_relais',
    label = "Ch11 — Arc Fugitif : Tour Céleste relais (D13P02)",
    ground = 'arc_palier_celeste', entry = 'Main_Entrance_Marker',
    note = "scène standalone d13p02.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d13p02')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_tour_sommet',
    label = "Ch11 — Arc Fugitif : sommet Rayquaza (D13P03)",
    ground = 'arc_tour_ciel_sommet', entry = 'Main_Entrance_Marker',
    note = "scène standalone d13p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.d13p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_place',
    label = "Ch11 — Arc Fugitif : Place Pokémon panique (T01P01)",
    ground = 't01p01', entry = 'Main_Entrance_Marker',
    note = "scène standalone t01p01.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.t01p01')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_reve',
    label = "Ch11 — Arc Fugitif : le rêve (A04P01)",
    ground = 'a04p01', entry = 'Main_Entrance_Marker',
    note = "scène standalone a04p01.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a04p01')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
  {
    key = 'arc_fin',
    label = "Ch11 — Arc Fugitif : The End (A05P03)",
    ground = 'a05p03', entry = 'Main_Entrance_Marker',
    note = "scène standalone a05p03.lua (dialogues SCENE_* à adopter)",
    set = {},
    play = function()
      GAME:CutsceneMode(true)
      local mod = require('halcyon.arc_fugitif.scene.a05p03')
      if mod ~= nil and mod.Cutscene ~= nil then mod.Cutscene() end
      GAME:CutsceneMode(false)
      GAME:FadeIn(20)
    end,
  },
}


--------------------------------------------------------------------
-- Recherche d'une scene par sa cle.
--------------------------------------------------------------------
function SceneDebug.Find(key)
  for _, sc in ipairs(SceneDebug.scenes) do
    if sc.key == key then return sc end
  end
  return nil
end


--------------------------------------------------------------------
-- Ecrit l'etat SV d'une scene, SANS deplacer le joueur.
-- Retourne true si l'armement a reussi.
--------------------------------------------------------------------
function SceneDebug.Arm(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return false
  end

  local ok, err = pcall(function()
    if sc.chapter ~= nil then
      SV.ChapterProgression.Chapter = sc.chapter
    end
    for tableName, fields in pairs(sc.set) do
      if SV[tableName] == nil then SV[tableName] = {} end
      for field, value in pairs(fields) do
        SV[tableName][field] = value
      end
    end
  end)

  if not ok then
    PrintInfo('[SceneDebug] armement echoue (' .. tostring(key) .. ') : ' .. tostring(err))
    return false
  end

  --Crochet pour les scenes dont l'etat ne vit pas dans une table
  --SV.Chapter<N> (ex. SV.LegendZones.Defeated pour les Ancrages).
  if sc.apres ~= nil then
    local okA, errA = pcall(sc.apres)
    if not okA then
      PrintInfo('[SceneDebug] crochet apres() echoue : ' .. tostring(errA))
    end
  end

  PrintInfo('[SceneDebug] arme : ' .. sc.label)
  PrintInfo('[SceneDebug]   condition visee : ' .. tostring(sc.note))
  return true
end


--------------------------------------------------------------------
-- Arme puis depose le joueur sur la carte de la scene.
--------------------------------------------------------------------
function SceneDebug.Go(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return
  end
  if not SceneDebug.Arm(key) then return end

  pcall(function() GAME:FadeOut(false, 20) end)
  GAME:EnterGroundMap(sc.ground, sc.entry)
end


--------------------------------------------------------------------
-- Menu de selection. A appeler depuis un PNJ ou objet de debug.
--------------------------------------------------------------------
function SceneDebug.Menu()
  local labels = {}
  for _, sc in ipairs(SceneDebug.scenes) do
    labels[#labels + 1] = sc.label
  end
  labels[#labels + 1] = "(annuler)"

  UI:BeginMultiPageMenu(24, 24, 232, "Armer une scene", labels, 8, 1, #labels)
  UI:WaitForChoice()
  local pick = UI:ChoiceResult()

  if pick == nil or pick > #SceneDebug.scenes then return end
  SceneDebug.Go(SceneDebug.scenes[pick].key)
end


--------------------------------------------------------------------
-- Diagnostic : affiche l'etat actuel des drapeaux d'une scene, pour
-- comprendre POURQUOI une cinematique ne part pas.
--------------------------------------------------------------------
function SceneDebug.Why(key)
  local sc = SceneDebug.Find(key)
  if sc == nil then
    PrintInfo('[SceneDebug] cle inconnue : ' .. tostring(key))
    return
  end

  PrintInfo('[SceneDebug] === ' .. sc.label .. ' ===')
  PrintInfo('[SceneDebug] condition : ' .. tostring(sc.note))
  if sc.chapter ~= nil then
    local cur = SV.ChapterProgression.Chapter
    PrintInfo(string.format('[SceneDebug] chapitre : actuel=%s attendu=%s %s',
      tostring(cur), tostring(sc.chapter),
      (cur == sc.chapter) and 'OK' or '<-- BLOQUANT'))
  end
  for tableName, fields in pairs(sc.set) do
    for field, expected in pairs(fields) do
      local actual = nil
      pcall(function() actual = SV[tableName][field] end)
      local match = (actual == expected)
      PrintInfo(string.format('[SceneDebug] SV.%s.%s : actuel=%s attendu=%s %s',
        tableName, field, tostring(actual), tostring(expected),
        match and 'OK' or '<-- A CORRIGER'))
    end
  end
end

return SceneDebug
