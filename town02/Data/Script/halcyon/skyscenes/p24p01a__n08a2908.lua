-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P24P01A/n08a2908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="All right![K] We made it through\nthe dungeon!", french="Parfait![K] Nous sommes\nsortis du donjon sains et saufs!", german="Alles klar![K] Wir haben es durch\nden Dungeon geschafft!", italian="Bene![K] Siamo riusciti a\nraggiungere la fine del dungeon!", spanish="¡Menos mal![K] ¡Hemos atravesado\nel territorio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P24P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 248, 316, false, 2)
  GAME:WaitFrames(5)
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 208, 208, Direction.Down, "NPC_YONOWAARU_N8")
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 208, 316, false, 2)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_porigon2 = SkySceneKit.spawn_npc("porygon", 208, 368, Direction.Up, "NPC_PORIGON2")
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon2, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  local npc_npc_porigon = SkySceneKit.spawn_npc("porygon", 248, 368, Direction.Up, "NPC_PORIGON")
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon2, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english=" Waah!", french=" Aaaah!", german=" Waaah!", italian=" Uaaah!", spanish=" ¡Aaah!"})
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english=" M...[K]Master [CS:N]Dusknoir[CR]!", french=" M...[K] Maître [CS:N]Noctunoir[CR]!", german=" M-[K]meister [CS:N]Zwirrfinst[CR]!", italian=" M-[K]Maestro [CS:N]Dusknoir[CR]!", spanish=" ¿Eh?...[K] ¡[CS:N]Dusknoir[CR]!"})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's been a while.", french=" Cela faisait bien longtemps.", german=" Es ist eine Weile her.", italian=" Ne è passato di tempo.", spanish=" Cuánto tiempo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(8), false, 1) end
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 228, 344, false, 1)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(0, -4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The reason I've come here...", french=" La raison de ma présence ici...", german="Weshalb ich\nhierhergekommen bin...", italian=" Il motivo per cui sono qui...", spanish=" La razón por la que he venido..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I bet you can guess at what I\nam going to request?", french="... vous la connaissez, n'est-ce\npas? Vous savez ce que je m'apprête\nà vous demander.", german="Ich nehme an, ihr könnt euch\ndenken, was ich von euch möchte?", italian="Credo che sappiate già cosa ho\nintenzione di chiedervi...", spanish="Bueno, supongo que ya\nsupondréis lo que voy a pediros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_porigon, Direction.Left)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_porigon2, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon, "sweating", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon2, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_porigon, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_porigon2, Direction.Up)
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english="Th-that's...[K]difficult.[K] We're\nbeing held back by [CS:N]Sableye[CR]...", french="C'est...[K] compliqué.[K]\nLes [CS:N]Ténéfix[CR] nous entravent...", german="D-das ist...[K] schwierig.[K]\nDie [CS:N]Zobiris[CR] haben uns in ihrer Gewalt...", italian="N-Non...[K] possiamo.[K] I [CS:N]Sableye[CR]\nci hanno minacciati...", spanish="Eso es...[K] complicado.[K] Los\n[CS:N]Sableye[CR] nos han dicho que no..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english="And...[K] Behind you, Master\n[CS:N]Dusknoir[CR] is...", french="Et...[K] Maître [CS:N]Noctunoir[CR],\njuste derrière vous...", german="Und...[K] Hinter euch,\nMeister [CS:N]Zwirrfinst[CR]...", italian="E poi...[K] dietro di lei, maestro\n[CS:N]Dusknoir[CR], c'è...", spanish="Y...[K] quien viene contigo,\n[CS:N]Dusknoir[CR], es..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Are you saying you won't listen\nto me?!", french="Quelle impudence! Oseriez-vous\ndésobéir?", german="Ihr wollt mir also tatsächlich\nden Gehorsam verweigern?!?", italian="Avete forse intenzione\ndi disobbedirmi?!", spanish="¡¿Me estás diciendo que no vais\na hacerme caso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon2, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_porigon, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english=" Wawawawawa!", french=" Aaaaaaaah!", german=" Wawawawawa!", italian=" Uauauauaua!", spanish=" ¡No, no, no, no!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english="We'll do it! We'll do it![K]\nTh-this way, please!", french="A vos ordres! A vos ordres![K]\nPar ici, s'il vous plaît!", german="Wir machen es! Wir machen es![K]\nH-hier entlang, bitte!", italian="D'accordo! Lo faremo![K]\nD-Da questa parte, prego!", spanish="¡Lo haremos! ¡Lo haremos![K]\n¡Venid por aquí!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  do local p=npc_npc_porigon.Position; GROUND:MoveToPosition(npc_npc_porigon, p.X+(32), p.Y+(0), false, 2) end
  GAME:WaitFrames(4)
  do local p=npc_npc_porigon2.Position; GROUND:MoveToPosition(npc_npc_porigon2, p.X+(-32), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_porigon, Direction.Left)
  GROUND:EntTurn(npc_npc_porigon2, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GAME:MoveCamera(228, 376, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 212, 368, false, 2)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(hero, 248, 368, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english="Well then...[K] We'll transmit you\nto [CS:P]Frozen Island[CR].", french="Bien...[K] Nous allons vous\ntéléporter sur l'[CS:P]Ile de Glace[CR].", german="Nun gut...[K] Wir werden euch zur\n[CS:P]Frostinsel[CR] transportieren.", italian="Bene...[K] Vi trasporteremo\nsull'[CS:P]Isola Glaciale[CR].", spanish="Muy bien...[K] Os enviaremos\na la [CS:P]Isla Helada[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_porigon) end)
  SkySceneKit.say({english=" Don't move.", french=" Ne bougez pas.", german=" Nicht bewegen.", italian=" Non muovetevi.", spanish=" No os mováis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- GAP: se_Play(10501) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(30)
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P24P01A1_420) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P24P01A1_421) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
