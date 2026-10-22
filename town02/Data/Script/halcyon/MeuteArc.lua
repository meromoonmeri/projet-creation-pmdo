--[[
    MeuteArc.lua — LA MEUTE DE CORBOSS

    Fil narratif recurrent des chapitres 8 a 10, demande par
    PLAN_DIRECTEUR_EXPANSION_CH8_10.md, section 2 :

        « Pour materialiser la montee de tension a l'approche de la
          crise climatique et de la fuite, une bande organisee de
          pilleurs opportunistes, la Meute de Corboss (Honchkrow) et
          ses sous-fifres Cornebre (Murkrow), intervient de maniere
          recurrente dans les donjons. Ils profitent du chaos
          environnemental pour detrousser les explorateurs en detresse. »

    ------------------------------------------------------------------
    ETAT AVANT CE MODULE
    ------------------------------------------------------------------
    Le fil n'existait pas. Un seul Cornebre apparaissait, au mini-boss
    de la Foret Lugubre (ch6), sans meute, sans chef et sans suite.
    Aucun chef n'etait declare dans CharacterEssentials.

    ESPECE DU CHEF : le plan ecrit « Honchkrow ». Ce nom n'apparait nulle
    part dans le projet — ni dans Data/Monster, ni dans la liste de
    spawns de mission_gen.lua (461 especes, ordre alphabetique : rien
    entre honedge et hoppip). L'employer serait inventer un asset. On
    retient mandibuzz, atteste dans cette liste : grand rapace
    charognard, plus credible en chef de bande que l'evolution d'un
    simple Cornebre.

    Pire : la fiche `Murkrow` y etait definie DEUX FOIS — Cornebre en
    ligne 458, puis Varko (PNJ nocturne) en ligne 1288. Lua ne garde que
    la derniere : le mini-boss du ch6 invoquait Varko en croyant
    invoquer Cornebre. Corrige en amont de ce module (Cornebre_Boss).

    ------------------------------------------------------------------
    LA STRUCTURE — TROIS RENCONTRES, UNE PROGRESSION
    ------------------------------------------------------------------
    Le plan demande une recurrence, pas trois combats identiques. Chaque
    rencontre change donc de NATURE :

      ch8   LE GUET      — ils observent, ils comptent, ils ne frappent
                           pas. On ne comprend pas encore ce qu'ils font.
      ch9   LE PILLAGE   — ils depouillent une equipe a terre. On arrive
                           trop tard. Premiere confrontation directe.
      ch10  LA BASCULE   — ils fuient comme tout le monde. Le chef parle
                           enfin, et ce qu'il dit vaut mieux qu'un combat.

    LE RENVERSEMENT DU CH10 est le coeur du fil. Corboss n'est pas un
    mechant : c'est un opportuniste lucide qui a compris avant les
    autres que le ciel tournait mal. Sa derniere replique donne au
    joueur une information que personne d'autre ne pouvait lui donner —
    parce que seul un charognard regarde ou les autres detournent les
    yeux.

    ------------------------------------------------------------------
    PLACEMENT
    ------------------------------------------------------------------
    A la sortie d'un donjon d'expedition, pas d'un donjon d'histoire :
    on ne coupe jamais la ligne principale. Patron SuaireArc.PlayAct.
      ch8   carriere_cuivre
      ch9   marais_errants
      ch10  falaises_envol
    Ces trois zones portent deja une expedition (SideExpeditions) : la
    Meute s'y greffe APRES, ce qui donne au joueur une raison de plus
    d'y aller et lie le contenu optionnel au fil rouge.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * Aucun nom des jeux d'origine.
      * La Voix n'intervient pas : ce fil est terrestre, humain, sale.
      * Module global -> texte litteral, pas de .resx.
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Tout sous pcall, sortie garantie, jamais d'ecran noir.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

MeuteArc = {}

--Donjon -> numero d'acte. Un seul point de verite.
MeuteArc.ACTS = {
  carriere_cuivre = 1,
  marais_errants  = 2,
  falaises_envol  = 3,
}

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
local function sv()
  if SV.MeuteArc == nil then SV.MeuteArc = {} end
  local s = SV.MeuteArc
  if s.CurrentAct == nil then s.CurrentAct = 1 end
  if s.Act1Done == nil then s.Act1Done = false end
  if s.Act2Done == nil then s.Act2Done = false end
  if s.Act3Done == nil then s.Act3Done = false end
  --Ce que le joueur a compris de la Meute, pour les dialogues de ville.
  if s.Known == nil then s.Known = false end
  return s
end

--------------------------------------------------------------------
-- UTILITAIRES DE SCENE
--------------------------------------------------------------------
local function say(who, emo, txt)
  local c = CH(who)
  if c == nil then return end
  UI:SetSpeaker(c)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(8)
end

--Regard : chaque personnage pivote selon SA position par rapport a la
--cible (section 5.2 du guide des cutscenes). On ne fait jamais tourner
--un groupe d'un bloc.
local function regarder(qui, cible, frames)
  local a, b = CH(qui), CH(cible)
  if a == nil or b == nil then return end
  pcall(function() GROUND:CharTurnToCharAnimated(a, b, frames or 4) end)
end

--Emote ponctuelle. Reservee aux moments qui la meritent (section 5.6).
local function emote(qui, nom)
  local c = CH(qui)
  if c == nil then return end
  pcall(function() GROUND:CharSetEmote(c, nom, 1) end)
end

--Cadrage. `dur` a 1 = coupe franche, sinon travelling.
local function cadre(x, y, dur)
  pcall(function() GAME:MoveCamera(x, y, dur or 40, false) end)
end

--Fait apparaitre la meute sous un flash, patron BossFX du mod.
local function surgir(liste)
  local sortis = {}
  local ok = pcall(function()
    sortis = CharacterEssentials.MakeCharactersFromList(liste, true)
  end)
  if not ok then return nil end
  for _, e in ipairs(liste) do
    pcall(function() GROUND:Hide(e[1]) end)
  end
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  GAME:WaitFrames(10)
  for _, e in ipairs(liste) do
    pcall(function() BossFX.Flash(e[2], e[3], 3, 5, 18) end)
    pcall(function() GROUND:Unhide(e[1]) end)
    GAME:WaitFrames(6)
  end
  return sortis
end

local function disparaitre(noms)
  SOUND:PlayBattleSE('EVT_Battle_Flash')
  for _, n in ipairs(noms) do
    pcall(function() GROUND:Hide(n) end)
  end
  GAME:WaitFrames(15)
end


--------------------------------------------------------------------
-- ACTE I — LE GUET  (ch8, sortie de la Carriere de Cuivre)
--
-- Ils ne font rien. C'est tout l'interet : le joueur les voit compter,
-- noter, repartir. Une menace qui prend son temps inquiete davantage
-- qu'une menace qui frappe.
--------------------------------------------------------------------
function MeuteArc.Act1(hero, partner)
  local s = sv()

  --Le lieu d'abord, en plan large : la sortie de la carriere.
  cadre(240, 232, 1)
  GAME:WaitFrames(25)

  --Le duo remonte vers la sortie. On les voit AVANT de voir la Meute.
  local m1 = TASK:BranchCoroutine(function()
    pcall(function() GeneralFunctions.EightWayMove(hero, 240, 232, false, 1) end)
  end)
  local m2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    pcall(function() GeneralFunctions.EightWayMove(partner, 216, 240, false, 1) end)
  end)
  pcall(function() TASK:JoinCoroutines({m1, m2}) end)
  GAME:WaitFrames(12)

  --Un bruit d'ailes : le partenaire l'entend le premier et se retourne.
  SOUND:PlayBattleSE('EVT_Emote_Startled_2')
  emote('Teammate1', 'notice')
  GAME:WaitFrames(14)

  --Ils SE POSENT. Des charognards ne se teleportent pas.
  surgir({
    {'Corboss',        240, 176, Direction.Down},
    {'Cornebre_Boss',  208, 192, Direction.Down},
  })
  pcall(function() BossFX.ShakeScreen(2, 12) end)
  cadre(228, 196, 45)
  GAME:WaitFrames(16)

  --Chacun se tourne selon SA position : le duo est en dessous, la Meute
  --au-dessus et decalee a gauche.
  regarder('PLAYER', 'Corboss', 5)
  GAME:WaitFrames(4)
  regarder('Teammate1', 'Corboss', 4)
  GAME:WaitFrames(10)

  say('partner', 'Surprised', "Ils etaient la ?[pause=25] Depuis combien de temps ?")

  --Cornebre ne regarde meme pas le duo : il compte. C'est ce detail qui
  --inquiete, pas la menace.
  regarder('Cornebre_Boss', 'Corboss', 4)
  say('Cornebre_Boss', 'Normal', "Deux. Une equipe de deux.[pause=20] Chef, je note deux.")
  GAME:WaitFrames(8)

  cadre(240, 184, 35)
  say('Corboss', 'Normal', "Note aussi qu'ils ressortent debout.[pause=25] C'est rare, cette semaine.")
  GAME:WaitFrames(12)

  think(hero, 'Worried', "(Ils ne nous barrent pas la route.[pause=25] Ils nous COMPTENT.)")

  --Le partenaire avance d'un pas : il se met entre le heros et la Meute.
  pcall(function() GeneralFunctions.EightWayMove(partner, 224, 224, false, 1) end)
  regarder('Teammate1', 'Corboss', 4)
  emote('Teammate1', 'angry')
  say('partner', 'Angry', "Qu'est-ce que vous faites ?![pause=20] Vous nous espionnez ?")
  GAME:WaitFrames(10)

  --Corboss descend d'un cran. Il ne menace pas : il se rapproche pour
  --etre entendu, ce qui est plus derangeant.
  pcall(function() GeneralFunctions.EightWayMove(CH('Corboss'), 240, 200, false, 1) end)
  regarder('Corboss', 'PLAYER', 5)
  cadre(234, 204, 30)
  say('Corboss', 'Normal', "Nous tenons des comptes.[pause=25] Qui descend. Qui remonte. Combien il en manque.")
  GAME:WaitFrames(8)
  say('Corboss', 'Happy', "Vous seriez surpris du nombre de gens qui ne remontent pas, ces temps-ci.")
  GAME:WaitFrames(14)

  emote('Teammate1', 'sweatdrop')
  say('partner', 'Worried', "Et vous en faites quoi, de vos comptes ?")
  GAME:WaitFrames(8)

  --Il se detourne pour repondre : il regarde le fond de la carriere.
  pcall(function() GROUND:CharAnimateTurnTo(CH('Corboss'), Direction.Up, 6) end)
  say('Corboss', 'Normal', "Rien, pour l'instant.[pause=30] On regarde. On attend.")
  GAME:WaitFrames(10)
  say('Corboss', 'Normal', "Un jour, ce qui traine au fond n'appartiendra plus a personne.[pause=25] Ce jour-la, nous saurons ou chercher.")
  GAME:WaitFrames(18)

  --Depart : ils reprennent l'air sans hate. Plan large pour les suivre.
  cadre(228, 180, 50)
  disparaitre({'Corboss', 'Cornebre_Boss'})
  GAME:WaitFrames(10)

  --Le duo se retrouve seul. Il se tourne l'un vers l'autre : la scene se
  --referme sur eux, pas sur la menace.
  regarder('Teammate1', 'PLAYER', 5)
  regarder('PLAYER', 'Teammate1', 5)
  cadre(228, 228, 40)
  GAME:WaitFrames(12)

  say('partner', 'Angry', "Des charognards.[pause=25] Ils attendent que les autres tombent.")
  think(hero, 'Worried', "(Ils attendent.[pause=25] Mais ils attendent QUOI, exactement ?)")

  s.Act1Done = true
  s.CurrentAct = 2
  s.Known = true
end


--------------------------------------------------------------------
-- ACTE II — LE PILLAGE  (ch9, sortie des Marais Errants)
--
-- On arrive trop tard. La scene ne se joue pas contre la Meute : elle
-- se joue devant ce qu'elle a laisse. La confrontation vient apres,
-- et elle est verbale — Corboss ne se bat pas quand il peut parler.
--------------------------------------------------------------------
function MeuteArc.Act2(hero, partner)
  local s = sv()

  --Ouverture sur le sac, pas sur les personnages : l'objet est le sujet.
  cadre(248, 200, 1)
  GAME:WaitFrames(30)

  --Le duo entre dans le cadre et s'arrete net devant.
  local a1 = TASK:BranchCoroutine(function()
    pcall(function() GeneralFunctions.EightWayMove(hero, 240, 216, false, 1) end)
  end)
  local a2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(8)
    pcall(function() GeneralFunctions.EightWayMove(partner, 264, 216, false, 1) end)
  end)
  pcall(function() TASK:JoinCoroutines({a1, a2}) end)
  GAME:WaitFrames(10)

  pcall(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 4) end)
  pcall(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 4) end)
  GAME:WaitFrames(12)

  emote('Teammate1', 'shock')
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  say('partner', 'Shock', "Ce sac...[pause=20] c'est celui d'une equipe de la Guilde !")
  GAME:WaitFrames(10)

  --Le heros s'accroupit vers le sac : la camera resserre sur le detail.
  cadre(248, 204, 30)
  think(hero, 'Worried', "(Les provisions sont la.[pause=25] Seules les Orbes ont disparu.)")
  GAME:WaitFrames(14)

  --La voix de Cornebre arrive du hors-champ : on entend avant de voir.
  SOUND:PlayBattleSE('EVT_Emote_Exclaim_2')
  GAME:WaitFrames(10)
  surgir({
    {'Corboss',        296, 192, Direction.Left},
    {'Cornebre_Boss',  320, 208, Direction.Left},
  })
  cadre(280, 204, 40)
  GAME:WaitFrames(12)

  --Le duo pivote vers la droite, chacun depuis sa position.
  regarder('Teammate1', 'Corboss', 5)
  GAME:WaitFrames(3)
  regarder('PLAYER', 'Corboss', 5)
  GAME:WaitFrames(8)

  emote('Cornebre_Boss', 'happy')
  say('Cornebre_Boss', 'Happy', "Trois Orbes de Voyage, chef ![pause=20] Presque neuves !")
  GAME:WaitFrames(10)

  --Le partenaire fait un pas EN AVANT, seul. Le heros reste au sac.
  pcall(function() GeneralFunctions.EightWayMove(partner, 280, 216, false, 2) end)
  regarder('Teammate1', 'Corboss', 4)
  emote('Teammate1', 'angry')
  say('partner', 'Angry', "VOUS ![pause=20] Ou sont-ils ?! Qu'est-ce que vous leur avez fait ?!")
  GAME:WaitFrames(12)

  --Corboss ne bouge pas d'un pouce. C'est le contraste qui compte.
  cadre(296, 196, 30)
  say('Corboss', 'Normal', "Rien.[pause=30] Strictement rien.")
  GAME:WaitFrames(8)
  say('Corboss', 'Normal', "Ils etaient deja partis quand nous sommes arrives.[pause=25] Partis en courant, a en juger par le sac.")
  GAME:WaitFrames(14)

  say('partner', 'Angry', "Et vous avez pris ce qui restait.")
  emote('Corboss', 'happy')
  say('Corboss', 'Happy', "Nous avons ramasse ce qui pourrissait dans la boue.[pause=25] Nuance.")
  GAME:WaitFrames(12)

  think(hero, 'Sad', "(Il ment mal.[pause=25] Ou alors il ne ment pas du tout, et c'est pire.)")
  GAME:WaitFrames(10)

  --La question. Il descend d'un cran et s'adresse au heros, pas au
  --partenaire : il sait lequel des deux ecoute vraiment.
  pcall(function() GeneralFunctions.EightWayMove(CH('Corboss'), 280, 200, false, 1) end)
  regarder('Corboss', 'PLAYER', 6)
  cadre(268, 208, 35)
  GAME:WaitFrames(10)
  say('Corboss', 'Normal', "Posez-vous la vraie question, petits.[pause=25] Pas « qui a pris les Orbes ».")
  GAME:WaitFrames(10)
  emote('Corboss', 'question')
  say('Corboss', 'Worried', "« Qu'est-ce qui fait fuir une equipe entiere[pause=15] en abandonnant ses vivres ? »")
  GAME:WaitFrames(22)

  --Le partenaire n'a pas de reponse. Son silence est joue, pas ecrit.
  regarder('Teammate1', 'PLAYER', 5)
  emote('Teammate1', 'sweatdrop')
  GAME:WaitFrames(16)
  say('partner', 'Worried', "...")
  GAME:WaitFrames(10)

  say('Corboss', 'Normal', "Nous, nous partons avant que ca n'arrive.[pause=25] C'est notre metier de savoir quand.")
  GAME:WaitFrames(14)

  cadre(288, 190, 45)
  disparaitre({'Corboss', 'Cornebre_Boss'})
  GAME:WaitFrames(12)

  --Retour sur le sac, reste ouvert. L'objet ferme la scene comme il
  --l'avait ouverte.
  cadre(248, 206, 45)
  GAME:WaitFrames(16)
  regarder('Teammate1', 'PLAYER', 5)
  say('partner', 'Sad', "Je deteste l'admettre.[pause=25] Mais sa question est meilleure que la mienne.")
  think(hero, 'Determined', "(Une equipe entiere a fui.[pause=25] Il faut savoir devant quoi.)")

  s.Act2Done = true
  s.CurrentAct = 3
end


--------------------------------------------------------------------
-- ACTE III — LA BASCULE  (ch10, sortie des Falaises de l'Envol)
--
-- Le renversement. Corboss ne pille plus : il decampe, et il le dit.
-- Un charognard qui fuit, c'est un signe que rien d'autre ne donne.
-- Il laisse une information, pas par bonte : parce qu'il n'en a plus
-- l'usage.
--------------------------------------------------------------------
function MeuteArc.Act3(hero, partner)
  local s = sv()

  --Plan large et long sur des falaises vides. Le silence EST la scene :
  --on laisse le vide s'installer avant la moindre replique.
  cadre(248, 208, 1)
  SOUND:StopBGM()
  GAME:WaitFrames(45)

  local b1 = TASK:BranchCoroutine(function()
    pcall(function() GeneralFunctions.EightWayMove(hero, 240, 216, false, 1) end)
  end)
  local b2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    pcall(function() GeneralFunctions.EightWayMove(partner, 264, 216, false, 1) end)
  end)
  pcall(function() TASK:JoinCoroutines({b1, b2}) end)
  GAME:WaitFrames(15)

  --Ils cherchent des yeux : deux orientations differentes, personne ne
  --regarde au meme endroit.
  pcall(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 6) end)
  GAME:WaitFrames(8)
  pcall(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Right, 6) end)
  GAME:WaitFrames(20)
  emote('Teammate1', 'question')
  GAME:WaitFrames(18)

  --Corboss est deja la, seul, immobile. Pas de flash : la camera le
  --DECOUVRE en remontant. Il n'est pas arrive, il attendait.
  surgir({ {'Corboss', 248, 168, Direction.Down} })
  cadre(248, 180, 60)
  GAME:WaitFrames(25)

  regarder('Teammate1', 'Corboss', 5)
  GAME:WaitFrames(3)
  regarder('PLAYER', 'Corboss', 5)
  emote('Teammate1', 'notice')
  GAME:WaitFrames(12)

  say('partner', 'Surprised', "Vous ?[pause=20] Tout seul ?[pause=25] Ou est votre bande ?")
  GAME:WaitFrames(10)

  --Il regarde le sud avant de repondre. Le geste dit la reponse.
  pcall(function() GROUND:CharAnimateTurnTo(CH('Corboss'), Direction.DownRight, 8) end)
  GAME:WaitFrames(14)
  say('Corboss', 'Worried', "Partis.[pause=30] Je les ai envoyes au sud il y a deux jours.")
  GAME:WaitFrames(16)

  think(hero, 'Shock', "(Il a renvoye sa propre meute.[pause=25] Un charognard n'abandonne jamais un territoire.)")
  GAME:WaitFrames(12)

  regarder('Corboss', 'PLAYER', 6)
  say('partner', 'Worried', "Vous ne pillez plus ?")
  GAME:WaitFrames(8)
  say('Corboss', 'Sad', "Il n'y a plus rien a piller.[pause=25] C'est exactement le probleme.")
  GAME:WaitFrames(16)

  cadre(248, 174, 35)
  say('Corboss', 'Normal', "J'ai compte pendant des mois.[pause=25] Qui descend, qui remonte. Vous vous souvenez ?")
  GAME:WaitFrames(10)
  say('Corboss', 'Worried', "Depuis six jours, plus personne ne descend.[pause=25] Et ceux d'en haut sont partis les premiers.")
  GAME:WaitFrames(18)

  --Le partenaire leve les yeux vers les corniches vides.
  pcall(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 6) end)
  emote('Teammate1', 'shock')
  GAME:WaitFrames(14)
  say('partner', 'Shock', "Les Pokemon volants...[pause=25] Ils ont tous quitte les falaises.")
  GAME:WaitFrames(12)
  regarder('Teammate1', 'Corboss', 5)
  say('Corboss', 'Normal', "Nous sentons le vent avant vous.[pause=25] C'est le seul avantage d'etre ce que nous sommes.")
  GAME:WaitFrames(15)

  --LE DON D'INFORMATION. Resserrement maximal, puis secousse : le vent
  --qui monte se voit avant d'etre nomme.
  say('Corboss', 'Normal', "Alors je vais vous dire une chose,[pause=15] et nous serons quittes.")
  GAME:WaitFrames(12)
  cadre(248, 170, 25)
  SOUND:PlayBattleSE('DUN_Wind')
  pcall(function() BossFX.ShakeScreen(3, 30) end)
  GAME:WaitFrames(20)
  say('Corboss', 'Worried', "Le vent ne descend plus de la montagne.[pause=30] Il y MONTE.")
  GAME:WaitFrames(24)
  say('Corboss', 'Sad', "Quelque chose la-haut respire a l'envers.[pause=25] Et ca aspire tout le reste avec.")
  GAME:WaitFrames(22)

  think(hero, 'Determined', "(Le vent qui monte.[pause=25] Le Veilleur l'avait dit autrement, mais il l'avait dit.)")
  GAME:WaitFrames(14)

  cadre(248, 196, 40)
  say('partner', 'Worried', "Pourquoi nous dire ca ?[pause=25] Vous ne nous devez rien.")
  GAME:WaitFrames(12)

  regarder('Corboss', 'PLAYER', 6)
  say('Corboss', 'Normal', "Parce que vous montez quand meme.[pause=30] Et que je n'ai jamais compris les gens comme vous.")
  GAME:WaitFrames(10)
  emote('Corboss', 'happy')
  say('Corboss', 'Happy', "Si vous redescendez,[pause=20] j'aimerais assez etre la pour le noter.")
  GAME:WaitFrames(18)

  --Il part vers le sud, comme tous les autres. On le suit du regard.
  pcall(function() GROUND:CharAnimateTurnTo(CH('Corboss'), Direction.DownRight, 6) end)
  GAME:WaitFrames(10)
  cadre(272, 184, 55)
  disparaitre({'Corboss'})
  GAME:WaitFrames(18)

  --Le duo reste face au sud, puis se retourne vers la montagne : le
  --dernier geste de la scene est un choix, pas une replique.
  regarder('Teammate1', 'PLAYER', 5)
  say('partner', 'Determined', "Meme les charognards fuient.[pause=25] Nous, on monte.")
  GAME:WaitFrames(12)

  pcall(function() GROUND:CharAnimateTurnTo(CH('PLAYER'), Direction.Up, 8) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharAnimateTurnTo(CH('Teammate1'), Direction.Up, 8) end)
  cadre(248, 176, 60)
  GAME:WaitFrames(20)
  think(hero, 'Determined', "(Le vent monte.[pause=25] Alors on montera plus vite que lui.)")
  GAME:WaitFrames(15)

  s.Act3Done = true
  s.CurrentAct = 4
end


--------------------------------------------------------------------
-- ORDONNANCEMENT
--------------------------------------------------------------------
-- Un acte ne se joue que si le precedent est fait ET si le chapitre
-- courant correspond. On ne rejoue jamais un acte.
--------------------------------------------------------------------
local CH_OF_ACT = { [1] = 8, [2] = 9, [3] = 10 }

function MeuteArc.IsActReady(zoneID)
  local n = MeuteArc.ACTS[zoneID]
  if n == nil then return false end
  local s = sv()
  if s['Act' .. n .. 'Done'] then return false end
  if s.CurrentAct ~= n then return false end

  local ch = 0
  pcall(function() ch = SV.ChapterProgression.Chapter or 0 end)
  if ch < (CH_OF_ACT[n] or 99) then return false end
  return true
end

--------------------------------------------------------------------
-- MeuteArc.PlayAct(zoneID)
--
-- A appeler depuis le ExitSegment de la zone, sur une victoire.
-- Renvoie true si un acte a ete joue (l'appelant doit alors sortir en
-- mode cinematique), false sinon.
--------------------------------------------------------------------
function MeuteArc.PlayAct(zoneID)
  if not MeuteArc.IsActReady(zoneID) then return false end
  local n = MeuteArc.ACTS[zoneID]
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  PrintInfo("[MeuteArc] acte " .. tostring(n) .. " — " .. tostring(zoneID))
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  SOUND:PlayBGM('Team_Dazzling_Theme.ogg', true)
  GAME:WaitFrames(20)

  local body = ({ MeuteArc.Act1, MeuteArc.Act2, MeuteArc.Act3 })[n]
  local ok, err = pcall(body, hero, partner)
  if not ok then
    --Jamais d'ecran noir : on trace, on marque l'acte fait, on sort.
    PrintInfo("[MeuteArc] ERREUR acte " .. tostring(n) .. " : " .. tostring(err))
    local s = sv()
    s['Act' .. n .. 'Done'] = true
    s.CurrentAct = n + 1
  end

  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetCenter(false) end)
  GAME:WaitFrames(20)
  GAME:FadeOut(false, 40)
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)
  pcall(function()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
  end)
  GAME:CutsceneMode(false)
  return true
end

--Combien d'actes restent a voir ?
function MeuteArc.Remaining()
  local s = sv()
  local n = 0
  for i = 1, 3 do
    if not s['Act' .. i .. 'Done'] then n = n + 1 end
  end
  return n
end

return MeuteArc
