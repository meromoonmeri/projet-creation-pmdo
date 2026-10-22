-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/n02a0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  -- back_SetGround(LEVEL_P17P02A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_P17P02A, 'UN02') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 288, 184, Direction.DownLeft, "NPC_PUKURIN_PAPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpRight, "NPC_PUKURIN_MAMA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(42) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(35)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, "happy", 1) end)
  GAME:WaitFrames(80)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_papa, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(35)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, "happy", 1) end)
  GAME:WaitFrames(45)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin_mama, nil, 0) end) -- EFFECT_NONE
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Left)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Good morning, [CS:Y]Igglybuff[CR].", french=" Bonjour, [CS:Y]Toudoudou[CR].", german=" Guten Morgen, [CS:Y]Fluffeluff[CR].", italian=" Buongiorno, [CS:Y]Igglybuff[CR].", spanish=" Buenos días, [CS:Y]Igglybuff[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yep, good morning! ♪[K] [CS:N]Papa[CR]. ♪\n[CS:N]Mama[CR]. ♪", french="Youpla, bonjour! ♪[K] [CS:N]Papa[CR]\nde moi. ♪ [CS:N]Maman[CR] de moi. ♪", german="Jau! Guten Morgen! ♪[K] [CS:N]Papa[CR]. ♪\n[CS:N]Mama[CR]. ♪", italian="Buongiorno! ♪[K] [CS:N]Papà[CR]. ♪\n[CS:N]Mamma[CR]. ♪", spanish="¡Sí, buenos días! ♪[K] ¡Hola,\n[CS:N]papá[CR]! ♪ ¡Hola, [CS:N]mamá[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Hey, [CS:Y]Igglybuff[CR].", french=" Alors, [CS:Y]Toudoudou[CR].", german=" Sag mal, [CS:Y]Fluffeluff[CR]...", italian=" Ehi, [CS:Y]Igglybuff[CR].", spanish=" Oye, [CS:Y]Igglybuff[CR]."})
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="You've got plans to play with\nyour friends today, right?", french="Tu as prévu d'aller jouer avec\ntes amis, aujourd'hui?", german="Du spielst heute wieder mit\ndeinen Freunden, nicht wahr?", italian="Vai a giocare con i tuoi amici\noggi, non è vero?", spanish="Hoy tienes pensado ir a jugar\ncon tus amiguitos, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="I bought a bunch of Gummis.[K]\nTake some to share.", french="J'ai acheté un gros paquet\nde gelées.[K] Prends-en et partage-les\navec eux.", german="Ich habe reichlich Gummibonbons\neingekauft.[K] Nimm doch ein paar für euch mit!", italian="Ho comprato un po' di Gomme.[K]\nDividetele tra di voi.", spanish="He comprado gomis.[K]\nLlévate unas cuantas para compartirlas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪ Thanks, [CS:N]Mama[CR]. ♪", french=" Voui. ♪ Merci, [CS:N]Maman[CR]. ♪", german=" Au ja. ♪ Danke, [CS:N]Mama[CR]. ♪", italian=" Sì. ♪ Grazie, [CS:N]mamma[CR]. ♪", spanish=" Vale. ♪ Gracias, [CS:N]mamá[CR]. ♪"})
  -- message_Close
  GROUND:MoveToPosition(hero, 240, 208, false, 2)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin_mama, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(9488) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:Y]Igglybuff[CR] received\n[CN]many Gummis from [CS:N]Mama[CR].", french="[CN][CS:Y]Toudoudou[CR] reçoit\n[CN]plein de gelées de sa [CS:N]Maman[CR].", german="[CN][CS:Y]Fluffeluff[CR] erhält eine Menge\n[CN]Gummibonbons von [CS:N]Mama[CR].", italian="[CN][CS:Y]Igglybuff[CR] ha ricevuto molte Gomme\n[CN]dalla [CS:N]mamma[CR].", spanish="[CN][CS:Y]Igglybuff[CR] ha obtenido\n[CN]muchas gomis de su [CS:N]mamá[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-8), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR]!", french=" [CS:Y]Toudoudou[CR]!", german=" [CS:Y]Fluffeluff[CR]!", italian=" [CS:Y]Igglybuff[CR]!", spanish=" ¡[CS:Y]Igglybuff[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.Down)
  GAME:WaitFrames(6)
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:Y]Igglybuff[CR]. ♪[K] Let's play. ♪", french=" [CS:Y]Toudoudou[CR]. ♪[K] Tu viens jouer? ♪", german=" [CS:Y]Fluffeluff[CR]. ♪[K] Lass uns spielen. ♪", italian=" [CS:Y]Igglybuff[CR]. ♪[K] Andiamo a giocare. ♪", spanish=" [CS:Y]Igglybuff[CR]. ♪[K] Vamos a jugar. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin_papa, Direction.DownLeft)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin_mama, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_pukurin_mama, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Look...[K] Your friends are here.", french=" Regarde...[K] Tes amis sont là.", german="Sieh mal...[K]\nDeine Freunde kommen dich abholen.", italian="Senti...[K] Sono arrivati\ni tuoi amici.", spanish=" Mira...[K] Han llegado tus amigos."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="Be careful...[K] Come home\nbefore it's dark.", french="Fais attention...[K] Et rentre avant\nla tombée de la nuit.", german="Pass auf dich auf...[K]\nUnd komm zurück, bevor es dunkel wird.", italian="Fai attenzione...[K] Torna a casa\nprima che faccia buio.", spanish="Ten cuidado...[K] Vuelve a casa\nantes de que anochezca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪[K] I'm off! ♪", french=" Voui, voui. ♪[K] Je file! ♪", german=" Na klar. ♪[K] Ich geh dann mal! ♪", italian=" Sì. ♪[K] Io vado! ♪", spanish=" Vale. ♪[K] ¡Hasta luego! ♪"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"Igglybuff the Prodigy\"\n[CN]stars [CS:Y]Igglybuff[CR] as the main character.", french="[CN][CS:Y]Toudoudou[CR] est le personnage principal\n[CN]de l'Episode Spécial intitulé\n[CN]\"Toudoudou le Surdoué\".", german="[CN]Die Bonusepisode\n[CN][F:S2]Wundersamer Fluffeluff[F:E2]\n[CN]mit [CS:Y]Fluffeluff[CR] in der Hauptrolle.", italian="[CN]L'episodio speciale\n[CN]\"Igglybuff il genio\"\n[CN]ha come protagonista [CS:Y]Igglybuff[CR].", spanish="[CN]El capítulo especial\n[CN]\"Igglybuff es un prodigio\"\n[CN]tiene a [CS:Y]Igglybuff[CR] por protagonista."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You will progress through the story with\n[CN][CS:Y]Igglybuff[CR] as the playable character.", french="[CN]Vous incarnerez [CS:Y]Toudoudou[CR].", german="[CN]Du wirst die Geschichte mit [CS:Y]Fluffeluff[CR]\n[CN]als spielbarem Charakter bestreiten.", italian="[CN]In questa storia impersonerai [CS:Y]Igglybuff[CR].", spanish="[CN]Avanzarás en la historia\n[CN]con [CS:Y]Igglybuff[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Also...", french="[CN]En outre...", german="[CN]Bitte beachte...", italian="[CN]Inoltre...", spanish="[CN]Además..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You can save your adventure\n[CN]from [CS:Y]Igglybuff[CR]'s bed.", french="[CN]Vous pouvez sauvegarder votre aventure\n[CN]en vous rendant au lit de [CS:Y]Toudoudou[CR].", german="[CN]Du kannst dein Abenteuer im Bett\n[CN]von [CS:Y]Fluffeluff[CR] sichern.", italian="[CN]Puoi salvare la tua avventura\n[CN]dal letto di [CS:Y]Igglybuff[CR].", spanish="[CN]Puedes guardar tu aventura en\n[CN]la cama de [CS:Y]Igglybuff[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN][CS:Y]Igglybuff[CR]'s bed is the top one on the left.", french="[CN]Le lit de [CS:Y]Toudoudou[CR] est celui qui se trouve\n[CN]tout en haut à gauche.", german="[CN]Das Bett von [CS:Y]Fluffeluff[CR]\n[CN]befindet sich oben links.", italian="[CN]Il letto di [CS:Y]Igglybuff[CR] è quello\n[CN]più in alto a sinistra.", spanish="[CN]La cama de [CS:Y]Igglybuff[CR]\n[CN]es la de arriba a la izquierda."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]To save your progress, visit [CS:Y]Igglybuff[CR]'s bed.", french="[CN]Donc, pour sauvegarder votre aventure,\n[CN]rendez-vous sur le lit de [CS:Y]Toudoudou[CR].", german="[CN]Zum Sichern deines Fortschritts\n[CN]besuche das Bett von [CS:Y]Fluffeluff[CR].", italian="[CN]Per salvare i tuoi progressi,\n[CN]avvicinati al letto di [CS:Y]Igglybuff[CR].", spanish="[CN]Para guardar tus progresos ve\n[CN]a la cama de [CS:Y]Igglybuff[CR]."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
