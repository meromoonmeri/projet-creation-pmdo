-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m26a0506.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_ATTENDANT1
    -- SetAnimation(2) [anim idle native]
    -- @label_0 [étiquette de flux ExplorerScript]
    -- forever{...} NDS: une itération compilée (ré-affichage du menu = annulation, documenté)
    GAME:WaitFrames(30)
    -- CallCommon CORO_EXPLANATION_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(30)
    GROUND:EntTurn(partner, Direction.DownLeft)
    GAME:WaitFrames(math.random(45, 80))
    GROUND:EntTurn(partner, Direction.DownRight)
    GAME:WaitFrames(math.random(45, 80))
    GROUND:EntTurn(partner, Direction.Down)
    -- continue [contrôle de boucle forever NDS: une itération compilée]
    -- may be redundant
  end)
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][partner] told the story whenever\n[CN]and wherever possible...", french="[CN][partner] répéta cette histoire encore\n[CN]et encore, à qui voulait l'entendre...", german="[CN][partner] erzählt die Geschichte,\n[CN]wo und wann immer es möglich ist.", italian="[CN][partner] racconta la storia\n[CN]ogni qualvolta è possibile...", spanish="[CN][partner] contó su historia\n[CN]siempre que se presentó la ocasión..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]to as many Pokémon as possible.", french="[CN]et à autant de Pokémon que possible.", german="[CN]Und so vielen Pokémon wie möglich.", italian="[CN]... e a ogni Pokémon che incontra.", spanish="[CN]A todos los Pokémon que le fue posible."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It was a story that had to be told.", french="[CN]C'était une histoire à faire\n[CN]revivre sans cesse.", german="[CN]Es ist eine Geschichte, die erzählt werden\n[CN]muss.", italian="[CN]È una storia che dev'essere raccontata.", spanish="[CN]Era una historia que debía ser contada."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It was a story of hope for world peace.", french="[CN]Une histoire pleine d'espoir\n[CN]pour un monde en paix.", german="[CN]Eine Geschichte der Hoffnung auf den\n[CN]Weltfrieden.", italian="[CN]È una storia di speranza per la pace nel mondo.", spanish="[CN]Una historia de esperanza para todos..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]It was a story of hope for future peace.", french="[CN]Une histoire pleine d'espoir\n[CN]pour un futur en paix.", german="[CN]Eine Geschichte für eine friedliche\n[CN]Zukunft.", italian="[CN]È una storia di speranza per un futuro di pace.", spanish="[CN]Una historia de esperanza para el futuro."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]So months passed...", french="[CN]Ainsi, les mois passèrent...", german="[CN]Die Monate verstreichen...", italian="[CN]E così i mesi passano...", spanish="[CN]Los meses fueron pasando..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Treasure Town returned to its\n[CN]cheerful routines...", french="[CN]... les habitants de Bourg-Trésor\n[CN]reprirent leur petite vie sereine...", german="[CN]In Schatzstadt geht man wieder\n[CN]fröhlich seinem Alltag nach...", italian="[CN]Borgo Tesoro ritorna alle\n[CN]sue allegre abitudini...", spanish="[CN]Aldea Tesoro volvió\n[CN]a su despreocupada rutina..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]the scars from the planet's\n[CN]injuries slowly healed...", french="[CN]... lentement mais sûrement, la planète\n[CN]pansa ses blessures...", german="[CN]Die Wunden des verletzten\n[CN]Planeten heilen allmählich...", italian="[CN]Le cicatrici delle ferite inflitte\n[CN]al pianeta lentamente guariscono...", spanish="[CN]Las heridas que había sufrido\n[CN]el planeta fueron cicatrizando..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]and life gradually returned to normal...", french="[CN]... et la vie reprit progressivement\n[CN]son cours normal...", german="[CN]Das Leben kehrt langsam\n[CN]zur Normalität zurück...", italian="[CN]E la vita torna gradualmente\n[CN]alla normalità...", spanish="[CN]Y la vida volvió poco a poco a la normalidad..."})
  -- message_Close
  SkySceneKit.join_routines()
end
