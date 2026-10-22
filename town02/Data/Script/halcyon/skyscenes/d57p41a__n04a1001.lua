-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P41A/n04a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=43, sub=4} -- $SCENARIO_SIDE = scn[43,4] (ROM)
  -- back_SetGround(LEVEL_D57P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  GAME:WaitFrames(1)
  -- GAP: BGM BGM_HEAVY_WIND2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(15)
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 224, 192, Direction.Down, "NPC_GOOSUTO")
  do local p=npc_npc_goosuto.Position; GROUND:MoveToPosition(npc_npc_goosuto, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" GUOOOOhhhhhh!!", french=" OUUUAAARGH!!", german=" GUooooh!!!", italian=" UOOOOOOhhhhhh!!", spanish=" ¡¡Aaah!!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" GUUUUOOOOOOOooooooohhhhhhhh!", french=" OUUUUUUAAAAaaaaaaarrrrrrrgh!", german=" GUUUUOOOOOOOoooooooh!", italian=" UUUOOOOOOooooooooohhhhhh!", spanish=" ¡Ay, qué daño!"})
  -- message_Close
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
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(3)
  -- GAP: se_Play(9987) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "shock", 1) end)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Phew...[K] Somehow, I managed to\nknock him out.", french="Pfiou...[K] J'ai fini par le\nmettre K.O.", german="Puuuh...[K] Ich habe es irgendwie\ngeschafft, ihn auszuschalten.", italian="Fiuuu...[K] Non so come, ma\nsono riuscita a batterlo.", spanish="Buf...[K] No tengo muy claro cómo,\npero he conseguido tumbarlo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyway, that [CS:N]Haunter[CR] had\na big mouth, but couldn't back it up. ♪", french="En tout cas, quel beau parleur,\nce [CS:N]Spectrum[CR], mais pas vraiment à la hauteur\nde ses prétentions. ♪", german="Na ja. Dieser [CS:N]Alpollo[CR] hatte wohl\nein großes Mundwerk, aber da steckte nichts\ndahinter. ♪", italian="Comunque questo [CS:N]Haunter[CR] si\nè dimostrato invincibile solo a parole. ♪", spanish="En fin, ese [CS:N]Haunter[CR] era un\nbocazas, mucho ruido y pocas nueces. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
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
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- GAP: se_Play(9990) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(1) [neutre/état moteur]
  -- SetAnimation(29) [anim idle native]
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 15) -- screen_WhiteOut
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh my gosh![K] It's so bright!", french=" Ben mince alors![K] Quelle lumière!", german=" Auweia![K] Es ist so hell!", italian=" Shock![K] Che luce accecante!", spanish=" ¡Jo, qué mal![K] ¡Cuánta luz!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-I can't see a thing!", french=" J-je n'y vois plus rien!", german=" I-ich sehe nichts!", italian=" N-Non vedo nulla!", spanish=" ¡No... No veo nada de nada!"})
  -- message_Close
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(60)
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
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Wh...[K]what?!", french=" Que...[K] quoi?!", german=" W-[K]was?!?", italian=" C...[K] Cosa?!", spanish=" O sea...[K] ¡¿Pero qué es esto?!"})
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
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Why, you ask? Well...[K] It's\nbecause I'm invincible!", french="Tu te demandes pourquoi?\nEh bien...[K] C'est parce que je suis invincible!", german="Du fragst warum? Tja...[K] Das ist\nso, weil ich unbesiegbar bin!", italian="Vuoi sapere perché...?[K]\nMa perché sono invincibile!", spanish="¿Que por qué? Bueno...[K] ¡Pues\nporque soy invencible!"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" GAH HA HA HA HA HA HA HA!!", french=" OUAH HA HA HA HA HA HA HA!!", german=" GAHAHAHAHAHAHAHA!!!", italian=" GAH AH AH AH AH AH AH!!!", spanish=" ¡¡Juaaa, ja, ja, ja, ja!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_goosuto, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I-invincible?", french=" In... invincible?", german=" U-unbesiegbar?", italian=" I-Invincibile?", spanish=" ¿In... invencible?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oh...", french=" Oh...", german=" Oh...", italian=" Oh...", spanish=" Vaya..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (That reminds me...)", french=" ... (Je me souviens...)", german=" ...(Ich erinnere mich...)", italian=" ... (Ora che ci penso...)", spanish=" Jo... (Se me había olvidado...)"})
  -- message_Close
  -- bgm_ChangeVolume(60,128) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- screen2_FadeIn(1, 1) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  SkySubScreen.Hide(30) -- screen2_WhiteOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  SkySceneKit.cleanup_npcs()
end
