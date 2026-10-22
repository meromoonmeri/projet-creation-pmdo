--[[
    AccusationArc.lua — Chapitre 11 : « Ceux que l'on accuse »

    Le Cercle du Suaire ne ment pas. C'est toute sa force depuis le ch6 :
    « Il n'a pas menti une seule fois. C'est ca qui me terrifie. »
    Ici, il ne commence pas a mentir — il DEFORME. Il prend une legende
    vraie (celle que Penticus raconte dans metano_town_legend.lua : des
    voyageurs venus d'ailleurs, reveilles dans un corps de Pokemon, qui
    ont sauve le monde) et il en retourne la lecture :

        « Ils ont sauve le monde. D'accord.
          Mais de QUOI l'ont-ils sauve, a chaque fois ? »
        « D'une catastrophe qui a commence le jour où ils sont arrivés. »

    C'est faux comme conclusion, exact comme enumeration. Personne ne
    peut le contredire avec des faits — seulement avec de la confiance.
    D'ou la fracture : ceux qui connaissent le heros n'y croient pas,
    ceux qui ne le connaissent pas y croient.

    STRUCTURE — 10 scenes
      1. Retour au sol           la lueur pourpre a ete vue de partout
      2. La rumeur               les commercants detournent le regard
      3. Le discours du Suaire   la scene longue, sur la place
      4. Plum                    la seule voix qui refuse, et qui ne pese rien
      5. La guilde protege       Penticus ferme les portes
      6. Le boycott              les echoppes closes une a une
      7. La manifestation        devant la guilde, de nuit
      8. Le conseil de la guilde Penticus n'a plus les moyens
      9. La decision             le partenaire choisit, de lui-meme
     10. Le depart               la fuite sous la pluie

    REGLES : le heros ne parle qu'en pensees ; jamais « Abime »,
    « Necrozma », « Eternatus », « prison » ; les personnages des jeux
    d'origine ne sont jamais nommes ; repliques < 150 caracteres hors
    [pause=N] ; aucune narration dans une scene jouee, seulement pour
    ouvrir ou clore un acte, avec fondu ; chaque personnage se reoriente
    depuis SA position ; toute scene sous pcall avec sortie garantie.

    Le mot « humain » est employe ici : il l'est deja dans la trame
    (relic_forest_ch_1, guild_guildmasters_room_ch_1, metano_town_legend)
    et c'est le pivot de l'accusation. Ce qui reste interdit, c'est de
    NOMMER les personnages des jeux d'origine — on n'en nomme aucun.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.Weather'

AccusationArc = {}

--------------------------------------------------------------------
-- Etat
--------------------------------------------------------------------
local function sv()
  if SV.AccusationArc == nil then SV.AccusationArc = {} end
  local s = SV.AccusationArc
  if s.Scene == nil then s.Scene = 0 end
  return s
end

--------------------------------------------------------------------
-- Briques de mise en scene
--------------------------------------------------------------------
local function say(who, emo, txt)
  if who == nil then return end
  UI:SetSpeaker(who)
  GeneralFunctions.SetEmotion(emo or 'Normal')
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

local function think(hero, emo, txt)
  GeneralFunctions.HeroDialogue(hero, txt, emo or 'Normal')
  GAME:WaitFrames(10)
end

-- Narration : uniquement pour ouvrir ou clore un acte, avec fondu.
local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(12)
end

-- Une voix dans la foule, sans visage : personne ne l'assume.
local function crowd(txt)
  UI:ResetSpeaker(false)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

-- Rumeur : la foule bruisse sans parler. Emotes en cascade, decalees,
-- pour que le groupe ne reagisse pas comme un seul bloc.
local function murmur(chars, emote)
  for i, c in ipairs(chars) do
    if c ~= nil then
      pcall(function() GROUND:CharSetEmote(c, emote or "question", 1) end)
      GAME:WaitFrames(4 + (i % 3) * 3)
    end
  end
  GAME:WaitFrames(15)
end

-- Chacun se tourne vers une cible depuis SA position (regle 5.2).
local function allTurnTo(chars, target)
  for i, c in ipairs(chars) do
    if c ~= nil and target ~= nil then
      pcall(function() GROUND:CharTurnToCharAnimated(c, target, 4) end)
      GAME:WaitFrames(3 + (i % 2) * 2)
    end
  end
end

--------------------------------------------------------------------
-- Positions de la place, relevees sur la grille de collision de
-- metano_town (189x189 cellules de 8 px) et verifiees libres ET
-- reliees a l'entree de la guilde par un parcours en largeur.
--------------------------------------------------------------------
AccusationArc.POS = {
  GUILDE   = {696, 904},
  MENEUR   = {696, 976},
  PNJ_1    = {632, 984},
  PNJ_2    = {664, 1000},
  PNJ_3    = {728, 992},
  -- (736,984) mettait PNJ_4 a 11 px de PNJ_3 : deux sprites de 16 px
  -- superposes. Recale a 25 px, l'arc reste resserre sans chevauchement.
  PNJ_4    = {752, 1000},
  PNJ_5    = {688, 1016},
  PNJ_6    = {720, 1016},
  PLUM     = {616, 952},
  HERO     = {688, 936},
  PARTNER  = {712, 936},
  CAMERA   = {696, 960},
}

--------------------------------------------------------------------
-- SCENE 3 — Le discours du Suaire.
-- Le morceau de bravoure du chapitre. Il ne crie pas, il enumere.
--------------------------------------------------------------------
function AccusationArc.Scene3_Discours(hero, partner)
  local P = AccusationArc.POS

  local suaire = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Banette', P.MENEUR[1], P.MENEUR[2], Direction.Up}
  })
  local linceul = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Gengar', P.PNJ_1[1], P.PNJ_1[2], Direction.UpRight}
  })
  local litanie = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Noivern', P.PNJ_4[1], P.PNJ_4[2], Direction.UpLeft}
  })

  -- Les habitants presents sur la carte servent de foule : on ne
  -- fabrique pas des figurants, on utilise ceux qui vivent la.
  local foule = {}
  for _, n in ipairs({'Red_Merchant', 'Green_Merchant', 'Legend_Merchant',
                      'Shop_Owner', 'Bank_Owner', 'Musician'}) do
    local c = CH(n)
    if c ~= nil then table.insert(foule, c) end
  end

  GAME:MoveCamera(P.CAMERA[1], P.CAMERA[2], 60, false)
  GAME:WaitFrames(20)

  -- Il laisse le silence s'installer avant de parler. (regle 6.2)
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(45)

  say(suaire, 'Normal', "Je ne suis pas venu me battre.[pause=25] Je viens vous raconter une histoire que vous croyez connaître.")
  murmur(foule, "question")

  say(suaire, 'Normal', "Il y a trente ans, une étoile est tombée.[pause=20] Qui l'a arrêtée ?[pause=15] Un voyageur venu d'ailleurs.")
  say(suaire, 'Normal', "Il y a quinze ans, le temps s'est fissuré.[pause=20] Qui l'a réparé ?[pause=15] Un autre voyageur venu d'ailleurs.")
  GAME:WaitFrames(20)

  say(linceul, 'Normal', "Chaque fois, on les a remerciés.[pause=20] Chaque fois, on a gravé leur nom.")
  GAME:WaitFrames(15)

  -- Le retournement. Il ne hausse pas la voix.
  say(suaire, 'Normal', "Alors posez-vous la seule question qui compte.[pause=30] De quoi vous ont-ils sauvés ?")
  GAME:WaitFrames(25)
  say(suaire, 'Normal', "D'une catastrophe.[pause=25] Qui a commencé le jour où ils sont arrivés.")

  murmur(foule, "exclaim")
  crowd("Attendez...[pause=20] c'est vrai que ça tombe toujours en même temps...")
  GAME:WaitFrames(15)

  say(litanie, 'Normal', "Jamais avant.[pause=25] Jamais après.[pause=20] Toujours pendant.")
  GAME:WaitFrames(20)

  -- Il se tourne vers le heros. La foule suit son regard.
  pcall(function() GROUND:CharTurnToCharAnimated(suaire, hero, 6) end)
  GAME:WaitFrames(15)
  allTurnTo(foule, hero)
  GAME:WaitFrames(20)

  say(suaire, 'Normal', "Et hier soir, le ciel a brûlé au-dessus de cette vallée.[pause=25] Qui était la-haut ?")
  GAME:WaitFrames(25)

  think(hero, 'Worried', "(Il ne dit rien de faux.[pause=30] Pas une seule fois.)")
  GAME:WaitFrames(20)

  say(partner, 'Shouting', "On a EMPECHE ce truc de tomber ![pause=20] Sans nous, il n'y aurait plus de vallée !")
  GAME:WaitFrames(15)

  say(suaire, 'Sad', "Je te crois.[pause=30] C'est ce qu'ils ont tous dit.[pause=25] Et ils disaient vrai, eux aussi.")
  GAME:WaitFrames(25)

  say(suaire, 'Normal', "Je n'accuse personne d'avoir voulu le mal.[pause=30] J'observe que là où ils passent,[pause=15] le monde manque de finir.")
  GAME:WaitFrames(20)

  crowd("Il a raison...[pause=20] Depuis qu'ils sont arrives, il se passe toujours quelque chose.")
  murmur(foule, "sweatdrop")

  -- La litanie, reprise par la foule. C'est le moment ou ca bascule.
  say(litanie, 'Normal', "Ce qui brille appelle.[pause=20] Ce qui s'eteint oublié.")
  GAME:WaitFrames(15)
  crowd("« Que l'oubli nous couvre tous. »")
  GAME:WaitFrames(25)

  think(hero, 'Sad', "(Ils reprennent ses mots.[pause=30] Ils ne les avaient jamais entendus avant ce soir.)")
  GAME:WaitFrames(20)

  -- Il s'en va sans conclure : il laisse la ville finir a sa place.
  -- Pas de narration ici — la scene est jouee, donc on la JOUE : il
  -- s'efface pendant que la foule, elle, ne bouge pas.
  SOUND:PlayBattleSE('EVT_Emote_Startled_2')
  BossFX.Flash(P.MENEUR[1], P.MENEUR[2], 6, 8, 34)
  for _, c in ipairs({suaire, linceul, litanie}) do
    if c ~= nil then
      pcall(function() GROUND:Hide(c.EntName) end)
      GAME:WaitFrames(8)
    end
  end
  GAME:WaitFrames(25)

  say(partner, 'Surprised', "Où est-ce qu'ils sont passés ?![pause=25] Ils étaient là, juste là !")
  GAME:WaitFrames(20)
  -- Personne dans la foule ne se retourne pour les chercher.
  think(hero, 'Worried', "(Personne ne les cherche.[pause=30] Ils regardent tous ailleurs.)")
  GAME:WaitFrames(20)

  local s = sv()
  s.HeardAccusation = true
  s.Scene = 3
end

--------------------------------------------------------------------
-- SCENE 4 — Plum.
-- Elle ne demonte pas l'argument : elle refuse de le regarder. C'est
-- une amie, pas une avocate. Et ca ne pese rien face a la foule.
--------------------------------------------------------------------
function AccusationArc.Scene4_Plum(hero, partner)
  local P = AccusationArc.POS
  local plum = CH('Jigglypuff')
  if plum == nil then
    plum = CharacterEssentials.MakeCharactersFromList({
      {'Jigglypuff', P.PLUM[1], P.PLUM[2], Direction.Right}
    })
  else
    GROUND:TeleportTo(plum, P.PLUM[1], P.PLUM[2], Direction.Right)
  end

  pcall(function() GROUND:CharSetEmote(plum, "angry", 1) end)
  GAME:WaitFrames(20)

  say(plum, 'Angry', "N'importe quoi.[pause=25] Voilà.[pause=15] C'est tout ce que j'ai à dire.")
  GAME:WaitFrames(15)

  crowd("Plum, tu ne peux pas savoir—")
  say(plum, 'Shouting', "Si ![pause=20] Je sais qui m'a ramenée du Mont Windsep quand personne ne voulait y monter.")
  GAME:WaitFrames(20)

  say(plum, 'Angry', "Vous voulez des dates et des étoiles qui tombent ?[pause=25] Moi j'ai des souvenirs.")
  GAME:WaitFrames(20)

  crowd("...")
  GAME:WaitFrames(20)

  say(plum, 'Sad', "Personne ne dit rien.[pause=30] Vous avez tous quelque chose à dire d'habitude.")
  GAME:WaitFrames(25)

  pcall(function() GROUND:CharTurnToCharAnimated(plum, hero, 4) end)
  say(plum, 'Determined', "Je ne les crois pas.[pause=25] Je voulais que tu l'entendes de quelqu'un.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(Une voix.[pause=30] Contre une place entière.)")
  GAME:WaitFrames(15)

  local s = sv()
  s.PlumDefended = true
  s.Scene = 4
end

--------------------------------------------------------------------
-- SCENE 7 — La manifestation devant la guilde, de nuit.
-- Personne ne force la porte. C'est pire : ils attendent.
--------------------------------------------------------------------
function AccusationArc.Scene7_Manifestation(hero, partner)
  local P = AccusationArc.POS

  -- La foule est faite d'habitants REELS de la ville, deplaces devant la
  -- guilde. On ne duplique pas une meme fiche : chaque entree de
  -- CharacterEssentials porte un `instance` unique, et spawner deux fois
  -- la meme cle donnerait deux entites au meme EntName — CH(), Hide() et
  -- les handlers viseraient alors la mauvaise. Les visages sont donc
  -- ceux que le joueur connait : c'est aussi plus dur a encaisser.
  local rangs = {}
  local ordre = {'MENEUR','PNJ_1','PNJ_2','PNJ_3','PNJ_4','PNJ_5','PNJ_6'}
  local noms  = {'Red_Merchant','Green_Merchant','Shop_Owner',
                 'Bank_Owner','Storage_Owner','Musician','Tutor_Owner'}
  for i, n in ipairs(noms) do
    local c = CH(n)
    local p = P[ordre[i]]
    if c ~= nil and p ~= nil then
      pcall(function() GROUND:TeleportTo(c, p[1], p[2], Direction.Up) end)
      table.insert(rangs, c)
    end
  end

  GAME:MoveCamera(P.CAMERA[1], P.CAMERA[2] + 20, 60, false)
  SOUND:PlayBGM('Growing Anxiety.ogg', true)
  GAME:WaitFrames(40)

  crowd("Qu'ils sortent ![pause=20] On veut juste qu'ils sortent !")
  murmur(rangs, "angry")
  GAME:WaitFrames(20)

  say(partner, 'Worried', "Ils sont là depuis le coucher du soleil.[pause=25] Ils ne frappent même pas.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(Ils attendent.[pause=30] Comme si on allait finir par leur donner raison.)")
  GAME:WaitFrames(25)

  crowd("Mon échoppe est fermée depuis trois jours ![pause=20] Qui va me rembourser ?")
  GAME:WaitFrames(15)
  crowd("Ce n'est pas contre toi, petit ![pause=25] C'est contre ce que tu attires !")
  GAME:WaitFrames(25)

  say(partner, 'Angry', "« Ce n'est pas contre toi. »[pause=25] Ils sont devant chez nous à minuit.")
  GAME:WaitFrames(20)

  local s = sv()
  s.SawProtest = true
  s.Scene = 7
end

--------------------------------------------------------------------
-- SCENE 9 — La decision. Le partenaire choisit de lui-meme.
-- Le heros ne le lui demande pas — il ne peut pas le lui demander.
--------------------------------------------------------------------
function AccusationArc.Scene9_Decision(hero, partner)
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(40)

  think(hero, 'Sad', "(Si je pars, tout ça s'arrête.[pause=30] La guilde respire.[pause=20] Plum respire.)")
  GAME:WaitFrames(25)

  say(partner, 'Normal', "Tu as ton air de quand tu as déjà décidé.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(...)")
  GAME:WaitFrames(20)

  say(partner, 'Determined', "Alors je le dis avant toi.[pause=25] Je viens.")
  GAME:WaitFrames(20)

  say(partner, 'Normal', "Et non, ce n'est pas pour toi.[pause=25] C'est ma décision, pas un service.")
  GAME:WaitFrames(25)

  say(partner, 'Determined', "Ils ont trente ans d'histoires et pas une preuve.[pause=20] On va leur en chercher une.")
  GAME:WaitFrames(20)

  think(hero, 'Determined', "(Il n'a pas hésité une seconde.[pause=30] Moi j'ai hésité toute la nuit.)")
  GAME:WaitFrames(20)

  local s = sv()
  s.PartnerChose = true
  s.Scene = 9
end

--------------------------------------------------------------------
-- SCENE 1 — Le retour au sol.
-- Ils redescendent victorieux. Personne ne les attend.
--------------------------------------------------------------------
function AccusationArc.Scene1_Retour(hero, partner)
  Weather.Set('pluie_legere')
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(40)

  say(partner, 'Happy', "On a réussi...[pause=25] On a vraiment réussi !")
  GAME:WaitFrames(20)

  -- Personne ne sort. La place reste vide. C'est le premier signal.
  GAME:WaitFrames(50)

  say(partner, 'Normal', "C'est calme.[pause=25] À cette heure-ci, il y a toujours du monde dehors.")
  GAME:WaitFrames(20)

  think(hero, 'Worried', "(Les volets sont fermés.[pause=30] Tous.)")
  GAME:WaitFrames(25)

  say(partner, 'Worried', "Ils ont dû voir la lueur d'ici.[pause=25] Ils ont eu peur, c'est normal.")
  GAME:WaitFrames(20)

  say(partner, 'Determined', "On expliquera demain.[pause=20] Une fois qu'ils auront dormi.")
  GAME:WaitFrames(15)

  think(hero, 'Sad', "(Il essaie de se rassurer lui-même.[pause=30] Ça s'entend.)")

  local s = sv()
  s.Scene = 1
end

--------------------------------------------------------------------
-- SCENE 2 — La rumeur.
-- Aucune insulte, aucun cri. Juste des regards qui se detournent.
--------------------------------------------------------------------
function AccusationArc.Scene2_Rumeur(hero, partner)
  local temoins = {}
  for _, n in ipairs({'Red_Merchant', 'Green_Merchant', 'Shop_Owner', 'Bank_Owner'}) do
    local c = CH(n)
    if c ~= nil then table.insert(temoins, c) end
  end

  Weather.Set('brouillard')
  GAME:WaitFrames(30)

  -- Ils se detournent l'un apres l'autre, pas tous ensemble.
  for i, c in ipairs(temoins) do
    pcall(function()
      GROUND:CharAnimateTurnTo(c, Direction.Up, 4)
      GROUND:CharSetEmote(c, "sweatdrop", 1)
    end)
    GAME:WaitFrames(14)
  end
  GAME:WaitFrames(20)

  crowd("...")
  GAME:WaitFrames(25)

  say(partner, 'Surprised', "Hé, bonjour ![pause=20] ...Il ne m'a pas répondu.")
  GAME:WaitFrames(20)

  crowd("Ce n'est pas le moment, petit.[pause=25] Rentrez chez vous.")
  GAME:WaitFrames(20)

  think(hero, 'Worried', "(Il ne me regarde pas.[pause=30] Il regarde à côté de moi.)")
  GAME:WaitFrames(20)

  say(partner, 'Sad', "Qu'est-ce qui se passe, à la fin ?[pause=25] On a fait quelque chose de mal ?")
  GAME:WaitFrames(20)

  crowd("On raconte des choses, en ville.[pause=25] Je ne dis pas que j'y crois.")
  GAME:WaitFrames(25)

  think(hero, 'Sad', "(« Je ne dis pas que j'y crois. »[pause=30] Il l'a dit quand même.)")

  local s = sv()
  s.Scene = 2
end

--------------------------------------------------------------------
-- SCENE 5 — La guilde ferme ses portes.
-- Penticus protege, mais protéger a un prix qu'il ne dit pas.
--------------------------------------------------------------------
function AccusationArc.Scene5_GuildeProtege(hero, partner)
  local penticus = CH('Tropius')
  local phileas  = CH('Noctowl')

  SOUND:PlayBGM("Wigglytuff's Guild.ogg", true)
  GAME:WaitFrames(40)

  if penticus ~= nil then
    pcall(function() GROUND:CharTurnToCharAnimated(penticus, hero, 4) end)
    say(penticus, 'Normal', "Vous ne sortez pas aujourd'hui.[pause=25] Ni demain, tant que je n'ai pas dit le contraire.")
    GAME:WaitFrames(20)
  end

  say(partner, 'Shouting', "Mais on n'a rien fait ![pause=20] On leur dira, ils comprendront !")
  GAME:WaitFrames(20)

  if penticus ~= nil then
    say(penticus, 'Sad', "Je sais que vous n'avez rien fait.[pause=30] Ce n'est pas la question.")
    GAME:WaitFrames(20)
    say(penticus, 'Normal', "La question, c'est ce qu'ils croient.[pause=25] Et on ne discute pas avec ça.")
    GAME:WaitFrames(20)
  end

  if phileas ~= nil then
    pcall(function() GROUND:CharTurnToCharAnimated(phileas, penticus, 4) end)
    say(phileas, 'Worried', "Trois demandes de retrait ce matin.[pause=25] Des équipes qui travaillaient avec nous depuis des années.")
    GAME:WaitFrames(20)
  end

  think(hero, 'Sad', "(La guilde paie pour moi.[pause=30] Et personne ne me le reproche.)")
  GAME:WaitFrames(25)

  if penticus ~= nil then
    say(penticus, 'Determined', "Cette guilde a resiste a pire qu'une rumeur.[pause=25] Restez a l'interieur, c'est tout.")
  end

  local s = sv()
  s.Scene = 5
end

--------------------------------------------------------------------
-- SCENE 6 — Le boycott.
-- Les echoppes ferment. Aucune ne le dit en face.
--------------------------------------------------------------------
function AccusationArc.Scene6_Boycott(hero, partner)
  local echoppes = {}
  for _, n in ipairs({'Shop_Owner', 'Storage_Owner', 'Bank_Owner', 'Tutor_Owner', 'Swap_Owner'}) do
    local c = CH(n)
    if c ~= nil then table.insert(echoppes, c) end
  end

  Weather.Set('pluie')
  GAME:WaitFrames(40)

  say(partner, 'Normal', "On a besoin de provisions.[pause=20] Ils ne vont pas nous refuser ça.")
  GAME:WaitFrames(20)

  -- Chacune se detourne a son tour, avec un decalage : ce n'est pas
  -- un mot d'ordre, c'est une contagion.
  for i, c in ipairs(echoppes) do
    pcall(function()
      GROUND:CharAnimateTurnTo(c, Direction.Up, 4)
      if i % 2 == 1 then GROUND:CharSetEmote(c, "sweatdrop", 1) end
    end)
    GAME:WaitFrames(18)
  end
  GAME:WaitFrames(25)

  crowd("Ferme.[pause=20] Inventaire.")
  GAME:WaitFrames(15)
  crowd("Reviens la semaine prochaine.[pause=25] Ou le mois prochain.")
  GAME:WaitFrames(20)

  say(partner, 'Angry', "Vous étiez ouverts il y a dix minutes ![pause=20] Je vous ai vus !")
  GAME:WaitFrames(20)

  crowd("Je dois penser à ma famille, petit.[pause=25] Comprends-moi.")
  GAME:WaitFrames(25)

  think(hero, 'Sad', "(Il a raison de penser aux siens.[pause=30] C'est ça le pire.)")
  GAME:WaitFrames(20)

  say(partner, 'Sad', "...On rentre.[pause=25] On trouvera autrement.")

  local s = sv()
  s.ShopsClosed = true
  s.Scene = 6
end

--------------------------------------------------------------------
-- SCENE 8 — Le conseil. Penticus n'a plus les moyens de protéger.
--------------------------------------------------------------------
function AccusationArc.Scene8_Conseil(hero, partner)
  local penticus = CH('Tropius')
  local phileas  = CH('Noctowl')

  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(45)

  if phileas ~= nil then
    say(phileas, 'Sad', "Onze retraits.[pause=25] Le tableau des missions est vide depuis trois jours.")
    GAME:WaitFrames(20)
  end

  if penticus ~= nil then
    pcall(function() GROUND:CharAnimateTurnTo(penticus, Direction.Down, 4) end)
    GAME:WaitFrames(20)
    say(penticus, 'Sad', "Je peux tenir la porte fermée.[pause=30] Je ne peux pas nourrir la guilde avec des principes.")
    GAME:WaitFrames(25)
  end

  say(partner, 'Worried', "Vous allez nous demander de partir ?")
  GAME:WaitFrames(25)

  if penticus ~= nil then
    say(penticus, 'Angry', "Non.[pause=30] Je ne demanderai jamais ça.")
    GAME:WaitFrames(20)
    say(penticus, 'Sad', "Et c'est bien pour ça que quelqu'un d'autre devra le décider à ma place.")
    GAME:WaitFrames(25)
  end

  think(hero, 'Sad', "(Il vient de me donner la permission sans jamais la formuler.)")
  GAME:WaitFrames(20)

  if phileas ~= nil then
    say(phileas, 'Normal', "Les archives parlent d'un autre continent, au-delà de la mer.[pause=25] Loin d'ici.")
    GAME:WaitFrames(20)
  end

  local s = sv()
  s.GuildCouncil = true
  s.Scene = 8
end

--------------------------------------------------------------------
-- SCENE 10 — Le depart, en deux lieux.
-- 10a : la traversee de la ville de nuit, sous l'averse.
-- 10b : la halte au carrefour, la derniere parole, la route.
--------------------------------------------------------------------
function AccusationArc.Scene10a_Ville(hero, partner)
  Weather.Set('pluie_forte')
  pcall(function() GROUND:AddMapStatus("darkness") end)
  SOUND:PlayBGM('Rising Fear.ogg', true)
  GAME:WaitFrames(40)

  Weather.Thunder(10)
  GAME:WaitFrames(25)

  say(partner, 'Determined', "Ne cours pas.[pause=25] Si on court, on a l'air de fuir.")
  GAME:WaitFrames(20)

  think(hero, 'Sad', "(Nous fuyons.)")
  GAME:WaitFrames(25)

  -- Le trajet : guilde -> place de la Legende -> sortie sud.
  -- Chemin verifie praticable sur la grille (121 cases).
  local etapes = {{660, 1060}, {612, 1140}, {492, 1180}, {348, 1196}, {292, 1300}}
  for i, p in ipairs(etapes) do
    local c1 = TASK:BranchCoroutine(function()
      GROUND:MoveToPosition(hero, p[1], p[2], false, 2)
    end)
    local c2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(10)
      if partner ~= nil then GROUND:MoveToPosition(partner, p[1] - 20, p[2] + 12, false, 2) end
    end)
    local c3 = TASK:BranchCoroutine(function()
      GAME:MoveCamera(p[1], p[2] - 16, 50, false)
    end)
    TASK:JoinCoroutines({c1, c2, c3})
    if i == 3 then
      Weather.Thunder(8)
      say(partner, 'Worried', "Il y a de la lumière derrière nous.[pause=25] Ne te retourne pas.")
      GAME:WaitFrames(20)
    end
  end

  GAME:WaitFrames(20)
  think(hero, 'Sad', "(Trois ans dans cette ville.[pause=30] Et je pars par la porte de service.)")
  GAME:WaitFrames(20)
  if partner ~= nil then
    say(partner, 'Determined', "On reviendra, {0}.[pause=25] Par la grande porte, cette fois.[pause=20] Je te le jure.")
    GAME:WaitFrames(20)
  end
  think(hero, 'Determined', "(Il tremble sous la pluie froide...[pause=25] mais sa voix n'a pas tremblé une seule fois.)")
  GAME:WaitFrames(25)

  local s = sv()
  s.Scene = 10
end

function AccusationArc.Scene10b_Carrefour(hero, partner)
  -- Positions relevees sur la grille de carrefour_nord (54x57 cellules) :
  -- arrivee sud, halte centrale, depart nord, toutes verifiees libres,
  -- traversee sud->nord praticable en 55 cases.
  Weather.Set('pluie')
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(30)

  GROUND:TeleportTo(hero, 216, 440, Direction.Up)
  if partner ~= nil then GROUND:TeleportTo(partner, 192, 448, Direction.Up) end
  GAME:MoveCamera(216, 400, 1, false)
  GAME:FadeIn(50)
  GAME:WaitFrames(30)

  -- Montee jusqu'au centre du carrefour.
  local c1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 216, 200, false, 1)
  end)
  local c2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(14)
    if partner ~= nil then GROUND:MoveToPosition(partner, 192, 208, false, 1) end
  end)
  local c3 = TASK:BranchCoroutine(function()
    GAME:MoveCamera(216, 230, 120, false)
  end)
  TASK:JoinCoroutines({c1, c2, c3})
  GAME:WaitFrames(25)

  -- Le heros se retourne vers le sud : la ville est derriere.
  pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Down, 6) end)
  GAME:WaitFrames(30)

  think(hero, 'Sad', "(D'ici, on ne voit même plus les toits.)")
  GAME:WaitFrames(25)

  if partner ~= nil then
    pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
    say(partner, 'Normal', "Tu peux encore rentrer, tu sais.[pause=25] Moi je continue, mais toi tu peux.")
    GAME:WaitFrames(25)
  end

  think(hero, 'Determined', "(Il sait très bien que non.[pause=30] Il me laisse le choix quand même.)")
  GAME:WaitFrames(25)

  -- Silence dramatique de mise en scène (60 frames ~ 1 seconde sous la pluie) avant la décision finale
  SOUND:FadeOutBGM(40)
  GAME:WaitFrames(60)

  -- Il se retourne vers le nord. La route.
  pcall(function() GROUND:CharAnimateTurnTo(hero, Direction.Up, 6) end)
  GAME:WaitFrames(20)

  if partner ~= nil then
    say(partner, 'Determined', "Bon.[pause=20] Alors on marche.")
    GAME:WaitFrames(20)
  end

  -- Depart vers le nord, camera qui les laisse s'eloigner.
  local d1 = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(hero, 216, 40, false, 1)
  end)
  local d2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(12)
    if partner ~= nil then GROUND:MoveToPosition(partner, 192, 56, false, 1) end
  end)
  TASK:JoinCoroutines({d1, d2})
  GAME:WaitFrames(40)

  GAME:FadeOut(false, 60)
  GAME:WaitFrames(40)

  -- Carton de fin d'acte : la seule narration, sur ecran noir.
  narrate("Cette nuit-là, deux explorateurs quittèrent Metano Town sous la pluie battante.[pause=30] Personne ne les vit partir.[pause=25] Leur seule boussole était la promesse de prouver leur innocence...[pause=20] et de ramener la vérité à toute la région.")
  GAME:WaitFrames(30)

  local s = sv()
  s.Scene = 11
  if SV.Chapter11 ~= nil then SV.Chapter11.FledGuild = true end
end

--------------------------------------------------------------------
-- Enveloppe commune : cutscene mode, IA, sortie garantie.
--------------------------------------------------------------------
function AccusationArc.Play(sceneFn, label)
  local hero    = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  local ok, err = pcall(sceneFn, hero, partner)
  if not ok then
    PrintInfo("[AccusationArc] " .. tostring(label) .. " interrompue : " .. tostring(err))
  end

  pcall(function()
    UI:ResetSpeaker()
    GeneralFunctions.RestoreIdleAnim()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return ok
end

return AccusationArc
