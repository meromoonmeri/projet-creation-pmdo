-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P41A/n04a2002.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D57P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_goosuto2 = SkySceneKit.spawn_npc("haunter", 200, 160, Direction.Down, "NPC_GOOSUTO2")
  -- SetOutputAttribute(128) [neutre/état moteur]
  local npc_npc_goosuto3 = SkySceneKit.spawn_npc("haunter", 256, 160, Direction.Down, "NPC_GOOSUTO3")
  -- SetOutputAttribute(128) [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 224, 184, Direction.Down, "NPC_GOOSUTO")
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]When I knocked out [CS:N]Haunter[CR]...", french="[CN]Quand j'ai mis K.O. [CS:N]Spectrum[CR]...", german="[CN]Als ich [CS:N]Alpollo[CR] den K.O. verpasst habe...", italian="[CN]Quando ho sconfitto [CS:N]Haunter[CR]...", spanish="[CN]Cuando tumbé a [CS:N]Haunter[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="He's not moving.[K] It looks like\nhe's fainted.", french="Il ne bouge pas.[K] On dirait qu'il\ns'est évanoui.", german="Er bewegt sich nicht mehr.[K]\nSieht aus, als sei er K.O. gegangen.", italian="Non si muove.[K] Pare che\nsia andato KO.", spanish="No se mueve.[K] Parece que\nse ha debilitado."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(hero, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So I need to hurry up and\napprehend him. ♪ Yay! ♪", french="Il faut que j'en profite pour\nl'arrêter. ♪ Cool! ♪", german="Also beeile ich mich besser und\nnehme ihn fest. ♪ Juchhu! ♪", italian="Sarà meglio che mi sbrighi\ne lo catturi. ♪ Urrà! ♪", spanish="Así que tengo que darme prisa\ny capturarlo ya. ♪ ¡Bieeen! ♪"})
  -- message_Close
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(9990) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]But every time I tried to arrest you, [CS:N]Haunter[CR]...", french="[CN]Mais à chaque fois que j'essayais\n[CN]de t'arrêter, [CS:N]Spectrum[CR]...", german="[CN]Aber jedes Mal, wenn ich dich gefangen\n[CN]nehmen wollte, [CS:N]Alpollo[CR]...", italian="[CN]Ma ogni volta che provavo ad arrestarti,\n[CN][CS:N]Haunter[CR]...", spanish="[CN]Pero cada vez que intentaba arrestaros,\n[CN][CS:N]Haunter[CR]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]There was always this sudden blinding light...", french="[CN]... il y avait cette lumière aveuglante...", german="[CN]Jedes Mal war da plötzlich dieses\n[CN]helle, blendende Licht...", italian="[CN]... compariva sempre questa luce accecante.", spanish="[CN]Siempre aparecía una luz cegadora..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]For a moment, I couldn't see a thing...", french="[CN]... qui m'empêchait d'y voir clair\n[CN]pendant un instant...", german="[CN]Einen Moment lang konnte ich nichts sehen...", italian="[CN]Per un attimo non riuscivo a vedere nulla...", spanish="[CN]No veía nada durante un momento..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]It was then, wasn't it...", french="[CN]C'est à ce moment-là, n'est-ce pas...", german="[CN]Und das habt ihr dann genutzt...", italian="[CN]Ed era in quel momento che...", spanish="[CN]Era entonces, ¿verdad?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]That you changed places...", french="[CN]... que tu en profitais pour changer\n[CN]de place avec un autre.", german="[CN]Genutzt, um die Plätze zu tauschen!", italian="[CN]... vi scambiavate di posto, non è vero?", spanish="[CN]Entonces cambiabais de lugar..."})
  -- message_Close
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You'd disorient your opponents\n[CN]with a blinding light...", french="[CN]Tu désorientes tes adversaires\n[CN]avec une lumière aveuglante...", german="[CN]Ihr blendet den Gegner mit einem Lichtblitz.", italian="[CN]Disorientate i vostri avversari\n[CN]con una luce abbagliante...", spanish="[CN]Desorientabais a vuestros adversarios\n[CN]con una luz cegadora..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]While the two of you that were hidden\n[CN]would come out...", french="[CN]... ce qui permet à tes deux complices\n[CN]cachés de sortir...", german="[CN]Ihr tut es, damit die zwei versteckten\n[CN]von euch kurz hervorkommen können...", italian="[CN]Poi due di voi escono fuori\n[CN]dal loro nascondiglio...", spanish="[CN]Mientras los dos que estaban\n[CN]escondidos salían..."})
  -- message_Close
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  -- GAP: se_Play(9986) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(11, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_goosuto3, 224, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_goosuto3, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]You'd hide the [CS:N]Haunter[CR] who fainted...", french="[CN]Il ne leur reste alors plus qu'à dissimuler\n[CN]le [CS:N]Spectrum[CR] qui s'est évanoui...", german="[CN]Der in Ohnmacht gefallene [CS:N]Alpollo[CR]\n[CN]wird dann schnell versteckt.", italian="[CN]Portano via l'[CS:N]Haunter[CR] che è andato KO...", spanish="[CN]Escondíais al [CS:N]Haunter[CR]\n[CN]que se hubiera debilitado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(44) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  -- GAP: se_Play(9991) — id SE NDS sans portage PMDO identifié
  -- ResetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  do local p=npc_npc_goosuto3.Position; GROUND:MoveToPosition(npc_npc_goosuto3, p.X+(0), p.Y+(-64), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Then one of you would feign innocence and\n[CN]pretend to be the [CS:N]Haunter[CR] who'd fainted...", french="[CN]... puis l'un de vous fait semblant d'être\n[CN]le [CS:N]Spectrum[CR] qui est tombé K.O.", german="[CN]Danach nimmt einer von euch den Platz des\n[CN]gerade K.O. gegangenen [CS:N]Alpollo[CR] ein\n[CN]und gibt vor, unbesiegbar zu sein.", italian="[CN]... e facendo finta di niente, uno\n[CN]dei due si sostituisce a lui.", spanish="[CN]Y entonces uno de vosotros fingía ser\n[CN]el [CS:N]Haunter[CR] que se había debilitado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_goosuto2, 224, 180, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_goosuto2, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(24), 48, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh![K] It's so bright!", french=" Ben mince alors![K] Quelle lumière!", german=" Auweia![K] Es ist so hell!", italian=" Shock![K] Che luce accecante!", spanish=" ¡Jo, qué mal![K] ¡Cuánta luz!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I can't see a thing!", french=" J-je n'y vois plus rien!", german=" I-ich sehe nichts!", italian=" N-Non vedo nulla!", spanish=" ¡No... No veo nada de nada!"})
  -- message_Close
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh!", french=" J'hallucine!", german=" Auweia!", italian=" Shock!", spanish=" ¡Jo, pero qué fuerte!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh...[K]what?!", french=" Que...[K] quoi?!", german=" W-[K]was?!?", italian=" C...[K] Cosa?!", spanish=" O sea...[K] ¡¿Cómo es posible?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I just...[K] I know I just knocked\nhim out...", french="Je t'ai...[K] J'étais sûre de l'avoir\nmis K.O., pourtant...", german="Ich habe...[K] Ich weiß doch, dass\nich ihn gerade auf die Bretter geschickt habe...", italian="Ma io...[K] ero sicura di averlo\nsconfitto...", spanish="Pero si lo acabo...[K] Sé\nperfectamente que lo acabo de tumbar..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Why is he suddenly fine?!", french="Pourquoi est-ce qu'il est en\npleine forme tout d'un coup?!", german="Warum ist er plötzlich wieder\nmunter?!?", italian="Come mai si è improvvisamente\nrialzato?!", spanish="¡¿Por qué de repente está\ncomo una rosa?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" GAH HA HA HA HA HA HA HA!!", french=" OUAH HA HA HA HA HA HA HA!!", german=" GAHAHAHAHAHAHAHA!!!", italian=" GAH AH AH AH AH AH AH!!!", spanish=" ¡¡Juaaa, ja, ja, ja, ja, ja!!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Did you see that?![K] It's\nimpossible to knock me out!", french="Tu as vu ça?![K] Personne ne peut\nme mettre K.O.!", german="Hast du gesehen?!?[K] Es ist\nunmöglich, mich fertigzumachen!", italian="Hai visto?![K] È impossibile\nbattermi!", spanish="¡¿Te lo crees ahora?![K]\n¡Es imposible vencerme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(11) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(9) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="[CN]That's how you got everyone to think you\n[CN]were the Invincible [CS:N]Haunter[CR]!", french="[CN]C'est comme ça qu'ils ont pu amener\n[CN]tout le monde à croire à cette histoire de\n[CN]\"[CS:N]Spectrum[CR] l'Invincible\"!", german="[CN]Auf diese Art habt ihr alle glauben lassen, ihr\n[CN]wäret [F:S2]Der unbesiegbare [CS:N]Alpollo[CR][F:E2]!", italian="[CN]Ecco perché tutti hanno cominciato a chiamarti\n[CN]l'invincibile [CS:N]Haunter[CR]!", spanish="[CN]¡Así hacíais creer a todo el mundo que erais\n[CN]\"[CS:N]Haunter[CR], el Invencible\"!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="[CN]The exploration teams that have\n[CN]challenged you so far, [CS:N]Haunter[CR]...", french="[CN]Toutes les équipes d'exploration qui\n[CN]ont défié les [CS:N]Spectrum[CR]...", german="[CN]Die Erkundungsteams, die euch bisher\n[CN]herausgefordert haben, [CS:N]Alpollo[CR]...", italian="[CN]Le squadre d'esplorazione che\n[CN]ti hanno sfidato finora...", spanish="[CN]Los equipos exploradores que\n[CN]os han retado hasta ahora..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="[CN]The moment they believed that you were\n[CN]invincible, [CS:N]Haunter[CR], they lost the will to fight...", french="[CN] ... perdaient toute volonté de se battre dès\n[CN]l'instant où elles croyaient [CS:N]Spectrum[CR] invincible.", german="[CN]Sie sind auf diese Täuschung hereingefallen\n[CN]und haben im selben Augenblick den\n[CN]Siegeswillen verloren...", italian="[CN]... perdevano la loro voglia di combattere\n[CN]perché erano indotte a pensare che tu\n[CN]fossi invincibile...", spanish="[CN]En cuanto creían que erais un solo [CS:N]Haunter[CR]\n[CN]invencible, perdían las ganas de luchar..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="[CN]That's why the exploration teams were unable\n[CN]to apprehend [CS:N]Haunter[CR].", french="[CN]C'est pour ça que les équipes d'exploration ont\n[CN]toujours été incapables d'arrêter [CS:N]Spectrum[CR].", german="[CN]Daher hat es kein Erkundungsteam geschafft,\n[CN][CS:N]Alpollo[CR] festzunehmen.", italian="[CN]È questo il motivo per cui nessuna squadra\n[CN]è mai stata in grado di catturarti, [CS:N]Haunter[CR].", spanish="[CN]Por eso ningún equipo explorador\n[CN]ha conseguido arrestar a [CS:N]Haunter[CR]."})
  -- message_Close
  GAME:FadeOut(false, 60)
  SkySceneKit.cleanup_npcs()
end
