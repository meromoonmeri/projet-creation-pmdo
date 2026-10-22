-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D52P11A/n09a0905.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TEMPORAL_PINNACLE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D52P11A) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 8, 272, Direction.Right, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  pcall(function() GAME:MoveCamera(172, 252, 60, false) end) -- performer/caméra
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 196, 244, false, 2)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 140, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- se_FadeOut(10759, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Those ice pillars stand out\nin places...", french="Ces piliers de glace qui s'élèvent\nde part et d'autre...", german="Diese Eissäulen\nsind wirklich auffällig...", italian="Quelle colonne di ghiaccio che\nemergono dal terreno...", spanish="Esas columnas de hielo llaman\nla atención..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="At the top of those pillars...[K]\nThere's something placed there...", french="Il y a quelque chose...[K]\nà leur sommet...", german="Und auf den Säulen...[K]\nDa ist etwas...", italian=" C'è qualcosa...[K] in cima...", spanish="Sobre esas columnas...[K]\nparece que hay algo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="They're crackling with\nelectricity...", french=" Ils émettent de l'électricité...", german=" Sie knistern vor Elektrizität...", italian="Sono attraversate dalla\ncorrente elettrica...", spanish="Noto cómo desprenden chispas\nde electricidad..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This is a strange place...", french=" Voilà un lieu bien étrange...", german=" Was für ein sonderbarer Ort...", italian=" Che strano posto...", spanish=" Es un lugar muy extraño..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(5)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  local npc_npc_yukiwarashi = SkySceneKit.spawn_npc("snorunt", 320, 256, Direction.DownRight, "NPC_YUKIWARASHI")
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end) -- message_SetActor(ACTOR_NPC_YUKIWARASHI)
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii.[K] Gigii.", french=" Gnignii.[K] Gnignii.", german=" Gigii.[K] Gigii.", italian=" Gigiii.[K] Gigiii.", spanish=" Guiguí.[K] Guiguí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(236, 252, 60, false) end) -- performer/caméra
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  GAME:WaitFrames(40)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(4) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-it's...[K] Who is it?!", french=" C'est...[K] Qui est-ce?!", german=" S-sind das...[K] Wer ist da?!?", italian=" C-Come...?[K] Uno [CS:N]Snorunt[CR]?!", spanish=" Es...[K] ¡¿Quién es?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.UpRight)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Relax.[K] He's different from\nthe ones we encountered before.", french="Du calme.[K] Il est différent\nde ceux que nous avons rencontrés\njusqu'à présent.", german="Ganz ruhig.[K] Er ist anders als\ndie, denen wir vorher begegnet sind.", italian="Tranquillo.[K] È diverso da quelli\nche abbiamo incontrato prima.", spanish="Tranquilízate.[K] Este es diferente\na los que nos hemos encontrado antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I know.[K] I wasn't\nlooking for revenge or anything.", french="Je sais.[K] Je ne cherche pas à\nme venger ou quoi que ce soit.", german="Ich weiß.[K] Ich wollte ihm auch\nnichts heimzahlen oder so...", italian="Lo so.[K] Non voglio certo\nvendicarmi.", spanish="Ya lo sé.[K] No pensaba vengarme de él\nni nada por el estilo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I want to talk to him.", french=" Il faut que je lui parle.", german=" Ich möchte mit ihm reden.", italian=" Voglio parlargli.", spanish=" Solo quiero preguntarle algo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" It's useless to talk.", french=" C'est inutile.", german=" Das bringt doch nichts.", italian=" È inutile.", spanish=" Es inútil hablar."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You'll just end up with another\npainful experience.", french=" Tu vas encore le regretter.", german="Du wirst nur wieder eine\nschmerzvolle Erfahrung machen.", italian="Finiresti solo per farti male\nun'altra volta.", spanish="Yo creo que vas a acabar\nuna vez más de mala manera."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But...[K] There's no trail, so we\nhave no other way...", french="Mais...[K] nous n'avons aucune\nroute à suivre, c'est le seul moyen...", german="Aber...[K] Es gibt hier keinen\nPfad, also können wir nicht anders...", italian="Ma...[K] non abbiamo altra scelta,\nnon sappiamo dove andare...", spanish="Pero...[K] no hay ningún sendero,\nasí que no podemos hacer otra cosa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Right)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Hey! You!", french=" Hé, toi!", german=" Hey! Du da!", italian=" Ehi, tu!", spanish=" ¡Oye, tú!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gii...?!", french=" Gnii...?!", german=" Gii?!?", italian=" Giii...?!", spanish=" ¡¿Gui...?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" W-wait![K] Don't run away!", french=" Attends![K] Ne pars pas!", german=" W-warte![K] Bleib hier!", italian=" A-Aspetta![K] Non agitarti!", spanish=" ¡Eh, espera![K] ¡No huyas!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I just want to talk.", french=" Je veux juste te parler.", german=" Ich möchte mich nur unterhalten.", italian=" Voglio solo parlarti.", spanish=" Solo quiero que hablemos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Gigii?", french=" Gnignii?", german=" Gigii?", italian=" Gigiii?", spanish=" ¿Guiguí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 276, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" If you know, please tell me...", french=" Dis-moi, s'il te plaît...", german="Sofern du es weißt,\nverrat mir bitte...", italian="Se sai qualcosa, ti prego\ndi dirmelo...", spanish=" Si sabes algo, cuéntamelo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Before us...[K]did anyone come\nthrough here?", french="As-tu vu...[K] quelqu'un passer par\nici avant nous?", german="Ist hier vor uns...[K]\njemand vorbeigekommen?", italian="Prima di noi...[K] è passato\nqualcuno di qua?", spanish="¿Ha pasado alguien por aquí...[K]\nantes que nosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Oh! Them!", french=" Oh! Eux!", german=" Oh! Die!", italian=" Oh! Loro!", spanish=" ¡Ah! ¡Ellos!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Yeah, I saw them!", french=" Ouais, je les ai vus!", german=" Ja, die habe ich gesehen!", italian=" Sì, li ho visti!", spanish=" ¡Sí, les he visto!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english="A bunch of scary-looking\nPokémon went through here in a group!", french="Une bande de Pokémon à donner\nla chair de poule est passée tout à l'heure!", german="Vorhin ist hier ein Haufen\nfurchterregender Pokémon vorbeigekommen!", italian="Un gruppetto di Pokémon\ndall'aria poco raccomandabile!", spanish="¡Unos Pokémon con pinta escalofriante\npasaron por aquí en grupo!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" They were [CS:N]Sableye[CR], I think...", french=" C'était des [CS:N]Ténéfix[CR], je crois...", german=" [CS:N]Zobiris[CR], soweit ich weiß...", italian="Erano dei [CS:N]Sableye[CR], se ben\nricordo...", spanish=" Creo que eran [CS:N]Sableye[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBGM("Growing Anxiety.ogg", true) end)
  pcall(function() GAME:MoveCamera(280, 252, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru_n9, 236, 268, false, 2)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-is that true?", french=" V-vraiment?", german=" I-ist das wahr?", italian=" D-Davvero?", spanish=" ¿Es cierto eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Where did they go?", french=" Où sont-ils allés?", german=" Wohin sind sie gegangen?", italian=" Dove sono andati?", spanish=" ¿Adónde han ido?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" They went that way!", french=" Par là!", german=" Sie sind dort entlang!", italian=" Da quella parte!", spanish=" ¡Fueron por allí!"})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" They went into [CS:P]Icicle Forest[CR]...", french=" Dans la [CS:P]Forêt Glaçon[CR]...", german=" Sie sind in den [CS:P]Eiszapfenwald[CR]...", italian=" Nel [CS:P]Bosco Gelido[CR]...", spanish="Penetraron en el\n[CS:P]Bosque Carámbano[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Did you see only [CS:N]Sableye[CR]?", french=" Il n'y avait que des [CS:N]Ténéfix[CR]?", german=" Hast du nur [CS:N]Zobiris[CR] gesehen?", italian=" Hai visto solo dei [CS:N]Sableye[CR]?", spanish=" ¿Solo había [CS:N]Sableye[CR]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" No.[K] It wasn't just [CS:N]Sableye[CR].", french="Non.[K] Les [CS:N]Ténéfix[CR] n'étaient\npas seuls.", german=" Nein.[K] Es waren nicht nur [CS:N]Zobiris[CR].", italian=" No.[K] Non c'erano solo loro.", spanish=" No.[K] No solo estaban los [CS:N]Sableye[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Now that you mention it.", french=" Maintenant que j'y pense...", german=" Jetzt, wo du es erwähnst...", italian=" Ora che mi ci fai pensare...", spanish=" Ahora que lo mencionas..."})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english="The [CS:N]Sableye[CR] were carrying\na Pokémon.", french="... ils portaient un autre\nPokémon.", german="Die [CS:N]Zobiris[CR] trugen\nein anderes Pokémon.", italian="... i [CS:N]Sableye[CR] stavano\ntrasportando un Pokémon.", spanish=" Los [CS:N]Sableye[CR] llevaban un Pokémon."})
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english="It was pink...[K]and very pretty,\nthat Pokémon.", french="Un Pokémon tout rose...[K] et tout\nmignon.", german="Dieses Pokémon war rosa...[K]\nund sehr hübsch.", italian="Era rosa...[K] e molto grazioso,\nquel Pokémon.", spanish=" Era un Pokémon rosa...[K] y muy bonito."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]Celebi[CR]!", french=" [CS:N]Celebi[CR]!", german=" [CS:N]Celebi[CR]!", italian=" [CS:N]Celebi[CR]!", spanish=" ¡[CS:N]Celebi[CR]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... ([CS:N]C-Celebi[CR]'s already...[K]\nbeen captured...)", french="... ([CS:N]C-Celebi[CR] a déjà été...[K]\ncapturée...)", german="...([CS:N]C-Celebi[CR] wurde...[K]\nEs wurde bereits gefangen genommen...)", italian="... ([CS:N]C-Celebi[CR] è già...[K] stata\ncatturata...)", spanish="Vaya... ([CS:N]Ce[CR]... [CS:N]Celebi[CR] ya ha sido...[K]\ncapturada...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Any other Pokémon?", french=" Y avait-il un autre Pokémon?", german=" Noch andere Pokémon?", italian=" Qualche altro Pokémon?", spanish=" ¿Había algún otro Pokémon?"})
  GROUND:EntTurn(hero, Direction.Right)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I believe there should have been\na Pokémon that looked much stronger than the\n[CS:N]Sableye[CR] with them...", french="Un Pokémon bien plus fort\net imposant que les [CS:N]Ténéfix[CR]...", german="Es hätte noch ein weiteres\nPokémon bei ihnen sein sollen, das stärker\naussieht als die [CS:N]Zobiris[CR]...", italian="Credo che con i [CS:N]Sableye[CR]\nci fosse un Pokémon dall'aria molto\npiù forte...", spanish="Yo creo que tendría que ir\ncon ellos un Pokémon de aspecto mucho\nmás fuerte que los [CS:N]Sableye[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukiwarashi) end)
  SkySceneKit.say({english=" Umm... Let me see...", french=" Euh... que je réfléchisse...", german=" Hmmm... Lass mich überlegen...", italian=" Uhm... fammi pensare...", spanish=" Ah... Déjame pensar..."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(10761) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(5)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "exclaim", 1) end)
  GAME:WaitFrames(4)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(10762) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- Destroy() [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(1024) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(4)
  GROUND:EntTurn(npc_npc_yukiwarashi, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(36) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(3)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(3)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n9, "shock", 1) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukiwarashi, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh-what!?", french=" Qu'est-ce qui se passe!?", german=" W-wie bitte?!?", italian=" C-Cosa?!", spanish=" ¡¿Qué?!"})
  -- message_Close
  pcall(function() GAME:MoveCamera(280, 148, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(60)
  -- se_FadeOut(10762, 150) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
