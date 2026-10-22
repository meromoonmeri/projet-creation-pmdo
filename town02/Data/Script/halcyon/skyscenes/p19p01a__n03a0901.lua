-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/n03a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  SV.SkyScenarioSide = {main=42, sub=5} -- $SCENARIO_SIDE = scn[42,5] (ROM)
  pcall(function() SOUND:StopBGM() end)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_SET_TEAM_SETUP_HERO_AND_PARTNER_ONLY, 0) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
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
  GROUND:MoveToPosition(hero, 228, 208, false, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Good morning, Master. ♪", french=" Bonjour, Maître. ♪", german=" Guten Morgen, Meister. ♪", italian=" Buongiorno, maestro. ♪", spanish=" Buenos días, maestro. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Oh hi, Junior.", french=" Oh, salut, petit.", german=" Oh, hallo Junior.", italian=" Oh ciao, piccolo.", spanish=" Ah, hola, peque."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Before you got here, I was doing\nsome research on [CS:P]Fortune Ravine[CR]...", french="Je viens de faire quelques\nrecherches sur ce [CS:P]Ravin Aubaine[CR]...", german="Ich habe noch ein paar\nNachforschungen über die [CS:P]Schicksalsschlucht[CR]\nangestellt.", italian="Prima del tuo arrivo, stavo\nfacendo delle ricerche sulla [CS:P]Gola del Tesoro[CR]...", spanish="Antes de que llegaras he estado\ninvestigando un poco el [CS:P]Risco Fortuna[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="It's a lot harder than any of the\ndungeons we've visited so far.", french="C'est un donjon bien plus\ndifficile que tous ceux que nous avons\nvisités jusque-là.", german="Sieht aus, als ob das heute um\neiniges schwieriger werden könnte als alle\nDungeons, die wir bisher besucht haben.", italian="Rispetto ai dungeon che abbiamo\nesplorato finora, è in assoluto il più difficile.", spanish="Es mucho más complicado que\ncualquier otro territorio en el que\nhayamos estado."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Even with my strength...[K]it will\nprobably be difficult.", french="Même avec mon expérience...[K]\nce sera probablement compliqué.", german="Selbst mit meiner Stärke[K]\nkann das sehr schnell schwierig werden.", italian="Per quanto io sia forte...[K] sarà\ncomunque molto dura.", spanish="Incluso con mi fuerza...[K]\nprobablemente tengamos dificultades."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Huh?[K] So we're not going?", french=" Ah?[K] Alors on n'y va pas?", german=" Hmmm?[K] Also gehen wir nicht?", italian=" Uh?[K] Allora non andiamo?", spanish=" ¿Eh?[K] ¿Entonces no vamos?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_aamarudo, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Maybe, maybe not.[K] I'm\nconcerned about what to do.", french="Peut-être que oui, peut-être\nque non.[K] Je dois y réfléchir.", german="Vielleicht, vielleicht auch nicht.[K]\nIch wäge ab, was wir tun sollen.", italian="Forse, non lo so.[K] Sono indeciso\nsul da farsi.", spanish="Quizá sí, quizá no.[K] Tengo dudas\nsobre lo que deberíamos hacer."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 252, 208, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Let's go! ♪[K] It will be fine,\nI know. ♪", french="On y va! ♪[K] Ça se passera bien,\nje le sais. ♪", german="Lass es uns versuchen! ♪[K]\nEs wird schon klappen, da bin ich sicher. ♪", italian="Andiamo! ♪[K] Sono sicuro che\nandrà tutto bene. ♪", spanish="¡Pues vamos! ♪[K] Todo irá bien,\nconfía en mí. ♪"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Together, Master and I\nare invincible! ♪", french="Ensemble, vous et moi,\non est invincibles! ♪", german="Zusammen sind der Meister\nund ich unbesiegbar! ♪", italian="Insieme, io e il maestro siamo\ninvincibili! ♪", spanish="¡Juntos, el maestro y yo\nsomos invencibles! ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" It's all right, all right! ♪", french=" C'est bon, tout bon! ♪", german=" Kein Problem, kein Problem! ♪", italian=" Tutto bene, tutto bene! ♪", spanish=" ¡Todo irá bien, ya lo verás! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...[K] (That's right...)", french=" ...[K] (\\\"Tout bon\\\"...)", german=" ...[K](Er hat recht...)", italian=" ...[K] (È vero...)", spanish=" Hum...[K] (Tiene razón...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(No thanks to me...[K] This kid is\nan exploration prodigy...)", french="(Sûrement pas grâce à moi...[K]\nCe gamin est un vrai génie...)", german="(Warum mache ich mir Sorgen...[K]\nDieser Kleine ist ein Erkundungs-Wunderkind...)", italian="(È inutile rifletterci sopra...[K]\nQuesto bambino è un genio dell'esplorazione...)", spanish="(Pero no gracias a mí...[K] Este\ncrío es un prodigio explorando...)"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="(If I tried to go alone, I couldn't\ndo it...[K] But if he's with me...)", french="(Si je m'aventurais là-bas\ntout seul, je n'aurais aucune chance...[K]\nMais avec lui à mes côtés...)", german="(Wenn ich es allein machen\nwürde, keine Chance...[K] Aber wenn er dabei\nist...)", italian="(Se andassi da solo,\nprobabilmente non ce la farei...[K]\nMa se lui è con me...)", spanish="(Si intentara ir solo, fracasaría\nestrepitosamente...[K] Pero si está conmigo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" ...[K]All right. [K]I agree.", french=" ...[K] Soit. [K]Je suis d'accord.", german="...[K]Nun gut.[K]\nDu hast mich überzeugt.", italian=" ...[K] Va bene.[K] D'accordo.", spanish="Hum...[K] Muy bien.[K] Estoy\nde acuerdo contigo."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Let's go.[K] To [CS:P]Fortune Ravine[CR].", french="Allons-y.[K] En route pour\nle [CS:P]Ravin Aubaine[CR].", german="Gehen wir.[K]\nAuf zur [CS:P]Schicksalsschlucht[CR].", italian="Andiamo.[K] Si parte per la\n[CS:P]Gola del Tesoro[CR].", spanish=" Vamos,[K] ¡al [CS:P]Risco Fortuna[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" M-Master!", french=" M-Maître!", german=" M-meister!", italian=" M-Maestro!", spanish=" ¡Ma... maestro!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I knew we were going to go![K]\nThat's my Master. ♪", french="Je savais que vous diriez ça![K]\nÇa, c'est mon Maître à moi. ♪", german="Ich wusste, wir würden gehen![K]\nDas ist mein Meister. ♪", italian="Lo sapevo che saremmo andati![K]\nQuesto è il mio maestro! ♪", spanish="¡Sabía que al final iríamos![K]\nMi maestro es el mejor. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Take care of your exploration\npreparations at the Kangaskhan Rock.", french="Prépare l'exploration comme\nil faut à la Statue Kangourex.", german="Denke an deine\nErkundungsvorbereitungen! Dort ist ein\nKangama-Speicher.", italian="Preparati per l'esplorazione\nusando la Statua Kangaskhan.", spanish="Ocúpate de los preparativos para\nla exploración en la Roca de Kangaskhan."})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Once you're ready, we'll go.", french=" Quand tu seras prêt, on partira.", german=" Wir gehen, sobald du fertig bist.", italian="Quando sei pronto, possiamo\npartire.", spanish=" Nos iremos cuando estés listo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Yep. ♪", french=" Voui. ♪", german=" Au ja. ♪", italian=" Sì. ♪", spanish=" Vale. ♪"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
