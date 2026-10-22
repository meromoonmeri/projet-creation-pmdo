-- === ENRICHISSEMENT 7K CH6 ===
-- L'arc de la Team Dazzling met en avant la rivalité idéologique entre
-- le prestige de surface (les badges diamants d'Adagio, Aria, Sonata) et
-- le dévouement sincère de l'équipe du joueur pour secourir Chenipent.
--[[
    DazzlingArc.lua

    LE CHAPITRE 6 : ZERAORA, PUIS LES TROIS
    ================================================================
    Etat des lieux avant ce lot (mesure tools/count_dialogue.py) :
    le chapitre 6 comptait 199 lignes, contre 1442 au chapitre 5. Deux
    trous precis, et non un manque diffus :

      1. ZERAORA N'AVAIT AUCUN APRES-BOSS. On le battait, la zone posait
         SV.Chapter6.DefeatedGloomyBoss = true, et on rentrait dormir.
         Les chapitres 8, 9 et 10 ont recu leur scene de consequence
         (ChapterAftermath.lua) ; le 6, lui, se terminait plus sechement
         qu'un donjon secondaire. Le boss le plus « personnage » du jeu —
         un gardien qui defend sa foret — mourait sans un mot.

      2. LA TEAM DAZZLING SE MOQUAIT SANS JAMAIS COMBATTRE. Verifie dans
         metano_town_ch_6.lua : elles paradent (DazzlingIntroduction),
         elles narguent apres une defaite (PostDefeatCutscene), elles
         felicitent du bout des levres (PostMissionCutscene). Trois
         scenes de parole, zero confrontation. Le rival qui n'affronte
         jamais le heros n'est pas un rival : c'est un decor bavard.

    ------------------------------------------------------------------
    CE QUE LES SOURCES ENSEIGNENT — ET CE QU'ON EN FAIT ICI
    ------------------------------------------------------------------
    * pret/pmd-red, intro.inc : FILS PARALLELES SYNCHRONISES PAR DRAPEAUX
      (setFlag 5 / waitFlag 5). Trois acteurs bougent en meme temps et se
      rejoignent sur un point de rendez-vous, au lieu de jouer chacun leur
      tour. -> Ici : les trois rivales n'entrent JAMAIS a la queue leu leu.
      Elles arrivent en triangle, decalees de 8 et 16 frames, et se
      rejoignent sur un JoinCoroutines. C'est ce qui donne le sentiment
      d'une equipe, et non de trois PNJ.

    * pret/pmd-red : CASCADE D'ANIMATIONS SUR UN ACTEUR (setAnimation 0xE,
      0xF, 0x10...). Un corps traverse une SUITE d'etats. -> Ici : Zeraora
      vaincu passe Hurt -> secousse -> Idle -> EventSleep, avec des temps
      morts. Il ne s'eteint pas d'un bloc.

    * EoSO, beach/init.lua : ON ETABLIT LE LIEU AVANT LES PERSONNAGES.
      -> Ici : avant le duel, 60 frames de clairiere vide et de musique
      qui monte. Avant l'apres-boss, la foret respire d'abord.

    * EoSO, storm_cutscene_a : BASCULE DE FIN EN COROUTINES CALEES
      (FadeOutFront + WaitShowTimedDialogue + FadeOutSE sur la meme duree).
      La derniere phrase s'efface AVEC l'image. -> Ici, fin du duel.

    ------------------------------------------------------------------
    IDENTITE NARRATIVE DES DEUX SCENES (elles ne se ressemblent pas)
    ------------------------------------------------------------------
      APRES-BOSS ZERAORA   Registre : honte. Zeraora n'est pas un mechant,
                          c'est un gardien qui a eu peur. Il croyait
                          proteger la foret en la fermant. Il decouvre
                          qu'il l'etouffait. Personne ne triomphe.
                          Fonction : premiere fois que le duo comprend
                          qu'un « ennemi » peut avoir raison sur le fond
                          et tort sur la methode.

      DUEL DAZZLING       Registre : sport. Aucun enjeu cosmique, aucune
                          Voix, aucun Coeur. C'est le SEUL combat du jeu
                          ou personne ne risque rien — et c'est exactement
                          pour ca qu'il compte : il montre au joueur ce
                          que serait une vie d'explorateur normale.
                          Fonction : Adagio reconnait le duo, et sa
                          reconnaissance vaut plus que la victoire.

    ------------------------------------------------------------------
    REGLES DU PROJET RESPECTEES ICI
    ------------------------------------------------------------------
    * Module GLOBAL (appele depuis zone/ et ground/) : donc TEXTE
      LITTERAL, jamais STRINGS.MapStrings — qui ne contient que les cles
      du ground courant. Patron de SuaireArc.lua / ChapterAftermath.lua.
    * Aucun nom interdit. La Voix ne parle pas dans ce chapitre : c'est
      voulu. Le silence de la Voix pendant tout le duel est une
      information pour le joueur attentif (elle ne s'interesse pas aux
      combats sans enjeu).
    * Le mot « prison » n'apparait pas. Le mot « paroi » non plus : on
      n'anticipe pas l'arc 9.
    * Repliques courtes, 1-2 phrases par boite, < 150 caracteres hors
      balises [pause=N].
    * Tout sous pcall, sortie garantie quoi qu'il arrive.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.EngineKit'

DazzlingArc = {}

--------------------------------------------------------------------
-- Briques locales (memes helpers que ChapterAftermath, volontairement :
-- deux modules globaux doivent se lire de la meme facon).
--------------------------------------------------------------------

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

--Cascade d'animations sur un corps vaincu (principe pmd-red).
local function collapse(boss)
  if boss == nil then return end
  pcall(function()
    GROUND:CharSetAnim(boss, "Hurt", true)
    GAME:WaitFrames(30)
    BossFX.ShakeScreen(4, 20)
    GAME:WaitFrames(20)
    GROUND:CharSetAnim(boss, "Idle", true)
    GAME:WaitFrames(25)
  end)
end

--Enveloppe commune : cadrage, fondu, musique, sortie garantie.
--`cfg.sv` / `cfg.flag` rendent la scene idempotente (rejouable sans doublon).
local function Scene(cfg)
  if cfg.sv ~= nil and cfg.flag ~= nil then
    if cfg.sv[cfg.flag] then return false end
    cfg.sv[cfg.flag] = true
  end

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
    --EoSO/beach : le LIEU s'installe avant qu'on parle.
    if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, cfg.loop ~= false) end
    GAME:WaitFrames(cfg.settle or 25)

    cfg.scene(hero, partner)
  end)

  if not ok then PrintInfo('[DazzlingArc] scene ecourtee : '..tostring(err)) end

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
-- APRES-BOSS DU CHAPITRE 6 — Zeraora comprend ce qu'il a fait.
--------------------------------------------------------------------
-- Se joue dans le ground gloomy_forest_boss (600x600, ancrages officiels
-- verifies : Main_Entrance_Marker 276,584 / TEAMMATE_1 308,584 ; la
-- clairiere jouable de la scene d'apparition va de y=208 a y=416 en x
-- 240..310). Les positions ci-dessous reprennent EXACTEMENT celles de
-- gloomy_forest_boss_ch_6.FirstBossScene : hero 276,288 / partner 308,288
-- / Zeraora 276,208. Aucun nouveau reperage : on rejoue le meme cadre,
-- ce qui garantit que le decor derriere les sprites est celui prevu.
--
-- Ton : personne ne gagne. Zeraora ne se rend pas, il REALISE. Le partenaire,
-- qui hurlait « on n'abandonne personne » avant le combat, est celui qui
-- lui tend la main — c'est le paiement de sa replique d'avant-combat.
function DazzlingArc.GloomyVictory()
  return Scene({
    sv = SV.Chapter6, flag = 'PlayedVictoryScene',
    music = 'Mystifying Forest.ogg',
    hero = {276, 288}, partner = {308, 288}, camera = {292, 250},
    settle = 40,
    scene = function(hero, partner)
      local zeraora = CharacterEssentials.MakeCharactersFromList({
        {'Zeraora', 276, 208, Direction.Down}
      })
      pcall(function() AI:DisableCharacterAI(zeraora) end)
      collapse(zeraora)

      narrate("Les lianes retombent une a une.[pause=25] Pour la premiere fois, on entend la foret respirer.")
      GAME:WaitFrames(20)

      say(zeraora, 'Pain', "...Assez.[pause=25] Vous avez gagne le passage.")
      say(partner, 'Worried', "On ne voulait pas vous blesser.[pause=20] On voulait juste recuperer Chenipent.")
      GAME:WaitFrames(15)
      say(zeraora, 'Sad', "Chenipent.[pause=30] C'est donc son nom.")
      GAME:WaitFrames(20)
      think(hero, 'Surprised', "(Il ne savait meme pas qui il retenait.)")
      GAME:WaitFrames(15)

      say(zeraora, 'Normal', "Je ne l'ai pas pris.[pause=25] Il s'est perdu, et j'ai ferme les chemins derriere lui.")
      say(partner, 'Angry', "Vous l'avez ENFERME ![pause=20] Il avait peur !")
      GAME:WaitFrames(20)
      say(zeraora, 'Sad', "Oui.[pause=30] Je croyais le mettre a l'abri.")
      GAME:WaitFrames(25)

      -- Le pivot : le gardien qui etouffe ce qu'il protege. C'est le
      -- theme du chapitre, dit par la bouche du boss et non par un
      -- narrateur.
      say(zeraora, 'Sad', "Il y a longtemps, quelque chose est entre dans cette foret.[pause=30] Depuis, je ferme.")
      say(zeraora, 'Normal', "Les chemins, les clairieres, la lumiere.[pause=25] Tout ce qui pouvait laisser passer.")
      GAME:WaitFrames(20)
      say(partner, 'Sad', "Et la foret est devenue... ca.[pause=25] Noire. Silencieuse.")
      GAME:WaitFrames(20)
      say(zeraora, 'Pain', "Une foret fermee ne meurt pas.[pause=30] Elle s'eteint. C'est plus lent.")
      GAME:WaitFrames(25)

      think(hero, 'Worried', "(Il a passe tout ce temps a proteger un endroit qu'il etait en train de tuer.)")
      GAME:WaitFrames(20)

      -- Le partenaire paie sa replique d'avant-combat (« On ne laisse
      -- personne derriere »). Il l'applique a l'adversaire.
      say(partner, 'Determined', "Alors rouvrez.[pause=25] On reviendra. On surveillera avec vous.")
      GAME:WaitFrames(20)
      say(zeraora, 'Surprised', "...Pourquoi ?[pause=25] Je viens de vous barrer la route.")
      say(partner, 'Normal', "Parce que vous aviez une bonne raison.[pause=20] Juste une mauvaise methode.")
      GAME:WaitFrames(25)

      say(zeraora, 'Normal', "Emmenez le petit.[pause=30] Et dites-lui que la foret s'excuse.")
      GAME:WaitFrames(20)

      -- Il ne disparait pas dans un effet : il s'ecarte. Un gardien qui
      -- cesse de garder, c'est plus fort qu'un boss qui s'evapore.
      pcall(function()
        -- Il se decale vers le bas-gauche : a y=208 les cotes sont de la
        -- roche pleine (obstacles verifies), le degagement est au sud.
        GROUND:CharAnimateTurnTo(zeraora, Direction.DownLeft, 4)
        GROUND:MoveToPosition(zeraora, 268, 232, false, 1)
      end)
      GAME:WaitFrames(20)
      narrate("Il s'ecarte du passage.[pause=25] Il ne s'en va pas :[pause=20] il arrete simplement de se tenir devant.")
      GAME:WaitFrames(20)
      think(hero, 'Normal', "(Ce n'est pas une victoire.[pause=25] C'est quelqu'un qui pose enfin quelque chose de lourd.)")
    end,
  })
end

--------------------------------------------------------------------
-- LE DUEL DES TROIS — avant-combat.
--------------------------------------------------------------------
-- Se joue dans le ground gloomy_forest_boss, meme cadre que ci-dessus.
-- Positions des trois rivales : en TRIANGLE (Adagio en retrait au centre,
-- Aria et Sonata en avant-garde), pas en ligne. Elles occupent la zone
-- y=200..232, x=240..312, entierement dans la clairiere jouable.
--
-- Regle de la scene : AUCUN enjeu. Pas de Voix, pas de Coeur, pas de
-- fragment. Adagio le dit explicitement — c'est ce qui rend le combat
-- respirable apres Zeraora.
function DazzlingArc.TrialIntro()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:StopBGM()

    GROUND:TeleportTo(hero, 276, 296, Direction.Up)
    GROUND:TeleportTo(partner, 308, 296, Direction.Up)
    GAME:MoveCamera(292, 280, 1, false)

    GAME:FadeIn(40)
    --EoSO/beach : la clairiere d'abord, les personnages ensuite.
    GAME:WaitFrames(60)

    narrate("La clairiere a change.[pause=25] La lumiere y tombe droit, maintenant.")
    GAME:WaitFrames(20)
    say(partner, 'Happy', "Regarde ![pause=20] Il a tenu parole. Tout est ouvert.")
    GAME:WaitFrames(15)

    -- Arrivee en TRIANGLE, trois fils paralleles decales (patron pmd-red :
    -- des acteurs qui convergent, pas une file indienne).
    -- Elles arrivent par le SUD, dans le dos du duo : elles l'ont suivi
    -- depuis l'entree, donc elles viennent du chemin, pas du fond de la
    -- clairiere. Le nord (y<230) est de la roche pleine sur cette carte
    -- (obstacles verifies) ; le sud y=376..432 est degage.
    SOUND:PlayBGM('Team_Dazzling_Theme.ogg', true)
    local trio = CharacterEssentials.MakeCharactersFromList({
      {'Adagio', 276, 416, Direction.Up},
      {'Aria',   244, 416, Direction.Up},
      {'Sonata', 308, 416, Direction.Up}
    })
    local adagio, aria, sonata = CH('Adagio'), CH('Aria'), CH('Sonata')
    for _, c in ipairs({adagio, aria, sonata}) do
      pcall(function() AI:DisableCharacterAI(c) end)
    end

    -- Le duo entend derriere lui AVANT de voir : on tourne d'abord.
    SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
    local t1 = TASK:BranchCoroutine(function()
      GROUND:CharSetEmote(partner, "shock", 1)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end)
    local t2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(8)
      GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
    end)
    TASK:JoinCoroutines({t1, t2})
    GAME:WaitFrames(16)

    -- Trois fils decales : elles convergent en triangle, Adagio en tete.
    local a1 = TASK:BranchCoroutine(function()
      GROUND:MoveToPosition(aria, 244, 376, false, 1)
      GROUND:CharAnimateTurnTo(aria, Direction.Up, 4)
    end)
    local a2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(8)
      GROUND:MoveToPosition(sonata, 308, 376, false, 1)
      GROUND:CharAnimateTurnTo(sonata, Direction.Up, 4)
    end)
    local a3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(16)
      GROUND:MoveToPosition(adagio, 276, 344, false, 1)
      GROUND:CharAnimateTurnTo(adagio, Direction.Up, 4)
    end)
    local a4 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(22)
      GAME:MoveCamera(292, 336, 40, false)
    end)
    TASK:JoinCoroutines({a1, a2, a3, a4})
    GAME:WaitFrames(20)

    say(partner, 'Surprised', "Vous ?![pause=20] Qu'est-ce que vous faites au coeur de la foret ?")
    say(aria, 'Happy', "On vous a suivies.[pause=20] Enfin — suivis. Depuis l'entree.")
    say(sonata, 'Happy', "Tout du long ![pause=20] Vous n'avez rien remarque. Pas une fois.")
    GAME:WaitFrames(15)
    think(hero, 'Worried', "(Tout du long.[pause=25] Meme dans les profondeurs.)")
    GAME:WaitFrames(15)

    say(partner, 'Angry', "Vous nous avez espionnes pendant qu'on se battait ?!")
    say(adagio, 'Normal', "Nous avons REGARDE.[pause=25] Ce n'est pas la meme chose.")
    GAME:WaitFrames(20)
    say(adagio, 'Normal', "Nous serions intervenues si vous etiez tombes.[pause=25] Vous n'etes pas tombes.")
    GAME:WaitFrames(20)
    say(partner, 'Surprised', "...Vous seriez intervenues ?")
    say(aria, 'Normal', "Evidemment.[pause=25] On est insupportables, pas monstrueuses.")
    GAME:WaitFrames(20)

    -- Adagio pose l'enjeu : il n'y en a pas. C'est la ligne-cle.
    say(adagio, 'Normal', "Je viens vous demander quelque chose.[pause=25] Battez-vous contre nous.")
    say(partner, 'Worried', "Maintenant ?[pause=20] On sort d'un combat !")
    say(adagio, 'Normal', "Justement.[pause=30] N'importe qui gagne frais.[pause=20] Je veux voir ce que vous valez vides.")
    GAME:WaitFrames(20)

    think(hero, 'Normal', "(Elle a attendu le pire moment.[pause=25] Exprès.)")
    GAME:WaitFrames(15)

    say(sonata, 'Happy', "Et il n'y a rien a gagner ![pause=20] Ni tresor, ni rang, ni mission.")
    say(aria, 'Happy', "Que de l'orgueil ![pause=20] C'est la meilleure des mises.")
    GAME:WaitFrames(20)
    say(adagio, 'Normal', "Si vous refusez, nous partons.[pause=25] Sans un mot de travers. Vous avez ma parole.")
    GAME:WaitFrames(20)

    say(partner, 'Determined', "...Tu en penses quoi ?[pause=25] On a le droit de dire non.")
    GAME:WaitFrames(15)
    think(hero, 'Determined', "(On a le droit.[pause=25] Mais je veux savoir, moi aussi.)")
    GAME:WaitFrames(20)

    say(partner, 'Inspired', "D'accord.[pause=20] Mais on ne se retient pas.")
    say(adagio, 'Happy', "Enfin une phrase qui me plait.")
    GAME:WaitFrames(15)

    -- Mise en place du combat : les trois se placent, la musique monte.
    say(aria, 'Determined', "Trois contre vous.[pause=20] Ne nous remerciez pas, c'est plus joli comme ca.")
    say(sonata, 'Normal', "Je ne ferai pas semblant.[pause=20] Je previens, c'est tout.")
    GAME:WaitFrames(20)
    say(adagio, 'Determined', "Une regle unique :[pause=25] personne ne s'excuse a la fin.")
    GAME:WaitFrames(25)

    pcall(function()
      GROUND:CharSetEmote(adagio, "determined", 1)
      GROUND:CharSetEmote(aria, "determined", 1)
      GROUND:CharSetEmote(sonata, "determined", 1)
    end)
    BossFX.ShakeScreen(5, 20)
    GAME:WaitFrames(20)
  end)

  if not ok then PrintInfo('[DazzlingArc.TrialIntro] ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    SV.Chapter6.DazzlingTrialStarted = true
    COMMON.BossTransition()
    GAME:CutsceneMode(false)
  end)
end

--------------------------------------------------------------------
-- LE DUEL DES TROIS — victoire du joueur.
--------------------------------------------------------------------
-- Adagio ne concede pas de mauvaise grace : elle NOMME. C'est le vrai
-- prix du combat, et c'est ce que le joueur retient.
function DazzlingArc.TrialVictory()
  return Scene({
    sv = SV.Chapter6, flag = 'PlayedTrialVictory',
    music = 'Team_Dazzling_Theme.ogg',
    hero = {276, 288}, partner = {308, 288}, camera = {292, 330},
    scene = function(hero, partner)
      -- Memes ancrages que TrialIntro : elles sont restees au sud, le duo
      -- leur fait face. Positions verifiees libres sur les obstacles.
      local trio = CharacterEssentials.MakeCharactersFromList({
        {'Adagio', 276, 344, Direction.Up},
        {'Aria',   244, 376, Direction.Up},
        {'Sonata', 308, 376, Direction.Up}
      })
      local adagio, aria, sonata = CH('Adagio'), CH('Aria'), CH('Sonata')
      for _, c in ipairs({adagio, aria, sonata}) do
        pcall(function() AI:DisableCharacterAI(c) end)
      end
      pcall(function()
        GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
        GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
      end)

      -- Cascade sur les trois corps, decalee (elles ne tombent pas
      -- ensemble : ce serait mecanique).
      local f1 = TASK:BranchCoroutine(function()
        pcall(function() GROUND:CharSetAnim(aria, "Hurt", true) end)
        GAME:WaitFrames(24)
        pcall(function() GROUND:CharSetAnim(aria, "Idle", true) end)
      end)
      local f2 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(10)
        pcall(function() GROUND:CharSetAnim(sonata, "Hurt", true) end)
        GAME:WaitFrames(24)
        pcall(function() GROUND:CharSetAnim(sonata, "Idle", true) end)
      end)
      local f3 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(18)
        pcall(function() GROUND:CharSetAnim(adagio, "Hurt", true) end)
        GAME:WaitFrames(30)
        pcall(function() GROUND:CharSetAnim(adagio, "Idle", true) end)
      end)
      TASK:JoinCoroutines({f1, f2, f3})
      GAME:WaitFrames(20)

      narrate("Aucune des trois ne tombe.[pause=25] Elles s'arretent, toutes en meme temps,[pause=20] comme sur un signal.")
      GAME:WaitFrames(20)

      say(aria, 'Pain', "Aie.[pause=20] Aie aie aie.[pause=25] D'accord.")
      say(sonata, 'Sad', "Je n'ai meme pas eu le temps de faire mon effet.")
      GAME:WaitFrames(15)
      say(partner, 'Inspired', "On a gagne ?[pause=20] On a GAGNE !")
      GAME:WaitFrames(20)

      say(adagio, 'Normal', "Oui.[pause=30] Ne le dites pas trop fort, la foret est encore fragile.")
      GAME:WaitFrames(20)
      say(aria, 'Happy', "Ils sortent d'un boss, Adagio.[pause=25] D'un BOSS.")
      say(adagio, 'Normal', "Je sais.[pause=25] J'ai choisi le moment. C'etait le but.")
      GAME:WaitFrames(20)

      think(hero, 'Normal', "(Elle a perdu son propre pari.[pause=25] Et elle a l'air contente.)")
      GAME:WaitFrames(20)

      -- Le vrai prix : la reconnaissance. Adagio arrete d'employer
      -- « les petits » et emploie le nom de l'equipe.
      say(adagio, 'Normal', "Depuis le debut je vous appelle « les petits ».[pause=30] C'etait commode.")
      GAME:WaitFrames(20)
      say(adagio, 'Determined', "Je vais arreter.[pause=30] Vous avez un nom. Je vais l'utiliser.")
      GAME:WaitFrames(25)
      say(partner, 'Surprised', "...C'est tout ?[pause=25] Pas de revanche, pas de « la prochaine fois » ?")
      say(adagio, 'Normal', "La prochaine fois, evidemment.[pause=25] Mais pas aujourd'hui.")
      GAME:WaitFrames(20)

      say(sonata, 'Happy', "Elle est de bonne humeur.[pause=20] Ca dure environ deux jours. Profitez-en.")
      say(aria, 'Happy', "Trois, si vous lui offrez a boire.")
      GAME:WaitFrames(20)
      say(adagio, 'Sigh', "...Rentrons.")
      GAME:WaitFrames(15)

      -- Bascule de fin, patron storm_cutscene_a : la derniere phrase
      -- s'efface EXACTEMENT avec l'image. Trois fils cales sur 90 frames.
      local e1 = TASK:BranchCoroutine(function()
        GROUND:MoveToPosition(aria, 244, 432, false, 1)
        GROUND:MoveToPosition(sonata, 308, 432, false, 1)
      end)
      local e2 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(20)
        UI:ResetSpeaker(false)
        UI:SetCenter(true)
        UI:WaitShowTimedDialogue("Elles repartent en se chamaillant.[pause=20] La foret laisse passer le bruit, maintenant.", 70)
        UI:SetCenter(false)
      end)
      local e3 = TASK:BranchCoroutine(function()
        GAME:WaitFrames(30)
        SOUND:FadeOutBGM(60)
        GAME:WaitFrames(30)
        GAME:FadeOut(false, 30)
      end)
      TASK:JoinCoroutines({e1, e2, e3})
      GAME:WaitFrames(20)
    end,
  })
end

--------------------------------------------------------------------
-- LE DUEL DES TROIS — defaite du joueur.
--------------------------------------------------------------------
-- Aucune humiliation. C'est la difference avec PostDefeatCutscene du
-- ch6 (ou elles narguent apres l'echec contre Zeraora) : la, l'echec
-- etait un manquement a une mission ; ici, ce n'est qu'un match perdu.
-- Adagio, qui se moque en ville, est CORRECTE sur le terrain. Ce
-- contraste est le vrai portrait du personnage.
function DazzlingArc.TrialDefeat()
  return Scene({
    sv = SV.Chapter6, flag = 'PlayedTrialDefeat',
    music = 'Team_Dazzling_Theme.ogg',
    hero = {276, 288}, partner = {308, 288}, camera = {292, 330},
    scene = function(hero, partner)
      local trio = CharacterEssentials.MakeCharactersFromList({
        {'Adagio', 276, 344, Direction.Up},
        {'Aria',   244, 376, Direction.Up},
        {'Sonata', 308, 376, Direction.Up}
      })
      local adagio, aria, sonata = CH('Adagio'), CH('Aria'), CH('Sonata')
      for _, c in ipairs({adagio, aria, sonata}) do
        pcall(function() AI:DisableCharacterAI(c) end)
      end

      pcall(function()
        GROUND:CharSetAnim(hero, "EventSleep", true)
        GROUND:CharSetAnim(partner, "EventSleep", true)
      end)
      GAME:WaitFrames(30)

      narrate("Le sol est frais.[pause=25] C'est la premiere chose qu'on remarque, quand on est a terre.")
      GAME:WaitFrames(25)

      say(aria, 'Worried', "Adagio.[pause=20] Ils ne se relevent pas.")
      say(adagio, 'Normal', "Ils sont sortis d'un combat il y a dix minutes.[pause=25] Recule.")
      GAME:WaitFrames(20)

      -- Elle soigne. Aucun triomphe, aucune pique.
      pcall(function()
        GROUND:MoveToPosition(adagio, 276, 320, false, 1)
        GROUND:CharAnimateTurnTo(adagio, Direction.Down, 4)
        SOUND:PlayBattleSE("DUN_Heal")
      end)
      GAME:WaitFrames(25)
      narrate("Adagio depose deux baies a portee de patte,[pause=20] et recule de trois pas.")
      GAME:WaitFrames(20)

      pcall(function()
        GROUND:CharEndAnim(partner)
        GeneralFunctions.DoAnimation(partner, 'Wake')
      end)
      GAME:WaitFrames(20)
      say(partner, 'Pain', "...Vous nous soignez ?")
      say(adagio, 'Normal', "Je vous ai demande un combat.[pause=25] Pas une nuit dehors.")
      GAME:WaitFrames(20)

      say(sonata, 'Worried', "On y est allees fort.[pause=20] Je crois qu'on y est allees fort.")
      say(aria, 'Sad', "On y est allees fort.")
      GAME:WaitFrames(20)

      say(adagio, 'Normal', "C'etait la demande.[pause=25] « On ne se retient pas. » Ce sont vos mots.")
      GAME:WaitFrames(20)
      think(hero, 'Sad', "(Elle a raison.[pause=25] C'est ca qui est agacant.)")
      GAME:WaitFrames(20)

      -- Elle ne dit pas « vous etes faibles ». Elle dit ce qui manque.
      say(adagio, 'Normal', "Vous n'etes pas plus faibles que nous.[pause=30] Vous etes plus fatigues. Ce n'est pas pareil.")
      GAME:WaitFrames(20)
      say(partner, 'Determined', "Alors on recommencera.[pause=20] Frais.")
      say(adagio, 'Happy', "J'y compte bien.[pause=25] Et cette fois, c'est moi qui choisirai d'etre fatiguee.")
      GAME:WaitFrames(20)

      pcall(function() GROUND:CharEndAnim(hero) end)
      narrate("Elles s'en vont sans se retourner.[pause=25] Personne, en ville, n'entendra parler de ce combat.")
      GAME:WaitFrames(20)
      think(hero, 'Normal', "(Elle aurait pu le raconter a tout Metano.[pause=25] Elle ne le fera pas.)")
    end,
  })
end

return DazzlingArc
