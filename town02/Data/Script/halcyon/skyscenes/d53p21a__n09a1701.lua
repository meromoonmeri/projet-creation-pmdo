-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D53P21A/n09a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] Menudo fracaso..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish="Tendremos que retroceder\npor ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D53P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 304, Direction.UpLeft, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_serebii = SkySceneKit.spawn_npc("celebi", 208, 288, Direction.UpRight, "NPC_SEREBII")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_VAST_ICE_MOUNTAIN_PEAK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="If we don't find Master [CS:N]Dialga[CR]\non the peak...", french="Si Maître [CS:N]Dialga[CR] n'est pas sur\nle pic...", german="Wenn wir Meister [CS:N]Dialga[CR]\nnicht bald finden...", italian="Se non troviamo il Maestro\n[CS:N]Dialga[CR] da queste parti...", spanish="Si no encontramos a\n[CS:N]Dialga[CR] en la cumbre..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Then he's most likely at\nthe pinnacle.", french="... alors, il est forcément\nau pinacle.", german="Dann wird er wohl schon auf\nder Spitze sein.", italian="... allora è molto probabile che\nabbia raggiunto la vetta.", spanish="Entonces probablemente esté\nen la cúspide."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We're almost to the pinnacle.[K]\nLet's break through here.", french="Nous y sommes presque.[K]\nFonçons!", german="Wir haben die Spitze schon fast\nerreicht.[K] Jetzt nur nicht nachlassen!", italian="Siamo quasi arrivati sulla vetta.[K]\nForza, un ultimo sforzo.", spanish="Ya casi estamos en la cúspide.[K]\nCrucemos por aquí."})
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_serebii, Direction.Up)
  GAME:WaitFrames(3)
  GROUND:EntTurn(npc_npc_yonowaaru_n9, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  SkySceneKit.cleanup_npcs()
end
