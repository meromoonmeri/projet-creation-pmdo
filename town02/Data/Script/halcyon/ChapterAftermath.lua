--[[
    ChapterAftermath.lua

    SCENES D'APRES-BOSS DES CHAPITRES 8, 9 ET 10
    ================================================================
    Trou le plus grave restant apres l'audit de densite : on battait Diancie,
    Laggron ou Lugia et... rien. `SV.ChapterN.DefeatedX = true` puis fin de
    journee. Aucune respiration, aucune consequence montree, aucune
    recompense narrative. Les trois combats les plus importants du jeu se
    terminaient plus sechement qu'un donjon secondaire.

    ------------------------------------------------------------------
    CE QUE LES SOURCES ENSEIGNENT SUR L'APRES-BOSS
    ------------------------------------------------------------------
    Analyse de pret/pmd-red (data/scripts/intro.inc) et des scenes de EoSO
    deja relues. Deux principes structurels, indifferents au contenu :

    1. LE FIL D'EXECUTION PARALLELE. Le script GBA lance plusieurs threads
       qui se synchronisent sur des DRAPEAUX (setFlag 5 / waitFlag 5) : un
       thread anime la camera, un autre deplace un acteur, un troisieme
       enchaine les animations. Personne n'attend inutilement.
       -> Transpose ici en BranchCoroutine + JoinCoroutines : le boss
          s'effondre PENDANT que la camera recule et que la musique tombe.
          Trois actions simultanees, pas trois attentes successives.

    2. LA CASCADE D'ANIMATIONS SUR UN SEUL ACTEUR. gUnknown_826EE1C enchaine
       setAnimation 0xE, 0xF, 0x10, 0x11... chaque etape separee par un
       deplacement. L'acteur ne joue pas UNE animation : il en traverse une
       SUITE, ce qui donne la sensation d'un corps qui reagit dans la duree.
       -> Transpose ici : le boss vaincu passe par Hurt -> Pose -> Idle avec
          des temps morts entre, au lieu de disparaitre d'un coup.

    ------------------------------------------------------------------
    ROLE NARRATIF DE CHAQUE SCENE (aucune ne se ressemble)
    ------------------------------------------------------------------
      ch8  LE DOUTE SEMÉ    Diancie n'est pas vaincue : elle CEDE, et sa
                            reddition pose la premiere question genante.
                            Registre : trouble. On repart avec un malaise.
      ch9  LA CONFIRMATION  Le Cercle du Suaire ne se bat pas : il CONSTATE.
                            Sa phrase est la piece qui manquait au puzzle.
                            Registre : effroi froid. On repart avec une peur.
      ch10 LE VERTIGE       Rayquaza ne juge plus : il S'EXCUSE. Le gardien le
                            plus ancien du monde demande pardon au heros.
                            Registre : renversement. On repart sans repere.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Aucun nom interdit. La Voix reste anonyme (\uE040).
    * Le twist des Coeurs-prison est APPROCHE trois fois, jamais dit.
      C'est la fonction dramatique de ces trois scenes : elles resserrent
      l'etau sans livrer la reponse, qui appartient a l'arc 6.
    * Texte litteral (module global, cf. SuaireArc.lua).
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.EngineKit'

ChapterAftermath = {}

--Face a face natif (UI:SetSpeakerReverse, cf. EngineKit.lua) : sans lui,
--les deux interlocuteurs regardent du meme cote et ne se font jamais face.
--Convention New Era : allies portrait retourne, PNJ et boss a l'endroit.
local function say(who, emo, txt)
  if who == nil then return end
  local ally = (who == CH('PLAYER') or who == CH('Teammate1'))
  EngineKit.Say(who, emo or 'Normal', txt, ally)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--La Voix : anonyme, toujours.
local function voice(txt)
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(12)
end

--Chute d'un boss, en cascade d'animations (principe 2 ci-dessus).
--Le corps traverse plusieurs etats au lieu de disparaitre d'un bloc.
local function collapse(boss)
  if boss == nil then return end
  pcall(function()
    GROUND:CharSetAnim(boss, "Hurt", true)
    GAME:WaitFrames(30)
    BossFX.ShakeScreen(4, 20)
    GAME:WaitFrames(20)
    GROUND:CharSetAnim(boss, "EventSleep", true)
    GAME:WaitFrames(40)
  end)
end

--Corps commun.
local function Aftermath(cfg)
  if cfg.sv == nil then return false end
  if cfg.sv[cfg.flag] then return false end
  cfg.sv[cfg.flag] = true

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    if cfg.hero ~= nil then GROUND:TeleportTo(hero, cfg.hero[1], cfg.hero[2], Direction.Up) end
    if partner ~= nil and cfg.partner ~= nil then
      GROUND:TeleportTo(partner, cfg.partner[1], cfg.partner[2], Direction.Up)
    end
    if cfg.camera ~= nil then GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false) end

    GAME:WaitFrames(40)
    GAME:FadeIn(50)
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, false) end
    GAME:WaitFrames(25)

    cfg.scene(hero, partner)
  end)

  if not ok then PrintInfo('[ChapterAftermath] scene ecourtee : '..tostring(err)) end

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
-- CHAPITRE 8 — Diancie cède. Le doute est semé.
--------------------------------------------------------------------
-- Elle n'est pas battue : elle s'arrete de se battre. Nuance capitale.
-- Sa question finale est la premiere fissure dans la certitude du duo.
function ChapterAftermath.CrystalVictory()
  return Aftermath({
    sv = SV.Chapter8, flag = 'PlayedVictoryScene',
    music = 'Crystal Crossing.ogg',
    hero = {172, 180}, partner = {140, 180}, camera = {156, 150},
    scene = function(hero, partner)
      local diancie = CharacterEssentials.MakeCharactersFromList({{'Diancie', 156, 120, Direction.Down}})
      collapse(diancie)

      narrate("Elle ne tombe pas.[pause=25] Elle s'agenouille,[pause=20] et referme ses mains sur rien.")
      GAME:WaitFrames(15)
      say(diancie, 'Sad', "Assez.[pause=25] Je ne me bats plus.")
      say(partner, 'Surprised', "Quoi ?[pause=20] Mais...[pause=15] on n'a même pas—")
      say(diancie, 'Normal', "Vous avez gagné il y a longtemps.[pause=30] Le jour où vous avez décidé de venir.")
      GAME:WaitFrames(20)
      pcall(function() GROUND:CharSetAnim(diancie, "Idle", true) end)
      say(diancie, 'Normal', "Prenez le Fragment.[pause=25] Il vous appartient déjà,[pause=15] puisque vous êtes capables de le porter.")
      GAME:WaitFrames(15)
      narrate("Un éclat de cristal se détache de la voûte et descend, lentement, jusqu'aux pattes du héros.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Elle ne le donne pas.[pause=25] Elle s'en débarrasse.)")
      GAME:WaitFrames(15)
      say(partner, 'Worried', "Pourquoi vous nous laissez faire ?[pause=25] Vous êtes la gardienne. Gardez-le.")
      GAME:WaitFrames(20)
      say(diancie, 'Sad', "Gardienne.[pause=30] Oui.[pause=25] C'est le mot qu'on m'a donné.")
      say(diancie, 'Sad', "Mais dites-moi une chose, avant de partir.")
      GAME:WaitFrames(15)
      -- La question qui reste dans la tete du joueur.
      say(diancie, 'Normal', "Un gardien protège ce qui est fragile.[pause=30] Alors pourquoi les premiers ont-ils bâti des MURS autour de leur lumière ?")
      GAME:WaitFrames(25)
      say(partner, 'Sad', "...Je ne sais pas.")
      say(diancie, 'Normal', "Moi non plus.[pause=30] Et j'ai eu mille ans pour y réfléchir.")
      GAME:WaitFrames(20)
      narrate("Les cristaux s'éteignent un par un derrière elle.[pause=25] Le silence, cette fois, n'a plus rien de sacré.")
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 9 — Le Cercle du Suaire constate. La peur s'installe.
--------------------------------------------------------------------
-- Ils n'attaquent pas, ne menacent pas. Ils commentent. C'est bien pire.
-- Leur phrase relie enfin les deux fils : les Coeurs et le sceau.
-- MISE EN SCENE (2026-08-02).
-- Emotion visee : L'EFFROI FROID. Pas la peur d'une menace — la peur de
-- comprendre qu'on avait tort. Le Suaire ne bouge pas, ne crie pas, ne se
-- bat pas : c'est SON IMMOBILITE qui fait peur, opposee a l'agitation du
-- partenaire. Zero mouvement gratuit — le Suaire ne se deplace JAMAIS.
--
-- Trois leviers seulement :
--   1. la camera qui RECULE (on decouvre qu'il etait la depuis le debut)
--   2. l'orientation de chacun depuis SA position reelle
--   3. le silence pose la ou la question reste sans reponse
--
-- Test « sans le texte » : camera qui recule sur trois silhouettes
-- immobiles -> le duo se retourne en sursaut -> le partenaire avance,
-- gesticule, recule -> le heros ne bouge pas -> ils s'effacent sans un
-- geste. La gravite se lit sans une seule replique.
--
-- Positions verifiees sur la grille (30x40 cellules de 8 px) :
--   hero (172,180) libre | partner (140,184) libre — (140,180) etait BLOQUE
--   boss (156,120) | Suaire (156,96) | Linceul (124,104) | Litanie (188,104)
function ChapterAftermath.MarshVictory()
  return Aftermath({
    sv = SV.Chapter9, flag = 'PlayedVictoryScene',
    music = 'Dark Hill.ogg',
    -- (140,180) tombait sur une case bloquee : le partenaire etait
    -- encastre dans le decor depuis l'ecriture de la scene.
    hero = {172, 180}, partner = {140, 184}, camera = {156, 150},
    scene = function(hero, partner)
      local boss = CharacterEssentials.MakeCharactersFromList({{'Swampert', 156, 120, Direction.Down}})

      -- Chute et recul de camera ENSEMBLE (principe 1 du module) : le corps
      -- s'affaisse pendant que le cadre s'ouvre.
      local c1 = TASK:BranchCoroutine(function() collapse(boss) end)
      local c2 = TASK:BranchCoroutine(function() GAME:MoveCamera(156, 156, 90, false) end)
      TASK:JoinCoroutines({c1, c2})

      narrate("La bête s'affaisse dans la vase.[pause=25] L'eau se referme sur elle sans un bruit.")
      GAME:WaitFrames(20)

      -- Le partenaire se tourne vers le heros : il est le seul a bouger,
      -- c'est lui qui porte la joie.
      pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
      say(partner, 'Happy', "On l'a fait ![pause=20] Le Cœur va pouvoir respirer—")

      -- RUPTURE : la phrase est coupee net, le son s'arrete avant l'image.
      pcall(function() SOUND:FadeOutBGM(20) end)
      pcall(function() BossFX.ShakeScreen(3, 16) end)
      narrate("La brume, derrière eux, cesse de bouger.")
      GAME:WaitFrames(25)

      -- Les trois apparaissent : le meneur au centre, les deux autres en
      -- retrait. Une silhouette isolee ferait moins peur que trois.
      local suaire  = CharacterEssentials.MakeCharactersFromList({{'Suaire_Banette', 156, 96, Direction.Down}})
      local linceul = CharacterEssentials.MakeCharactersFromList({{'Suaire_Gengar', 124, 104, Direction.DownRight}})
      local litanie = CharacterEssentials.MakeCharactersFromList({{'Suaire_Noivern', 188, 104, Direction.DownLeft}})
      pcall(function()
        GROUND:Hide('Suaire_Banette'); GROUND:Hide('Suaire_Gengar'); GROUND:Hide('Suaire_Noivern')
      end)

      -- La camera RECULE pour les faire entrer dans le cadre : le joueur
      -- decouvre qu'ils etaient dans son dos. Seul mouvement ample de la
      -- scene, et il porte toute la revelation.
      local cam = TASK:BranchCoroutine(function() GAME:MoveCamera(156, 132, 70, false) end)
      local rev = TASK:BranchCoroutine(function()
        GAME:WaitFrames(18)
        pcall(function() BossFX.Flash(156, 96, 2, 4, 18); GROUND:Unhide('Suaire_Banette') end)
        GAME:WaitFrames(10)
        pcall(function() GROUND:Unhide('Suaire_Gengar') end)
        GAME:WaitFrames(7)
        pcall(function() GROUND:Unhide('Suaire_Noivern') end)
      end)
      TASK:JoinCoroutines({cam, rev})

      -- Le duo se retourne, chacun depuis SA position : le heros est a
      -- droite, le partenaire a gauche — ils ne pivotent pas pareil.
      pcall(function()
        GROUND:CharTurnToCharAnimated(hero, suaire, 6)
        GAME:WaitFrames(5)
        GROUND:CharTurnToCharAnimated(partner, suaire, 3)
        GROUND:CharSetEmote(partner, "exclaim", 1)
      end)
      GAME:WaitFrames(22)

      say(suaire, 'Normal', "Trois.")
      GAME:WaitFrames(18)

      -- Le partenaire fait un pas EN AVANT : il proteste, il ne recule pas.
      -- x=144 et non 140 : la colonne x=140 est un mur de y=144 a y=176
      -- (verifie sur la grille). Le pas partait dans le decor.
      pcall(function() GROUND:MoveToPosition(partner, 144, 168, false, 1) end)
      say(partner, 'Surprised', "—Qui...[pause=20] Depuis quand vous êtes là ?!")

      say(suaire, 'Normal', "Depuis le début.[pause=25] Nous ne sommes pas venus vous arrêter.")
      GAME:WaitFrames(15)
      say(suaire, 'Normal', "Nous sommes venus COMPTER.")

      -- SILENCE : le mot reste seul a l'ecran avant que le heros comprenne.
      -- C'est le temps de la scene, pas un flottement.
      GAME:WaitFrames(45)
      think(hero, 'Worried', "(Compter quoi ?[pause=25] ...Les Cœurs. Il compte les Cœurs.)")
      GAME:WaitFrames(15)

      -- Il explose : deuxieme pas en avant, emote de colere.
      pcall(function()
        GROUND:MoveToPosition(partner, 144, 152, false, 1)
        GROUND:CharSetEmote(partner, "angry", 1)
      end)
      say(partner, 'Angry', "On les SAUVE ![pause=20] On les répare ![pause=25] Vous devriez nous remercier !")
      GAME:WaitFrames(20)

      -- Le Suaire n'a pas bouge d'un pixel depuis son apparition. C'est le
      -- coeur de l'effet.
      say(suaire, 'Sad', "Oui.[pause=30] C'est bien le problème.")
      GAME:WaitFrames(28)

      -- LA phrase-pivot : resserrement lent de la camera sur lui seul, le
      -- monde retrecit a ce qu'il est en train de dire.
      local zoom = TASK:BranchCoroutine(function() GAME:MoveCamera(156, 112, 100, false) end)
      local dire = TASK:BranchCoroutine(function()
        GAME:WaitFrames(12)
        say(suaire, 'Normal', "Chaque Cœur que vous ranimez brille un peu plus fort.[pause=30] Et chaque fois qu'un Cœur brille,[pause=20] une paroi s'amincit.")
      end)
      TASK:JoinCoroutines({zoom, dire})
      GAME:WaitFrames(25)

      -- La question du partenaire. Cette fois il RECULE d'un pas.
      pcall(function() GROUND:MoveToPosition(partner, 144, 168, false, 1) end)
      say(partner, 'Worried', "Une paroi ?[pause=25] Une paroi de QUOI ?")

      -- LE SILENCE QUI REFUSE. Le Suaire ne repond pas, et ce refus est
      -- JOUE : les deux autres se tournent vers lui, il ne bronche pas.
      -- Sans ce temps, la question passait inapercue.
      pcall(function()
        GROUND:CharTurnToCharAnimated(linceul, suaire, 5)
        GAME:WaitFrames(6)
        GROUND:CharTurnToCharAnimated(litanie, suaire, 5)
      end)
      GAME:WaitFrames(50)

      say(suaire, 'Sad', "Continuez.[pause=30] Vous comprendrez au dernier.")
      GAME:WaitFrames(20)

      -- Ils s'effacent dans l'ordre inverse de leur apparition. Aucun ne
      -- fait un geste de depart : ils cessent d'etre la.
      pcall(function()
        GROUND:Hide('Suaire_Noivern'); GAME:WaitFrames(8)
        GROUND:Hide('Suaire_Gengar');  GAME:WaitFrames(8)
        BossFX.Flash(156, 96, 6, 2, 26)
        GROUND:Hide('Suaire_Banette')
      end)
      narrate("Il ne s'en va pas.[pause=25] Il cesse simplement d'être là,[pause=20] comme une buée qu'on essuie.")
      GAME:WaitFrames(25)

      -- Le partenaire cherche le regard du heros. Le heros, lui, fixe
      -- toujours l'endroit vide : il n'a pas quitte le Suaire des yeux.
      pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
      GAME:WaitFrames(30)
      think(hero, 'Sad', "(Il n'a pas menti une seule fois.[pause=30] C'est ça qui me terrifie.)")
      GAME:WaitFrames(20)
    end,
  })
end

--------------------------------------------------------------------
-- CHAPITRE 10 — Rayquaza s'excuse. Tous les reperes tombent.
--------------------------------------------------------------------
-- Le renversement : le plus ancien gardien du monde demande pardon a deux
-- gamins. S'il s'excuse, c'est qu'il a fait quelque chose. Fin de l'arc
-- sur une question, pas sur une victoire.
-- MISE EN SCENE (2026-08-02).
-- Emotion visee : LE VERTIGE. Le plus ancien gardien du monde demande
-- pardon a deux gamins — le joueur perd son dernier repere d'autorite.
--
-- CE QUE CETTE SCENE EST, NARRATIVEMENT
-- Rayquaza vient d'etre vaincu et RESTE : c'est ici qu'il renseigne le heros
-- sur la marche a suivre. La scene est longue et parlee, c'est voulu.
-- Elle s'acheve sur son epuisement — ce qui rend possible, juste apres,
-- l'arrivee de Rayquaza face a la meteorite (autel_celeste). Rayquaza ne
-- PEUT plus rien : le climax qui suit n'est donc pas un deus ex machina,
-- il comble une incapacite etablie trente secondes plus tot.
--
-- Zero mouvement gratuit. Rayquaza est a terre : il ne se deplace pas, il
-- se REDRESSE par paliers, puis retombe. Trois etats de corps :
--   effondre -> assis (il parle) -> tente de se lever (il echoue)
--
-- Test « sans le texte » : un colosse a terre, deux enfants minuscules
-- face a lui, la camera qui descend a leur hauteur, le colosse qui baisse
-- la tete, puis qui essaie de se relever et n'y arrive pas.
--
-- Positions verifiees sur la grille (69x75 cellules de 8 px) :
--   hero (296,296) | partner (256,296) | Rayquaza (272,232) | tous libres
function ChapterAftermath.PeakVictory()
  return Aftermath({
    -- Flag PROPRE a l'acte 1. Les deux actes du climax partageaient
    -- 'PlayedVictoryScene' : PeakVictory le posait, ce qui rendait la
    -- condition d'entree de l'acte 2 definitivement fausse. C'est le
    -- coeur du blocage corrige le 2026-08-02. Le nom du flag reste
    -- 'PlayedLugiaTalk' : le renommer casserait les sauvegardes en cours,
    -- et il est lu tel quel par tour_ciel_sommet:91.
    sv = SV.Chapter10, flag = 'PlayedLugiaTalk',
    music = 'Rainbow Peak.ogg',
    hero = {296, 296}, partner = {256, 296}, camera = {276, 264},
    scene = function(hero, partner)
      -- ================================================================
      -- REECRITURE 2026-08-04 — LUGIA -> RAYQUAZA
      -- ================================================================
      -- Cette scene etait ecrite pour Lugia, gardien reclus qui avait
      -- « passe mille ans a se taire ». Or tout le climax annonce
      -- RAYQUAZA : il fend les nuages a l'acte 0, et c'est lui qui
      -- pulverise la meteorite a l'acte 2. On affrontait Lugia au milieu
      -- de deux scenes de Rayquaza (l'arene sky_tower_boss portait
      -- encore lugia n35, corrige le meme jour).
      --
      -- Le texte n'est PAS transpose mot pour mot : le registre de Lugia
      -- (le reclus qui s'excuse) ne colle pas au dragon qui vient de
      -- descendre du ciel pour vous juger. Reecrit sur la specification
      -- du projet, docs/CINEMATIQUE_CLIMAX_CH10_RAYQUAZA.md :
      --
      --   « Il y a 30 ans, le monde fut sauve de la collision avec
      --     l'Etoile de la Destruction grace a un humain transforme en
      --     Pokemon et son partenaire, qui braverent la Tour Celeste
      --     pour convaincre Rayquaza de pulveriser le corps celeste. »
      --
      -- Les beats STRUCTURELS sont conserves un pour un, parce que ce
      -- sont eux qui arment l'acte 2 :
      --   1. le boss s'effondre, le vent tombe          (silence)
      --   2. il reconnait quelque chose dans le heros   (les 30 ans)
      --   3. le partenaire fait le lien                 (la legende)
      --   4. il donne une consigne, une seule           (« sous l'ecaille »)
      --   5. La Voix intervient devant temoin           (elle a peur)
      --   6. il tente de se relever et n'y arrive pas   (il ne PEUT plus)
      --
      -- Le beat 6 est indispensable : c'est lui qui rend necessaire
      -- l'effort surhumain de l'acte 2. Rayquaza ne monte pas detruire
      -- la meteorite parce que c'est facile, mais parce qu'il est le
      -- seul a pouvoir le faire — et il est deja a bout.
      local rayquaza = CharacterEssentials.MakeCharactersFromList({{'Rayquaza', 272, 232, Direction.Down}})

      -- Il tombe pendant que le vent s'arrete : le silence arrive AVANT
      -- l'immobilite, on l'entend cesser.
      local c1 = TASK:BranchCoroutine(function() collapse(rayquaza) end)
      local c2 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(20)
        pcall(function() GROUND:RemoveMapStatus("blowing_wind_fast") end)
        pcall(function() SOUND:FadeOutBGM(50) end)
      end)
      TASK:JoinCoroutines({c1, c2})

      narrate("Le dragon retombe sur l'anneau de pierre.[pause=30] Le vent tombe avec lui,[pause=20] et le sommet devient parfaitement silencieux.")
      GAME:WaitFrames(30)

      -- Premier palier : il redresse la tete. Le duo se tourne vers lui,
      -- chacun depuis sa place (le heros a droite, le partenaire a gauche).
      pcall(function()
        GROUND:CharSetAnim(rayquaza, "Idle", true)
        GROUND:CharTurnToCharAnimated(hero, rayquaza, 5)
        GAME:WaitFrames(6)
        GROUND:CharTurnToCharAnimated(partner, rayquaza, 5)
      end)
      GAME:WaitFrames(20)

      say(rayquaza, 'Normal', "Assez.[pause=25] Vous tenez encore debout.[pause=20] C'est tout ce que je voulais savoir.")
      say(partner, 'Surprised', "Vous nous avez...[pause=20] mis a l'epreuve ?[pause=25] On a failli y rester !")
      say(rayquaza, 'Normal', "J'ai juge.[pause=30] Je juge tout ce qui monte jusqu'ici.")

      -- Le mot tombe dans le vide. On laisse le joueur l'encaisser.
      GAME:WaitFrames(40)
      think(hero, 'Worried', "(Il ne nous a pas attaques par colere.[pause=25] Il verifiait quelque chose.)")
      GAME:WaitFrames(20)

      -- LE BEAT DES TRENTE ANS. C'est le coeur de la scene : il ne
      -- reconnait pas le heros, il reconnait ce qu'il PORTE.
      pcall(function() GROUND:CharTurnToCharAnimated(rayquaza, hero, 5) end)
      GAME:WaitFrames(18)
      say(rayquaza, 'Surprised', "Cette lueur, dans tes yeux.[pause=30] Je l'ai deja vue.[pause=25] Exactement la meme.")
      GAME:WaitFrames(25)
      say(rayquaza, 'Normal', "Il y a trente ans,[pause=20] deux voyageurs se sont tenus ou vous etes.[pause=25] Un humain qui n'avait plus de corps d'humain,[pause=20] et celui qui ne l'a jamais laisse seul.")
      GAME:WaitFrames(20)

      -- Le partenaire fait le lien : il avance d'un pas.
      pcall(function() GROUND:MoveToPosition(partner, 260, 280, false, 1) end)
      say(partner, 'Shock', "L'equipe de la vieille catastrophe...[pause=25] Celle des contes ?[pause=20] On nous la racontait pour nous endormir !")
      say(rayquaza, 'Normal', "Ils etaient reels.[pause=30] Ils m'ont affronte ici meme,[pause=20] puis ils m'ont demande d'abattre l'etoile qui tombait.")
      GAME:WaitFrames(25)
      say(rayquaza, 'Sad', "Je l'ai fait.[pause=30] Et j'ai cru que c'etait fini.")
      GAME:WaitFrames(25)

      -- Il detourne le regard vers le vide : l'aveu qui vient lui coute.
      pcall(function() GROUND:CharAnimateTurnTo(rayquaza, Direction.DownLeft, 6) end)
      GAME:WaitFrames(18)
      say(rayquaza, 'Normal', "Trente ans que je surveille ce ciel sans rien voir venir.[pause=30] Et depuis quelques lunes,[pause=20] l'air ne repond plus comme avant.")
      GAME:WaitFrames(20)
      think(hero, 'Surprised', "(Il ne gardait pas un sommet.[pause=30] Il montait la garde. Depuis trente ans,[pause=20] contre quelque chose qu'il croyait mort.)")
      GAME:WaitFrames(25)

      -- Il revient sur eux pour la partie utile : ce qu'il PEUT donner.
      pcall(function() GROUND:CharTurnToCharAnimated(rayquaza, hero, 5) end)
      GAME:WaitFrames(15)
      say(rayquaza, 'Sad', "Je ne peux pas vous dire ce qui se prepare.[pause=30] Pas par interdit —[pause=20] je ne le sais pas non plus.")
      GAME:WaitFrames(15)
      say(rayquaza, 'Normal', "Alors je vous donne la seule chose que j'ai.[pause=30] Trois mots.")

      -- LA consigne. Resserrement lent, et silence avant de la dire :
      -- c'est l'information que le joueur doit retenir du chapitre.
      local zoom = TASK:BranchCoroutine(function() GAME:MoveCamera(276, 248, 90, false) end)
      local dire = TASK:BranchCoroutine(function()
        GAME:WaitFrames(35)
        say(rayquaza, 'Determined', "Cherchez sous l'ecaille.")
      end)
      TASK:JoinCoroutines({zoom, dire})
      GAME:WaitFrames(30)

      -- La Voix intervient devant temoin pour la premiere fois. Rayquaza
      -- ne reagit pas : elle ne s'adresse qu'au heros.
      voice("...Il en a trop dit.")
      GAME:WaitFrames(20)

      -- Le partenaire voit le heros palir, et se tourne vers LUI, pas vers
      -- Rayquaza : il a compris ou est le vrai probleme.
      pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
      say(partner, 'Worried', "Tu as encore pali.[pause=25] C'etait elle, hein ?")
      GAME:WaitFrames(15)
      think(hero, 'Sad', "(Elle avait peur.[pause=30] Pour la premiere fois depuis le debut,[pause=20] elle avait PEUR.)")
      GAME:WaitFrames(25)

      say(rayquaza, 'Sad', "Une derniere chose,[pause=20] et je me tais.")
      GAME:WaitFrames(20)

      -- Le regret. Il baisse la tete — le colosse s'incline devant deux
      -- gamins. C'est l'image que la scene doit laisser.
      pcall(function() GROUND:CharSetAnim(rayquaza, "Hurt", true) end)
      GAME:WaitFrames(15)
      say(rayquaza, 'Sad', "J'aurais du continuer a regarder le ciel.[pause=40] Trente ans a croire qu'on avait gagne,[pause=25] c'est trente ans a ne pas voir revenir.")
      GAME:WaitFrames(40)

      -- Il ESSAIE de se relever, et n'y arrive pas. C'est ce plan qui rend
      -- necessaire l'effort de l'acte 2 : quand la meteorite tombera, il
      -- montera quand meme, et le joueur saura ce que ca lui coute.
      pcall(function()
        GROUND:CharSetAnim(rayquaza, "Idle", true)
        GAME:WaitFrames(20)
        BossFX.ShakeScreen(2, 14)
        GROUND:CharSetAnim(rayquaza, "Hurt", true)
      end)
      GAME:WaitFrames(30)
      narrate("Il tente de reprendre de l'altitude.[pause=30] Son corps refuse de quitter la pierre.")
      GAME:WaitFrames(25)
    end,
  })
end

return ChapterAftermath
