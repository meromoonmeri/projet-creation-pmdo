--[[
    guild_heros_room_ch_11.lua
    Chambre du Héros — Chapitre 11 : « Ceux que l'on accuse »

    POINT D'ENTREE DE L'ARC DE L'ACCUSATION
    ------------------------------------------------------------------
    Correctif 2026-08-02. AccusationArc.lua contenait les dix scènes du
    chapitre et n'était require'd par AUCUN fichier du dépôt : le module
    n'était donc jamais chargé, et ses dix scènes étaient inatteignables.
    Sous RogueEssence, un module global qui n'est pas require'd n'existe
    tout simplement pas à l'exécution — `AccusationArc.Play` aurait levé
    « attempt to index a nil value ».

    C'est ce fichier qui le charge et qui l'enchaîne, parce qu'il est
    lui-même appelé par guild_heros_room/init.lua (l. 386) à l'entrée du
    chapitre 11.

    Le carton disait encore « L'Autre Continent » : c'était le titre du
    plan initial, avant que le chapitre soit réécrit autour de
    l'accusation. Le voyage vers le Bourg du Comptoir n'a pas disparu —
    il vient APRES la fuite, une fois le duo sorti de Metano.
]]

require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'
require 'halcyon.AccusationArc'
require 'halcyon.ground.guild_heros_room.guild_heros_room_helper'

guild_heros_room_ch_11 = {}

--------------------------------------------------------------------
-- Carton de chapitre, puis bascule sur la première scène de l'arc.
--------------------------------------------------------------------
function guild_heros_room_ch_11.ShowTitleCard()
  local ok = pcall(function()
    GAME:FadeOut(false, 1)
    GAME:CutsceneMode(true)
    local partner = CH('Teammate1')
    if partner ~= nil then AI:DisableCharacterAI(partner) end
    UI:ResetSpeaker()
    SOUND:StopBGM()
    GAME:WaitFrames(60)

    local coro1 = TASK:BranchCoroutine(function()
      UI:WaitShowTitle("Chapitre 11\nCeux que l'on accuse\n", 20)
      GAME:WaitFrames(180)
      UI:WaitHideTitle(20)
    end)
    local coro2 = TASK:BranchCoroutine(function()
      -- Chapter_10 plutôt que Chapter_1 : le fond du chapitre précédent
      -- prolonge visuellement le climax de l'Autel, alors que le BG du
      -- chapitre 1 n'avait aucun rapport (c'était un repli esthétique).
      UI:WaitShowBG("Chapter_10", 180, 20)
      GAME:WaitFrames(180)
      UI:WaitHideBG(20)
    end)
    TASK:JoinCoroutines({coro1, coro2})
    GAME:WaitFrames(90)

    SV.Chapter11.ShowedTitleCard = true
  end)

  if not ok then
    PrintInfo("[guild_heros_room_ch_11] carton interrompu")
  end

  -- Le duo se réveille dans la chambre : c'est la scène 1 de l'arc, le
  -- retour au sol. Elle se joue ici, pas en ville — ils rentrent de
  -- l'Autel et ne comprennent pas encore ce qui les attend dehors.
  guild_heros_room_ch_11.OpenArc()
end

--------------------------------------------------------------------
-- Enchaînement des scènes de l'arc depuis la chambre.
-- Les scènes 3 à 8 se jouent en ville (metano_town) et sont appelées
-- par son PlotScripting ; celles-ci sont les scènes « intérieures ».
--------------------------------------------------------------------
function guild_heros_room_ch_11.OpenArc()
  local s = SV.AccusationArc
  if s == nil then
    -- Rattrapage : la table est déclarée dans scriptvars et complétée
    -- par OnUpgrade, mais on ne suppose jamais qu'elle existe.
    SV.AccusationArc = { Scene = 0 }
    s = SV.AccusationArc
  end

  if s.Scene == 0 then
    AccusationArc.Play(AccusationArc.Scene1_Retour, 'Scene1_Retour')
  elseif s.SawProtest and s.GuildCouncil and not s.PartnerChose then
    -- Scène 9 : la décision. Elle se joue la nuit, dans la chambre, une
    -- fois la manifestation vue (scène 7) ET le conseil tenu (scène 8) :
    -- le partenaire ne décide qu'après avoir entendu Penticus admettre
    -- qu'il n'a plus les moyens. Sans la condition sur GuildCouncil, la
    -- décision se jouait avant le conseil et le rendait sans objet.
    AccusationArc.Play(AccusationArc.Scene9_Decision, 'Scene9_Decision')
    guild_heros_room_ch_11.Depart()
  else
    GAME:FadeIn(20)
  end
end

--------------------------------------------------------------------
-- Scène 10 — le départ, en deux lieux.
--------------------------------------------------------------------
function guild_heros_room_ch_11.Depart()
  local ok = pcall(function()
    GAME:FadeOut(false, 45)
    GAME:WaitFrames(30)
    SV.Chapter11.FledGuild = true
  end)
  if not ok then PrintInfo("[guild_heros_room_ch_11] Depart interrompu") end

  -- 10a se joue dans la ville de nuit, 10b au carrefour. C'est
  -- metano_town_nuit qui enchaîne, pour que le trajet soit visible.
  pcall(function()
    GAME:EnterGroundMap("metano_town_nuit", "Guild_Entrance_Marker")
  end)
end

return guild_heros_room_ch_11
