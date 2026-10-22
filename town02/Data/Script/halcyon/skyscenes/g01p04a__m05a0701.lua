-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/m05a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P04A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 456, 224, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Hmm. Let me see if I've got this\nall straight.", french="Hmm. Voyons voir si j'ai bien\nsaisi.", german="Hmm. Mal sehen, ob ich alles\nrichtig verstanden habe.", italian="Mmm. Vediamo se ho capito\nbene.", spanish="Hum. A ver si lo he entendido\nbien."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Behind the waterfall, there is\na cave...", french="Derrière la cascade, il y a\nune grotte...", german="Hinter dem Wasserfall gibt es\neine Höhle.", italian="Dietro la cascata c'è una\ncaverna...", spanish=" Tras esa cascada hay una cueva."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="In the deepest part of the cave,\nthere is a gigantic gem...", french="Dans les profondeurs de cette\ngrotte, il y a une gemme gigantesque...", german="Im tiefsten Teil der Höhle ist\nein riesiger Edelstein.", italian="Nella parte più profonda della\ncaverna si trova una gemma gigante...", spanish="En lo más profundo de la cueva\nhay una gema gigantesca."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="When you pushed on the gem, it\ntriggered a trap of some kind...", french="Quand on pousse cette gemme,\ncela actionne une sorte de piège...", german="Als du gegen den Edelstein\ngedrückt hast, wurde eine Art Falle ausgelöst.", italian="Quando avete spinto la gemma,\nsi è attivata una trappola di qualche tipo...", spanish="Al empujar la gema, se accionó\nuna especie de trampa..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And, surprisingly, you were\nflushed off to the distant Hot Spring?[K] Is that\nthe gist of your report?", french="Et on se retrouve emporté par\nle courant jusqu'à la Source Chaude, située\nà des lieues de là![K] Est-ce là votre rapport?", german="Und ohne es zu ahnen, wurdet\nihr bis zur weit entfernten Heißen Quelle\ngespült?[K] Sind das die Fakten?", italian="E sorprendentemente, avete\nraggiunto la lontana Sorgente Termale?[K] È\nquesto il succo della vostra storia?", spanish="Y poco después acabasteis en la\nlejanísima Terma.[K] ¿Eso es lo que me\nestáis diciendo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yep.[K] What's really disappointing\nis that we couldn't bring the gem back.", french="C'est ça.[K] Et nous n'avons pas\npu rapporter la gemme avec nous.\nC'est vraiment décevant!", german="Ja.[K] Dass wir den Edelstein nicht\nmitnehmen konnten, ist wirklich schade.", italian="Sì.[K] Ma purtroppo\nnon ci è stato possibile portare con noi la\ngemma.", spanish="Sí.[K] Lo más decepcionante\nes que no hayamos podido traer la gema."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes.[K] It's really disappointing\nthat we couldn't bring the gem back...", french="C'est ça.[K] Et nous n'avons pas\npu rapporter la gemme avec nous.\nC'est vraiment décevant!", german="Ja.[K] Dass wir den Edelstein nicht\nmitnehmen konnten, ist wirklich schade.", italian="Sì.[K] La cosa deludente è che\nnon ci è stato possibile portare con noi la\ngemma.", spanish="Sí.[K] Pero es un poco\ndecepcionante que no hayamos podido traer\nla gema."})
  else
  SkySceneKit.say({english="Yes.[K] It's awfully disappointing\nthat we couldn't bring the gem back...", french="C'est ça.[K] Et nous n'avons pas\npu rapporter la gemme avec nous.\nC'est vraiment décevant!", german="Ja.[K] Dass wir den Edelstein nicht\nmitnehmen konnten, ist wirklich schade.", italian="Sì.[K] Purtroppo, però,\nabbiamo dovuto lasciare la gemma là.", spanish="Sí.[K] Pero es una auténtica pena\nque no hayamos podido traer la gema."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(42) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" No, no, no! Emphatically, no!", french=" Non, non! Trois fois non!", german=" Nein, nein! Aber zehnmal nein!", italian=" No, no, no! Assolutamente, no!", spanish=" ¡No, no y mil veces no!"})
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" This is a major discovery!", french="Vous avez fait une découverte\nmajeure!", german="Ihr habt doch eine große\nEntdeckung gemacht!", italian="Questa è una scoperta\nimportante!", spanish="¡Esto es un descubrimiento\nimportantísimo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¿De... de verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¿De... de verdad?"})
  else
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?!?", italian=" D-Davvero?!", spanish=" ¿De... de verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(44) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Undoubtedly! ♪", french=" Indubitablement! ♪", german=" Zweifellos! ♪", italian=" Senza dubbio! ♪", spanish=" ¡Sin duda alguna! ♪"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="After all, the presence of the\ncave behind the waterfall...", french="Vous avez tout de même\ndécouvert une grotte cachée derrière\nla cascade!", german="Dass es hinter dem Wasserfall\neine Höhle gibt...", italian="Dopotutto, la presenza della\ncaverna dietro la cascata...", spanish="Después de todo, encontrasteis\nla cueva tras la cascada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="No one knew about that\nbefore now! ♪", french="Nul n'en connaissait l'existence\njusqu'à aujourd'hui! ♪", german=" Das wusste bisher niemand! ♪", italian="Nessuno ne sapeva niente, fino\nad ora! ♪", spanish="¡Habéis descubierto algo que\nno sabía nadie! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, I see! We made a discovery!", french="Oh, je vois! Nous avons fait\nune découverte!", german="Oh, verstehe! Wir haben eine\nEntdeckung gemacht!", italian="Oh, capisco! Abbiamo fatto una\nscoperta!", spanish="¡Ah, ya lo entiendo!\n¡Hemos hecho un descubrimiento!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, I see! We made a discovery!", french="Oh, je vois! Nous avons fait\nune découverte!", german="Oh, verstehe! Wir haben eine\nEntdeckung gemacht!", italian="Oh, capisco! Abbiamo fatto una\nscoperta!", spanish="¡Ah, ya lo entiendo!\n¡Hemos hecho un descubrimiento!"})
  else
  SkySceneKit.say({english=" Oh, I see! We made a discovery!", french="Oh, je vois! Nous avons fait\nune découverte!", german="Oh, verstehe! Wir haben eine\nEntdeckung gemacht!", italian="Oh, capisco! Abbiamo fatto una\nscoperta!", spanish="¡Ah, ya lo entiendo!\n¡Hemos hecho un descubrimiento!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.UpRight)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When I had those dizzy spells...)", french="(Quand j'ai eu ces vertiges...)", german="(Als ich diese Schwindelanfälle hatte...)", italian="(Quando ho avuto quei capogiri...)", spanish="(Cuando tuve esos mareos...)"})
  else
  SkySceneKit.say({english="(When I had those dizzy spells...)", french="(Quand j'ai eu ces vertiges...)", german="(Als ich diese Schwindelanfälle hatte...)", italian="(Quando ho avuto quei capogiri...)", spanish="(Cuando tuve esos mareos...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The shadow of that Pokémon I saw...)", french="(... l'ombre du Pokémon que j'ai vu...)", german="(Da sah ich den Schatten eines Pokémon.)", italian="(L'ombra del Pokémon che ho visto...)", spanish="(La sombra de ese Pokémon que vi...)"})
  else
  SkySceneKit.say({english="(The shadow of that Pokémon I saw...)", french="(... l'ombre du Pokémon que j'ai vu...)", german="(Da sah ich den Schatten eines Pokémon.)", italian="(L'ombra del Pokémon che ho visto...)", spanish="(La sombra de ese Pokémon que vi...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
