--[[
    RedCanonScene — rejeu d'une cinématique canonique PMD Red.

    La séquence vient de l'extraction de la ROM
    (`RESERVE/red_cinematics/<scene>.cif.json`) : dialogues, changements et
    fondus de musique, secousses d'écran, panoramiques de caméra, animations.
    Elle est rejouée dans l'ordre exact du script d'origine.

    Rien n'est inventé :
      * une réplique dont le texte n'est pas importé est sautée ;
      * un évènement dont l'extraction ne donne pas la cible (quel personnage
        joue l'animation, vers quelles coordonnées panoramique la caméra) est
        compté et journalisé, jamais remplacé par une approximation.

    Compléter la fidélité exige le décodage complet du script de la ROM
    (coordonnées et acteurs) : voir docs/dungeon_builder/CANON_SCENES.md.
]]
require 'origin.common'

RedCanonScene = {}

local reported = {}

--- Texte canonique de la clé, ou nil s'il n'est pas importé.
function RedCanonScene.Text(key)
  local ok, value = pcall(function() return STRINGS:FormatKey(key) end)
  if not ok or value == nil then return nil end
  value = tostring(value)
  if value == '' or value == key then return nil end
  return value
end

local function shake(frames)
  local ok = pcall(function()
    local mover = RogueEssence.Content.ScreenMover(2, 6, frames or 30)
    GROUND:MoveScreen(mover)
  end)
  return ok
end

--- Rejoue la séquence canonique. `events` est une liste ordonnée de tables :
---   { t='msg',  key='SCENE_D06P01_001' }
---   { t='bgm',  track='Mt. Thunder' }
---   { t='bgm_fade', frames=30 }
---   { t='shake', frames=30 }
---   { t='camera', action='INIT_PAN' }
---   { t='anim', id='5' }
function RedCanonScene.Play(scene, events)
  GAME:CutsceneMode(true)
  local stats = { msg = 0, missing_text = 0, bgm = 0, shake = 0, skipped = 0 }
  for _, ev in ipairs(events or {}) do
    if ev.t == 'msg' then
      local text = RedCanonScene.Text(ev.key)
      if text ~= nil then
        UI:ResetSpeaker(false)
        UI:WaitShowDialogue(text)
        stats.msg = stats.msg + 1
      else
        stats.missing_text = stats.missing_text + 1
      end
    elseif ev.t == 'bgm' then
      if ev.track ~= nil and ev.track ~= '' then
        pcall(function() SOUND:PlayBGM(ev.track, true) end)
        stats.bgm = stats.bgm + 1
      else
        stats.skipped = stats.skipped + 1
      end
    elseif ev.t == 'bgm_fade' then
      pcall(function() SOUND:FadeOutBGM(ev.frames or 30) end)
      stats.bgm = stats.bgm + 1
    elseif ev.t == 'shake' then
      if shake(ev.frames) then stats.shake = stats.shake + 1
      else stats.skipped = stats.skipped + 1 end
    else
      -- 'anim' et 'camera' : l'extraction ne donne ni l'acteur ni les
      -- coordonnées. On ne joue rien plutôt que d'inventer un mouvement.
      stats.skipped = stats.skipped + 1
    end
  end
  if not reported[scene] then
    reported[scene] = true
    PrintInfo(string.format(
      '[RedCanonScene] %s : %d réplique(s) jouée(s), %d sans texte importé, '
      .. '%d évènement(s) audio, %d secousse(s), %d évènement(s) non décodés '
      .. '(acteur ou coordonnées absents de l extraction ROM).',
      tostring(scene), stats.msg, stats.missing_text, stats.bgm, stats.shake,
      stats.skipped))
  end
  return stats
end

return RedCanonScene
