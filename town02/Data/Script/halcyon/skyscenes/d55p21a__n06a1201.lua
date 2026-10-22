-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D55P21A/n06a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  local npc_npc_chaaremu = SkySceneKit.spawn_npc("medicham", 200, 296, Direction.Down, "NPC_CHAAREMU")
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="Hmm...[K] Looks like we didn't do\nso well.", french="Hum...[K] Ce n'était pas\nune franche réussite.", german="Hmm...[K] Sieht fast so aus, als\nwären wir nicht gut genug gewesen.", italian="Mmmh...[K] A quanto pare non\nè andata molto bene.", spanish="Hum...[K] Parece que\nno nos ha ido demasiado bien."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Well, it happens sometimes.[K]\nThis kind of thing. [M:H8]", french="C'est ainsi.[K] On ne peut pas\nréussir à tous les coups. [M:H8]", german="Nun gut.[K] So was passiert sogar\nden Besten. [M:H8]", italian=" Già.[K] A volte capita. [M:H8]", spanish="No pasa nada.[K] Son cosas\nque pasan. [M:H8]"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_saanaito = SkySceneKit.spawn_npc("gardevoir", 264, 296, Direction.Left, "NPC_SAANAITO")
  pcall(function() UI:SetSpeaker(npc_npc_saanaito) end)
  SkySceneKit.say({english="Anyway, let's head back for a\nlittle while.", french=" Faisons une petite pause.", german="Wir sollten uns auf den\nRückweg begeben und für eine Weile ausruhen.", italian="Comunque non dobbiamo perdere\nla speranza.", spanish=" En fin, volvamos."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D55P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(hero, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Down)
  GROUND:EntTurn(npc_npc_saanaito, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  -- SetAnimation(22) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Boulder Quarry.ogg", true) end)
  GAME:WaitFrames(30)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(10)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(7)
  -- SetAnimation(23) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_chaaremu, Direction.Right)
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chaaremu, hero, 4) end)
  GAME:WaitFrames(6)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_saanaito, npc_npc_chaaremu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english=" Aargh! We were almost there!", french=" Aargh! Nous y étions presque!", german=" Aargh! Wir sind fast da!", italian=" Aaah! Che disdetta!", spanish=" ¡Ay! ¡Ya casi habíamos llegado!"})
  pcall(function() UI:SetSpeaker(npc_npc_chaaremu) end)
  SkySceneKit.say({english="But let's not get discouraged,[K]\n[CS:N]Gardevoir[CR] and [CS:Y]Lopunny[CR]!", french="Ne nous laissons pas abattre.[K]\nCourage, [CS:N]Gardevoir[CR] et [CS:Y]Lockpin[CR]!", german="Nur nicht den Mut verlieren,[K]\n[CS:N]Guardevoir[CR] und [CS:Y]Schlapor[CR]!", italian="Ma non scoraggiamoci,[K]\n[CS:N]Gardevoir[CR] e [CS:Y]Lopunny[CR]!", spanish="¡Pero no os desaniméis,[K]\n[CS:N]Gardevoir[CR] y [CS:Y]Lopunny[CR]!"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
