--[[
    TownRaid.lua

    LES PILLARDS DE METANO
    ================================================================
    L'IDEE
    ------------------------------------------------------------------
    Certaines nuits, la ville est attaquee. Des rodeurs profitent du
    noir pour piller les etals, forcer l'entrepot, vider la banque. Le
    joueur les repousse au corps a corps.

    Ce n'est PAS un donjon de plus : c'est une nuit qui tourne mal. Le
    joueur etait sorti se promener, et il rentre en ayant defendu la
    ville. Le lendemain, quelqu'un s'en souvient.

    ------------------------------------------------------------------
    COMMENT LE COMBAT EST FAIT (patron deja eprouve dans ce depot)
    ------------------------------------------------------------------
    On ne bricole rien : on reprend EXACTEMENT le dispositif du duel
    contre la Team Dazzling, verifie dans le depot :

      ground/gloomy_forest_boss/init.lua (fonction PlotScripting)
        DazzlingArc.TrialIntro()
        GAME:ContinueDungeon("gloomy_forest", 7, 0, 0, ...)
      (segment 7 depuis l'insertion du mini-boss en segments 2 et 3)

    Soit : une cinematique, puis ContinueDungeon vers un segment dedie
    dont le Floor est un LoadGen + MappedRoomStep pointant une .rsmap
    peuplee d'une MonsterTeam. Les trois cartes de raid
    (metano_raid_1/2/3) sont des clones de serment_dazzling_arene :
    meme geometrie 15x18, seul le casting change.

      segment 6 -> metano_raid_1  (3 pillards, niv. 14)
      segment 7 -> metano_raid_2  (4 pillards, niv. 19-22)
      segment 8 -> metano_raid_3  (5 pillards, niv. 27-30)

    ------------------------------------------------------------------
    QUI SONT LES PILLARDS
    ------------------------------------------------------------------
    Des especes SPECTRE, toutes deja presentes dans les donjons du mod
    (verifie espece par espece) : Shuppet, Gastly, Duskull, Banette,
    Misdreavus, Haunter, Mismagius, Dusclops, Drifblim. Aucun
    legendaire, aucun fabuleux — regle du projet.

    Ils sont marques Unrecruitable : on ne recrute pas quelqu'un qui
    vient de piller la ville. Les cartes ne contiennent ni argent ni
    objet : defendre Metano n'est pas une occasion de butin.

    ------------------------------------------------------------------
    POURQUOI ILS VIENNENT (et pourquoi ca compte)
    ------------------------------------------------------------------
    Ce ne sont pas des monstres errants. Ils fuient quelque chose qui
    monte, et la ville est sur leur chemin. Le heros ne le comprend pas
    tout de suite ; le joueur, lui, fait le lien avec ce qu'il sait.
    C'est la meme regle que partout : LE JOUEUR RECONNAIT, LE HEROS NON.

    ------------------------------------------------------------------
    REGLES DU PROJET
    ------------------------------------------------------------------
    * Jamais « Necrozma », « Eternatus », « l'Abime », « prison ».
    * La Voix ne parle pas ici : c'est une nuit concrete, pas une vision.
    * Texte litteral francais (module global).
    * 1 a 2 phrases par boite, < 150 caracteres hors [pause=N].
    * Tout sous pcall, sortie garantie.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.BossFX'
require 'halcyon.TownPlunder'
require 'halcyon.NightWatch'
require 'halcyon.TownReward'
require 'halcyon.RaidScenes'

TownRaid = {}

--------------------------------------------------------------------
-- HELPERS (memes roles que dans ChapterScenes / TownNightScenes)
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
function TownRaid.Ensure()
  if SV.TownRaid == nil then SV.TownRaid = {} end
  local s = SV.TownRaid
  if s.Repelled == nil then s.Repelled = 0 end   -- raids repousses
  if s.Lost == nil then s.Lost = 0 end           -- raids perdus
  if s.Pending == nil then s.Pending = false end -- un raid est en cours
  if s.Wave == nil then s.Wave = 0 end           -- palier atteint (1..3)
  if s.LastDay == nil then s.LastDay = -1 end    -- jour du dernier raid
  if s.Told == nil then s.Told = {} end          -- reactions deja vues
  --Reveil au chevet a jouer au prochain passage dans la chambre.
  if s.BedsidePending == nil then s.BedsidePending = false end
  return s
end

--------------------------------------------------------------------
-- QUAND UN RAID SE DECLENCHE
--------------------------------------------------------------------
-- Regles, pensees pour que ca reste un EVENEMENT et pas une corvee :
--
--   * jamais avant le ch6 (la nuit elle-meme n'existe pas avant) ;
--   * jamais deux nuits de suite (on compare a DaysPassed) ;
--   * la premiere sortie nocturne d'un joueur est TOUJOURS calme :
--     on lui laisse decouvrir la ville endormie avant de l'agresser ;
--   * ensuite, environ une nuit sur trois.
--
-- Le palier depend du chapitre, pas du nombre de raids : un joueur du
-- ch10 qui n'a jamais vu de raid affronte quand meme la grande vague.
function TownRaid.Wave()
  local ch = (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
  if ch >= 9 then return 3 end
  if ch >= 7 then return 2 end
  return 1
end

function TownRaid.ShouldTrigger()
  local ch = (SV.ChapterProgression and SV.ChapterProgression.Chapter) or 1
  if ch < 6 then return false end

  local s = TownRaid.Ensure()
  local night = SV.TownNight or {}

  --La toute premiere nuit reste calme, sans exception.
  if (night.Visits or 0) < 2 then return false end

  --Jamais deux nuits de suite.
  local today = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0
  if s.LastDay == today then return false end
  if s.LastDay >= 0 and (today - s.LastDay) < 2 then return false end

  --Environ une nuit sur trois. Mais une nuit de GARDE est plus exposee :
  --c'est justement les nuits ou l'on veille que quelque chose arrive.
  --Une nuit sur deux quand le tour de guet a ete impose par la guilde.
  local bornes = 3
  pcall(function()
    if NightWatch.IsOnDuty() then bornes = 2 end
  end)

  local roll = 0
  pcall(function() roll = math.random(1, bornes) end)
  return roll == 1
end

--------------------------------------------------------------------
-- L'ALERTE — la cinematique d'entree
--------------------------------------------------------------------
-- Trois registres distincts, un par palier. La premiere fois, on ne
-- comprend pas ce qui arrive ; la troisieme, on sait deja.
local ALERTS = {}

ALERTS[1] = function(hero, partner)
  narrate("Un bruit de verre.[pause=25] Puis un autre, plus loin.")
  GAME:WaitFrames(20)
  say(partner, 'Surprised', "Ça vient du marché ![pause=25] Quelqu'un force les étals !")
  think(hero, 'Worried', "(Des ombres. Elles bougent mal —[pause=20] elles ne touchent pas le sol.)")
  GAME:WaitFrames(15)
  narrate("Trois formes se detachent entre les stands.[pause=30] Elles ne fuient pas. Elles vous regardent.")
  say(partner, 'Determined', "Ils sont chez nous.[pause=25] Ils n'ont rien à faire ici !")
end

ALERTS[2] = function(hero, partner)
  narrate("Cette fois, c'est du côté de l'entrepôt.[pause=25] Et ils sont plus nombreux.")
  GAME:WaitFrames(20)
  say(partner, 'Worried', "Encore eux...[pause=25] Ils reviennent, et ils apprennent.")
  think(hero, 'Worried', "(Ils ne pillent pas au hasard.[pause=25] Ils vont droit aux réserves.)")
  GAME:WaitFrames(15)
  say(partner, 'Sad', "Tu as vu comme ils se déplacent ?[pause=30] On dirait qu'ils fuient quelque chose.")
  think(hero, 'Normal', "(Fuir vers une ville endormie.[pause=25] Il faut avoir très peur pour faire ça.)")
  say(partner, 'Determined', "Peu importe.[pause=20] Ici, ils ne passeront pas.")
end

ALERTS[3] = function(hero, partner)
  narrate("Pas de bruit, cette fois.[pause=30] C'est ça qui vous réveille.")
  GAME:WaitFrames(25)
  say(partner, 'Surprised', "La place...[pause=25] Regarde la place.")
  narrate("Ils sont cinq, immobiles, au centre.[pause=30] Ils attendaient que vous sortiez.")
  GAME:WaitFrames(20)
  think(hero, 'Worried', "(Ce n'est plus du pillage.[pause=25] Ils sont venus pour nous.)")
  say(partner, 'Sad', "Ils savent qui on est.[pause=30] Depuis quand est-ce qu'ils savent ?")
  GAME:WaitFrames(15)
  say(partner, 'Determined', "Tant pis.[pause=25] Derrière ces murs, tout le monde dort. On tient.")
  BossFX.ShakeScreen(5, 20)
end

--Lance l'alerte puis le combat. Appelee depuis la carte de nuit.
function TownRaid.Begin()
  local s = TownRaid.Ensure()
  local wave = TownRaid.Wave()
  s.Wave = wave
  s.Pending = true
  s.LastDay = (SV.ChapterProgression and SV.ChapterProgression.DaysPassed) or 0

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:FadeOutBGM(20)
    GAME:WaitFrames(20)
    local fn = ALERTS[wave] or ALERTS[1]
    fn(hero, partner)
  end)
  --NOTE : la fuite des ombres (RaidScenes.ShadowsFlee) et l'ecroulement
  --(RaidScenes.Collapse) se jouent APRES le combat, dans Victory/Defeat.
  if not ok then PrintInfo('[TownRaid.Begin] alerte ecourtee : '..tostring(err)) end

  pcall(function()
    UI:ResetSpeaker()
    if partner ~= nil then
      AI:EnableCharacterAI(partner)
      AI:SetCharacterAI(partner, 'origin.ai.ground_partner', CH('PLAYER'), partner.Position)
    end
    GAME:CutsceneMode(false)
  end)

  --Le combat. Segments 8, 9 et 10 de gloomy_forest (decales de +2 par
  --l'insertion du mini-boss en segments 2 et 3) : chacun charge une des
  --trois cartes de raid. Meme appel que le duel Dazzling
  --(gloomy_forest_boss/init.lua, segment 7).
  pcall(function()
    COMMON.BossTransition()
    GAME:ContinueDungeon("gloomy_forest", 7 + wave, 0, 0,
      RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end)
end

--------------------------------------------------------------------
-- APRES LE COMBAT
--------------------------------------------------------------------
-- Un combat sans consequence n'est qu'un obstacle. Ces deux scenes
-- disent ce que la nuit a coute, ou rapporte.
function TownRaid.Victory()
  local s = TownRaid.Ensure()
  s.Pending = false
  s.Repelled = s.Repelled + 1
  local wave = s.Wave

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  return pcall(function()
    GAME:CutsceneMode(true)
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    SOUND:FadeOutBGM(30)
    GAME:WaitFrames(25)

    --LES OMBRES REFLUENT. Mise en scene deportee dans RaidScenes : les
    --pillards ne meurent pas, ils se dissolvent et retournent d'ou ils
    --viennent. Cette scene remplace la simple phrase de constat qui se
    --trouvait ici, et joue AVANT les repliques du duo.
    pcall(function() RaidScenes.ShadowsFlee(wave) end)
    GAME:WaitFrames(15)

    if wave >= 3 then
      say(partner, 'Pain', "C'est fini...[pause=30] Dis-moi que c'est fini.")
      think(hero, 'Worried', "(Pour ce soir.[pause=25] Seulement pour ce soir.)")
      GAME:WaitFrames(15)
      narrate("Une fenêtre s'entrouvre.[pause=25] Puis une autre. Personne ne sort.")
      say(partner, 'Sad', "Ils ont entendu.[pause=30] Ils ont eu peur, et ils n'ont rien pu faire.")
      say(partner, 'Determined', "C'est pour ça qu'on est là.[pause=25] Pour qu'ils puissent se rendormir.")
    elseif wave == 2 then
      say(partner, 'Worried', "Ils étaient plus organisés.[pause=30] La prochaine fois, ils seront pires.")
      think(hero, 'Normal', "(Alors il faudra être là.[pause=25] Chaque fois.)")
      narrate("Vous redressez un étal renversé.[pause=30] Le marchand ne saura jamais pourquoi il tient droit.")
    else
      say(partner, 'Happy', "On les a eus ![pause=25] Ils n'ont rien emporté.")
      think(hero, 'Normal', "(Personne ne s'est réveillé.[pause=25] C'est peut-être ça, le mieux.)")
      narrate("Vous remettez les caisses en place avant de partir.[pause=30] Comme si rien n'était arrivé.")
    end

    GAME:WaitFrames(20)
    SOUND:PlayBGM('Goodnight.ogg', true)

    --LA VILLE REMERCIE. Objets tires au sort et argent des marchands,
    --deposes devant la porte au matin. Le palier suit la vague : cinq
    --rodeurs repousses valent mieux que trois. Voir TownReward.lua.
    --Arme aussi les felicitations publiques du lendemain.
    GAME:WaitFrames(15)
    pcall(function() TownReward.Grant(wave) end)
  end)
end

function TownRaid.Defeat()
  local s = TownRaid.Ensure()
  s.Pending = false
  s.Lost = s.Lost + 1

  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  --L'ECROULEMENT. Le corps lache avant que quiconque commente : jambes
  --qui cedent, ecran qui tangue, chute, puis le noir. Joue AVANT tout
  --le reste — c'est le dernier souvenir du heros avant son reveil.
  pcall(function() RaidScenes.Collapse() end)

  --LE PILLAGE A LIEU POUR DE VRAI. Etals vides, banque entamee, sac
  --allege. Applique AVANT la scene, pour que le constat puisse citer
  --les montants exacts. Voir TownPlunder.lua pour les garde-fous.
  local vole, objets = 0, {}
  pcall(function() vole, objets = TownPlunder.Apply() end)

  --LE REVEIL EST DEPORTE AU LENDEMAIN. Le heros s'est evanoui : il ne
  --peut pas commenter sa propre nuit dans la seconde qui suit. La suite
  --(reveil, chevet de la guilde, debrief chiffre) se joue dans la
  --chambre, via RaidScenes.Bedside, arme par ce drapeau.
  s.BedsidePending = true
  return true
end

--------------------------------------------------------------------
-- LA VILLE S'EN SOUVIENT
--------------------------------------------------------------------
-- Ce que le joueur a fait la nuit doit exister le JOUR, sinon ca n'a
-- pas eu lieu. Ces repliques sont utilisables par les PNJ de la ville
-- (meme forme que TownVoices : on renvoie une liste de boites).
function TownRaid.DayEcho()
  local s = TownRaid.Ensure()
  if s.Repelled <= 0 and s.Lost <= 0 then return nil end

  if s.Lost > 0 and s.Repelled == 0 then
    return {
      "On s'est fait voler cette nuit.[pause=25] Encore.",
      "Les gardes disent qu'ils n'ont rien vu venir.[pause=30] Moi je les crois, c'est bien le problème.",
    }
  end

  if s.Repelled >= 3 then
    return {
      "Il paraît qu'il se passe des choses, la nuit.[pause=30] Des choses qu'on nous cache.",
      "Moi je dis qu'on a de la chance.[pause=25] Je ne sais pas de quoi, mais on en a.",
    }
  end

  if s.Repelled >= 2 then
    return {
      "Mon étal était renversé hier soir.[pause=25] Ce matin, il était debout.",
      "Quelqu'un l'a redressé.[pause=30] Je ne sais pas qui. J'aimerais bien le remercier.",
    }
  end

  return {
    "Vous avez entendu du bruit cette nuit ?[pause=25] Moi non plus.",
    "Et pourtant j'ai mal dormi.[pause=30] Comme si quelque chose s'était passé tout près.",
  }
end

return TownRaid
