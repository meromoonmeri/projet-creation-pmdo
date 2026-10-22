--[[
    ChapterScenes.lua

    SCENES D'ARRIVEE DES CHAPITRES 8, 9 ET 10
    ================================================================
    Ces trois chapitres avaient leur donjon, leurs dialogues de ville et leur
    veillee — mais AUCUNE mise en scene a l'arrivee devant le donjon. On y
    entrait par un simple menu oui/non. Mesure a l'appui : ch1-5 totalisent
    633 a 1229 boites de dialogue chacun, ch8/9/10 en ont 71, 52 et 53.

    ------------------------------------------------------------------
    GRAMMAIRE OBSERVEE DANS LES SOURCES (logique reprise, pas le contenu)
    ------------------------------------------------------------------
    Fichiers relus dans Minemaker0430/ExplorersOfSkyOrigins :
      ground/beach/init.lua            arrivee sur un lieu + malaise du heros
      ground/storm_cutscene_a/init.lua vision, eclairs, bascule synchronisee
      ground/chapter_card/init.lua     carton-titre en coroutines paralleles
      ground/guild_bedroom_night/...   veillee, script GBA garde en commentaire
      CharacterActions.lua             DizzyFade, ShakeHead, ScaredJump

    Ce que ces scenes ont en commun, et qu'on reprend :

    1. ON ETABLIT LE LIEU AVANT LES PERSONNAGES.
       Le son d'ambiance monte AVANT le premier mot (beach : FadeInSE puis
       60 frames d'attente puis dialogue). Le joueur entend le lieu, puis le
       voit, puis seulement on lui parle.

    2. LE DIALOGUE EST EN TROIS TEMPS.
       constat sensoriel -> reaction affective -> decision d'avancer.
       Jamais l'inverse. On ne commente pas l'enjeu avant d'avoir decrit ce
       qu'on a sous les yeux.

    3. LA CAMERA CADRE LE LIEU, PAS LES PERSONNAGES.
       Elle part sur le decor, puis redescend sur le duo au moment de la
       decision. Le mouvement accompagne le changement de sujet.

    4. LE DEPART EST UNE COROUTINE JOINTE.
       Marche, fondu et son se terminent ensemble (patron JoinCoroutines de
       storm_cutscene_a). Rien ne "coupe" : tout s'eteint en meme temps.

    ------------------------------------------------------------------
    IDENTITE PROPRE A CHAQUE CHAPITRE (regle : aucune repetition)
    ------------------------------------------------------------------
      ch8  LE SANCTUAIRE   -> l'emerveillement. Silence, lumiere, beaute.
                              Le duo parle bas. Registre : contemplation.
      ch9  LE MARAIS       -> le degout puis la peur. Odeur, vase, presence.
                              Le duo se serre. Registre : malaise physique.
      ch10 LE PIC          -> l'urgence et la rivalite. Vent, course, defi.
                              Le duo est presse. Registre : adrenaline.

    Aucune des trois n'ouvre de la meme facon, ne se termine de la meme
    facon, ni n'emploie le meme registre de langue.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Texte litteral en francais (module global appele depuis plusieurs
      grounds — MapStrings ne resoudrait pas, cf. SuaireArc.lua).
    * Aucun nom interdit. La Voix reste anonyme.
    * Tout sous pcall, sortie garantie : une scene qui casse ne doit jamais
      laisser le joueur bloque devant une entree de donjon.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'

ChapterScenes = {}

--Une replique du partenaire.
local function say(partner, emo, txt)
  if partner == nil then return end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

--Une pensee du heros.
local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

--Narration centree, sans locuteur : sert a poser le decor.
local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--------------------------------------------------------------------
-- Corps commun : arrivee devant un donjon.
--------------------------------------------------------------------
-- cfg = {
--   flag   = 'CrystalArrival',  -- champ SV.ChapterN, joue une seule fois
--   sv     = SV.Chapter8,
--   music  = 'X.ogg',
--   camera = {x, y},            -- cadrage du DECOR au lever de rideau
--   focus  = {x, y},            -- cadrage du duo au moment de decider
--   scene  = function(hero, partner) ... end,
-- }
local function Arrival(cfg)

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  if cfg.sv == nil then return false end
  if cfg.sv[cfg.flag] then return false end
  cfg.sv[cfg.flag] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    --1. Le lieu d'abord : camera sur le decor, rideau qui se leve lentement.
    if cfg.camera ~= nil then GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false) end
    GAME:FadeIn(50)
    GAME:WaitFrames(30)
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end
    GAME:WaitFrames(25)

    --2. La scene propre au chapitre.
    cfg.scene(hero, partner)

    --3. La camera redescend sur le duo : on passe du lieu a la decision.
    if cfg.focus ~= nil then
      GAME:MoveCamera(cfg.focus[1], cfg.focus[2], 60, false)
      GAME:WaitFrames(20)
    end
  end)

  if not ok then PrintInfo('[ChapterScenes] scene ecourtee : '..tostring(err)) end

  --Sortie garantie : le joueur reprend la main quoi qu'il arrive.
  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return true
end

--------------------------------------------------------------------
-- CHAPITRE 8 — Le Sanctuaire de Cristal : l'emerveillement
--------------------------------------------------------------------
-- Registre : contemplation. Ils parlent bas, comme dans une bibliotheque.
-- Le danger n'est pas evoque : c'est la beaute qui inquiete, parce qu'elle
-- est trop parfaite pour etre naturelle.
function ChapterScenes.CrystalArrival()
  return Arrival({
    sv = SV.Chapter8, flag = 'PlayedArrivalScene',
    music = 'Crystal Crossing.ogg',
    camera = {160, 96}, focus = {160, 160},
    scene = function(hero, partner)
      narrate("La cascade tombe sans un bruit.[pause=30] C'est la première chose qui cloche.")
      GAME:WaitFrames(20)
      say(partner, 'Surprised', "Écoute...[pause=25] Non. N'écoute pas.[pause=20] Il n'y a RIEN à écouter.")
      say(partner, 'Worried', "Une chute d'eau de cette taille, ça devrait couvrir nos voix.[pause=25] On s'entend chuchoter.")
      think(hero, 'Worried', "(L'eau tombe. Elle touche la pierre. Et le son ne nous parvient pas.)")
      GAME:WaitFrames(20)
      say(partner, 'Normal', "Derrière le rideau d'eau...[pause=20] tu vois cette lueur ?[pause=15] Elle bat.[pause=25] Lentement. Comme un souffle.")
      GAME:WaitFrames(15)
      narrate("Un halo bleu pâle traverse la cascade, s'éteint, revient.[pause=25] Toujours au même rythme.")
      GAME:WaitFrames(20)
      say(partner, 'Sad', "Phileas a dit que les premiers gardiens avaient écrit leur savoir ici.[pause=30] Moi je ne vois pas une bibliothèque.")
      say(partner, 'Sad', "Je vois un endroit qu'on a fermé.[pause=25] Et le silence, c'est le couvercle.")
      think(hero, 'Normal', "(Elle a raison. On ne cache pas un livre derrière une cascade.[pause=20] On cache un secret.)")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "Bon.[pause=20] On n'est pas venus admirer.[pause=25] On passe sous l'eau et on lit ce qu'ils ont laissé.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 9 — Le Marais de l'Oubli : le degout, puis la peur
--------------------------------------------------------------------
-- Registre : malaise physique. Phrases courtes, hachees. Le duo se rapproche
-- au lieu de s'ecarter. On ne montre PAS le Cercle du Suaire : on montre ce
-- qu'il laisse derriere lui. La menace est deja passee par la.
function ChapterScenes.MarshArrival()
  return Arrival({
    sv = SV.Chapter9, flag = 'PlayedArrivalScene',
    music = 'Dark Hill.ogg',
    camera = {160, 96}, focus = {160, 160},
    scene = function(hero, partner)
      narrate("L'odeur arrive avant la vue.[pause=30] Quelque chose de sucré, et de faux.")
      GAME:WaitFrames(20)
      say(partner, 'Pain', "Beurk...[pause=20] Ça sent le...[pause=25] non. Je ne veux pas trouver le mot.")
      think(hero, 'Worried', "(Des fleurs. Ça sent les fleurs.[pause=25] Beaucoup trop de fleurs, pour un marais.)")
      GAME:WaitFrames(20)
      say(partner, 'Worried', "Regarde les roseaux, sur la berge.[pause=25] Ils sont couchés.[pause=20] Tous dans le même sens.")
      say(partner, 'Worried', "Il n'y a pas de vent.[pause=30] Il n'y en a pas eu depuis ce matin.")
      GAME:WaitFrames(15)
      narrate("Quelque chose est passé là. Récemment.[pause=25] Assez lourd pour coucher les roseaux,[pause=15] assez léger pour ne rien casser.")
      GAME:WaitFrames(20)
      -- Le partenaire se rapproche : geste, pas mot. Sky fait beaucoup ca.
      pcall(function()
        if partner ~= nil then
          GROUND:MoveInDirection(partner, Direction.Right, 12, false, 1)
          GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
        end
      end)
      GAME:WaitFrames(15)
      say(partner, 'Sad', "...Je peux rester près de toi ?[pause=30] C'est bête, je sais.")
      think(hero, 'Normal', "(Ce n'est pas bête.[pause=20] Je l'allais le demander.)")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "Bon.[pause=20] Le Cœur est au fond, et il se noie.[pause=25] On n'a pas le luxe d'avoir peur.")
      say(partner, 'Worried', "...On l'aura quand même.[pause=25] Mais on avancera avec.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 10 — Le Pic Celeste : l'urgence et la menace au-dessus
--------------------------------------------------------------------
-- Registre : adrenaline. Phrases lancees, coupees. Pas de contemplation :
-- trois dragons tournent deja au-dessus de la voie directe et le duo doit
-- decider vite. On les voit sans les entendre : c'est plus inquietant.
-- (Recale le 2026-08-04 : l'etage-arene portait une « Escouade Fulgur »
-- electrique, remplacee par le trio Dracolosse/Drattak/Altaria.)
function ChapterScenes.PeakArrival()
  return Arrival({
    sv = SV.Chapter10, flag = 'PlayedArrivalScene',
    music = 'Sky Peak Prairie.ogg',
    --Recadrage 2026-08-02 : le ground a ete refait a partir de
    --l'illustration fournie (552x360 au lieu de 240x320). L'ancien
    --cadrage (160,80) tombait dans la falaise, hors de la bande de
    --sable praticable (y 112..240 px). On ouvre desormais sur la
    --gorge et sa grotte, puis on redescend sur le duo.
    camera = {344, 136}, focus = {272, 184},
    scene = function(hero, partner)
      --SE5_Wind_Background : bandeau de 5120x256 (frames 256x256, 20 images),
      --concu pour defiler horizontalement. Il dormait inexploite dans
      --Content/BG. Ici il EST le vent : rafales qui traversent l'ecran de
      --droite a gauche pendant toute la scene.
      pcall(function()
        BossFX.Overlay('SE5_Wind_Background', 0, 0, 20, 600, 60, DrawLayer.Top, -180, 0)
      end)
      narrate("Le vent frappe de côté.[pause=25] Il faut se pencher dedans pour tenir debout.")
      GAME:WaitFrames(15)
      say(partner, 'Surprised', "Là-haut ![pause=15] Au-dessus de la deuxième corniche ![pause=20] Trois ombres qui tournent !")
      GAME:WaitFrames(10)
      -- Le vent porte une voix : on ne voit personne, on entend tout.
      narrate("Le vent apporte un cri long,[pause=20] très haut.[pause=25] Puis le silence retombe.")
      GAME:WaitFrames(15)
      think(hero, 'Shock', "(Ils ne se posent pas.[pause=25] Ils tournent au-dessus de la voie, comme s'ils gardaient quelque chose.)")
      GAME:WaitFrames(15)
      say(partner, 'Worried', "Des dragons.[pause=25] À cette altitude,[pause=20] ça ne peut être qu'eux.")
      say(partner, 'Worried', "Et ils ne s'éloignent pas.[pause=25] Ils restent exactement au même endroit.[pause=20] Ils attendent.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Quelque chose leur a demandé de tenir ce passage.[pause=30] Et ce quelque chose est encore plus haut.)")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "On ne passera pas en force par la voie directe.[pause=25] Alors on ne prend pas la voie directe.")
      say(partner, 'Happy', "La voie des contreforts.[pause=20] Plus longue, plus dure,[pause=15] et personne ne la prend jamais.")
      think(hero, 'Determined', "(...Ce qui veut dire qu'ils ne nous verront pas venir.)")
      GAME:WaitFrames(15)
      say(partner, 'Determined', "Exactement.[pause=25] Accroche-toi.[pause=20] On part maintenant.")

      --ENRICHISSEMENT 2026-08-02 — le decor est desormais l'illustration
      --fournie (552x360). Jusqu'ici la scene etait entierement parlee :
      --deux personnages plantes sur place pendant onze repliques. On lui
      --donne son mouvement, cale sur la geometrie reelle du ground.
      --Positions verifiees libres et accessibles depuis Main_Entrance_Marker.
      pcall(function()
        --Le duo quitte le bas de la gorge et remonte vers l'escalier de
        --pierre qui mene a la grotte. Ils marchent en parlant : la
        --decision est deja prise, on la voit s'executer.
        local m1 = TASK:BranchCoroutine(function()
          GeneralFunctions.EightWayMove(hero, 288, 200, false, 1)
        end)
        local m2 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(10)
          GeneralFunctions.EightWayMove(partner, 272, 208, false, 1)
        end)
        local mc = TASK:BranchCoroutine(function()
          GAME:MoveCamera(280, 200, 90, false)
        end)
        TASK:JoinCoroutines({m1, m2, mc})
        GAME:WaitFrames(15)

        --Le vent redouble au pied de la paroi : on le fait sentir avant
        --la derniere replique, plutot que de le dire.
        SOUND:PlayBattleSE('DUN_Wind')
        pcall(function() BossFX.ShakeScreen(2, 25) end)
        GAME:WaitFrames(20)

        say(partner, 'Worried', "Le vent tourne dans la gorge.[pause=20] Il descend, maintenant.")
        GAME:WaitFrames(12)
        think(hero, 'Determined', "(Il descend parce que quelque chose, la-haut, le pousse vers nous.)")
        GAME:WaitFrames(15)

        --Derniers pas jusqu'au pied de l'escalier, face au nord.
        local s1 = TASK:BranchCoroutine(function()
          GeneralFunctions.EightWayMove(hero, 344, 176, false, 1)
          GROUND:CharAnimateTurnTo(hero, Direction.Up, 4)
        end)
        local s2 = TASK:BranchCoroutine(function()
          GAME:WaitFrames(8)
          GeneralFunctions.EightWayMove(partner, 344, 192, false, 1)
          GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
        end)
        local sc = TASK:BranchCoroutine(function()
          GAME:MoveCamera(344, 160, 80, false)
        end)
        TASK:JoinCoroutines({s1, s2, sc})
        GAME:WaitFrames(20)

        narrate("L'escalier taille dans la roche monte vers une ouverture noire.[pause=25] Aucun bruit n'en sort.")
        GAME:WaitFrames(15)
        say(partner, 'Determined', "C'est par la.[pause=20] Apres toi.")
      end)
    end,
  })
end


--------------------------------------------------------------------
-- CHAPITRE 10 — LA TOUR SE DEVOILE
--------------------------------------------------------------------
-- Beat classique de Donjon Mystere : le duo leve les yeux, et le jeu
-- montre PLEIN ECRAN ce qu'il voit. Ici la Tour Celeste entiere, du pied
-- au sommet, avec un travelling ascendant.
--
-- COMMENT C'EST FAIT, ET POURQUOI AINSI
-- RogueEssence n'a pas de « cinematique video ». Le seul moyen d'occuper
-- tout l'ecran est un FiniteOverlayEmitter alimente par un BGAnimData,
-- c'est-a-dire une image de Content/BG. On a donc converti
-- Sky_Tower_cutscene_RTRB.png (288x216, Rescue Team) au format .dir du
-- moteur — entete 8 octets + PNG + 16 octets (largeur, hauteur,
-- frameTime, frames), format releve sur les 22 BG existants — et
-- redimensionne en 320x240, la taille de tous les BG plein cadre du mod
-- (Chapter_1..10). Outil : tools/png2bg.py.
--
-- LE TRAVELLING. L'overlay ne « scrolle » pas tout seul : son parametre
-- Movement fait defiler la nappe. On la fait descendre (moveY positif),
-- ce qui donne a l'oeil l'impression que le REGARD monte. C'est le meme
-- procede que le vent de PeakArrival (SE5_Wind_Background, moveX -180),
-- deja valide en jeu.
--
-- LA MUSIQUE. « Sky Tower.ogg » demarre AVEC l'image et non avant : le
-- theme du donjon est la recompense du plan, pas son accompagnement.
--
-- Appelee par sky_tower_entrance juste avant l'entree du donjon.
-- Flag propre, elle ne se joue qu'une fois.
--------------------------------------------------------------------
function ChapterScenes.PeakTowerReveal()
  if SV.Chapter10 == nil then return false end
  if SV.Chapter10.PlayedTowerReveal then return false end
  SV.Chapter10.PlayedTowerReveal = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    -- 1. Ils s'arretent. Le partenaire leve la tete le premier.
    pcall(function()
      GROUND:CharAnimateTurnTo(partner, Direction.Up, 6)
      GAME:WaitFrames(9)
      GROUND:CharAnimateTurnTo(hero, Direction.Up, 6)
    end)
    GAME:WaitFrames(24)
    say(partner, 'Surprised', "Attends.[pause=30] Leve les yeux.")
    GAME:WaitFrames(20)

    -- 2. LE PLAN. Silence complet, puis l'image monte.
    pcall(function() SOUND:FadeOutBGM(30) end)
    GAME:WaitFrames(35)
    pcall(function() GAME:FadeOut(false, 30) end)
    GAME:WaitFrames(20)

    -- L'overlay couvre l'ecran. TotalTime long : il tient pendant tout
    -- l'echange. Movement vertical lent = le regard qui remonte la tour.
    pcall(function()
      BossFX.Overlay('Sky_Tower_Reveal', 0, 0, 40, 900, 60, DrawLayer.Top, 0, 22)
    end)
    pcall(function() SOUND:PlayBGM('Sky Tower.ogg', true) end)
    GAME:FadeIn(60)
    GAME:WaitFrames(50)

    -- 3. Les deux commentent, chacun son portrait, pendant que l'image
    --    continue de defiler. Le heros pense, il ne parle jamais tout haut.
    narrate("Une colonne de nuages tordus monte droit dans le ciel.[pause=30] On n'en voit pas le sommet.")
    GAME:WaitFrames(30)
    say(partner, 'Shock', "C'est... c'est ca, la Tour Celeste ?[pause=30] Mais elle n'a pas de fin !")
    GAME:WaitFrames(25)
    think(hero, 'Surprised', "(Elle ne s'appuie sur rien.[pause=30] Elle tient debout toute seule, au milieu du vide.)")
    GAME:WaitFrames(30)
    say(partner, 'Worried', "Les anciens disaient qu'elle touchait le toit du monde.[pause=30] Je croyais qu'ils exageraient.")
    GAME:WaitFrames(25)
    think(hero, 'Worried', "(Ils n'exageraient pas.[pause=30] Ils n'avaient simplement pas de mot pour ca.)")
    GAME:WaitFrames(30)
    say(partner, 'Determined', "Et il faut monter jusqu'en haut.[pause=35] Jusqu'a lui.")
    GAME:WaitFrames(35)

    -- 4. Retour au sol. L'image se retire, le duo est toujours la, tete
    --    levee — et c'est CE plan qui ferme la scene.
    pcall(function() GAME:FadeOut(false, 50) end)
    GAME:WaitFrames(60)
    GAME:FadeIn(50)
    GAME:WaitFrames(25)
    narrate("Le vent redescend.[pause=25] Devant eux, le premier escalier attend.")
    GAME:WaitFrames(20)
  end)

  if not ok then
    PrintInfo('[ChapterScenes.PeakTowerReveal] scene ecourtee : ' .. tostring(err))
  end

  -- HORS pcall : la main est rendue quoi qu'il arrive.
  pcall(function() UI:ResetSpeaker() end)
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    end
  end)
  pcall(function() GAME:CutsceneMode(false) end)
  return true
end

return ChapterScenes
