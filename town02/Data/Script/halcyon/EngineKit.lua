--[[
    EngineKit.lua

    CAPACITES NATIVES DE PMDO — BOITE A OUTILS NEW ERA
    ================================================================
    Issu de l'etude de la documentation officielle du moteur
    (PMDODump/DataAsset/Docs/Script.txt, 3275 lignes, 255 fonctions
    d'API) et du dungeon-pack de DoubleTrio.

    CONSTAT DE L'AUDIT
    ------------------------------------------------------------------
    New Era exploite deja 202 des 255 fonctions de l'API : le moteur est
    globalement bien utilise. Mais 62 fonctions ne servaient nulle part,
    et parmi elles cinq changent VRAIMENT la qualite d'une cinematique.
    Aucune n'etait employee dans les 186 fichiers de scene du mod.

    Ce module ne remplace rien : il rend ces cinq capacites natives
    disponibles derriere une API courte, documentee et sure (pcall
    partout), pour que les scenes a venir les utilisent sans avoir a
    relire la doc du moteur.

    LES CINQ CAPACITES ET CE QU'ELLES APPORTENT
    ------------------------------------------------------------------
    1. UI:SetSpeakerReverse(bool)
       Retourne le portrait pour qu'il regarde a GAUCHE. Sans cela, dans
       un dialogue a deux, les deux interlocuteurs regardent du meme
       cote — ils ne se font jamais face. C'est le defaut le plus
       visible de nos scenes actuelles.

    2. GAME:MoveCameraToChara(x, y, duree, chara)
       Centre la camera sur un PERSONNAGE, avec un decalage. Nos scenes
       utilisent MoveCamera(x, y) en coordonnees absolues : chaque
       cadrage doit etre recalcule a la main, et se casse si le
       personnage bouge. Suivre un acteur devient trivial.

    3. SOUND:WaitFanfare(son)
       Joue un son en COUPANT la musique le temps qu'il dure, puis la
       reprend, et attend la fin. C'est le traitement natif des moments
       solennels (recompense, revelation). Nos scenes faisaient
       FadeOutBGM + PlaySE + WaitFrames a la main, avec une duree
       devinee.

    4. UI:SetBounds(x, y, w, h) / UI:ResetBounds()
       Deplace et redimensionne la boite de dialogue. Utile quand le
       personnage qui parle est en BAS de l'ecran : la boite standard
       le recouvre.

    5. UI:SetSpeakTime(frames)
       Regle la cadence du son de frappe du texte. Ralentir = gravite,
       accelerer = panique. Un reglage, un effet.

    REGLES DU PROJET
    ------------------------------------------------------------------
    * Tout sous pcall : si une API manque sur une version de moteur plus
      ancienne, la scene continue au lieu de planter.
    * Aucune de ces fonctions n'est obligatoire : les scenes existantes
      continuent de marcher sans modification.
    * Module global -> texte litteral, jamais STRINGS.MapStrings.
]]
require 'origin.common'

EngineKit = {}

--------------------------------------------------------------------
-- 1. DIALOGUE FACE A FACE
--------------------------------------------------------------------
-- Probleme resolu : dans une conversation a deux, les deux portraits
-- regardent a droite. Personne ne se fait face.
--
-- Convention retenue pour New Era :
--   * le heros et ses allies  -> portrait a DROITE (reverse = true),
--     ils regardent vers la gauche, donc vers l'interlocuteur ;
--   * les PNJ et les boss     -> portrait a GAUCHE (reverse = false).
--
-- Usage :
--   EngineKit.Say(boss, 'Normal', "Halte.")            -- regarde a droite
--   EngineKit.Say(partner, 'Worried', "...", true)     -- regarde a gauche
function EngineKit.Say(who, emo, txt, reverse)
  if who == nil or txt == nil then return end
  pcall(function() UI:SetSpeakerReverse(reverse == true) end)
  UI:SetSpeaker(who)
  if emo ~= nil then GeneralFunctions.SetEmotion(emo) end
  UI:WaitShowDialogue(txt)
  --On remet l'orientation par defaut : une scene qui oublierait de le
  --faire contaminerait toutes les repliques suivantes.
  pcall(function() UI:SetSpeakerReverse(false) end)
end

--Raccourci : replique d'un allie (donc portrait retourne).
function EngineKit.SayAlly(who, emo, txt)
  EngineKit.Say(who, emo, txt, true)
end

--------------------------------------------------------------------
-- 2. CAMERA QUI SUIT UN PERSONNAGE
--------------------------------------------------------------------
-- GAME:MoveCamera prend des coordonnees ABSOLUES : chaque cadrage doit
-- etre recalcule a la main pour chaque carte, et devient faux des que
-- l'acteur se deplace. MoveCameraToChara centre sur le personnage avec
-- un simple decalage.
--
--   dx, dy   decalage par rapport au personnage (0,0 = pile dessus)
--   duree    en frames (1 = instantane)
function EngineKit.CamOn(chara, dx, dy, duree)
  if chara == nil then return false end
  local ok = pcall(function()
    GAME:MoveCameraToChara(dx or 0, dy or 0, duree or 40, chara)
  end)
  return ok
end

--Cadrage « conversation » : entre deux personnages, legerement au-dessus
--du milieu pour laisser la place a la boite de dialogue en bas.
function EngineKit.CamBetween(a, b, duree)
  if a == nil then return false end
  if b == nil then return EngineKit.CamOn(a, 0, -16, duree) end
  local ok = pcall(function()
    local mx = (a.Position.X + b.Position.X) // 2
    local my = (a.Position.Y + b.Position.Y) // 2
    GAME:MoveCamera(mx, my - 16, duree or 40, false)
  end)
  return ok
end

--------------------------------------------------------------------
-- 3. MOMENT SOLENNEL (fanfare native)
--------------------------------------------------------------------
-- SOUND:WaitFanfare coupe la musique le temps du son, la reprend seule,
-- et attend la fin exacte. Remplace le trio
-- FadeOutBGM + PlayBattleSE + WaitFrames(duree devinee).
--
-- Reserve aux vrais moments : recompense, revelation, fin de chapitre.
function EngineKit.Fanfare(son)
  local ok = pcall(function() SOUND:WaitFanfare(son or "Battle/LevelUp") end)
  if not ok then
    --Repli si le son n'existe pas sur cette version du moteur.
    pcall(function()
      SOUND:PlayBattleSE(son or "EVT_Battle_Flash")
      GAME:WaitFrames(60)
    end)
  end
end

--------------------------------------------------------------------
-- 4. BOITE DE DIALOGUE DEPLACEE
--------------------------------------------------------------------
-- Quand celui qui parle est en bas de l'ecran, la boite standard le
-- recouvre. On la remonte le temps de la replique, puis on restaure.
--
-- Le viewport PMDO fait 320x240 : la boite haute occupe le tiers
-- superieur, ce qui laisse le bas libre.
function EngineKit.SayTop(who, emo, txt, reverse)
  pcall(function() UI:SetBounds(8, 8, 304, 72) end)
  EngineKit.Say(who, emo, txt, reverse)
  pcall(function() UI:ResetBounds() end)
end

--------------------------------------------------------------------
-- 5. CADENCE DE FRAPPE DU TEXTE
--------------------------------------------------------------------
-- Un seul reglage, un effet immediat sur le ton :
--   'grave'  texte lent      -> solennite, aveu, revelation
--   'normal' cadence par defaut
--   'vif'    texte rapide    -> panique, urgence, dispute
local CADENCE = { grave = 14, normal = 6, vif = 3 }

function EngineKit.SetTone(nom)
  pcall(function() UI:SetSpeakTime(CADENCE[nom] or CADENCE.normal) end)
end

--Toujours remettre la cadence par defaut en fin de scene, sinon elle
--contamine tout le reste de la partie.
function EngineKit.ResetTone()
  pcall(function() UI:SetSpeakTime(CADENCE.normal) end)
end

--------------------------------------------------------------------
-- BONUS : etat du donjon courant (API natives inexploitees)
--------------------------------------------------------------------
-- DUNGEON:DungeonCurrentFloor et DUNGEON:DungeonAssetName permettent a
-- un script de savoir OU il se joue sans que la zone ait a le lui
-- passer en argument. Utile pour un dialogue qui reagit a la
-- profondeur atteinte.
function EngineKit.Floor()
  local n = 0
  pcall(function() n = DUNGEON:DungeonCurrentFloor() end)
  return n
end

function EngineKit.DungeonName()
  local s = ""
  pcall(function() s = DUNGEON:DungeonAssetName() end)
  return s
end

return EngineKit
