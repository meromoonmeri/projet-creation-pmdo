-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m16a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Ahem...[K] About the attempt to\ncapture [CS:N]Grovyle[CR]...", french="Hum...[K] En ce qui concerne\nla capture de [CS:N]Massko[CR]...", german="Ähem...[K] Was die versuchte\nFestnahme von [CS:N]Reptain[CR] angeht...", italian="Ahem...[K] A proposito del piano\nper acciuffare [CS:N]Grovyle[CR]...", spanish="Ejem...[K] Con respecto al plan de\ncaptura de [CS:N]Grovyle[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We have yet to receive word\nthat [CS:N]Grovyle[CR] has been captured.", french="Aucune nouvelle ne nous est\nencore parvenue.", german="Wir warten noch auf die\nInformation, ob [CS:N]Reptain[CR] gefasst wurde.", italian="Stiamo ancora aspettando di\nricevere notizie della sua cattura.", spanish="Aún no sabemos si [CS:N]Grovyle[CR]\nha sido capturado."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I understand that you are all\nitching for something to happen! But consider\nthis a test of your patience!", french="Je sais bien que vous avez tous\nhâte qu'il se passe quelque chose! Mais\nconsidérez ça comme une épreuve de patience!", german="Ich verstehe, dass ihr es kaum\nerwarten könnt, bis endlich etwas passiert!\nAber seht es als Geduldstest an!", italian="Attendiamo con ansia! Speriamo\nche succeda presto qualcosa.", spanish="Entiendo que todos estáis\nansiosos de que ocurra algo, pero podemos\nconsiderar esto como una prueba de paciencia."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Because we ask you to carry on\nwith your usual work! ♪", french="En attendant, poursuivez\nvos tâches quotidiennes! ♪", german="Denn wir möchten, dass ihr\nweiterhin eurer gewohnten Arbeit nachgeht! ♪", italian="Vi prego di continuare il vostro\nlavoro come al solito.", spanish="Por tanto, os pedimos que sigáis\ncon vuestro trabajo de siempre. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(7182) — id SE NDS sans portage PMDO identifié
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 424, 272, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 360, 256, Direction.UpRight, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  GAME:WaitFrames(5)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 360, 272, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 392, 272, Direction.Up, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(55)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Oh! What's that siren?!", french=" Oh! Quelle est cette sirène?!", german="Oh! Was ist das für eine\nSirene?!?", italian=" Oh! Cos'è questa sirena?!", spanish=" ¡¿Qué es esa sirena?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(240, 252, 60, false) end) -- performer/caméra
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:EntTurn(hero, Direction.DownLeft)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 424, 208, Direction.Down, "NPC_PUKURIN")
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 424, 256, Direction.Up, "NPC_BIPPA")
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 392, 256, Direction.Up, "NPC_CHIRIIN")
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownLeft)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 456, 256, Direction.Up, "NPC_KIMAWARI")
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.DownLeft)
  pcall(function() GAME:MoveCamera(240, 308, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(15)
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 216, 296, Direction.DownLeft, "NPC_DIGUDA")
  GROUND:EntTurn(npc_npc_diguda, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english=" Deputy [CS:N]Magnemite[CR] is here!", french="Le shérif adjoint [CS:N]Magnéti[CR]\nest ici!", german=" Wachtmeister [CS:N]Magnetilo[CR] ist da!", italian=" L'agente [CS:N]Magnemite[CR] è qui!", spanish="¡El ayudante [CS:N]Magnemite[CR]\nha llegado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  GROUND:EntTurn(npc_npc_diguda, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 400, 200, Direction.Down, "NPC_KOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end) -- message_SetActor(ACTOR_NPC_KOIRU)
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! This is a message from\nOfficer [CS:N]Magnezone[CR]. Zzzt!", french="Zzzt! Ceci est un message\ndu shérif [CS:N]Magnézone[CR]. Zzzt!", german="Zzzt! Dies ist eine Nachricht von\nOberwachtmeister [CS:N]Magnezone[CR]. Zzzt!", italian="Zzzt! Questo è un messaggio del\nCommissario [CS:N]Magnezone[CR]. Zzzt!", spanish="¡Bzz! Este es un mensaje del\nagente [CS:N]Magnezone[CR]. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(240, 252, 60, false) end) -- performer/caméra
  pcall(function() GAME:MoveCamera(420, 252, 60, false) end) -- performer/caméra
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! We are pleased to deliver\nthis report! Zzzt!", french="Zzzt! Nous sommes enchantés\nde faire ce rapport! Zzzt!", german="Zzzt! Wir freuen uns, diese\nNachricht überbringen zu können! Zzzt!", italian="Zzzt! Siamo lieti di annunciare\nquanto segue! Zzzt!", spanish="¡Bzz! ¡Nos complace comunicar\nesta noticia! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! [CS:N]Grovyle[CR] has finally been\ncaptured! Zzzt!", french="Zzzt! [CS:N]Massko[CR] a enfin\nété appréhendé! Zzzt!", german="Zzzt! [CS:N]Reptain[CR] wurde endlich\ngefasst! Zzzt!", italian="Zzzt! [CS:N]Grovyle[CR] è stato finalmente\narrestato! Zzzt!", spanish="¡Bzz! ¡[CS:N]Grovyle[CR] ha sido capturado\npor fin! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Whoa! At LAST!", french=" Waouh! ENFIN!", german=" Boah! ENDLICH!", italian=" Wow! Finalmente!", spanish=" ¡Vaya! ¡Por fin!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" By gosh! [CS:N]Grovyle[CR]'s been caught!", french=" Sapristi! On a attrapé [CS:N]Massko[CR]!", german="Donnerwetter! [CS:N]Reptain[CR] wurde\ngeschnappt!", italian=" Ohibò! Hanno preso [CS:N]Grovyle[CR]!", spanish="¡Bien! ¡[CS:N]Grovyle[CR] ha sido\ncapturado!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Oh my gosh! They did it! Yippee!", french="Ben mince alors! Il a réussi!\nYoupiii!", german="Auweia! Er hat es geschafft!\nJuchhu!", italian=" Shock! Ce l'hanno fatta! Yuppi!", spanish=" ¡Superguay! ¡Lo lograron!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end) -- message_SetActor(ACTOR_NPC_KOIRU)
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english=" Zzzt! There's more! Zzzt!", french=" Zzzt! Ce n'est pas tout! Zzzt!", german=" Zzzt! Das ist nicht alles! Zzzt!", italian=" Zzzt! C'è dell'altro! Zzzt!", spanish=" ¡Bzz! ¡Aún hay más! ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! [CS:N]Grovyle[CR] was captured\nby the great [CS:N]Dusknoir[CR]. Zzzt!", french="Zzzt! C'est le grand [CS:N]Noctunoir[CR]\nqui a mis la main sur [CS:N]Massko[CR]. Zzzt!", german="Zzzt! [CS:N]Reptain[CR] wurde von\ndem großen [CS:N]Zwirrfinst[CR] gefasst. Zzzt!", italian="Zzzt! [CS:N]Grovyle[CR] è stato catturato\ndal grande [CS:N]Dusknoir[CR]. Zzzt!", spanish="¡Bzz! [CS:N]Grovyle[CR] ha sido capturado\npor el gran [CS:N]Dusknoir[CR]. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He has informed us that he\nwill return to the future with [CS:N]Grovyle[CR]! Zzzt!", french="Zzzt! Il nous a informés\nde son intention de l'emmener\ndans le futur avec lui! Zzzt!", german="Zzzt! Wie er uns mitgeteilt hat,\nwird er mit [CS:N]Reptain[CR] in die Zukunft\nzurückkehren! Zzzt!", italian="Zzzt! Ci ha informato che è sua\nintenzione ritornare nel futuro e portare\n[CS:N]Grovyle[CR] con sé! Zzzt!", spanish="¡Bzz! ¡Nos ha informado de que\nregresará al futuro con [CS:N]Grovyle[CR]! ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(2, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR] is...", french=" [CS:N]Noctunoir[CR] va...", german=" [CS:N]Zwirrfinst[CR]...", italian=" [CS:N]Dusknoir[CR] intende...", spanish=" [CS:N]Dusknoir[CR] se va..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Going home?", french=" ... repartir?", german=" Er geht nach Hause?", italian=" ... tornare indietro?", spanish=" ¿A casa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Going home?", french=" ... repartir?", german=" Er geht nach Hause?", italian=" ... tornare indietro?", spanish=" ¿A casa?"})
  else
  SkySceneKit.say({english=" Going home?", french=" ... repartir?", german=" Er geht nach Hause?", italian=" ... tornare indietro?", spanish=" ¿A casa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Going back to the future...?", french=" Repartir dans le futur...?", german=" Er geht wieder in die Zukunft?", italian=" Vuole tornare nel futuro...?", spanish=" ¿De vuelta al futuro?"})
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" How do you...go back?", french=" Et comment on fait ça...?", german=" Wie soll das denn gehen?", italian=" E come... Come intende fare?", spanish=" ¿Y cómo hará para volver?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end) -- message_SetActor(ACTOR_NPC_KOIRU)
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! I do not claim to\nunderstand the process. Zzzt!", french="Zzzt! Je ne prétends pas\ncomprendre le protocole à suivre. Zzzt!", german="Zzzt! Ich habe nicht behauptet,\ndass ich das weiß. Zzzt!", italian="Zzzt! Non sono a conoscenza di\ntutti i dettagli di quest'operazione. Zzzt!", spanish="¡Bzz! Yo no es que entienda tan\ncomplejo proceso. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! But I have heard they will\nbe going through a tunnel. Zzzt! He called it a\ndimensional hole. Zzzt!", french="Zzzt! Mais il paraît qu'ils vont\nemprunter une sorte de tunnel. Le gouffre\ndimensionnel, selon ses propres termes. Zzzt!", german="Zzzt! Aber wie ich gehört habe,\nwerden sie durch einen Tunnel reisen. Zzzt!\nEr nannte es ein dimensionales Loch. Zzzt!", italian="Zzzt! Ma ho sentito dire che\nattraverseranno un tunnel. Zzzt! Ha parlato di\nun cosiddetto tunnel dimensionale. Zzzt!", spanish="¡Bzz! Pero he oído decir que van\na cruzar un túnel. ¡Bzz! Dijo que se trataba de\nun \"agujero dimensional\". ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! He opened a dimensional\nhole in the town's main square, I am told. Zzzt!", french="Zzzt! A ce qu'on dit, il a ouvert\nun gouffre dimensionnel sur la place principale\ndu bourg. Zzzt!", german="Zzzt! Soweit ich weiß, hat er\nauf dem Hauptplatz der Stadt ein\ndimensionales Loch geöffnet. Zzzt!", italian="Zzzt! Mi è stato detto che ha\nattivato un tunnel dimensionale nella piazza\nprincipale della città. Zzzt!", spanish="Me han dicho que ha abierto...\n¡Bzz! Un agujero dimensional en la plaza\ndel pueblo. ¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! [CS:N]Dusknoir[CR] told us that he\nwishes to say good-bye before he leaves. Zzzt!", french="Zzzt! [CS:N]Noctunoir[CR] veut vous dire\nau revoir avant de partir. Zzzt!", german="Zzzt! [CS:N]Zwirrfinst[CR] sagte, dass\ner sich gerne verabschieden würde, bevor er\ngeht. Zzzt!", italian="Zzzt! [CS:N]Dusknoir[CR] ha espresso il\ndesiderio di salutare tutti prima di andarsene.\nZzzt!", spanish="¡Bzz! [CS:N]Dusknoir[CR] nos ha dicho\nque quería despedirse antes de su marcha.\n¡Bzz!"})
  pcall(function() UI:SetSpeaker(npc_npc_koiru) end)
  SkySceneKit.say({english="Zzzt! Therefore, he hopes that\nyou will come see him for the last time at\nTreasure Town's square. Zzzt!", french="Zzzt! C'est pourquoi il espère\nque vous viendrez le voir une dernière fois\nsur la grand-place de Bourg-Trésor. Zzzt!", german="Zzzt! Deshalb hofft er, dass ihr\nzum Platz von Schatzstadt kommen werdet,\num ihn ein letztes Mal zu sehen. Zzzt!", italian="Zzzt! Si augura di trovarvi tutti\nnella piazza di Borgo Tesoro per un ultimo\nsaluto. Zzzt!", spanish="¡Bzz! Por eso, espera que\nvayáis a verle una última vez a la plaza\nde Aldea Tesoro. ¡Bzz!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(npc_npc_chiriin, Direction.Down)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Well, what are we\ndoing here?!", french="Eh dis donc, mais qu'est-ce\nqu'on attend?!", german="Hey, hey! Na, worauf warten\nwir dann noch?!?", italian="Ehi, ehi! Cosa stiamo\naspettando?", spanish="¡Oye, oye! Entonces, ¿qué\nestamos haciendo aquí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Come on, hurry! We have to go\nto Treasure Town!", french="Allez, on se dépêche!\nTous à Bourg-Trésor!", german="Kommt schon, schnell! Wir\nmüssen nach Schatzstadt!", italian="Coraggio, gente! Tutti a Borgo\nTesoro!", spanish="¡Vamos, rápido! ¡Tenemos que\nir a Aldea Tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's hurry! We have to go to\nTreasure Town!", french="Allez, on se dépêche!\nTous à Bourg-Trésor!", german="Beeilung! Wir müssen nach\nSchatzstadt!", italian="Sbrighiamoci! Corriamo tutti a\nBorgo Tesoro!", spanish="¡Vamos, rápido! ¡Tenemos que\nir a Aldea Tesoro!"})
  else
  SkySceneKit.say({english="Let's hurry! We have to go to\nTreasure Town!", french="Allez, on se dépêche!\nTous à Bourg-Trésor!", german="Beeilung! Wir müssen nach\nSchatzstadt!", italian="Sbrighiamoci! Corriamo tutti a\nBorgo Tesoro!", spanish="¡Vamos, rápido! ¡Tenemos que\nir a Aldea Tesoro!"})
  end
  -- message_Close
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_guregguru, 324, 188, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 188, false, 2)
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(-80), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_heigani, 324, 188, false, 2)
  do local p=npc_npc_dogoomu.Position; GROUND:MoveToPosition(npc_npc_dogoomu, p.X+(-32), p.Y+(-16), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_bippa, 324, 188, false, 2)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(-32), p.Y+(0), false, 2) end -- Move2PositionOffset
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(-80), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-80), p.Y+(-24), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-80), p.Y+(-24), false, 2) end
  GROUND:MoveToPosition(npc_npc_kimawari, 324, 188, false, 2)
  GROUND:MoveToPosition(npc_npc_dogoomu, 324, 188, false, 2)
  GAME:FadeOut(false, 30)
  GROUND:MoveToPosition(npc_npc_guregguru, 324, 132, false, 2)
  GROUND:MoveToPosition(npc_npc_chiriin, 324, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitScreenFade
  SkySceneKit.cleanup_npcs()
end
