-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D03P41A/m03a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(5, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  -- back_SetGround(LEVEL_D03P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_ruriri = SkySceneKit.spawn_npc("azurill", 352, 248, Direction.Down, "NPC_RURIRI")
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(hero, 368, 324, false, 2)
  GROUND:MoveToPosition(partner, 328, 324, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_ruriri, "exclaim", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]!", german=" [CS:N]Traumato[CR]!", italian=" [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 352, 272, Direction.Up, "NPC_SURIIPU")
  GROUND:EntTurn(npc_npc_suriipu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Not you again.", french=" Encore vous?!", german=" Nicht ihr schon wieder.", italian=" Ancora voi.", spanish=" ¡Otra vez no!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let go of [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]! Laisse partir [CS:N]Azurill[CR]!", german=" Lass [CS:N]Azurill[CR] in Ruhe, [CS:N]Traumato[CR]!", italian=" Lascia andare [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR], suelta a [CS:N]Azurill[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let go of [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]! Laisse partir [CS:N]Azurill[CR]!", german=" Lass [CS:N]Azurill[CR] in Ruhe, [CS:N]Traumato[CR]!", italian=" Lascia andare [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR], suelta a [CS:N]Azurill[CR]!"})
  else
  SkySceneKit.say({english=" Let go of [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", french=" [CS:N]Soporifik[CR]! Laisse partir [CS:N]Azurill[CR]!", german=" Lass [CS:N]Azurill[CR] in Ruhe, [CS:N]Traumato[CR]!", italian=" Lascia andare [CS:N]Azurill[CR], [CS:N]Drowzee[CR]!", spanish=" ¡[CS:N]Drowzee[CR], suelta a [CS:N]Azurill[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="You foolish pests. Do I have to\nembarrass you again?", french="Imbéciles. Combien de fois\nfaudra-t-il vous mettre une raclée?", german="Ihr dämlichen Nervensägen.\nMuss ich euch noch einmal bloßstellen?", italian="Ancora voi guastafeste. Devo\ndarvi un'altra lezione?", spanish="Sois insoportables. ¿Tengo\nque dejaros en evidencia otra vez?"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english="You seem to hunger for\npunishment. Let me help you out!", french="Puisque vous insistez,\nje vais me faire un plaisir de vous donner\nune autre correction!", german="Ihr wollt wohl unbedingt eine\nAbreibung. Die könnt ihr haben!", italian="Sembrate proprio in cerca di\nguai. Vedrò di accontentarvi!", spanish="Parece que os gusta que os\nderrote. ¡Pues por mí no hay problema!"})
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" C'mon! Whenever you want!", french=" Allez! C'est quand vous voulez!", german=" Kommt! Ich bin jederzeit bereit!", italian=" Forza! Quando volete!", spanish=" ¡Venga! ¡Cuando queráis!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
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
  -- main_EnterDungeon(5, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  SkySceneKit.cleanup_npcs()
end
