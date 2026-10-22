-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P02P01A/m21a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Heartwarming.ogg", true) end)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[212] = 0 -- dungeon_mode(212) = DMODE_CLOSED (ROM)
  local npc_npc_kootasu = SkySceneKit.spawn_npc("torkoal", 264, 136, Direction.Down, "NPC_KOOTASU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kootasu, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_kootasu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_kootasu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Hm? Ah, my young friends![K]\nCome to wash away your exhaustion?", french="Hmm? Ah, jeunes gens![K]\nVous venez prendre un bon bain réparateur?", german="Hm? Ah, meine jungen Freunde![K]\nWollt ihr eure Müdigkeit wegwaschen?", italian="Eh? Ah, giovani Pokémon![K]\nVenite a lavar via la vostra stanchezza?", spanish="¿Eh? Ah, ¡mis jóvenes amigos![K]\n¿Venís a recuperaros de vuestro agotamiento?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" ...Oh?[K] Not so?", french=" ... Oh?[K] Ce n'est pas ça?", german=" ...Oh?[K] Nicht?", italian=" Eh?[K] Non siete qui per questo?", spanish=" ¿No?[K] ¿No es así?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I see...[K] You seek my wisdom.", french="Je vois...[K] Vous sollicitez\nmes conseils.", german="Ich verstehe...[K] Ihr sucht meinen\nweisen Rat.", italian="Capisco...[K] Siete alla ricerca\ndella mia saggezza.", spanish="Ah, ya veo...[K]\nOs interesa mi sabiduría."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Well, there's no better place\nthan this to share your story!", french="Eh bien, il n'y a pas meilleur\nendroit que celui-ci pour me faire part\nde votre histoire!", german="Nun, es gibt keinen besseren Ort\nals diesen, wenn ihr eure Geschichte mit\njemandem teilen möchtet.", italian="Bene, non c'è posto migliore di\nquesto per parlarmi della vostra storia!", spanish="Bueno, este es un lugar perfecto\npara compartir historias."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(45)
  -- back_SetGround(LEVEL_P02P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_mankii = SkySceneKit.spawn_npc("mankey", 304, 192, Direction.UpLeft, "NPC_MANKII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_okorizaru = SkySceneKit.spawn_npc("primeape", 216, 224, Direction.UpRight, "NPC_OKORIZARU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_MEDIUM2 — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_STUCK_IN_YELLOW_WATER_DEEP2 — VFX sans émote PMDO équivalente
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="...Ah, I see...[K] The [CS:P]Hidden Land[CR],\nyou say?", french="... Ah, je vois...[K] Les [CS:P]Terres\nIllusoires[CR], vous dites?", german="...Ah, ich verstehe.[K] Das\n[CS:P]Verborgene Land[CR], sagt ihr?", italian="Ah, capisco...[K] La [CS:P]Terra[CR]\n[CS:P]Nascosta[CR], dite?", spanish="Ah, ya veo...[K]\n¿La [CS:P]Tierra Oculta[CR], decís?"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I have heard of it.", french=" J'en ai entendu parler, en effet.", german=" Ich habe davon gehört.", italian=" Ne ho sentito parlare.", spanish=" He oído hablar de ella."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, really?!", french=" Oh, vraiment?!", german=" Oh, wirklich?!?", italian=" Oh, davvero?!", spanish=" ¡¿De verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, really?!", french=" Oh, vraiment?!", german=" Oh, wirklich?!?", italian=" Oh, davvero?!", spanish=" ¡¿De verdad?!"})
  else
  SkySceneKit.say({english=" Oh, really?!", french=" Oh, vraiment?!", german=" Oh, wirklich?!?", italian=" Oh, davvero?!", spanish=" ¡¿De verdad?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] is truly a place\nof legend...", french="Les [CS:P]Terres Illusoires[CR]\nsont une contrée légendaire...", german="Das [CS:P]Verborgene Land[CR] ist\nein wahrlich legendärer Ort.", italian="La [CS:P]Terra Nascosta[CR] è davvero\nun posto leggendario...", spanish="La [CS:P]Tierra Oculta[CR] es un lugar\nlegendario..."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="It is tattered lore at best,\nhanded down by oral tradition...", french="C'est une vieille légende\npoussiéreuse qui se transmet de génération\nen génération... Elle n'a rien de vrai.", german="Es ist eine bestenfalls\nlückenhafte Überlieferung, von Mund zu Mund\nweitererzählt.", italian="Ne sono rimaste solo poche\nnotizie, tramandate dalla tradizione orale...", spanish="Solo aparece en las historias\norales y poco fiables que se han transmitido\nde generación en generación..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No matter! Please tell us!", french="Peu importe! Raconte-nous,\ns'il te plaît!", german="Macht nichts! Bitte erzähle sie\nuns!", italian=" Non importa! Diccele per favore!", spanish="¡No importa!\n¡Cuéntanos lo que sepas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No matter! Please tell us!", french="Peu importe! Raconte-nous,\ns'il te plaît!", german="Macht nichts! Bitte erzähle sie\nuns!", italian=" Non importa! Diccele per favore!", spanish="¡No importa!\n¡Cuéntanos lo que sepas!"})
  else
  SkySceneKit.say({english=" No matter! Please tell us!", french="Peu importe! Raconte-nous,\ns'il te plaît!", german="Macht nichts! Bitte erzähle sie\nuns!", italian=" Non importa! Diccele per favore!", spanish="¡No importa!\n¡Cuéntanos lo que sepas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Of course.[K] I can tell you only\nwhat I have heard.", french="Bien sûr.[K] Mais je ne peux vous\nraconter que ce que j'ai moi-même entendu\ndire à ce sujet.", german="Selbstverständlich.[K] Ich kann\neuch nur erzählen, was ich weiß.", italian="Certo.[K] Posso solo dirvi quello\nche ho sentito a proposito.", spanish="Por supuesto.[K]\nAunque solo son leyendas que me han llegado\nde oídas..."})
  -- message_KeyWait
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] lies beyond the\nsea...[K]in a hidden place, so the story goes.", french="L'histoire raconte que les [CS:P]Terres\nIllusoires[CR] se trouvent par-delà les mers...[K]\ndans un lieu secret.", german="Das [CS:P]Verborgene Land[CR] liegt\njenseits des Ozeans,[K] an einem versteckten\nOrt. So geht die Geschichte.", italian="La [CS:P]Terra Nascosta[CR] si trova\noltre il mare...[K] in un posto segreto.\nCosì narra la leggenda.", spanish="La [CS:P]Tierra Oculta[CR] se esconde tras\nel mar...[K] en un lugar recóndito, según dicen."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A hidden place?", french=" Un lieu secret?", german=" Ein versteckter Ort?", italian=" Un posto segreto?", spanish=" ¿Un lugar recóndito?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A hidden place?", french=" Un lieu secret?", german=" Ein versteckter Ort?", italian=" Un posto segreto?", spanish=" ¿Un lugar recóndito?"})
  else
  SkySceneKit.say({english=" A hidden place?", french=" Un lieu secret?", german=" Ein versteckter Ort?", italian=" Un posto segreto?", spanish=" ¿Un lugar recóndito?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Así es."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="The [CS:P]Hidden Land[CR] allows only\nthe chosen to find it.", french="Seuls les élus peuvent atteindre\nles [CS:P]Terres Illusoires[CR].", german="Das [CS:P]Verborgene Land[CR] erlaubt nur\nden Auserwählten, es zu finden.", italian="L'accesso alla [CS:P]Terra Nascosta[CR]\nè permesso solo ai prescelti.", spanish="Solo ciertos elegidos pueden\nllegar a la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="To go there, one must possess\ncertain qualities.", french="Pour y aller, il faut posséder\ncertaines qualités.", german="Um dort hinzugelangen, muss\nman über bestimmte Qualifikationen verfügen.", italian="Per poterci andare, è necessario\npossedere determinate qualità.", spanish="Para ir allí, es necesario\ncumplir cierto requisito..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh... A place that only someone\nwith proper qualifications can go to...", french="Oh... un lieu accessible\nuniquement à qui possède les aptitudes\nrequises...", german="Oh! Ein Ort, zu dem nur jemand\nmit den richtigen Qualifikationen gelangen\nkann...", italian="Oh... Un posto a cui ha accesso\nsolo chi soddisfa specifici requisiti...", spanish="¿Así que hay que cumplir\nun requisito para ir allí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh... A place that only someone\nwith proper qualifications can go to...", french="Oh... un lieu accessible\nuniquement à qui possède les aptitudes\nrequises...", german="Oh! Ein Ort, zu dem nur jemand\nmit den richtigen Qualifikationen gelangen\nkann...", italian="Oh... Un posto a cui ha accesso\nsolo chi soddisfa specifici requisiti...", spanish="¿Así que hay que cumplir\nun requisito para ir allí?"})
  else
  SkySceneKit.say({english="Oh... A place that only someone\nwith proper qualifications can go to...", french="Oh... un lieu accessible\nuniquement à qui possède les aptitudes\nrequises...", german="Oh! Ein Ort, zu dem nur jemand\nmit den richtigen Qualifikationen gelangen\nkann...", italian="Oh... Un posto a cui ha accesso\nsolo chi soddisfa specifici requisiti...", spanish="¿Así que hay que cumplir\nun requisito para ir allí?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right, [CS:N]Torkoal[CR].[K] What are\nthose qualifications?", french="Très bien, [CS:N]Chartor[CR].[K] Quelles sont\nces aptitudes?", german="Alles klar, [CS:N]Qurtel[CR].[K] Was sind das\nfür Qualifikationen?", italian="Va bene, [CS:N]Torkoal[CR].[K] Quali sono\nquesti requisiti?", spanish="Entendido, [CS:N]Torkoal[CR].[K]\n¿Y cuál es ese requisito?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="OK, [CS:N]Torkoal[CR].[K] What are those\nqualifications?", french="Très bien, [CS:N]Chartor[CR].[K] Quelles sont\nces aptitudes?", german="Okay, [CS:N]Qurtel[CR].[K] Was sind das\nfür Qualifikationen?", italian="Ok, [CS:N]Torkoal[CR].[K] Quali sono questi\nrequisiti?", spanish="Entendido, [CS:N]Torkoal[CR].[K]\n¿Y cuál es ese requisito?"})
  else
  SkySceneKit.say({english="OK, [CS:N]Torkoal[CR].[K] What are those\nqualifications?", french="Très bien, [CS:N]Chartor[CR].[K] Quelles sont\nces aptitudes?", german="Okay, [CS:N]Qurtel[CR].[K] Was sind das\nfür Qualifikationen?", italian="Ok, [CS:N]Torkoal[CR].[K] Quali sono questi\nrequisiti?", spanish="Entendido, [CS:N]Torkoal[CR].[K]\n¿Y cuál es ese requisito?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(200) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" They are...", french=" Elles sont...", german=" Es sind...", italian=" Sono...", spanish=" Pues..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Er...[K] Er...[K] Now what were they?", french="Euh...[K] euh...[K] qu'est-ce\nque c'était déjà?", german="Ähm...[K] Öhm...[K] Was waren das\nnoch mal für Qualifikationen?", italian="Ehm...[K] Ehm...[K] Già, quali\nerano?", spanish=" Esto...[K] Yo...[K] ¿Cuál era?"})
  -- message_Close
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I'm sorry.[K] It's slipped my mind.", french="Ça m'est sorti de la tête.[K]\nDésolé.", german="Tut mir leid.[K] Das ist mir\nentfallen.", italian="Mi dispiace.[K] Mi sono sfuggiti di\nmente.", spanish=" Lo siento.[K] Ya no lo recuerdo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? You forgot?", french=" Hein? Tu as oublié?", german=" Du hast es vergessen?", italian=" Eh? Li hai dimenticati?", spanish=" ¿Qué? ¿Se te ha olvidado?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh no! You've forgotten?!", french=" Hein? Tu as oublié?", german=" Oh nein! Du hast es vergessen?", italian=" Oh no! Te li sei dimenticati?!", spanish=" ¿Qué? ¿Se te ha olvidado?"})
  else
  SkySceneKit.say({english=" Oh no! You can't remember?!", french=" Hein? Tu as oublié?", german="Oh nein! Du kannst dich nicht\nerinnern?", italian=" Oh no! Non te li ricordi?!", spanish=" ¡¿No lo recuerdas?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Please, [CS:N]Torkoal[CR]! Please\nremember!", french="S'il te plaît, [CS:N]Chartor[CR]!\nFais un effort!", german="Bitte, [CS:N]Qurtel[CR]! Bitte erinnere\ndich!", italian="Per favore, [CS:N]Torkoal[CR]! Ti prego,\nricorda!", spanish="¡[CS:N]Torkoal[CR], por favor!\n¡Tienes que acordarte!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Please, [CS:N]Torkoal[CR]! Please\nremember!", french="S'il te plaît, [CS:N]Chartor[CR]!\nFais un effort!", german="Bitte, [CS:N]Qurtel[CR]! Bitte erinnere\ndich!", italian="Per favore, [CS:N]Torkoal[CR]! Ti prego,\ncerca di ricordare!", spanish="¡[CS:N]Torkoal[CR], por favor!\n¡Tienes que acordarte!"})
  else
  SkySceneKit.say({english="Please, [CS:N]Torkoal[CR]! Please\nremember!", french="S'il te plaît, [CS:N]Chartor[CR]!\nFais un effort!", german="Bitte, [CS:N]Qurtel[CR]! Bitte erinnere\ndich!", italian="Per favore, [CS:N]Torkoal[CR]! Ti prego,\nricorda!", spanish="¡[CS:N]Torkoal[CR], por favor!\n¡Tienes que acordarte!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's really important.", french="C'est de la plus haute\nimportance.", german=" Es ist wirklich wichtig.", italian=" È davvero importante.", spanish=" Es realmente importante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is really important.", french="C'est de la plus haute\nimportance.", german=" Es ist wirklich wichtig.", italian=" È davvero importante.", spanish=" Esto es realmente importante."})
  else
  SkySceneKit.say({english=" This is really important.", french="C'est de la plus haute\nimportance.", german=" Es ist wirklich wichtig.", italian=" È davvero importante.", spanish=" Esto es realmente importante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="That's easy for you to say,\nbut...[K] Er...um...", french="Facile à dire, mais...[K]\neuh... hmm...", german="Ihr sagt das so leicht, aber...[K]\nÄhm... Öhm....", italian=" Facile dirlo, ma...[K] Ehm... Uhm...", spanish="Eso resulta muy fácil decirlo,\npero...[K] Esto... Hum..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Oh! That's it![K] You need proof!", french="Oh! Ça y est, j'y suis!\nIl vous faut une preuve!", german="Oh! Das war es![K] Ihr braucht\neinen Nachweis!", italian="Ah! Ora ricordo![K] Avete bisogno\ndi una prova!", spanish="¡Oh! ¡Eso es![K]\n¡Necesitáis pasar una prueba!"})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="You needed proof of some sort...\nYes, that was it. Proof.", french="Une sorte de preuve...\nOui, c'est bien ça. Une preuve.", german="Ihr braucht irgendeinen\nNachweis. Ja, das war es. Ein Nachweis.", italian="Avete bisogno di una prova di un\ncerto tipo... Sì, era così. Una prova.", spanish="Una prueba de algún tipo...\nSí, eso es. Necesitáis probar algo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Proof?[K] What kind of proof?", french="Une preuve?[K] Quel genre de\npreuve?", german="Ein Nachweis?[K] Ein Nachweis\nworüber?", italian="Una prova?[K] Che genere di\nprova?", spanish=" ¿Prueba?[K] ¿Qué tipo de prueba?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Proof?[K] What kind of proof?", french="Une preuve?[K] Quel genre de\npreuve?", german="Ein Nachweis?[K] Ein Nachweis\nworüber?", italian="Una prova?[K] Che genere di\nprova?", spanish=" ¿Prueba?[K] ¿Qué tipo de prueba?"})
  else
  SkySceneKit.say({english=" Proof?[K] What kind of proof?", french="Une preuve?[K] Quel genre de\npreuve?", german="Ein Nachweis?[K] Ein Nachweis\nworüber?", italian="Una prova?[K] Che genere di\nprova?", spanish=" ¿Prueba?[K] ¿Qué tipo de prueba?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(200) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" That would be...", french=" Voyons...", german=" Das wäre ein Nachweis über...", italian=" Dovrebbe essere...", spanish=" Pues..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Er?[K] Um?", french=" Euh...[K] Hmmm.", german=" Ähm?[K] Öhm?", italian=" Eh?[K] Uhm?", spanish=" Esto...[K] ¿Eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_kootasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" Forgive me.[K] I've forgotten again.", french=" Excusez-moi.[K] J'ai encore oublié.", german="Seid mir nicht böse.[K] Ich habe es\nwieder vergessen.", italian="Me ne sono dimenticato.[K] Me\nne sono dimenticato di nuovo.", spanish="Perdonadme.[K]\nTambién lo he olvidado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What? You can't remember?!", french=" Hein? Tu as oublié?", german="Was? Du kannst dich nicht\nerinnern?", italian=" Cosa? Non te lo ricordi?!", spanish=" ¿Qué? ¡¿No lo recuerdas?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? You can't remember?!", french=" Hein? Tu as oublié?", german="Was? Du kannst dich nicht\nerinnern?", italian=" Cosa? Non te lo ricordi?!", spanish=" ¿Qué? ¡¿No lo recuerdas?!"})
  else
  SkySceneKit.say({english=" What? You can't remember?!", french=" Hein? Tu as oublié?", german="Was? Du kannst dich nicht\nerinnern?", italian=" Cosa? Non te lo ricordi?!", spanish=" ¿Qué? ¡¿No lo recuerdas?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kootasu, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" I... I'm sorry to disappoint you.", french="Je... je suis désolé de ne pas\npouvoir vous aider davantage.", german="Es... Es tut mir leid, euch\nenttäuschen zu müssen.", italian=" Mi... dispiace deludervi.", spanish=" Yo... Siento decepcionaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh, all right.[K] Can you recall\nanything else at all?", french="Bon, d'accord.[K] Tu ne te\nsouviens de rien d'autre?", german="Umpf, na gut.[K] Kannst du dich\nnoch an irgendetwas anderes erinnern?", italian="Uh, va bene.[K] Riesci a ricordare\nqualcos'altro?", spanish="Bueno, vale...[K]\n¿Recuerdas alguna otra cosa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh, all right.[K] Can you recall\nanything else at all?", french="Bon, d'accord.[K] Tu ne te\nsouviens de rien d'autre?", german="Umpf, na gut.[K] Kannst du dich\nnoch an irgendetwas anderes erinnern?", italian="Uh, va bene.[K] Riesci a ricordare\nqualcos'altro?", spanish="Bueno, vale...[K]\n¿Recuerdas alguna otra cosa?"})
  else
  SkySceneKit.say({english="Ugh, all right.[K] Can you recall\nanything else at all?", french="Bon, d'accord.[K] Tu ne te\nsouviens de rien d'autre?", german="Umpf, na gut.[K] Kannst du dich\nnoch an irgendetwas anderes erinnern?", italian="Uh, va bene.[K] Riesci a ricordare\nqualcos'altro?", spanish="Bueno, vale...[K]\n¿Recuerdas alguna otra cosa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english=" ...No. That's all.", french=" ... Non. C'est tout.", german=" Nein. Das war alles.", italian=" No. È tutto quello che ricordo.", spanish=" No. Me temo que eso es todo."})
  pcall(function() UI:SetSpeaker(npc_npc_kootasu) end)
  SkySceneKit.say({english="Forgive me, youngsters. If I\nrecall what proof you need, I'll be sure to\nlet you know.", french="Excusez-moi, jeunes gens.\nSi ça me revient, je vous le ferai savoir.", german="Vergebt mir, Kinder. Falls mir\neinfallen sollte, welche Art von Nachweis man\nbraucht, lasse ich es euch wissen.", italian="Perdonatemi, giovani Pokémon.\nSe dovessi ricordarmi di che prova avete\nbisogno, ve lo farò sapere.", spanish="Perdonad a este anciano...\nSi recuerdo lo que queréis saber, me pondré\nen contacto con vuestro [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes, please. Thank you, [CS:N]Torkoal[CR].", french="Ce serait vraiment gentil. Merci\nbeaucoup, [CS:N]Chartor[CR].", german=" Ja, bitte. Danke, [CS:N]Qurtel[CR].", italian=" Sì, per favore. Grazie, [CS:N]Torkoal[CR].", spanish="Te lo agradeceríamos un montón.\nMuchas gracias, [CS:N]Torkoal[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes, please. Thank you, [CS:N]Torkoal[CR].", french="Ce serait vraiment gentil. Merci\nbeaucoup, [CS:N]Chartor[CR].", german=" Ja, bitte. Danke, [CS:N]Qurtel[CR].", italian=" Sì, per favore. Grazie, [CS:N]Torkoal[CR].", spanish="Te lo agradeceríamos\nenormemente. Muchas gracias, [CS:N]Torkoal[CR]."})
  else
  SkySceneKit.say({english=" Yes, please. Thank you, [CS:N]Torkoal[CR].", french="Ce serait vraiment gentil. Merci\nbeaucoup, [CS:N]Chartor[CR].", german=" Ja, bitte. Danke, [CS:N]Qurtel[CR].", italian=" Sì, per favore. Grazie, [CS:N]Torkoal[CR].", spanish="Te lo agradeceríamos de todo\ncorazón. Muchas gracias, [CS:N]Torkoal[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go back to the guild,\n[hero].", french="On retourne à la Guilde,\n[hero].", german="Lass uns zur Gilde zurückgehen,\n[hero].", italian="Torniamo alla Gilda,\n[hero].", spanish="Volvamos al [CS:N]Pokégremio[CR],\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go back to the guild,\n[hero].", french="On retourne à la Guilde,\n[hero].", german="Wir sollten zur Gilde\nzurückgehen, [hero].", italian="Dovremmo tornare alla Gilda,\n[hero].", spanish="Volvamos al [CS:N]Pokégremio[CR],\n[hero]."})
  else
  SkySceneKit.say({english="Let's go back to the guild,\n[hero].", french="On retourne à la Guilde,\n[hero].", german="Lass uns zur Gilde zurückgehen,\n[hero].", italian="Torniamo alla Gilda,\n[hero].", spanish="Volvamos al [CS:N]Pokégremio[CR],\n[hero]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
