-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D51P11A/n09a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nWir waren wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No nos ha ido bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten besser\nnoch einmal umkehren.", italian=" Meglio tornare sui nostri passi.", spanish=" Retrocedamos por ahora..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D51P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 312, 176, Direction.Right, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_ICE_MOUNTAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (Anyway, there's no solution\nif we can't proceed farther.)", french="... (De toute façon, nous n'avons\npas d'autre solution, il faut continuer.)", german="...(Wenn wir es nicht weiter\nschaffen, werden wir keine Lösung finden.)", italian="... (Non possiamo fare nulla se\nnon riusciamo ad andare avanti.)", spanish="Uf... (Poco más podemos hacer\nde momento si queremos avanzar.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(We'll make it through on the\nnext one.)", french="(La prochaine fois sera\nla bonne.)", german="(Beim nächsten Mal werden wir\nes weiter schaffen.)", italian="(La prossima volta dobbiamo\nfarcela.)", spanish="(Ya lo conseguiremos en el\npróximo intento.)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
