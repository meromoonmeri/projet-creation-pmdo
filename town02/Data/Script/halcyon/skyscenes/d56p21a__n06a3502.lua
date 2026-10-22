-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D56P21A/n06a3502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 264, 296, Direction.Left, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" .........[K]That was so close...", french=" .........[K] C'était moins une...", german=".........[K]\nDas war ganz schön knapp...", italian=" .........[K] C'è mancato poco...", spanish=" Uf...[K] Qué cerca ha estado..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D56P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 296, Direction.Down, "NPC_CHAAREMU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
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
  -- GAP: BGM BGM_DEEP_LIMESTONE_CAVERN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yeah, that's true...[K] That was a\nclose call.", french="Tu l'as dit...[K] Ce n'est pas passé\nloin.", german="Ja, stimmt...[K]\nDas wäre es fast gewesen.", italian="Sì, è vero...[K] C'è mancato\ndavvero un soffio.", spanish=" Sí, es verdad,[K] por los pelos..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="They're pretty strong, aren't\nthey...[K] Team [CS:X]AWD[CR]...", french=" Redoutable, cette Equipe [CS:X]DDA[CR]...", german="Team [CS:X]SPA[CR]...[K]\nSie sind stärker als erwartet...", italian="Quel Team [CS:X]AWD[CR]...[K]\nSono piuttosto forti, non è vero?", spanish="Son bastante fuertes, eh...[K]\nVaya con el [CS:X]Equipo WAD[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english=" Besides...", french=" Changement de sujet...", german=" Übrigens...", italian=" Comunque...", spanish=" Pero, aparte de eso..."})
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, npc_npc_saanaito, 4) end)
  GAME:WaitFrames(6)
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Why do you think the treasure\nchest was completely empty?", french="Comment expliquez-vous que\nle coffre ait été vide?", german="Warum glaubt ihr, war die\nSchatztruhe komplett leer?", italian="Secondo voi perché il forziere\nera completamente vuoto?", spanish="¿Por qué creéis que el cofre\nestaba vacío?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We should head back there\nand investigate.", french="Nous devrions y retourner pour\nmener l'enquête.", german="Wir sollten noch einmal\nzurückkehren und uns das genauer ansehen.", italian="Dovremmo tornare laggiù\ne scoprirlo.", spanish=" Deberíamos volver a investigar."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There has to be some kind\nof clue...", french=" Il y a forcément des indices...", german="Es muss da irgendeine Art\nTrick geben...", italian="Deve esserci una qualche\nspiegazione...", spanish=" Tiene que haber alguna pista..."})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Don't you think Team [CS:X]AWD[CR]\nwill still be there?", french="Mais l'Equipe [CS:X]DDA[CR] doit nous y\nattendre, vous ne croyez pas?", german="Denkt ihr nicht, dass Team [CS:X]SPA[CR]\nimmer noch dort ist?", italian="Ma il Team [CS:X]AWD[CR] sarà ancora lì,\nnon credete?", spanish="¿Pero no seguirá allí el\n[CS:X]Equipo WAD[CR]?"})
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Huh?[K] We'll worry about it when\nwe get there. ♪", french="Hein?[K] On s'en souciera en temps\nvoulu. ♪", german="Hä?[K] Das sehen wir dann\nschon. ♪", italian="Uh?[K] Ci penseremo quando\nce li ritroveremo di fronte. ♪", spanish="Hum...[K] Ya nos preocuparemos\nde eso cuando toque. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We can have our revenge,\nand everything will be\njust fine. [M:H8]", french="Nous prendrons notre revanche\net tout sera réglé. [M:H8]", german="Erst mal zahlen wir es ihnen\nheim, alles andere wird sich dann schon\nklären. [M:H8]", italian="Potremo prenderci una bella\nrivincita e tutto andrà a posto. [M:H8]", spanish="Así podremos vengarnos y todo\nhabrá salido a pedir de boca. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="That's right.[K] Let's head back into\nthe depths and see.", french="Bien dit.[K] Retournons dans\nles profondeurs pour voir.", german="Stimmt genau.[K] Lasst uns zu den\nTiefen zurückkehren. Den Rest sehen wir dann.", italian="Hai ragione.[K] Ritorniamo laggiù\ne facciamogliela vedere.", spanish="Tienes razón.[K] Pues volvamos a\nlo más profundo a ver qué pasa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Yep, got it.", french=" En avant.", german=" Alles klar, verstanden.", italian=" Sì, giusto.", spanish=" Vale, andando."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
