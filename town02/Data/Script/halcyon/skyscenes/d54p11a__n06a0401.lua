-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D54P11A/n06a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 224, 248, Direction.Up, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Looks like we didn't do\nso well.", french="Hum...[K] Ce n'était pas\nune franche réussite.", german="Hmm...[K] Sieht fast so aus, als\nwären wir nicht gut genug gewesen.", italian="Mmm...[K] A quanto pare non\nè andata molto bene.", spanish="Hum...[K] Parece que\nno nos ha ido demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So it goes.[K] That's how\nit is sometimes. [M:H8]", french="C'est ainsi.[K] On ne peut pas\nréussir à tous les coups. [M:H8]", german="Nun gut.[K] So was passiert sogar\nden Besten. [M:H8]", italian=" Già.[K] A volte capita. [M:H8]", spanish="No pasa nada.[K] Son cosas\nque pasan. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 288, 248, Direction.Up, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Anyway, let's head back for a\nlittle while.", french=" Faisons une petite pause.", german="Wir sollten uns auf den\nRückweg begeben und für eine Weile ausruhen.", italian="Comunque non dobbiamo perdere\nla speranza.", spanish=" En fin, volvamos."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D54P11A) [neutre/état moteur]
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
  -- GAP: BGM BGM_SOUTHERN_JUNGLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
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
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="This time, we'll make it through\nthe jungle!", french="Cette fois-ci, nous viendrons\nà bout de cette jungle!", german="Dieses Mal schaffen wir es\ndurch den Dschungel!", italian="Questa volta ce la faremo\na uscire dalla giungla!", spanish="¡Esta vez conseguiremos\natravesar la selva!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Don't get too worked up about it,\n[CS:N]Medicham[CR].[K] It's good to be excited, but only to\na point.", french="Allons, du calme, [CS:N]Charmina[CR].[K]\nC'est bien d'être enthousiaste, mais pas trop\nquand même.", german="Nur keine Sorge, [CS:N]Meditalis[CR].[K]\nEs ist okay, mitzufiebern. Aber Übermut tut\nselten gut.", italian="Non scaldarti troppo, [CS:N]Medicham[CR].[K]\nTutta questa energia va bene, ma fino\na un certo punto.", spanish="No te emociones demasiado,\n[CS:N]Medicham[CR].[K] Está bien apasionarse, pero\ntodo tiene un límite."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That's right.[K] And it's not good to\nrush, either.", french="C'est bien vrai.[K]\nEt la précipitation n'est pas recommandée.", german="Das stimmt.[K] Vergiss nicht:\nIn der Ruhe liegt die Kraft.", italian="È vero.[K] E inoltre non dobbiamo\nfarci prendere dalla fretta.", spanish="Exacto.[K] Y tampoco conduce\na ningún sitio ir con prisas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This time, our target is said to\nbe impossible to find, so...", french="Cette fois-ci, nous nous\nattaquons à une cible dont on dit qu'elle\nest introuvable...", german="Man sagt, dass unser jetziges\nZiel schwer zu finden sei...", italian="Se dicono che questa volta il\nnostro obiettivo è impossibile da trovare...", spanish="En esta ocasión se dice que\nnuestro objetivo es imposible de hallar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We don't really need to worry\nabout another exploration team finding it\nbefore we do. [M:H8]", french="Le côté positif, c'est qu'on n'a\npas à craindre la concurrence. [M:H8]", german="Also müssen wir keine Sorgen\nhaben, dass uns ein anderes Erkundungsteam\nzuvorkommen könnte. [M:H8]", italian="... almeno non dobbiamo temere\nche un'altra squadra d'esplorazione arrivi\nprima di noi. [M:H8]", spanish="Así que no debe preocuparnos\nque otro equipo explorador\nse nos adelante. [M:H8]"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyhow...[K] We should keep\nmoving and be cautious.", french="Enfin...[K] Continuons à avancer\navec prudence.", german="Aber trotzdem...[K] Wer rastet,\nder rostet. Also lasst uns weiter. Und immer\nschön vorsichtig!", italian="Comunque...[K] è meglio proseguire\ne fare molta attenzione.", spanish="En fin...[K] Deberíamos seguir\navanzando y proceder con cautela."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
