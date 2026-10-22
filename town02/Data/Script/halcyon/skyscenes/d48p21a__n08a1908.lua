-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D48P21A/n08a1908.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nDas war wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No nos ha ido muy bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten wohl noch\neinmal von vorne anfangen.", italian=" Meglio tornare sui nostri passi.", spanish="Deberíamos dar media vuelta\npor ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D48P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 248, 288, Direction.Left, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_TEMPORAL_SPIRE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (Argh![K] Just a little farther to\nthe pinnacle.)", french="... (Argh![K] Encore un petit effort,\nle pinacle n'est plus très loin.)", german="...(Argh![K] Nur ein bisschen\nweiter bis zur Spitze.)", italian="... (Argh![K] Manca poco\nalla vetta.)", spanish="Uf... (¡Ay![K] Solo queda un poco\nmás hasta la cúspide.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(Next time, I'll definitely show\nyou I can make it through.)", french="(Hors de question que j'échoue,\nla prochaine fois.)", german="(Das nächste Mal werde ich dir\nbeweisen, dass ich es schaffen kann.)", italian="(La prossima volta gli\ndimostrerò che ce la posso fare... questo\nè poco, ma sicuro.)", spanish="(La próxima vez, ya te\ndemostraré que puedo cruzar este territorio.)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
