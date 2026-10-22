--[[
    MidpointTemplate.lua
    TEMPLATE INTER-DONJONS DU POINT MEDIAN (motif « Tunnel Incandescent »).

    -------------------------------------------------------------------
    PRINCIPE
    -------------------------------------------------------------------
    Le point median est UNE SEULE structure de gameplay/mise en scene,
    declinee visuellement d'un donjon a l'autre. Ce fichier porte la
    STRUCTURE (fixe, partagee, non negociable). Chaque donjon ne fournit
    que son HABILLAGE (palette, decor, particules, ambiance, lumiere).

      Structure = ici, dans ce fichier, identique partout.
      Habillage = dans la table `skin` passee par chaque relais.

    Le joueur doit reconnaitre le meme type de passage a chaque
    rencontre, tout en le sentant pleinement integre a son biome.

    -------------------------------------------------------------------
    LES 4 ETATS DU TEMPLATE (squelette, jamais reinvente)
    -------------------------------------------------------------------
    Repris a l'identique du patron d'origine
    (searing_tunnel_midpoint/init.lua:159-166 + _ch_5.lua:12-23) :

      FirstArrival  — premiere venue. Palier reconnu, camp decouvert,
                      carton-titre, on souffle, on prepare la suite.
      RepeatArrival — retour apres une sortie a l'amiable (repli
                      volontaire, ou reprise d'une sauvegarde faite au
                      relais). Bref, sobre : on reprend le fil.
      DeathArrival  — reveil apres un KO au-dela du checkpoint.
                      L'equipe se reveille au sol, ranimee.
      Rest          — le relais est deja connu et rien de special :
                      simple fondu, le joueur garde la main.

    -------------------------------------------------------------------
    FONCTION DANS LA PROGRESSION (identique partout)
    -------------------------------------------------------------------
      1. PALIER      — marque le milieu du trajet, moitie 1 / moitie 2.
      2. PAUSE       — rocher de Kangourex : soin, stockage, sauvegarde.
      3. REPERE      — carton-titre a la premiere venue : on se situe.
      4. TRANSITION  — sortie nord = on avance, sortie sud = on redescend.

    -------------------------------------------------------------------
    HABILLAGE ATTENDU (table `skin`, propre a CHAQUE donjon)
    -------------------------------------------------------------------
      skin = {
        music     = 'X.ogg',     -- theme du camp, propre au biome
        status    = 'steam',     -- MapStatus d'ambiance (peut etre nil)
        particle  = {...},       -- particule d'ambiance (peut etre nil)
        hero      = {x, y},      -- arrivee du heros
        partner   = {x, y},
        camera    = {x, y},
        walk      = 48,          -- pas d'entree, en pixels
        posts     = {...},       -- postes de repos des equipiers
        wake      = {...},       -- disposition du reveil apres KO
      }

    Regle de non-duplication : deux donjons ne doivent JAMAIS partager
    le meme habillage complet. Seule la structure est commune.

    -------------------------------------------------------------------
    NOTES MOTEUR (verifiees, ne pas « optimiser »)
    -------------------------------------------------------------------
    - GAME:FadeOut est BLOQUANT (ScriptGame.cs:1590) et FadeInternal rend
      la main a chaque frame (FadeEffect.cs:30-42) : tout appel place
      avant le premier fondu laisse passer des frames RENDUES sur une
      carte non montee. D'ou le FadeOut(false,1) en tete de chaque
      scene — no-op sur ecran deja noir (FadeEffect.cs:63-64).
    - GROUND:AddMapStatus / BossFX.Particle echouent EN SILENCE sur un
      nom absent : tous les noms passes ici sont verifies presents.
    - Les MapStatus reellement presents dans Data/MapStatus/ sont :
      autumn_leaves, blowing_wind, blowing_wind_fast, darkness, dusk,
      falling_ash, mysterious_distortion, sakura_drift, steam,
      winter_snow.
]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

MidpointTemplate = {}

--------------------------------------------------------------------
-- Habillage : pose l'ambiance du biome (statut de carte + particules)
-- Silencieux et defensif : un habillage absent ne casse pas la scene.
--------------------------------------------------------------------
function MidpointTemplate.ApplySkin(skin)
  if skin == nil then return end
  if skin.status ~= nil then
    pcall(function() GROUND:AddMapStatus(skin.status) end)
  end
  if skin.particle ~= nil then
    pcall(function()
      require 'halcyon.BossFX'
      for _, p in ipairs(skin.particle) do
        BossFX.Particle(p[1], p[2], p[3], p[4] or 4)
      end
    end)
  end
end

--------------------------------------------------------------------
-- Locuteur generique. `who` est un personnage deja resolu par
-- l'appelant ; on ne devine jamais un slot d'equipe ici.
--------------------------------------------------------------------
local function say(who, hero, line)
  if line.spk == 'hero' then
    GeneralFunctions.HeroDialogue(hero, line.txt, line.emo or 'Normal')
  elseif line.spk == 'narrator' then
    UI:ResetSpeaker()
    UI:SetCenter(true)
    UI:WaitShowDialogue(line.txt)
    UI:SetCenter(false)
  elseif who ~= nil then
    UI:SetSpeaker(who)
    GeneralFunctions.SetEmotion(line.emo or 'Normal')
    UI:WaitShowDialogue(line.txt)
  end
  if line.wait ~= nil then GAME:WaitFrames(line.wait) end
end

--------------------------------------------------------------------
-- ETAT 1 — FirstArrival
-- Le duo (et l'escorte) entrent par le bas, decouvrent le palier.
-- Carton-titre : c'est le repere. Puis on souffle, puis on repart.
--------------------------------------------------------------------
function MidpointTemplate.FirstArrival(cfg)
  --Le noir AVANT tout appel moteur (cf. notes en tete de fichier).
  pcall(function() GAME:FadeOut(false, 1) end)

  local skin = cfg.skin or {}
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local cast = cfg.cast or {}

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  MidpointTemplate.ApplySkin(skin)

  GROUND:TeleportTo(hero, skin.hero[1], skin.hero[2], Direction.Up)
  if partner ~= nil then
    GROUND:TeleportTo(partner, skin.partner[1], skin.partner[2], Direction.Up)
  end
  --L'escorte entre derriere le duo, decalee vers le bas.
  for _, m in ipairs(cast) do
    if m.chara ~= nil and m.enter ~= nil then
      GROUND:TeleportTo(m.chara, m.enter[1], m.enter[2], Direction.Up)
    end
  end
  GAME:MoveCamera(skin.camera[1], skin.camera[2], 1, false)

  --REPERE : le carton-titre signe le palier. Present a chaque premiere
  --venue, dans tous les donjons — c'est un marqueur du template.
  UI:ResetSpeaker()
  UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
  GAME:FadeIn(40)
  if skin.music ~= nil then SOUND:PlayBGM(skin.music, false) end
  GAME:WaitFrames(30)

  --Entree en marchant : le partenaire ouvre la voie d'un demi-pas.
  local walk = skin.walk or 48
  local coros = {}
  table.insert(coros, TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveInDirection(partner, Direction.Up, walk, false, 1)
    end
  end))
  table.insert(coros, TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, walk, false, 1)
  end))
  for i, m in ipairs(cast) do
    if m.chara ~= nil and m.enter ~= nil then
      table.insert(coros, TASK:BranchCoroutine(function()
        GAME:WaitFrames(12 + i * 6)
        GROUND:MoveInDirection(m.chara, Direction.Up, walk, false, 1)
      end))
    end
  end
  TASK:JoinCoroutines(coros)
  GAME:WaitFrames(20)

  for _, line in ipairs(cfg.lines or {}) do
    say(line.who, hero, line)
  end

  GAME:WaitFrames(30)

  --Les equipiers gagnent leur poste de repos : le camp s'installe
  --sous les yeux du joueur avant qu'il ne reprenne la main.
  local posts = {}
  for _, m in ipairs(cast) do
    if m.chara ~= nil and m.post ~= nil then
      table.insert(posts, TASK:BranchCoroutine(function()
        GeneralFunctions.EightWayMove(m.chara, m.post[1], m.post[2], false, 1)
        if m.face ~= nil then GROUND:CharAnimateTurnTo(m.chara, m.face, 4) end
      end))
    end
  end
  if #posts > 0 then TASK:JoinCoroutines(posts) end

  if cfg.onDone ~= nil then cfg.onDone() end

  --Reprise de main sous un fondu court (regle de mise en scene du
  --projet : le joueur ne reprend jamais la main en plein plan fixe).
  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
  end
  GeneralFunctions.RendreLaMain(true)
end

--------------------------------------------------------------------
-- ETAT 2 — RepeatArrival
-- Retour a l'amiable : repli volontaire, ou reprise d'une sauvegarde
-- faite au relais. Court, sobre, sans carton-titre : le lieu est deja
-- connu, on ne rejoue pas la decouverte. Meme fonction de palier.
--------------------------------------------------------------------
function MidpointTemplate.RepeatArrival(cfg)
  pcall(function() GAME:FadeOut(false, 1) end)

  local skin = cfg.skin or {}
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local cast = cfg.cast or {}

  GAME:CutsceneMode(true)
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  MidpointTemplate.ApplySkin(skin)

  --Disposition « camp deja monte » : chacun a son poste, le duo arrive.
  GROUND:TeleportTo(hero, skin.hero[1], skin.hero[2], Direction.Up)
  if partner ~= nil then
    GROUND:TeleportTo(partner, skin.partner[1], skin.partner[2], Direction.Up)
  end
  for _, m in ipairs(cast) do
    if m.chara ~= nil and m.post ~= nil then
      GROUND:TeleportTo(m.chara, m.post[1], m.post[2], m.face or Direction.Down)
    end
  end
  GAME:MoveCamera(skin.camera[1], skin.camera[2], 1, false)

  GAME:FadeIn(40)
  if skin.music ~= nil then SOUND:PlayBGM(skin.music, true) end
  GAME:WaitFrames(24)

  --Quelques pas seulement : on rentre au camp, on ne le decouvre pas.
  local step = math.floor((skin.walk or 48) / 2)
  local coro1 = TASK:BranchCoroutine(function()
    if partner ~= nil then
      GROUND:MoveInDirection(partner, Direction.Up, step, false, 1)
    end
  end)
  local coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(6)
    GROUND:MoveInDirection(hero, Direction.Up, step, false, 1)
  end)
  TASK:JoinCoroutines({coro1, coro2})
  GAME:WaitFrames(16)

  for _, line in ipairs(cfg.lines or {}) do
    say(line.who, hero, line)
  end

  GAME:WaitFrames(20)
  if cfg.onDone ~= nil then cfg.onDone() end

  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
  end
  GeneralFunctions.RendreLaMain(true)
end

--------------------------------------------------------------------
-- ETAT 3 — DeathArrival
-- Reveil apres un KO au-dela du checkpoint. Structure fixe, reprise du
-- patron d'origine (searing_tunnel_midpoint_ch_5.lua:333-472) :
--   ecran noir -> tout le monde au sol (EventSleep) -> fondu ->
--   attente -> reveils decales -> on se regarde -> dialogue -> main.
--------------------------------------------------------------------
function MidpointTemplate.DeathArrival(cfg)
  pcall(function() GAME:FadeOut(false, 1) end)

  local skin = cfg.skin or {}
  local wake = skin.wake or {}
  local hero = CH('PLAYER')
  local partner = CH('Teammate1')
  local cast = cfg.cast or {}

  GAME:CutsceneMode(true)
  SOUND:StopBGM()
  if partner ~= nil then AI:DisableCharacterAI(partner) end

  MidpointTemplate.ApplySkin(skin)

  GROUND:TeleportTo(hero, wake.hero[1], wake.hero[2], wake.heroFace or Direction.Left)
  GROUND:CharSetAnim(hero, 'EventSleep', true)
  if partner ~= nil then
    GROUND:TeleportTo(partner, wake.partner[1], wake.partner[2], wake.partnerFace or Direction.Right)
    --Decale d'une poignee de frames : les cycles de respiration ne
    --doivent pas etre synchrones, sinon l'effet est mecanique.
    GAME:WaitFrames(10)
    GROUND:CharSetAnim(partner, 'EventSleep', true)
  end
  --L'escorte a porte le duo jusqu'au camp : elle veille, debout.
  for _, m in ipairs(cast) do
    if m.chara ~= nil and m.watch ~= nil then
      GROUND:TeleportTo(m.chara, m.watch[1], m.watch[2], m.watchFace or Direction.Up)
    end
  end
  GAME:MoveCamera(wake.camera[1], wake.camera[2], 1, false)

  GAME:FadeIn(60)
  if skin.wakeMusic ~= nil then SOUND:PlayBGM(skin.wakeMusic, true) end
  --110 et non 120 : la boucle de sommeil ne doit pas entamer une
  --nouvelle image juste avant le reveil (patron d'origine).
  GAME:WaitFrames(110)

  local coros = {}
  table.insert(coros, TASK:BranchCoroutine(function()
    GeneralFunctions.DoAnimation(hero, 'Wake')
    GAME:WaitFrames(12)
    GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
  end))
  if partner ~= nil then
    table.insert(coros, TASK:BranchCoroutine(function()
      GAME:WaitFrames(14)
      GeneralFunctions.DoAnimation(partner, 'Wake')
      GAME:WaitFrames(12)
      GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
    end))
  end
  for i, m in ipairs(cast) do
    if m.chara ~= nil and m.watch ~= nil then
      table.insert(coros, TASK:BranchCoroutine(function()
        GAME:WaitFrames(30 + i * 14)
        GROUND:CharAnimateTurnTo(m.chara, Direction.Down, 4)
      end))
    end
  end
  TASK:JoinCoroutines(coros)
  GAME:WaitFrames(30)

  for _, line in ipairs(cfg.lines or {}) do
    say(line.who, hero, line)
  end

  GAME:WaitFrames(20)
  if cfg.onDone ~= nil then cfg.onDone() end

  if partner ~= nil then
    AI:EnableCharacterAI(partner)
    AI:SetCharacterAI(partner, 'origin.ai.ground_partner', hero, partner.Position)
    PartnerEssentials.SaveGamePartnerPosition(partner)
  end
  GeneralFunctions.RendreLaMain(true)
end

--------------------------------------------------------------------
-- ETAT 4 — Rest
-- Le relais est connu, rien de special : on place le camp et on rend
-- la main. Pas de cinematique — mais l'habillage du biome est pose,
-- pour que le lieu reste le meme d'une visite a l'autre.
--------------------------------------------------------------------
function MidpointTemplate.Rest(cfg)
  local skin = cfg.skin or {}
  MidpointTemplate.ApplySkin(skin)
  for _, m in ipairs(cfg.cast or {}) do
    if m.chara ~= nil and m.post ~= nil then
      GROUND:TeleportTo(m.chara, m.post[1], m.post[2], m.face or Direction.Down)
    end
  end
  GAME:FadeIn(20)
end

--------------------------------------------------------------------
-- Routeur commun. Chaque relais lui passe son etat et son habillage ;
-- l'ordre des branches est le meme partout, c'est ce qui garantit que
-- le point median se comporte pareil d'un donjon a l'autre.
--------------------------------------------------------------------
function MidpointTemplate.Route(state, cfg)
  if state == 'DeathArrival' then
    MidpointTemplate.DeathArrival(cfg)
  elseif state == 'FirstArrival' then
    MidpointTemplate.FirstArrival(cfg)
  elseif state == 'RepeatArrival' then
    MidpointTemplate.RepeatArrival(cfg)
  else
    MidpointTemplate.Rest(cfg)
  end
end

return MidpointTemplate
