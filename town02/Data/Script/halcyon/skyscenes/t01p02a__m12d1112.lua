-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m12d1112.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetWeather(9) [météo visuelle ground NDS - documenté]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="My partner here just happened\nto see it in a dream.", french="En fait, mon acolyte l'a\nsimplement vu en rêve.", german="Mein Partner hat es zufällig in\neinem Traum gesehen.", italian="Il mio amico Pokémon ha avuto\nuna visione.", spanish="Mi acompañante lo vio en\nun sueño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="My partner here just happened\nto see it in a dream.", french="En fait, mon acolyte l'a\nsimplement vu en rêve.", german="Mein Partner hat es zufällig in\neinem Traum gesehen.", italian="Il mio amico Pokémon ha avuto\nuna visione.", spanish="Mi acompañante lo vio en\nun sueño."})
  else
  SkySceneKit.say({english="My partner here just happened\nto see it in a dream.", french="En fait, mon acolyte l'a\nsimplement vu en rêve.", german="Mein Partner hat es zufällig in\neinem Traum gesehen.", italian="Il mio amico Pokémon ha avuto\nuna visione.", spanish="Mi acompañante lo vio en\nun sueño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 328, 248, Direction.Up, "NPC_YONOWAARU")
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Excuse me?[K] A dream, you say?", french="Excusez-moi?[K] En rêve,\ndites-vous?", german="Wie bitte?[K] In einem Traum,\nsagst du?", italian=" Mmm...[K] Visione, dici?", spanish=" ¿Cómo dices?[K] ¿En un sueño?"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" By dream, what do you mean?", french=" Qu'entendez-vous par \\\"rêve\\\"?", german=" Was meinst du mit Traum?", italian=" Che tipo di visione?", spanish="¿Qué quieres decir con eso\nde un sueño?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]When they mentioned the Dimensional\n[CN]Scream, I was skeptical at first...", french="[CN]Lorsqu'ils ont évoqué le Cri Dimensionnel\n[CN]pour la première fois, j'étais sceptique...", german="[CN]Als sie den Dimensionalen Schrei erwähnten,\n[CN]war ich noch skeptisch...", italian="[CN]Quando per la prima volta mi parlarono dello\n[CN]Squarcio Dimensionale, ero molto scettico...", spanish="[CN]Cuando hablaron de la Percepción de Cronos,\n[CN]al principio fui escéptico."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]But then an idea began to\n[CN]take shape in my mind...", french="[CN]Mais ensuite une idée a pris\n[CN]forme dans mon esprit...", german="[CN]Aber dann fing eine Idee an,\n[CN]in meinem Kopf Gestalt anzunehmen...", italian="[CN]Ma poi... mi venne un'idea...", spanish="[CN]Pero luego empecé a darle\n[CN]vueltas a la cabeza..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CN]And...", french="[CN]Et...", german="[CN]Und...", italian="[CN]... e...", spanish="[CN]Y..."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
end
