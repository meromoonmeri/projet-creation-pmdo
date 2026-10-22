-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/n06a1601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 248, 248, Direction.Down, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Looks like we didn't do\nso well.", french="Hum...[K] Ce n'était pas\nune franche réussite.", german="Hmm...[K] Sieht fast so aus, als\nwären wir nicht gut genug gewesen.", italian="Mmmh...[K] A quanto pare non\nè andata molto bene.", spanish="Hum...[K] Parece que\nno nos ha ido demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We'll do better\nnext time. [M:H8]", french="On fera mieux la\nprochaine fois. [M:H8]", german="Beim nächsten Mal machen wir\ndas besser. [M:H8]", italian="Faremo meglio la prossima\nvolta. [M:H8]", spanish="Lo haremos mejor la próxima\nvez. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 312, 248, Direction.Down, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Anyway, let's head back for a\nlittle while.", french=" Faisons une petite pause.", german="Wir sollten uns auf den\nRückweg begeben und für eine Weile ausruhen.", italian="Comunque non dobbiamo perdere\nla speranza.", spanish=" En fin, volvamos."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D55P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Boulder Quarry.ogg", true) end)
  GAME:WaitFrames(30)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(9)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="...[K]Looks like we're right back\nhere again...", french="...[K] Nous voilà revenues au point\nde départ...", german="...[K]Sieht fast so aus, als wären\nwir nicht gut genug gewesen.", italian="...[K] A quanto pare siamo tornate\nindietro...", spanish="Pues...[K] Parece que volvemos\na estar aquí..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I said we shouldn't be\nimpatient earlier...", french="D'accord, la précipitation ne\nmène à rien...", german="Ich habe vorhin gesagt, dass\nwir nicht ungeduldig sein sollten...", italian="Prima ho detto che non dobbiamo\nfarci prendere dalla fretta...", spanish="Ya os dije antes que ser\nimpacientes no nos iba a llevar lejos..."})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="But we just can't take our\ntime, either.", french="... mais il ne s'agirait pas\nde traîner, non plus.", german="Aber wir können uns auch nicht\newig Zeit lassen.", italian="Ma ora non possiamo nemmeno\nperdere tutto questo tempo.", spanish="Pero tampoco podemos\ndormirnos en los laureles."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="I'm worried about how far\nTeam [CS:X]AWD[CR] has gotten...", french="Je me demande où en est\nl'Equipe [CS:X]DDA[CR]...", german="Ich frage mich, wie weit\nTeam [CS:X]SPA[CR] bereits ist...", italian="Ho paura che il Team [CS:X]AWD[CR]\nci abbia superate...", spanish="Me preocupa no saber hasta\ndónde habrá llegado el [CS:X]Equipo WAD[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's true.[K] We should hurry up\na little.", french="Il faut les rattraper.[K]\nAccélérons.", german="Das stimmt.[K] Wir sollten uns ein\nwenig beeilen.", italian=" È vero.[K] Dovremmo sbrigarci.", spanish="A mí también.[K] Deberíamos\nir un poquito más rápido."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Once you're ready, let's head out.", french="Faisons nos préparatifs\net partons.", german="Sobald ihr fertig seid, können\nwir los.", italian=" Quando siamo pronte, andiamo.", spanish=" Cuando estéis listas, nos vamos."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
