-- scrollpilot.lua — PILOTE BACKGROUND DÉFILANT (catégorie
-- CINEMATIC_SCROLL_BACKGROUND, contrat CLASSIFICATION_PIPELINE.md).
--
-- Source canonique : SCRIPT/S13P05A/t02a0204.ssb (ROM Sky EU) — panorama
-- vertical 312x576 px (s13p05a, "Top Menu theme") :
--   back_SetBackScrollOffset(0, -70)      départ décalé de 70 tuiles ? NON:
--                                         unité = px NDS (offset caméra Y)
--   back_SetBackScrollSpeed(0.6992, 0)    défilement X 0.6992 px/frame
--   (le performer 0 = caméra glisse vers le mark m0 (19.5, 47.5) tuiles)
--
-- Adaptation technique PMDO (documentée) : le défilement d'un background
-- plein écran NDS est reproduit par le MOUVEMENT DE CAMÉRA continu sur le
-- ground panorama (GAME:MoveCamera, API native) — même effet visuel :
-- l'image défile à vitesse constante. La vitesse ROM (px/frame) est
-- convertie en durée exacte : distance / vitesse = frames.
-- Le test vérifie LE MOUVEMENT (positions de caméra relues à 3 instants),
-- pas seulement la première frame.
local ScrollPilot = {}

local function emit(s)
  local f = io.open('/tmp/ground_gameplay_validator.jsonl', 'a')
  if f then f:write(s .. '\n'); f:close() end
  PrintInfo('[SCROLL_PILOT] ' .. s)
end

local function cam_pos()
  local x, y = -1, -1
  pcall(function()
    local m = GAME:GetCurrentGround()
    x = m.ViewCenter.X; y = m.ViewCenter.Y
  end)
  return x, y
end

function ScrollPilot.s13p05a_t02a0204()
  -- caméra au départ : bas du panorama, offset ROM (0, -70) px appliqué
  -- au point de départ du performer (mark m0 19.5, 47.5 tuiles => px).
  local mx, my = math.floor(19.5 * 8), math.floor(47.5 * 8)
  local start_y = my + 100  -- SetPositionOffset<performer 0>(0, -100): la
                            -- caméra PART 100px SOUS le mark et remonte
  pcall(function() GAME:MoveCamera(mx, start_y, 1, false) end)
  GAME:FadeIn(30)
  local x0, y0 = cam_pos()
  emit(string.format('{"scroll":"begin","cam":[%d,%d]}', x0, y0))

  -- MovePositionMark<performer 0>(1, m0) : la caméra glisse à vitesse 1
  -- (1 px/frame NDS) vers le mark -> durée = distance / 1 = 100 frames.
  pcall(function() GAME:MoveCamera(mx, my, 100, false) end)
  GAME:WaitFrames(50)
  local x1, y1 = cam_pos()
  emit(string.format('{"scroll":"mid","cam":[%d,%d]}', x1, y1))
  GAME:WaitFrames(60)
  local x2, y2 = cam_pos()
  emit(string.format('{"scroll":"end","cam":[%d,%d]}', x2, y2))

  -- back_SetBackScrollSpeed(0.6992, 0) : défilement horizontal lent après
  -- l'arrivée (0.6992 px/frame pendant ~85 frames = ~59 px)
  pcall(function() GAME:MoveCamera(mx + 59, my, 85, false) end)
  GAME:WaitFrames(90)
  local x3, y3 = cam_pos()
  emit(string.format('{"scroll":"drift","cam":[%d,%d]}', x3, y3))

  -- screen_WhiteOut(1, 30) : fin de la séquence
  GAME:FadeOut(true, 30)

  -- VERDICT : le mouvement doit être réel (la caméra a bougé entre les
  -- trois mesures, dans les bonnes directions : remontée Y puis drift X)
  local moved_up = (y1 < y0) and (y2 <= y1)
  local drifted = (x3 > x2)
  local v = (moved_up and drifted) and "SCROLL_RUNTIME_PASS" or "FAIL"
  emit(string.format(
    '{"scroll":"verdict","moved_up":%s,"drifted_x":%s,' ..
    '"source":"SCRIPT/S13P05A/t02a0204.ssb","adaptation":' ..
    '"scrolling NDS -> caméra continue PMDO (durée=distance/vitesse ROM)",' ..
    '"verdict":"%s"}', tostring(moved_up), tostring(drifted), v))
  GAME:FadeIn(20)
end

return ScrollPilot
