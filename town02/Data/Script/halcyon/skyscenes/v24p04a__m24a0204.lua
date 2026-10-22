-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P04A/m24a0204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V24P04A) [neutre/état moteur]
  -- supervision_SpecialActing(20, 0, 0) [cadrage NDS]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetOutputAttribute(64) [neutre/état moteur]
  -- SetOutputAttribute(8) [neutre/état moteur]
  -- back_SetEffect(13, 0) [transition couches décor NDS immédiate]
  -- camera_SetMyself() [neutre/état moteur]
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 176, Direction.UpLeft, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" It's true!", french=" Oh, oui, je vois!", german=" Es stimmt!", italian=" È vero!", spanish=" ¡Es cierto!"})
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="The waves...[K] The waves are all\ntwisted up!", french="Les vagues...[K] leur comportement\nest tout sauf naturel!", german="Die Wellen...[K] Die Wellen sind\nverdreht!", italian="Le onde...[K] Guardate com'è\nincrespato il mare!", spanish="Las olas...[K]\n¡Las olas parecen ir contra corriente!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_THROUGH_THE_SEA_OF_TIME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Lapras[CR]! Wh-what is that?!", french=" [CS:N]Lokhlass[CR]! Qu'est-ce que c'est?!", german=" [CS:N]Lapras[CR]! W-was ist das?!?", italian=" [CS:N]Lapras[CR]! C-Che cos'è quello?!", spanish=" ¡[CS:N]Lapras[CR]! ¡¿Qué es eso?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Lapras[CR]! Wh-what is that?!", french=" [CS:N]Lokhlass[CR]! Qu'est-ce que c'est?!", german=" [CS:N]Lapras[CR]! W-was ist das?!?", italian=" [CS:N]Lapras[CR]! C-Che cos'è quello?!", spanish=" ¡[CS:N]Lapras[CR]! ¡¿Qué es eso?!"})
  else
  SkySceneKit.say({english=" [CS:N]Lapras[CR]! Wh-what is that?!", french=" [CS:N]Lokhlass[CR]! Qu'est-ce que c'est?!", german=" [CS:N]Lapras[CR]! W-was ist das?!?", italian=" [CS:N]Lapras[CR]! C-Che cos'è quello?!", spanish=" ¡[CS:N]Lapras[CR]! ¡¿Qué es eso?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_RAPURASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" The edge of the gap in time.", french=" C'est la brèche temporelle.", german=" Der Rand der Spalte in der Zeit.", italian="Il confine della breccia del\ntempo.", spanish="Esos son los límites del\nintervalo temporal."})
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_RAPURASU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="That is the portal through which\nwe will go to the [CS:P]Hidden Land[CR].", french="Le passage que nous allons\nfranchir pour atteindre les [CS:P]Terres Illusoires[CR].", german="Das ist das Portal, durch das\nwir zum [CS:P]Verborgenen Land[CR] gelangen.", italian="Attraverso questo portale\nraggiungeremo la [CS:P]Terra Nascosta[CR].", spanish="Ese es el portal por el que\naccederemos a la [CS:P]Tierra Oculta[CR]."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- supervision_SpecialActing(3, 0, 0) [cadrage NDS]
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
