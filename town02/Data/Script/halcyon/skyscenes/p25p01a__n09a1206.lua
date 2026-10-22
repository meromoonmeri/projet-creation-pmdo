-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P25P01A/n09a1206.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_PROUD_ACCOMPLISHMENT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P25P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n9 = SkySceneKit.spawn_npc("dusknoir", 168, 288, Direction.Down, "NPC_YONOWAARU_N9")
  -- SetAnimation(29) [anim idle native]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" While I live, I want to shine.", french="Je veux que mon existence\nait un impact sur le monde alentour.", german="Solange ich etwas erreiche,\nbin ich ein leuchtendes Beispiel für andere.", italian="Fintanto che sono qui, voglio\ndare il meglio di me stesso.", spanish="Mientras esté aquí, quiero hacer algo\nrelevante."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I want to prove that I exist.", french="Je veux laisser une trace aux\ngénérations suivantes.", german="Ich möchte, dass andere mich\nund meine Taten wahrnehmen.", italian="Voglio lasciare una prova di ciò\nche ho realizzato.", spanish=" No quiero pasar desapercibido."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If I could do something really\nimportant...[K] That would definitely carry\non into the future.", french="Si je pouvais accomplir quelque\nhaut fait...[K] alors, on se souviendrait de moi,\nlongtemps après ma disparition, dans le futur.", german="Wenn ich also etwas wirklich\nWichtiges erreiche,[K] würde dies auf jeden\nFall bis in die Zukunft hineinreichen.", italian="Se riuscissi a compiere\nun'impresa veramente importante...[K] allora\nil suo ricordo si perpetuerebbe nel futuro.", spanish="Si pudiera hacer algo realmente\nimportante...[K] Dejar mi huella en el futuro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" No...[K] Not just into the future.", french="Non...[K] pas seulement\ndans le futur.", german="Nein...[K]\nNicht nur bis in die Zukunft.", italian="No...[K] Non solo in un futuro\nqualsiasi.", spanish=" No...[K] No solo en el futuro."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="In [c_name:NPC_HERO_FIRST]'s and\n[c_name:NPC_PARTNER_FIRST]'s future too...", french="Dans le futur de [c_name:NPC_HERO_FIRST] et\n[c_name:NPC_PARTNER_FIRST] aussi...", german="Auch bis in die Zukunft von\n[c_name:NPC_HERO_FIRST] und [c_name:NPC_PARTNER_FIRST]...", italian="Ma anche nel futuro\ndi [c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST]...", spanish="En el futuro de [c_name:NPC_HERO_FIRST]\ny [c_name:NPC_PARTNER_FIRST]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="My spirit has become part of\nthem, I believe.", french=" Je fais partie d'eux.", german="Ich glaube, dass zwischen uns\neine enge Verbindung besteht.", italian="Credo che la mia essenza sia\ndiventata parte di loro.", spanish="Sé que mi recuerdo ahora\nforma parte de su memoria."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" In them, my spirit is alive.", french=" Ma mémoire vit en eux.", german="Durch sie bestehen\nmeine Taten fort.", italian=" Li accompagna ogni giorno.", spanish="Una parte de mí siempre habitará\nen su interior."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And that spirit could be passed\nalong to others.", french="Et cette mémoire peut être\ntransmise de génération en génération.", german="Und die Auswirkungen meiner\nTaten können andere inspirieren.", italian="E quell'essenza può essere\ntrasmessa ad altri.", spanish="Ese recuerdo podría pasar\nincluso a formar parte de otros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru_n9, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="And so, if I were to\ndisappear...[K]I think all that I have accomplished\nwill go on.", french="Par conséquent, si nous\ndisparaissons...[K] je laisserai derrière moi\ntout ce que j'aurai accompli.", german="Wenn ich also verschwinde...[K]\nwerden meine Taten fortbestehen.", italian="Così, anche se dovessi\nscomparire...[K] penso che il ricordo di ciò\nche ho compiuto continuerebbe a esistere.", spanish="Por eso, si yo desapareciera...[K]\ncreo que lo que he conseguido hacer\nperviviría muchos años más."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" That is...", french=" Ce qui signifie...", german=" Somit...", italian=" È...", spanish=" Para mí..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="That would mean...[K]that it's\nliving, right?", french="Eh bien...[K] que je n'aurai\npas vraiment disparu, n'est-ce pas?", german="Das würde doch bedeuten,[K]\ndass Taten Bestand haben, nicht wahr?!?", italian="È questo...[K] che conta davvero,\nno?", spanish="Eso sería...[K] como una forma de vivir,\n¿no te parece?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="... (Even if I disappear...[K]\nI still live on...)", french="... (Même si l'on disparaît...[K]\nnotre existence se poursuit...)", german="...(Auch wenn ich verschwinde...[K]\nIch wäre immer noch hier...)", italian="... (Anche se scompaio...[K]\nil mio ricordo vivrà...)", spanish="Ah... (Tras desaparecer...[K]\npuedo seguir viviendo...)"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" (My spirit is...[K]alive!)", french="(Notre mémoire reste...[K]\nvivante!)", german="(Meine Taten...[K]\nwürden für sich sprechen!)", italian="(La mia essenza...[K] sarà sempre\npresente!)", spanish=" (Mi recuerdo puede...[K] ¡vivir!)"})
  -- message_Close
  GAME:FadeOut(true, 60) -- screen_WhiteOut
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  SkySceneKit.cleanup_npcs()
end
