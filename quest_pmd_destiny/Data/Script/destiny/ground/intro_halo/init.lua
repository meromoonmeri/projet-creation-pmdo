--[[ init.lua — Intro « halo arc-en-ciel » (map intro_halo)
     Chaîne de démarrage de la quest PMD Destiny, après le choix de la
     langue puis « Nouvelle partie » :
       Data/StartParams.xml → zone personality_test, ground 1 = intro_halo ;
       cette map (fond halo arc-en-ciel en Content/BG/Halo_*.dir) joue
       l'intro : le halo pulse entre le noir et sa pleine visibilité
       (fondus du moteur), avec les titres d'introduction de Halcyon en
       voice-over blanc (« Welcome to the world of Pokémon! » etc., textes
       FR) ; puis la transition : fondu blanc « aspiré par le halo » →
       map personality_test (fonds Dream_Back/Dream_Front = le « dream »).
     Mise en scène inspirée de l'intro Arceus de Pokémon Relict (halo sur
     fond noir) et des titres de Palikadude/Halcyon — code rédigé pour
     PMD Destiny. Honnêteté : runtime_tested false.
]]

require 'common'

local intro_halo = {}

-- ------------------------------------------------------------- map callbacks

function intro_halo.Init(map)
end

function intro_halo.Enter(map)
  intro_halo.Scene()
end

function intro_halo.Exit(map)
end

function intro_halo.Update(map)
end

function intro_halo.GameSave(map)
end

function intro_halo.GameLoad(map)
  intro_halo.Scene()
end

-- --------------------------------------------------------------- scène

function intro_halo.Scene()
  GAME:CutsceneMode(true)
  UI:ResetSpeaker()
  GAME:FadeOut(false, 1)
  GAME:WaitFrames(30)

  -- le halo apparaît, puis respire (noir ↔ visible) pendant les titres
  GAME:FadeIn(60)
  UI:WaitShowVoiceOver("Bienvenue dans le monde des Pokémon !", -1)

  GAME:FadeOut(false, 45)   -- le halo s'éteint
  GAME:FadeIn(45)           -- ... et revient (pulse)
  UI:WaitShowVoiceOver("Devant toi s'étend un monde rempli d'aventures\n palpitantes et de mystères à découvrir !", -1)
  UI:WaitShowVoiceOver("Avant de partir, tu dois prendre\n d'importantes décisions.", -1)

  GAME:FadeOut(false, 45)
  GAME:FadeIn(45)
  UI:WaitShowVoiceOver("Réfléchis bien avant de choisir !", -1)
  UI:WaitShowVoiceOver("À toi de faire tes choix !", -1)
  GAME:WaitFrames(40)

  -- transition dans le halo : fondu blanc (aspiré par la lumière),
  -- puis arrivée sur le test de personnalité (fond « dream »)
  GAME:FadeOut(true, 60)
  GAME:WaitFrames(20)
  GROUND:EnterGroundMap('personality_test', 'Main_Entrance_Marker')
end

return intro_halo
