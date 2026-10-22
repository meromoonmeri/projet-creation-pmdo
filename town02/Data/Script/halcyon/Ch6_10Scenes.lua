--[[
    Ch6_10Scenes.lua

    CINEMATIQUES D'ETAGE — CHAPITRES 8, 9, 10
    ================================================================
    Les arènes relais/miniboss/boss des ch8-10 n'avaient AUCUN OnMapStarts :
    on y entrait sans mise en scène (constat mesuré : ~220/210/170 dialogues
    par chapitre vs ~2800 aux ch6-7).

    Ce module branche les cinématiques d'étage manquantes, sur le patron
    déjà validé par cloven_ruins (MapEffectStep + SingleCharScriptEvent ->
    SINGLE_CHAR_SCRIPT.*), avec la grammaire DonjonFX (Recit/Dire/Penser/
    VoixGardien/RegarderVers/Flash) et des textes par clés CH8_*/CH9_*/CH10_*
    dans Strings/stringsEx.*.resx.

    REGISTRES (jamais répétés) :
      ch8  LE SANCTUAIRE  -> l'émerveillement qui inquiète. Lumière, silence.
      ch9  LE MARAIS      -> le dégoût, puis la peur. Boue, présence.
      ch10 LE PIC         -> l'urgence et la rivalité. Vent, course.
]]

require 'origin.common'
require 'halcyon.GeneralFunctions'
require 'halcyon.DonjonFX'
require 'halcyon.BossFX'

Ch6_10Scenes = {}

local function guard_done(flag)
  -- Une fois jouée, la scène ne rejoue pas si on revient sur l'étage.
  if SV.Ch6_10Scenes == nil then SV.Ch6_10Scenes = {} end
  if SV.Ch6_10Scenes[flag] then return true end
  SV.Ch6_10Scenes[flag] = true
  return false
end

--------------------------------------------------------------------
-- CHAPITRE 8.1 — RELAIS DU SANCTUAIRE (crystal_sanctuary_relay)
-- L'émerveillement : le duo émerge du rideau d'eau dans la salle des
-- reliques. Kangourex les accueille. Ils lisent un fragment de savoir.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.Ch8_RelaisArrivee(owner, ownerChar, context, args)
  if context ~= nil and context.User ~= nil then return end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  SV.Chapter8 = SV.Chapter8 or {}

  -- Réveil au checkpoint après une défaite contre Terapagos. Cette branche
  -- doit précéder guard_done : contrairement à la découverte, elle est rejouable.
  if SV.Chapter8.SanctuaryMidState == 'TerapagosRespawn' then
    SV.Chapter8.SanctuaryMidState = nil
    local tries = SV.Chapter8.TerapagosDefeats or 1
    pcall(function()
      GAME:CutsceneMode(true); GAME:FadeIn(45); GAME:WaitFrames(25)
      DonjonFX.Flash(hero, 'white', 4)
      if tries == 1 then
        DonjonFX.Recit('@La lumière revient par pulsations. Le relais vous a ramenés au dernier point stable.')
        DonjonFX.Dire(partner, '@Tu respires... Terapagos nous a rejetés jusqu’ici. Le checkpoint a tenu.', 'Worried')
        DonjonFX.Penser('@(Les quinze premiers étages sont derrière nous. Il faut repartir des profondeurs.)', 'Determined')
      else
        DonjonFX.Dire(partner, '@Encore au relais. Il nous a sauvés une nouvelle fois.', 'Pain')
        DonjonFX.Penser('@(Se relever. Comprendre son rythme. Recommencer.)', 'Determined')
      end
      GAME:CutsceneMode(false)
    end)
    return
  end

  if guard_done('Ch8Relais') then return end
  SV.Chapter8.TerapagosCheckpoint = true

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(45)
    SOUND:PlayBGM('Crystal Crossing.ogg', true)

    --------------------------------------------------------- ACTE I
    -- La salle parle avant les personnages : la lumière qui bat.
    DonjonFX.Recit('CH8_RELAIS_001')
    GAME:WaitFrames(30)
    DonjonFX.Flash(hero, 'white', 4)
    GAME:WaitFrames(25)
    DonjonFX.Recit('CH8_RELAIS_002')
    GAME:WaitFrames(20)

    -------------------------------------------------------- ACTE II
    -- Le duo réagit, chacun selon sa position.
    DonjonFX.Dire(partner, 'CH8_RELAIS_003', 'Surprised')
    GAME:WaitFrames(14)
    DonjonFX.Penser('CH8_RELAIS_004', 'Worried')
    GAME:WaitFrames(18)
    DonjonFX.Dire(partner, 'CH8_RELAIS_005', 'Worried')
    GAME:WaitFrames(14)

    ------------------------------------------------------- ACTE III
    -- Un fragment de savoir : les premiers gardiens.
    DonjonFX.Recit('CH8_RELAIS_006')
    GAME:WaitFrames(20)
    DonjonFX.Dire(partner, 'CH8_RELAIS_007', 'Sad')
    GAME:WaitFrames(14)
    DonjonFX.Dire(partner, 'CH8_RELAIS_008', 'Normal')
    GAME:WaitFrames(12)
    DonjonFX.Penser('CH8_RELAIS_009', 'Normal')
    GAME:WaitFrames(18)

    -------------------------------------------------------- ACTE IV
    -- Décision : continuer vers les profondeurs.
    DonjonFX.Dire(partner, 'CH8_RELAIS_010', 'Determined')
    GAME:WaitFrames(16)
    DonjonFX.Penser('CH8_RELAIS_011', 'Determined')
    GAME:WaitFrames(10)

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Ch6_10Scenes] ch8 relais ecourte : '..tostring(err)) end
end

--------------------------------------------------------------------
-- CHAPITRE 8.2 — MINI-BOSS : STRASSIE & MOMARTIK (crystal_sanctuary_miniboss)
-- Les gardiens de cristal se réveillent dans la lumière. Ils parlent de
-- leur serment avant le combat.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.Ch8_MinibossEveil(owner, ownerChar, context, args)
  if context ~= nil and context.User ~= nil then return end
  if guard_done('Ch8Miniboss') then return end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gardien = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(45)

    --------------------------------------------------------- ACTE I
    -- La salle s'éclaire : deux silhouettes de cristal.
    DonjonFX.Recit('CH8_MINIBOSS_001')
    GAME:WaitFrames(25)
    DonjonFX.Flash(hero, 'white', 6)
    GAME:WaitFrames(30)
    DonjonFX.Recit('CH8_MINIBOSS_002')
    GAME:WaitFrames(20)

    -------------------------------------------------------- ACTE II
    -- Le duo comprend qu'ils ne sont pas seuls.
    DonjonFX.Dire(partner, 'CH8_MINIBOSS_003', 'Surprised')
    GAME:WaitFrames(14)
    DonjonFX.Penser('CH8_MINIBOSS_004', 'Shock')
    GAME:WaitFrames(18)

    -- Les gardiens se manifestent.
    if gardien ~= nil then
      pcall(function() EngineKit.CamOn(gardien, 0, -8, 45) end)
      DonjonFX.RegarderVers(gardien, 7)
      GAME:WaitFrames(18)
      DonjonFX.VoixGardien(gardien, 'CH8_MINIBOSS_005')
      GAME:WaitFrames(16)
    end
    DonjonFX.Recit('CH8_MINIBOSS_006')
    GAME:WaitFrames(18)
    DonjonFX.Dire(partner, 'CH8_MINIBOSS_007', 'Worried')
    GAME:WaitFrames(14)

    ------------------------------------------------------- ACTE III
    -- Leur serment : garder ce que la lumière ne doit pas voir.
    if gardien ~= nil then
      DonjonFX.VoixGardien(gardien, 'CH8_MINIBOSS_008')
      GAME:WaitFrames(16)
      DonjonFX.VoixGardien(gardien, 'CH8_MINIBOSS_009')
      GAME:WaitFrames(16)
    end
    DonjonFX.Dire(partner, 'CH8_MINIBOSS_010', 'Determined')
    GAME:WaitFrames(12)
    DonjonFX.Penser('CH8_MINIBOSS_011', 'Determined')
    GAME:WaitFrames(10)

    -- Musique de combat : la main est rendue.
    pcall(function() SOUND:PlayBGM('Boss Battle!.ogg', true) end)
    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Ch6_10Scenes] ch8 miniboss ecourte : '..tostring(err)) end
end

--------------------------------------------------------------------
-- CHAPITRE 8.3 — BOSS : DIANCIE (crystal_sanctuary_boss)
-- La salle du trône de cristal. Diancie se révèle dans la lumière et
-- parle de son rôle de gardienne du Cœur d'Anima.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.Ch8_BossEveil(owner, ownerChar, context, args)
  if context ~= nil and context.User ~= nil then return end
  if guard_done('Ch8Boss') then return end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gardien = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(50)
    SOUND:PlayBGM('Crystal Crossing.ogg', true)

    --------------------------------------------------------- ACTE I
    -- La salle du trône : la lumière est partout, trop parfaite.
    DonjonFX.Recit('CH8_BOSS_001')
    GAME:WaitFrames(25)
    DonjonFX.Recit('CH8_BOSS_002')
    GAME:WaitFrames(20)
    DonjonFX.Dire(partner, 'CH8_BOSS_003', 'Worried')
    GAME:WaitFrames(14)
    DonjonFX.Penser('CH8_BOSS_004', 'Worried')
    GAME:WaitFrames(16)

    -------------------------------------------------------- ACTE II
    -- DIANCIE se révèle : une lumière qui se condense, puis une forme.
    DonjonFX.Flash(hero, 'white', 10)
    GAME:WaitFrames(40)
    DonjonFX.Recit('CH8_BOSS_005')
    GAME:WaitFrames(20)
    if gardien ~= nil then
      pcall(function() EngineKit.CamOn(gardien, 0, -10, 50) end)
      DonjonFX.RegarderVers(gardien, 7)
      GAME:WaitFrames(20)
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_006')
      GAME:WaitFrames(16)
    end

    ------------------------------------------------------- ACTE III
    -- Elle parle de son rôle et de sa peur.
    if gardien ~= nil then
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_007')
      GAME:WaitFrames(14)
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_008')
      GAME:WaitFrames(16)
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_009')
      GAME:WaitFrames(16)
    end
    DonjonFX.Dire(partner, 'CH8_BOSS_010', 'Sad')
    GAME:WaitFrames(12)

    -------------------------------------------------------- ACTE IV
    -- Le duo la convainc qu'ils ne viennent pas voler, mais sauver.
    DonjonFX.Penser('CH8_BOSS_011', 'Determined')
    GAME:WaitFrames(16)
    DonjonFX.Dire(partner, 'CH8_BOSS_012', 'Determined')
    GAME:WaitFrames(14)
    if gardien ~= nil then
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_013')
      GAME:WaitFrames(14)
      DonjonFX.VoixGardien(gardien, 'CH8_BOSS_014')
      GAME:WaitFrames(16)
    end

    -- Musique de combat.
    pcall(function() SOUND:PlayBGM('Boss Battle!.ogg', true) end)
    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Ch6_10Scenes] ch8 boss ecourte : '..tostring(err)) end
end


--------------------------------------------------------------------
-- CHAPITRE 9.2 — BOSS : MEGA-BLASTOISE (forgotten_marsh_boss)
-- Le gardien du marais émerge de la vase. Il protège le Cœur noyé,
-- persuadé que l'éteindre est la seule paix.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.Ch9_BossEveil(owner, ownerChar, context, args)
  if context ~= nil and context.User ~= nil then return end
  if guard_done('Ch9Boss') then return end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()
  local gardien = DonjonFX.Gardien()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(50)
    SOUND:PlayBGM('Dark Hill.ogg', true)

    --------------------------------------------------------- ACTE I
    -- Le fond du marais : l'eau monte, le Cœur se noie.
    DonjonFX.Recit('CH9_BOSS_001')
    GAME:WaitFrames(25)
    DonjonFX.Recit('CH9_BOSS_002')
    GAME:WaitFrames(20)
    DonjonFX.Dire(partner, 'CH9_BOSS_003', 'Worried')
    GAME:WaitFrames(14)
    DonjonFX.Penser('CH9_BOSS_004', 'Worried')
    GAME:WaitFrames(16)

    -------------------------------------------------------- ACTE II
    -- MEGA-BLASTOISE émerge de la vase.
    DonjonFX.Secousse(5, 30)
    GAME:WaitFrames(25)
    DonjonFX.Recit('CH9_BOSS_005')
    GAME:WaitFrames(20)
    if gardien ~= nil then
      pcall(function() EngineKit.CamOn(gardien, 0, -8, 50) end)
      DonjonFX.RegarderVers(gardien, 7)
      GAME:WaitFrames(20)
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_006')
      GAME:WaitFrames(16)
    end

    ------------------------------------------------------- ACTE III
    -- Il parle de sa conviction : éteindre le Cœur = la paix.
    if gardien ~= nil then
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_007')
      GAME:WaitFrames(14)
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_008')
      GAME:WaitFrames(16)
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_009')
      GAME:WaitFrames(16)
    end
    DonjonFX.Dire(partner, 'CH9_BOSS_010', 'Sad')
    GAME:WaitFrames(12)

    -------------------------------------------------------- ACTE IV
    -- Le duo le convainc que le Cœur peut revivre.
    DonjonFX.Penser('CH9_BOSS_011', 'Determined')
    GAME:WaitFrames(16)
    DonjonFX.Dire(partner, 'CH9_BOSS_012', 'Determined')
    GAME:WaitFrames(14)
    if gardien ~= nil then
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_013')
      GAME:WaitFrames(14)
      DonjonFX.VoixGardien(gardien, 'CH9_BOSS_014')
      GAME:WaitFrames(16)
    end

    pcall(function() SOUND:PlayBGM('Boss Battle!.ogg', true) end)
    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Ch6_10Scenes] ch9 boss ecourte : '..tostring(err)) end
end

--------------------------------------------------------------------
-- CHAPITRE 10.1 — RELAIS DES NUAGES (palier_celeste)
-- L'Escouade Fulgur est arrivée première. Rivalité, puis trêve forcée
-- par le danger commun.
--------------------------------------------------------------------
function SINGLE_CHAR_SCRIPT.Ch10_RelaisArrivee(owner, ownerChar, context, args)
  if context ~= nil and context.User ~= nil then return end
  if guard_done('Ch10Relais') then return end

  local hero = DonjonFX.Hero()
  local partner = DonjonFX.Partner()

  local ok, err = pcall(function()
    GAME:CutsceneMode(true)
    GAME:WaitFrames(45)
    SOUND:PlayBGM('Sky Peak Prairie.ogg', true)

    --------------------------------------------------------- ACTE I
    -- Le palier entre les nuages : le monde s'ouvre sous eux.
    DonjonFX.Recit('CH10_RELAIS_001')
    GAME:WaitFrames(25)
    DonjonFX.Dire(partner, 'CH10_RELAIS_002', 'Surprised')
    GAME:WaitFrames(14)
    DonjonFX.Penser('CH10_RELAIS_003', 'Normal')
    GAME:WaitFrames(16)

    -------------------------------------------------------- ACTE II
    -- Quelqu'un est déjà là : l'Escouade Fulgur.
    DonjonFX.Recit('CH10_RELAIS_004')
    GAME:WaitFrames(18)
    DonjonFX.Dire(partner, 'CH10_RELAIS_005', 'Surprised')
    GAME:WaitFrames(12)
    DonjonFX.Recit('CH10_RELAIS_006')
    GAME:WaitFrames(16)
    DonjonFX.Dire(partner, 'CH10_RELAIS_007', 'Determined')
    GAME:WaitFrames(12)

    ------------------------------------------------------- ACTE III
    -- La rivalité, puis la trêve devant le danger commun.
    DonjonFX.Recit('CH10_RELAIS_008')
    GAME:WaitFrames(16)
    DonjonFX.Penser('CH10_RELAIS_009', 'Determined')
    GAME:WaitFrames(16)
    DonjonFX.Recit('CH10_RELAIS_010')
    GAME:WaitFrames(14)
    DonjonFX.Dire(partner, 'CH10_RELAIS_011', 'Determined')
    GAME:WaitFrames(14)

    GAME:CutsceneMode(false)
  end)
  if not ok then PrintInfo('[Ch6_10Scenes] ch10 relais ecourte : '..tostring(err)) end
end

return Ch6_10Scenes
