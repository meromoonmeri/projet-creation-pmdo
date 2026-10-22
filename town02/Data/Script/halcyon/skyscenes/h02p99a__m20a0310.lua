-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/m20a0310.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 280, 176, Direction.Down, "NPC_JUPUTORU")
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="All right.[K] It's agreed that we\nwill collect all of the Time Gears.", french="Très bien.[K] Nous sommes d'accord\npour rassembler tous les Rouages du Temps.", german="Alles klar.[K] Wir sind uns einig,\ndass wir alle Zahnräder der Zeit einsammeln.", italian="Va bene.[K] Allora siamo\nd'accordo, prenderemo tutti gli Ingranaggi\ndel Tempo.", spanish="Muy bien.[K] Ya hemos resuelto que\niremos a buscar los Engranajes del Tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english="First...[K] We have to decide which\nTime Gear we should target.", french="D'abord...[K] on doit choisir quel\nRouage du Temps chercher en premier.", german="Als Erstes[K] müssen wir\nentscheiden, welches Zahnrad der Zeit wir\nzuerst ins Visier nehmen.", italian="Prima cosa...[K] Dobbiamo\ndecidere da quale Ingranaggio del Tempo\ncominciare.", spanish="Ahora...[K] habrá que decidir qué\nengranaje vamos a buscar en primer lugar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's check the Wonder Map.", french=" Consultons la Carte Miracle.", german="Sehen wir uns mal die\nWunderkarte an.", italian="Controlliamo sulla Mappa delle\nmeraviglie.", spanish=" Miremos el Mapa Mágico."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's check the Wonder Map.", french=" Consultons la Carte Miracle.", german="Sehen wir uns mal die\nWunderkarte an.", italian="Controlliamo sulla Mappa delle\nmeraviglie.", spanish=" Miremos el Mapa Mágico."})
  else
  SkySceneKit.say({english=" Let's check the Wonder Map.", french=" Consultons la Carte Miracle.", german="Sehen wir uns mal die\nWunderkarte an.", italian="Controlliamo sulla Mappa delle\nmeraviglie.", spanish=" Miremos el Mapa Mágico."})
  end
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
