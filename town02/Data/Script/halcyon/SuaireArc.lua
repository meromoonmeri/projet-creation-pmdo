--[[
    SuaireArc.lua — Arc 2 « Ce que la brume emporte »

    5 quêtes secondaires liées à l'intrigue globale, jouables entre le ch6 et
    le ch12. Chaque quête se conclut par un ACTE cinématique joué à la sortie
    du donjon concerné.

    LES TROIS FILS, ENTRELACÉS (choix utilisateur : « tous ») :
      * Cercle du Suaire  — ils volent des éclats de Cœur. Fil principal,
        déjà amorcé au ch6 par la rumeur « la brume aux trois silhouettes ».
      * Rêves du héros    — chaque éclat repris réveille un fragment de la
        mémoire du dernier gardien du sceau (préparation lointaine du twist).
      * Escouade Fulgur   — rivaux sur la même piste ; l'acte IV bascule la
        rivalité en trêve, préfigurant l'alliance de l'arc 4.

    RÈGLES RESPECTÉES : jamais « Necrozma », « Eternatus », « l'Abîme » ; la
    Voix et le Suaire restent énigmatiques ; français idiomatique ; ton des
    chapitres 1-3 (répliques courtes, une idée par boîte).

    Aucun boss n'est ajouté : les actes sont des cinématiques de fin de donjon.
]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.CharacterEssentials'
require 'halcyon.BossFX'
require 'halcyon.SuaireJobs'

SuaireArc = {}

-- Donjon -> numéro d'acte. Un seul point de vérité pour tout le module.
SuaireArc.ACTS = {
  bosquet_voile  = 1,
  grotte_mystere = 2,
  jardin_secret  = 3,
  col_foudre     = 4,
  antre_enigme   = 5,
}

--------------------------------------------------------------------
-- Utilitaires
--------------------------------------------------------------------
local function sv()
  if SV.SuaireArc == nil then SV.SuaireArc = {} end
  local s = SV.SuaireArc
  if s.CurrentAct == nil then s.CurrentAct = 0 end
  if s.ShardsRecovered == nil then s.ShardsRecovered = 0 end
  if s.DreamFragments == nil then s.DreamFragments = 0 end
  return s
end

--Cet acte est-il celui que le joueur doit jouer maintenant ?
function SuaireArc.IsActReady(zoneID)
  local n = SuaireArc.ACTS[zoneID]
  if n == nil then return false end
  local s = sv()
  if not s.Unlocked then return false end
  if s['Act'..n..'Done'] then return false end
  --les actes s'enchaînent : l'acte N exige l'acte N-1
  if n > 1 and not s['Act'..(n-1)..'Done'] then return false end
  return true
end

local function line(who, emo, txt)
  UI:SetSpeaker(who)
  if emo ~= nil then GeneralFunctions.SetEmotion(emo) end
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(10)
end

local function narrate(txt)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(txt)
  UI:SetCenter(false)
  GAME:WaitFrames(10)
end

--La Voix : jamais nommée, jamais incarnée.
--Le héros est le SEUL à l'entendre, et l'entendre lui coûte : l'écran tangue
--et il a un haut-le-cœur juste avant. Les autres ne réagissent pas — pour eux,
--il ne s'est rien passé.
local function voice(txt)
  pcall(function()
    local hero = CH('PLAYER')
    if hero ~= nil then
      GROUND:CharSetEmote(hero, "shock", 1)
      GROUND:CharSetAnim(hero, "Hurt", true)
    end
    GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 5, 26))
    GAME:WaitFrames(26)
  end)

  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowDialogue(txt)
  GAME:WaitFrames(12)

  pcall(function()
    local hero = CH('PLAYER')
    if hero ~= nil then
      GROUND:CharSetEmote(hero, "", 0)
      GROUND:CharSetAnim(hero, "Idle", true)
    end
  end)
end

--Un fragment de mémoire du gardien du sceau. Toujours la même grammaire :
--flash blanc bref, image sans contexte, retour brutal.
local function dream(hero, partner, txt1, txt2)
  local s = sv()
  s.DreamFragments = s.DreamFragments + 1
  SOUND:FadeOutBGM(40)
  BossFX.Flash(GAME:GetCameraCenter().X, GAME:GetCameraCenter().Y, 4, 8, 30)
  GAME:WaitFrames(20)
  narrate(txt1)
  if txt2 ~= nil then narrate(txt2) end
  GAME:WaitFrames(15)
  if partner ~= nil then
    line(partner, "Worried", "Hé...[pause=20] Hé ![pause=15] Tu étais parti, là.")
  end
  GeneralFunctions.HeroDialogue(hero, "...Je ne sais pas où j'étais.", "Worried")
end

--------------------------------------------------------------------
-- ACTE I — Bosquet Voilé : le premier éclat
-- Fil : Suaire (on ne voit qu'une silhouette). Rêve : premier fragment.
--------------------------------------------------------------------
function SuaireArc.Act1(hero, partner)
  narrate("Le bosquet est trop silencieux.[pause=20] Pas un insecte, pas un souffle.")
  if partner ~= nil then
    line(partner, "Worried", "Les fleurs sont fanées d'un seul côté...[pause=20] celui du sol.")
    line(partner, "Surprised", "Exactement comme la rumeur en ville.[pause=15] Je croyais qu'on exagérait.")
  end
  GeneralFunctions.HeroDialogue(hero, "Quelqu'un est passé avant nous.", "Normal")

  narrate("Au pied d'un arbre mort, une pierre pâle affleure.[pause=20] Il en manque un morceau,[pause=10] arraché net.")
  if partner ~= nil then
    line(partner, "Surprised", "C'est un Cœur ![pause=15] Un petit, mais c'en est un !")
    line(partner, "Sad", "Et on lui a pris un éclat.[pause=20] Récemment.")
  end

  --La silhouette : vue de dos, jamais de face.
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  narrate("Une silhouette se lève dans la brume, à vingt pas.[pause=20] Elle ne court pas.[pause=15] Elle s'efface.")
  if partner ~= nil then
    line(partner, "Surprised", "Hé ![pause=10] Toi, là !")
  end
  narrate("La brume se referme.[pause=20] Il ne reste qu'une odeur d'encens froid.")

  --Fragment de mémoire n°1.
  dream(hero, partner,
    "Une main pose une pierre pâle dans une niche de roche.[pause=20] Il y en a des dizaines,[pause=10] alignées.",
    "Une voix, très loin :[pause=20] « Compte-les. Tant qu'elles brillent, il dort. »")

  if partner ~= nil then
    line(partner, "Worried", "On rentre le dire à la guilde.[pause=20] Quelqu'un vole des éclats de Cœur.")
  end
  local s = sv()
  s.ShardsRecovered = s.ShardsRecovered + 0  --acte I : on ne récupère rien, on constate
  s.Act1Done = true
  s.CurrentAct = 2
end

--------------------------------------------------------------------
-- ACTE II — Grotte du Mystère : la marque des bâtisseurs
-- Fil : lore du sceau. On récupère le premier éclat.
--------------------------------------------------------------------
function SuaireArc.Act2(hero, partner)
  narrate("La paroi du fond n'est pas de la roche brute.[pause=20] Elle a été taillée,[pause=10] il y a très longtemps.")
  if partner ~= nil then
    line(partner, "Surprised", "Regarde ces rainures...[pause=20] C'est le même motif que sur les Terminaux !")
    line(partner, "Normal", "Les bâtisseurs sont venus jusqu'ici.[pause=20] Pourquoi si loin ?")
  end
  GeneralFunctions.HeroDialogue(hero, "Parce qu'il y avait quelque chose à garder.", "Normal")

  narrate("Dans une niche, un éclat de Cœur a été abandonné en hâte.[pause=20] Comme si on avait été dérangé.")
  if partner ~= nil then
    line(partner, "Inspired", "Ils l'ont laissé tomber ![pause=15] On le récupère !")
  end

  voice("Tu ramasses ce que d'autres ont jugé bon d'emporter.")
  if partner ~= nil then
    line(partner, "Surprised", "Encore cette voix ![pause=20] Elle nous suit depuis la steppe...")
  end
  voice("Ils ne volent pas par cupidité, petit.[pause=25] Demande-toi ce qu'ils croient éteindre.")
  GeneralFunctions.HeroDialogue(hero, "« Éteindre »...[pause=20] Pas « prendre ». Éteindre.", "Worried")

  dream(hero, partner,
    "La même niche, intacte.[pause=20] Une silhouette encapuchonnée retire une pierre et la brise contre le sol.",
    "« Une de moins pour le nourrir. »[pause=25] La voix tremble.[pause=15] Elle pleure.")

  if partner ~= nil then
    line(partner, "Worried", "Celui qui les prend...[pause=20] il pense faire le bien ?")
  end
  local s = sv()
  s.ShardsRecovered = s.ShardsRecovered + 1
  s.Act2Done = true
  s.CurrentAct = 3
end

--------------------------------------------------------------------
-- ACTE III — Jardin Secret : le témoin
-- Fil : on voit le Suaire de face pour la première fois.
--------------------------------------------------------------------
function SuaireArc.Act3(hero, partner)
  local suaire = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Banette', 184, 168, Direction.Down}
  })
  GROUND:Hide('Suaire_Banette')

  narrate("Le jardin a poussé sans personne pour s'en occuper.[pause=20] Et pourtant rien n'y est mort.")
  if partner ~= nil then
    line(partner, "Normal", "C'est... paisible.[pause=20] Presque trop.")
  end

  SOUND:FadeOutBGM(40)
  narrate("L'encens froid, de nouveau.[pause=20] Cette fois, il ne s'éloigne pas.")
  BossFX.Flash(184, 168, 3, 5, 20)
  GAME:WaitFrames(10)
  GROUND:Unhide('Suaire_Banette')
  BossFX.Impact(8)
  SOUND:PlayBGM('Growing Anxiety.ogg', true)
  UI:WaitShowTitle("Le Cercle du Suaire", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  line(suaire, nil, "Tu me suis depuis le bosquet.[pause=25] Tu es lent.")
  if partner ~= nil then
    line(partner, "Determined", "Rends ce que tu as pris ![pause=15] Ces éclats ne sont pas à toi !")
  end
  line(suaire, nil, "À toi non plus.[pause=25] Ils n'appartiennent à personne.[pause=20] C'est bien le problème.")
  GeneralFunctions.HeroDialogue(hero, "Pourquoi les briser ?", "Worried")
  line(suaire, nil, "...")
  line(suaire, nil, "Parce qu'on nous a confié une consigne,[pause=15] et qu'on l'a mal comprise pendant six cents ans.")
  line(suaire, nil, "Nous corrigeons.")

  if partner ~= nil then
    line(partner, "Surprised", "Six cents...[pause=20] Qu'est-ce que tu racontes ?")
  end
  narrate("La brume monte du sol et l'enveloppe.[pause=20] Il ne recule pas :[pause=10] il se laisse effacer.")
  narrate("Un éclat roule à vos pieds.[pause=20] Laissé exprès.")

  voice("Il t'a donné quelque chose.[pause=25] Demande-toi pourquoi.")

  dream(hero, partner,
    "Un cercle de silhouettes encapuchonnées.[pause=20] Elles récitent, toutes ensemble.",
    "« Ce qui brille appelle. Ce qui s'éteint oublie. »")

  local s = sv()
  s.ShardsRecovered = s.ShardsRecovered + 1
  s.SawSuaireFace = true
  s.Act3Done = true
  s.CurrentAct = 4
end

--------------------------------------------------------------------
-- ACTE IV — Col de la Foudre : la course
-- Fil : Escouade Fulgur. Rivalité -> trêve.
--------------------------------------------------------------------
function SuaireArc.Act4(hero, partner)
  local voltra = CharacterEssentials.MakeCharactersFromList({
    {'Fulgur_Luxray', 168, 176, Direction.DownRight}
  })
  local aegis = CharacterEssentials.MakeCharactersFromList({
    {'Fulgur_Lucario', 200, 176, Direction.DownLeft}
  })

  narrate("Quelqu'un est déjà là-haut.[pause=20] Deux silhouettes,[pause=10] et de l'électricité dans l'air.")
  SOUND:PlayBGM('Rising Fear.ogg', true)

  line(voltra, "Normal", "Tiens.[pause=20] La petite équipe de Metano.[pause=15] Vous avez mis le temps.")
  if partner ~= nil then
    line(partner, "Surprised", "L'Escouade Fulgur ![pause=15] Qu'est-ce que vous faites ici ?")
  end
  line(voltra, "Normal", "Notre travail.[pause=20] La guilde nous a chargés d'inspecter les Cœurs.[pause=15] Comme vous,[pause=10] j'imagine.")
  line(aegis, "Normal", "Sauf que nous, on est arrivés premiers.")

  GeneralFunctions.HeroDialogue(hero, "Alors vous avez vu la pierre brisée.", "Normal")
  line(voltra, "Worried", "...Oui.")
  line(voltra, "Normal", "Trois éclats manquants sur ce Cœur-là.[pause=20] Pas volés au hasard :[pause=15] choisis.")
  line(aegis, "Worried", "Et la brume est arrivée avant nous.[pause=20] On ne l'a pas devancée une seule fois.")

  if partner ~= nil then
    line(partner, "Determined", "Nous non plus.[pause=20] Quatre donjons,[pause=10] toujours un pas derrière.")
  end
  line(voltra, "Normal", "...")
  line(voltra, "Determined", "Écoute-moi bien, parce que je ne le répéterai pas.")
  line(voltra, "Determined", "Tant que cette brume court,[pause=20] le classement de la guilde ne m'intéresse pas.")
  line(voltra, "Normal", "On partage ce qu'on trouve.[pause=20] Vous et nous.[pause=15] Après,[pause=10] on redevient rivaux.")

  GeneralFunctions.HeroDialogue(hero, "Après.", "Determined")
  line(aegis, "Normal", "Il parle peu, celui-là.[pause=20] Ça me va.")

  narrate("Voltra dépose un éclat récupéré dans votre sac,[pause=15] sans un mot de plus.")
  voice("Deux équipes qui s'allient.[pause=25] Le sceau n'a jamais été aussi bien gardé...[pause=20] ni aussi près de céder.")
  if partner ~= nil then
    line(partner, "Worried", "Elle a dit « le sceau » ?")
  end

  dream(hero, partner,
    "Des dizaines de silhouettes, autrefois. Elles se relaient devant les niches.[pause=20] Elles rient.",
    "Puis le froid.[pause=20] Puis plus personne.[pause=15] Et les pierres qui brillent toutes seules,[pause=10] pendant des siècles.")

  local s = sv()
  s.ShardsRecovered = s.ShardsRecovered + 1
  s.FulgurTruce = true
  s.Act4Done = true
  s.CurrentAct = 5
end

--------------------------------------------------------------------
-- ACTE V — Antre de l'Énigme : ce que le Suaire protège
-- Fil : convergence des trois. Aucune réponse claire — on prépare l'arc 3.
--------------------------------------------------------------------
function SuaireArc.Act5(hero, partner)
  local suaire = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Banette', 184, 160, Direction.Down}
  })
  local linceul = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Gengar', 152, 176, Direction.DownRight}
  })
  local litanie = CharacterEssentials.MakeCharactersFromList({
    {'Suaire_Noivern', 216, 176, Direction.DownLeft}
  })
  GROUND:Hide('Suaire_Banette')
  GROUND:Hide('Suaire_Gengar')
  GROUND:Hide('Suaire_Noivern')

  narrate("L'antre s'ouvre sur une salle ronde.[pause=20] Des niches vides,[pause=10] partout,[pause=10] jusqu'au plafond.")
  if partner ~= nil then
    line(partner, "Surprised", "Il y en a des centaines...[pause=20] et pas une seule pierre.")
    line(partner, "Sad", "Tout a déjà été emporté.")
  end

  SOUND:FadeOutBGM(60)
  narrate("Trois souffles dans le noir.[pause=20] Ils vous attendaient.")
  for _, n in ipairs({'Suaire_Banette', 'Suaire_Gengar', 'Suaire_Noivern'}) do
    BossFX.Flash(184, 168, 3, 4, 16)
    GROUND:Unhide(n)
    GAME:WaitFrames(10)
  end
  BossFX.Impact(9)
  SOUND:PlayBGM('The Power of Darkness.ogg', true)
  UI:WaitShowTitle("Le Cercle du Suaire", 20)
  GAME:WaitFrames(50)
  UI:WaitHideTitle(20)

  line(suaire, nil, "Tu as rendu quatre éclats à la guilde.[pause=25] Nous en avons brisé quarante.")
  line(linceul, nil, "Il ne comprend pas, Suaire.[pause=20] Regarde-le.")
  line(litanie, nil, "Il comprendra.[pause=20] Ils comprennent toujours.[pause=15] Trop tard,[pause=10] mais ils comprennent.")

  if partner ~= nil then
    line(partner, "Determined", "Alors expliquez ![pause=15] Au lieu de casser ce qui protège le monde !")
  end
  line(suaire, nil, "Protège.")
  line(suaire, nil, "Voilà le mot que vos guildes répètent depuis six cents ans sans jamais l'interroger.")
  GeneralFunctions.HeroDialogue(hero, "Et si on l'interrogeait maintenant ?", "Determined")

  line(suaire, nil, "...")
  line(suaire, nil, "Une lumière qui protège n'a pas besoin d'être si vaste.")
  line(suaire, nil, "Celle-ci couvre un continent.[pause=25] Demande-toi ce qu'on enferme avec un mur pareil.")

  --La litanie, entendue en entier pour la première fois.
  narrate("Les trois récitent ensemble,[pause=15] à voix basse.")
  narrate("« Ce qui brille appelle.[pause=15] Ce qui s'éteint oublie.[pause=15] Que l'oubli nous couvre tous. »")

  if partner ~= nil then
    line(partner, "Worried", "« Enferme »...[pause=20] Il a dit enferme ?")
  end
  line(litanie, nil, "Nous ne sommes pas vos ennemis, petits.[pause=25] Nous sommes ce qu'il reste de ceux qui ont posé les pierres.")
  narrate("La brume se referme sur eux.[pause=20] Aucun d'eux ne s'est battu.")

  voice("Ils t'ont dit la vérité.[pause=25] Pas toute.[pause=20] Mais plus que la guilde ne t'en dira.")

  dream(hero, partner,
    "La salle ronde, pleine.[pause=20] Chaque niche brille.[pause=15] Et sous le sol,[pause=10] très loin,[pause=10] quelque chose remue en dormant.",
    "La voix qui pleurait dit :[pause=20] « Ne les laisse jamais toutes s'éteindre.[pause=15] Ne les laisse jamais toutes briller. »")

  if partner ~= nil then
    line(partner, "Worried", "Ni tout éteindre...[pause=20] ni tout allumer ?[pause=15] Mais alors on fait quoi ?")
  end
  GeneralFunctions.HeroDialogue(hero, "On trouve ce qu'il y a en dessous.", "Determined")

  local s = sv()
  s.ShardsRecovered = s.ShardsRecovered + 1
  s.HeardLitany = true
  s.Act5Done = true
  s.CurrentAct = 6
end

--------------------------------------------------------------------
-- Point d'entrée unique : appelé depuis l'ExitSegment du donjon.
-- Renvoie true si un acte a été joué (l'appelant enchaîne alors sur sa
-- sortie normale).
--------------------------------------------------------------------
function SuaireArc.PlayAct(zoneID)
  if not SuaireArc.IsActReady(zoneID) then return false end
  local n = SuaireArc.ACTS[zoneID]
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  PrintInfo("[SuaireArc] acte "..tostring(n).." — "..tostring(zoneID))
  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end
  GAME:WaitFrames(20)

  local body = ({SuaireArc.Act1, SuaireArc.Act2, SuaireArc.Act3,
                 SuaireArc.Act4, SuaireArc.Act5})[n]
  local ok, err = pcall(body, hero, partner)
  if not ok then
    --Jamais d'écran noir : on log et on sort quand même.
    PrintInfo("[SuaireArc] ERREUR acte "..tostring(n)..": "..tostring(err))
    local s = sv()
    s['Act'..n..'Done'] = true
    s.CurrentAct = n + 1
  end

  --Le contrat correspondant passe a « accompli » sur le tableau des missions.
  pcall(function() SuaireJobs.MarkDone(zoneID) end)

  GAME:WaitFrames(20)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(30)
  GAME:CutsceneMode(false)
  return true
end

return SuaireArc
