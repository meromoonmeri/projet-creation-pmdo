-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P42A/n03a1502.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(7170) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(7939) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  local npc_npc_aamarudo = SkySceneKit.spawn_npc("armaldo", 272, 232, Direction.Down, "NPC_AAMARUDO")
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Ow ow ow ow ow.[K]\nMy back hurts...", french="Ouille ouille ouille.[K]\nMon dos... j'ai mal...", german="Auauauauauau.[K]\nMein armer Rücken...", italian="Ahi ahi ahi ahi ahi.[K]\nLa mia schiena...", spanish="Ay, ay, ay, ay, ay.[K]\nQué dolor de espalda..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Master, are you OK?", french=" Maître, ça va?", german=" Meister, ist alles in Ordnung?", italian=" Maestro, stai bene?", spanish=" ¿Estás bien, maestro?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Y-yeah.[K] How are you, Junior?", french="Heu... oui.[K] Et toi, petit,\ntout va bien?", german=" J-ja.[K] Wie geht es dir, Junior?", italian=" S-Sì.[K] Tu come stai, piccolo?", spanish=" Sí... más o menos.[K] ¿Y tú?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm OK. ♪", french=" Ben voui. ♪", german=" Mir geht es gut. ♪", italian=" Tutto bene. ♪", spanish=" Yo estoy bien. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh, for pity's sake...[K] We seem to\nhave fallen into a pit!", french="Oh, misère de misère...[K]\nOn dirait qu'on est tombés dans un trou!", german="Oh, das ist was zum Grübeln...[K]\nAnscheinend sind wir in eine Grube gefallen!", italian="Ops...[K] Pare che siamo caduti\nin una fossa!", spanish="Qué mala pata tenemos...[K] Parece\nque hemos caído en una sima."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="P-pit...[K] Is that what this is?\nThis hole...", french="Oui...[K] Nous sommes au\nfond du trou...", german="G-grube...[K] Das ist es also?\nDieses Loch...", italian="F-Fossa...[K] È così?\nQuesta buca...", spanish="Una... sima...[K] ¿Es eso lo que es\neste agujero...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey, Master.", french=" Hé, Maître.", german=" Hey, Meister.", italian=" Ehi, maestro.", spanish=" Eh, maestro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" What is it?", french=" Qu'y a-t-il?", german=" Was ist denn?", italian=" Che c'è?", spanish=" ¿Qué pasa, peque?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Those torches...[K] It seems like\nthey weren't there to open the door...", french="Ces torches...[K] On dirait qu'elles\nne servaient pas à ouvrir la porte...", german="Diese Fackeln...[K] Sie sind wohl\nnicht dazu da, die Tür zu öffnen.", italian="Quelle torce...[K] Forse non\nservivano per aprire la porta...", spanish="Esas antorchas...[K] Parece que su\nfunción no era abrir la puerta..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Truth is, they were there to\nopen the pit...[K] It was some kind\nof trap! ♪", french="En fait, elles servaient à ouvrir\nce trou...[K] Comme un genre de piège! ♪", german="In Wahrheit haben sie die\nFalltür geöffnet...[K] Das war eine Art Falle! ♪", italian="In realtà servivano per aprire\nla fossa...[K] Era una specie di trappola! ♪", spanish="Por lo visto estaban ahí para\nhacer que cayéramos en la sima...[K] ¡No era\nmás que una trampa! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" T-trap?", french=" Un piège?", german=" F-falle?", italian=" T-Trappola?", spanish="Hum... Muy agudo, peque...\n(Y lo dice ahora, el crío...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But if this really is a trap...[K]\nIt's so dark, I can't see a thing...", french="Mais s'il s'agit vraiment d'un\npiège...[K] Il fait si sombre, je ne vois rien...", german="Aber auch, wenn es wirklich\neine Falle war...[K] Hier ist es so dunkel, dass\nich nichts erkennen kann.", italian="Ma se questa è davvero\nuna trappola...[K] È così buio qui,\nnon vedo nulla...", spanish="Pero si es una trampa...[K]\nEstá muy oscuro, no veo ni torta..."})
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Truth is...[K] We seem to have\nlanded ourselves in a difficult position. ♪", french="Dites...[K] On dirait qu'on s'est\nmis dans un drôle de pétrin. ♪", german="Sieht fast so aus, als seien\nwir in eine schwierige Situation geraten. ♪", italian="A quanto pare...[K] siamo finiti\nin una situazione piuttosto complicata. ♪", spanish="La verdad es que...[K] nos hemos\nmetido en un buen aprieto. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(9474) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CS:N]???[CR]: GARURURURURURURURURURURU...", french="[CS:N]???[CR]: GROAOUROUROUROUROUROUROUUUUH...", german="[CS:N]???[CR]: GARURURURURURURURURURURU...", italian="[CS:N]???[CR]: GRRRRRRRRRRRROOOARRRRRRRRR...", spanish="[CS:N](?)[CR]: Grooooooooooooar..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  GAME:WaitFrames(10)
  -- GAP: se_Play(9738) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CN]\n[CN]ZAZA... ZAZA...", french="[CN]\n[CN]GZZZ... GZZZ...", german="[CN]\n[CN]ZAZA... ZAZA...", italian="[CN]\n[CN]ZAZA... ZAZA...", spanish="[CN]\n[CN]Zaza... Zaza..."}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey![K] I can hear something. ♪", french=" Hé![K] J'entends quelque chose. ♪", german=" Hey![K] Ich höre etwas. ♪", italian=" Ehi![K] Ho sentito qualcosa. ♪", spanish=" ¡Eh![K] He oído algo. ♪"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It seems like something's\ngetting closer. ♪", french="On dirait que ça\nse rapproche. ♪", german="Als ob etwas näherkommen\nwürde. ♪", italian="È come se qualcosa\nsi avvicinasse. ♪", spanish="Sea lo que sea, parece que\nse está acercando. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Y-you...[K] How can you stay\nso calm?", french="T-tu...[K] Comment peux-tu garder\nun tel sang-froid?", german="D-du...[K] Wie kannst du so\nruhig bleiben?", italian="M-Ma tu...[K] come fai a essere\ncosì calmo?", spanish="Pe... pero...[K] ¿Cómo puedes estar\ntan tranquilo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm not calm.", french=" Quel sang-froid?", german=" Ich bin nicht ruhig.", italian=" Non sono calmo.", spanish=" No estoy tranquilo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm incredibly...[K]excited! ♪", french=" Je suis tout excité! ♪", german="Ich bin unglaublich...[K]\naufgeregt! ♪", italian="Sono incredibilmente...[K]\nemozionato! ♪", spanish=" Estoy...[K] ¡emocionadísimo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="[CS:N]???[CR]: GWWWOOOOOOAAAaaaaaAAAAAHHHH!!!", french="[CS:N]???[CR]: GRRRRRROUAAAAAAAAAAAAAAAOUH!!!", german="[CS:N]???[CR]: GWWWOOOOOOAAAaaaaaAAAAAH!!!", italian="[CS:N]???[CR]: GRRROOOOOOAAAaaaaaAAAAAHHHH!!!", spanish="[CS:N](?)[CR]: ¡¡¡Groooaaa!!!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(45)
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  -- message_CloseEnforce
  GAME:WaitFrames(30)
  -- back_SetGround(LEVEL_D45P42A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:FadeIn(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_aamarudo, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_aamarudo.Position; GROUND:MoveToPosition(npc_npc_aamarudo, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="UWAAAAAAAaaaaaahhhhh![K]\nIt's a...[K]Monster House!", french="Yaaaaaaaaaaaaaaaaaaaah![K]\nC'est... [K]une maison de monstres!", german="UWAAAAAAAaaaaah![K]\nDas ist ein...[K] Monster-Raum!", italian="UAAAAAAAAAaaaaaahhhhhh![K]\nÈ un...[K] covo di Pokémon!", spanish="¡Uaaaah![K]\n¡Es un...[K] nido de monstruos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" They're here! ♪", french=" Ils sont nombreux! ♪", german=" Da sind sie! ♪", italian=" Ci siamo! ♪", spanish=" ¡Son un montón! ♪"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Let's do our best, Master! ♪", french="Faisons de notre mieux,\nMaître! ♪", german=" Geben wir unser Bestes! ♪", italian="Facciamo del nostro meglio,\nmaestro! ♪", spanish=" ¡Vamos a por todas, maestro! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_aamarudo, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english=" Don't we always?!", french="Mais c'est ce qu'on fait\ntoujours, pas vrai?!", german=" Machen wir das nicht immer?!?", italian=" Come sempre, no?!", spanish=" ¡¿No lo hacemos siempre?!"})
  pcall(function() UI:SetSpeaker(npc_npc_aamarudo) end)
  SkySceneKit.say({english="Don't ever let yourself be caught\nunprepared, Junior!", french="Ne te laisse jamais\nsurprendre, petit!", german="Sei niemals unvorbereitet,\nwenn es brenzlig wird, Junior!", italian="Non farti cogliere di sorpresa,\npiccolo!", spanish="¡No dejes que te cojan nunca\ncon la guardia baja, peque!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(132, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
