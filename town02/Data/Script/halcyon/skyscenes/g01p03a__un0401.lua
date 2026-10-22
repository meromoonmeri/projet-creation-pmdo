-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/un0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(43, 2) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 2]
  end
  -- @label_3 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[132] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[132]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 432, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" [CS:Y]Sunflora[CR]'s such a kind lady...", french=" [CS:Y]Héliatronc[CR] est si gentille...", german=" [CS:Y]Sonnflora[CR] ist so nett...", italian=" [CS:Y]Sunflora[CR], sei così gentile...", spanish=" [CS:Y]Sunflora[CR] es amabilísima..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Whoa...", french=" Waouh...", german=" Wow...", italian=" Wow...", spanish=" Guau..."})
  -- message_Close
  -- @label_2 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  SV.SkyTalkBitFlags = SV.SkyTalkBitFlags or {}; SV.SkyTalkBitFlags[132] = 1 -- $SCENARIO_TALK_BIT_FLAG[132] = 1 (ROM)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Oh! [K]Oh, miss!", french=" Oh! [K]Oh, m'zelle!", german=" Oh![K] Oh, Fräulein!", italian=" Oh! [K]Oh, signorina!", spanish=" ¡Anda![K] ¡Hola, señorita!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Whoa...", french=" Ouah...", german=" Wow...", italian=" Wow...", spanish=" Guau..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Wh-what's going on?[K]\nM-miss?", french="Qu'est-ce... qu'est-ce qui\nse passe?[K] M'zelle?", german="W-was ist los?[K]\nF-fräulein?", italian=" C-Come?[K] S-Signorina?", spanish="¿Qué... Qué ocurre?[K]\n¿Se... señorita?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Ah...[K]n-no!", french=" Ah...[K] n-non!", german=" Ah...[K] N-nein!", italian=" Ah...[K] N-No!", spanish=" Ah...[K] ¡Nada, nada!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I-it's nothing![K]\nI was just whispering to myself! Yup, yup!", french="Ce... c'est rien![K]\nJe m'parlais à moi-même, c'est tout!\nOuaip ouaip!", german="G-gar nix![K] Ich habe nur mit mir\nselbst gesprochen! Jawollja!", italian="N-Non è niente![K]\nStavo parlando tra me e me! Già, già!", spanish="¡No pasa nada![K]\n¡Solo hablaba conmigo mismo, sí, señor!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Anyhow...", french=" En tout cas...", german=" Gleichwohl...", italian=" Comunque...", spanish=" Estooo..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Thanks for taking me along on\nthat exploration the other day!", french="... merci de m'avoir emmené\nen exploration, l'autre jour!", german="Danke, dass du mich neulich mit\ndir hast mitkommen lassen!", italian="Grazie di avermi portato con te\nin esplorazione l'altro giorno!", spanish="¡Gracias por llevarme\nde exploración el otro día!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="You're great at exploring,\n[CS:Y]Sunflora[CR]!", french="Tu es une super exploratrice,\n[CS:Y]Héliatronc[CR]!", german="Du bist eine wirklich großartige\nErkunderin, [CS:Y]Sonnflora[CR]!", italian="Sei davvero una grande\nesploratrice, [CS:Y]Sunflora[CR]!", spanish="¡Explorar se te da genial,\n[CS:Y]Sunflora[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" I really respect you... Yup!", french="Je te respecte vraiment...\nOuaip!", german="Deshalb habe ich großen Respekt\nvor dir... Jawollja!", italian=" Ti ammiro davvero tanto... Già!", spanish=" Te admiro mucho... ¡En serio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" R-respect?", french=" Tu me... respectes?", german=" R-respekt?", italian=" M-Mi ammiri?", spanish=" ¿Me... admiras?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh![K] I'm so happy!", french="J'hallucine![K] Je suis\ntrooop contente!", german=" Auweia![K] Ich freue mich so!", italian=" Shock![K] Sono così felice!", spanish=" ¡Qué pasada![K] ¡Estoy superfeliz!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You know...you were not so\ngreat in the beginning, [CS:N]Bidoof[CR]...", french="Tu sais... au début, t'étais pas\ntrop top, [CS:N]Keunotor[CR]...", german="Weißt du... Du warst vielleicht\nam Anfang nicht der Beste, [CS:N]Bidiza[CR]...", italian="Sai... all'inizio non eri così\nbravo, [CS:N]Bidoof[CR]...", spanish="La verdad es que... al principio\nno eras demasiado bueno, [CS:N]Bidoof[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But look...you've learned how\nto fight and gotten better little by little...", french="Mais regarde... Tu as appris\nà te battre et tu t'es amélioré\nau fur et à mesure...", german="Aber sieh mal... Du hast gelernt\nzu kämpfen und bist nach und nach immer\nbesser geworden...", italian="Ma adesso hai imparato a\nlottare e sei migliorato molto...", spanish="Pero... has aprendido a combatir\ny has mejorado poco a poco..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I am so glad!", french=" Je suis si contente!", german=" Ich bin so froh!", italian=" Sono così contenta per te!", spanish=" ¡Me alegro muchísimo por ti!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" R-[K]really? You mean it?", french="Vrai... [K]vraiment?\nTu l'penses?", german=" W-[K]wirklich? Findest du?", italian=" Da-[K]Davvero? Dici sul serio?", spanish=" ¿Cómo?...[K] ¿De verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Yes. [K]If you keep on working\nhard, you'll be a great explorer in no time!", french="Oui. [K]Si tu continues\nà bosser dur, tu deviendras un grand\nexplorateur en un rien de temps!", german="Ja.[K] Wenn du dich weiter so\nanstrengst, wirst du schon bald ein großer\nErkunder sein!", italian="Certo. [K]Se continui a impegnarti\ncosì, in men che non si dica diventerai\nun grande esploratore.", spanish="Sí.[K] ¡Si sigues trabajando duro,\nexplorarás de maravilla ya mismo!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Do your best!", french=" Fais de ton mieux!", german=" Gib dein Bestes!", italian=" Fai del tuo meglio!", spanish=" ¡Ve a por todas!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Gosh, I'm so happy![K]\nI'm gonna do my best to be an explorer!", french="Sapristi, j'suis si heureux![K]\nJe vais faire d'mon mieux pour\ndevenir explorateur!", german="Donnerwetter, macht mich das\nglücklich![K] Ich werde mein Bestes geben, ein\ngroßer Erkunder zu sein.", italian="Ohibò, sono così contento![K] Darò\nil massimo per diventare un bravo esploratore!", spanish="¡Caramba, qué alegría![K] ¡Voy a\nesforzarme para llegar a ser un explorador!"})
  -- message_Close
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  SkySceneKit.cleanup_npcs()
end
