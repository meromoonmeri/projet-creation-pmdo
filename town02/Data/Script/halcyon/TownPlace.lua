--[[
    TownPlace.lua

    LE RACCORD ENTRE OU UN PNJ SE TROUVE ET CE QU'IL DIT
    ================================================================
    LE DEFAUT CORRIGE
    ------------------------------------------------------------------
    Deux systemes existaient cote a cote sans jamais se parler :

      npc_routines.lua   deplace 16 PNJ dans Metano selon le jour et
                         l'heure (ROUTE_POINTS + AI de flanerie).
      TownVoices/Arc     leur donne un dialogue selon l'avancement du
                         chapitre.

    Dix PNJ ont les deux — Bagon, Bellossom, Furret, Gloom, Linoone,
    Oddish, Roselia, Sentret, Wooper_Boy, Wooper_Girl — et pourtant leur
    replique ne depend jamais de l'endroit ou ils se trouvent. Roselia
    tient le meme propos qu'elle soit a son etal du marche ou au bord de
    la riviere.

    C'est exactement ce que systeme_raid_ville_vivante.md interdit au
    point 5 :

        « un PNJ qui a un nouveau dialogue mais reste a une position qui
          ne correspond plus au contexte casse autant l'immersion qu'un
          dialogue perime »

    et au point 3 : « chaque changement de position doit renforcer
    l'impression que ce PNJ a une vie propre ».

    CE QUE FAIT CE MODULE
    ------------------------------------------------------------------
    Il lit la position REELLE du personnage en jeu, la rapproche du lieu
    connu le plus proche, et rend une phrase d'ancrage propre au couple
    (PNJ, lieu). Cette phrase se place AVANT la replique de chapitre :
    on entend d'abord ou l'on est, ensuite ce qui se passe.

        Roselia au marche     « Mon etal est monte de travers ce matin. »
        Roselia a la riviere  « Je rince mes tiges ici. L'eau est plus
                                douce qu'au puits. »

    Le lieu n'est PAS devine depuis la routine (qui decrit une intention
    de deplacement) mais depuis chara.Position : c'est la seule source
    qui dise ou le PNJ est vraiment, y compris apres sa flanerie libre.

    REGLES DU PROJET
      * Module global -> texte litteral, pas de .resx.
      * 1 a 2 phrases, < 150 caracteres hors [pause=N].
      * Aucun nom des jeux d'origine, aucun terme interdit.
      * Degradation silencieuse : sans fiche, sans position lisible ou
        trop loin de tout lieu connu, le module se tait et laisse le
        dialogue de chapitre s'executer seul.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

TownPlace = {}

--------------------------------------------------------------------
-- LES LIEUX
-- Coordonnees relevees sur les entites reelles de metano_town.rsground
-- et validees par tools/verify_npc_routes.py (libres, accessibles a
-- pied depuis l'entree de la ville).
-- `rayon` : distance en pixels au-dela de laquelle on considere que le
-- PNJ n'est pas « a » ce lieu. Large pour les places, serre pour les
-- points precis, afin que deux lieux voisins ne se disputent pas un PNJ.
--------------------------------------------------------------------
local LIEUX = {
  { id = 'marche',   x = 952,  y = 864,  rayon = 190 },
  { id = 'puits',    x = 672,  y = 200,  rayon = 170 },
  { id = 'bassin',   x = 744,  y = 432,  rayon = 150 },
  { id = 'cafe',     x = 1144, y = 592,  rayon = 160 },
  { id = 'riviere',  x = 312,  y = 560,  rayon = 200 },
  { id = 'etang',    x = 992,  y = 392,  rayon = 150 },
  { id = 'dojo',     x = 920,  y = 1160, rayon = 170 },
  { id = 'maisons',  x = 680,  y = 584,  rayon = 160 },
  { id = 'tentes',   x = 784,  y = 1120, rayon = 170 },
  { id = 'guilde',   x = 728,  y = 576,  rayon = 150 },
  { id = 'pature',   x = 400,  y = 1040, rayon = 190 },
  { id = 'donjons',  x = 160,  y = 880,  rayon = 200 },
}

--------------------------------------------------------------------
-- LES ANCRAGES
-- [PNJ][lieu] = phrase. On n'ecrit que les couples qui ont un sens :
-- un PNJ sans entree pour le lieu ou il se trouve reste muet, et c'est
-- voulu — mieux vaut le silence qu'un remplissage.
--------------------------------------------------------------------
TownPlace.LINES = {

  Roselia = {
    marche  = "Mon etal est monte de travers ce matin.[pause=20] Le vent, sans doute.",
    riviere = "Je rince mes tiges ici.[pause=20] L'eau est plus douce qu'au puits.",
    puits   = "Je remplis mes arrosoirs avant la foule.[pause=20] Apres, c'est la queue.",
    pature  = "Les fleurs sauvages d'ici valent mieux que les miennes.[pause=25] Ne le repetez pas.",
    tentes  = "Les marchands de passage achetent mes invendus.[pause=20] Tout le monde y gagne.",
  },

  Bellossom = {
    marche  = "Deux etals a moi toute seule aujourd'hui.[pause=20] J'ai les petales en vrac.",
    bassin  = "Je viens danser pres de l'eau quand personne ne regarde.[pause=25] ...Vous n'avez rien vu.",
    pature  = "L'herbe haute me chatouille les chevilles.[pause=20] C'est agreable.",
    riviere = "Le courant emporte les petales que je perds.[pause=25] Ca fait une jolie trainee.",
  },

  Gloom = {
    riviere = "Je me tiens au bord pour que le courant emporte mon odeur.[pause=25] C'est plus courtois.",
    pature  = "Ici, personne ne se plaint.[pause=20] Il n'y a que des herbes.",
    maisons = "Je passe vite devant les fenetres.[pause=25] Question de savoir-vivre.",
    etang   = "L'eau stagnante me convient.[pause=20] A moi, et a personne d'autre.",
  },

  Oddish = {
    pature  = "La terre est meuble ici ![pause=20] Je peux m'enfouir jusqu'aux feuilles !",
    marche  = "Il y a trop de pieds.[pause=25] Je reste sous l'etal, c'est plus sur.",
    puits   = "L'eau du puits est fraiche.[pause=20] Mes racines adorent.",
    maisons = "Je rentre avant la nuit.[pause=20] Maman compte les feuilles.",
  },

  Furret = {
    maisons = "Je compte les petits deux fois par jour.[pause=25] Trois, quand il vente.",
    marche  = "Je fais les courses pour toute la famille.[pause=20] Ca fait beaucoup de courses.",
    tentes  = "Les marchands me font credit.[pause=25] Ils savent que je rembourse toujours.",
    pature  = "Les petits courent devant.[pause=20] Je les rattrape. Toujours.",
  },

  Linoone = {
    donjons = "C'est d'ici que je pars quand il faut porter un message.[pause=25] Je connais chaque virage.",
    marche  = "Je livre pour trois etals.[pause=20] En courant. Evidemment.",
    riviere = "Je bois vite et je repars.[pause=25] Le temps ne se rattrape pas.",
    guilde  = "J'attends qu'on me confie quelque chose a porter.[pause=25] Ca ne tarde jamais.",
  },

  Sentret = {
    guilde  = "De ma queue, je vois par-dessus le pont.[pause=25] Rien a signaler pour l'instant.",
    marche  = "Je surveille les etals pendant que les marchands mangent.[pause=25] Sans salaire.",
    maisons = "Depuis les toits, on voit toute la ville.[pause=20] Et un peu au-dela.",
    donjons = "Je guette la route.[pause=25] Ceux qui reviennent, surtout.",
  },

  Bagon = {
    dojo    = "Je m'entraine a tomber correctement.[pause=25] C'est la moitie du vol, parait-il.",
    guilde  = "Un jour je sauterai du pont.[pause=25] Quand j'aurai des ailes. Pas avant.",
    maisons = "Je grimpe sur les toits pour m'entrainer.[pause=25] Les proprietaires ne sont pas d'accord.",
    pature  = "Terrain degage, sol meuble.[pause=20] Parfait pour s'ecraser sans temoin.",
  },

  Wooper_Boy = {
    bassin  = "On fait la course dans l'eau ![pause=20] Je gagne toujours. Presque toujours.",
    etang   = "L'etang est a nous ![pause=15] Enfin, a nous deux.",
    riviere = "Le courant nous porte jusqu'au pont.[pause=25] Papa n'aime pas trop.",
    marche  = "On a le droit a une friandise par semaine.[pause=25] C'est aujourd'hui.",
  },

  Wooper_Girl = {
    bassin  = "Je fais des ronds dans l'eau.[pause=20] Mon frere fait des vagues. Ce n'est pas pareil.",
    etang   = "J'ai vu un poisson gros comme moi ![pause=20] ...Presque comme moi.",
    riviere = "Je reste au bord.[pause=25] Le milieu, c'est pour les grands.",
    maisons = "Je dessine sur le pas de la porte.[pause=25] Regardez, c'est vous !",
  },
}


--------------------------------------------------------------------
-- Quel lieu occupe ce personnage, maintenant ?
-- Renvoie l'identifiant du lieu le plus proche dans son rayon, ou nil.
-- On lit chara.Position (la position REELLE en jeu) et non la routine :
-- apres sa flanerie, un PNJ n'est plus sur son point de destination.
--------------------------------------------------------------------
function TownPlace.Where(chara)
  if chara == nil then return nil end
  local px, py
  local ok = pcall(function()
    px = chara.Position.X
    py = chara.Position.Y
  end)
  if not ok or px == nil then return nil end

  local best, bestd = nil, nil
  for _, l in ipairs(LIEUX) do
    local dx, dy = px - l.x, py - l.y
    local d2 = dx * dx + dy * dy
    if d2 <= l.rayon * l.rayon and (bestd == nil or d2 < bestd) then
      best, bestd = l.id, d2
    end
  end
  return best
end


--------------------------------------------------------------------
-- TownPlace.Line(inst) -> phrase d'ancrage, ou nil.
--------------------------------------------------------------------
function TownPlace.Line(inst)
  local fiche = TownPlace.LINES[inst]
  if fiche == nil then return nil end
  local chara = CH(inst)
  if chara == nil then return nil end
  local lieu = TownPlace.Where(chara)
  if lieu == nil then return nil end
  return fiche[lieu]
end


--------------------------------------------------------------------
-- TownPlace.Say(inst, emo)
--
-- Prononce l'ancrage s'il y en a un, dans une boite SEULE, avant que
-- l'appelant n'enchaine sur sa replique de chapitre. Renvoie true si
-- quelque chose a ete dit.
--
-- Volontairement, ce module N'OUVRE PAS et NE FERME PAS la conversation :
-- c'est l'appelant qui gere StartConversation/EndConversation. On evite
-- ainsi le double cadrage camera et le portrait qui clignote.
--------------------------------------------------------------------
function TownPlace.Say(inst, emo)
  local txt = TownPlace.Line(inst)
  if txt == nil then return false end
  local chara = CH(inst)
  if chara == nil then return false end
  local ok = pcall(function()
    UI:SetSpeaker(chara)
    GeneralFunctions.SetEmotion(emo or 'Normal')
    UI:WaitShowDialogue(txt)
  end)
  return ok
end


--Combien de couples (PNJ, lieu) ce module couvre-t-il ?
function TownPlace.Count()
  local n = 0
  for _, fiche in pairs(TownPlace.LINES) do
    for _ in pairs(fiche) do n = n + 1 end
  end
  return n
end

return TownPlace
