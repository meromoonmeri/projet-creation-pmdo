-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m03a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 472, 216, Direction.Up, "NPC_BIPPA")
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_bippa, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Huh?[K] Are you folks all set and\nready for some exploring?", french="Alors?[K] Z'avez bien fait\nvos préparatifs? Vous voulez partir en\nmission?", german="Na?[K] Seid ihr bereit für eine\nGanovenjagd?", italian=" Eh?[K] Tutto pronto?", spanish=" ¿Eh?[K] ¿Ya habéis acabado?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_ExecuteCommon(CORO_EVENT_M03_05_06) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_EVENT_END_FREE (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  else -- default/annulation
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Not yet, huh?", french=" Pas encore?", german=" Noch nicht, wie?", italian=" Non ancora, eh?", spanish=" Aún no, ¿eh?"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Just give me a holler when\nyou're all ready to go.", french="Z'aurez qu'à m'sonner quand\nvous voudrez partir.", german="Sagt einfach Bescheid, wenn ihr\nbereit seid.", italian="Fatemi un fischio quando avete\nfinito.", spanish="Avisadme cuando lo tengáis todo\nlisto para partir."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Then we'll all have a gander at\nthe Outlaw Notice Board and pick out a suitable\noutlaw for you.", french="On zieutera les Avis\nd'Recherche et puis on vous choisira\nun p'tit hors-la-loi.", german="Dann werfen wir einen Blick auf\ndas Ganoven-Infobrett und suchen euch einen\npassenden Ganoven aus.", italian="Poi cercheremo nella Bacheca\ndei ricercati la missione più adatta a voi.", spanish="Entonces le echaremos un ojo a\nlos carteles de \"Se Busca\" y escogeremos\nel malhechor adecuado para vuestro nivel."})
  -- message_Close
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
