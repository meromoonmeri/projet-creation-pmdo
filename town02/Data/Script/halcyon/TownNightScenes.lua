--[[
    TownNightScenes.lua

    LES CINEMATIQUES DE LA NUIT
    ================================================================
    POURQUOI CE MODULE EXISTE
    ------------------------------------------------------------------
    La carte de nuit (metano_town_nuit) et ses habitants (TownNight)
    donnaient un DECOR : une ville plus sombre, trois PNJ de plus. Un
    decor ne raconte rien. Si la nuit n'est qu'un lieu de plus a
    visiter, le joueur y va une fois et n'y revient jamais.

    Ce module fait de la nuit un TEMPS NARRATIF. Trois principes, qui
    reprennent la grammaire deja etablie dans ChapterScenes.lua :

      1. ON ETABLIT LE LIEU AVANT LES PERSONNAGES.
         Le silence et la musique montent avant le premier mot.

      2. LA NUIT DIT CE QUE LE JOUR TAIT.
         Chaque chapitre a sa propre nuit, accrochee a l'etat REEL du
         scenario (SV.ChapterN, champs verifies dans scriptvars.lua).
         La nuit du ch6 n'est pas celle du ch9.

      3. LA NUIT EST LE MOMENT OU LE HEROS EST SEUL.
         C'est la que la Voix parle le mieux : tout dort, plus rien ne
         couvre. On reutilise VoiceVisions.Speak, sans le dupliquer.

    ------------------------------------------------------------------
    LA LOGIQUE : POURQUOI CHAQUE NUIT TOMBE JUSTE
    ------------------------------------------------------------------
    Chaque nuit commente ce que le joueur VIENT DE VIVRE, jamais ce
    qu'il n'a pas encore vu. Les etats lus sont ceux qui existent :

      ch6  SV.Chapter6.ChenipentFound / DefeatedGloomyBoss
           -> la ville a eu peur pour un enfant perdu en foret.
      ch7  SV.Chapter7.HeardGenesisTale / HadFirstDream
           -> le heros a entendu le recit des origines. Il ne dort plus.
      ch8  SV.Chapter8.ObtainedCrystalFragment
           -> il rapporte un objet qui n'aurait pas du sortir de la.
      ch9  SV.Chapter9.SawCercleDuSuaire
           -> quelqu'un d'autre cherche la meme chose que lui.
      ch10 SV.Chapter10.SawNecrozmaVision (nom de champ interne)
           -> la derniere nuit avant la fin. La ville ne sait pas.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison » dans
      un texte affiche. Les noms de CHAMPS internes ne sont pas des
      textes affiches.
    * La Voix reste anonyme (\uE040), portee par VoiceVisions.
    * Texte litteral francais (module global : MapStrings ne resoudrait
      pas, meme raison que SuaireArc.lua et ChapterScenes.lua).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall, sortie garantie : une cinematique qui casse ne
      doit jamais laisser le joueur fige dans une ville endormie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.VoiceVisions'

TownNightScenes = {}

--------------------------------------------------------------------
-- HELPERS (memes noms et memes roles que dans ChapterScenes.lua)
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

--Numero de chapitre courant, jamais nil.
local function chap()
  return (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
end

--Enveloppe commune : coupe l'IA du partenaire, joue, rend la main.
--La sortie est GARANTIE, meme si la scene plante en plein milieu.
local function Cutscene(body)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    body(hero, partner)
  end)
  if not ok then PrintInfo('[TownNightScenes] scene ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)
  return ok
end

--------------------------------------------------------------------
-- 1. L'ARRIVEE — une par chapitre
--------------------------------------------------------------------
-- Appelee par TownNight.Arrival() a la place du texte generique.
-- Chaque chapitre ouvre sa nuit AUTREMENT : registre, sujet et humeur
-- du partenaire changent. Aucune ne commence par la meme phrase.
local ARRIVALS = {}

--CH6 — LA VILLE A EU PEUR. On vient de ramener un enfant de la foret.
ARRIVALS[6] = function(hero, partner)
  local c6 = SV.Chapter6 or {}
  narrate("Metano, la nuit.[pause=25] On n'entend que la rivière.")
  GAME:WaitFrames(20)
  if c6.ChenipentFound then
    narrate("Une fenêtre est restée allumée, au sud.[pause=25] Une seule.")
    say(partner, 'Normal', "C'est la maison du petit.[pause=25] Ses parents n'éteignent plus, on dirait.")
    think(hero, 'Worried', "(Il est rentré. Il dort. Et ils laissent quand même la lumière.)")
    say(partner, 'Sad', "Ça doit être ça, avoir peur pour quelqu'un.[pause=30] On continue même quand c'est fini.")
  else
    say(partner, 'Worried', "Tout le monde s'est couché tôt.[pause=25] Personne ne dit pourquoi.")
    think(hero, 'Normal', "(La forêt est de ce côté-là.[pause=20] Ils ferment les volets qui donnent dessus.)")
  end
end

--CH7 — LE HEROS NE DORT PLUS. Le recit des origines lui reste en travers.
ARRIVALS[7] = function(hero, partner)
  local c7 = SV.Chapter7 or {}
  narrate("La ville dort.[pause=25] Vous, non. Pas depuis les ruines.")
  GAME:WaitFrames(20)
  if c7.HeardGenesisTale then
    think(hero, 'Worried', "(Le récit tourne encore.[pause=25] Chaque fois que je ferme les yeux, il recommence.)")
    say(partner, 'Worried', "Tu n'as pas fermé l'œil, hein ?[pause=30] Moi non plus.")
    say(partner, 'Sad', "Ce qu'on a entendu là-bas...[pause=25] ça ne devrait pas être une histoire pour enfants.")
    think(hero, 'Normal', "(Sauf que ce n'en était pas une.[pause=20] C'est bien le problème.)")
  else
    say(partner, 'Normal', "Marcher, ça vaut mieux que se retourner dans son lit.")
    think(hero, 'Worried', "(Les pierres des ruines avaient cette odeur.[pause=25] Elle est encore sur moi.)")
  end
end

--CH8 — IL RAPPORTE QUELQUE CHOSE. Registre : la beaute qui met mal a l'aise.
ARRIVALS[8] = function(hero, partner)
  local c8 = SV.Chapter8 or {}
  narrate("Il n'y a pas un souffle.[pause=30] Les volets sont tirés, sauf deux ou trois.")
  GAME:WaitFrames(20)
  if c8.ObtainedCrystalFragment then
    narrate("Dans votre sac, quelque chose accroche la lune.[pause=25] Même à travers la toile.")
    say(partner, 'Surprised', "Il brille encore.[pause=25] Dans le noir complet, il brille.")
    think(hero, 'Worried', "(Un caillou ne fait pas ça.[pause=20] Un caillou attend qu'on l'éclaire.)")
    say(partner, 'Worried', "On l'a sorti de là-bas.[pause=30] Tu crois qu'on avait le droit ?")
    think(hero, 'Normal', "(Je ne sais pas.[pause=25] Personne ne nous a dit non. Ce n'est pas pareil.)")
  else
    say(partner, 'Normal', "La lumière de la lune sur les toits...[pause=25] ça ressemble un peu à là-bas.")
    think(hero, 'Worried', "(En moins beau.[pause=20] Et c'est rassurant, d'être en moins beau.)")
  end
end

--CH9 — QUELQU'UN D'AUTRE CHERCHE. Registre : la surveillance, le doute.
ARRIVALS[9] = function(hero, partner)
  local c9 = SV.Chapter9 or {}
  narrate("La ville dort mal.[pause=30] Ça s'entend, une ville qui dort mal.")
  GAME:WaitFrames(20)
  if c9.SawCercleDuSuaire then
    say(partner, 'Worried', "Ne te retourne pas tout de suite.[pause=30] ...Bon. Il n'y a personne. J'ai cru.")
    think(hero, 'Worried', "(Depuis le marais, elle vérifie derrière elle.[pause=25] Moi aussi.)")
    say(partner, 'Sad', "Ils étaient là avant nous.[pause=25] Ils cherchaient la même chose que nous.")
    say(partner, 'Worried', "Si eux savent où aller...[pause=30] c'est qu'on n'a pas d'avance. On en a moins.")
  else
    say(partner, 'Pain', "J'ai encore l'odeur du marais sur moi.[pause=25] Trois bains n'y ont rien fait.")
    think(hero, 'Normal', "(Ce n'est pas sur nous que ça colle.[pause=20] C'est dedans.)")
  end
end

--CH10 — LA DERNIERE NUIT. Registre : la tendresse, et ce qu'on ne dit pas.
--Aucun mot interdit. Le poids vient de ce que la ville IGNORE.
ARRIVALS[10] = function(hero, partner)
  narrate("Metano, la nuit.[pause=30] Comme les autres nuits. Exactement comme les autres nuits.")
  GAME:WaitFrames(25)
  say(partner, 'Normal', "Regarde-les dormir.[pause=30] Ils ne savent rien de ce qui monte là-haut.")
  think(hero, 'Worried', "(Et c'est très bien.[pause=25] C'est même exactement pour ça qu'on y va.)")
  GAME:WaitFrames(15)
  say(partner, 'Sad', "Je voulais marcher ici une dernière fois.[pause=30] Avant. Juste marcher.")
  say(partner, 'Sad', "...Ne fais pas cette tête.[pause=25] J'ai dit « avant ». Pas autre chose.")
  GAME:WaitFrames(15)
  think(hero, 'Normal', "(Elle a raison.[pause=20] On rentrera. On rentrera et tout sera à sa place.)")
  narrate("La rivière continue.[pause=30] Elle n'a jamais eu besoin de savoir.")
end

--Nuits des chapitres 1-5 : le systeme n'y est pas branche (le choix de
--fin de journee n'existe qu'a partir du ch6). On garde malgre tout une
--ouverture correcte au cas ou une zone anterieure y mene un jour.
local function ArrivalGeneric(hero, partner, visits)
  if visits <= 1 then
    narrate("Metano, la nuit.[pause=25] On n'entend que la rivière.")
    say(partner, 'Normal', "Je n'étais jamais sorti à cette heure-ci.[pause=25] C'est la même ville, et pourtant non.")
    say(partner, 'Happy', "Allons voir qui ne dort pas.")
  else
    narrate("La ville dort.[pause=20] Les volets sont tirés, sauf deux ou trois.")
  end
end

--Point d'entree de l'arrivee. `visits` vient de SV.TownNight.Visits.
function TownNightScenes.Arrival(visits)
  visits = visits or 1
  local ch = chap()
  return Cutscene(function(hero, partner)
    SOUND:PlayBGM('Goodnight.ogg', true)
    GAME:WaitFrames(50)

    local fn = ARRIVALS[ch]
    --La scene propre au chapitre ne se joue qu'a la PREMIERE nuit de ce
    --chapitre : elle commente un evenement precis, la reservir chaque
    --soir la viderait de son sens.
    local s = SV.TownNight
    local key = 'Ch'..tostring(ch)
    if fn ~= nil and s ~= nil and not (s.Seen or {})[key] then
      if s.Seen == nil then s.Seen = {} end
      s.Seen[key] = true
      fn(hero, partner)
    else
      ArrivalGeneric(hero, partner, visits)
    end
  end)
end

--------------------------------------------------------------------
-- 2. LA VOIX AU PUITS — le coeur du dispositif
--------------------------------------------------------------------
-- POURQUOI LE PUITS, ET POURQUOI LA NUIT
-- Le puits est le seul endroit de Metano ou l'on se penche vers le bas
-- et ou l'on voit sa propre image. La nuit, l'eau noire renvoie aussi
-- le ciel — le meme ciel que la Compteuse d'Etoiles surveille depuis
-- vingt ans. Les deux fils se rejoignent sans qu'on ait a l'expliquer.
--
-- La Voix ne parle pas en ville de JOUR (regle du projet). La nuit, la
-- ville est vide : le heros est seul, ce qui est la condition meme du
-- dispositif. C'est la seule exception, et elle est motivee.
--
-- Une seule fois par chapitre, et seulement a partir du ch7 : avant, le
-- heros n'a pas encore entendu le recit des origines et la Voix n'a
-- aucune prise sur lui.
function TownNightScenes.WellVoice()
  local ch = chap()
  if ch < 7 then return false end

  local s = SV.TownNight
  if s == nil then return false end
  if s.VoiceHeard == nil then s.VoiceHeard = {} end
  local key = 'Ch'..tostring(ch)
  if s.VoiceHeard[key] then return false end
  s.VoiceHeard[key] = true

  local partner = CH('Teammate1')

  --Les paroles evoluent : la Voix se rapproche a mesure des chapitres.
  local lines
  if ch == 7 then
    lines = {
      "Tu t'es penché.[pause=30] Personne ne se penche, d'habitude.",
      "Ce que tu as entendu dans les ruines n'est pas fini.[pause=25] Ce n'est qu'un début de phrase.",
    }
  elseif ch == 8 then
    lines = {
      "Tu l'as sorti de là.[pause=30] Je l'ai senti bouger.",
      "Garde-le contre toi.[pause=25] Il se souvient d'un endroit où je ne peux pas aller.",
    }
  elseif ch == 9 then
    lines = {
      "D'autres marchent vers moi.[pause=30] Ils vont plus vite que toi.",
      "Ils ne cherchent pas la même chose.[pause=25] Ils cherchent à ce que ça continue.",
    }
  else
    lines = {
      "Demain.[pause=35] Tu le sais déjà, n'est-ce pas.",
      "Regarde-la bien, cette ville.[pause=30] Regarde-la comme on regarde ce qu'on va défendre.",
      "Je n'ai plus rien à t'apprendre.[pause=25] Monte.",
    }
  end

  VoiceVisions.Speak({
    level = (ch >= 10) and 3 or 2,
    witness = partner,
    lines = lines,
    heroLine = (ch >= 10)
      and "(...Je vais la défendre.[pause=25] Je ne sais pas encore comment, mais je vais la défendre.)"
      or "(Encore.[pause=30] Et toujours quand il n'y a personne pour l'entendre avec moi.)",
    witnessLines = { "Hé...[pause=25] Tu t'es figé au-dessus du puits.[pause=20] Tu es tout pâle." },
  })

  --Le monde revient. La musique de la nuit reprend, plus basse.
  pcall(function()
    GAME:WaitFrames(20)
    SOUND:PlayBGM('Moonlit Courtyard.ogg', true)
  end)
  return true
end

--------------------------------------------------------------------
-- 3. LE DEPART — avant de rentrer se coucher
--------------------------------------------------------------------
-- Une nuit doit se FERMER, sinon elle n'a pas eu lieu. Cette scene se
-- joue juste avant le coucher, et change selon ce que le joueur a
-- reellement fait de sa nuit : a-t-il parle a la Compteuse ? a-t-il
-- entendu la Voix ? est-il resté planté a l'entree ?
function TownNightScenes.Departure()
  local s = SV.TownNight or {}
  local ch = chap()
  local rencontres = 0
  for _, n in pairs(s.Met or {}) do
    if n and n > 0 then rencontres = rencontres + 1 end
  end
  local entendu = (s.VoiceHeard or {})['Ch'..tostring(ch)]

  return Cutscene(function(hero, partner)
    SOUND:FadeOutBGM(40)
    GAME:WaitFrames(30)

    if entendu then
      --La nuit a coute quelque chose. On ne la referme pas gaiement.
      think(hero, 'Worried', "(Rentrer.[pause=25] Dormir, si j'y arrive.)")
      say(partner, 'Worried', "Tu ne m'as pas dit ce que tu avais.[pause=30] Tu ne me le diras pas ce soir non plus.")
      say(partner, 'Normal', "Ce n'est pas grave.[pause=25] Je serai là demain aussi.")
    elseif s.SawStars then
      --Le fil de la Compteuse d'Etoiles se referme sur une image.
      narrate("Avant de rentrer, vous levez la tête.[pause=30] Par habitude, déjà.")
      say(partner, 'Normal', "Tu la cherches, toi aussi ?[pause=25] L'étoile qui manque.")
      think(hero, 'Normal', "(Je ne saurais même pas laquelle.[pause=25] Mais je regarde quand même.)")
    elseif rencontres >= 2 then
      say(partner, 'Happy', "Ils sont bien, les gens de la nuit.[pause=30] Ils parlent vraiment, eux.")
      think(hero, 'Normal', "(Parce que personne ne les écoute le jour.[pause=25] Ça change tout.)")
    else
      narrate("La ville reste silencieuse derrière vous.[pause=30] Elle n'a rien remarqué.")
    end

    GAME:WaitFrames(20)
    narrate("Vous rentrez.[pause=25] Demain commence dans quelques heures.")
  end)
end

return TownNightScenes
