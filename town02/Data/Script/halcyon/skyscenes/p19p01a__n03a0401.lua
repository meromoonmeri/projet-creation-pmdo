-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SkySceneKit.reset_locks()
  SkySceneKit.run_routine(function() -- def 1 for actor ACTOR_PLAYER_PUPURIN
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(5) -- Lock(5) NDS
    GROUND:MoveToPosition(hero, 228, 208, false, 2)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    GROUND:EntTurn(hero, Direction.UpRight)
    SkySceneKit.lock(6) -- Lock(6) NDS
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    SkySceneKit.lock(7) -- Lock(7) NDS
    -- SetAnimation(4) [anim idle native]
    SkySceneKit.lock(8) -- Lock(8) NDS
    -- SetAnimation(2) [anim idle native]
    SkySceneKit.lock(9) -- Lock(9) NDS
    pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
    pcall(function() GROUND:CharSetEmote(hero, "question", 1) end)
    SkySceneKit.lock(10) -- Lock(10) NDS
    GROUND:EntTurn(hero, Direction.UpLeft)
    GAME:WaitFrames(30)
    SkySceneKit.lock(11) -- Lock(11) NDS
    GROUND:MoveToPosition(hero, 196, 188, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- GAP: se_Play(9733) — id SE NDS sans portage PMDO identifié
    -- SetAnimation(18) [anim idle native]
    GAME:WaitFrames(30)
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:MoveToPosition(hero, 172, 172, false, 2)
    GROUND:EntTurn(hero, Direction.Right)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- CallCommon CORO_JUMP_ANGRY_FUNC (fermeture/attente message: géré par say())
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    GROUND:EntTurn(hero, Direction.UpRight)
    GROUND:MoveToPosition(hero, 196, 188, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- SetAnimation(5) [anim idle native]
    GAME:WaitFrames(30)
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    -- SetOutputAttribute(8) [neutre/état moteur]
    GROUND:MoveToPosition(hero, 220, 172, false, 2)
    GROUND:EntTurn(hero, Direction.Left)
    GAME:WaitFrames(10)
    pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
    -- SetAnimation(18) [anim idle native]
    GAME:WaitFrames(30)
    -- SetOutputAttribute(2) [neutre/état moteur]
    -- SetAnimation(2) [anim idle native]
    pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
    -- se_FadeOut(9733, 10) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
    SkySceneKit.lock(12) -- Lock(12) NDS
    GROUND:EntTurn(hero, Direction.Right)
    GAME:WaitFrames(10)
    GROUND:MoveToPosition(hero, 252, 208, false, 2)
    GROUND:EntTurn(hero, Direction.Up)
    GAME:WaitFrames(1) -- hold
  end)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=42, sub=2} -- $SCENARIO_SIDE = scn[42,2] (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- back_SetGround(LEVEL_P19P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 256, 176, Direction.Left, "NPC_AAMARUDO")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- GAP: BGM BGM_A_FUN_EXPLORATION non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(5) -- Unlock(5) NDS
  GAME:WaitFrames(40)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(40)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Good morning! ♪", french=" Bonjour! ♪", german=" Guten Morgen! ♪", italian=" Buongiorno! ♪", spanish=" ¡Buenos días! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(6) -- Unlock(6) NDS
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Hey, here you are, Junior.", french=" Ah, tu es là, petit.", german=" Hey, da bist du ja, Junior.", italian=" Ehi, eccoti qui, piccolo.", spanish=" Ah, ya estás aquí, peque."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(7) -- Unlock(7) NDS
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Quick, let's go let's go! ♪", french=" Vite, on y va, on y va! ♪", german="Schnell, lass uns gehen. Nun\nmach schon! ♪", italian=" Dai, andiamo, andiamo! ♪", spanish=" ¡Venga, vamos, vamos! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(8) -- Unlock(8) NDS
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" No need to be impatient.", french=" Inutile de t'impatienter.", german=" Kein Grund, ungeduldig zu sein.", italian=" Non essere impaziente.", spanish=" No seas tan impaciente."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Before exploring, you have to\nmake sure you're well prepared.", french="Avant une exploration, il faut\nbien se préparer.", german="Vor einer Erkundung musst du\nsichergehen, dass du gut vorbereitet bist.", italian="Prima d'iniziare un'esplorazione,\nbisogna prepararsi bene.", spanish="Antes de explorar debes\nasegurarte de estar totalmente listo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(9) -- Unlock(9) NDS
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Prepared?", french=" Se préparer?", german=" Vorbereitet?", italian=" Prepararsi?", spanish="¿Qué quieres decir?\n¿Estar totalmente listo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Esatto.", spanish=" Sí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Look at this.", french=" Regarde ceci.", german=" Sieh mal hier.", italian=" Guarda qui.", spanish=" Mira esto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" What...[K] What's this?", french=" C'est...[K] c'est quoi, ça?", german=" Was...[K] Was ist das?", italian=" Cosa...[K] Cos'è questa?", spanish=" Qué...[K] ¿Qué es esto?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="This is called a Kangaskhan\nRock...[K] Here you can make a record of your\nadventure and sort your items...", french="C'est ce qu'on appelle une Statue\nKangourex...[K] Ici, tu peux sauvegarder ton\naventure et trier tes objets...", german="Dies nennt man einen Kangama-\nSpeicher...[K] Hier kannst du dein Abenteuer\nsichern und deine Items sortieren...", italian="Questa si chiama Statua\nKangaskhan...[K] Qui puoi salvare la tua\navventura e gestire i tuoi strumenti...", spanish="Es una Roca de Kangaskhan...[K]\nCon ella puedes guardar tu aventura y ordenar\ntus objetos..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's something you shouldn't\npass up on your explorations.", french="C'est une étape à ne pas\noublier lors des explorations.", german="So einen solltest du auf\ndeinen Erkundungen nie auslassen.", italian="Tienilo bene a mente quando\ndecidi di partire per un'esplorazione.", spanish="Es algo que no debes olvidar\ndurante tus exploraciones."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Really?", french=" Vraiment?", german=" Wirklich?", italian=" Davvero?", spanish=" ¿De verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(11) -- Unlock(11) NDS
  GAME:WaitFrames(40)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Oh![K] Hey![K] Stop hitting it\nlike that!", french="Oh![K] Hé![K] Arrête un peu de taper\ndessus comme ça!", german="Oh![K] Hey![K] Hör auf, so darauf\nherumzuhauen!", italian="Oh![K] Ehi![K] Smettila di colpirla\nin quel modo!", spanish="¡Oye![K] ¡Para![K] ¡No le des\nesos golpes!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitLockLives
  SkySceneKit.unlock(12) -- Unlock(12) NDS
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Anyhow.", french=" Bref.", german=" Na, wie auch immer.", italian=" Comunque...", spanish=" En fin."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="You can go ahead and use any\nitems you find at the Kangaskhan Rock as\nyou see fit...", french="Tu peux choisir les objets que\ntu as trouvés à la Statue Kangourex et les\nutiliser comme bon te semble...", german="Du kannst jedes im\nKangama-Speicher gelagerte Item verwenden,\nwie du es für angebracht hältst...", italian="Alla Statua Kangaskhan puoi\ntrovare e usare gli strumenti depositati che\npotrebbero esserti utili per la tua avventura...", spanish="Como iba diciendo, puedes usar\ncualquier objeto que encuentres en la Roca de\nKangaskhan como mejor te parezca..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="So, let's use the Kangaskhan\nRock to finish preparations for our adventure.", french="Bien, utilisons la Statue\nKangourex pour terminer nos préparatifs.", german="Lass uns also mithilfe des\nKangama-Speichers die Vorbereitungen\nunseres Abenteuers abschließen.", italian="Quindi usiamo la Statua\nKangaskhan per prepararci al meglio.", spanish="Bueno, pues vamos a usar la\nRoca de Kangaskhan para ultimar\nlos preparativos de nuestra aventura."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep! ♪ Got it! ♪", french=" Voui! ♪ Compris! ♪", german=" Ja! ♪ Verstanden! ♪", italian=" Ok! ♪ Ho capito! ♪", spanish=" ¡Vale! ♪ ¡Voy! ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
  SkySceneKit.join_routines()
end
