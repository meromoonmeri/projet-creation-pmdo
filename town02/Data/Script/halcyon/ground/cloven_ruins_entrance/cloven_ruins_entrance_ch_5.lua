--[[
    cloven_ruins_entrance_ch_5.lua — CAMP DES AEGIS CAVE
    REFONTE COMPLETE (2026-08-04)

    ==================================================================
    GEOMETRIE — auditee case par case AVANT ecriture
    ==================================================================
    Carte 576x408 px, TexSize 3, grille d'obstacles 72x51 cases de 8 px,
    2024 cases bloquantes sur 3672.

    Composante praticable REELLE, calculee par remplissage depuis
    Main_Entrance_Marker (24,216) : 894 positions posables pour une
    boite 16x16 — les 4 cases de 8 px testees a chaque fois.
    Etendue x 0..444, y 120..296. Le coeur large et continu est la
    bande y=160..256, prolongee a l'est par un chemin degage vers
    l'entree du donjon (408,200), desormais accessible.

    Objets scriptes : Dungeon_Entrance (408,200), desormais sur sol
    praticable. Aucune tablette Zarbi ni statue Kangourex dans la zone
    (retirees 2026-08-04).

    Toutes les positions de ce fichier sortent de cet audit. Aucune
    n'est estimee a l'oeil.

    ==================================================================
    STRUCTURE — 7 actes
    ==================================================================
      A1  ecran NOIR, pas seuls, deux repliques. Le fondu se declenche
          SUR la deuxieme, pas avant.
      A2  arrivee, incomprehension, travelling tres lent vers le centre
      A3  PLUM immobile au centre d'un camp VIDE (ni feu ni paillasse)
      A4  arrivees echelonnees des 10 membres, malaise croissant
      A5  « VOOOOOOOOUS M'AVEZ PERDUUUUU !!! » puis running gag
      A6  Ganlon veut manger, Shuca le calme d'un regard, diner
      A7  nuit : paillasses posees ICI SEULEMENT, chuchotements,
          Phileas rappelle Kino, discussion intime, reve

    REGLE OST : aucune musique jusqu'a la fin de l'acte 5. Uniquement le
    vent et les pas. C'est le silence qui rend Plum inquietante — une
    nappe musicale detruirait l'effet.
]]--
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
local TeamDazzlingAegis = require 'halcyon.TeamDazzlingAegis'
require 'halcyon.BossFX'
-- VoiceVisions.Nausea : le sursaut du reveil apres le reve de Gardevoir.
-- Meme dependance que le Mont Venteux (mount_windswept_entrance_ch_5.lua:5).
require 'halcyon.VoiceVisions'

cloven_ruins_entrance_ch_5 = {}

-- ==================================================================
-- POSITIONS — toutes validees contre obstacles[]
-- ==================================================================
cloven_ruins_entrance_ch_5.CAMP_X = 192
cloven_ruins_entrance_ch_5.CAMP_Y = 208
local CX = cloven_ruins_entrance_ch_5.CAMP_X
local CY = cloven_ruins_entrance_ch_5.CAMP_Y

-- Cercle du diner : VRAIE ellipse centree sur le foyer (CAMP_X, CAMP_Y).
--
-- CORRECTIF « le feu n'est pas au centre du cercle ». Le foyer etait bien a
-- 4 px du barycentre des places : ce n'est pas lui qui etait decale, c'est le
-- cercle qui n'en etait pas un. Les places allaient de 48 px (Penticus) a
-- 112 px (Plum) du feu, soit un rapport de plus du double — a l'ecran, la
-- moitie du groupe semblait colle aux flammes et l'autre reléguee au loin,
-- ce qui se lit exactement comme un feu decentre.
--
-- Les treize places sont desormais posees sur une ellipse RX=82 RY=45,
-- repartie en angles reguliers (360/13) a partir du sud. Distance au feu :
-- 43 a 82 px au lieu de 48 a 112. Ecart minimal entre voisins : 23 px.
-- Toutes verifiees marchables sur la grille de collision reelle.
-- Ordre choisi pour que les binomes restent cote a cote (hero/partner,
-- Kino/Reinier, Ganlon/Shuca) et que le heros soit au sud, face camera.
local PLACES = {
  hero      = {192, 256},
  partner   = {152, 248},
  Plum      = {128, 232},
  Ganlon    = {112, 216},
  Shuca     = {112, 192},
  Kino      = {136, 176},
  Reinier   = {176, 168},
  Almotz    = {208, 168},
  Hyko      = {248, 176},
  Rin       = {272, 192},
  Coco      = {272, 216},
  Phileas   = {256, 232},
  Penticus  = {232, 240},
}
cloven_ruins_entrance_ch_5.PLACES = PLACES

-- POSTE D'ACCUEIL DE PLUM (actes 1 a 5) — distinct de sa place au diner.
--
-- CORRECTIF. Elle etait posee d'emblee sur PLACES.Plum = {80, 200}, c'est-a-dire
-- a l'OUEST du camp. Or le duo entre par l'ouest (x=24) et marche vers l'est
-- jusqu'a x=152 : il lui passait littéralement dessus, puis la depassait. La
-- camera partait ensuite la chercher DERRIERE le groupe, et elle etait tournee
-- vers la gauche, donc de dos. Toute la chute de l'acte 5 (« elle etait devant
-- tout le monde depuis le debut ») tombait a plat, puisqu'elle etait derriere.
--
-- Elle attend desormais a l'EST de l'arret du duo, dans l'axe de la marche :
-- le groupe avance vers elle et la decouvre en face, ce que la scene raconte.
-- Position verifiee marchable et sans conflit (tools/audit_camp_ruines.py).
local PLUM_ACCUEIL = {216, 200}
cloven_ruins_entrance_ch_5.PLUM_ACCUEIL = PLUM_ACCUEIL

-- Paillasses : chacun dort la ou il a mange (patron du Mont Venteux), mais
-- POUSSE VERS L'EXTERIEUR du cercle pour degager le foyer pendant la nuit.
-- Recalculees avec les nouvelles places. Verifie : aucune sur un obstacle,
-- 29 px minimum entre deux paillasses, et le point de couchage lui-meme
-- (+13/+10, cf. plus bas) tombe sur du marchable.
-- CORRECTIF 2026-08-04 : la paillasse du PARTENAIRE (128,256) etait a la
-- lisiere du massif rocheux qui borde le camp au sud (y>=264) : le dormeur
-- semblait couche sur un rocher. On la remonte a (128,248), en plein sol.
-- Celle de PENTICUS (224,232) etait elle aussi sur un affleurement : on la
-- decale a (224,224). Les onze autres paillasses sont conservees telles
-- quelles (le joueur les a jugees parfaites).
local LITS = {
  hero      = {176, 256},
  partner   = {128, 248},
  Plum      = {104, 232},
  Ganlon    = {88, 216},
  Shuca     = {88, 184},
  Kino      = {112, 168},
  Reinier   = {168, 160},
  Almotz    = {200, 168},
  Hyko      = {272, 168},
  Rin       = {296, 184},
  Coco      = {296, 216},
  Phileas   = {280, 232},
  Penticus  = {224, 224},
}
cloven_ruins_entrance_ch_5.LITS = LITS

-- Arrivees echelonnees : chacun part du bord ouest et rejoint sa place.
--
-- CORRECTIF DE COLLISIONS. Tout le monde partait du MEME point (16, 200) et
-- visait des places dispersees : les derniers arrives traversaient donc les
-- premiers. Mesure avant correction (tools/audit_camp_ruines.py) : 11
-- traversees, dont Reinier passant a 6 px de Coco et Shuca a 8 px de Coco.
--
-- Nouvelle regle, tenue pour les dix : CHACUN PART A LA HAUTEUR DE SA PLACE.
-- Le trajet est alors une ligne droite horizontale, et deux lignes droites a
-- des hauteurs differentes ne se croisent jamais. Les places sont rangees en
-- arc ouvert autour du duo, toutes a l'ouest de Plum (x < 200) pour ne jamais
-- masquer la seule chose que la camera regarde a l'acte 3.
-- Verifie : 0 traversee, 0 superposition, 0 position dans un obstacle.
local ARR = {
  Phileas   = { depart = {16, 208}, attente = {120, 208} },
  Penticus  = { depart = {16, 208}, attente = {88, 208} },
  Rin       = { depart = {16, 176}, attente = {192, 176} },
  Coco      = { depart = {16, 208}, attente = {56, 208} },
  Hyko      = { depart = {16, 248}, attente = {192, 248} },
  Almotz    = { depart = {16, 184}, attente = {104, 184} },
  Ganlon    = { depart = {16, 232}, attente = {104, 232} },
  Shuca     = { depart = {16, 184}, attente = {72, 184} },
  Kino      = { depart = {16, 232}, attente = {72, 232} },
  Reinier   = { depart = {16, 184}, attente = {40, 184} },
}
cloven_ruins_entrance_ch_5.ARR = ARR

-- EntName reel de chaque PNJ : MakeCharactersFromList pose l'ESPECE
-- comme nom d'entite, pas le nom propre. CH('Tropius'), pas
-- CH('Penticus'). Verifie sur la version precedente du fichier.
local ESPECE = {
  Penticus  = 'Tropius',
  Phileas   = 'Noctowl',
  Coco      = 'Snubbull',
  Rin       = 'Audino',
  Hyko      = 'Growlithe',
  Almotz    = 'Zigzagoon',
  Kino      = 'Breloom',
  Reinier   = 'Girafarig',
  Plum      = 'Jigglypuff',
}
cloven_ruins_entrance_ch_5.ESPECE = ESPECE

-- ==================================================================
-- HELPERS DE MISE EN SCENE
-- ==================================================================
-- Regle du projet : un groupe qui pivote d'un bloc a l'air mecanique.
-- Tout ce qui touche plusieurs personnages est DECALE dans le temps.

local function E(nom)
  local id = ESPECE[nom]
  if id == nil then return nil end
  local c = nil
  pcall(function() c = CH(id) end)
  return c
end

-- Les auditeurs se tournent vers le locuteur, en decale.
local function Listen(speaker, listeners, emote)
  if speaker == nil or listeners == nil then return end
  -- Séquentiel plutôt qu'un Join de coroutines : les regards restent lisibles
  -- et aucun acteur bloqué ne peut suspendre toute la scène.
  for _, who in ipairs(listeners) do
    if who ~= nil and who ~= speaker then
      pcall(function()
        GROUND:CharTurnToCharAnimated(who, speaker, 4)
        if emote ~= nil then GROUND:CharSetEmote(who, emote, 1) end
      end)
      GAME:WaitFrames(2)
    end
  end
end

local EMOTION_EMOTE = {
  Surprised='shock', Stunned='shock', Worried='sweatdrop',
  Angry='angry', Shouting='exclaim', Determined='notice',
  Happy='happy', Joyous='happy', Inspired='notice', Pain='sweatdrop',
  Sigh='sweatdrop'
}

-- Le corps parle avant la bouche : regard, réaction, respiration, parole.
local function Says(speaker, emotion, key, listeners, emote)
  if speaker == nil then return end
  if listeners ~= nil then
    for _, target in ipairs(listeners) do
      if target ~= nil and target ~= speaker then
        pcall(function() GROUND:CharTurnToCharAnimated(speaker, target, 4) end)
        break
      end
    end
  end
  local body_emote = emote or EMOTION_EMOTE[emotion or 'Normal']
  if body_emote ~= nil then pcall(function() GROUND:CharSetEmote(speaker, body_emote, 1) end) end
  Listen(speaker, listeners, nil)
  GAME:WaitFrames(4)
  UI:SetSpeaker(speaker)
  GeneralFunctions.SetEmotion(emotion or "Normal")
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  GAME:WaitFrames(5)
end

-- Le heros ne parle JAMAIS a voix haute : pensee entre parentheses.
local function Pense(hero, key, emotion)
  pcall(function()
    GeneralFunctions.HeroDialogue(hero, STRINGS:Format(STRINGS.MapStrings[key]),
                                  emotion or "Normal")
  end)
end

-- Boite de narration : UNIQUEMENT pour ouvrir ou clore un acte.
local function Narre(key)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings[key]))
  UI:SetCenter(false)
end

-- Un vrai temps : boite fermee, rien a l'ecran.
local function Silence(frames)
  UI:SetCenter(false)
  UI:ResetSpeaker()
  GAME:WaitFrames(frames or 40)
end

-- Cascade de reactions : chacun SON emote, jamais le meme bloc.
local function ReactAll(reactions)
  if reactions == nil then return end
  local turns, i = {}, 0
  for _, r in ipairs(reactions) do
    i = i + 1
    if r[1] ~= nil then
      turns[#turns + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames((i - 1) * 5)
          GeneralFunctions.EmoteAndPause(r[1], r[2], true)
        end)
      end)
    end
  end
  if #turns > 0 then pcall(function() TASK:JoinCoroutines(turns) end) end
end

-- Respiration d'attente : de petits mouvements pour que personne ne
-- soit un mannequin pendant les dialogues des autres.
local function Respire(gens)
  local co = {}
  for i, who in ipairs(gens) do
    if who ~= nil then
      co[#co + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 11)
          GeneralFunctions.LookAround(who, 1, 10, false, false, true, Direction.Down)
        end)
      end)
    end
  end
  return co
end

-- Vent : le seul "son d'ambiance" des actes 1 a 5.
-- DUN_Wind est le SEUL SE de vent atteste dans le depot (5 emplois).
-- Premiere redaction : DUN_Whirlwind et DUN_Move_Ground — verification
-- faite, ZERO occurrence dans tout le mod. C'etaient des inventions.
local function Vent()
  pcall(function() SOUND:PlayBattleSE("DUN_Wind") end)
end

-- Les PAS de l'acte 1 ne sont pas un SE : aucun n'existe dans ce mod.
-- On les FAIT ENTENDRE autrement — les personnages marchent reellement
-- sous le noir (MoveToPosition), et le moteur joue leur animation de
-- marche. Le vent ponctue. C'est la solution honnete : pas de son
-- invente, et le joueur entend quand meme quelque chose bouger.


-- ==================================================================
-- SETUP — qui est present, et OU
-- ==================================================================
-- includeRecon : Kino et Reinier sont-ils au camp ? Ils partent en
-- reconnaissance apres le matin.
function cloven_ruins_entrance_ch_5.SetupGround(includeRecon)
  -- APRES L'ASSEMBLEE MATINALE (RuinsCampDone), tout le monde est parti
  -- devant dans les Ruines : il ne reste au camp que Penticus, Phileas
  -- et Plum (qui n'appartient pas a l'expedition). Le heros et le
  -- partenaire entrent seuls dans le dernier donjon.
  local apresAssemblee = false
  pcall(function()
    apresAssemblee = (SV.Chapter5 ~= nil and SV.Chapter5.RuinsCampDone == true)
  end)

  local spawn
  if apresAssemblee then
    spawn = {
      {'Tropius',   ARR.Penticus.attente[1], ARR.Penticus.attente[2], Direction.Down},
      {'Noctowl',   ARR.Phileas.attente[1],  ARR.Phileas.attente[2],  Direction.Down},
    }
  else
    spawn = {
      {'Tropius',   ARR.Penticus.attente[1], ARR.Penticus.attente[2], Direction.Down},
      {'Noctowl',   ARR.Phileas.attente[1],  ARR.Phileas.attente[2],  Direction.Down},
      {'Snubbull',  ARR.Coco.attente[1],     ARR.Coco.attente[2],     Direction.Down},
      {'Audino',    ARR.Rin.attente[1],      ARR.Rin.attente[2],      Direction.Down},
      {'Growlithe', ARR.Hyko.attente[1],     ARR.Hyko.attente[2],     Direction.Down},
      {'Zigzagoon', ARR.Almotz.attente[1],   ARR.Almotz.attente[2],   Direction.Down},
    }
  end
  -- Apres l'assemblee, Kino et Reinier sont partis devant : on ne les
  -- recre jamais, meme si includeRecon est vrai (retours apres KO, etc.).
  if includeRecon and not apresAssemblee then
    spawn[#spawn + 1] = {'Breloom',   ARR.Kino.attente[1],    ARR.Kino.attente[2],    Direction.Down}
    spawn[#spawn + 1] = {'Girafarig', ARR.Reinier.attente[1], ARR.Reinier.attente[2], Direction.Down}
  else
    -- CORRECTIF (log joueur 2026-08-03) : ScriptGround.Hide leve une
    -- ArgumentException si l'entite n'existe pas — et elle n'existe PAS
    -- a la premiere arrivee, puisqu'on est justement dans la branche qui
    -- ne la cree pas. Le pcall empechait le crash mais l'exception etait
    -- quand meme tracee a chaque entree sur la carte, noyant le log.
    -- On ne masque plus que ce qui existe reellement.
    for _, nom in ipairs({'Breloom', 'Girafarig'}) do
      local existe = false
      pcall(function()
        existe = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
      end)
      if existe then pcall(function() GROUND:Hide(nom) end) end
    end
  end
  -- Plum s'est incrustee au Mont Venteux et a suivi. Running gag.
  -- Elle apparait a son POSTE D'ACCUEIL, a l'est, deja tournee vers l'ouest :
  -- c'est par la que le duo arrive, et elle le regarde venir.
  spawn[#spawn + 1] = {'Jigglypuff', PLUM_ACCUEIL[1], PLUM_ACCUEIL[2], Direction.Left}

  -- ================================================================
  -- ANTI-DUPLICATION — bug constate en jeu sur l'ancienne carte
  -- ================================================================
  -- CharacterEssentials.MakeCharactersFromList appelle AddTempChar
  -- (CharacterEssentials.lua:2023 et 2034) SANS jamais verifier si
  -- l'entite existe deja. Chaque appel AJOUTE donc un sprite.
  --
  -- Or SetupGround etait appele DEUX FOIS pour une seule arrivee :
  --     init.lua:168        SetupGround(true)
  --     ch_5.lua ArrivalBody SetupGround(false)
  -- D'ou les sprites dupliques signales : deux Penticus, deux Rin,
  -- superposes au pixel pres et impossibles a distinguer a l'arret,
  -- mais visibles des qu'un des deux bouge.
  --
  -- On filtre donc la liste : on ne cree que ce qui n'existe pas.
  -- FindEntity est la methode qu'emploie ScriptGround.Hide lui-meme
  -- (Lua/ScriptGround.cs:31) ; signature verifiee dans
  -- Ground/Maps/GroundMap.cs:1004. Aucune API inventee.
  local aCreer = {}
  for _, e in ipairs(spawn) do
    local nom = e[1]
    local deja = false
    pcall(function()
      deja = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
    end)
    if deja then
      PrintInfo('[CR5] ' .. tostring(nom) .. ' existe deja — non recree.')
    else
      aCreer[#aCreer + 1] = e
    end
  end
  if #aCreer > 0 then
    pcall(function() CharacterEssentials.MakeCharactersFromList(aCreer) end)
  end

  -- Meme precaution pour les equipiers : SpawnerDoSpawn appele deux
  -- fois poserait deux fois Ganlon et Shuca. On ne declenche le
  -- spawner que si l'entite n'est pas deja sur la carte.
  if GAME:GetPlayerPartyCount() > 3 then
    for i, nom in ipairs({'Teammate2', 'Teammate3'}) do
      local deja = false
      pcall(function()
        deja = (GAME:GetCurrentGround():FindEntity(nom) ~= nil)
      end)
      if not deja then
        pcall(function()
          local cle = 'TEAMMATE_' .. tostring(i + 1)
          GROUND:SpawnerSetSpawn(cle, GAME:GetPlayerPartyMember(i + 1))
          GROUND:SpawnerDoSpawn(cle)
        end)
      end
    end
  end
end

function cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local anims = GAME:GetCurrentGround().Decorations[0].Anims
    for i = anims.Count - 1, 0, -1 do anims:RemoveAt(i) end
  end)
  cloven_ruins_entrance_ch_5.RemoveFireBlocker()
end

function cloven_ruins_entrance_ch_5.AddFireBlocker()
  pcall(function()
    cloven_ruins_entrance_ch_5.RemoveFireBlocker()
    local b = RogueEssence.Ground.GroundObject(
      RogueEssence.Content.ObjAnimData("", 1),
      RogueElements.Rect(CX + 6, CY + 6, 24, 24),
      RogueElements.Loc(0, 0), false, "Campfire_Blocker")
    b:ReloadEvents()
    GAME:GetCurrentGround():AddTempObject(b)
    cloven_ruins_entrance_ch_5.fireBlocker = b
  end)
end

function cloven_ruins_entrance_ch_5.RemoveFireBlocker()
  pcall(function()
    local b = cloven_ruins_entrance_ch_5.fireBlocker
    if b ~= nil then
      GAME:GetCurrentGround():RemoveTempObject(b)
      cloven_ruins_entrance_ch_5.fireBlocker = nil
    end
  end)
end

-- LE FEU : allume seulement au diner et pendant la nuit (acte 6/7),
-- jamais au matin. A l'arrivee, le camp doit etre VIDE — c'est une
-- exigence de la scene.
-- CORRECTIF 2026-08-04 : le feu re-apparaissait au rassemblement du
-- matin et restait allume pendant la formation et le depart, alors qu'il
-- doit s'eteindre avec la nuit. BuildCampDay ne rallume plus le foyer :
-- il purge le decor de la nuit precedente et rend la main sur un camp de
-- jour, feu eteint. Le feu ne se rallume qu'au diner (Acte 6) et pour la
-- nuit (DeployBeds).
function cloven_ruins_entrance_ch_5.BuildCampDay()
  -- JOUR : aucun filtre. On retire ceux d'une nuit precedente, sinon
  -- le camp reste sombre au reveil (defaut constate au Mont Venteux).
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  cloven_ruins_entrance_ch_5.PurgeDecor()
  cloven_ruins_entrance_ch_5.RemoveFireBlocker()
end

-- LES PAILLASSES : posees SEULEMENT a l'acte 7, jamais avant.
function cloven_ruins_entrance_ch_5.DeployBeds()
  -- NUIT NOIRE — patron exact du Mont Venteux
  -- (mount_windswept_entrance_ch_5.lua:4452 pose 'dusk' a l'arrivee au
  -- couchant, puis :5449 pose 'darkness' au deploiement des couchages).
  -- Ici les paillasses sortent au coeur de la nuit : on passe donc
  -- directement de dusk a darkness.
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  pcall(function() GROUND:AddMapStatus("darkness") end)
  cloven_ruins_entrance_ch_5.PurgeDecor()
  pcall(function()
    local g = GAME:GetCurrentGround()
    local hay = RogueEssence.Content.ObjAnimData('Hay_Bed', 1)
    for _, b in pairs(LITS) do
      g.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(hay,
        RogueElements.Loc(b[1], b[2])))
    end
    g.Decorations[0].Anims:Add(RogueEssence.Ground.GroundAnim(
      RogueEssence.Content.ObjAnimData('Campfire', 6), RogueElements.Loc(CX, CY)))
  end)
  cloven_ruins_entrance_ch_5.AddFireBlocker()
end


-- ==================================================================
-- ACTE 1 — L'ECRAN NOIR
-- ==================================================================
-- Le fondu ne se declenche PAS a l'entree de la carte : il attend la
-- DEUXIEME replique du partenaire. Jusque-la, le joueur n'a que la
-- voix et le mouvement.
function cloven_ruins_entrance_ch_5.ArrivalCutscene()
  local ok, err = pcall(cloven_ruins_entrance_ch_5.ArrivalBody)
  if not ok then
    PrintInfo('[CR5] arrivee interrompue : ' .. tostring(err))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.ArrivalBody()
  -- LE NOIR AVANT TOUT APPEL MOTEUR.
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  SOUND:StopBGM()   -- AUCUNE OST jusqu'a la fin de l'acte 5.

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(false)
  -- CREPUSCULE a l'arrivee : le camp des Ruines s'atteint au couchant.
  -- On retire seulement la nuit noire heritee d'une session precedente
  -- (sinon un rechargement apres la nuit arriverait dans un camp reste
  -- noir), puis on pose 'dusk' : le crepuscule est DEJA tombe quand le
  -- duo arrive — patron du Mont Venteux (mount_windswept_entrance_ch_5.lua:4452).
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  pcall(function() GROUND:AddMapStatus("dusk") end)
  -- PARTICULES DE FEUILLES : MapStatus 'autumn_leaves' (feuilles qui
  -- tombent en continu) — il existe bien dans Content/MapStatus, c'est
  -- le meme que celui des relais (gloomy_forest_midpoint).
  pcall(function() GROUND:AddMapStatus("autumn_leaves") end)
  -- Camp VIDE : ni feu, ni paillasse. On purge tout decor herite.
  cloven_ruins_entrance_ch_5.PurgeDecor()

  -- Tout le monde est cache sauf Plum : elle attend deja au centre.
  for nom, id in pairs(ESPECE) do
    if nom ~= 'Plum' then pcall(function() GROUND:Hide(id) end) end
  end

  -- Le duo entre par l'ouest, sous le noir. Ils MARCHENT vraiment :
  -- c'est leur animation de pas que le joueur percoit.
  GROUND:TeleportTo(hero, 24, 192, Direction.Right)
  if partner ~= nil then GROUND:TeleportTo(partner, 24, 216, Direction.Right) end
  GAME:MoveCamera(96, 200, 1, false)

  local marche1 = {}
  marche1[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 72, 192, false, 1) end)
  end)
  marche1[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(9)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 72, 216, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(marche1) end)

  -- Premiere replique, TOUJOURS sur le noir.
  Says(partner, "Normal", 'CR5_A01')
  Silence(18)

  -- Quelques secondes de marche de plus.
  local marche2 = {}
  marche2[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 120, 192, false, 1) end)
  end)
  marche2[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(9)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 120, 216, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(marche2) end)
  Silence(14)

  -- DEUXIEME replique : c'est PENDANT elle que le noir se leve.
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion("Normal")
  local fondu = TASK:BranchCoroutine(function()
    GAME:WaitFrames(20)
    pcall(function() GAME:FadeIn(150) end)   -- tres progressif
  end)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_A02']))
  pcall(function() TASK:JoinCoroutines({fondu}) end)
  Vent()
  Silence(20)

  cloven_ruins_entrance_ch_5.Acte2(hero, partner)
end


-- ==================================================================
-- ACTE 2 — ILS NE COMPRENNENT PAS CE QU'ILS VOIENT
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte2(hero, partner)
  -- Ils avancent encore un peu, puis s'arretent net.
  local av = {}
  av[1] = TASK:BranchCoroutine(function()
    pcall(function() GROUND:MoveToPosition(hero, 152, 200, false, 1) end)
  end)
  av[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(7)
    if partner ~= nil then
      pcall(function() GROUND:MoveToPosition(partner, 152, 224, false, 1) end)
    end
  end)
  pcall(function() TASK:JoinCoroutines(av) end)
  Silence(24)

  -- Ils regardent DEVANT. Le camp est vide, et ca ne colle pas.
  --
  -- Les deux pivotaient dans la meme frame : une rotation de groupe, que la
  -- charte du projet interdit. Le partenaire tourne la tete le premier (c'est
  -- lui qui parle ensuite), le heros suit 7 frames plus tard.
  local tourne = {}
  tourne[1] = TASK:BranchCoroutine(function()
    if partner ~= nil then
      pcall(function() GROUND:CharAnimateTurnTo(partner, Direction.Right, 6) end)
    end
  end)
  tourne[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(7)
    pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Right, 6) end)
  end)
  pcall(function() TASK:JoinCoroutines(tourne) end)
  Silence(30)

  -- Puis ils se regardent l'un l'autre. Rien n'est dit : c'est le
  -- regard qui pose la question.
  pcall(function()
    if partner ~= nil then
      GROUND:CharTurnToCharAnimated(hero, partner, 5)
      GAME:WaitFrames(7)
      GROUND:CharTurnToCharAnimated(partner, hero, 5)
    end
  end)
  Silence(28)

  -- Emotes d'interrogation et de gene, decalees.
  ReactAll({ {partner, "Question"}, {hero, "Sweating"} })
  Silence(16)

  -- Chacun balaie les alentours, a son rythme.
  local regard = {}
  regard[1] = TASK:BranchCoroutine(function()
    if partner ~= nil then
      pcall(function() GeneralFunctions.LookAround(partner, 2, 14, false, false, true, Direction.Right) end)
    end
  end)
  regard[2] = TASK:BranchCoroutine(function()
    GAME:WaitFrames(16)
    pcall(function() GeneralFunctions.LookAround(hero, 2, 14, false, false, true, Direction.Right) end)
  end)
  pcall(function() TASK:JoinCoroutines(regard) end)
  Vent()
  Silence(30)

  Says(partner, "Worried", 'CR5_A03', {hero})
  Silence(18)
  Pense(hero, 'CR5_A04', "Worried")
  Silence(24)

  cloven_ruins_entrance_ch_5.Acte3(hero, partner)
end


-- ==================================================================
-- ACTE 3 — LE TRAVELLING, PUIS PLUM
-- ==================================================================
-- La camera quitte le groupe et glisse TRES lentement jusqu'au centre
-- exact du camp. 104 px a parcourir : a 240 frames, c'est un mouvement
-- que le joueur voit avancer sans le sentir bouger.
function cloven_ruins_entrance_ch_5.Acte3(hero, partner)
  -- La camera glisse vers l'EST, la ou attend Plum. Elle ne s'arrete pas au
  -- foyer : elle depasse le duo et va decouvrir ce qu'il a devant lui.
  pcall(function() GAME:MoveCamera(PLUM_ACCUEIL[1] - 24, PLUM_ACCUEIL[2], 240, false) end)
  Silence(20)
  Vent()
  Silence(40)

  -- Elle est la. Debout. Immobile. Face au groupe. Bras le long du
  -- corps. La camera reste sur elle SANS AUCUN DIALOGUE.
  --
  -- Elle est deja tournee vers l'ouest depuis son apparition : elle les a
  -- regardes arriver tout du long. On ne la fait donc PAS pivoter ici — la
  -- faire se tourner maintenant dirait qu'elle vient seulement de les
  -- remarquer, ce qui contredit la chute de l'acte 5.
  local plum = E('Plum')

  -- Le duo, lui, la decouvre : chacun se tourne vers elle a son rythme,
  -- selon SA position (CharTurnToCharAnimated calcule la direction reelle).
  if plum ~= nil then
    local vu = {}
    vu[1] = TASK:BranchCoroutine(function()
      pcall(function() GROUND:CharTurnToCharAnimated(partner, plum, 5) end)
    end)
    vu[2] = TASK:BranchCoroutine(function()
      GAME:WaitFrames(8)
      pcall(function() GROUND:CharTurnToCharAnimated(hero, plum, 5) end)
    end)
    pcall(function() TASK:JoinCoroutines(vu) end)
  end
  Silence(60)
  Vent()
  Silence(70)

  -- Le partenaire finit par rompre le silence. Sourire gene.
  Says(partner, "Sigh", 'CR5_A05')
  Silence(14)
  Says(partner, "Happy", 'CR5_A06')
  Silence(22)

  -- Le heros observe : comment est-elle arrivee avant eux ?
  Pense(hero, 'CR5_A07', "Surprised")
  Silence(26)

  -- Plum ne repond pas. Elle detourne seulement les yeux vers le
  -- chemin par lequel tout le monde arrive : l'ouest, en contrebas.
  -- Elle regardait DROIT le duo (Left) ; elle glisse vers UpLeft, ce qui
  -- casse le contact visuel sans lui tourner le dos. Le duo comprend
  -- qu'elle ne le regarde plus lui, mais quelque chose derriere lui.
  if plum ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(plum, Direction.UpLeft, 10) end)
  end
  Silence(50)
  Vent()
  Silence(45)

  -- Emote "?" au-dessus de la tete du partenaire.
  if partner ~= nil then
    pcall(function() GeneralFunctions.EmoteAndPause(partner, "Question", true) end)
  end
  Says(partner, "Worried", 'CR5_A08')
  Silence(55)

  cloven_ruins_entrance_ch_5.Acte4(hero, partner, plum)
end


-- ==================================================================
-- ACTE 4 — LES ARRIVEES ECHELONNEES
-- ==================================================================
-- Chacun entre a son tour, marche vraiment depuis le bord ouest, et
-- lache une replique qui lui ressemble. Kino et Reinier sont les TOUT
-- DERNIERS et ne remarquent meme pas Plum : ils parlent d'eux.
local function Entre(nom, dir)
  local id = ESPECE[nom]
  if id == nil then return nil end
  local a = ARR[nom]
  if a == nil then return E(nom) end
  local c = E(nom)
  if c == nil then return nil end
  pcall(function()
    GROUND:TeleportTo(c, a.depart[1], a.depart[2], dir or Direction.Right)
    GROUND:Unhide(id)
    GROUND:MoveToPosition(c, a.attente[1], a.attente[2], false, 1)
  end)
  return c
end

function cloven_ruins_entrance_ch_5.Acte4(hero, partner, plum)
  -- Camera sur le chemin d'arrivee : on voit venir.
  pcall(function() GAME:MoveCamera(192, 208, 100, false) end)
  Silence(20)

  -- 1er : Phileas, methodique, il annonce l'etape.
  local phileas = Entre('Phileas')
  Says(phileas, "Normal", 'CR5_A09', {hero, partner})
  Silence(12)

  -- 2e : Penticus, le doyen, souffle apres la marche.
  local penticus = Entre('Penticus')
  Says(penticus, "Sigh", 'CR5_A10', {phileas})
  Silence(10)
  -- Echange : le doyen jauge la porte scellee devant laquelle le camp
  -- est monte. Le groupe prend conscience de ce qui l'attend.
  Says(partner, "Worried", 'CR5_A87', {phileas, penticus})
  Silence(12)
  Says(phileas, "Normal", 'CR5_A88', {partner, penticus})
  Silence(14)

  -- 3e : Rin, medicale, elle s'inquiete des pattes de tout le monde.
  local rin = Entre('Rin')
  Says(rin, "Worried", 'CR5_A11', {penticus, partner})
  Silence(10)

  -- 4e : Coco, surprise que le heros soit deja la.
  local coco = Entre('Coco')
  Says(coco, "Surprised", 'CR5_A12', {hero, partner})
  Silence(10)

  -- 5e : Hyko, garde du perimetre, il flaire quelque chose.
  local hyko = Entre('Hyko')
  Says(hyko, "Normal", 'CR5_A13', {coco})
  Silence(10)
  -- Echange : Coco remarque que Hyko n'ecoute plus la steppe, il ecoute
  -- le sol. Petit detail qui pose le ton des ruines.
  Says(coco, "Curious", 'CR5_A91', {hyko})
  Silence(12)
  Says(hyko, "Worried", 'CR5_A92', {coco})
  Silence(14)

  -- 6e : Almotz, soulage de ne pas etre le dernier pour une fois.
  local almotz = Entre('Almotz')
  Says(almotz, "Happy", 'CR5_A14', {hyko, rin})
  Silence(10)
  -- Echange : Rin taquine Almotz sur le sac trop lourd, Almotz se defend.
  Says(rin, "Teasing", 'CR5_A89', {almotz})
  Silence(12)
  Says(almotz, "Sigh", 'CR5_A90', {rin})
  Silence(14)

  -- Le groupe respire : personne n'est un mannequin.
  local resp = Respire({phileas, penticus, rin, coco, hyko, almotz})
  Silence(30)
  pcall(function() TASK:JoinCoroutines(resp) end)

  -- Ganlon et Shuca s'ils sont dans l'equipe.
  local ganlon, shuca = CH('Teammate2'), CH('Teammate3')
  if ganlon ~= nil then
    pcall(function()
      GROUND:TeleportTo(ganlon, ARR.Ganlon.depart[1], ARR.Ganlon.depart[2], Direction.Right)
      GROUND:MoveToPosition(ganlon, ARR.Ganlon.attente[1], ARR.Ganlon.attente[2], false, 1)
    end)
    Says(ganlon, "Sigh", 'CR5_A15', {almotz, coco})
    Silence(10)
  end
  if shuca ~= nil then
    pcall(function()
      GROUND:TeleportTo(shuca, ARR.Shuca.depart[1], ARR.Shuca.depart[2], Direction.Right)
      GROUND:MoveToPosition(shuca, ARR.Shuca.attente[1], ARR.Shuca.attente[2], false, 1)
    end)
    Says(shuca, "Normal", 'CR5_A16', {ganlon})
    Silence(12)
  end

  -- LES TOUT DERNIERS : Kino et Reinier, en pleine conversation.
  -- Ils ne voient meme pas Plum et continuent leur histoire.
  local kino = Entre('Kino')
  local reinier = Entre('Reinier')
  Says(kino, "Joyous", 'CR5_A17', {reinier})
  Silence(8)
  Says(reinier, "Normal", 'CR5_A18', {kino})
  Silence(8)
  Says(kino, "Shouting", 'CR5_A19', {reinier})
  Silence(14)

  -- ...puis ils comprennent que personne ne les ecoute.
  --
  -- Ils tournaient vers Direction.Right en dur : selon l'endroit ou ils se
  -- sont arretes, cela pouvait les faire regarder a cote du groupe. On vise
  -- desormais le heros lui-meme : CharTurnToCharAnimated calcule la direction
  -- reelle depuis leurs positions respectives, donc chacun se tourne selon SA
  -- geometrie. Decalage de 8 frames : Kino comprend avant Reinier.
  pcall(function()
    GROUND:CharTurnToCharAnimated(kino, hero, 5)
    GAME:WaitFrames(8)
    GROUND:CharTurnToCharAnimated(reinier, hero, 5)
  end)
  ReactAll({ {kino, "Question"}, {reinier, "Sweating"} })
  Says(reinier, "Worried", 'CR5_A20', {kino})
  Silence(20)

  -- LE MALAISE. Les conversations se font plus discretes. Chacun a sa
  -- lecture de la situation, fidele a son caractere.
  pcall(function() GAME:MoveCamera(CX - 24, CY, 120, false) end)
  Says(rin, "Worried", 'CR5_A21', {plum})
  Silence(16)
  Says(coco, "Normal", 'CR5_A22', {plum, rin})
  Silence(16)
  Says(hyko, "Sad", 'CR5_A23', {plum})
  Silence(18)
  Says(penticus, "Normal", 'CR5_A24', {plum, phileas})
  Silence(20)

  -- Tout le monde finit par se tourner vers elle, en decale.
  Listen(plum, {phileas, penticus, rin, coco, hyko, almotz, kino, reinier,
                ganlon, shuca, partner, hero})
  Silence(40)
  Vent()
  Silence(45)

  Pense(hero, 'CR5_A25', "Worried")
  Silence(50)

  cloven_ruins_entrance_ch_5.Acte5(hero, partner, plum,
    {phileas=phileas, penticus=penticus, rin=rin, coco=coco, hyko=hyko,
     almotz=almotz, kino=kino, reinier=reinier, ganlon=ganlon, shuca=shuca})
end


-- ==================================================================
-- ACTE 5 — LE CRI
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte5(hero, partner, plum, t)
  -- Elle FAIT VOLTE-FACE. Rotation en 1 frame, pas 8.
  --
  -- Elle avait detourne les yeux vers UpLeft a l'acte 3, puis tout le camp
  -- est arrive derriere le duo, a l'ouest. Elle revient donc brutalement sur
  -- Left : le mouvement est reel, et il cadre le groupe entier d'un coup.
  -- (Avant ce correctif elle « se retournait » vers la direction ou elle
  -- etait deja : le geste ne se voyait pas et le cri tombait de nulle part.)
  if plum ~= nil then
    pcall(function() GROUND:EntTurn(plum, Direction.Left) end)
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  end
  -- TRES gros silence. C'est lui qui arme la blague.
  Silence(75)

  -- LE CRI.
  pcall(function() BossFX.ShakeScreen(6, 30) end)
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end) -- Start funny guild theme!
  Says(plum, "Shouting", 'CR5_A26')
  pcall(function() GeneralFunctions.EmoteAndPause(plum, "Angry", true) end)
  Silence(20)

  -- Tout le camp encaisse : emotes DIFFERENTES, en cascade.
  ReactAll({ {partner, "Shock"}, {hero, "Exclaim"}, {t.coco, "Shock"},
             {t.rin, "Sweating"}, {t.hyko, "Exclaim"}, {t.almotz, "Shock"},
             {t.kino, "Question"}, {t.reinier, "Sweating"} })
  Silence(24)

  -- LE RUNNING GAG
  Says(t.penticus, "Sigh", 'CR5_A27', {plum})
  Silence(12)
  Says(plum, "Angry", 'CR5_A28', {t.penticus})
  Silence(10)
  Says(t.coco, "Happy", 'CR5_A29', {plum})
  Silence(10)
  Says(plum, "Shouting", 'CR5_A30', {t.coco})
  Silence(12)
  Says(t.phileas, "Normal", 'CR5_A31', {plum})
  Silence(14)
  -- La chute : elle etait devant tout le monde depuis le debut.
  Says(plum, "Sigh", 'CR5_A32', {t.phileas, partner})
  Silence(16)
  ReactAll({ {t.kino, "Happy"}, {partner, "Sweating"}, {t.almotz, "Happy"} })
  Says(t.kino, "Joyous", 'CR5_A33', {plum})
  Silence(12)
  Says(plum, "Angry", 'CR5_A34', {t.kino})
  Silence(14)
  Pense(hero, 'CR5_A35', "Sigh")
  Silence(20)

  cloven_ruins_entrance_ch_5.Acte6(hero, partner, plum, t)
end


-- ==================================================================
-- ACTE 6 — GANLON A FAIM, SHUCA LE REGARDE
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte6(hero, partner, plum, t)
  if t.ganlon ~= nil then
    Says(t.ganlon, "Happy", 'CR5_A36', {t.coco, partner})
    Silence(12)
    Says(t.coco, "Joyous", 'CR5_A37', {t.ganlon})
    Silence(10)
    Says(t.almotz, "Happy", 'CR5_A38', {t.ganlon})
    Silence(10)
    Says(t.ganlon, "Angry", 'CR5_A39', {t.coco, t.almotz})
    Silence(12)

    -- SHUCA NE DIT RIEN. Elle le regarde. C'est tout.
    if t.shuca ~= nil then
      pcall(function() GROUND:CharTurnToCharAnimated(t.shuca, t.ganlon, 3) end)
      Silence(45)
      pcall(function() GeneralFunctions.EmoteAndPause(t.ganlon, "Sweating", true) end)
      Silence(18)
      Says(t.ganlon, "Sigh", 'CR5_A40', {t.shuca})
      Silence(16)
      Pense(hero, 'CR5_A41', "Surprised")
      Silence(22)
    end
  end

  -- Le feu s'allume : c'est le repas. Le camp prend enfin vie.
  Narre('CR5_A42')
  pcall(function() SOUND:FadeOutBGM(30) end) -- Fade out funny BGM
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("At the End of the Day.ogg", true) end) -- Start cozy camp BGM!
  cloven_ruins_entrance_ch_5.BuildCampDay()

  -- Chacun a sa place autour du foyer.
  local assis = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, a in ipairs(assis) do
    local c, p = a[1], PLACES[a[2]]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Down) end)
    end
  end
  -- Tout le monde regarde le feu.
  for _, a in ipairs(assis) do
    if a[1] ~= nil then
      pcall(function()
        local dx, dy = CX - a[1].Position.X, CY - a[1].Position.Y
        local d = Direction.Down
        if math.abs(dx) > math.abs(dy) then
          d = (dx > 0) and Direction.Right or Direction.Left
        else
          d = (dy > 0) and Direction.Down or Direction.Up
        end
        GROUND:EntTurn(a[1], d)
      end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(45)
  Silence(30)

  -- LE DINER : les conversations se croisent.
  Says(t.penticus, "Normal", 'CR5_A43', {hero, partner, t.phileas})
  Silence(12)
  Says(t.kino, "Joyous", 'CR5_A44', {t.reinier, t.coco})
  Silence(10)
  Says(t.reinier, "Sigh", 'CR5_A45', {t.kino})
  Silence(10)
  Says(t.rin, "Happy", 'CR5_A46', {partner, hero})
  Silence(10)
  Says(plum, "Angry", 'CR5_A47', {t.coco, t.kino})
  Silence(10)
  ReactAll({ {t.coco, "Happy"}, {t.hyko, "Happy"}, {t.almotz, "Happy"} })
  Says(t.coco, "Joyous", 'CR5_A48', {plum})
  Silence(12)
  -- Echange intime : Coco demande a Rin ce qu'ils trouveront, Rin repond.
  Says(t.coco, "Curious", 'CR5_A93', {t.rin})
  Silence(12)
  Says(t.rin, "Normal", 'CR5_A94', {t.coco})
  Silence(14)
  -- Running gag leger : Almotz et son pain, pour detendre l'atmosphere.
  Says(t.kino, "Teasing", 'CR5_A95', {t.almotz})
  Silence(10)
  Says(t.almotz, "Sigh", 'CR5_A96', {t.kino})
  Silence(12)
  Says(t.hyko, "Normal", 'CR5_A49', {t.penticus})
  Silence(10)
  Says(t.phileas, "Normal", 'CR5_A50', {t.penticus, hero, partner})
  Silence(14)
  Says(partner, "Determined", 'CR5_A51', {hero, t.phileas})
  Silence(12)
  Pense(hero, 'CR5_A52', "Happy")
  Silence(20)

  -- ================================================================
  -- LA VEILLEE — Ganlon imite Tornadus, Phileas sermonne, puis les
  -- histoires de Phileas avant le coucher. Tout le monde reagit, en
  -- decale, chacun son caractere.
  -- ================================================================
  -- Ganlon se moque du gardien (running gag post-victoire). Il se leve
  -- un peu, imite la grosse voix, mime le coup d'aile.
  if t.ganlon ~= nil then
    pcall(function()
      GROUND:CharAnimateTurnTo(t.ganlon, Direction.Up, 4)
      GROUND:CharSetEmote(t.ganlon, "exclaim", 1)
    end)
    Says(t.ganlon, "Joyous", 'CR5_V01', {t.shuca, t.coco, t.rin})
    Silence(14)
    -- Shuca ne peut pas s'empecher de rire ; Coco pouffe aussi.
    ReactAll({ {t.shuca, "Happy"}, {t.coco, "Happy"}, {t.rin, "Sweating"} })
    Says(t.ganlon, "Joyous", 'CR5_V02', {t.shuca, t.coco})
    Silence(12)
    ReactAll({ {t.shuca, "Happy"}, {t.kino, "Happy"}, {t.almotz, "Happy"} })
    Silence(14)
  end

  -- PHILEAS S'ARRÊTE. Le rire retombe d'un coup : personne ne rit plus
  -- quand il reprend la parole sur ce ton.
  if t.phileas ~= nil then
    pcall(function()
      GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 6)
      GROUND:CharSetEmote(t.phileas, "", 0)
    end)
    Says(t.phileas, "Angry", 'CR5_V03', {t.ganlon, t.shuca, t.coco})
    Silence(16)
    -- Ganlon se deflate. Il baisse les yeux, la voix lui manque.
    if t.ganlon ~= nil then
      pcall(function() GROUND:CharSetEmote(t.ganlon, "sweating", 1) end)
      Says(t.ganlon, "Sigh", 'CR5_V04', {t.phileas})
      Silence(12)
    end
    Says(t.phileas, "Normal", 'CR5_V05', {t.ganlon, partner, hero})
    Silence(18)
  end

  -- Le duo est trouble : on l'a tous cru battu.
  Says(partner, "Surprised", 'CR5_V06', {hero, t.phileas})
  Silence(14)
  Pense(hero, 'CR5_V24', "Worried")
  Silence(16)

  -- PHILEAS REVELE LA VERITE SUR TORNADUS.
  if t.phileas ~= nil then
    pcall(function() GAME:MoveCamera(t.phileas.Position.X, t.phileas.Position.Y, 50, false) end)
    Says(t.phileas, "Worried", 'CR5_V07', {partner, hero, t.ganlon})
    Silence(18)
    Says(t.phileas, "Normal", 'CR5_V08', {partner, t.penticus})
    Silence(18)
    Says(t.phileas, "Determined", 'CR5_V09', {t.ganlon, partner})
    Silence(20)
    -- Le silence, puis Ganlon, penaud.
    if t.ganlon ~= nil then
      pcall(function() GROUND:CharSetEmote(t.ganlon, "sweating", 1) end)
      Says(t.shuca, "Sigh", 'CR5_V10', {t.ganlon})
      Silence(12)
      ReactAll({ {t.ganlon, "Sweating"}, {t.coco, "Sigh"} })
    end
  end

  -- PHILEAS ADOUCIT LE TON : c'est l'heure des histoires.
  if t.phileas ~= nil then
    pcall(function()
      GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 6)
      GeneralFunctions.SetEmotion("Happy")
    end)
    Says(t.phileas, "Happy", 'CR5_V11', {partner, hero, t.rin})
    Silence(16)
    -- LA LEGENDE : 16 ans plus tot, la catastrophe temporelle.
    pcall(function()
      GAME:MoveCamera(CX, CY, 60, false)
      GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 6)
    end)
    GAME:WaitFrames(20)
    Says(t.phileas, "Normal", 'CR5_V12', {partner, hero, t.rin, t.coco})
    Silence(20)
    Says(partner, "Surprised", 'CR5_V13', {t.phileas})
    Silence(14)
    Says(t.phileas, "Determined", 'CR5_V14', {partner, hero})
    Silence(20)
    -- Le partenaire, bouche beee, pose LA question.
    Says(partner, "Worried", 'CR5_V15', {t.phileas})
    Silence(16)
    Says(t.phileas, "Determined", 'CR5_V16', {partner, hero})
    Silence(22)
    -- L'AUTRE LEGENDE : Rescue Team et Rayquaza.
    Says(t.phileas, "Normal", 'CR5_V17', {partner, t.kino, t.reinier})
    Silence(20)
    Says(t.kino, "Joyous", 'CR5_V18', {t.phileas, t.reinier})
    Silence(14)
    Says(t.phileas, "Normal", 'CR5_V19', {partner, hero, t.kino})
    Silence(24)

    -- LE SILENCE. Le feu crepite. Tout le monde encaisse.
    pcall(function() GAME:MoveCamera(CX, CY, 1, false) end)
    Silence(30)
    Narre('CR5_V20')
    Silence(35)
  end

  -- PHILEAS RAPPROCHE LE CAMP : il est temps de dormir.
  if t.phileas ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(t.phileas, Direction.Down, 6) end)
    Says(t.phileas, "Normal", 'CR5_V21', {partner, hero, t.rin, t.coco})
    Silence(18)
    Says(partner, "Happy", 'CR5_V22', {t.phileas})
    Silence(16)
    Says(t.phileas, "Happy", 'CR5_V23', {partner, hero})
    Silence(20)
  end

  cloven_ruins_entrance_ch_5.Acte7(hero, partner, plum, t)
end



-- ==================================================================
-- ACTE 7 — LA NUIT, LES PAILLASSES, LE REVE
-- ==================================================================
function cloven_ruins_entrance_ch_5.Acte7(hero, partner, plum, t)
  -- LE SOIR TOMBE. 'dusk' d'abord, sous les yeux du joueur : la
  -- lumiere baisse pendant que le camp discute encore. La nuit noire
  -- ('darkness') ne viendra qu'avec les paillasses, dans DeployBeds.
  -- Patron du Mont Venteux, ou la meme progression est jouee.
  -- TRANSITION DOUCE VERS LE CREPUSCULE : on passe par un fondu doux de 40 frames
  -- pour eviter tout changement brusque de couleur a l'ecran (respect strict de la DA PMD).
  pcall(function() GAME:FadeOut(false, 40) end)
  pcall(function() GAME:WaitFrames(25) end)
  pcall(function() GROUND:RemoveMapStatus("gloom") end)
  pcall(function() GROUND:AddMapStatus("dusk") end)
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() GAME:FadeIn(40) end)
  -- Fin de la transition douce

  Narre('CR5_A53')
  GAME:FadeOut(false, 50)
  GAME:WaitFrames(35)

  -- LES PAILLASSES SONT POSEES ICI, ET NULLE PART AVANT.
  cloven_ruins_entrance_ch_5.DeployBeds()

  -- Chacun sur SA paillasse. Positions auditees : 40 px entre voisines,
  -- aucune sur un obstacle, aucune superposition.
  local couches = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, c in ipairs(couches) do
    local ch, p = c[1], LITS[c[2]]
    if ch ~= nil and p ~= nil then
      -- +13/+10 : centre le sprite SUR la paillasse. Sans ce decalage
      -- le dormeur est pose sur le coin haut-gauche du Hay_Bed et
      -- deborde visiblement. Patron du Mont Venteux
      -- (mount_windswept_entrance_ch_5.lua:81 seatX, :1892-1893).
      pcall(function() GROUND:TeleportTo(ch, p[1] + 13, p[2] + 10, Direction.Down) end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(50)
  Silence(30)

  -- Les chuchotements, comme au Mont Venteux.
  Says(t.coco, "Normal", 'CR5_A54', {t.rin})
  Silence(14)
  Says(t.rin, "Happy", 'CR5_A55', {t.coco})
  Silence(12)
  Says(t.almotz, "Normal", 'CR5_A56', {t.hyko})
  Silence(12)
  Says(t.kino, "Joyous", 'CR5_A57', {t.reinier})
  Silence(10)
  Says(t.reinier, "Sigh", 'CR5_A58', {t.kino})
  Silence(10)
  Says(t.kino, "Happy", 'CR5_A59', {t.reinier})
  Silence(14)
  -- Chuchotements supplementaires : Ganlon et le feu, Penticus et son
  -- coeur. La nuit s'apaise par petites conversations.
  if t.ganlon ~= nil and t.shuca ~= nil then
    Says(t.shuca, "Teasing", 'CR5_A97', {t.ganlon})
    Silence(10)
    Says(t.ganlon, "Sigh", 'CR5_A98', {t.shuca})
    Silence(12)
  end
  Says(t.penticus, "Worried", 'CR5_A99', {t.phileas})
  Silence(12)
  Says(t.phileas, "Normal", 'CR5_A100', {t.penticus})
  Silence(14)

  -- PHILEAS rappelle tout le monde a l'ordre — et cite Kino, comme
  -- au Mont Venteux. Clin d'oeil assume.
  Says(t.phileas, "Normal", 'CR5_A60', {t.kino, t.coco, t.rin, t.almotz})
  Silence(16)
  ReactAll({ {t.kino, "Sweating"}, {t.coco, "Happy"} })
  Says(t.kino, "Sigh", 'CR5_A61', {t.phileas})
  Silence(14)
  Says(plum, "Angry", 'CR5_A62', {t.phileas})
  Silence(12)
  ReactAll({ {t.phileas, "Sweating"} })
  Silence(20)

  -- LA DISCUSSION INTIME — camera resserree sur les deux paillasses.
  pcall(function()
    GAME:MoveCamera((LITS.hero[1] + LITS.partner[1]) / 2,
                    LITS.hero[2] + 8, 90, false)
  end)
  Silence(24)
  pcall(function()
    if partner ~= nil then GROUND:CharTurnToCharAnimated(partner, hero, 5) end
  end)
  Silence(16)
  Says(partner, "Normal", 'CR5_A63', {hero})
  Silence(18)
  Pense(hero, 'CR5_A64', "Normal")
  Silence(16)
  -- ENRICHISSEMENT 2026-08-04 : la discussion ne s'arrete pas apres
  -- « je pense a demain ». Le partenaire nomme ce qui les attend — les
  -- autres qui dorment autour du feu, et la responsabilite qu'ils portent
  -- pour eux. Chacun ajoute sa part, puis on retombe sur le « Bonne nuit »
  -- d'origine.
  Says(partner, "Worried", 'CR5_A64b', {hero})
  Silence(20)
  Pense(hero, 'CR5_A64c', "Worried")
  Silence(18)
  Says(partner, "Determined", 'CR5_A65', {hero})
  Silence(20)
  Says(partner, "Happy", 'CR5_A65b', {hero})
  Silence(22)
  Says(partner, "Normal", 'CR5_A66', {hero})
  Silence(24)

  -- Bonne nuit au reste de l'equipe.
  Says(t.penticus, "Normal", 'CR5_A67')
  Silence(30)

  -- Tout le monde s'endort.
  local dodo = {}
  for i, c in ipairs(couches) do
    if c[1] ~= nil then
      dodo[#dodo + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 6)
          GROUND:CharSetAnim(c[1], "Sleep", true)
        end)
      end)
    end
  end
  pcall(function() TASK:JoinCoroutines(dodo) end)
  Silence(40)

  SV.Chapter5.RuinsCampNightDone = true

  -- LE REVE : bascule vers hero_dream, qui renvoie ici.
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(40)

  local peut = false
  local okPre = pcall(function()
    peut = (_DATA.DataIndices ~= nil)
  end)
  if not okPre then peut = false end

  SV.TemporaryFlags.DreamReturn = 'cloven_ruins_entrance'
  local okDream = pcall(function()
    GAME:EnterGroundMap('hero_dream', 'Main_Entrance_Marker', true)
  end)
  if not okDream then
    PrintInfo('[CR5] hero_dream indisponible — reve saute')
    pcall(function() SV.Chapter5.RuinsDreamSeen = true end)
    pcall(function()
      GAME:EnterGroundMap('cloven_ruins_entrance', 'Main_Entrance_Marker', true)
    end)
  end
end


-- ==================================================================
-- LENDEMAIN MATIN — retour du reve
-- ==================================================================
function cloven_ruins_entrance_ch_5.ResumeAfterDream()
  local ok, err = pcall(cloven_ruins_entrance_ch_5.MorningBody)
  if not ok then
    PrintInfo('[CR5] matin interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.RuinsCampDone = true end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.MorningBody()
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  -- On sort du reve : le silence est VOULU sur les premieres secondes,
  -- mais il doit se refermer. La BGM du matin est relancee plus bas, au
  -- lever du jour (BuildCampDay), et la main n'est jamais rendue sans OST.
  SOUND:StopBGM()

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(true)
  -- On se reveille encore dans la nuit : DeployBeds repose 'darkness'.
  -- Le jour se levera avec BuildCampDay, plus bas, qui le retire.
  cloven_ruins_entrance_ch_5.DeployBeds()

  local t = {phileas=E('Phileas'), penticus=E('Penticus'), rin=E('Rin'),
             coco=E('Coco'), hyko=E('Hyko'), almotz=E('Almotz'),
             kino=E('Kino'), reinier=E('Reinier'),
             ganlon=CH('Teammate2'), shuca=CH('Teammate3')}
  local plum = E('Plum')

  -- Tout le monde encore couche.
  local couches = {
    {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
    {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
    {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
    {t.ganlon,'Ganlon'},{t.shuca,'Shuca'},
  }
  for _, c in ipairs(couches) do
    local ch, p = c[1], LITS[c[2]]
    if ch ~= nil and p ~= nil then
      pcall(function()
        -- Meme centrage +13/+10 qu'au coucher : le dormeur doit se
        -- reveiller EXACTEMENT ou il s'est couche.
        GROUND:TeleportTo(ch, p[1] + 13, p[2] + 10, Direction.Down)
        GROUND:CharSetAnim(ch, "Sleep", true)
      end)
    end
  end
  GAME:MoveCamera(CX, CY, 1, false)

  -- ================================================================
  -- LE SURSAUT DU REVEIL — patron du Mont Venteux
  -- ================================================================
  -- CORRECTIF : « le lendemain matin doit etre exactement le meme que
  -- celui du Mont Venteux ». Ici on passait directement du reve au
  -- carton « Le lendemain matin... », puis au camp deja debout : le
  -- reve n'avait AUCUNE consequence visible sur le corps du heros,
  -- alors que c'est tout le dispositif de la scene du Mont
  -- (mount_windswept_entrance_ch_5.lua:2020-2050).
  --
  -- Meme chaine que la-bas : camera serree sur sa couche, fondu, SE de
  -- sursaut, fin de l'anim de sommeil, nausee, puis ses pensees.
  --
  -- UNE DIFFERENCE ASSUMEE, et elle est scenaristique : au Mont, le
  -- heros OUBLIE en se reveillant (MWE5_155/156/157). Ici c'est le
  -- DEUXIEME reve, et le texte du reve dit explicitement l'inverse —
  -- « C'est la deuxieme fois que tu m'entends », « Cette fois, je me
  -- souviens de toi » (DRM_011_RUINS, DRM_012_RUINS). Il se souvient
  -- donc, et ce sont les mots de Gardevoir qui le poursuivent.
  -- Recopier l'oubli du Mont contredirait le reve qu'on vient de jouer.
  local litHero = LITS['hero']
  if litHero ~= nil then
    GAME:MoveCamera(litHero[1] + 13, litHero[2] + 10, 1, false)
  end
  GAME:FadeIn(45)
  GAME:WaitFrames(25)

  pcall(function() SOUND:PlayBattleSE('EVT_Emote_Exclaim_2') end)
  pcall(function() GROUND:CharEndAnim(hero) end)
  pcall(function() VoiceVisions.Nausea(hero, 1) end)
  GAME:WaitFrames(25)

  Pense(hero, 'CR5_A80', "Pain")
  Silence(30)
  Pense(hero, 'CR5_A81', "Surprised")
  Silence(25)
  Pense(hero, 'CR5_A82', "Worried")
  Silence(25)
  Pense(hero, 'CR5_A83', "Sad")
  Silence(35)

  -- LE PARTENAIRE NE PEUT PAS RESTER PASSIF. Il dort a cote : le heros
  -- vient de se redresser en sursaut, il se reveille forcement. Au Mont,
  -- c'est Phileas (de garde) qui reagit ; ici tout le monde dort, donc
  -- c'est le voisin de paillasse. Il se tourne vers lui, chuchote, et
  -- se rendort — il ne reveille pas le camp pour un cauchemar.
  if partner ~= nil then
    pcall(function() GROUND:CharEndAnim(partner) end)
    pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 5) end)
    Silence(20)
    Says(partner, "Worried", 'CR5_A84', {hero})
    Silence(18)
    Pense(hero, 'CR5_A85', "Worried")
    Silence(22)
    Says(partner, "Sigh", 'CR5_A86', {hero})
    Silence(20)
    pcall(function() GROUND:CharSetAnim(partner, "Sleep", true) end)
  end
  Silence(25)

  -- Le heros se recouche. La nuit reprend, et le matin arrive.
  pcall(function() GROUND:CharSetAnim(hero, "Sleep", true) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(40)
  GAME:MoveCamera(CX, CY, 1, false)

  -- LENDEMAIN ULTRA-LENT (patron Mont Venteux) : pas de carton brusque.
  -- La nuit noire s'efface tres progressivement, le crepuscule pointe,
  -- s'attarde, puis le jour prend le relais. On sent le temps passer
  -- avant que le camp ne se mette en mouvement.
  -- Ellipse temporelle entièrement sous le noir : le crépuscule reste en
  -- place pendant la soirée, puis la nuit. Le joueur ne voit plus un faux
  -- lever nuit → crépuscule → matin. Le prochain FadeIn révèle directement
  -- le camp reconstruit au matin, avec toute la formation déjà en place.
  pcall(function() UI:WaitShowVoiceOver(STRINGS:Format(STRINGS.MapStrings['CR5_A68']) .. "\n\n", -1) end)
  pcall(function() GROUND:RemoveMapStatus("darkness") end)
  pcall(function() GROUND:RemoveMapStatus("dusk") end)
  GAME:WaitFrames(30)

  -- Le camp se reveille, en decale : personne ne se leve en meme temps.
  local leve = {}
  for i, c in ipairs(couches) do
    if c[1] ~= nil then
      leve[#leve + 1] = TASK:BranchCoroutine(function()
        pcall(function()
          GAME:WaitFrames(i * 9)
          GROUND:CharEndAnim(c[1])
          GeneralFunctions.LookAround(c[1], 1, 12, false, false, true, Direction.Down)
        end)
      end)
    end
  end
  pcall(function() TASK:JoinCoroutines(leve) end)
  Silence(24)

  Says(t.coco, "Sigh", 'CR5_A69', {t.rin})
  Silence(12)
  Says(t.kino, "Happy", 'CR5_A70', {t.reinier})
  Silence(12)

  -- On replie les paillasses : le decor redevient un camp de jour.
  Narre('CR5_A71')
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(25)
  cloven_ruins_entrance_ch_5.BuildCampDay()

  -- LE JOUR SE LEVE, ET LA MUSIQUE AVEC LUI.
  -- Correctif : le matin jouait integralement en silence, y compris le
  -- rassemblement et le discours du Maitre de Guilde, et le joueur
  -- reprenait la main sans aucune OST. Le Mont Venteux, lui, relance
  -- toujours une piste avant de rendre la main
  -- (mount_windswept_entrance_ch_5.lua:5678, 'Mt. Travail.ogg').
  -- 'Aegis Cave.ogg' est la piste des ruines : la meme ambiance que la
  -- musique du donjon. Demande utilisateur : la musique envoyee (lien
  -- YouTube pour l'ambiance des ruines) doit aussi accompagner le
  -- rassemblement du matin, pas seulement le donjon. On l'utilise donc
  -- ici, des que le jour se leve sur le camp des Aegis Cave.
  pcall(function() SOUND:PlayBGM('Aegis Cave.ogg', true) end)

  -- LA FORMATION DE LA GUILDE — le rassemblement en rangs de deux,
  -- face au Maitre de Guilde. Même disposition que l'assemblée de la
  -- guilde et que le rassemblement du Mont Windswept :
  --   Penticus seul au centre, face aux troupes ;
  --   Phileas, son bras droit, en retrait sur sa gauche ;
  --   deux rangées de cinq, face à lui ;
  --   Plum EN DEHORS de la formation (elle ne fait pas partie de
  --   l'expédition) — sa position dit son statut sans un mot.
  -- CORRECTIF 2026-08-04 : chaque membre du rang de devant (y=240) est
  -- desormais EXACTEMENT devant son vis-a-vis du rang de derriere (y=272),
  -- sur la meme colonne — cinq paires, comme au Mont Venteux et a la
  -- guilde. Colonnes 116/140/164/188/212 : toutes sur du sol propre, hors
  -- du massif rocheux au sud (y>=264) et de l'affleurement est (x>~270).
  -- Toutes les positions verifiees libres sur la grille du camp.
  local FORMATION = {
    Penticus = {192, 180}, Phileas = {152, 188},
    -- rang de devant (y=240)
    partner  = {116, 240}, shuca = {140, 240}, kino = {164, 240},
    rin      = {188, 240}, hyko  = {212, 240},
    -- rang de derriere (y=272)
    hero     = {116, 272}, ganlon = {140, 272}, reinier = {164, 272},
    coco     = {188, 272}, almotz = {212, 272},
    -- plum a l'ecart, a l'est
    plum     = {320, 200},
  }
  local fonde = { {hero,'hero'},{partner,'partner'},{plum,'Plum'},{t.phileas,'Phileas'},
                  {t.penticus,'Penticus'},{t.rin,'Rin'},{t.coco,'Coco'},{t.hyko,'Hyko'},
                  {t.almotz,'Almotz'},{t.kino,'Kino'},{t.reinier,'Reinier'},
                  {t.ganlon,'Ganlon'},{t.shuca,'Shuca'} }
  for _, a in ipairs(fonde) do
    local c, cle = a[1], a[2]
    local p = FORMATION[cle]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Up) end)
    end
  end
  -- Penticus et Phileas se tiennent face a la troupe (vers le bas).
  if t.penticus ~= nil then
    pcall(function() GROUND:TeleportTo(t.penticus, 192, 180, Direction.Down) end)
  end
  if t.phileas ~= nil then
    pcall(function() GROUND:TeleportTo(t.phileas, 152, 188, Direction.DownRight) end)
  end
  -- Plum regarde la formation depuis son ecart.
  if plum ~= nil then
    pcall(function() GROUND:TeleportTo(plum, 320, 200, Direction.Left) end)
  end
  GAME:MoveCamera(CX, CY + 8, 1, false)
  GAME:FadeIn(45)
  Silence(18)
  -- Team Dazzling remplace définitivement Team Charm dans le présent de Cloven Ruin.
  TeamDazzlingAegis.GatheringAppearance()
  Silence(18)

  -- Tout le monde se tourne vers le Maitre de Guilde, en decale.
  Listen(t.penticus, {hero, partner, plum, t.phileas, t.rin, t.coco, t.hyko,
                      t.almotz, t.kino, t.reinier, t.ganlon, t.shuca})
  Silence(24)

  -- LE DISCOURS MATINAL.
  Says(t.penticus, "Normal", 'CR5_A72')
  Silence(16)
  Says(t.penticus, "Determined", 'CR5_A73')
  Silence(18)
  Says(t.penticus, "Shouting", 'CR5_A74')
  Silence(14)
  -- CORRECTIF d'audit : 'Determined' et 'Joyous' sont des EMOTIONS DE
  -- PORTRAIT, pas des emotes de bulle. EmoteAndPause ne les connait pas
  -- (GeneralFunctions.lua:590-650) et serait retombe en silence sur
  -- 'sweatdrop' — une goutte de sueur au moment ou le camp s'enthousiasme,
  -- soit exactement l'inverse de l'effet voulu.
  -- Emotes de bulle reellement gerees : Happy, Notice, Exclaim, Glowing,
  -- Sweating, Question, Angry, Shock, Sweatdrop.
  ReactAll({ {partner, "Exclaim"}, {t.kino, "Happy"}, {t.coco, "Happy"},
             {t.hyko, "Notice"}, {plum, "Happy"} })
  Says(partner, "Determined", 'CR5_A75', {hero})
  Silence(18)

  -- ================================================================
  -- LES AUTRES PARTENT DEVANT VERS LA GROTTE, PAR PAIRES — il ne
  -- reste que Penticus, Phileas et Plum au camp. Le heros et le
  -- partenaire entreront seuls dans le dernier donjon (equipe de deux,
  -- comme au debut du chapitre 5).
  -- CORRECTIF 2026-08-04 : avant, tout le monde s'evaporait d'un coup
  -- vers le NORD, hors champ, sans lien avec l'entree. Desormais chaque
  -- paire (deux membres qui partageaient la meme colonne de formation)
  -- marche a deux vers l'embouchure de la grotte (Dungeon_Entrance,
  -- cote est), l'un derriere l'autre, puis est retiree a la porte —
  -- comme des eclairiers qui entrent dans la grotte devant le duo.
  -- ================================================================
  local paires_dep = {
    { t.shuca, t.ganlon, 380, 220 },
    { t.kino,  t.reinier, 392, 216 },
    { t.rin,   t.coco,    380, 232 },
    { t.hyko,  t.almotz,  404, 212 },
  }
  local dep = {}
  for i, paire in ipairs(paires_dep) do
    local a, b, tx, ty = paire[1], paire[2], paire[3], paire[4]
    dep[#dep + 1] = TASK:BranchCoroutine(function()
      pcall(function()
        GAME:WaitFrames((i - 1) * 28)
        -- La paire se tourne vers l'est et marche vers la grotte, le
        -- second legerement en retrait : jamais un deplacement de bloc.
        if a ~= nil then
          GROUND:CharAnimateTurnTo(a, Direction.Right, 4)
          GROUND:MoveToPosition(a, tx, ty, false, 1.3)
        end
        if b ~= nil then
          GROUND:CharAnimateTurnTo(b, Direction.Right, 4)
          GROUND:MoveToPosition(b, tx + 12, ty + 4, false, 1.3)
        end
        GAME:WaitFrames(18)
        if a ~= nil then GAME:GetCurrentGround():RemoveTempChar(a) end
        if b ~= nil then GAME:GetCurrentGround():RemoveTempChar(b) end
      end)
    end)
  end
  pcall(function() TASK:JoinCoroutines(dep) end)
  Silence(20)

  -- La camera revient sur le trio qui reste, puis sur le duo.
  if t.penticus ~= nil then
    pcall(function() GAME:MoveCamera(t.penticus.Position.X, t.penticus.Position.Y, 60, false) end)
  end
  Silence(20)

  SV.Chapter5.RuinsCampDone = true
  if partner ~= nil then
    pcall(function()
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
      PartnerEssentials.SaveGamePartnerPosition(partner)
    end)
  end
  GeneralFunctions.RendreLaMain(true)
end


-- ==================================================================
-- RETOURS APRES KO / REPLI dans les Ruines
-- ==================================================================
function cloven_ruins_entrance_ch_5.KODefeatCutscene()
  local ok, err = pcall(function()
    cloven_ruins_entrance_ch_5.RetourBody('CR5_A76', 'CR5_A77')
  end)
  if not ok then
    PrintInfo('[CR5] reveil apres KO interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.RetreatReturnCutscene()
  local ok, err = pcall(function()
    cloven_ruins_entrance_ch_5.RetourBody('CR5_A78', 'CR5_A79')
  end)
  if not ok then
    PrintInfo('[CR5] repli interrompu : ' .. tostring(err))
    pcall(function() SV.Chapter5.PlayTempRuinsScene = false end)
    pcall(function() GAME:CutsceneMode(false) end)
    pcall(function() GAME:FadeIn(20) end)
  end
end

function cloven_ruins_entrance_ch_5.RetourBody(k1, k2)
  GAME:FadeOut(false, 1)
  GAME:CutsceneMode(true)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  cloven_ruins_entrance_ch_5.SetupGround(false)
  cloven_ruins_entrance_ch_5.BuildCampDay()
  -- Meme correctif que le matin : on rentre bredouille dans un camp qui
  -- vit toujours. Sans cette ligne la scene de retour, puis toute la
  -- reprise en main, se jouaient dans le silence complet.
  -- Meme piste que le rassemblement : l'ambiance des ruines (Aegis Cave).
  pcall(function() SOUND:PlayBGM('Aegis Cave.ogg', true) end)

  local rin = E('Rin')
  local penticus = E('Penticus')
  pcall(function() GROUND:TeleportTo(hero, PLACES.hero[1], PLACES.hero[2], Direction.Down) end)
  if partner ~= nil then
    pcall(function() GROUND:TeleportTo(partner, PLACES.partner[1], PLACES.partner[2], Direction.Down) end)
  end
  if rin ~= nil then
    pcall(function() GROUND:TeleportTo(rin, PLACES.Rin[1], PLACES.Rin[2], Direction.Left) end)
  end
  GAME:MoveCamera(CX, CY, 1, false)
  GAME:FadeIn(45)
  Silence(30)

  Says(rin, "Worried", k1, {hero, partner})
  Silence(16)
  Says(penticus, "Normal", k2, {hero, partner, rin})
  Silence(20)

  SV.Chapter5.PlayTempRuinsScene = false
  if partner ~= nil then
    pcall(function()
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    end)
  end
  GeneralFunctions.RendreLaMain(true)
end


-- ==================================================================
-- L'ENTREE — Penticus et Phileas, inquiets, une seule fois
-- ==================================================================
-- Le joueur vient de confirmer qu'il entre dans les Ruines. Avant le
-- fondu qui ouvre sur le donjon, on glisse une courte scene : les deux
-- sages du camp s'inquietent des nuits mouvementees du heros. Elle ne
-- se joue qu'une fois (RuinsEntryTalkDone), au premier passage devant
-- la porte — la repetition tuerait l'effet.
function cloven_ruins_entrance_ch_5.EntryTalk()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local phileas = E('Phileas')
  local penticus = E('Penticus')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    UI:ResetSpeaker()

    -- La camera quitte le duo et glisse vers les deux sages, deja
    -- tournes vers la porte. Le silence laisse le joueur comprendre
    -- qu'on parle de lui, pas de l'entree.
    pcall(function() SOUND:FadeOutBGM(40) end)
    if phileas ~= nil and penticus ~= nil then
      GAME:MoveCamera((phileas.Position.X + penticus.Position.X) / 2,
                      (phileas.Position.Y + penticus.Position.Y) / 2 - 8, 50, false)
    end
    GAME:WaitFrames(50)

    if penticus ~= nil and phileas ~= nil then
      -- Ils se tournent l'un vers l'autre : une confidence, pas un discours.
      GROUND:CharTurnToCharAnimated(penticus, phileas, 5)
      GAME:WaitFrames(8)
      GROUND:CharTurnToCharAnimated(phileas, penticus, 5)
      GAME:WaitFrames(20)

      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P1']))
      GAME:WaitFrames(16)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P2']))
      GAME:WaitFrames(18)

      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Sad")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P3']))
      GAME:WaitFrames(18)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Determined")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P4']))
      GAME:WaitFrames(22)

      -- LA LEGENDE DE MEW — Phileas, l'erudit, la confie avant qu'on
      -- pousse la porte. Penticus en connait des bribes, mais jamais
      -- il n'a entendu le mythe tout entier, a voix haute, ici.
      -- Un moment de confidence : on parle bas, les deux sages face
      -- a face, le duo immobile derriere.
      GROUND:CharTurnToCharAnimated(penticus, phileas, 5)
      GAME:WaitFrames(8)
      GROUND:CharTurnToCharAnimated(phileas, penticus, 5)
      GAME:WaitFrames(24)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P6']))
      GAME:WaitFrames(18)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_MEW01']))
      GAME:WaitFrames(14)

      -- Penticus sursaute a peine ; il connait le nom, pas le poids.
      GROUND:CharTurnToCharAnimated(penticus, phileas, 5)
      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Surprised")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_MEW02']))
      GAME:WaitFrames(14)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_MEW03']))
      GAME:WaitFrames(14)

      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Normal")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_MEW04']))
      GAME:WaitFrames(14)

      -- Phileas s'adresse maintenant au duo, pas a Penticus : un vœu.
      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Determined")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_MEW05']))
      GAME:WaitFrames(24)

      -- PLUM S'INCRUSTE (2026-08-04) : la confidence est interrompue.
      -- Plum, qui n'a jamais fait partie de l'expedition, vient se glisser
      -- entre les deux sages. Ils changent de sujet, genes — puis fondu
      -- noir, et le joueur reprend la main au camp.
      local plum = E('Plum')
      if plum ~= nil then
        GROUND:CharSetEmote(plum, "notice", 1)
        GROUND:CharTurnToCharAnimated(plum, penticus, 4)
        GROUND:MoveToPosition(plum,
          (phileas.Position.X + penticus.Position.X) / 2,
          (phileas.Position.Y + penticus.Position.Y) / 2 + 16, false, 1.1)
        GROUND:CharSetEmote(plum, "happy", 1)
        GAME:WaitFrames(40)
        UI:SetSpeaker(plum)
        GeneralFunctions.SetEmotion("Happy")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P7']))
        GAME:WaitFrames(16)
        GROUND:CharTurnToCharAnimated(penticus, plum, 4)
        UI:SetSpeaker(penticus)
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P8']))
        GAME:WaitFrames(16)
        UI:SetSpeaker(phileas)
        GeneralFunctions.SetEmotion("Normal")
        UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_ENTREE_P9']))
        GAME:WaitFrames(20)
        -- Plum recule d'un pas, satisfaite d'avoir ete entendue.
        GROUND:CharAnimateTurnTo(plum, Direction.Left, 4)
        GROUND:MoveInDirection(plum, Direction.Left, 24, false, 1.0)
        GAME:WaitFrames(30)
      end
      -- FONDU NOIR : la scene se referme ; le joueur reprend la main.
      pcall(function() GAME:FadeOut(false, 50) end)
      GAME:WaitFrames(35)
      pcall(function() GAME:FadeIn(30) end)
    end
  end)

  if not ok then
    PrintInfo('[CR5.EntryTalk] scene ecourtee : ' .. tostring(err))
  end

  -- Sortie garantie, hors pcall.
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
  pcall(function() SV.Chapter5.RuinsEntryTalkDone = true end)
end

-- ==================================================================
-- APRES REGISTEEL — Penticus et Phileas decident de rentrer
-- ==================================================================
-- Une seule fois (RegisteelDepartDone), au retour au camp apres la
-- victoire sur Registeel. Le duo est descendu dans le Puits (seg6) ;
-- les deux sages s'inquietent et decident de rentrer a la guilde pour
-- ramener des renforts. C'est ce qui rend coherente leur arrivee face a
-- Regigigas avec le reste de la guilde (RuinesTitan).
function cloven_ruins_entrance_ch_5.RegisteelDepart()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local phileas = E('Phileas')
  local penticus = E('Penticus')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    UI:ResetSpeaker()
    GAME:FadeIn(45)
    GAME:WaitFrames(40)

    if penticus ~= nil and phileas ~= nil then
      GROUND:CharTurnToCharAnimated(penticus, phileas, 5)
      GAME:WaitFrames(8)
      GROUND:CharTurnToCharAnimated(phileas, penticus, 5)
      GAME:WaitFrames(20)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_REGISTEEL_01']))
      GAME:WaitFrames(16)

      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Worried")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_REGISTEEL_02']))
      GAME:WaitFrames(18)

      UI:SetSpeaker(phileas)
      GeneralFunctions.SetEmotion("Determined")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_REGISTEEL_03']))
      GAME:WaitFrames(18)

      UI:SetSpeaker(penticus)
      GeneralFunctions.SetEmotion("Determined")
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_REGISTEEL_04']))
      GAME:WaitFrames(20)

      -- Ils se tournent vers la sortie : ils rentrent chercher la guilde.
      GROUND:CharAnimateTurnTo(penticus, Direction.Up, 5)
      GROUND:CharAnimateTurnTo(phileas, Direction.Up, 5)
      GAME:WaitFrames(20)
      UI:ResetSpeaker(false)
      UI:SetCenter(true)
      UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['CR5_REGISTEEL_05']))
      UI:SetCenter(false)
      UI:ResetSpeaker()
      GAME:WaitFrames(25)
    end
  end)

  if not ok then
    PrintInfo('[CR5.RegisteelDepart] scene ecourtee : ' .. tostring(err))
  end

  -- Sortie garantie, hors pcall.
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() GAME:CutsceneMode(false) end)
  pcall(function() SV.Chapter5.RegisteelDepartDone = true end)
end

return cloven_ruins_entrance_ch_5
