-- ==========================================================================
-- Cinematique d'Opening PMDO 0.8.12 (sprites multi-poses 8 directions)
-- Schema choregraphique « Simple and Clean -Ray of Hope MIX- » (opening anime) :
--   Acte I    abysse & chute arriere
--   Acte II   vitrail du destin
--   Acte III  plage & course au clair de lune
--   Acte IV   melee contre les ombres, partenaires possedes
--   Acte V    fissure de la realite & Mega-Evolution (Lucario -> Mega-Lucario)
--   Acte VI   chute celeste, barriere, patte tendue
--   Acte VII  trio reuni & pose devant l'embleme Oeuf Aile
-- Jouable en ground : pmd_destiny_opening.PlayOpeningCutscene(...)
-- ==========================================================================
local pmd_destiny_opening = {}

local function anim(c, name, loop)
  if c ~= nil then
    GROUND:CharSetAnim(c, name, loop)
  end
end

local function turn(a, b, t)
  if a ~= nil and b ~= nil then
    GROUND:CharTurnToCharAnimated(a, b, t or 4)
  end
end

function pmd_destiny_opening.PlayOpeningCutscene(lucario, riolu, evoli, sh_zoroark, sh_massko, tiplouf, darkrai, mega)
  GAME:CutsceneMode(true)
  GAME:FadeIn(20)
  -- Actes I-II : abysse & chute arriere vers le Vitrail du Destin
  anim(lucario, "DeepBreath", false)
  GAME:MoveCamera(0, -24, 45, true)
  anim(lucario, "TumbleBack", false)
  GAME:WaitFrames(24)
  anim(lucario, "Float", true)
  GAME:WaitFrames(40)
  GAME:MoveCamera(0, 16, 30, true)
  GAME:WaitFrames(24)

  -- Acte III : plage & course au clair de lune (le trio court, Evoli bondit)
  anim(riolu, "Walk", true)
  anim(evoli, "Walk", true)
  anim(tiplouf, "Walk", true)
  GAME:MoveCamera(24, 0, 40, true)
  GAME:WaitFrames(30)
  anim(evoli, "Hop", false)
  GAME:WaitFrames(16)

  -- Acte IV : melee choregraphiee sur l'eau miroir + possession par Darkrai
  turn(sh_zoroark, lucario)
  anim(sh_zoroark, "QuickStrike", false)
  anim(lucario, "Strike", false)
  GAME:MoveCamera(8, -4, 8, true)
  GAME:WaitFrames(18)
  anim(sh_massko, "Swing", false)
  anim(lucario, "Double", false)
  GAME:WaitFrames(22)
  anim(lucario, "Pain", true)
  anim(darkrai, "Charge", false)
  anim(evoli, "Cringe", false)
  anim(tiplouf, "Cringe", false)
  GAME:WaitFrames(20)
  anim(riolu, "Hop", false)
  anim(evoli, "Hop", false)
  GAME:WaitFrames(16)
  anim(riolu, "QuickStrike", false)
  anim(evoli, "Double", false)
  anim(lucario, "RearUp", false)
  GAME:WaitFrames(30)

  -- Acte V : fissure de la realite, Lucario atterrit puis Mega-Evolue
  anim(lucario, "LeapForth", false)
  GAME:MoveCamera(0, -8, 14, true)
  GAME:WaitFrames(20)
  anim(lucario, "Charge", true)
  GAME:WaitFrames(48)
  GAME:FadeOut(true, 4)
  GAME:FadeIn(4)
  anim(mega, "RearUp", false)
  anim(mega, "Pose", false)
  anim(lucario, "Idle", true)
  GAME:WaitFrames(30)

  -- Acte VI : chute celeste, barriere, patte tendue a travers l'ocean
  anim(evoli, "Sink", false)
  anim(riolu, "Sink", false)
  anim(tiplouf, "Sink", false)
  GAME:MoveCamera(0, 24, 45, true)
  GAME:WaitFrames(36)
  anim(riolu, "Float", true)
  anim(tiplouf, "Float", true)
  GAME:WaitFrames(24)
  anim(riolu, "Pull", false)
  GAME:WaitFrames(20)
  anim(evoli, "Wake", false)
  anim(evoli, "LookUp", false)
  anim(evoli, "Nod", false)
  GAME:WaitFrames(24)

  -- Acte VII : trio reuni, pose commune, puis embleme Oeuf Aile (titre)
  anim(riolu, "Pose", false)
  anim(evoli, "Pose", false)
  anim(tiplouf, "Pose", false)
  GAME:MoveCamera(0, -8, 24, true)
  GAME:WaitFrames(36)
  GAME:FadeOut(true, 30)
  GAME:CutsceneMode(false)
end

return pmd_destiny_opening
