-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V23P04A/m23a1007.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V23P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(2) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7445) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- back_SetEffect(13, 0) [transition couches décor NDS immédiate]
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V23P04A1_297) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(90)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(120)
  pcall(function() UI:SetSpeaker("Grovyle", true, "grovyle", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_JUPUTORU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What...[K] What was that?", french=" Que...[K] qu'est-ce que c'était?", german=" Was...[K] Was war das?", italian=" Cosa...[K] Cos'è stato?", spanish=" ¿Pero qué...?[K] ¿Qué ha sido eso?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A beam of light shot out to sea...", french="Il y a un rayon de lumière\nqui a jailli vers la mer...", german="Ein Lichtkegel schießt in\nRichtung Meer...", italian="Un raggio di luce in direzione\ndel mare...", spanish="Un rayo de luz ha salido\ndisparado hacia el mar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A beam of light shot out to sea...", french="Il y a un rayon de lumière\nqui a jailli vers la mer...", german="Ein Lichtkegel schießt in\nRichtung Meer...", italian="Un raggio di luce in direzione\ndel mare...", spanish="Un rayo de luz ha salido\ndisparado hacia el mar..."})
  else
  SkySceneKit.say({english=" A beam of light shot out to sea...", french="Il y a un rayon de lumière\nqui a jailli vers la mer...", german="Ein Lichtkegel schießt in\nRichtung Meer...", italian="Un raggio di luce in direzione\ndel mare...", spanish="Un rayo de luz ha salido\ndisparado hacia el mar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's that out there...?", french="Il y a quelque chose\nlà-dehors...", german=" Was war das?", italian=" Chi c'è laggiù...?", spanish=" ¿Qué ha sido eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What's that out there...?", french="Il y a quelque chose\nlà-dehors...", german=" Was war das?", italian=" Chi c'è laggiù...?", spanish=" ¿Qué ha sido eso?"})
  else
  SkySceneKit.say({english=" What's that out there...?", french="Il y a quelque chose\nlà-dehors...", german=" Was war das?", italian=" Chi c'è laggiù...?", spanish=" ¿Qué ha sido eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(120) -- back_SetEffect(11, 120) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  -- ResetOutputAttribute(128) [neutre/état moteur]
  GAME:WaitFrames(120)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Huh?[K] That's...", french=" ... Quoi?[K] C'est...", german=" Häh?[K] Das ist...", italian=" Eh?[K] Quello è...", spanish=" ¿Eh?[K] Eso es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...What?[K] That's...", french=" ... Quoi?[K] C'est...", german=" ...Was?[K] Das ist...", italian=" Cosa?[K] Quello è...", spanish=" ¿Eh?[K] Eso es..."})
  else
  SkySceneKit.say({english=" ...What?[K] That's...", french=" ... Quoi?[K] C'est...", german=" ...Was?[K] Das ist...", italian=" Cosa?[K] Quello è...", spanish=" ¿Eh?[K] Eso es..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: SetEffect 658 — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(70)
  -- SetAnimation(19) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's coming closer...[K]\nIt's swimming...", french=" Ça se rapproche...[K] en nageant...", german="Es kommt näher...[K]\nEs schwimmt...", italian=" Si avvicina...[K] Sta nuotando...", spanish="Se está acercando...[K]\nViene nadando hacia aquí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's coming closer...[K]\nIt's swimming...", french=" Ça se rapproche...[K] en nageant...", german="Es kommt näher...[K]\nEs schwimmt...", italian=" Si avvicina...[K] Sta nuotando...", spanish="Se está acercando...[K]\nViene nadando hacia aquí..."})
  else
  SkySceneKit.say({english="It's coming closer...[K]\nIt's swimming...", french=" Ça se rapproche...[K] en nageant...", german="Es kommt näher...[K]\nEs schwimmt...", italian=" Si avvicina...[K] Sta nuotando...", spanish="Se está acercando...[K]\nViene nadando hacia aquí..."})
  end
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
end
