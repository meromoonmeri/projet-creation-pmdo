-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01B/m02a0105.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P01A) [décor sub chargé: Sub_v02p01a]
  -- back_SetGround(LEVEL_G01P01B) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(240, 196, 1, false) end)
  -- SetAnimation(9) [anim idle native]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v02p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Are they arguing?", french=" Quoi?[K] Ils se disputent?", german=" Häh?[K] Sind sie am Streiten?", italian=" Eh?[K] Stanno litigando?", spanish=" ¿Eh?[K] ¿Están discutiendo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] Are they arguing?", french=" Quoi?[K] Ils se disputent?", german=" Was?[K] Streiten sie etwa?", italian=" Eh?[K] Stanno litigando?", spanish=" ¿Eh?[K] ¿Se han puesto a discutir?"})
  else
  SkySceneKit.say({english=" What?[K] Are they arguing?", french=" Quoi?[K] Ils se disputent?", german=" Wie?[K] Streiten sie etwa?", italian=" Eh?[K] Stanno litigando?", spanish="¿Qué?[K] ¡No me digas que se han\npuesto a discutir!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" ...Sorry to make you WAIT.", french=" ... Désolé de vous avoir fait ATTENDRE.", german=" ...Tut mir leid, dass ihr WARTEN musstet.", italian=" Spiacente per l'ATTESA.", spanish=" Sentimos la espera."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_RIGHT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Well, it's TRUE that you don't see any\n[c_kind:PLAYER] in these parts...", french="C'est VRAI que l'on ne voit pas de\n[c_kind:PLAYER] dans cette région...", german="Nun, es STIMMT schon, man sieht in dieser\nGegend keine [c_kind:PLAYER]...", italian="Beh, è VERO che non si vedono molti\nesemplari di [c_kind:PLAYER] da queste parti...", spanish="Bueno, lo cierto es que no se suele ver\nningún [c_kind:PLAYER] por aquí..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" But you don't SEEM to be bad...", french="Mais tu n'as pas l'air d'être un MECHANT\nPokémon...", german=" Aber du SCHEINST nicht böse zu sein...", italian=" ... ma non SEMBRI un Pokémon cattivo...", spanish=" Pero no pareces mala gente..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" OK, good enough![K] ENTER!", french=" Allez, c'est bon![K] ENTREZ!", german=" Okay, das reicht![K] EINTRETEN!", italian=" Ok, basta così![K] ENTRATE!", spanish=" Bueno, ¡ya está bien![K] ¡ENTRAD!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6408) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  GROUND:EntTurn(partner, Direction.UpRight)
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_G01P01A3_95) [routine d'objet NDS non simulée - documenté]
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yikes!", french=" Gloups...", german=" Oh Mann!", italian=" Gulp!", spanish=" ¡Huy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yikes!", french=" Gloups...", german=" Oh Mann!", italian=" Gulp!", spanish=" ¡Huy!"})
  else
  SkySceneKit.say({english=" Yipes!", french=" Gloups...", german=" Oh Mann!", italian=" Gulp!", spanish=" ¡Huy!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm so nervous! So jittery!", french="Je suis si nerveux! Je tremble\ncomme une feuille!", german=" Ich bin ganz nervös und hibbelig!", italian=" Sono così nervoso! Ho i brividi!", spanish="¡Qué nervios! ¡Estoy como un\nflan!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm so nervous! So jittery!", french="Je suis si nerveux! Je tremble\ncomme une feuille!", german=" Ich bin ganz nervös und hibbelig!", italian=" Sono così nervoso! Ho i brividi!", spanish="¡Qué nervioso estoy!\n¡Estoy temblando!"})
  else
  SkySceneKit.say({english=" I'm so nervous! So jittery!", french="Je suis si nerveuse! Je tremble\ncomme une feuille!", german=" Ich bin ganz nervös und hibbelig!", italian=" Sono così nervosa! Ho i brividi!", spanish="¡Qué nerviosa estoy!\n¡Hasta tengo escalofríos!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I'm glad we're finally\nallowed in.[K] My heart's pounding, though...", french="Mais je suis content de pouvoir\nenfin entrer.[K] Par contre, mon cœur bat\nla chamade...", german="Aber ich bin froh, dass wir\nendlich hineindürfen.[K] Mein Herz klopft mir bis\nzum Hals...", italian="Ma sono felice di poter\nfinalmente entrare.[K] Anche se il cuore\nmi batte forte...", spanish="Pero me alegra que por fin\npodamos entrar.[K] Aunque el corazón\nme late muy deprisa..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I'm glad we're finally\nallowed in.[K] My heart's pounding, though...", french="Mais je suis content de pouvoir\nenfin entrer.[K] Par contre, mon cœur bat\nla chamade...", german="Aber ich bin froh, dass wir\nendlich hineindürfen.[K] Mein Herz klopft mir bis\nzum Hals...", italian="Ma sono felice di poter\nfinalmente entrare.[K] Anche se il cuore\nmi batte forte...", spanish="Pero me alegra que por fin\npodamos entrar.[K] Aunque el corazón\nme late muy deprisa..."})
  else
  SkySceneKit.say({english="But I'm glad we're finally\nallowed in.[K] My heart's pounding, though...", french="Mais je suis contente de pouvoir\nenfin entrer.[K] Par contre, mon cœur bat\nla chamade...", german="Aber ich bin froh, dass wir\nendlich hineindürfen.[K] Mein Herz klopft mir bis\nzum Hals...", italian="Ma sono felice di poter\nfinalmente entrare.[K] Anche se il cuore\nmi batte forte...", spanish="Pero estoy contenta de que\nal fin podamos entrar.[K] Aunque el corazón\nme late muy deprisa..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Anyway, let's go.", french=" Allez, entrons.", german="Wie auch immer! Gehen wir\nrein.", italian=" Beh, andiamo.", spanish=" Venga, entremos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, let's go in.", french=" Allez, entrons.", german=" Okay, gehen wir rein.", italian=" Ok, andiamo.", spanish=" Vale, entremos."})
  else
  SkySceneKit.say({english=" Anyway, let's go.", french=" Allez, entrons.", german="Wie auch immer! Gehen wir\nrein.", italian=" Beh, andiamo.", spanish=" Bueno, ya es hora de entrar."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 240, 148, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 240, 172, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 240, 148, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
