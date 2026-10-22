-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P41A/m12a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(19, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D12P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 3) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(3)
  GAME:WaitFrames(30)
  local npc_npc_raiboruto = SkySceneKit.spawn_npc("manectric", 280, 224, Direction.Down, "NPC_RAIBORUTO")
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" You trespass again?!", french=" Encore vous?!", german="Ihr Eindringlinge wagt es,\nzurückzukehren?!?", italian=" Come osate!", spanish=" ¡¿No os rendís nunca?!"})
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" To claim our territory?!", french="Vous cherchez à vous emparer\nde notre territoire?!", german="Um uns unser Revier streitig zu\nmachen?!?", italian="Come osate invadere di nuovo il\nnostro territorio?", spanish="¡¿Queréis arrebatarnos nuestro\nterritorio?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're wrong! We came to...", french="Non, tu te trompes! On est là\npour...", german="Du irrst dich! Wir sind hier,\num...", italian=" Un momento! Noi siamo qui per...", spanish=" ¡Te equivocas! ¡Veníamos a...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You've got it wrong! We came\nonly to...", french="Non, tu te trompes! On est là\npour...", german="Du täuschst dich! Wir sind nur\nhier, um...", italian=" Un momento! Noi siamo qui per...", spanish=" ¡Te equivocas! ¡Veníamos a...!"})
  else
  SkySceneKit.say({english="Please, no! You're wrong!\nWe came only to...", french="Non, tu te trompes! On est là\npour...", german="Bitte, nein! Du irrst dich!\nWir sind nur hier, um...", italian=" Un momento! Noi siamo qui per...", spanish="¡No, te equivocas!\n¡Tan solo veníamos a...!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Save your lies!", french=" Epargnez-moi vos mensonges!", german=" Spart euch eure Lügen!", italian=" Silenzio!", spanish="¡Podéis ahorraros vuestras\nmentiras!"})
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Prepare to fight!", french=" Préparez-vous à vous battre!", german=" Macht euch bereit, zu kämpfen!", italian=" Preparatevi a lottare!", spanish=" ¡Preparaos para luchar!"})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(19, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
