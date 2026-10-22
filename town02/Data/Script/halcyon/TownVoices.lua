--[[
    TownVoices.lua

    METANO PARLE — dialogues de ville reactifs a l'avancement
    ================================================================
    CONSTAT MESURE
    ------------------------------------------------------------------
    Chapitre 6 : 47 PNJ, 100 repliques au total. 42 d'entre eux n'ont
    que DEUX lignes, dont la plupart figees — le meme texte du debut a
    la fin du chapitre. La fonction Ch6State() distingue pourtant quatre
    moments (early / pre / during / post), mais presque personne ne s'en
    sert : la ville recite au lieu de vivre.

    CE QUE FAIT CE MODULE
    ------------------------------------------------------------------
    Une fiche par PNJ, avec jusqu'a CINQ etats. Le cinquieme est neuf :

      early    avant l'arrivee des rivales — la routine
      pre      les rivales sont la — la ville jase
      during   l'equipe est partie dans la foret — l'attente
      post     Zeraora est vaincu — le soulagement
      quests   les requetes sont rendues — la ville a ete AIDEE,
               et elle s'en souvient

    L'etat `quests` recompense le joueur qui a fait les requetes : les
    PNJ ne disent pas merci en boucle, ils parlent DIFFEREMMENT. C'est
    la difference entre une ville qui reagit et une ville qui remercie.

    PRINCIPE D'ECRITURE
    ------------------------------------------------------------------
    Une ville ne commente pas l'intrigue principale — elle vit a cote,
    et c'est par ses petits soucis qu'on mesure ce qui change. Le
    boulanger ne dit pas « la foret est en danger » : il dit que les
    livraisons du nord ont trois jours de retard.

    Chaque PNJ garde UN trait constant a travers ses cinq etats, pour
    qu'on le reconnaisse : Gulpin pense a manger, Machamp a
    l'entrainement, Wooper a jouer. Ce qui change, c'est ce que leur
    trait devient sous la pression des evenements.

    REGLES DU PROJET
      * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
      * La Voix ne parle jamais en ville.
      * Module global -> texte litteral.
      * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
      * Aucune replique existante n'est supprimee : ce module s'ajoute
        en amont et laisse la main si le PNJ n'a pas de fiche.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

TownVoices = {}

--------------------------------------------------------------------
-- ETAT DE LA VILLE
--------------------------------------------------------------------
-- Reprend la logique de Ch6State en y ajoutant l'etat `quests`, qui
-- prime sur `post` : rendre les requetes est le dernier jalon du
-- chapitre, donc le dernier etat de parole.
function TownVoices.State(ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  if ch == 6 then
    local c6 = SV.Chapter6 or {}
    if c6.MissionComplete then
      local ok = false
      pcall(function() ok = SideQuests ~= nil and SideQuests.AllDone(6) end)
      if ok then return 'quests' end
      return 'post'
    end
    if c6.MissionAccepted then return 'during' end
    if c6.DazzlingIntroPlayed then return 'pre' end
    return 'early'
  end

  --CHAPITRES 7 A 10. Les etats sont ceux des fichiers de chapitre
  --(Ch7State..Ch10State, releves un par un), pas des inventions. On les
  --replie sur le meme vocabulaire que le ch6 pour que les fiches restent
  --lisibles : early / pre / during / post / quests.
  --  'post'   = le donjon est fait, la ville respire
  --  'quests' = le dernier jalon du chapitre est franchi
  if ch == 7 then
    local c = SV.Chapter7 or {}
    if c.HadFirstDream or c.HeardGenesisTale then return 'quests' end
    if c.DefeatedRuinsBoss then return 'post' end
    if c.EnteredRuins then return 'during' end
    if c.RuinsAddressGiven then return 'pre' end
    return 'early'
  end

  if ch == 8 then
    local c = SV.Chapter8 or {}
    if c.ObtainedCrystalFragment then return 'quests' end
    if c.DefeatedDiancie then return 'post' end
    if c.EnteredSanctuary or c.ReachedCrystalRelay then return 'during' end
    if c.CrystalAddressGiven then return 'pre' end
    return 'early'
  end

  if ch == 9 then
    local c = SV.Chapter9 or {}
    if c.PurifiedMarshCore then return 'quests' end
    if c.DefeatedMegaBlastoise then return 'post' end
    if c.EnteredMarsh or c.SawCercleDuSuaire then return 'during' end
    if c.MarshAddressGiven then return 'pre' end
    return 'early'
  end

  if ch == 10 then
    local c = SV.Chapter10 or {}
    if c.SawNecrozmaVision then return 'quests' end
    if c.DefeatedLugia then return 'post' end
    if c.EnteredPeak or c.ReachedFulgurEncounter then return 'during' end
    if c.PeakAddressGiven then return 'pre' end
    return 'early'
  end

  return 'early'
end

--------------------------------------------------------------------
-- LES FICHES
--------------------------------------------------------------------
-- [Instance] = { emo, early, pre, during, post, quests }
-- Un etat absent retombe sur le precedent renseigne : on n'ecrit que
-- ce qui a une raison de changer.
TownVoices.CH6 = {

  ---- LES COMMERCANTS : le premier thermometre d'une ville ----
  Gulpin = { emo = 'Happy',
    early  = "Le marche est bien fourni ce matin ![pause=20] Je vais tout gouter. Par devoir.",
    pre    = "Trois etrangeres en ville et moi je pense au dejeuner.[pause=20] Chacun ses priorites.",
    during = "Les livraisons du nord ont trois jours de retard.[pause=25] Trois. C'est jamais arrive.",
    post   = "Un festin ![pause=15] Il faut celebrer ca avec un festin ![pause=20] Qui paye ?",
    quests = "Vous avez aide la moitie de la rue.[pause=25] Votre repas est offert. N'insistez pas." },

  Lickitung = { emo = 'Normal',
    early  = "Rien ne vaut un bon repas apres une longue journee.",
    pre    = "Ces trois-la mangent debout.[pause=20] Ca en dit long sur une equipe.",
    during = "J'ai mis de cote une part pour votre retour.[pause=25] Elle attendra le temps qu'il faudra.",
    post   = "Votre part vous attend toujours.[pause=20] Elle a un peu refroidi. Pas grave.",
    quests = "Vous avez couru partout pour tout le monde aujourd'hui.[pause=25] Asseyez-vous. C'est un ordre." },

  Bellossom = { emo = 'Worried',
    early  = "Les begonias sont magnifiques cette saison ![pause=15] Vous ne trouvez pas ?",
    pre    = "Elles ont regarde mon etal sans rien acheter.[pause=20] Grand bien leur fasse.",
    during = "Mon etal est a moitie vide et je n'ose pas dire pourquoi.",
    post   = "La foret respire, parait-il.[pause=25] Peut-etre que mes fleurs reviendront.",
    quests = "Je monte au nord demain, avec elle.[pause=25] A deux. Grace a vous." },

  Roselia = { emo = 'Sad',
    early  = "Je cueille au nord depuis dix ans.[pause=20] Je connais chaque sentier.",
    pre    = "Des explorateurs celebres en ville ?[pause=25] Ils ne monteront pas au nord, eux.",
    during = "Faites attention, la-haut.[pause=25] Ce n'est pas le danger qui fait peur. C'est le calme.",
    post   = "Vous etes revenus.[pause=25] Tout le monde ne revient pas, ces temps-ci.",
    quests = "On y va ensemble demain.[pause=25] Je ne pensais pas remonter un jour." },

  ---- LES ENFANTS : ils repetent ce que les adultes taisent ----
  Wooper_Boy = { emo = 'Happy',
    early  = "On joue a l'exploration ![pause=15] Moi je suis le chef !",
    pre    = "T'as vu les trois dames ?[pause=20] Elles sont trop classe. Meme la grincheuse.",
    during = "Maman veut plus qu'on aille jouer pres des arbres.[pause=25] Elle dit pas pourquoi.",
    post   = "Vous avez battu le monstre de la foret ?![pause=20] POUR DE VRAI ?",
    quests = "Papa dit que vous etes des vrais explorateurs.[pause=25] Pas ceux des affiches. Des vrais." },

  Wooper_Girl = { emo = 'Normal',
    early  = "Un jour j'aurai ma propre equipe ![pause=15] Avec un nom qui claque !",
    pre    = "J'ai compte : elles ont trois badges chacune.[pause=20] Nous on en aura dix.",
    during = "Les grands chuchotent quand on entre.[pause=25] Ils croient qu'on remarque pas.",
    post   = "Racontez ![pause=15] Racontez tout ! Le monstre etait grand comment ?",
    quests = "J'ai aide Madame Bellossom a ranger, moi aussi.[pause=25] C'est un debut, non ?" },

  Marill = { emo = 'Happy',
    early  = "Un jour je serai explorateur ![pause=15] Comme vous !",
    pre    = "Elles ont des costumes assortis ![pause=20] Nous il nous faut des costumes.",
    during = "Vous revenez quand ?[pause=25] J'ai plein de questions en attente.",
    post   = "Vous etes revenus ENTIERS ![pause=20] C'est la meilleure partie !",
    quests = "Je m'entraine tous les matins maintenant.[pause=25] Tous. Les. Matins." },

  ---- LES ANCIENS : ils comparent avec avant ----
  Nidoking = { emo = 'Normal',
    early  = "J'ai bourlingue en mon temps.[pause=20] Les routes etaient plus sures. Ou j'etais plus bete.",
    pre    = "Des professionnelles.[pause=25] On voit ca a la facon dont elles regardent les sorties.",
    during = "Deux gamins partis dans la Foret Lugubre.[pause=25] De mon temps on y allait a six.",
    post   = "A deux.[pause=30] Vous y etes alles a deux et vous en etes revenus.",
    quests = "Vous avez rendu service a la moitie du quartier apres CA.[pause=25] Ou vous prenez l'energie ?" },

  Nidorina = { emo = 'Worried',
    early  = "Ne rentrez pas trop tard, les jeunes.[pause=20] Il fait vite noir.",
    pre    = "Elles n'ont pas dit bonjour en arrivant.[pause=20] Ca aussi, c'est un choix.",
    during = "Je n'aime pas savoir des petits dans cette foret.[pause=25] Je n'aime pas ca du tout.",
    post   = "Venez la que je vous regarde.[pause=25] ...Pas une egratignure. Bien.",
    quests = "Vous avez ecoute tout le monde aujourd'hui.[pause=25] C'est plus rare que le courage." },

  Medicham = { emo = 'Normal',
    early  = "Le corps suit l'esprit.[pause=20] Entrainez les deux.",
    pre    = "Celle qui mene garde son calme.[pause=25] C'est ce qui la rend dangereuse.",
    during = "Respirez avant d'entrer dans la foret.[pause=25] La peur passe. Elle passe toujours.",
    post   = "Vous avez tenu.[pause=25] Ce n'est pas la force qui tient : c'est le souffle.",
    quests = "Servir apres avoir vaincu.[pause=30] Voila un equilibre que peu atteignent." },

  ---- LES GARDIENS : ils comptent, ils surveillent ----
  Machamp = { emo = 'Determined',
    early  = "Chaque matin, cent pompes.[pause=15] Chaque soir, cent de plus.",
    pre    = "J'ai propose un bras de fer a la grande.[pause=25] Elle a refuse. Sagement.",
    during = "Si vous avez besoin d'un bras solide la-bas,[pause=20] vous savez ou me trouver.",
    post   = "Vous n'aviez pas besoin de mes bras.[pause=25] Bien joue quand meme.",
    quests = "Porter les caisses des autres, c'est aussi de l'entrainement.[pause=25] Le plus dur, meme." },

  Manectric = { emo = 'Worried',
    early  = "Electrike est agite.[pause=20] Il sent les choses avant nous.",
    pre    = "Il a grogne quand elles sont passees.[pause=25] Il ne grogne jamais.",
    during = "Il fixe le nord depuis ce matin.[pause=25] Il ne mange plus.",
    post   = "Il s'est rendormi.[pause=25] C'est le meilleur signe que je puisse vous donner.",
    quests = "Il vous suit du regard maintenant.[pause=25] Chez lui, c'est de l'affection." },

  Luxray = { emo = 'Normal',
    early  = "La guilde vous soutient.[pause=15] Toujours. Ne l'oubliez jamais.",
    pre    = "Trois exploratrices confirmees en ville.[pause=20] Je les ai a l'oeil.",
    during = "Allez, [player].[pause=15] La foret n'attend pas.",
    post   = "Rapport recu.[pause=25] Et... bien joue. Ce n'est pas dans le rapport, ca.",
    quests = "Trois requetes rendues le meme jour.[pause=25] Metano vous doit une soiree tranquille." },

  ---- LES REVEURS ET LES DISTRAITS ----
  Spinda = { emo = 'Happy',
    early  = "La vie tourne ![pause=15] Comme moi ![pause=20] Enfin, elle, elle sait ou elle va.",
    pre    = "Elles tournent pas, elles.[pause=20] Elles avancent droit. Ca doit etre pratique.",
    during = "J'ai le tournis rien qu'a penser a cette foret.[pause=25] Alors j'y pense pas.",
    post   = "Vous etes revenus ![pause=20] Moi j'ai pas bouge. Mais j'ai pense a vous. En tournant.",
    quests = "Tout le monde parle de vous aujourd'hui.[pause=25] Meme moi, et je parle surtout tout seul." },

  Ludicolo = { emo = 'Happy',
    early  = "Un peu de musique et tout va mieux ![pause=15] C'est prouve.",
    pre    = "J'ai joue pour elles.[pause=25] La petite aux oreilles a danse. Les deux autres, non.",
    during = "Je garde un air de cote pour votre retour.[pause=25] Un air joyeux, hein.",
    post   = "L'AIR JOYEUX ![pause=20] Je l'avais garde ! Ecoutez ca !",
    quests = "Trois bonnes actions et une victoire.[pause=25] Ca merite un morceau entier." },

  Jigglypuff = { emo = 'Normal',
    early  = "Je travaille une nouvelle berceuse.[pause=20] Personne ne s'est encore endormi. Progres.",
    pre    = "Elles ne m'ont pas ecoutee jusqu'au bout.[pause=25] Personne ne m'ecoute jusqu'au bout.",
    during = "Je chanterai pour vous quand vous rentrerez.[pause=25] Si vous rentrez. Non — QUAND.",
    post   = "Vous etes rentres ![pause=20] Asseyez-vous, j'ai une berceuse a finir.",
    quests = "Vous vous etes endormis pendant ma chanson.[pause=30] ...C'est un compliment. Je crois." },

  ---- LES INQUIETS ----
  Vileplume = { emo = 'Worried',
    early  = "Les fleurs du nord ont un mois de retard.[pause=20] Un mois.",
    pre    = "Elles viennent de la cote, parait-il.[pause=25] La-bas aussi les saisons se decalent ?",
    during = "Je regarde vers la foret toutes les dix minutes.[pause=25] Ca ne sert a rien. Je continue.",
    post   = "Une seule fleur a rouvert ce matin.[pause=25] Une seule. Mais elle a rouvert.",
    quests = "Vous vous etes occupes de nous tous.[pause=25] Prenez cette fleur. Elle est la premiere." },

  Gloom = { emo = 'Sad',
    early  = "Je ne me sens pas tres bien...[pause=20] Ca doit etre la saison.",
    pre    = "Du monde en ville, du bruit...[pause=25] J'aime autant rester dans mon coin.",
    during = "L'air est lourd depuis des jours.[pause=25] Vous le sentez aussi, ou c'est moi ?",
    post   = "C'est plus leger.[pause=30] Depuis ce matin, c'est vraiment plus leger.",
    quests = "Je respire mieux.[pause=25] Je ne sais pas si c'est la foret ou vous." },

  Oddish = { emo = 'Worried',
    early  = "Je grandis lentement.[pause=20] On me le dit tous les jours.",
    pre    = "Trois grandes dames fortes.[pause=25] Moi j'arrive meme pas a la hauteur du comptoir.",
    during = "Vous etes partis loin ?[pause=25] Moi je suis jamais sorti de la rue.",
    post   = "Vous etes alles dans la GRANDE foret.[pause=25] Un jour, peut-etre. Un jour.",
    quests = "Vous avez aide Madame Bellossom.[pause=25] Moi aussi je peux aider. Je vais demander." },

  ---- LES PRATIQUES ----
  Furret = { emo = 'Normal',
    early  = "Il faut manger avant de partir.[pause=20] Regle numero un.",
    pre    = "Elles ont refuse le petit-dejeuner.[pause=25] On ne peut pas leur faire confiance.",
    during = "Je vous garde une part.[pause=25] Une VRAIE part, cette fois.",
    post   = "Mangez d'abord.[pause=20] Racontez ensuite. Dans cet ordre.",
    quests = "Deux parts pour le petit, comme promis.[pause=25] Et une pour vous. Assis." },

  Linoone = { emo = 'Normal',
    early  = "Toujours en mouvement, moi.[pause=15] Rester assis, c'est rouiller.",
    pre    = "Je les ai vues arriver par la route est.[pause=20] Pas un grain de poussiere sur elles.",
    during = "J'ai fait trois fois le tour de la ville en vous attendant.[pause=25] Trois fois.",
    post   = "Vous voila ![pause=20] Je commencais a user mes pattes.",
    quests = "Vous avez traverse la ville dix fois aujourd'hui.[pause=25] Enfin quelqu'un qui bouge autant que moi." },

  Sentret = { emo = 'Worried',
    early  = "Je surveille depuis mon poste.[pause=20] Rien a signaler.",
    pre    = "Trois arrivees, zero depart.[pause=25] Je note tout.",
    during = "Deux departs vers le nord ce matin.[pause=25] Zero retour pour l'instant.",
    post   = "Deux retours ![pause=20] Le compte est bon. Enfin.",
    quests = "J'ai note vos allees et venues.[pause=25] Vingt-deux traversees. Vous devriez vous asseoir." },

  ---- LES ARTISANS ET LES CURIEUX ----
  Cranidos = { emo = 'Determined',
    early  = "Quoi ?[pause=15] Je peux pas me reposer un peu ?",
    pre    = "Ces trois-la ont l'air solide.[pause=20] Je testerais bien un coup de tete.",
    during = "Vous auriez du m'emmener.[pause=25] J'aurais defonce quelque chose. N'importe quoi.",
    post   = "Vous l'avez eu SANS MOI ?![pause=25] ...Bon. Bravo quand meme.",
    quests = "Aider les gens toute la journee...[pause=25] c'est plus fatigant qu'un donjon, hein ?" },

  Mareep = { emo = 'Normal',
    early  = "Le temps se rafraichit.[pause=20] Ma laine s'epaissit deja.",
    pre    = "Elles n'ont pas froid, elles.[pause=25] Ou elles font semblant.",
    during = "J'ai tricote en vous attendant.[pause=25] Je tricote toujours quand je m'inquiete.",
    post   = "J'ai fini deux echarpes.[pause=25] Ca vous dit l'ampleur de mon inquietude.",
    quests = "Prenez-en une.[pause=25] Non, ce n'est pas negociable." },

  Metapod = { emo = 'Normal',
    early  = "...",
    pre    = "...![pause=20] (Il semble suivre les nouvelles venues du regard.)",
    during = "...[pause=25] (Il fixe la route du nord sans bouger.)",
    post   = "...![pause=20] (Il fremit. C'est sans doute de la joie.)",
    quests = "...[pause=30] (Il s'incline tres legerement. Ca lui a pris du temps.)" },

  Silcoon = { emo = 'Normal',
    early  = "...",
    pre    = "...[pause=20] (Elle s'est tournee vers la place, curieuse.)",
    during = "...[pause=25] (Elle est restee tournee vers le nord toute la journee.)",
    post   = "...![pause=20] (Elle se balance doucement. Soulagee ?)",
    quests = "...[pause=25] (Elle s'est rapprochee de vous. Un tout petit peu.)" },
}

--------------------------------------------------------------------
-- INTERACTION
--------------------------------------------------------------------
-- Renvoie true si une replique a ete jouee. Le ground enchaine sur son
-- dialogue d'origine sinon : aucun PNJ ne perd sa voix existante.
local ORDER = { 'early', 'pre', 'during', 'post', 'quests' }

function TownVoices.Talk(inst, ch)
  ch = ch or (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 0
  if ch ~= 6 then return false end
  local fiche = TownVoices.CH6[inst]
  if fiche == nil then return false end
  local chara = CH(inst)
  if chara == nil then return false end

  local st = TownVoices.State(ch)
  --Repli en cascade : un etat non renseigne retombe sur le precedent.
  local txt = nil
  for _, k in ipairs(ORDER) do
    if fiche[k] ~= nil then txt = fiche[k] end
    if k == st then break end
  end
  if txt == nil then return false end

  local ok = pcall(function()
    GeneralFunctions.StartConversation(chara, txt, fiche.emo or 'Normal')
    GeneralFunctions.EndConversation(chara)
  end)
  return ok
end

--Combien de PNJ ce module fait-il parler ?
function TownVoices.Count()
  local n = 0
  for _ in pairs(TownVoices.CH6) do n = n + 1 end
  return n
end

return TownVoices
