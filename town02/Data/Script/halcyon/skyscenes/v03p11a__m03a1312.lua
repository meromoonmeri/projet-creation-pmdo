-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P11A/m03a1312.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V03P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 472, 240, Direction.Left, "NPC_JUPUTORU")
  -- SetAnimation(42) [anim idle native]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-1440), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(-12.0,0.0) px/frame -> caméra continue (pilote scroll)
  -- bgm2_ChangeVolume(30, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't really know the answer\nto that question.", french="Je n'ai pas de réponse à cette\nquestion.", german="Ich weiß keine sichere Antwort\nauf diese Frage.", italian="Non conosco proprio la\nrisposta a questa domanda.", spanish=" No tengo ni idea."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't really know the answer\nto that question.", french="Je n'ai pas de réponse à cette\nquestion.", german="Ich weiß keine sichere Antwort\nauf diese Frage.", italian="Non conosco proprio la\nrisposta a questa domanda.", spanish="No sabría qué responder,\nla verdad."})
  else
  SkySceneKit.say({english="I don't really know the answer\nto that question.", french="Je n'ai pas de réponse à cette\nquestion.", german="Ich weiß keine sichere Antwort\nauf diese Frage.", italian="Non conosco proprio la\nrisposta a questa domanda.", spanish="Desconozco la respuesta\na esa pregunta."})
  end
  -- message_Close
  -- GAP: se_Play(6420) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(1024) [anim idle native]
  GROUND:MoveToPosition(npc_npc_juputoru, 144, 236, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(-100), p.Y+(0), false, 2) end
  -- se_Stop(6420) [SE one-shot PMDO déjà terminé: arrêt sans objet, canal SE V2]
  -- GAP: se_Play(6421) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  GAME:FadeOut(false, 5)
  SkySceneKit.cleanup_npcs()
end
