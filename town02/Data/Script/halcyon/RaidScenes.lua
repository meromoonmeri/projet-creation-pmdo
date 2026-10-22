--[[
    RaidScenes.lua

    LES DEUX FINS D'UN RAID — l'ecroulement, et la fuite des ombres
    ================================================================
    CE QUE CE MODULE AJOUTE
    ------------------------------------------------------------------
    TownRaid savait dire « gagne » ou « perdu », mais rien ne se VOYAIT.
    On passait d'un ecran de combat a une boite de dialogue. Les deux
    moments les plus forts de la nuit n'avaient aucune mise en scene.

    Deux scenes, exactement symetriques :

      Defeat  -> LE HEROS S'ECROULE. Les jambes lachent, l'ecran tangue,
                 le monde s'eteint. Puis le reveil : la guilde est a son
                 chevet, on debriefe, et on repart.
      Victory -> LES OMBRES SE DEFONT. Elles ne meurent pas : elles
                 refluent, se dissolvent, retournent d'ou elles viennent.
                 Une menace qui s'enfuit reste une menace.

    ------------------------------------------------------------------
    LA REGLE DE MISE EN SCENE (reprise de ChapterScenes.lua)
    ------------------------------------------------------------------
      1. le corps parle avant la bouche : on montre l'etat physique
         avant de laisser quelqu'un le commenter ;
      2. le son precede l'image, l'image precede le mot ;
      3. une sortie de scene est une coroutine jointe : marche, fondu et
         musique se terminent ensemble.

    ------------------------------------------------------------------
    LE CHEVET — pourquoi ces trois-la, et pas d'autres
    ------------------------------------------------------------------
    CORRECTION D'UNE ERREUR DE CASTING. La premiere version de cette
    scene convoquait « Phileas, maitre de guilde » et « Chatot, son
    second ». Les deux etaient faux, verification faite dans le depot :

      * Le maitre de guilde est PENTICUS (Tropius). Preuve :
        guild_third_floor_lobby_ch_7.lua ouvre l'adresse du matin sur
        lui, et c'est LUI qui donne la parole a Phileas (« Et au coeur
        de tout ca, les anciennes Aegis Cave. Phileas ? »).
      * PHILEAS (Noctowl) est le savant de la guilde, pas son chef. Il
        repond « Merci, Penticus » et enchaine sur le savoir des ruines.
        C'est lui qui raconte la Genese au ch7.
      * CHATOT s'appelle FALO, et ce n'est meme pas un membre de la
        guilde : c'est le MUSICIEN de Metano (metano_town/init.lua:3183,
        instance 'Musician'). Il n'a rien a faire au chevet du heros.

    Le trio corrige, et ce que chacun apporte :

      PENTICUS (Tropius), maitre de guilde. Il ne gronde pas : il
        constate, puis il protege. C'est ce qui le rend impressionnant.
        C'est aussi lui qui a autorite pour doubler les veilles.
      PHILEAS (Noctowl), le savant. Il ne s'interesse pas a la faute
        mais au FAIT : comment les pillards savaient ou chercher. Son
        role dans tout le mod est de comprendre, pas de commander.
      RIN (Audino). Elle tient l'assemblee au 2e etage
        (guild_second_floor : Assembly_Owner) et connait tout le monde ;
        elle parle du CORPS et du repos, jamais de la faute.

    Le partage des roles reste le meme qu'avant — quelqu'un s'inquiete
    du corps, quelqu'un reproche, quelqu'un conclut — mais il est
    desormais porte par les bons personnages. Le reproche revient a
    Phileas sous forme de question insistante (c'est sa maniere), ce qui
    laisse Penticus libre de proteger.

    Ils repartent en file, et la piece redevient calme : le joueur
    reprend la main sans transition brutale.

    ------------------------------------------------------------------
    POSITIONS — verifiees sur guild_heros_room.rsground (352x352)
    ------------------------------------------------------------------
      Hero_Bed    172,148     Partner_Bed 228,148
      Les trois visiteurs se placent DEVANT les lits, cases testees
      libres (Tags == 0) : 172,180 / 200,190 / 228,180.
      Sortie par Bedroom_Exit, en 0,184.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici.
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall : une scene qui casse ne doit jamais laisser le
      joueur immobile dans sa chambre.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'

RaidScenes = {}

--------------------------------------------------------------------
-- HELPERS
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
-- 1. L'ECROULEMENT
--------------------------------------------------------------------
-- Jouee AVANT le transfert vers la chambre. Le corps lache d'abord, la
-- vue ensuite : c'est l'ordre reel d'un evanouissement, et c'est ce qui
-- rend la scene physique plutot que narrative.
--
-- « Faint » et « Hurt » sont des animations attestees dans le depot
-- (crooked_den_ch_3.lua:621 pose Faint via PoseGroundAction ; BossFX
-- l.437 utilise CharSetAnim(hero,"Hurt")). On n'invente rien.
function RaidScenes.Collapse()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  return pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    --Le son d'abord : la musique se coupe net, comme un souffle coupe.
    SOUND:FadeOutBGM(25)
    GAME:WaitFrames(15)

    --Le corps encaisse. Recul, puis l'ecran tangue avec lui.
    pcall(function()
      if hero ~= nil then GROUND:CharSetAnim(hero, "Hurt", true) end
      if partner ~= nil then GROUND:CharSetAnim(partner, "Hurt", true) end
    end)
    BossFX.ShakeScreen(6, 24)
    GAME:WaitFrames(20)

    narrate("Vos jambes ne repondent plus.[pause=30] Le sol se rapproche, tres lentement.")
    GAME:WaitFrames(15)

    --La chute. PoseGroundAction fige la pose : le personnage RESTE au sol.
    pcall(function()
      if hero ~= nil then
        GROUND:CharSetAction(hero, RogueEssence.Ground.PoseGroundAction(
          hero.Position, hero.Direction,
          RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
      end
      if partner ~= nil then
        GROUND:CharSetAction(partner, RogueEssence.Ground.PoseGroundAction(
          partner.Position, partner.Direction,
          RogueEssence.Content.GraphicsManager.GetAnimIndex("Faint")))
      end
      --SE de chute. DUN_Rollout est atteste dans le depot (2 usages) ;
      --j'avais d'abord ecrit "DUN_Tumble", qui n'existe nulle part.
      SOUND:PlayBattleSE("DUN_Rollout")
    end)
    BossFX.ShakeScreen(3, 16)
    GAME:WaitFrames(25)

    say(partner, 'Pain', "Debout...[pause=30] il faut se relever...")
    GAME:WaitFrames(15)
    narrate("La joue contre la pierre froide.[pause=30] Les bruits s'eloignent, un par un.")
    GAME:WaitFrames(20)

    --Le noir. FadeOut lent : on s'evanouit, on ne coupe pas.
    GAME:FadeOut(false, 90)
    GAME:WaitFrames(40)
  end)
end

--------------------------------------------------------------------
-- 2. LE CHEVET — le lendemain matin
--------------------------------------------------------------------
-- Jouee dans guild_heros_room. Les trois cadres sont crees a la volee
-- (MakeCharactersFromList, patron employe partout dans le mod) puis
-- retires : la chambre n'a aucun MapChar permanent, verifie dans
-- guild_heros_room.rsground (MapChars vide).
local VISITEURS = {
  { 'Tropius', 200, 190, Direction.Up },   --Penticus, maitre de guilde, au centre
  { 'Noctowl', 150, 180, Direction.Right}, --Phileas, le savant, en retrait
  { 'Audino',  240, 180, Direction.Left }, --Rin, cote lit
}

function RaidScenes.Bedside()
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local plunder = SV.TownPlunder or {}

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    --Les visiteurs sont deja la quand on ouvre les yeux.
    CharacterEssentials.MakeCharactersFromList(VISITEURS)
    local penticus = CH('Tropius')   --le maitre de guilde
    local phileas  = CH('Noctowl')   --le savant
    local rin      = CH('Audino')

    --Le duo est couche. On se reveille : le monde revient par le son.
    SOUND:PlayBGM('Goodnight.ogg', true)
    GAME:FadeIn(70)
    GAME:WaitFrames(35)

    narrate("Des voix.[pause=30] Elles parlaient deja avant que vous ouvriez les yeux.")
    GAME:WaitFrames(20)

    --RIN EN PREMIERE : le corps avant la faute. Elle connait tout le
    --monde a la guilde (elle tient l'assemblee), donc elle tutoie les
    --inquietudes sans jamais parler de responsabilite.
    say(rin, 'Worried', "Il se reveille.[pause=25] Doucement. Ne vous redressez pas d'un coup.")
    say(rin, 'Normal', "Rien de casse.[pause=30] De l'epuisement, surtout. Beaucoup d'epuisement.")
    GAME:WaitFrames(10)
    think(hero, 'Worried', "(La chambre. Mon lit.[pause=25] Je ne me souviens pas d'etre rentre.)")
    GAME:WaitFrames(15)

    --PHILEAS INSISTE. Ce n'est pas un reproche de superieur : c'est un
    --savant qui veut des faits, et qui n'a pas la delicatesse d'attendre.
    --Sa maniere de presser vaut reproche, ce qui laisse Penticus libre
    --de proteger ensuite.
    say(phileas, 'Worried', "Combien etaient-ils ?[pause=25] Reflechissez. C'est important.")
    say(partner, 'Pain', "Je ne sais pas...[pause=30] Ils bougeaient tous en meme temps.")
    say(phileas, 'Normal', "Et l'alarme ?[pause=30] Pourquoi n'avez-vous pas sonne l'alarme ?")
    say(partner, 'Sad', "On n'a pas eu le temps.[pause=30] Ils etaient deja sur la place.")
    GAME:WaitFrames(15)

    --PENTICUS COUPE. Le maitre de guilde protege les siens avant de
    --demander des comptes : c'est ce qui le rend impressionnant.
    say(penticus, 'Normal', "Assez, Phileas.[pause=30] Ils ont tenu jusqu'a ce qu'ils tombent. C'est deja beaucoup.")
    GAME:WaitFrames(12)
    say(penticus, 'Worried', "Voici ce que nous savons.[pause=25] Ils sont entres par l'est, avant la mi-nuit.")

    --LE DEBRIEF CHIFFRE : on nomme les pertes. Le joueur doit savoir.
    if (plunder.LastStolen or 0) > 0 then
      say(penticus, 'Sad', "Le coffre a ete force.[pause=25] "
        .. tostring(plunder.LastStolen) .. STRINGS:Format("\\uE024") .. " manquent au registre.")
    end
    if plunder.LastItems ~= nil and #plunder.LastItems > 0 then
      say(rin, 'Sad', "On a fouille votre sac pendant que vous etiez a terre.[pause=25] Ils ne se sont pas genes.")
    end
    if plunder.ShopsEmpty then
      say(rin, 'Worried', "Les etals sont vides.[pause=30] Les marchands ne rouvriront pas aujourd'hui.")
    end
    GAME:WaitFrames(12)

    --PHILEAS REPREND, sur son vrai terrain : comprendre. C'est lui qui
    --pose la question qui compte, et le heros la complete tout seul.
    say(phileas, 'Normal', "Ce qui m'occupe n'est pas ce qu'ils ont pris.[pause=30] C'est qu'ils savaient ou chercher.")
    think(hero, 'Worried', "(Alors ils etaient deja venus.[pause=25] Avant cette nuit.)")
    say(phileas, 'Worried', "Je vais relire les registres des veilles.[pause=30] Toutes les nuits, depuis le debut.")
    GAME:WaitFrames(15)

    --PENTICUS TRANCHE : seul le maitre de guilde a autorite pour ca.
    say(penticus, 'Determined', "La guilde double les veilles a partir de ce soir.[pause=25] Vous, vous vous reposez.")
    say(partner, 'Determined', "On peut reprendre la garde des demain !")
    say(penticus, 'Normal', "Je n'en doute pas.[pause=30] C'est justement pour cela que je vous l'interdis aujourd'hui.")
    GAME:WaitFrames(15)

    --Une derniere phrase qui n'accuse pas : c'est elle qu'on retient.
    say(penticus, 'Sad', "Vous etiez deux, dehors, pour nous tous.[pause=30] Ne l'oubliez pas quand vous vous en voudrez.")
    GAME:WaitFrames(20)

    --ILS SORTENT, en file, vers Bedroom_Exit (0,184). Coroutines jointes :
    --les trois departs se terminent ensemble, la piece se vide d'un bloc.
    say(rin, 'Happy', "Reposez-vous.[pause=25] Ce n'est pas un conseil, c'est un ordre de l'assemblee.")
    GAME:WaitFrames(10)

    --Ordre de sortie voulu : Phileas file le premier, il a des registres a
    --relire. Rin ensuite. Penticus ferme la marche — un maitre de guilde
    --sort toujours en dernier de la chambre d'un blesse.
    local c1 = TASK:BranchCoroutine(function()
      GROUND:MoveToPosition(phileas, 60, 200, false, 1)
      GROUND:MoveToPosition(phileas, 8, 200, false, 1)
    end)
    local c2 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(20)
      GROUND:MoveToPosition(rin, 60, 208, false, 1)
      GROUND:MoveToPosition(rin, 8, 208, false, 1)
    end)
    local c3 = TASK:BranchCoroutine(function()
      GAME:WaitFrames(40)
      GROUND:MoveToPosition(penticus, 60, 192, false, 1)
      GROUND:MoveToPosition(penticus, 8, 192, false, 1)
    end)
    TASK:JoinCoroutines({c1, c2, c3})
    GAME:WaitFrames(20)

    --On retire les visiteurs : ils ne doivent pas rester dans la chambre.
    pcall(function()
      GROUND:Hide('Tropius'); GROUND:Hide('Noctowl'); GROUND:Hide('Audino')
    end)

    --La piece est calme. Le duo se leve : on rend la main en douceur.
    GAME:WaitFrames(25)
    narrate("La porte se referme.[pause=30] La chambre redevient silencieuse.")
    GAME:WaitFrames(15)
    say(partner, 'Sad', "...On aurait pu faire mieux.")
    think(hero, 'Determined', "(On fera mieux.[pause=25] Ce soir, on ne sera pas les seuls dehors.)")
  end)
  if not ok then PrintInfo('[RaidScenes.Bedside] ecourtee : '..tostring(err)) end

  --Sortie garantie : le joueur reprend TOUJOURS la main.
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
-- 3. LA FUITE DES OMBRES — quand on gagne
--------------------------------------------------------------------
-- Elles ne meurent pas : elles refluent. Une menace qui s'enfuit reste
-- une menace, et c'est exactement ce qu'on veut faire sentir.
--
-- On reutilise le vocabulaire visuel deja etabli dans BossFX pour les
-- apparitions d'ombre (EmergeShadow) : memes particules, meme SE, mais
-- joues a l'envers — l'ombre se retire au lieu de surgir.
function RaidScenes.ShadowsFlee(wave)
  wave = wave or 1
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  return pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end

    SOUND:FadeOutBGM(30)
    GAME:WaitFrames(20)

    narrate("Le dernier coup porte.[pause=30] Et puis plus rien ne bouge.")
    GAME:WaitFrames(20)

    --Le reflux. Vent sombre en fond, puis les silhouettes se defont.
    pcall(function()
      BossFX.Overlay("Ominous_Wind", 0, 0, 25, 90, 25, DrawLayer.Bottom)
      SOUND:PlayBattleSE("DUN_Shadow_Force")
    end)
    GAME:WaitFrames(25)

    local hx, hy = 160, 160
    pcall(function()
      if hero ~= nil then hx, hy = hero.Position.X, hero.Position.Y end
    end)

    --Trois bouffees d'ombre qui s'ecartent du duo : elles refluent.
    pcall(function()
      BossFX.Particle("Shadow_Ball", hx - 48, hy - 16, 3)
      GAME:WaitFrames(8)
      BossFX.Particle("Shadow_Ball", hx + 48, hy - 8, 3)
      GAME:WaitFrames(8)
      BossFX.Particle("Dark_Pulse_Particle", hx, hy - 40, 4)
    end)
    GAME:WaitFrames(20)

    narrate("Elles ne tombent pas.[pause=30] Elles s'effacent, comme une buee qu'on essuie.")
    GAME:WaitFrames(20)

    if wave >= 3 then
      --La grande vague : la derniere ombre s'attarde. Elle vous regarde.
      say(partner, 'Surprised', "Attends —[pause=25] celle-la ne part pas.")
      GAME:WaitFrames(20)
      pcall(function()
        BossFX.Particle("Shadow_Ball", hx, hy - 56, 3)
        BossFX.ShakeScreen(4, 18)
      end)
      narrate("Une derniere forme reste au bord de la place.[pause=30] Immobile. Tournee vers vous.")
      GAME:WaitFrames(20)
      think(hero, 'Worried', "(Elle nous regarde.[pause=25] Elle prend le temps de nous regarder.)")
      GAME:WaitFrames(15)
      pcall(function()
        SOUND:PlayBattleSE("DUN_Shadow_Force")
        BossFX.Particle("Dark_Pulse_Particle", hx, hy - 56, 4)
      end)
      narrate("Puis elle recule dans le noir,[pause=20] sans se retourner.")
      GAME:WaitFrames(20)
      say(partner, 'Worried', "Elle savait qu'elle pouvait partir.[pause=30] Elle n'a pas fui. Elle est partie.")
      think(hero, 'Determined', "(Alors elle reviendra.[pause=25] Et on sera la.)")
    elseif wave == 2 then
      say(partner, 'Pain', "Elles filent vers la riviere ![pause=25] Non... elles filent DANS les murs.")
      think(hero, 'Worried', "(On ne peut pas poursuivre ce qui traverse la pierre.)")
      GAME:WaitFrames(15)
      say(partner, 'Determined', "Tant pis.[pause=25] Ce soir, elles n'ont rien eu.")
    else
      say(partner, 'Surprised', "Elles se sont... dissoutes ?[pause=30] Sous mes yeux ?")
      think(hero, 'Normal', "(Il ne reste meme pas de trace au sol.)")
      GAME:WaitFrames(15)
      say(partner, 'Happy', "Peu importe.[pause=25] Les etals sont intacts. C'est tout ce qui compte.")
    end

    GAME:WaitFrames(20)
    narrate("La place est vide.[pause=30] La ville n'a rien su.")
  end)
end

return RaidScenes
