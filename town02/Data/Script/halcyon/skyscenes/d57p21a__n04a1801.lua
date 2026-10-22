-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P21A/n04a1801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K] What's going on?\nWhat's happening?!", french="Ben mince alors![K] C'est quoi,\ncette histoire? J'ai fait un truc de travers?", german="Auweia![K] Was ist los?\nWarum passiert mir so was?", italian="Shock![K] Ma cosa...?\nCom'è successo?", spanish="¡Ostras![K] ¿Pero qué pasa?\n¿Por qué tiene que ocurrir esto?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyway, I'll just have to try\nagain![K] Oh my gosh!", french="Pas grave, je vais réessayer![K]\nBen mince alors!", german="Wie auch immer, ich muss\nes noch einmal versuchen![K] Auweia!", italian="Non importa, devo riprovarci![K]\nShock!", spanish="En fin, pues tendré que volver\na intentarlo.[K] ¡Pero qué fuerte!"})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D57P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(27) [anim idle native]
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Spring Cave Depths.ogg", true) end)
  GAME:WaitFrames(30)
  -- SetAnimation(30) [anim idle native]
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...[K] I couldn't do it...", french=" Ouille...[K] Je n'ai pas réussi...", german=" Uuuff...[K] Das war wohl nix...", italian=" Aaargh...[K] Non ce l'ho fatta...", spanish=" Uf...[K] Pues no me ha salido bien..."})
  -- message_Close
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But--[K]I've already come this far!", french="Mais... [K]avec tout ce chemin\nque j'ai déjà parcouru!", german=" Aber...[K] Ich bin schon so weit!", italian="Però...[K] sono arrivata fin qui\ne non mi arrenderò!", spanish=" Pero...[K] si he llegado hasta aquí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'll definitely catch [CS:N]Haunter[CR] and\nbring him back!", french="Je vais l'attraper, ce [CS:N]Spectrum[CR],\net je le ramènerai à la Guilde!", german="Ich werde [CS:N]Alpollo[CR] auf jeden Fall\nfangen und zurückbringen!", italian="Catturerò assolutamente [CS:N]Haunter[CR]\ne lo riporterò indietro con me!", spanish="¡Pienso capturar a [CS:N]Haunter[CR] y\nponerlo a disposición de las autoridades!"})
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
end
