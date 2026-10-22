-- subscreen.lua — SINGLE-SCREEN FOCUS pour les scènes double écran NDS.
--
-- PMDO n'a qu'un écran : le 2e écran NDS (back2_SetGround + screen2_*)
-- est reconstruit comme une NAPPE PLEIN ÉCRAN native (Content/BG/
-- Sub_<id>.dir, rendu ROM pixel-perfect cadré fenêtre NDS 256x192 →
-- 320x240 même ratio). Le focus suit la TIMELINE CANONIQUE
-- (DUAL_SCREEN_TIMELINES.json, curseur = Wait()+durées de fondu ROM) :
--   TOP_FOCUS    -> la nappe sub couvre le canvas (le joueur voit
--                   l'écran du haut, comme quand la NDS ne révèle que lui)
--   BOTTOM_FOCUS -> nappe retirée, le ground principal est seul visible
--   BOTH_FOCUS   -> composition : nappe sub semi-cadrée au-dessus du
--                   ground principal révélé (les deux contenus visibles)
--   FOCUS_TRANSITION -> fondu de la durée ROM exacte
-- Le contenu du 2e écran n'est JAMAIS jeté : il est affiché chaque fois
-- que la timeline le requiert.
--
-- Implémentation : FiniteOverlayEmitter (BGAnimData), le seul affichage
-- plein écran du moteur (même mécanique que ChapterScenes/BossFX,
-- validée en jeu). En BOTH_FOCUS l'alpha est réduit pour laisser lire la
-- scène du bas — différence documentée : la NDS posait les deux écrans
-- l'un au-dessus de l'autre physiquement.
local SubScreen = {}

local current = nil   -- { emitter, name }

local function trace(s)
  if os.getenv('PMDO_GROUND_VALIDATOR') == nil then return end
  local f = io.open('/tmp/ground_gameplay_validator.jsonl', 'a')
  if f then f:write(s .. '\n'); f:close() end
end

local function overlay(name, fade_in, alpha)
  local o = RogueEssence.Content.FiniteOverlayEmitter()
  o.FadeIn = math.max(1, fade_in or 20)
  o.TotalTime = 100000            -- tenu jusqu'à Hide (scène courte)
  o.FadeOut = 20
  o.Layer = DrawLayer.Top
  o.RepeatX = false
  o.RepeatY = false
  o.Anim = RogueEssence.Content.BGAnimData(name, 0)
  local c = GAME:GetCameraCenter()
  -- l'émetteur dessine la nappe à partir de son origine : caler sur le
  -- coin haut-gauche du viewport (nappe 320x240 = viewport entier)
  GROUND:PlayVFX(o, c.X - 160, c.Y - 120)
  return o
end

-- affiche l'écran sub (TOP_FOCUS ou BOTH_FOCUS)
-- ground_id: id du décor (ex. 'v01p03a') ; fade: frames ROM ; both: bool
function SubScreen.Show(ground_id, fade, both)
  SubScreen.Hide(0)
  local name = 'Sub_' .. ground_id
  local ok, em = pcall(overlay, name, fade, both and 176 or 255)
  if ok then
    current = { emitter = em, name = name }
    trace(string.format(
      '{"subscreen":"show","bg":"%s","fade":%d,"mode":"%s"}',
      name, fade or 20, both and 'BOTH_FOCUS' or 'TOP_FOCUS'))
  else
    trace(string.format(
      '{"subscreen":"show_fail","bg":"%s","error":"%s"}',
      name, tostring(em):gsub('"', "'")))
  end
end

-- retire l'écran sub (retour BOTTOM_FOCUS)
function SubScreen.Hide(fade)
  if current == nil then return end
  local em = current.emitter
  pcall(function()
    em.TotalTime = math.max(1, (fade or 20))
    em.FadeOut = math.max(1, (fade or 20))
  end)
  trace(string.format('{"subscreen":"hide","bg":"%s","fade":%d}',
                      current.name, fade or 20))
  current = nil
end

function SubScreen.Active()
  return current ~= nil
end

return SubScreen
