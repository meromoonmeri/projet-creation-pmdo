-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s22p0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...[K] That ended badly.", french=" Argh...[K] Ça s'est mal terminé.", german=" Uff...[K] Das ging böse aus.", italian=" Oh...[K] È finita male.", spanish=" Uf...[K] No ha acabado nada bien."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...[K] We didn't make it...", french=" Argh...[K] Ça s'est mal terminé.", german=" Uff...[K] Nicht geschafft...", italian=" Uff...[K] Non ce l'abbiamo fatta.", spanish=" Uf...[K] No lo logramos."})
  else
  SkySceneKit.say({english=" Ugh...[K] We didn't get through...", french=" Argh...[K] Ça s'est mal terminé.", german=" Uff...[K] Wir kamen nicht durch...", italian=" Uh...[K] Non ce l'abbiamo fatta.", spanish=" Uf...[K] No ha ido muy bien."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm... This is tough...[K] Let's stop\nfor now and try again tomorrow.", french="Hum... Ce n'est pas une mince\naffaire...[K] A chaque jour suffit sa peine.\nRetentons notre chance demain.", german="Hmm... Es ist schwer...[K] Lasst\nuns erst einmal eine Pause einlegen und dann\nmorgen weitermachen.", italian="Mmm... È dura...[K] Fermiamoci\nqui per oggi e riproviamo domani.", spanish="Hum... Esto no es fácil...[K]\nDejémoslo por hoy e intentémoslo de\nnuevo mañana."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm... This is tough...[K] Let's stop\nfor now and try again tomorrow.", french="Hum... Ce n'est pas une mince\naffaire...[K] A chaque jour suffit sa peine.\nRetentons notre chance demain.", german="Hmm... Es ist schwer...[K] Lasst\nuns erst einmal eine Pause einlegen und dann\nmorgen weitermachen.", italian="Mmm... È dura...[K] Fermiamoci\nqui per oggi e riproviamo domani.", spanish="Hum... Esto no es fácil...[K]\nDejémoslo por hoy e intentémoslo de\nnuevo mañana."})
  else
  SkySceneKit.say({english="Hmm... This is tough...[K] Let's stop\nfor now and try again tomorrow.", french="Hum... Ce n'est pas une mince\naffaire...[K] A chaque jour suffit sa peine.\nRetentons notre chance demain.", german="Hmm... Es ist schwer...[K] Lasst\nuns erst einmal eine Pause einlegen und dann\nmorgen weitermachen.", italian="Mmm... È dura...[K] Fermiamoci\nqui per oggi e riproviamo domani.", spanish="Hum... Esto no es fácil...[K]\nDejémoslo por hoy e intentémoslo de\nnuevo mañana."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's put an end to [CS:N]Darkrai[CR]'s\nscheme this time!", french="Mettons un terme aux projets\nde [CS:N]Darkrai[CR], cette fois-ci!", german="Setzen wir dem Vorhaben von\n[CS:N]Darkrai[CR] diesmal ein Ende!", italian="Questa volta metteremo fine ai\npiani di [CS:N]Darkrai[CR]!", spanish="¡Acabemos con [CS:N]Darkrai[CR] y su\nmalvado plan de una vez por todas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's put an end to [CS:N]Darkrai[CR]'s\nscheme this time!", french="Mettons un terme aux projets\nde [CS:N]Darkrai[CR], cette fois-ci!", german="Setzen wir dem Vorhaben von\n[CS:N]Darkrai[CR] diesmal ein Ende!", italian="Questa volta metteremo fine ai\npiani di [CS:N]Darkrai[CR]!", spanish="¡Acabemos con [CS:N]Darkrai[CR] y su\nmalvado plan de una vez por todas!"})
  else
  SkySceneKit.say({english="Let's put an end to [CS:N]Darkrai[CR]'s\nscheme this time!", french="Mettons un terme aux projets\nde [CS:N]Darkrai[CR], cette fois-ci!", german="Setzen wir dem Vorhaben von\n[CS:N]Darkrai[CR] diesmal ein Ende!", italian="Questa volta metteremo fine ai\npiani di [CS:N]Darkrai[CR]!", spanish="¡Acabemos con [CS:N]Darkrai[CR] y su\nmalvado plan de una vez por todas!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="On n'a pas le droit d'abandonner\nmaintenant, [hero]!", german="Es gibt diesmal kein Aufgeben,\n[hero]!", italian="Non possiamo arrenderci adesso,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="On n'a pas le droit d'abandonner\nmaintenant, [hero]!", german="Es gibt diesmal kein Aufgeben,\n[hero]!", italian="Non possiamo arrenderci adesso,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  else
  SkySceneKit.say({english="We can't give up now,\n[hero]!", french="On n'a pas le droit d'abandonner\nmaintenant, [hero]!", german="Wir können jetzt nicht aufgeben,\n[hero]!", italian="Non possiamo arrenderci adesso,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
