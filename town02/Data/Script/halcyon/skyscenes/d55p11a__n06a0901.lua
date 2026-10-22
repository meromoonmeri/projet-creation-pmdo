-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P11A/n06a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 248, 248, Direction.Down, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Looks like we didn't do\nso well.", french="Hum...[K] Ce n'était pas\nune franche réussite.", german="Hmm...[K] Sieht fast so aus, als\nwären wir nicht gut genug gewesen.", italian="Mmmh...[K] A quanto pare non\nè andata molto bene.", spanish="Hum...[K] Parece que\nno nos ha ido demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Well, it happens sometimes.[K]\nThis kind of thing. [M:H8]", french="C'est ainsi.[K] On ne peut pas\nréussir à tous les coups. [M:H8]", german="Nun gut.[K] So was passiert sogar\nden Besten. [M:H8]", italian=" Già.[K] A volte capita. [M:H8]", spanish="No pasa nada.[K] Son cosas\nque pasan. [M:H8]"})
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
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Don't be so slow!", french=" Arrêtez de lambiner!", german=" Hey, nicht ausruhen!", italian=" Diamoci una mossa!", spanish=" ¡Deprisa!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="If we don't hurry, Team [CS:X]AWD[CR]\nwill get that treasure before us!", french="Si on ne se dépêche pas, l'Equipe\n[CS:X]DDA[CR] va nous souffler le trésor!", german="Wenn wir uns nicht beeilen,\nwird Team [CS:X]SPA[CR] den Schatz vor uns erreichen!", italian="Se non ci sbrighiamo, il\nTeam [CS:X]AWD[CR] metterà le mani sul tesoro\nprima di noi!", spanish="Si no nos damos prisa, el\n[CS:X]Equipo WAD[CR] encontrará\nel tesoro antes que nosotras."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's no need to get so\nflustered like that, [CS:N]Medicham[CR].", french=" Inutile de s'énerver, [CS:N]Charmina[CR].", german="Es gibt keinen Grund,\nsich so aufzuregen, [CS:N]Meditalis[CR].", italian="Non c'è bisogno di agitarsi così,\n[CS:N]Medicham[CR].", spanish="No hace falta ponerse así,\n[CS:N]Medicham[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="That's right.[K] I don't know how\nstrong Team [CS:X]AWD[CR] is...", french="C'est vrai.[K] Nous ne savons pas\nce que vaut l'Equipe [CS:X]DDA[CR]...", german="Das stimmt.[K] Ich weiß nicht, wie\nstark Team [CS:X]SPA[CR] wirklich ist...", italian="Sono d'accordo.[K] Non so quanto\nsia forte il Team [CS:X]AWD[CR]...", spanish="Exacto.[K] No sabemos con certeza\nlo fuerte que es el [CS:X]Equipo WAD[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="It seems like this treasure is a\nreally difficult one to find...", french="Décidément, ce trésor est\nbien caché...", german="Und dieser Schatz ist allem\nAnschein nach wirklich nicht leicht zu finden.", italian="... ma pare che non sia per\nniente facile trovare questo tesoro.", spanish="Y por lo visto ese tesoro\nes superdifícil de encontrar..."})
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Don't you think that taking our\ntime and not being so impatient would be the\nbest way to explore this place?", french="Il vaut mieux prendre notre\ntemps pour fouiller cet endroit jusque dans\nses moindres recoins, tu ne crois pas?", german="Denkst du nicht, dass es für die\nErkundung hier besser ist, wenn wir uns Zeit\nlassen und alles ohne Hast untersuchen?", italian="Non pensi che il modo migliore\nper esplorare questo posto sia quello\ndi mantenere la calma ed essere pazienti?", spanish="¿No crees que la mejor forma de\nexplorar este lugar sería ir paso a paso y\ntener paciencia?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyway...[K] Once we're done\ngetting ready, we'll head out again.", french="Enfin...[K] Reprenons la route\ndès que nous serons prêtes.", german="Lasst uns...[K] auf jeden Fall\nerst aufbrechen, wenn wir fertig sind.", italian="Comunque...[K] Dopo esserci\npreparate, ci rimetteremo in cammino.", spanish="En fin...[K] Cuando estemos listas,\nnos iremos otra vez."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
