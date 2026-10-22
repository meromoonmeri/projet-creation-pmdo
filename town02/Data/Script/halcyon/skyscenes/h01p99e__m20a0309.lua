-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/m20a0309.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_ON_THE_BEACH_AT_DUSK) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02B) [décor sub chargé: Sub_v21p02b]
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm_ChangeVolume(120,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  SkySubScreen.Show("v21p02b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It all gave me courage.", french=" ... cela m'a redonné courage.", german=" Das hat mir immer Mut gemacht.", italian="Beh, la sua presenza mi dava\ncoraggio.", spanish="Me daba valor para seguir\nadelante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It all gave me courage.", french=" ... cela m'a redonné courage.", german=" Das hat mir immer Mut gemacht.", italian="Beh, la sua presenza mi dava\ncoraggio.", spanish="Me daba valor para seguir\nadelante."})
  else
  SkySceneKit.say({english=" It all gave me courage.", french=" ... cela m'a redonné courage.", german=" Das hat mir immer Mut gemacht.", italian="Beh, la sua presenza mi dava\ncoraggio.", spanish="Me daba valor para seguir\nadelante."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="With [hero], I felt like I\ncould conquer any challenge.", french="Avec [hero] à mes côtés,\nj'ai toujours eu l'impression que je pourrais\nsoulever des montagnes.", german="Mit [hero] fühlte ich\nmich bereit für jede Herausforderung.", italian="Con [hero], sentivo di\npoter vincere ogni sfida.", spanish="Con [hero] a mi lado,\nsentía que podía superar cualquier\nobstáculo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="With [hero], I felt like I\ncould overcome any challenge.", french="Avec [hero] à mes côtés,\nj'ai toujours eu l'impression que je pourrais\nsoulever des montagnes.", german="Mit [hero] fühlte ich\nmich jeder Herausforderung gewachsen.", italian="Con [hero], sentivo di\npoter affrontare qualunque sfida.", spanish="Con [hero] a mi lado,\nsentía que podía superar cualquier\nobstáculo."})
  else
  SkySceneKit.say({english="With [hero], I felt like I\ncould overcome any challenge.", french="Avec [hero] à mes côtés,\nj'ai toujours eu l'impression que je pourrais\nsoulever des montagnes.", german="Mit [hero] fühlte ich\nmich jeder Herausforderung gewachsen.", italian="Con [hero], sentivo di\npoter affrontare qualunque sfida.", spanish="Con [hero] a mi lado,\nsentía que podía superar cualquier\nobstáculo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's how I came to think\nover time.", french="Le temps a passé, et cette\nimpression a persisté.", german=" So fühlte ich nach einiger Zeit.", italian=" Col tempo sono cambiato.", spanish="Así es como acabé sintiéndome\nal cabo del tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's how I came to feel\nover time.", french="Le temps a passé, et cette\nimpression a persisté.", german=" So fühlte ich nach einiger Zeit.", italian=" Col tempo sono cambiato.", spanish="Así es como acabé sintiéndome\nal cabo del tiempo."})
  else
  SkySceneKit.say({english="That's how I came to feel\nover time.", french="Le temps a passé, et cette\nimpression a persisté.", german=" So fühlte ich nach einiger Zeit.", italian=" Col tempo sono cambiata.", spanish="Así es como acabé sintiéndome\nal cabo del tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe that's why I was able to\nkeep going without giving up!", french="C'est peut-être grâce à ça que\nj'ai pu m'accrocher jusqu'au bout!", german="Vielleicht war das der Grund,\naus dem ich weitermachen konnte, ohne\naufzugeben!", italian="Forse è per questo che sono\nriuscito a tenere duro senza arrendermi!", spanish="¡Tal vez por eso pude seguir\nadelante sin rendirme!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe that's why I was able to\nkeep going without giving up!", french="C'est peut-être grâce à ça que\nj'ai pu m'accrocher jusqu'au bout!", german="Vielleicht war das der Grund,\naus dem ich weitermachen konnte, ohne\naufzugeben!", italian="Forse è per questo che sono\nriuscito a tenere duro senza arrendermi!", spanish="¡Tal vez por eso pude seguir\nadelante sin rendirme!"})
  else
  SkySceneKit.say({english="Maybe that's why I was able to\nkeep going without giving up!", french="C'est peut-être grâce à ça que\nj'ai pu m'accrocher jusqu'au bout!", german="Vielleicht war das der Grund,\naus dem ich weitermachen konnte, ohne\naufzugeben!", italian="Forse è per questo che sono\nriuscita a tenere duro senza arrendermi!", spanish="¡Tal vez por eso pude seguir\nadelante sin rendirme!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 216, 160, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" ...[K]All right.", french=" ...[K] Je vois.", german=" ...[K]Alles klar.", italian=" ...[K] Va bene.", spanish=" Ah...[K] Ya veo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I think I understand what\nyou're saying.", french="Je crois comprendre ce que\ntu veux dire.", german="Ich verstehe, was du meinst,\ndenke ich.", italian="Penso di aver capito cosa\nintendi.", spanish="Creo que entiendo lo que me\nquieres decir."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Yes, [hero] has a special\nquality that makes others feel that way.", french="C'est vrai, [hero] est\ntrès habile pour vous redonner du cœur\nà l'ouvrage.", german="Ja, [hero] hat eine\nbesondere Eigenschaft, die andere so\nempfinden lässt.", italian="Sì, [hero] ha un qualcosa\nche consente a chi è al suo\nfianco di sentirsi più forte.", spanish="Sí, algo en [hero] hace\nque los demás se sientan de esa forma."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The same way that I care for\n[hero] as a friend...", french="C'est la même amitié qui\nme lie à [hero]...", german="Genauso, wie mir [hero]\nals Freund am Herzen liegt...", italian=" Io tengo molto a [hero]...", spanish="A mí me pasaba lo mismo.\nLa amistad de [hero] también era\nmuy importante para mí."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You, [partner], also feel that\nsame way about [hero].", french="Et toi aussi, [partner],\ntu ressens la même chose pour [hero].", german="So empfindest du, [partner],\nauch für [hero].", italian=" E tu fai altrettanto.", spanish="Ahora eres tú, [partner],\nquien siente ese lazo con [hero]."})
  -- message_Close
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [hero] is...[K]lucky...", french="[hero] a vraiment...[K]\nde la chance...", german="[hero] ist...[K]\nein Glückspilz.", italian=" [hero] ha...[K] fortuna...", spanish="[hero] tiene...[K]\nmucha suerte..."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="to be blessed with a friend\nlike you...", french=" ... d'avoir quelqu'un comme toi...", german="Ein Glückspilz, einen Freund wie\ndich zu haben.", italian="... ad avere un Pokémon come\nte accanto.", spanish="Por tener a alguien como tú\na su lado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_juputoru, Direction.Right)
  GAME:WaitFrames(90)
  GROUND:EntTurn(npc_npc_juputoru, Direction.UpRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_juputoru, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Well, it's morning.", french=" Bon, le jour s'est levé.", german=" Der Morgen ist da.", italian=" Bene, si è fatta mattina.", spanish=" Bueno, ya es de día."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" We should be leaving soon.", french=" On devrait partir au plus vite.", german=" Wir sollten bald aufbrechen.", italian="Dobbiamo cercare di partire\npresto.", spanish=" Pronto tendremos que irnos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_juputoru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup.", french=" D'accord.", german=" Jep.", italian=" Sì.", spanish=" Sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes.", french=" D'accord.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  else
  SkySceneKit.say({english=" Yep.", french=" D'accord.", german=" Jep.", italian=" Sì.", spanish=" Sí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_juputoru, 232, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 296, 172, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(20)
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-16), false, 2) end
  GROUND:MoveToPosition(partner, 232, 172, false, 2)
  GROUND:MoveToPosition(npc_npc_juputoru, 276, 156, false, 2)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(48), p.Y+(0), false, 2) end
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(90)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
