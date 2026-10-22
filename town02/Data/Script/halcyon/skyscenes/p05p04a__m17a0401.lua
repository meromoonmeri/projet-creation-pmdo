-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P04A/m17a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7193) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(90)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 128, 176, Direction.Right, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Come on! This way![K] We need to\nkeep running until we hit the exit!", french="Par là, vite![K] On ne peut pas\ns'arrêter tant qu'on n'a pas trouvé la sortie!", german="Kommt! Hier entlang![K] Wir\nmüssen weiterlaufen, bis wir den Ausgang\nerreichen!", italian="Forza! Da questa parte![K]\nDobbiamo continuare a correre finché non\ntroviamo l'uscita!", spanish="¡Vamos! ¡Por aquí![K]\n¡Tenemos que correr sin parar hasta la salida!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Come on! Faster! Pick it up!", french=" Allez! Plus vite! Du nerf!", german=" Kommt! Schneller! Macht schon!", italian="Coraggio! Più in fretta!\nAndiamocene!", spanish=" ¡Vamos! ¡Más rápido! ¡Apuraos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is the fastest I can go!", french=" Je fais aussi vite que je peux!", german=" Ich kann nicht schneller!", italian=" Più in fretta di così non posso!", spanish=" ¡No puedo ir más rápido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is the fastest I can go!", french=" Je fais aussi vite que je peux!", german=" Ich kann nicht schneller!", italian=" Più in fretta di così non posso!", spanish=" ¡No puedo ir más rápido!"})
  else
  SkySceneKit.say({english=" I'm running as fast as I can!", french=" Je fais aussi vite que je peux!", german=" Ich laufe, so schnell ich kann!", italian="Sto correndo più veloce che\nposso!", spanish=" ¡No puedo ir más rápido!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Quit ordering me around!", french=" Et je ne suis pas à tes ordres!", german="Hör auf, mich\nherumzukommandieren!", italian=" Smettila di darmi ordini!", spanish=" ¡Deja de darme órdenes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Quit ordering me around!", french=" Et je ne suis pas à tes ordres!", german="Hör auf, mich\nherumzukommandieren!", italian=" Smettila di darmi ordini!", spanish=" ¡Deja de darme órdenes!"})
  else
  SkySceneKit.say({english=" Don't order me around!", french=" Et je ne suis pas à tes ordres!", german="Hör auf, mich\nherumzukommandieren!", italian=" Smettila di darmi ordini!", spanish=" ¡Deja de darme órdenes!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Anyway, [CS:N]Grovyle[CR]...!", french=" Au fait, [CS:N]Massko[CR]...!", german=" Wie auch immer, [CS:N]Reptain[CR]!", italian=" Ad ogni modo, [CS:N]Grovyle[CR]...!", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Anyway, [CS:N]Grovyle[CR]...!", french=" Au fait, [CS:N]Massko[CR]...!", german=" Wie auch immer, [CS:N]Reptain[CR]!", italian=" Ad ogni modo, [CS:N]Grovyle[CR]...!", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  else
  SkySceneKit.say({english=" Anyway, [CS:N]Grovyle[CR]...!", french=" Au fait, [CS:N]Massko[CR]...!", german=" Wie auch immer, [CS:N]Reptain[CR]!", italian=" Ad ogni modo, [CS:N]Grovyle[CR]...!", spanish=" Oye, [CS:N]Grovyle[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Is this...[K]the future?", french=" Est-ce qu'on est...[K] dans le futur?", german=" Ist das hier...[K] die Zukunft?", italian=" Questo è...[K] il futuro?", spanish=" ¿Esto es...?[K] ¿Esto es el futuro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Is this...[K]the future?", french=" Est-ce qu'on est...[K] dans le futur?", german=" Ist das hier...[K] die Zukunft?", italian=" Questo è...[K] il futuro?", spanish=" ¿Esto es...?[K] ¿Esto es el futuro?"})
  else
  SkySceneKit.say({english=" Is this...[K]the future?", french=" Est-ce qu'on est...[K] dans le futur?", german=" Ist das hier...[K] die Zukunft?", italian=" Questo è...[K] il futuro?", spanish=" ¿Esto es...?[K] ¿Esto es el futuro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" That's right.[K] You catch on fast.", french=" C'est exact.[K] Tu comprends vite.", german=" So ist es.[K] Du schaltest schnell.", italian="Proprio così.[K] Afferri le cose in\nfretta.", spanish=" Así es.[K] Vaya, qué sagaz."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk! So it is, after all...", french="Argh! Alors on y est bel et\nbien...", german=" Urk! Also tatsächlich...", italian=" Ah! È così, dopotutto...", spanish=" ¡Glup! O sea, que sí lo es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk! So it is, after all...", french="Argh! Alors on y est bel et\nbien...", german=" Urk! Also tatsächlich...", italian=" Ah! È così, dopotutto...", spanish=" ¡Glup! Así que sí lo es..."})
  else
  SkySceneKit.say({english=" Urk! So it is, after all...", french="Argh! Alors on y est bel et\nbien...", german=" Urk! Also tatsächlich...", italian=" Ah! È così, dopotutto...", spanish=" ¡Glup! O sea, que sí lo es..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Are we...[K] Are we going to be\nable to get back to our world?", french="Est-ce qu'on...[K] est-ce qu'on\npourra rentrer chez nous?", german="Werden wir...[K] Werden wir in\nunsere Welt zurückkehren können?", italian="Noi...[K] riusciremo a ritornare\nnel presente?", spanish="¿Y vamos...?[K]\n¿Vamos a poder regresar a nuestro mundo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Are we...[K] Are we going to be\nable to get back to our world?", french="Est-ce qu'on...[K] est-ce qu'on\npourra rentrer chez nous?", german="Werden wir...[K] Werden wir in\nunsere Welt zurückkehren können?", italian="Noi...[K] riusciremo a ritornare\nnel presente?", spanish="¿Y vamos...?[K]\n¿Vamos a poder regresar a nuestro mundo?"})
  else
  SkySceneKit.say({english="Are we...[K] Are we going to be\nable to get back to our world?", french="Est-ce qu'on...[K] est-ce qu'on\npourra rentrer chez nous?", german="Werden wir...[K] Werden wir in\nunsere Welt zurückkehren können?", italian="Noi...[K] riusciremo a ritornare\nnel presente?", spanish="¿Y vamos...?[K]\n¿Vamos a poder regresar a nuestro mundo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Who knows?[K] We just need to get\naway for now.", french="Qui sait?[K] La priorité pour\nl'instant, c'est de sortir de là.", german="Wer weiß?[K] Wir müssen fürs\nErste einfach weg von hier.", italian="Chi lo sa?[K] Per ora pensiamo a\nscappare.", spanish="Quién sabe...[K]\nDe momento tenemos que salir de aquí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="If we get caught, returning home\nwill be the least of your worries.[K] Run faster!", french="S'ils nous rattrapent, rentrer\nchez vous sera le cadet de vos soucis.[K]\nAccélérez!", german="Wenn sie uns fangen, wird es\neure geringste Sorge sein, wie wir\nzurückkommen.[K] Lauft schneller!", italian="Se ci prendono, ritornare a casa\ndiventerà l'ultimo dei vostri problemi.[K]\nSbrighiamoci!", spanish="Si nos atrapan, volver a casa\nserá lo que menos te importe.[K]\n¡Corred más rápido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I can't![K] I'm exhausted...[K]\nHuff-huff...", french="Impossible![K] Je suis épuisé...[K]\nPff, pff...", german="Ich kann nicht![K] Ich bin fix und\nfertig...[K] Keuch, keuch...", italian="Non ce la faccio![K] Sono\nesausto...[K] Pant-pant...", spanish="No puedo...[K] Estoy agotado...[K]\nUf... Puf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I can't![K] I'm exhausted...[K]\nHuff-huff...", french="Impossible![K] Je suis épuisé...[K]\nPff, pff...", german="Ich kann nicht![K] Ich bin fix und\nfertig...[K] Keuch, keuch...", italian="Non ce la faccio![K] Sono\nesausto...[K] Pant-pant...", spanish="No puedo...[K] Estoy agotado...[K]\nUf... Puf..."})
  else
  SkySceneKit.say({english="I can't![K] I'm exhausted...[K]\nHuff-huff...", french="Impossible![K] Je suis épuisée...[K]\nPff, pff...", german="Ich kann nicht![K] Ich bin fix und\nfertig...[K] Keuch, keuch...", italian="Non ce la faccio![K] Sono\nesausta...[K] Pant-pant...", spanish="No puedo...[K] Estoy agotada...[K]\nUf... Puf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="We're almost there![K]\nLook! The exit is right there!", french="Nous y sommes presque![K]\nRegardez! La sortie est juste là!", german="Wir sind fast da![K]\nSeht! Der Ausgang ist gleich da!", italian="Ci siamo quasi![K] Guardate!\nL'uscita è proprio lì!", spanish="¡Ya casi estamos![K]\n¡Mirad! ¡La salida está allí mismo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  else
  SkySceneKit.say({english=" Huff-huff...[K] Huff-huff...", french=" Pff, pff...[K] Pff, pff...", german=" Keuch, keuch...[K] Keuch, keuch...", italian=" Uff-uff...[K] Uff-uff...", spanish=" Uf... Puf...[K] Uf... Puf..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We did it![K] We're...[K]outside!", french=" On a réussi![K] On est...[K] dehors!", german=" Geschafft![K] Wir sind...[K] draußen!", italian="Ce l'abbiamo fatta![K] Siamo...[K]\nfuori!", spanish="¡Lo logramos![K]\nEstamos...[K] ¡en el exterior!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We did it![K] We're...[K]outside!", french=" On a réussi![K] On est...[K] dehors!", german=" Geschafft![K] Wir sind...[K] draußen!", italian="Ce l'abbiamo fatta![K] Siamo...[K]\nfuori!", spanish="¡Lo logramos![K]\nEstamos...[K] ¡en el exterior!"})
  else
  SkySceneKit.say({english=" We did it![K] We're...[K]outside!", french=" On a réussi![K] On est...[K] dehors!", german=" Geschafft![K] Wir sind...[K] draußen!", italian="Ce l'abbiamo fatta![K] Siamo...[K]\nfuori!", spanish="¡Lo logramos![K]\nEstamos...[K] ¡en el exterior!"})
  end
  -- message_Close
  -- se_FadeOut(7193, 30) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7187) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(60)
  -- back_SetGround(LEVEL_P05P04A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(npc_npc_juputoru, 272, 172, false, 2)
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(32), p.Y+(0), false, 2) end
  GAME:WaitFrames(20)
  -- supervision_Acting(3) [neutre/état moteur]
  GAME:WaitFrames(1)
  GROUND:MoveToPosition(partner, 200, 172, false, 2)
  GROUND:MoveToPosition(hero, 236, 188, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wah! What...[K]what is this?!", french=" Ouah! Que...[K] qu'est-ce que c'est?!", german=" Wah! Was...[K] ist das?!?", italian="Aah! Che...[K] Che cos'è tutto\nquesto?!", spanish=" ¡Aah! ¿Qué?[K] ¡¿Qué es esto?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wah! What...[K]what is this?!", french=" Ouah! Que...[K] qu'est-ce que c'est?!", german=" Wah! Was...[K] ist das?!?", italian="Aah! Che...[K] Che cos'è tutto\nquesto?!", spanish=" ¡Aah! ¿Qué?[K] ¡¿Qué es esto?!"})
  else
  SkySceneKit.say({english=" Wah! What...[K]what is this?!", french=" Ouah! Que...[K] qu'est-ce que c'est?!", german=" Wah! Was...[K] ist das?!?", italian="Aah! Che...[K] Che cos'è tutto\nquesto?!", spanish=" ¡Aah! ¿Qué?[K] ¡¿Qué es esto?!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
