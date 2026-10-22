--[[
    guild_guildmasters_room_ch_6.lua

    L'AUDIENCE DU RETOUR — la chambre du maitre s'ouvre
    ================================================================
    CE QUE CETTE SCENE CORRIGE
    ------------------------------------------------------------------
    La porte de la chambre du maitre (guild_third_floor_lobby,
    Door_Exit_Touch) etait ouverte en PERMANENCE. Verifie dans le depot :
    elle n'est masquee qu'au chapitre 1 (guild_third_floor_lobby_ch_1
    ligne 17, GROUND:Hide('Door_Exit')), et plus jamais ensuite.

    Resultat : des le ch2, le joueur pouvait pousser la porte du maitre
    de guilde quand il voulait, entrer, et trouver Penticus plante la
    sans rien a dire — parce que guild_guildmasters_room.PlotScripting
    ne traitait que les chapitres 1, 2, 4 et 5. Un lieu qui devrait
    etre le plus solennel de la guilde etait le plus vide.

    Desormais la porte se merite. Elle reste close jusqu'au retour de
    l'expedition, puis Penticus convoque l'equipe : c'est cette audience
    qui l'ouvre pour de bon.

    ------------------------------------------------------------------
    POURQUOI CE MOMENT-LA
    ------------------------------------------------------------------
    Le retour du Mont Balaye est la vraie bascule du jeu : c'est la que
    SV.ChapterProgression.Chapter passe de 5 a 6 (zone/mount_windswept
    ligne 116). L'equipe cesse d'etre une recrue qu'on envoie en
    exercice. Lui ouvrir la porte du maitre a cet instant precis, c'est
    dire « vous n'etes plus des eleves » sans avoir a le prononcer.

    ------------------------------------------------------------------
    LE CASTING (verifie, apres l'erreur du chevet)
    ------------------------------------------------------------------
      PENTICUS (Tropius)  maitre de guilde. Preuve : c'est lui qui ouvre
        l'adresse du matin et donne la parole aux autres
        (guild_third_floor_lobby_ch_7 : « ...les Aegis Cave. Phileas ? »).
        Il est deja sur la carte (MapChars : Tropius, en 184,112).
      PHILEAS (Noctowl)   le savant. Il repond « Merci, Penticus » dans
        la meme scene. Il ne commande pas : il sait.

    Aucun autre cadre : une audience a deux voix reste lisible. Ils sont
    crees a la volee puis retires, comme le fait deja
    guild_guildmasters_room_ch_5.SetupGround.

    ------------------------------------------------------------------
    GRAMMAIRE (reprise de ChapterScenes.lua)
    ------------------------------------------------------------------
      1. on etablit le LIEU avant les personnages ;
      2. constat sensoriel -> reaction affective -> decision ;
      3. la camera cadre le decor, puis redescend sur le duo ;
      4. les departs sont des coroutines jointes.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici : c'est une scene humaine.
    * Ne nomme aucun personnage des jeux d'origine.
    * Texte litteral francais.
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall, sortie garantie : le joueur ne doit jamais rester
      fige dans le bureau du maitre.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'

guild_guildmasters_room_ch_6 = {}

--------------------------------------------------------------------
-- HELPERS (memes noms et memes roles que dans ChapterScenes.lua)
--------------------------------------------------------------------
local function say(chara, emo, txt)
  if chara == nil then return end
  UI:SetSpeaker(chara)
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
-- L'AUDIENCE
--------------------------------------------------------------------
-- Positions relevees sur guild_guildmasters_room.rsground (384x384) :
-- Tropius est en 184,112 et tout l'espace devant lui (y de 160 a 224)
-- est libre, verifie case par case. Phileas se place a sa droite, le
-- duo reste en retrait, a l'entree.
function guild_guildmasters_room_ch_6.GuildmasterAudience()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local tropius = CH('Tropius')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    --1. LE LIEU D'ABORD. La camera cadre le bureau, le rideau se leve
    --lentement, et on laisse le silence s'installer avant le premier mot.
    SOUND:StopBGM()
    GAME:MoveCamera(192, 140, 1, false)
    GAME:FadeIn(50)
    GAME:WaitFrames(35)

    narrate("Le bureau du maitre de guilde.[pause=30] Vous n'y aviez jamais mis les pieds.")
    GAME:WaitFrames(20)
    narrate("Des cartes jusqu'au plafond.[pause=25] Certaines montrent des cotes qui n'existent plus.")
    GAME:WaitFrames(15)

    --Piste verifiee dans Content/Music : le fichier s'appelle bien
    --'Guildmaster Wigglytuff.ogg' (3 usages attestes dans le depot).
    --'Guildmaster.ogg' que j'avais ecrit d'abord n'existe pas.
    SOUND:PlayBGM('Guildmaster Wigglytuff.ogg', true)
    GAME:WaitFrames(25)

    --Phileas est deja la, il attendait. On le fait apparaitre a cote de
    --Penticus : la scene commence avec eux deux, pas avec leur arrivee.
    local noctowl
    pcall(function()
      noctowl = CharacterEssentials.MakeCharactersFromList({
        { 'Noctowl', 232, 152, Direction.DownLeft },
      })
    end)
    if noctowl == nil then noctowl = CH('Noctowl') end

    say(partner, 'Surprised', "On a le droit d'etre ici ?[pause=30] Vraiment ?")
    think(hero, 'Worried', "(La porte etait ouverte.[pause=25] C'est la premiere fois qu'elle est ouverte.)")
    GAME:WaitFrames(15)

    --2. PENTICUS. Il ne felicite pas tout de suite : il constate, et il
    --le fait avec le poids de quelqu'un qui a vu beaucoup d'equipes.
    say(tropius, 'Normal', "Avancez.[pause=30] Vous etes chez vous ici, maintenant.")
    GAME:WaitFrames(12)
    say(tropius, 'Normal', "Cette porte reste fermee tant qu'une equipe apprend.[pause=25] Elle s'ouvre quand l'equipe a fini d'apprendre.")
    think(hero, 'Worried', "(Fini d'apprendre.[pause=25] Je ne me sens pas fini du tout.)")
    GAME:WaitFrames(15)

    say(tropius, 'Worried', "Vous etes montes au sommet et vous en etes redescendus.[pause=30] Peu d'equipes font les deux.")
    say(partner, 'Sad', "On a surtout eu de la chance.")
    say(tropius, 'Normal', "Toutes les equipes qui reviennent disent cela.[pause=30] Celles qui ne reviennent pas ne disent rien.")
    GAME:WaitFrames(18)

    --3. PHILEAS. Il ne commande pas, il SAIT. C'est lui qui apporte le
    --fait genant, et il le pose sans menagement : c'est sa maniere.
    say(noctowl, 'Normal', "Puis-je ?[pause=25] Merci.")
    say(noctowl, 'Worried', "J'ai relu les rapports d'expedition des trente dernieres annees.[pause=30] Tous.")
    say(noctowl, 'Worried', "Le sommet etait accessible en huit jours de marche.[pause=25] Vous en avez mis onze.")
    GAME:WaitFrames(12)
    say(partner, 'Surprised', "On a ete lents ?")
    say(noctowl, 'Normal', "Non.[pause=30] La montagne est plus haute qu'avant.")
    GAME:WaitFrames(20)

    narrate("Personne ne dit rien pendant un moment.[pause=30] Dehors, on entend la guilde travailler.")
    GAME:WaitFrames(18)

    think(hero, 'Worried', "(Une montagne ne grandit pas.[pause=25] Pas en trente ans. Pas comme ca.)")
    say(tropius, 'Sad', "Voila pourquoi vous etes ici.[pause=30] Pas pour etre felicites.")
    GAME:WaitFrames(15)

    --4. CE QUI CHANGE CONCRETEMENT. Une audience doit donner quelque
    --chose au joueur, sinon c'est un discours.
    say(tropius, 'Normal', "Cette piece vous est ouverte a partir d'aujourd'hui.[pause=25] Venez quand vous voulez.")
    say(tropius, 'Normal', "Vous y trouverez ce que la guilde sait.[pause=30] Ce n'est pas beaucoup. C'est tout ce que nous avons.")
    GAME:WaitFrames(12)

    say(noctowl, 'Normal', "Je travaille ici la plupart du temps.[pause=25] Si vous voyez quelque chose d'anormal, dites-le moi.")
    say(noctowl, 'Worried', "N'importe quoi.[pause=30] Meme ce qui vous parait ridicule. Surtout ce qui vous parait ridicule.")
    GAME:WaitFrames(15)

    say(partner, 'Determined', "On note tout.[pause=25] Promis.")
    GAME:WaitFrames(10)

    --5. LA CAMERA REDESCEND SUR LE DUO : on passe du lieu a la decision.
    GAME:MoveCamera(192, 200, 60, false)
    GAME:WaitFrames(20)

    say(tropius, 'Happy', "Une derniere chose.[pause=30] Bienvenue chez les explorateurs.")
    think(hero, 'Normal', "(...Il l'a dit comme si ca allait de soi.[pause=25] Comme si on l'avait toujours ete.)")
    GAME:WaitFrames(20)

    narrate("Vous ressortez.[pause=30] La porte, derriere vous, reste ouverte.")
  end)
  if not ok then PrintInfo('[ch6.GuildmasterAudience] ecourtee : '..tostring(err)) end

  --La porte est desormais franchissable, et l'audience ne se rejoue pas.
  --Pose HORS du pcall : meme si la scene casse en plein milieu, le joueur
  --ne doit pas se retrouver avec une porte definitivement bloquee.
  SV.Chapter6.GuildmasterRoomUnlocked = true
  SV.Chapter6.PlayedGuildmasterAudience = true

  --Phileas repart : il n'a rien a faire dans le decor une fois la scene
  --finie. On le masque plutot que de le laisser plante la.
  pcall(function() GROUND:Hide('Noctowl') end)

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
-- LES VISITES SUIVANTES
--------------------------------------------------------------------
-- Une piece qu'on ouvre et dans laquelle il n'y a plus rien a faire
-- redevient vide. Penticus a donc quelque chose a dire selon l'avancement
-- du chapitre 6 — les champs lus existent tous (scriptvars.lua).
function guild_guildmasters_room_ch_6.SetupGround()
  pcall(function() GAME:FadeIn(20) end)
end

function guild_guildmasters_room_ch_6.Tropius_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  local c6 = SV.Chapter6 or {}

  local txt, emo
  if c6.DefeatedGloomyBoss then
    txt = "La foret respire de nouveau.[pause=30] Je ne demande pas comment. Je vous crois."
    emo = 'Happy'
  elseif c6.ChenipentFound then
    txt = "Vous avez ramene l'enfant.[pause=30] Le reste attendra. C'est l'ordre des choses."
    emo = 'Normal'
  elseif c6.MissionAccepted then
    txt = "La Foret Lugubre.[pause=25] Prenez le sentier de l'ouest : il est plus long et beaucoup plus sur."
    emo = 'Worried'
  else
    txt = "Regardez les cartes autant que vous voulez.[pause=30] Elles ne mordent pas. Elles mentent, parfois."
    emo = 'Normal'
  end

  pcall(function()
    GeneralFunctions.StartConversation(chara, txt, emo)
    GeneralFunctions.EndConversation(chara)
  end)
end

return guild_guildmasters_room_ch_6
