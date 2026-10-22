-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D50P11A/n08a2808.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nDas war wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No nos ha ido bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten wohl noch\neinmal von vorne anfangen.", italian=" Meglio tornare sui nostri passi.", spanish=" Deberíamos regresar por ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D50P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 296, 216, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_SPACIAL_CLIFFS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (I'd be too impatient to go\nthere now.)", french="... (Mon impatience pourrait\nme jouer des tours.)", german="...(Ich war wohl zu ungeduldig,\ndorthin zu gelangen.)", italian=" ... (Sono stato imprudente.)", spanish="Uf... (No puedo ser tan\nimpaciente.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(I should be a bit\nmore cautious.)", french=" (Je devrais être plus prudent.)", german="(Ich sollte etwas\nvorsichtiger sein.)", italian="(Devo cercare di fare più\nattenzione.)", spanish=" (Es mejor que tenga cautela.)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
