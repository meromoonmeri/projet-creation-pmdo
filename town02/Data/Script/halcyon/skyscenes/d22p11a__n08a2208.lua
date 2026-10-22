-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/n08a2208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nDas war wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No nos ha ido muy bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten wohl noch\neinmal von vorne anfangen.", italian=" Meglio tornare sui nostri passi.", spanish="Será mejor que retrocedamos\npor ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_D22P11A, 'UN08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 296, 264, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DUSK_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Argh![K] I want to go soon.\nI'm getting impatient.)", french="(Argh![K] Partons au plus vite.\nJe suis impatient.)", german="(Argh![K] Ich möchte bald los.\nIch werde langsam unruhig.)", italian="(Argh![K] Che rabbia! Ma non mi\narrendo.)", spanish="(¡Ay![K] Quiero ir cuanto antes.\nMe estoy impacientando.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Next time, definitely!)", french="(Ce sera pour la prochaine\nfois!)", german=" (Beim nächsten Mal bestimmt!)", italian="(La prossima volta ce la farò\ndi sicuro!)", spanish="(¡La próxima vez será\nla definitiva!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
