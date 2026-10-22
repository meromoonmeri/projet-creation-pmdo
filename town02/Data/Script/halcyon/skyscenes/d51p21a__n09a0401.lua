-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P21A/n09a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No lo hemos hecho bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish=" Vamos a dar la vuelta por ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D51P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 256, 288, Direction.Left, "NPC_YONOWAARU_N9")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (Argh.[K] It's bad to\nnot make any progress in a place like this!)", french="... (Argh.[K] Que c'est frustrant\nde faire du sur-place!)", german="...(Argh.[K] An einem solchen\nOrt nicht voranzukommen, ist nicht gut!)", italian="... (Argh.[K] Non sopporto l'idea\ndi non riuscire ad andare avanti in questo\nposto!)", spanish="Ay... (Vaya...[K] ¡No es bueno\nno poder avanzar en un sitio como este!)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" (Next time, definitely!)", french="(Nous y arriverons\nla prochaine fois!)", german=" (Nächstes Mal aber bestimmt!)", italian="(La prossima volta ce la farò\ndi sicuro!)", spanish="(¡La próxima vez sé que\nlo conseguiré!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
