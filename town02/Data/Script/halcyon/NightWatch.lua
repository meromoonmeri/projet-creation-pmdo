--[[
    NightWatch.lua

    LE TOUR DE GUET
    ================================================================
    LE PROBLEME QUE CE MODULE RESOUT
    ------------------------------------------------------------------
    Jusqu'ici, sortir la nuit etait une lubie : le heros quittait son lit
    sans raison, se promenait dans une ville endormie, et rentrait. Rien
    n'expliquait POURQUOI il etait dehors, ni pourquoi personne ne lui
    en faisait le reproche. Le systeme fonctionnait, mais il flottait
    a cote de l'histoire.

    Le tour de guet resout ca d'un coup. La guilde protege Metano ; les
    equipes se relaient pour veiller la nuit ; quand vient le tour du
    heros, il SORT PARCE QUE C'EST SON DEVOIR. La promenade nocturne
    n'est plus une option bizarre, c'est une mission. Et les pillards
    ne sont plus une agression gratuite : ils sont exactement ce contre
    quoi on monte la garde.

    ------------------------------------------------------------------
    L'ENCHAINEMENT
    ------------------------------------------------------------------
      1. PREMIERE FOIS (ch6) — le tour de guet est IMPOSE. Une scene
         explique l'usage : le registre, le relais, ce qu'on fait si on
         voit quelque chose. Le joueur n'a pas le choix, et c'est bien :
         c'est ainsi qu'on apprend une regle du monde.
      2. ENSUITE — le choix libre de fin de journee reprend la main. Le
         joueur sait desormais qu'il PEUT prendre la garde quand il veut,
         et le menu de TownNight prend son sens.
      3. DE TEMPS EN TEMPS — la guilde le lui redemande (tour impose),
         ce qui justifie de retourner en ville la nuit sans que ce soit
         une lubie.

    ------------------------------------------------------------------
    OU CA S'ACCROCHE (points verifies dans le depot)
    ------------------------------------------------------------------
    * guild_heros_room.PlotScripting (init.lua:208) lit
      SV.TemporaryFlags.Bedtime et appelle guild_heros_room_helper
      .Bedtime(true) : c'est la que le duo se couche. On s'insere AVANT
      le coucher, pour que le tour de guet remplace la nuit de sommeil.
    * GeneralFunctions.EndOfDay (GeneralFunctions.lua:63) incremente
      DaysPassed puis UpdateDailyFlags. On ne le double pas : le tour de
      guet se termine par le circuit de coucher habituel.
    * SV.ChapterProgression.DaysPassed sert a espacer les tours.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici : la garde est un devoir concret.
    * Ne nomme aucun personnage des jeux d'origine.
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

NightWatch = {}

--------------------------------------------------------------------
-- HELPERS
--------------------------------------------------------------------
local function say(partner, emo, txt)
  if partner == nil then return end
  UI:SetSpeaker(partner)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(8)
end

local function think(hero, emo, txt)
  if hero == nil then return end
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

--------------------------------------------------------------------
-- ETAT
--------------------------------------------------------------------
function NightWatch.Ensure()
  if SV.NightWatch == nil then SV.NightWatch = {} end
  local s = SV.NightWatch
  if s.Explained == nil then s.Explained = false end  --la regle a ete enseignee
  if s.Tours == nil then s.Tours = 0 end              --tours de garde effectues
  if s.LastTour == nil then s.LastTour = -1 end       --DaysPassed du dernier tour
  if s.Assigned == nil then s.Assigned = false end    --un tour est impose ce soir
  return s
end

--------------------------------------------------------------------
-- LA GUILDE IMPOSE-T-ELLE UN TOUR CE SOIR ?
--------------------------------------------------------------------
-- Deux cas :
--   * le tout premier tour, au ch6 : impose, c'est la lecon ;
--   * ensuite, environ une nuit sur cinq, jamais deux soirs de suite.
--
-- On ne double jamais une scene imposee par le scenario : si le
-- chapitre reclame un diner ou une reunion, la garde attend.
function NightWatch.IsAssigned()
  local ch = (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
  if ch < 6 then return false end

  local s = NightWatch.Ensure()
  local t = SV.TemporaryFlags or {}
  --Priorite absolue au scenario : memes drapeaux que TownNight.StoryLocked.
  if t.MissionCompleted or t.MorningWakeup or t.MorningAddress then return false end

  --Le premier tour est toujours impose : c'est lui qui enseigne la regle.
  if not s.Explained then return true end

  local today = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
  if s.LastTour == today then return false end
  if s.LastTour >= 0 and (today - s.LastTour) < 3 then return false end

  local roll = 0
  pcall(function() roll = math.random(1, 5) end)
  return roll == 1
end

--------------------------------------------------------------------
-- LA CINEMATIQUE DU PREMIER TOUR — la regle du monde
--------------------------------------------------------------------
-- C'est la scene qui donne du sens a tout le systeme. Elle doit
-- expliquer, sans peser : on montre un usage ancien, pas un reglement.
--
-- Elle ne nomme personne des jeux d'origine et ne designe aucun
-- coupable : la garde existe « parce qu'elle a toujours existe ».
local function FirstWatchScene(hero, partner)
  narrate("On frappe a la porte.[pause=30] Trois coups brefs. C'est un code.")
  GAME:WaitFrames(20)

  say(partner, 'Surprised', "À cette heure ?[pause=25] Attends, je vais voir.")
  GAME:WaitFrames(15)
  narrate("Un registre est glisse sous la porte.[pause=25] Une page est cornee.")
  GAME:WaitFrames(15)

  say(partner, 'Normal', "C'est le registre des veilles.[pause=30] Notre nom est inscrit pour ce soir.")
  think(hero, 'Worried', "(Le registre des veilles.[pause=25] Personne ne nous en a jamais parle.)")
  GAME:WaitFrames(15)

  say(partner, 'Normal', "Chaque équipe de la guilde y passe.[pause=25] Une nuit, à tour de rôle.")
  say(partner, 'Normal', "Pendant que la ville dort, quelqu'un marche dehors.[pause=30] C'est comme ça depuis toujours.")
  GAME:WaitFrames(15)

  think(hero, 'Normal', "(Alors les rues n'ont jamais été vides.[pause=25] Il y avait toujours quelqu'un.)")
  GAME:WaitFrames(10)

  say(partner, 'Sad', "Les anciens disent que ça remonte à la fondation.[pause=30] Avant même la guilde.")
  say(partner, 'Sad', "Personne ne se souvient de ce qu'on guettait au début.[pause=25] On a gardé l'habitude.")
  GAME:WaitFrames(20)

  --La consigne pratique, en trois points. Courte : c'est un usage, pas
  --un manuel. Le joueur retient « marcher, regarder, ne pas reveiller ».
  narrate("Sur la page cornee, trois lignes.[pause=30] Toujours les memes, depuis des annees.")
  GAME:WaitFrames(15)
  narrate("« Marcher jusqu'a l'aube. »")
  narrate("« Regarder, meme quand il n'y a rien. »")
  narrate("« Ne reveiller personne, sauf s'il le faut vraiment. »")
  GAME:WaitFrames(20)

  say(partner, 'Determined', "Bon.[pause=25] On y va ?")
  think(hero, 'Normal', "(La ville dort. Et cette nuit, c'est nous qui la regardons dormir.)")
  GAME:WaitFrames(15)
  say(partner, 'Happy', "J'avoue que ça me fait quelque chose.[pause=30] C'est notre tour, maintenant.")
end

--------------------------------------------------------------------
-- LES TOURS SUIVANTS — court, varie, jamais la meme phrase
--------------------------------------------------------------------
local function LaterWatchScene(hero, partner, tours)
  if tours == 1 then
    narrate("Le registre passe de nouveau sous la porte.[pause=25] Notre nom, encore.")
    say(partner, 'Normal', "Deuxième tour.[pause=25] On commence à avoir l'habitude.")
    think(hero, 'Normal', "(La première fois, j'ai trouvé ça long.[pause=25] Plus maintenant.)")
  elseif tours == 2 then
    narrate("Cette fois, vous entendez venir avant les trois coups.")
    say(partner, 'Happy', "Je l'ai reconnu à sa façon de marcher ![pause=30] On progresse.")
    say(partner, 'Normal', "Allez.[pause=20] La ville nous attend.")
  else
    narrate("Le registre est deja sur la table.[pause=25] Vous ne l'avez pas entendu arriver.")
    say(partner, 'Normal', "Encore nous.[pause=30] Je crois qu'ils nous mettent plus souvent qu'avant.")
    think(hero, 'Worried', "(Ou alors il y a moins d'équipes disponibles qu'avant.)")
    say(partner, 'Determined', "Ne pensons pas à ça.[pause=25] Sortons.")
  end
end

--------------------------------------------------------------------
-- LE TOUR DE GUET
--------------------------------------------------------------------
-- Appelee depuis la chambre, AVANT le coucher. Renvoie true si la garde
-- a bien ete prise (auquel cas l'appelant ne doit PAS coucher le duo).
function NightWatch.Begin()
  local s = NightWatch.Ensure()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local premier = not s.Explained

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:FadeOutBGM(20)
    GAME:WaitFrames(20)

    if premier then
      FirstWatchScene(hero, partner)
    else
      LaterWatchScene(hero, partner, s.Tours)
    end
  end)
  if not ok then PrintInfo('[NightWatch.Begin] scene ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)

  s.Explained = true
  s.Tours = s.Tours + 1
  s.LastTour = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
  s.Assigned = true

  --On part en ville de nuit. Les drapeaux de coucher seront poses par
  --TownNight.GoHome() au retour, comme pour une sortie volontaire :
  --le circuit de fin de journee reste unique.
  pcall(function()
    SV.TemporaryFlags.Bedtime = false
    SOUND:FadeOutBGM(40)
    GAME:FadeOut(false, 40)
    GAME:EnterGroundMap('metano_town_nuit', 'entrance')
  end)
  return true
end

--------------------------------------------------------------------
-- CE QUE LE TOUR DE GUET CHANGE POUR LES PILLARDS
--------------------------------------------------------------------
-- Une nuit de garde a plus de chances d'etre agitee qu'une promenade :
-- c'est justement les nuits ou l'on veille que quelque chose arrive.
-- TownRaid interroge cette fonction pour ajuster son tirage.
function NightWatch.IsOnDuty()
  local s = NightWatch.Ensure()
  return s.Assigned == true
end

--Fin du tour : appelee quand le joueur rentre se coucher.
function NightWatch.End()
  local s = NightWatch.Ensure()
  s.Assigned = false
end

--------------------------------------------------------------------
-- LE RAPPORT DE GARDE — au matin
--------------------------------------------------------------------
-- Un devoir accompli doit etre reconnu, sinon ce n'etait pas un devoir.
-- Court : deux boites, pas plus. Le lendemain appartient au chapitre.
function NightWatch.Report()
  local s = NightWatch.Ensure()
  local raid = SV.TownRaid or {}

  return pcall(function()
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    if (raid.Repelled or 0) > 0 and raid.LastDay == s.LastTour then
      UI:WaitShowDialogue("Vous inscrivez la nuit au registre.[pause=30] Une ligne de plus que d'habitude.")
      UI:WaitShowDialogue("« Rien à signaler » aurait été plus simple à écrire.")
    else
      UI:WaitShowDialogue("Vous inscrivez la nuit au registre.[pause=25] « Rien à signaler. »")
      UI:WaitShowDialogue("C'est la meilleure chose qu'on puisse y écrire.")
    end
    UI:SetCenter(false)
    UI:ResetSpeaker()
  end)
end

return NightWatch
