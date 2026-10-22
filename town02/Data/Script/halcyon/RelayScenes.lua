--[[
    RelayScenes.lua
    Cinématiques d'arrivée aux relais et Stations-Relais : le duo entre en
    marchant, la caméra cadre le camp, puis le dialogue se déroule.
    Utilisé par les relais ch7-10, les 6 Stations du Réseau des Anciens
    Chemins, et les visites libres (hors chapitre) de tous les relais.

    cfg = {
      hero    = {x, y},        -- position de départ du héros (bord bas)
      partner = {x, y},        -- position de départ du partenaire
      camera  = {x, y},        -- centre de la caméra pendant la scène
      walk    = 56,            -- distance de marche vers le haut, en pixels
      title   = true/false,    -- afficher le nom du lieu en carton-titre
      music   = 'X.ogg' | nil, -- thème joué après le fondu (nil = silence géré par la map)
      lines   = {              -- dialogue, dans l'ordre
        { spk='partner', emo='Normal',  txt="..." },
        { spk='hero',    emo='Worried', txt="(...)" },
        { spk='narrator',                txt="..." },
      },
    }
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

RelayScenes = {}

function RelayScenes.DuoArrival(cfg)

	--LE NOIR AVANT TOUT APPEL MOTEUR (correctif d'arrivee, 2026-07-30).
	--Cette scene se joue sous le noir laisse par la carte precedente et ne
	--rallume qu'a son FadeIn final. Mais GAME:FadeOut est BLOQUANT
	--(ScriptGame.cs:1590) et rend la main au moteur : tout appel place
	--avant le premier fondu laisse passer des frames RENDUES, sur une
	--carte chargee mais NON MONTEE (joueur au marqueur par defaut, camera
	--non recadree, decor absent). D'ou l'eclair de zone nue signale en
	--jeu. FadeOut(false,1) sur ecran deja noir = no-op (FadeEffect.cs:63).
	pcall(function() GAME:FadeOut(false, 1) end)
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  GROUND:TeleportTo(hero, cfg.hero[1], cfg.hero[2], Direction.Up)
  if partner ~= nil then
    GROUND:TeleportTo(partner, cfg.partner[1], cfg.partner[2], Direction.Up)
  end
  GAME:MoveCamera(cfg.camera[1], cfg.camera[2], 1, false)

  UI:ResetSpeaker()
  if cfg.title then
    UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
    GAME:WaitFrames(60)
    UI:WaitHideTitle(20)
  end
  GAME:FadeIn(40)
  if cfg.music ~= nil then SOUND:PlayBGM(cfg.music, true) end
  GAME:WaitFrames(20)

  -- Le duo entre en marchant, le partenaire ouvre la voie d'un demi-pas.
  local walk = cfg.walk or 56
  local coro1 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveInDirection(partner, Direction.Up, walk, false, 1)
    end
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, walk, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(16)

  -- Le duo se fait face un court instant avant de parler.
  if partner ~= nil then
    GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
    GROUND:CharAnimateTurnTo(hero, Direction.Left, 4)
  end
  GAME:WaitFrames(10)

  for _, line in ipairs(cfg.lines) do
    if line.spk == 'hero' then
      GeneralFunctions.HeroDialogue(hero, line.txt, line.emo or 'Normal')
    elseif line.spk == 'narrator' then
      UI:ResetSpeaker()
      UI:SetCenter(true)
      UI:WaitShowDialogue(line.txt)
      UI:SetCenter(false)
    else
      if partner ~= nil then
        UI:SetSpeaker(partner)
        GeneralFunctions.SetEmotion(line.emo or 'Normal')
        UI:WaitShowDialogue(line.txt)
      end
    end
    if line.wait ~= nil then GAME:WaitFrames(line.wait) end
  end

  GAME:WaitFrames(14)
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
  end
  GAME:CutsceneMode(false)
end

return RelayScenes
