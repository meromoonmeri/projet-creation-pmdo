-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P31A/n09a1202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D52P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GAME:MoveCamera(252, 268, 60, false) end) -- performer/caméra
  GAME:FadeIn(30)
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(hero, 228, 260, false, 2)
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 280, 400, Direction.Up, "NPC_YONOWAARU_N9")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 276, 288, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is...", french=" C'est...", german=" Das ist...", italian=" Questa è...", spanish=" Esto es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="It looks like the deepest part of\nthis ice-covered forest.", french="... le fin fond de cette forêt\ncouverte de neige.", german="Das sieht aus wie der tiefste\nTeil dieses eisbedeckten Waldes.", italian="Sembra la parte più profonda\ndi questo bosco coperto di ghiaccio.", spanish="Parece la parte más profunda\nde este bosque helado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Over there...[K] I can see a\nremarkably large ice pillar...", french="Là-bas...[K] un gigantesque pilier\nde glace...", german="Dort drüben...[K] Dort kann ich eine\nbemerkenswert große Eissäule erkennen...", italian="Laggiù...[K] scorgo un'enorme\ncolonna di ghiaccio...", spanish="Ahí delante...[K] veo un pilar de hielo\nparticularmente grande."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's a mysterious feeling\nin the air...[K] Is that...", french="Le mystère flotte dans l'air...[K]\nSerait-ce...", german="Ich habe da ein merkwürdiges\nGefühl...[K] Ist das...", italian="C'è una strana atmosfera\nin questo posto...[K] Non sarà che...", spanish="Hay una sensación misteriosa\nen el aire...[K] ¿Será...?"})
  -- message_Close
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Egad![K] [CS:Y]Grovyle[CR], look!", french=" Bon sang![K] [CS:Y]Massko[CR], regarde!", german=" Oh nein![K] [CS:Y]Reptain[CR], dort!", italian=" Oh![K] [CS:Y]Grovyle[CR], guarda!", spanish=" ¡Atiza![K] ¡[CS:Y]Grovyle[CR], mira!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Over there...[K] Just past those\nfour huge pillars...[K] Can you see anything?", french="Là-bas...[K] entre ces quatre\npiliers colossaux...[K] Tu vois quelque chose?", german="Dort drüben...[K] Genau hinter den\nvier riesigen Säulen...[K] Kannst du das sehen?", italian="Laggiù...[K] Al di là di quelle\nquattro enormi colonne...[K] Lo vedi?", spanish="Ahí delante...[K] Más allá de esas\ncuatro columnas enormes...[K] ¿No lo ves?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yes! I can!", french=" Oui! Je vois!", german=" Ja! Kann ich!", italian=" Sì! Lo vedo!", spanish=" ¡Sí! ¡Lo veo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Looks like someone's lying there\nunconscious...", french=" Quelqu'un gît sans connaissance...", german="Sieht fast so aus, als ob\njemand ohnmächtig am Boden liegt...", italian="Sembra che ci sia qualcuno\nprivo di sensi...", spanish="Parece que allí hay alguien\ninconsciente..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru_n9, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Come on!", french=" Allons-y!", german=" Komm schon!", italian=" Forza, andiamo!", spanish=" ¡Vamos!"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_yonowaaru_n9.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n9, p.X+(0), p.Y+(-160), false, 2) end
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
