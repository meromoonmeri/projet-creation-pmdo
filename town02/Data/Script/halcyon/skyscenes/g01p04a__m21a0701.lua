-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m21a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 328, 216, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmmm...[K] So [CS:N]Torkoal[CR] couldn't\nprovide us with many answers.", french="Hmmm...[K] Bon, [CS:N]Chartor[CR]\nne nous a pas fourni beaucoup de réponses.", german="Hmmm...[K] [CS:N]Qurtel[CR] konnte uns nicht\nviele Antworten geben.", italian="Mmm...[K] Alla fine [CS:N]Torkoal[CR] non\nè riuscito a darci molte risposte.", spanish="Hum...[K] [CS:N]Torkoal[CR] no ha podido\nofrecernos muchas respuestas."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" That's too bad...", french=" Quel dommage...", german=" Das ist schade...", italian=" Così non va...", spanish=" Es una pena..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 352, 224, Direction.DownLeft, "NPC_PUKURIN")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_pukurin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin, 4) end)
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh! That's not entirely true!", french="Oh, mais ça n'est pas tout à fait\nvrai!", german=" Oh! Das stimmt nicht ganz!", italian=" Oh! Non è proprio così!", spanish=" Bueno, tampoco ha ido tan mal."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="We know that we need proof!\nAnd knowing that is a step forward! ♪", french="Nous savons maintenant qu'il\nnous faut une preuve! C'est déjà ça! ♪", german="Wir wissen, dass wir einen\nNachweis brauchen! Und das zu wissen, ist\nein Fortschritt! ♪", italian="Sappiamo che ci serve una\nprova! E questo è già un passo avanti! ♪", spanish="Ahora sabemos que hace falta\npasar una prueba. ¡Ya es un avance! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Right? ♪", french=" Pas vrai? ♪", german=" Richtig? ♪", italian=" Giusto? ♪", spanish=" ¿Verdad? ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 232, Direction.DownLeft, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! We're searching too...", french="Eh dis donc! On cherche nous\naussi...", german="Hey, hey! Wir suchen auch\ngerade...", italian="Ehi, ehi! Anche noi stiamo\ncercando...", spanish="¡Oye, oye!\nNosotros también hemos estado buscando..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpLeft)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 288, 224, Direction.DownRight, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_dogoomu, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Yeah, but we didn't find anything.", french=" Ouais, mais on n'a rien trouvé.", german="Jaaa, aber wir haben nichts\ngefunden.", italian="Sì, ma non abbiamo scoperto\nnulla.", spanish="Sí, pero no hemos encontrado\nnada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 344, 272, Direction.Up, "NPC_BIPPA")
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_bippa, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="But...[K]there's no giving up!\nWe have to keep trying, by golly!", french="Pourtant...[K] impossible\nd'abandonner! Faut persévérer, pardi!", german="Aufgegeben wird nicht![K]\nWir müssen es weiter versuchen,\nDonnerwetter!", italian="Ma...[K] non dobbiamo mollare!\nDobbiamo continuare a cercare, ohibò!", spanish="Aun así...[K] no hay que rendirse.\n¡Vamos a seguir intentándolo! ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 376, 248, Direction.Left, "NPC_DIGUDA")
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diguda, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_diguda, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" I'll keep trying too!", french=" Moi aussi je vais persévérer!", german=" Ich versuche es auch weiterhin!", italian=" Anch'io continuerò a cercare!", spanish=" ¡Yo también lo haré!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 368, 272, Direction.UpLeft, "NPC_KIMAWARI")
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(partner, Direction.DownRight)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We should have dinner and rest\nup for the night.", french="On devrait manger et aller se\nreposer pour la nuit.", german="Wir sollten zu Abend essen und\nuns die Nacht über ausruhen.", italian="Per oggi penso che possiamo\ncenare e andare a riposarci.", spanish="Ahora deberíamos cenar y\ndescansar hasta mañana."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="We'll resume our efforts\ntomorrow!", french=" On s'y remettra demain!", german=" Wir machen morgen weiter!", italian=" Domani ci rimetteremo all'opera!", spanish="Reanudaremos la búsqueda\nentonces."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, well... Thanks, everyone!", french=" Eh bien... merci, tout le monde!", german=" Na gut! Danke, Leute!", italian=" Oh, bene... Grazie a tutti!", spanish=" De acuerdo... ¡Gracias a todos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, well... Thanks, everyone!", french=" Eh bien... merci, tout le monde!", german=" Na gut! Danke, Leute!", italian=" Oh, bene... Grazie a tutti!", spanish=" Ah, bueno... ¡Gracias a todos!"})
  else
  SkySceneKit.say({english=" Oh, well... Thanks, everyone!", french=" Eh bien... merci, tout le monde!", german=" Na gut! Danke, Leute!", italian=" Oh, bene... Grazie a tutti!", spanish=" Ah, bueno... ¡Gracias a todos!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
end
