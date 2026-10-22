-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D47P11A/n08a1308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french="Argh...[K] Ça ne s'est pas\ntrès bien passé...", german="Argh...[K]\nDas war wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No lo hemos hecho bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten wohl noch\neinmal von vorne anfangen.", italian=" Meglio tornare sui nostri passi.", spanish=" Vamos a retroceder por ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V17P01A) [décor sub chargé: Sub_v17p01a]
  -- back_SetGround(LEVEL_D47P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 21.5, 17>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 232, 144, Direction.Down, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  SkySubScreen.Show("v17p01a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DARK_WASTELAND non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You appear to be so wary of me\nthat you can't focus properly on our enemies.", french="Ta méfiance envers moi affecte\nta concentration. Occupe-toi plutôt de nos\nennemis.", german="Du bist ja derart auf der Hut\nvor mir, dass du dich wohl nicht gut genug\nauf die Feinde konzentrieren kannst.", italian="Ho la sensazione che tu sia così\ndiffidente nei miei confronti da non riuscire\na concentrarti come si deve sui tuoi nemici.", spanish="Desconfías tanto de mí que\nno le prestas la debida atención a nuestros\nenemigos. Así no vamos a ninguna parte."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" That's it?[K] That's your strength?", french="C'est ainsi?[K] Est-ce là tout\nce que tu peux faire?", german="Ist das schon alles?[K]\nHast du nicht mehr zu bieten?", italian="Tutto qua?[K] Sarebbe questa\nla tua forza?", spanish="¿Eso es todo?[K] ¿Esa es toda\ntu fuerza?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Humph.[K] Whatever.", french=" Pfff.[K] Qu'importe.", german=" Hmpf.[K] Was soll's...", italian=" Bah.[K] Lasciami stare.", spanish=" ¡Bah![K] Déjame en paz."})
  -- message_Close
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
