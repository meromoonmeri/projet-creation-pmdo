-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m26a0607.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK_SHORTENED non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03B) [décor sub chargé: Sub_v01p03b]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- supervision_SpecialActing(21, 600, 0) [cadrage NDS]
  -- supervision2_SpecialActing(21, 600, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  -- SetOutputAttribute(2) [neutre/état moteur]
  SkySubScreen.Show("v01p03b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I haven't seen this for a long\ntime. It's just as beautiful as I remember.", french="Je n'avais pas vu ça depuis\nlongtemps. C'est aussi beau que dans\nmes souvenirs.", german="Ich habe das so lange nicht\ngesehen. Es ist immer noch so schön wie in\nmeiner Erinnerung.", italian="Non lo vedevo da un sacco di\ntempo. È sempre bello come ricordavo.", spanish="Hacía mucho que no veía la\npuesta de sol. Es tan hermosa como la\nrecordaba."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I haven't seen this for a long\ntime. It's as beautiful as I remember.", french="Je n'avais pas vu ça depuis\nlongtemps. C'est aussi beau que dans\nmes souvenirs.", german="Ich habe das so lange nicht\ngesehen. Es ist immer noch so schön wie in\nmeiner Erinnerung.", italian="Non lo vedevo da un sacco di\ntempo. È sempre bello come ricordavo.", spanish="Hacía mucho que no veía la\npuesta de sol. Es tan hermosa como la\nrecordaba."})
  else
  SkySceneKit.say({english="I haven't seen this for a long\ntime. It's as pretty as I remember.", french="Je n'avais pas vu ça depuis\nlongtemps. C'est aussi beau que dans\nmes souvenirs.", german="Ich habe das so lange nicht\ngesehen. Es ist immer noch so schön wie in\nmeiner Erinnerung.", italian="Non lo vedevo da un sacco di\ntempo. È sempre bello come ricordavo.", spanish="Hacía mucho que no veía la\npuesta de sol. Es tan hermosa como la\nrecordaba."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I've been too busy to come and\nsee it.", french="Ces derniers temps, j'étais trop\noccupé pour venir voir ça.", german="Ich war einfach zu beschäftigt,\num herzukommen und es mir anzusehen.", italian="Avevo troppe cose da fare per\nvenire qui.", spanish="He estado tan ocupado que no\nhe tenido tiempo para venir a contemplarla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I've just been too busy to come\nand see it.", french="Ces derniers temps, j'étais trop\noccupé pour venir voir ça.", german="Ich war einfach zu beschäftigt,\num herzukommen und es mir anzusehen.", italian="Ero troppo impegnato per venire\na vederlo.", spanish="He estado tan ocupado que no\nhe tenido tiempo para venir a contemplarla."})
  else
  SkySceneKit.say({english="I've been too busy to come and\nsee it.", french="Ces derniers temps, j'étais trop\noccupée pour venir voir ça.", german="Ich war einfach zu beschäftigt,\num herzukommen und es mir anzusehen.", italian="Ero troppo impegnata per venire\na vederlo.", spanish="He estado tan ocupada que no\nhe tenido tiempo para venir a contemplarla."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I've missed this...[K]\nfantastic sight.", french="Mais ça m'a beaucoup manqué...[K]\nC'est un spectacle féerique.", german="Aber ich habe es vermisst...[K]\nEin fantastischer Anblick.", italian="Ma mi è mancata...[K] questa\nsplendida vista.", spanish="Pero echaba de menos...[K] esta\nfantástica vista."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I've missed this...[K]\nfantastic sight.", french="Mais ça m'a beaucoup manqué...[K]\nC'est un spectacle féerique.", german="Aber ich habe es vermisst...[K]\nEin fantastischer Anblick.", italian="Ma mi è mancata...[K] questa\nsplendida vista.", spanish="Pero echaba de menos...[K] esta\nfantástica vista."})
  else
  SkySceneKit.say({english="But I've missed this...[K]\nfantastic sight.", french="Mais ça m'a beaucoup manqué...[K]\nC'est un spectacle féerique.", german="Aber ich habe es vermisst...[K]\nEin fantastischer Anblick.", italian="Ma mi è mancata...[K] questa\nsplendida vista.", spanish="Pero echaba de menos...[K] esta\nfantástica vista."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(210) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="When was the last time I saw\nthis, anyway?", french="Je me demande à quand remonte\nla dernière fois que je l'ai vu...", german="Wann habe ich das überhaupt\nzuletzt gesehen?", italian="Quand'è stata l'ultima volta,\ncomunque?", spanish="¿Cuándo fue la última vez\nque disfruté de esta vista?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I wonder when it was when I\nlast saw this...", french="Je me demande à quand remonte\nla dernière fois que je l'ai vu...", german="Ich frage mich, wann ich das\nzuletzt gesehen habe...", italian="Chissà quand'è stata l'ultima\nvolta...", spanish="¿Cuándo fue la última vez\nque disfruté de esta vista?"})
  else
  SkySceneKit.say({english="When was the last time I saw\nthis, anyway?", french="Je me demande à quand remonte\nla dernière fois que je l'ai vu...", german="Wann habe ich das überhaupt\nzuletzt gesehen?", italian="Quand'è stata l'ultima volta,\ncomunque?", spanish="¿Cuándo fue la última vez\nque disfruté de esta vista?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The last time was...", french=" La dernière fois remonte à...", german=" Das letzte Mal war...", italian=" L'ultima volta è stata...", spanish=" La última vez..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The last time was...", french=" La dernière fois remonte à...", german=" Das letzte Mal war...", italian=" L'ultima volta è stata...", spanish=" La última vez..."})
  else
  SkySceneKit.say({english=" The last time was...", french=" La dernière fois remonte à...", german=" Das letzte Mal war...", italian=" L'ultima volta è stata...", spanish=" La última vez..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh...[K] The last time I saw this...", french="Oh...[K] La dernière fois\nque j'ai vu ça...", german=" Oh...[K] Das letzte Mal war...", italian=" Oh...[K] L'ultima volta è stata...", spanish=" Oh...[K] La última vez fue..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh...[K] The last time I saw this...", french="Oh...[K] La dernière fois\nque j'ai vu ça...", german=" Oh...[K] Das letzte Mal war...", italian=" Oh...[K] L'ultima volta è stata...", spanish=" Oh...[K] La última vez fue..."})
  else
  SkySceneKit.say({english=" Oh...[K] The last time I saw this...", french="Oh...[K] La dernière fois\nque j'ai vu ça...", german=" Oh...[K] Das letzte Mal war...", italian=" Oh...[K] L'ultima volta è stata...", spanish=" Oh...[K] La última vez fue..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was when...[K]when I met\n[hero]...", french="C'était quand...[K] quand j'ai\nrencontré [hero]...", german="Es war,[K] als ich [hero]\ntraf...", italian="... quando...[K] quando ho\nconosciuto [hero]...", spanish="Fue...[K] cuando conocí a\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was when...[K]when I met\n[hero]...", french="C'était quand...[K] quand j'ai\nrencontré [hero]...", german="Es war,[K] als ich [hero]\ntraf...", italian="... quando...[K] quando ho\nconosciuto [hero]...", spanish="Fue...[K] cuando conocí a\n[hero]."})
  else
  SkySceneKit.say({english="It was when...[K]when I met\n[hero]...", french="C'était quand...[K] quand j'ai\nrencontré [hero]...", german="Es war,[K] als ich [hero]\ntraf...", italian="... quando...[K] quando ho\nconosciuto [hero]...", spanish="Fue...[K] cuando conocí a\n[hero]."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- supervision2_SpecialActing(3, 0, 0) [acting sub NDS: décor déjà reproduit par SubScreen, acteurs sub non simulés - trace]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
