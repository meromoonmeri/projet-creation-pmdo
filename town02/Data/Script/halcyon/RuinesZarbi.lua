--[[
    RuinesZarbi.lua — LE PUZZLE DES ZARBI (portage d'Aegis Cave)

    ==================================================================
    CE QUE FAIT LE DONJON OFFICIEL, ET QU'ON REPRODUIT ICI
    ==================================================================
    Dans Explorers of Sky, Aegis Cave n'est pas un donjon lineaire :

      1. Une TABLETTE de pierre attend a l'entree. Elle porte des cavites
         en forme de Zarbi — un mot a epeler.
      2. On descend le labyrinthe. Les Zarbi vaincus laissent PARFOIS une
         pierre gravee de leur lettre. Le drop est aleatoire, et la forme
         de Zarbi qui apparait a l'etage l'est aussi.
      3. Au bout du labyrinthe, on ne trouve pas la chambre du gardien :
         on ressort AU CAMP. Le secteur BOUCLE tant que le mot est
         incomplet. C'est la mecanique centrale, pas un effet de bord.
      4. Le mot complete, on presente les pierres a la tablette. Le jeu
         demande de FERMER LES YEUX. A la reouverture, un escalier est
         apparu : la chambre du gardien s'ouvre.

    Trois mots, dans l'ordre impose. En version francaise du projet :
         GLACE -> Regice     ROCHE -> Regirock     ACIER -> Registeel
    puis le Puits (5 etages, sans enigme) et Regigigas.

    ==================================================================
    CE QUI EST VOLONTAIREMENT FIDELE, Y COMPRIS LE DEFAUT
    ==================================================================
    Le drop reste ALEATOIRE, comme dans l'original. C'est le choix
    assume : « reprends fidelement Aegis Cave ». On ne lisse pas la
    difficulte, on ne garantit pas la lettre manquante.

    Seule concession, invisible pour le joueur et deja presente dans
    l'esprit du jeu : un Zarbi ne peut lacher que des lettres UTILES au
    secteur en cours. Dans EoS les 28 formes existent partout et on peut
    ramasser des lettres inutiles ; ici les spawns de chaque secteur sont
    deja restreints aux lettres de son mot (Lot 1, TeamSpawnZoneStep).
    La sensation — revenir bredouille et redescendre — est identique.

    ==================================================================
    API — verifiee, jamais supposee
    ==================================================================
      GAME:GivePlayerItem(id, n)     19 usages dans le mod
      GAME:FindPlayerItem(id, ...)    5 usages
      GAME:GetPlayerBagItem(i)       14 usages
      GAME:TakePlayerBagItem(i)      11 usages
    Les 9 pierres (ruines_pierre_a .. _r) sont declarees dans
    Data/Item/ et indexees dans Data/Item/index.idx.
]]--
require 'origin.common'

RuinesZarbi = {}

--------------------------------------------------------------------
-- Les trois mots, et le secteur auquel chacun appartient.
--------------------------------------------------------------------
RuinesZarbi.MOTS = {
  [0] = { cle = 'Glace', mot = 'GLACE', gardien = 'Regice'    },
  [2] = { cle = 'Roche', mot = 'ROCHE', gardien = 'Regirock'  },
  [4] = { cle = 'Acier', mot = 'ACIER', gardien = 'Registeel' },
}

-- Chance qu'un Zarbi vaincu laisse sa pierre. Valeur d'Aegis Cave :
-- faible et non garantie. 25 % rend la boucle sensible sans la rendre
-- interminable sur un mot de 5 lettres.
RuinesZarbi.CHANCE_PIERRE = 33  -- valeur NDS : UNOWN_STONE_DROP_CHANCE (arm9, 33%)
-- (corrigé de 25% le 2026-08-09 : le jeu original donne 33%, cf. pmdsky-debug
-- overlay10 UNOWN_STONE_DROP_CHANCE 0x22C4474)

--------------------------------------------------------------------
-- Etat de sauvegarde
--------------------------------------------------------------------
function RuinesZarbi.Ensure()
  if SV.Ruines == nil then SV.Ruines = {} end
  local R = SV.Ruines
  if R.MotGlace == nil then R.MotGlace = false end
  if R.MotRoche == nil then R.MotRoche = false end
  if R.MotAcier == nil then R.MotAcier = false end
  if R.PierresGlace == nil then R.PierresGlace = {} end
  if R.PierresRoche == nil then R.PierresRoche = {} end
  if R.PierresAcier == nil then R.PierresAcier = {} end
  if R.BoucleSecteur == nil then R.BoucleSecteur = -1 end
  if R.TabletteVue == nil then R.TabletteVue = false end
end

--------------------------------------------------------------------
-- Quel secteur est en cours ? On se fie au segment reel du moteur,
-- jamais a une variable qui pourrait avoir derive.
--------------------------------------------------------------------
function RuinesZarbi.SecteurCourant()
  local seg = -1
  pcall(function() seg = _ZONE.CurrentMapID.Segment end)
  return seg
end

-- Le secteur dont le mot n'est PAS encore complete (celui que la
-- tablette affiche). Retourne nil si les trois sont faits.
-- Le secteur en cours : le premier des trois dont le GARDIEN n'est pas
-- encore tombe.
--
-- CORRECTIF DE BLOCAGE DE SAUVEGARDE. Cette fonction ne regardait que le
-- mot ('Mot'..cle), jamais le gardien. Or le mot est epele AVANT le combat :
-- des qu'il etait complet, le secteur cessait d'etre actif, que le Regi ait
-- ete vaincu ou non. Deux consequences, verifiees par simulation :
--
--   * le joueur qui PERD contre un gardien ne peut plus jamais revenir a
--     lui : son arene devient inatteignable, le scelle reste intact ;
--   * s'il perd contre Registeel (3e mot epele), plus aucun secteur n'est
--     actif ET le Puits reste ferme, puisqu'il exige VaincuRegisteel.
--     Le donjon entier se referme : sauvegarde bloquee.
--
-- Un secteur est desormais fini quand son gardien est tombe, ce qui est la
-- vraie condition d'Aegis Cave. Le mot, lui, sert toujours a ouvrir l'arene
-- (motComplet dans zone/cloven_ruins/init.lua) : une fois epele il le reste,
-- donc un joueur battu retraverse le labyrinthe et retombe sur le gardien,
-- sans avoir a re-collecter les pierres. C'est exactement le comportement
-- du jeu d'origine.
function RuinesZarbi.SecteurActif()
  RuinesZarbi.Ensure()
  for _, seg in ipairs({0, 2, 4}) do
    local d = RuinesZarbi.MOTS[seg]
    if SV.Ruines['Vaincu' .. d.gardien] ~= true then return seg, d end
  end
  return nil, nil
end

--------------------------------------------------------------------
-- Inventaire des lettres deja obtenues, pour un secteur.
--------------------------------------------------------------------
local function tablePierres(cle)
  RuinesZarbi.Ensure()
  local t = SV.Ruines['Pierres' .. cle]
  if t == nil then t = {}; SV.Ruines['Pierres' .. cle] = t end
  return t
end

function RuinesZarbi.A(cle, lettre)
  return tablePierres(cle)[lettre] == true
end

--------------------------------------------------------------------
-- Lettres encore manquantes pour un mot. Une lettre repetee ne compte
-- qu'une fois : la tablette a une cavite par FORME de Zarbi.
--------------------------------------------------------------------
function RuinesZarbi.Manquantes(seg)
  local d = RuinesZarbi.MOTS[seg]
  if d == nil then return {} end
  local t = tablePierres(d.cle)
  local vues, out = {}, {}
  for i = 1, #d.mot do
    local L = string.sub(d.mot, i, i)
    if not vues[L] then
      vues[L] = true
      if t[L] ~= true then out[#out + 1] = L end
    end
  end
  return out
end

function RuinesZarbi.MotComplet(seg)
  return #RuinesZarbi.Manquantes(seg) == 0
end

--------------------------------------------------------------------
-- Un Zarbi vient d'etre vaincu : tente le drop.
-- Appele par le hook de combat ; protege pour qu'un echec ici ne
-- puisse jamais interrompre une partie.
--------------------------------------------------------------------
function RuinesZarbi.ZarbiVaincu(lettre)
  local seg = RuinesZarbi.SecteurCourant()
  local d = RuinesZarbi.MOTS[seg]
  if d == nil or lettre == nil then return false end

  -- Une lettre inutile au mot en cours ne donne rien : inutile
  -- d'encombrer le sac du joueur.
  if not string.find(d.mot, lettre, 1, true) then return false end
  -- Deja obtenue : le Zarbi ne la redonne pas.
  if RuinesZarbi.A(d.cle, lettre) then return false end

  if math.random(100) > RuinesZarbi.CHANCE_PIERRE then return false end

  local id = 'ruines_pierre_' .. string.lower(lettre)
  local donne = false
  pcall(function()
    GAME:GivePlayerItem(id, 1)
    donne = true
  end)
  if donne then
    tablePierres(d.cle)[lettre] = true
    PrintInfo('[Ruines] pierre ' .. lettre .. ' obtenue (' .. d.mot .. ')')
  end
  return donne
end

--------------------------------------------------------------------
-- La tablette. Coeur de la mise en scene, patron d'Aegis Cave :
-- lecture des cavites -> proposition de fermer les yeux -> le mot
-- s'illumine -> l'escalier apparait.
--
-- Retourne true si la chambre vient d'etre ouverte.
--------------------------------------------------------------------
function RuinesZarbi.LireTablette()
  RuinesZarbi.Ensure()
  local seg, d = RuinesZarbi.SecteurActif()

  -- Les trois gardiens sont tombes : la tablette n'a plus rien a dire,
  -- le Puits est ouvert.
  if seg == nil then
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_FINI']))
    UI:SetCenter(false)
    UI:ResetSpeaker()
    return false
  end

  local manque = RuinesZarbi.Manquantes(seg)

  -- Premiere lecture : on decouvre les cavites.
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  if not SV.Ruines.TabletteVue then
    SV.Ruines.TabletteVue = true
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_DECOUVERTE']))
  end
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_CAVITES'], d.mot))
  UI:SetCenter(false)
  UI:ResetSpeaker()

  if #manque > 0 then
    -- Mot incomplet : on dit CE QUI manque, sans dire ou le trouver.
    local liste = table.concat(manque, ', ')
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_MANQUE'], liste))
    UI:SetCenter(false)
    UI:ResetSpeaker()
    return false
  end

  -- Mot complet : « fermez les yeux ».
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_COMPLET']))
  UI:SetCenter(false)
  UI:ResetSpeaker()

  UI:ChoiceMenuYesNo(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_FERMER']), false)
  UI:WaitForChoice()
  if not UI:ChoiceResult() then
    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_REFUS']))
    UI:SetCenter(false)
    UI:ResetSpeaker()
    return false
  end

  -- L'ouverture. Noir total, un son, puis la lumiere revient sur
  -- l'escalier. Le silence fait le travail : aucune musique par-dessus.
  pcall(function() SOUND:FadeOutBGM(40) end)
  GAME:FadeOut(false, 40)
  GAME:WaitFrames(50)
  pcall(function() SOUND:PlayBattleSE('EVT_Title_Intro') end)
  GAME:WaitFrames(60)
  GAME:FadeIn(60)
  GAME:WaitFrames(20)

  SV.Ruines['Mot' .. d.cle] = true
  PrintInfo('[Ruines] mot ' .. d.mot .. ' complete -> chambre de ' .. d.gardien)

  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['RUINES_TAB_OUVERT']))
  UI:SetCenter(false)
  UI:ResetSpeaker()
  return true
end

--------------------------------------------------------------------
-- Etat lisible, pour les dialogues du camp et le debogage.
--------------------------------------------------------------------
function RuinesZarbi.Etat()
  RuinesZarbi.Ensure()
  local seg, d = RuinesZarbi.SecteurActif()
  if seg == nil then return 'puits' end
  return d.cle, #RuinesZarbi.Manquantes(seg)
end

--------------------------------------------------------------------
-- ATTACHEMENT DU DROP AUX ETAGES DE LABYRINTHE
--------------------------------------------------------------------
-- Appele par un ScriptGenStep pose dans Data/Zone/cloven_ruins.json sur
-- les segments 0, 2 et 4. Patron repris a l'identique de
-- DungeonLife.SpawnWanderingMerchant (dungeon_life.lua:13-19) : meme
-- ActiveEffect, meme MapEffectStep generique, meme mise en file.
-- Aucune API nouvelle.
function RuinesZarbi.PoserDrop(zoneContext, context, queue, seed, args)
    local ae = RogueEssence.Data.ActiveEffect()
    ae.OnDeaths:Add(6, RogueEssence.Dungeon.SingleCharScriptEvent("RuinesZarbiDrop"))
    local es = LUA_ENGINE:MakeGenericType(
        luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1'),
        {luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')}, {ae})
    queue:Enqueue(RogueElements.Priority(-5), es)
end

return RuinesZarbi
