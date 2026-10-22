-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P05C/n02a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P05C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 208, 360, Direction.Up, "NPC_PERAPPU")
  GROUND:MoveToPosition(npc_npc_perappu, 204, 220, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Sorry to have kept you waiting.[K]\nHere's your Perfect Apple! ♪", french="Désolé de vous avoir fait\nattendre.[K] Voici votre Pomme Parfaite! ♪", german="Entschuldigung, dass es so lange\ngedauert hat.[K] Hier, der Perfekte Apfel! ♪", italian="Mi scusi se l'ho fatta attendere.[K]\nEcco la sua Mela Perfetta! ♪", spanish="Perdona por hacerte esperar.[K]\n¡Aquí tienes tu Manzana Perfecta! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_ChangeVolume(30, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() SOUND:PlayBGM("Guildmaster Wigglytuff.ogg", true) end)
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 208, 200, Direction.Down, "NPC_PUKURIN")
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yay! ♪[K] Thank you! ♪", french=" Youpla! ♪[K] Merci! ♪", german=" Juchhu! ♪[K] Vielen Dank! ♪", italian=" Evviva! ♪[K] Grazie! ♪", spanish=" ¡Bieeen! ♪[K] ¡Gracias! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(15)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- GAP: SetEffect EFFECT_APPLE_ON_HEAD — VFX sans émote PMDO équivalente
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(55)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is the last time!", french=" C'est la dernière fois!", german=" Das ist das letzte Mal!", italian=" Questa è l'ultima volta!", spanish=" ¡Pero que conste que es la última vez!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Each night I sneak away from\neveryone and bring you a Perfect Apple\nfrom storage...", french="Toutes les nuits je me glisse\ndans la cuisine à l'insu de tous pour vous\nrapporter une Pomme Parfaite.", german="Jede Nacht schleiche ich mich in\nden Vorratsraum, nur um dir einen Perfekten\nApfel von dort zu holen...", italian="Ogni notte non faccio che\nallontanarmi furtivamente da tutti gli altri\ne portarle una Mela Perfetta dal deposito...", spanish="Cada noche me toca escabullirme\npara traerte una Manzana Perfecta\nde la despensa..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" I'm fed up with it!", french=" Trop c'est trop!", german=" Das reicht mir!", italian=" Non ne posso più!", spanish=" ¡Esto no puede seguir así!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Please, let me stop doing this!", french="Je vous demande de\nm'affranchir de cette tâche ingrate!", german="Bitte erlaube mir, damit\naufzuhören!", italian="La prego, non mi chieda più\ndi farlo!", spanish="¡Ya no quiero tener que\nhacerlo más!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I'm begging![K]\n(...That is, the Guildmaster...[K]would sneak in\nand eat one anyway if I didn't bring him one...)", french="Je vous en prie![K]\n(... De toute façon...[K] le Maître irait se servir\nlui-même, si je ne lui en apportais pas...)", german="Bitte![K] (Obwohl...[K] Wie ich ihn\nkenne, wird sich der Gildenmeister dann selbst\num einen Perfekten Apfel kümmern...)", italian="La supplico![K] (... Comunque, anche\nse mi rifiutassi...[K] il Capitano sarebbe capace\ndi entrare nel deposito e mangiarsene una...)", spanish="¡Te lo suplico![K]\n(Creo que el Gran Bluff...[K] iría a la\ndespensa él mismo si no se la trajera...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(9485) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- Slide2PositionMark<object OBJECT_P22P01A1_392> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(18) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "exclaim", 1) end)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_perappu, Direction.Right)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- bgm2_ChangeVolume(30, 256) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Oh!", french=" Oh!", german=" Oh!", italian=" Oh!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(npc_npc_pukurin, 240, 212, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(4)
  GROUND:MoveToPosition(npc_npc_perappu, 220, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Is this...[K]a [CS:Z]Defend Globe[CR]?", french=" Est-ce là...[K] une [CS:Z]Défensphère[CR]?", german=" Ist das...[K] ein [CS:Z]Abwehrglobus[CR]?", italian=" Questo è...[K] un [CS:Z]Globodifesa[CR]?", spanish=" ¿Es eso...[K] un [CS:Z]Globodefensa[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(15)
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="...[K]It's all right.[K]\nIt's not damaged.", french="...[K] Tout va bien.[K]\nElle n'est pas endommagée.", german="...[K]Alles in Ordnung.[K]\nIst nicht kaputtgegangen.", italian="...[K] Bene.[K]\nNon è danneggiato.", spanish="Bueno...[K] Menos mal.[K]\nNo le ha pasado nada."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(8)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="That's good. ♪[K] I thought it got\nchipped or broken when I dropped it. ♪", french="Parfait. ♪[K] J'ai eu peur qu'elle\nse fêle ou se brise en tombant. ♪", german="Wie schön. ♪[K] Ich dachte\nschon, er würde zersplittern oder\nzerbersten, wenn er mir runterfällt. ♪", italian="Meno male. ♪[K] Pensavo che si\nfosse sbeccato o addirittura rotto quando\nmi è caduto. ♪", spanish="Qué susto. ♪[K] Temía que se\nhubiera desconchado o roto al caerse. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hee-hee! That's kind of a rare\nitem for you, Guildmaster. ♪", french="Mazette! C'est étonnant de vous\nvoir avec un objet de cette valeur, Maître. ♪", german="Hi-hi! Dieses Item ist dir wohl\nsehr teuer, Gildenmeister. ♪", italian="Ih ih! Quello strumento è\npiuttosto importante per lei, Capitano. ♪", spanish="¡Ji, ji! La verdad es que guardas\nese objeto como oro en paño, Gran Bluff. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You're usually pretty rough with\nitems, Guildmaster...", french="D'habitude, vous n'êtes pas\naussi soigneux, Maître...", german="Normalerweise gehst du doch gar\nnicht so zimperlich mit Items um.", italian="Di solito non presta molta\nattenzione a queste cose...", spanish="Normalmente eres más descuidado\ncon los objetos..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But it's nice to see there is an\nitem that you take good care of. ♪", french="Mais je suis content de voir\nqu'il y a un objet auquel vous tenez. ♪", german="Aber schön zu sehen, dass es\nItems gibt, die du hegst und pflegst. ♪", italian="Ma è bello vedere quanto le stia\na cuore quello strumento, Capitano. ♪", spanish="Así que me alegro de ver que\ncuidas tan bien de ese objeto. ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Guildmaster is always taking\ncare of Perfect Apples... (...That is, he's like\nthat again today.)", french="Il n'y a que les Pommes\nParfaites qui vous intéressent, d'habitude.", german="Um Perfekte Äpfel kümmerst\ndu dich immer gut, Gildenmeister.\n(...Jeden Tag aufs Neue.)", italian="Di solito lei pensa sempre alle\nMele Perfette... (... Come oggi, del resto.)", spanish="Aunque es cierto que también\ncuidas mucho de las Manzanas Perfectas...\n(Antes de comértelas, al menos...)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="That is, it seems like that\n[CS:Z]Defend Globe[CR] is a very precious\nexclusive item, isn't it?", french="Ma foi, il semblerait que cette\n[CS:Z]Défensphère[CR] soit un objet très précieux,\nn'est-ce pas?", german="Aber der [CS:Z]Abwehrglobus[CR] ist wohl\nein ganz besonders wertvolles, exklusives\nItem, nicht wahr?", italian="Quindi sembra che quel\n[CS:Z]Globodifesa[CR] sia uno Strumento Esclusivo\nmolto prezioso per lei, non è vero?", spanish="Aun así, parece que ese\n[CS:Z]Globodefensa[CR] tiene mucho valor para ti,\n¿no es así?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But...[K] This item only has an\neffect on Bug-type Pokémon...", french="Mais...[K] cet objet n'affecte que\nles Pokémon de type Insecte...", german="Nur...[K]\nDas Item wirkt nur bei Käfer-Pokémon...", italian="Però...[K] ne traggono beneficio\nsolo i Pokémon di tipo Coleottero...", spanish="Pero...[K] Es un objeto que solo\nafecta a los Pokémon de tipo Bicho..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="So even though you're holding on\nto it, Guildmaster, it's not very useful, is it?", french="Maître, cet objet ne vous est\npas très utile, non?", german="Für dich ist es also nicht\nsonderlich hilfreich. Aber trotzdem gibst\ndu derart acht darauf?", italian="Quindi anche se se lo porta\nsempre appresso, Capitano, non è che\nsia molto efficace, vero?", spanish="Así que, por más que lo aprecies,\nno es muy útil, ¿no?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yes.[K] I know you're right...", french=" C'est vrai.[K] Tu as raison...", german="Ja.[K] Was du sagst,\nstimmt haargenau...", italian=" Sì.[K] Effettivamente hai ragione...", spanish=" Ya.[K] Sé que tienes razón..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_pukurin, Direction.Down)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" But this is a special thing.", french=" Mais ce truc-là est spécial.", german="Aber es ist wirklich ein\neinzigartiges Item.", italian="... ma si tratta di uno strumento\nspeciale.", spanish=" Es muy especial para mí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Special thing?", french=" Spécial?", german=" Einzigartig?", italian=" Speciale?", spanish=" ¿Especial?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Yep. ♪ Special thing.", french=" Oui, oui. ♪ Spécial.", german=" Genau. ♪ Einzigartig.", italian=" Già. ♪ Speciale.", spanish=" Sí. ♪ Es de lo más especial."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="It's why...[K] When I decided to\nbecome an explorer...", french="C'est grâce...[K] c'est grâce à\nça que tout a commencé...", german="Dieser Globus ist der Grund,[K]\naus dem ich mich entschlossen habe,\nErkunder zu werden.", italian="È il motivo...[K] per cui ho deciso\ndi diventare un esploratore...", spanish="Representa...[K] el momento en que\ndecidí convertirme en un explorador..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" The starting point.", french=" Que tout a commencé...", german=" Der Grundstein sozusagen.", italian=" Il punto di partenza.", spanish=" El punto de partida."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
