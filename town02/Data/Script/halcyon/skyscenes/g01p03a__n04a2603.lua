-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/n04a2603.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 448, 232, Direction.Down, "NPC_JIBAKOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Thank you very\nmuch! ZZZT!", french=" ZZZT! Merci beaucoup! ZZZT!", german=" ZZZT! Vielen Dank! ZZZT!", italian=" ZZZT! Grazie mille! ZZZT!", spanish=" ¡Bzz! ¡Muchas gracias! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! The outlaw [CS:N]Haunter[CR]... ", french="ZZZT! Le [CS:N]Spectrum[CR]\nhors-la-loi...", german=" ZZZT! Der Ganove [CS:N]Alpollo[CR]...", italian=" ZZZT! Il ricercato [CS:N]Haunter[CR]... ", spanish=" ¡Bzz! El malhechor [CS:N]Haunter[CR]... "})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="The Invincible [CS:N]Haunter[CR], whom\nnobody was able to capture...", french="... cet invincible [CS:N]Spectrum[CR] que\npersonne n'a jamais réussi à capturer...", german="[F:S2]Der unbesiegbare [CS:N]Alpollo[CR][F:E2], den\nniemand festnehmen konnte...", italian="L'invincibile [CS:N]Haunter[CR], che nessuno\nera mai stato in grado di catturare...", spanish="El [CS:N]Haunter[CR] invencible, al que\nnadie lograba capturar..."})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" Was finally apprehended! ZZZT!", french="... a finalement été appréhendé!\nZZZT!", german="Er wurde endlich\nverhaftet! ZZZT!", italian="... è stato finalmente\narrestato! ZZZT!", spanish=" Por fin ha sido apresado. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6418) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 408, 224, Direction.Down, "NPC_KOIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 480, 224, Direction.Down, "NPC_KOIRU2")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, "happy", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  local npc_npc_goosuto2 = SkySceneKit.spawn_npc("haunter", 448, 208, Direction.Down, "NPC_GOOSUTO2")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_goosuto2, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! It's shocking to learn\nthat it was actually three Pokémon deceiving\nus! ZZZT!", french="ZZZT! Quel choc d'apprendre\nque nous avons été bernés par trois\nPokémon! ZZZT!", german="ZZZT! Wie schockierend, dass\nes in Wirklichkeit drei Pokémon waren,\ndie uns getäuscht haben! ZZZT!", italian="ZZZT! È sorprendente scoprire\nche in realtà si trattava di uno stratagemma\nescogitato da tre Pokémon! ZZZT!", spanish="¡Bzz! ¡Menuda sorpresa,\nenterarme de que en realidad eran tres\nPokémon y nos estaban engañando! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_koiru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_koiru2, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Furthermore,[K] I'd call this\na brilliant arrest--seeing through the\ndeception! ZZZT!", french="ZZZT! En plus,[K] réussir à\ndéceler leur stratagème... quelle arrestation\nexemplaire! ZZZT!", german="ZZZT! Deswegen[K] möchte ich\ndiese Festnahme als ermittlungstechnisch\nbrillante Einzelleistung hervorheben! ZZZT!", italian="ZZZT! Devo dirlo,[K] smascherare\nun simile imbroglio e arrestare il colpevole\nnon è da tutti! ZZZT!", spanish="¡Bzz! Además...[K] Diría que\nha sido una detención de lo más brillante...\n¡Has descubierto su secreto! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" ZZZT! It was magnificent!", french="ZZZT! Un travail\nremarquable! ZZZT!", german=" ZZZT! Großartig!", italian=" ZZZT! È stato magnifico ZZZT!", spanish=" ¡Bzz! ¡Ha sido magnífico! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="It's to be expected from one of\n[CS:N]Wigglytuff[CR]'s apprentices.[K] You are all on a\ndifferent level! ZZZT!", french="ZZZT! C'était à prévoir, avec\nun apprenti de [CS:N]Grodoudou[CR].[K] Vous êtes\nvraiment d'un niveau supérieur! ZZZT!", german="Die [CS:N]Knuddeluff-Gilde[CR] hat sich\nabermals als bewährter Partner erwiesen.[K]\nDas war ein denkwürdiger Einsatz! ZZZT!", italian="ZZZT! Ma non mi sarei aspettato\nniente di meno da uno degli apprendisti di\n[CS:N]Wigglytuff[CR].[K] Siete di un altro livello! ZZZT!", spanish="¡Bzz! Era de esperar, viniendo\nde uno de los aprendices de [CS:N]Wigglytuff[CR].[K] ¡Sois\nunos fuera de serie! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 480, 248, Direction.UpLeft, "NPC_PERAPPU")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_koiru2, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Oh, you don't have to\nsay that. ♪", french=" Oh, inutile de dire ça. ♪", german=" Oh, wie schmeichelhaft. ♪", italian=" Oh, non lo dica nemmeno. ♪", spanish=" Huy, no digas eso, quita, quita. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="This praise from you is making\nus blush, Officer!", french="Vous nous faites rougir avec\ntoutes ces louanges, shérif!", german="Dieses Lob lässt uns vor Scham\nerröten, Herr Oberwachtmeister!", italian="Tutti questi complimenti\nci fanno arrossire, Commissario!", spanish="¡Con tanto elogio me vas a\nsacar los colores, agente!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(444, 276, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 384, 280, Direction.UpRight, "NPC_BIPPA")
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweatdrop", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 424, 288, Direction.Up, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "sweatdrop", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 360, 264, Direction.Right, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="... (You're not the one being\npraised. Hey, hey...)", french="... (Ces louanges ne s'adressent\npas à toi, dis donc...)", german="...(Dabei gilt das Lob gar nicht\ndir. Hey, hey...)", italian="... (Non è con te che si sta\ncomplimentando. Ehi, ehi...)", spanish="Hum... (Pero si los elogios\nno van por ti, oye...)"})
  -- message_Close
  pcall(function() GAME:MoveCamera(444, 276, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_jibakoiru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_jibakoiru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_koiru2, Direction.DownLeft)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english=" [CS:Y]Sunflora[CR].", french=" ZZZT! [CS:Y]Héliatronc[CR]. ZZZT!", german=" [CS:Y]Sonnflora[CR].", italian=" [CS:Y]Sunflora[CR].", spanish=" [CS:Y]Sunflora[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! This is a thank-you, from\nme. ZZZT!", french="ZZZT! Voici un cadeau de\nremerciement de ma part. ZZZT!", german="ZZZT! Nimm dieses Dankeschön\nvon mir. ZZZT!", italian="ZZZT! Questo è il mio modo\nper ringraziarti. ZZZT!", spanish="¡Bzz! Acepta esto como muestra\nde mi agradecimiento. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="[CN][CS:Y]Sunflora[CR] received the [CS:Z]Sun Scarf[CR]\n[CN]from [CS:N]Magnezone[CR]!", french="[CN][CS:Y]Héliatronc[CR] a reçu l'[CS:Z]Hélioécharpe[CR]\n[CN]de la part de [CS:N]Magnézone[CR]!", german="[CN][CS:Y]Sonnflora[CR] erhält den [CS:Z]Sonn-Schal[CR]\n[CN]von [CS:N]Magnezone[CR]!", italian="[CN][CS:Y]Sunflora[CR] ha ricevuto il [CS:Z]Velosole[CR]\n[CN]da [CS:N]Magnezone[CR]!", spanish="[CN][CS:Y]Sunflora[CR] ha obtenido un [CS:Z]Pañuelo Sol[CR]\n[CN]de [CS:N]Magnezone[CR]."})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- item_Set(0, 1150, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- switch(message_Menu(MENU_GIVE_ITEM2)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  GAME:WaitFrames(10)
  do local p=npc_npc_jibakoiru.Position; GROUND:MoveToPosition(npc_npc_jibakoiru, p.X+(0), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" A-a [CS:Z]Sun Scarf[CR]!", french=" U-une [CS:Z]Hélioécharpe[CR]!", german=" E-ein [CS:Z]Sonn-Schal[CR]!", italian=" U-Un [CS:Z]Velosole[CR]!", spanish=" Es... ¡un [CS:Z]Pañuelo Sol[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Th-this will help me against\nFire-type damage...", french="Ç-ça me protégera contre les\ndégâts de type Feu...", german="D-der wird mir eine große Hilfe\ngegen Feuer-Attacken sein.", italian="C-Con questo potrò proteggermi\ndagli attacchi di tipo Fuoco...", spanish="Me... Me ayudará a combatir el\ndaño de tipo Fuego..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This Exclusive Item is a\ngreat treasure!", french="Cet Objet Exclusif est un\nsuper trésor!", german="Dieses Exklusive Item ist ein\ngroßer Schatz!", italian="Questo Strumento Esclusivo\nè un tesoro incredibile!", spanish=" ¡Este objeto exclusivo es ideal!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh! I'm so happy!", french="Ben mince alors! J'en crois pas\nmes pétales!", german=" Auweia! Ich bin so froh!", italian=" Evviva! Sono così felice!", spanish=" ¡Jo, qué fuerte! ¡Soy superfeliz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Well then.[K] Thank you for\nyour assistance. ZZZT!", french="ZZZT! Très bien.[K] Merci encore\npour votre aide. ZZZT!", german="ZZZT! Nun gut.[K] Vielen Dank für\ndie Zusammenarbeit. ZZZT!", italian="ZZZT! Molto bene.[K] Grazie ancora\nper il vostro aiuto. ZZZT!", spanish="¡Bzz! Me alegro de que te guste.[K]\nGracias por tu ayuda. ¡Bzz!"})
  -- message_Close
  -- GAP: se_Play(6418) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, "happy", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_jibakoiru, npc_npc_goosuto2, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_koiru, Direction.UpRight)
  GROUND:EntTurn(npc_npc_koiru2, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! All right, come\nalong. ZZZT!", french=" ZZZT! Parfait, allons-y. ZZZT!", german=" ZZZT! Wir brechen auf. ZZZT!", italian=" ZZZT! Forza, andiamo. ZZZT!", spanish="¡Bzz! Venga, vosotros,\nandando. ¡Bzz!"})
  -- message_Close
  GROUND:MoveToPosition(npc_npc_jibakoiru, 380, 228, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_koiru, Direction.Down)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_koiru, 332, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 424, 208, Direction.Down, "NPC_GOOSUTO")
  GROUND:MoveToPosition(npc_npc_goosuto, 420, 220, false, 2)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_goosuto2, 420, 220, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_goosuto3 = SkySceneKit.spawn_npc("haunter", 472, 208, Direction.Down, "NPC_GOOSUTO3")
  GROUND:MoveToPosition(npc_npc_goosuto3, 420, 220, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_koiru2, 332, 220, false, 2)
  pcall(function() SOUND:FadeOutBGM(150) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 32, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GROUND:MoveToPosition(npc_npc_heigani, 388, 244, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_diguda, 432, 280, false, 2)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 480, 280, Direction.UpLeft, "NPC_DAGUTORIO")
  GROUND:MoveToPosition(npc_npc_dagutorio, 472, 280, false, 2)
  GAME:WaitFrames(5)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 512, 272, Direction.UpLeft, "NPC_GUREGGURU")
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_guregguru, 492, 264, false, 2) -- Slide2PositionMark (glissement)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 520, 240, Direction.Left, "NPC_CHIRIIN")
  GROUND:MoveToPosition(npc_npc_chiriin, 500, 220, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_bippa, 400, 268, false, 2)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_guregguru, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Attention!", french=" Votre attention, s'il vous plaît!", german=" Eure Aufmerksamkeit, bitte!", italian=" Attenzione!", spanish=" ¡Atención!"})
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Thanks to [CS:Y]Sunflora[CR]![K]\nShe accomplished this arrest. ♪", french="Tous nos remerciements\nà [CS:Y]Héliatronc[CR]![K]\nC'est elle qui a conduit cette arrestation. ♪", german="Lasst uns [CS:Y]Sonnflora[CR] danken![K]\nSie hat diese Festnahme zustande gebracht. ♪", italian="Ringraziamo [CS:Y]Sunflora[CR]![K]\nÈ stata lei a compiere l'arresto. ♪", spanish="¡[CS:Y]Sunflora[CR], muchas gracias![K]\nHas logrado arrestar a los malhechores. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" You really did a great job. ♪", french="Tu as vraiment fait un\nexcellent travail. ♪", german="Das war echt eine\nSpitzenleistung. ♪", italian="Hai svolto un lavoro\neccezionale. ♪", spanish=" Has hecho un gran trabajo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" No, no... I must say...", french=" Non, non... Il faut dire...", german=" Augenblick... Ich muss sagen...", italian=" No, no... A dire il vero...", spanish=" No, no... Tengo algo que decir..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I didn't do it all by myself...", french="... que je n'ai pas fait ça\ntoute seule...", german="Ich habe das nicht ganz allein\ngeschafft...", italian=" Il merito non è solo mio...", spanish=" No lo hice yo sola..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?", french=" Hein?", german=" Hmmm?", italian=" Uh?", spanish=" ¿Eh?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Speaking of which,\nwhere's [CS:N]Loudred[CR]...?", french="Justement, où se trouve\n[CS:N]Ramboum[CR]...?", german="Wo ich gerade dabei bin,\nwo steckt denn [CS:N]Krakeelo[CR]?", italian=" A proposito...", spanish=" Por cierto, ¿dónde está [CS:N]Loudred[CR]?..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Where is [CS:N]Loudred[CR]?", french=" Où est-il encore, ce [CS:N]Ramboum[CR]?", german=" Wo ist [CS:N]Krakeelo[CR]?", italian=" Dov'è [CS:N]Loudred[CR]?", spanish=" ¿Dónde está [CS:N]Loudred[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" [CS:N]Loudred[CR]?", french=" [CS:N]Ramboum[CR]?", german=" [CS:N]Krakeelo[CR]?", italian=" [CS:N]Loudred[CR]?", spanish=" ¿[CS:N]Loudred[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" He's in trouble!", french=" Il a de gros ennuis!", german=" Der steckt in Schwierigkeiten!", italian=" Si è cacciato nei guai!", spanish=" ¡Se ha metido en un buen lío!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He neglected his Gatekeeper\nduties for the day and sneaked away\nsomewhere to slack off!", french="Il a abandonné son poste\nde gardien de l'entrée pour aller flâner\nje ne sais où!", german="Anstatt seinen Wachdienst zu\nschieben, hat er sich stattdessen lieber\nirgendwo anders herumgetrieben!", italian="Ha trascurato i suoi compiti\ndi guardiano e se l'è svignata da qualche\nparte per oziare!", spanish="Desatendió su guardia y se escabulló\nvete a saber dónde a hacer el vago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?!", french=" Hein?!", german=" Huch!", italian=" Eh?!", spanish=" ¡¿Qué?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So as punishment, I sent him to\n[CS:P]Apple Woods[CR] to fetch Perfect Apples!", french="Alors, comme punition, je l'ai\nenvoyé au [CS:P]Bois aux Pommes[CR] ramasser\ndes Pommes Parfaites!", german="Als Bestrafung habe ich ihn\nin den [CS:P]Apfelwald[CR] geschickt, um Perfekte Äpfel\nzu sammeln!", italian="Quindi, come punizione, l'ho\nmandato nel [CS:P]Giardino dei Meli[CR] a cercare\ndelle Mele Perfette!", spanish="Así que, como castigo, lo he\nmandado al [CS:P]Manzanar[CR] a por Manzanas\nPerfectas. ¡Para que aprenda!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... ([CS:N]L[CR]-[CS:N]Loudred[CR]...)", french=" ... ([CS:N]R[CR]-[CS:N]Ramboum[CR]...)", german=" ...([CS:N]K-Krakeelo[CR]...)", italian=" ... ([CS:N]L-Loudred[CR]...)", spanish=" Jo... ([CS:N]Lo[CR]... [CS:N]Loudred[CR]...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="([CS:N]Chatot[CR] didn't really ask you to\ncome help me...)", french="(Ce n'est donc pas [CS:N]Pijako[CR] qui t'a\ndemandé de venir m'aider...)", german="([CS:N]Plaudagei[CR] hatte dich gar nicht\ndarum gebeten, mir zu helfen...)", italian="(Non è stato [CS:N]Chatot[CR] a chiedergli\ndi venire ad aiutarmi...)", spanish="([CS:N]Chatot[CR] no te pidió que fueras\na echarme una mano...)"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That's not true, [CS:N]Chatot[CR].", french=" Ce n'est pas vrai, [CS:N]Pijako[CR].", german=" Das stimmt nicht, [CS:N]Plaudagei[CR].", italian=" Ti sbagli, [CS:N]Chatot[CR].", spanish=" Eso no es cierto, [CS:N]Chatot[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Huh?[K] What isn't?", french=" Comment?[K] Que veux-tu dire?", german="Wie bitte?[K]\nWas soll nicht stimmen?", italian=" Uh?[K] Cosa?", spanish=" ¿Eh?[K] ¿Qué no es cierto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" The truth is, [CS:N]Loudred[CR]...", french=" La vérité, c'est que [CS:N]Ramboum[CR]...", german=" In Wahrheit hat [CS:N]Krakeelo[CR]...", italian=" La verità è che [CS:N]Loudred[CR]...", spanish=" En realidad [CS:N]Loudred[CR]..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(90) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Whaaaat?![K] Is that right?!", french=" Quoiiiii?![K] Vraiment?!", german="Waaaas?!?[K]\nIst das die Wahrheit?!?", italian=" Cosaaa?![K] Dici sul serio?!", spanish=" ¡¿Quéeee?![K] ¡¿En serio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If that's the case, then [CS:N]Loudred[CR]\nalso deserves recognition![K] I need to thank him!", french="Si tu dis vrai, alors [CS:N]Ramboum[CR]\nmérite aussi sa part de reconnaissance![K]\nJe dois le remercier!", german="Wenn das so ist, verdient auch\n[CS:N]Krakeelo[CR] unsere Anerkennung![K] Ich muss ihm\naugenblicklich danken!", italian="Se è così, allora anche [CS:N]Loudred[CR]\nmerita un riconoscimento![K] Devo ringraziarlo!", spanish="¡Si es así, [CS:N]Loudred[CR] también\nmerece reconocimiento![K] ¡He de darle\nlas gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Però...", spanish=" Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Golly, what is it?", french=" Sapristi, qu'est-ce qu'il y a?", german=" Was ist denn, Donnerwetter?", italian=" Ohibò, che c'è?", spanish=" Caramba, ¿qué pasa?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Guild rules are strict.", french="Le règlement de la Guilde est\nstrict sur ce point.", german=" Die Gildenregeln sind strikt.", italian="Le regole della Gilda sono\nsevere.", spanish="Las normas del [CS:N]Pokégremio[CR]\nson estrictas."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The fact that [CS:N]Loudred[CR] left his\npost remains unchanged.", french="Il n'en demeure pas moins que\n[CS:N]Ramboum[CR] a délaissé son poste.", german="Die Tatsache, dass [CS:N]Krakeelo[CR]\nseine Pflicht verletzt hat, bleibt bestehen.", italian="Il fatto che [CS:N]Loudred[CR] abbia\nabbandonato la sua postazione non\ncambia la situazione.", spanish="El hecho de que [CS:N]Loudred[CR] abandonara\nsu puesto sigue estando ahí."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" A punishment is a punishment.", french=" Une punition est une punition.", german=" Strafe ist Strafe.", italian=" Una punizione è una punizione.", spanish=" Un castigo es un castigo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Loudred[CR]'s already left for\n[CS:P]Apple Woods[CR]...", french="[CS:N]Ramboum[CR] est déjà parti pour\nle [CS:P]Bois aux Pommes[CR]...", german="[CS:N]Krakeelo[CR] hat sich bereits zum\n[CS:P]Apfelwald[CR] aufgemacht...", italian="E poi [CS:N]Loudred[CR] è già partito\nper il [CS:P]Giardino dei Meli[CR]...", spanish="[CS:N]Loudred[CR] ya se ha marchado\nal [CS:P]Manzanar[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="He'll only have to harvest\nPerfect Apples for today.", french="Il n'aura qu'à ramasser des\nPommes Parfaites pour aujourd'hui.", german="Aber er wird nur heute\nPerfekte Äpfel ernten müssen.", italian="Ma niente paura, deve solo\nraccogliere le Mele Perfette per la\ngiornata di oggi.", spanish="Solo tendrá que recoger\nManzanas Perfectas hoy."})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
