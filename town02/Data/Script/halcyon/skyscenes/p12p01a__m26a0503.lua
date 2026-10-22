-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P12P01A/m26a0503.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V26P04A) [décor sub chargé: Sub_v26p04a]
  -- back_SetGround(LEVEL_P12P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 18.5, 17.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(360), 120, false) end) -- back_SetBackScrollSpeed(0.0,3.0) px/frame -> caméra continue (pilote scroll)
  -- back2_SetBackScrollSpeed(0, 6.3984) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- MovePositionOffset<object OBJECT_V26P04A1_339> [prop décor NDS, géré par le rendu du ground]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- MovePositionOffset<object OBJECT_V26P04A2_342> [prop décor NDS, géré par le rendu du ground]
  GAME:WaitFrames(30) -- WaitBgmSignal (signal SMD NDS sans équivalent: join fixe documenté)
  SkySubScreen.Show("v26p04a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(120)
  -- message_SetWaitMode(210, 90) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] is...[K]getting\nfarther and farther away...", french="La [CS:P]Tour du Temps[CR]...[K] elle\ns'éloigne de plus en plus...", german="Der [CS:P]Zeitturm[CR].[K] Er rückt in immer\nweitere Ferne...", italian="La [CS:P]Torre del Tempo[CR] è...[K] sempre\npiù lontana...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] está\ncada vez más lejos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] is...[K]getting\nfarther and farther away...", french="La [CS:P]Tour du Temps[CR]...[K] elle\ns'éloigne de plus en plus...", german="Der [CS:P]Zeitturm[CR].[K] Er rückt in immer\nweitere Ferne...", italian="La [CS:P]Torre del Tempo[CR] è...[K] sempre\npiù lontana...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] está\ncada vez más lejos."})
  else
  SkySceneKit.say({english="[CS:P]Temporal Tower[CR] is...[K]getting\nfarther and farther away...", french="La [CS:P]Tour du Temps[CR]...[K] elle\ns'éloigne de plus en plus...", german="Der [CS:P]Zeitturm[CR].[K] Er rückt in immer\nweitere Ferne...", italian="La [CS:P]Torre del Tempo[CR] è...[K] sempre\npiù lontana...", spanish="La [CS:P]Torre del Tiempo[CR]...[K] está\ncada vez más lejos."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And [hero]...[K] I'm getting\nfarther away from [hero]...", french="Et [hero]...[K] Je m'éloigne\nde plus en plus de [hero]...", german="Und auch [hero]...[K]\n[hero] entfernt sich immer weiter von\nmir...", italian="E [hero]...[K] Io sono\nsempre più lontano da [hero]...", spanish="Y también [hero]...[K]\nMe voy alejando más de [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And [hero]...[K] I'm getting\nfarther away from [hero]...", french="Et [hero]...[K] Je m'éloigne\nde plus en plus de [hero]...", german="Und auch [hero]...[K]\n[hero] entfernt sich immer weiter von\nmir...", italian="E [hero]...[K] Io sono\nsempre più lontano da [hero]...", spanish="Y también [hero]...[K]\nMe voy alejando más de [hero]..."})
  else
  SkySceneKit.say({english="And [hero]...[K] I'm getting\nfarther away from [hero]...", french="Et [hero]...[K] Je m'éloigne\nde plus en plus de [hero]...", german="Und auch [hero]...[K]\n[hero] entfernt sich immer weiter von\nmir...", italian="E [hero]...[K] Io sono\nsempre più lontana da [hero]...", spanish="Y también [hero]...[K]\nMe voy alejando más de [hero]..."})
  end
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  else
  SkySceneKit.say({english=" Oh, [hero]...", french=" Oh, [hero]...", german=" Oh, [hero]...", italian=" Oh, [hero]...", spanish=" Oh, [hero]..."})
  end
  -- message_Close
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(240) end)
  SkySubScreen.Hide(160) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 160)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- message_SetWaitMode(-1, -1) [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitBgm
  -- GAP: BGM BGM_A_WISH_FOR_PEACE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]And so, [hero]\n[CN]and [partner]...", french="[CN]C'est ainsi que\n[CN][hero] et [partner]...", german="[CN]Und so waren [hero]\n[CN]und [partner]", italian="[CN]E così, [hero]\n[CN]e [partner]...", spanish="[CN]Y así, [hero] y\n[CN][partner]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]finally succeeded in their mission...", french="[CN]... achevèrent enfin leur mission...", german="[CN]schließlich erfolgreich mit ihrer Mission.", italian="[CN]alla fine hanno portato a termine\n[CN]la loro missione...", spanish="[CN]finalmente cumplieron su misión..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]and saved the world from disaster.", french="[CN]... et sauvèrent le monde du désastre.", german="[CN]Sie retteten die Welt vor der Katastrophe.", italian="[CN]... e hanno salvato il mondo\n[CN]da una catastrofe certa.", spanish="[CN]y salvaron al mundo del desastre."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] departed from\n[CN][CS:P]Temporal Tower[CR]...", french="[CN][partner] quitta\n[CN]la [CS:P]Tour du Temps[CR]...", german="[CN][partner] verlässt den\n[CN][CS:P]Zeitturm[CR],", italian="[CN][partner] si lascia alle spalle la\n[CN][CS:P]Torre del Tempo[CR]...", spanish="[CN][partner] se marchó\n[CN]de la [CS:P]Torre del Tiempo[CR]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]traveled across the\n[CN]ravaged [CS:P]Hidden Land[CR]...", french="[CN]... traversa la contrée dévastée\n[CN]des [CS:P]Terres Illusoires[CR]...", german="[CN]reist durch das\n[CN]verwüstete [CS:P]Verborgene Land[CR],", italian="[CN]... attraversa la devastata\n[CN][CS:P]Terra Nascosta[CR]...", spanish="[CN]viajó por la devastada\n[CN][CS:P]Tierra Oculta[CR]..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]rode [CS:N]Lapras[CR] across the sea...", french="[CN]... franchit la mer sur le dos de [CS:N]Lokhlass[CR]...", german="[CN]reitet auf [CS:N]Lapras[CR] über das Meer,", italian="[CN]... solca il mare in groppa a [CS:N]Lapras[CR]...", spanish="[CN]montó sobre [CS:N]Lapras[CR] para cruzar el mar..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]and safely returned\n[CN]to Treasure Town.", french="[CN]... et regagna enfin\n[CN]Bourg-Trésor.", german="[CN]und kehrt wohlbehalten nach\n[CN]Schatzstadt zurück.", italian="[CN]e torna in salute\n[CN]a Borgo Tesoro.", spanish="[CN]y volvió sin percances\n[CN]a Aldea Tesoro."})
  -- message_Close
  GAME:WaitFrames(60)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
