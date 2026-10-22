-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P34A/m26a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_EARTHQUAKE3 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm2_PlayFadeIn(BGM_HEAVY_FEELING) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_D30P34A) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(11) [anim idle native]
  local npc_npc_dark_diaruga = SkySceneKit.spawn_npc("dialga", 272, 288, Direction.Down, "NPC_DARK_DIARUGA")
  -- SetAnimation(25) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  -- SetAnimation(68) [anim idle native]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('1', '1', '1', '0')
  GAME:FadeIn(1)
  GAME:WaitFrames(30)
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A4_78) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(7690) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D30P33A4_78) [routine d'objet NDS non simulée - documenté]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(8455) — id SE NDS sans portage PMDO identifié
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  else
  SkySceneKit.say({english=" Waaaaah!", french=" Ouaaaaah!", german=" Waaaaah!", italian=" Aaaaaah!", spanish=" ¡Aaaaah!"})
  end
  GAME:WaitFrames(40)
  -- GAP: se_Play(6403) — id SE NDS sans portage PMDO identifié
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(true, 90) -- screen_WhiteOutAll
  GAME:WaitFrames(60)
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(180)
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  GAME:WaitFrames(2) -- join WaitBgm
  GAME:WaitFrames(2) -- join WaitBgm2
  GAME:WaitFrames(2) -- join WaitSe
  SkySceneKit.cleanup_npcs()
end
