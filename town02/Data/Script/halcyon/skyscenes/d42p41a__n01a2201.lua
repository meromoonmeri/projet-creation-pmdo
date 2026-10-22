-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P41A/n01a2201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(125, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D42P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ONE_FOR_ALL_ALL_FOR_ONE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 252, 292, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" All right![K] It's not over yet!", french="Très bien![K]\nOn va voir c'qu'on va voir!", german="Alles klar![K]\nEs ist noch nicht vorbei!", italian=" Forza![K] Non è ancora finita!", spanish=" ¡Venga![K] ¡Esto no se acaba aquí!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 192, 248, Direction.DownRight, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="These guys are exceptionally\nstubborn. Hey, hey!", french="Saperlipopince! Ces types sont\ndu genre coriace!", german="Diese Typen sind unglaublich\nzäh. Hey, hey!", italian="Questi tipi sono davvero degli\nossi duri. Ehi, ehi!", spanish="Oye, estos tipos son muy duros\nde mollera."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 216, 216, Direction.DownRight, "NPC_DOGOOMU")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="We're HAVING a hard TIME\nwith THEM.", french="ILS nous DONNENT du FIL\nà RETORDRE!", german="DIE sind GANZ schön\nANSTRENGEND.", italian="Ce la STIAMO vedendo BRUTTA\ncontro di LORO.", spanish=" Nos lo están poniendo difícil."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 320, 248, Direction.DownLeft, "NPC_KIMAWARI")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" But![K] We won't lose!", french="Mais zut![K]\nOn ne va pas se laisser faire comme ça!", german="Aber![K]\nWir werden nicht verlieren!", italian=" Ma![K] Non perderemo!", spanish=" Pero...[K] ¡No podemos perder!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Got it! Yup yup!", french=" Bien reçu! Ouaip ouaip!", german=" Verstanden! Jawollja!", italian=" Nossignore! Già, già!", spanish=" ¡Estoy de acuerdo, sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I'm there, I think it'll cause\nmore trouble if I help...", french="J'vais p'tête vous apporter plus\nd'ennuis qu'autre chose en restant\nà vos côtés...", german="Vielleicht verwirrt es nur,\nwenn ich mich da jetzt einmische...", italian="Forse la mia presenza sarà più\nd'intralcio che d'aiuto...", spanish="La verdad es que creo que si\nayudo no haré más que estorbar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] I should try my best\nand help fight!", french="Mais...[K] faut que j'donne tout\nc'que j'ai pour vous aider à les battre!", german="Aber...[K] Ich sollte mein Bestes\ngeben und mithelfen!", italian="Però...[K] devo unirmi alla lotta\ne fare del mio meglio!", spanish="Pero...[K] debería ir a por todas\ny ayudar en el combate."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 256, 256, Direction.Down, "NPC_YUKIKABURI")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english="Humph...[K] Even if you join in,\nnothing will change!", french="Humph...[K] Tu peux bien te joindre\nà eux, si ça t'amuse. Ça ne changera\nrien du tout.", german="Grmpf...[K] Auch wenn du\nmitmachst, wird das gar nichts ändern!", italian="Bah...[K] Anche se ti unisci a loro,\nnon cambierà nulla!", spanish="¡Ja![K] Por mucho que te unas\na ellos, no supondrá ninguna diferencia."})
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Let's go!", french=" A l'attaque!", german=" Los geht's!", italian=" Andiamo!", spanish=" ¡Vamos!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(125, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
