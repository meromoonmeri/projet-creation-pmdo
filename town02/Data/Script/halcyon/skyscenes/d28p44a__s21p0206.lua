-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P44A/s21p0206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D28P44A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 256, 184, Direction.Down, "NPC_YONOWAARU")
  -- SetAnimation(55) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 256, 184, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(33) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- SetAnimation(10) [anim idle native]
  -- GAP: SetEffect 653 — VFX sans émote PMDO équivalente
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [partner]![K] This is it for me!", french="[partner]![K] C'est ici que\nnos chemins se séparent!", german="[partner]![K] Ende der\nFahnenstange!", italian=" [partner]![K] A lui ci penso io!", spanish="¡[partner]![K]\n¡Aquí nos despedimos!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I'm taking [CS:N]Dusknoir[CR]...[K]back to\nthe future!", french="Je ramène [CS:N]Noctunoir[CR]...[K]\ndans le futur!", german="Ich nehme [CS:N]Zwirrfinst[CR]...[K] mit in\ndie Zukunft zurück!", italian=" Riporto [CS:N]Dusknoir[CR]...[K] nel futuro!", spanish="Me llevo a [CS:N]Dusknoir[CR]...[K]\n¡de vuelta al futuro!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" Huh?![K] Wh-what?!", french=" Hein?![K] Quoi?!", german=" Wie bitte?!?[K] W-was?!?", italian=" Eh?![K] C-Cosa?!", spanish=" ¡¿Eh?![K] ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_juputoru, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="I can never come back here\nagain.", french="Je ne pourrai plus jamais\nrevenir.", german="Ich kann niemals mehr hierher\nzurückkommen.", italian=" Non tornerò mai più.", spanish=" No regresaré."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="Watch [hero]'s back...[K]\nPromise me!", french="Prends soin de [hero]\npour moi...[K] Promets-le-moi!", german="Pass gut auf [hero]\nauf...[K] Versprich mir das!", italian="Prenditi cura di [hero]...[K]\nPromettimelo!", spanish="Cuida de [hero]...[K]\n¡Prométemelo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  else
  SkySceneKit.say({english=" B-but...!", french=" M-mais!", german=" A-aber...", italian=" M-Ma...!", spanish=" ¡Pero...!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  else
  SkySceneKit.say({english="Take your place, [CS:N]Grovyle[CR]...?[K]\nI can't!", french="Prendre ta place, [CS:N]Massko[CR]...?[K]\nJe ne peux pas faire ça!", german="Deinen Platz einnehmen,\n[CS:N]Reptain[CR]?[K] Das kann ich nicht!", italian="Prendere il tuo posto,\n[CS:N]Grovyle[CR]...?[K] Non posso!", spanish="¿Quieres que ocupe tu lugar,\n[CS:N]Grovyle[CR]?[K] ¡No puedo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You must and you will.[K] Because\nyou can, [partner].", french="Tu le dois et tu le feras.[K] Parce\nque tu en es capable, [partner].", german="Du musst und du wirst.[K] Weil du\nes kannst, [partner].", italian="Devi farlo e lo farai.[K] Perché\nne sei in grado, [partner].", spanish="Debes hacerlo, y lo harás...[K]\nporque puedes, [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="You two are...[K]the greatest of\ncombinations.", french="Vous faites...[K] une équipe\nhors pair.", german="Ihr beide seid...[K] das beste\nGespann, das es gibt.", italian="Voi due siete...[K] un'accoppiata\nmagnifica!", spanish="Cuando actuáis en equipo...[K]\nNo hay rival que os haga sombra."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
