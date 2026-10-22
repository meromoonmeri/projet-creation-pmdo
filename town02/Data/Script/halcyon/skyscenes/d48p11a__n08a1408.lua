-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D48P11A/n08a1408.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D48P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 320, 408, Direction.Up, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Temporal Tower.ogg", true) end)
  GAME:WaitFrames(60)
  pcall(function() GAME:MoveCamera(300, 280, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 284, 284, false, 2)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 316, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="We're here.[K] This is the entrance\nto [CS:P]Temporal Tower[CR].", french="Nous y voilà.[K] L'entrée de la\n[CS:P]Tour du Temps[CR].", german="Da sind wir.[K] Dies ist der Eingang\nzum [CS:P]Zeitturm[CR].", italian="Eccoci qui.[K] Questo è l'ingresso\ndella [CS:P]Torre del Tempo[CR].", spanish="Aquí estamos.[K] Esta es la entrada\nde la [CS:P]Torre del Tiempo[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... ([CS:P]Temporal Tower[CR], huh...)", french=" ... (Hum, la [CS:P]Tour du Temps[CR]...)", german=" ...(Der [CS:P]Zeitturm[CR]...)", italian=" ... (La [CS:P]Torre del Tempo[CR], uh...)", spanish=" Ah... (La [CS:P]Torre del Tiempo[CR]...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="...! (Now that you mention it...[K]\nIn the past, [c_name:NPC_HERO_FIRST] and [c_name:NPC_PARTNER_FIRST]\nare also...)", french="...! (Maintenant que j'y pense...[K]\nDans le passé, [c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST]...", german="...(Jetzt, wo du es erwähnst...[K]\nIn der Vergangenheit sind [c_name:NPC_HERO_FIRST] und\n[c_name:NPC_PARTNER_FIRST] auch...)", italian="...! (Ora che ci penso...[K]\nNel passato, anche [c_name:NPC_HERO_FIRST]\ne [c_name:NPC_PARTNER_FIRST] stanno...)", spanish="¡Oh! (Ahora que lo dices...[K]\nEn el pasado, [c_name:NPC_HERO_FIRST] y [c_name:NPC_PARTNER_FIRST]\ntambién deben de estar...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Climbing up [CS:P]Temporal Tower[CR],\nI expect...)", french="... sont sans doute aussi en\ntrain de gravir la [CS:P]Tour du Temps[CR]...)", german="(Sie sind auch dabei, den\n[CS:P]Zeitturm[CR] zu erklimmen, hoffe ich doch...)", italian="(... scalando la [CS:P]Torre del Tempo[CR],\ncredo...)", spanish="(Subiendo por la [CS:P]Torre del Tiempo[CR],\no al menos eso espero...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="([c_name:NPC_HERO_FIRST]...[K][c_name:NPC_PARTNER_FIRST]...[K]\nDo your best...)", french="([c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...[K]\nFaites de votre mieux...)", german="([c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...[K]\nStrengt euch an...)", italian="([c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...[K]\nFate del vostro meglio...)", spanish="([c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]...[K]\nEsforzaos todo lo que podáis...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(I believe in you...[K] The rest is\nup to you.)", french="(J'ai foi en vous...[K]\nA vous de jouer.)", german="(Ich glaube an euch...[K] Den Rest\nmüsst ihr alleine schaffen.)", italian="(Ho fiducia in voi...[K] il resto è\nnelle vostre mani.)", spanish="(No dudo de que seáis capaces...[K]\nLo demás corre de vuestra cuenta.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(In this world...[K] I'll do\neverything I can!)", french="(Quant à moi...[K] je ferai tout ce\nqui est en mon pouvoir dans ce monde!)", german="(In dieser Welt...[K] werde ich\nalles geben, was ich kann!)", italian="(In questo mondo...[K] farò tutto\nciò che posso!)", spanish="(En este mundo...[K] ¡yo haré\ntodo lo que me sea posible!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Together...[K]for the future!)", french=" (Ensemble...[K] pour le futur!)", german=" (Zusammen...[K] für die Zukunft!)", italian=" (Uniti...[K] per il futuro!)", spanish=" (Juntos...[K] ¡por el futuro!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
