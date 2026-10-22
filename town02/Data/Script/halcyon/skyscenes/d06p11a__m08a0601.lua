-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V02P08A, 0, 132, 104, 7,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D06P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  -- ResetHitAttribute(31) [neutre/état moteur]
  -- ResetHitAttribute(31) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 224, 352, Direction.Right, "NPC_BIPPA")
  -- ResetHitAttribute(31) [neutre/état moteur]
  GROUND:MoveToPosition(partner, 320, 260, false, 2)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(npc_npc_bippa, 320, 260, false, 2)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(hero, 320, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 408, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_bippa, 344, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 344, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(48), g.ViewCenter.Y+(0), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow! The sea is right up this\nway, [hero]!", french="Waouh! La mer est par là,\n[hero]!", german="Wow! Das Meer ist gleich da\ndrüben, [hero]!", italian="Wow! Poco più avanti,\nda questa parte, c'è il mare, [hero]!", spanish="Vaya, ¡el mar está\nahí enfrente, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! The sea is right up this\nway, [hero]!", french="Waouh! La mer est par là,\n[hero]!", german="Wow! Das Meer ist gleich da\ndrüben, [hero]!", italian="Wow! Poco più avanti,\nda questa parte, c'è il mare, [hero]!", spanish="Vaya, ¡el mar está\nahí enfrente, [hero]!"})
  else
  SkySceneKit.say({english="Wow! The sea is right up this\nway, [hero]!", french="Waouh! La mer est par là,\n[hero]!", german="Wow! Das Meer ist gleich da\ndrüben, [hero]!", italian="Wow! Poco più avanti,\nda questa parte, c'è il mare, [hero]!", spanish="Vaya, ¡el mar está\nahí enfrente, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-48), g.ViewCenter.Y+(0), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(partner, Direction.Left)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And just look at this cliff!", french=" Regarde cette falaise!", german=" Sieh dir nur mal diese Klippe an!", italian="E date un'occhiata a questo\npromontorio!", spanish=" Menudo acantilado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And just look at this cliff!", french=" Regarde cette falaise!", german=" Sieh dir nur mal diese Klippe an!", italian="E date un'occhiata a questo\npromontorio!", spanish=" Este acantilado es increíble."})
  else
  SkySceneKit.say({english=" And just look at this cliff!", french=" Regarde cette falaise!", german=" Sieh dir nur mal diese Klippe an!", italian="E date un'occhiata a questo\npromontorio!", spanish=" Este acantilado es increíble."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yup yup! I reckon this is looking\nmore and more like a true expedition!", french="Ouaip ouaip! Ça ressemble d'plus\nen plus à une vraie expédition, pour sûr!", german="Jawollja! Das sieht mir immer\nmehr nach einer echten Expedition aus!", italian="Già, già! Questa sì che è una\nspedizione coi fiocchi!", spanish="¡Sí, señor! Esto sí empieza a\nparecerse a una expedición después de todo."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="The path ahead surely will get\ntricky, just what real explorers like to see!", french="Ça va sûrement commencer\nà se corser! Les vrais explorateurs, ils\nadorent ça!", german="Der Weg, der vor uns liegt,\nwird nicht leicht werden. Genau das Richtige\nfür wahre Erkunder!", italian="Più avanti le cose si faranno più\ndifficili, proprio come piace ai veri\nesploratori!", spanish="Es normal que el camino\nse vaya complicando más al avanzar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="And this...[K]this here is\nsomething well known to all us explorers...", french="Et ça...[K] ce machin, là,\nc'est un truc bien connu de nous tous,\nexplorateurs...", german="Und das...[K] Das hier ist etwas,\ndas Erkunder wie wir sofort wiedererkennen...", italian="E questa...[K] Questa che\nvedete è una cosa molto importante per noi\nesploratori...", spanish="Y esto...[K] es algo que\nconocemos bien todos los exploradores..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" It's a Kangaskhan Rock.", french=" C'est une Statue Kangourex.", german=" Ein Kangama-Speicher.", italian=" È una Statua Kangaskhan.", spanish=" Es una Roca de Kangaskhan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Kangaskhan Rock?", french=" Une Statue Kangourex?", german=" Kangama-Speicher?", italian=" Statua Kangaskhan?", spanish=" ¿Una Roca de Kangaskhan?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Kangaskhan Rock?", french=" Une Statue Kangourex?", german=" Kangama-Speicher?", italian=" Statua Kangaskhan?", spanish=" ¿Una Roca de Kangaskhan?"})
  else
  SkySceneKit.say({english=" Kangaskhan Rock?", french=" Une Statue Kangourex?", german=" Kangama-Speicher?", italian=" Statua Kangaskhan?", spanish=" ¿Una Roca de Kangaskhan?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Yes sirree, you heard right. That\nthere's a Kangaskhan Rock.", french="Pour sûr, t'as bien entendu. C'est\nune Statue Kangourex.", german="Jawollja, richtig gehört. Das da\nist ein Kangama-Speicher.", italian="Sissignore, avete capito bene.\nQuella è una Statua Kangaskhan.", spanish="Sí, señor, así es. Eso de ahí\nes una Roca de Kangaskhan."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="A Kangaskhan Rock lets you stow\nand take out items, and it lets you save a\nrecord of your progress.", french="Une Statue Kangourex, ça sert à\ndéposer des objets dans la réserve et à en\nretirer, et aussi à sauvegarder ton aventure.", german="Kangama-Speicher erlauben dir,\nItems zu lagern oder herauszunehmen, und\ndeinen Spielfortschritt zu speichern.", italian="Una Statua Kangaskhan vi\npermette di depositare e prelevare strumenti.\nServe anche per salvare il gioco.", spanish="Una Roca de Kangaskhan\nte permite almacenar y coger objetos,\ny guardar tu avance hasta el momento."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" It's a real help to travelers.", french="C'est une aide vachement\nprécieuse pour les aventuriers comme nous.", german="Sie sind für Reisende sehr\nhilfreich.", italian="È un grande aiuto per i\nviaggiatori.", spanish="Es una gran ayuda para los\nviajeros."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="...Well, I haven't had much of\na chance to use Kangaskhan Rocks...", french="... Bon, en même temps, on peut\npas dire que j'en ai déjà utilisé des tas,\ndes Statues Kangourex...", german="...Nun, ich habe noch nicht so\noft Kangama-Speicher verwendet...", italian="Beh, non che io abbia avuto\nmolte occasioni di usare le Statue Kangaskhan...", spanish="Bueno... En realidad no he tenido\nmuchas ocasiones para usar las Rocas\nde Kangaskhan..."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Reckon I shouldn't oughta talk\nlike a big shot...", french=" J'peux pas vraiment m'vanter...", german="Ich vermute, das ist nicht\ngerade ein Grund zum Prahlen...", italian="Immagino di non dovermi dare\ntutte queste arie...", spanish="Así que será mejor que no hable\nmucho, por si meto la pata..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  -- message_FacePositionOffset(-1, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Gulp...![K] I just want to say again\nthat this here's my first expedition!", french="Euh...![K] Comme j'vous l'ai déjà\ndit, c'est ma première expédition!", german="Schluck...[K] Ich wollte nur noch\nmal sagen, dass das hier meine erste\nExpedition ist!", italian="Gulp...![K] Quello che voglio dire è\nche questa è la mia prima spedizione!", spanish="Huy...[K] Solo quería deciros\nque nunca he estado en una expedición."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'm feeling kind of nervous,\nby golly.", french="Alors j'suis un chouïa nerveux,\npardi.", german="Donnerwetter, ich bin irgendwie\nnervös!", italian="Mi sento un po' nervoso,\nohibò.", spanish=" Estoy un poco nervioso..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha ha ha. That goes for us too.", french=" Ha ha ha! Nous aussi!", german=" Hahaha. Das geht uns auch so.", italian=" Ah ah ah. Anche noi.", spanish="¡Ja, ja! No te creas que eres\nel único."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha ha ha. That goes for us too.", french=" Ha ha ha! Nous aussi!", german=" Hahaha. Das geht uns auch so.", italian=" Ah ah ah. Anche noi.", spanish="Ja, ja, ja. ¡No creas que solo te\npasa a ti!"})
  else
  SkySceneKit.say({english=" Ha ha ha. That goes for us too.", french=" Ha ha ha! Nous aussi!", german=" Hahaha. Das geht uns auch so.", italian=" Ah ah ah. Anche noi.", spanish="¡Ja, ja! ¿Te piensas que solo\nte pasa a ti?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're all new at this. Let's just\ndo our best.", french="C'est notre première fois à\ntous les trois. Faisons de notre mieux!", german="Wir machen das alle zum ersten\nMal. Geben wir einfach unser Bestes.", italian="Siamo tutti dei novellini.\nFacciamo del nostro meglio!", spanish="También es nuestra primera vez.\nVamos a hacerlo lo mejor que podamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're all beginners at this.\nLet's just do our best.", french="C'est notre première fois à\ntous les trois. Faisons de notre mieux!", german="Das ist für jeden von uns etwas\nNeues. Geben wir einfach unser Bestes.", italian="Siamo tutti dei novellini.\nFacciamo semplicemente del nostro\nmeglio!", spanish="Todos somos principiantes,\npero lo haremos lo mejor que podamos."})
  else
  SkySceneKit.say({english="We're all beginners at this.\nLet's just do our best.", french="C'est notre première fois à\ntous les trois. Faisons de notre mieux!", german="Das ist für jeden von uns etwas\nNeues. Geben wir einfach unser Bestes.", italian="Siamo tutti dei novellini.\nFacciamo semplicemente del nostro\nmeglio!", spanish="Todos somos principiantes,\npero lo haremos lo mejor que podamos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 376, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's have a look at the\nWonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Sehen wir uns die Wunderkarte\nmal an.", italian="Diamo un'occhiata\nalla Mappa delle meraviglie.", spanish=" A ver el Mapa Mágico."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's check the Wonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Schlagen wir mal die\nWunderkarte auf.", italian="Diamo un'occhiata\nalla Mappa delle meraviglie.", spanish="Vamos a echar un vistazo\nal Mapa Mágico."})
  else
  SkySceneKit.say({english="Let's have a look at the\nWonder Map.", french="Jetons un coup d'œil sur la\nCarte Miracle.", german="Sehen wir uns die Wunderkarte\nmal an.", italian="Diamo un'occhiata\nalla Mappa delle meraviglie.", spanish=" Miremos el Mapa Mágico."})
  end
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
