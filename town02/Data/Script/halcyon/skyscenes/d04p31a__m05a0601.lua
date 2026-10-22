-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D04P31A/m05a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(6, 6) -- $SCENARIO_MAIN = scn[6,6] (ROM)
  -- back_SetGround(LEVEL_D04P31A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 232, 284, false, 2)
  GROUND:MoveToPosition(hero, 272, 284, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 252, 316, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 288, 316, false, 2) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow! Check that out,\n[hero]!", french="Waouh! T'as vu ça,\n[hero]!", german=" Wow! Sieh mal, [hero]!", italian="Wow! Guarda,\n[hero]!", spanish=" ¡Vaya! ¡Mira eso, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! Look at that,\n[hero]!", french="Waouh! T'as vu ça,\n[hero]!", german="Wow! Sieh dir das an,\n[hero]!", italian="Wow! Guarda,\n[hero]!", spanish=" ¡Vaya! ¡Mira eso, [hero]!"})
  else
  SkySceneKit.say({english="Wow! Will you look at that,\n[hero]!", french="Waouh! T'as vu ça,\n[hero]!", german="Wow! Sieh dir das mal an,\n[hero]!", italian="Wow! Guarda,\n[hero]!", spanish=" ¡Vaya! ¡Mira eso, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look at all the gems sparkling!", french="Regarde toutes ces gemmes qui\nscintillent!", german="Sieh dir all die funkelnden\nEdelsteine an!", italian="Guarda come luccicano tutte\nqueste gemme!", spanish=" ¡Cómo brillan todas esas gemas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look at all the gems sparkling!", french="Regarde toutes ces gemmes qui\nscintillent!", german="Sieh dir all die funkelnden\nEdelsteine an!", italian="Guarda come luccicano tutte\nqueste gemme!", spanish=" ¡Cómo brillan todas esas gemas!"})
  else
  SkySceneKit.say({english=" Look at all the gems sparkling!", french="Regarde toutes ces gemmes qui\nscintillent!", german="Sieh dir all die funkelnden\nEdelsteine an!", italian="Guarda come luccicano tutte\nqueste gemme!", spanish=" ¡Cómo brillan todas esas gemas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, check that out! It's a\ngigantic gem!", french="Waouh! Cette gemme est\ngigantesque!", german="Hey, schau mal! Ein riesiger\nEdelstein!", italian="Ehi, dai un'occhiata lì! È una\ngemma gigante!", spanish=" ¡Eh, fíjate! ¡Menuda gema!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Whoa, look over there! It's a\ngigantic gem!", french="Waouh! Cette gemme est\ngigantesque!", german="Boah, sieh mal da! Ein riesiger\nEdelstein!", italian="Ehi, dai un'occhiata lì! È una\ngemma gigante!", spanish="¡Vaya, fíjate! ¡Es una gema\nenorme!"})
  else
  SkySceneKit.say({english="Wow, look over there! It's a\ngigantic gem!", french="Waouh! Cette gemme est\ngigantesque!", german="Wow, sieh mal da! Ein riesiger\nEdelstein!", italian="Ehi, dai un'occhiata lì! È una\ngemma gigante!", spanish="¡Vaya, fíjate! ¡Es una gema\ngigantesca!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(252, 196, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 232, 204, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 272, 204, false, 2)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 204, 252, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 300, 252, false, 2) end end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.Up) end end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Awesome! I've never seen a gem\nthis humongous!", french="Incroyable! Je n'ai jamais vu\nune gemme de cette taille!", german="Wow! So einen riesengroßen\nEdelstein habe ich noch nie gesehen!", italian="Magnifica! Non avevo mai visto\nuna gemma di queste dimensioni!", spanish="¡Asombroso! ¡Nunca había visto\nuna gema tan grande!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow! I've never seen a gem\nthis huge!", french="Incroyable! Je n'ai jamais vu\nune gemme de cette taille!", german="Toll! So einen gigantischen\nEdelstein habe ich noch nie gesehen!", italian="Magnifica! Non avevo mai visto\nuna gemma così enorme!", spanish="¡Vaya! ¡Nunca había visto una\ngema tan inmensa!"})
  else
  SkySceneKit.say({english="Oh, wow! I've never seen\na gem this immense!", french="Incroyable! Je n'ai jamais vu\nune gemme de cette taille!", german="Toll! So einen enormen\nEdelstein habe ich noch nie gesehen!", italian="Magnifica! Non avevo mai visto\nuna gemma così grande!", spanish="¡Oh, vaya! ¡Nunca había visto\nuna gema tan inmensa!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This is an incredible treasure!", french=" Quel trésor incroyable!", german="Was für ein unglaublicher\nSchatz!", italian=" Questo è un tesoro incredibile!", spanish=" ¡Es un tesoro increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This is an incredible treasure!", french=" Quel trésor incroyable!", german="Was für ein unglaublicher\nSchatz!", italian=" Questo è un tesoro incredibile!", spanish=" ¡Es un tesoro increíble!"})
  else
  SkySceneKit.say({english=" This is an incredible treasure!", french=" Quel trésor incroyable!", german="Was für ein unglaublicher\nSchatz!", italian="Questo è un tesoro di\ninestimabile valore!", spanish=" ¡Es un tesoro increíble!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone's going to be really\nimpressed when we take this back with us!", french="On va impressionner tout le\nmonde si on la rapporte!", german="Alle werden schwer beeindruckt\nsein, wenn wir mit dem zurückkommen!", italian="Rimarranno tutti a bocca aperta\nquando torneremo con questa!", spanish="¡Todos se van a llevar\nuna sorpresa cuando volvamos con esto!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone will be amazed if we\ntake this back.", french="On va impressionner tout le\nmonde si on la rapporte!", german="Alle werden staunen, wenn wir\nmit dem zurückkommen!", italian="Rimarranno tutti a bocca aperta\nquando torneremo con questa!", spanish="¡Todos se van a llevar\nuna sorpresa si volvemos con esto!"})
  else
  SkySceneKit.say({english="Everyone will be amazed if we\ntake this back.", french="On va impressionner tout le\nmonde si on la rapporte!", german="Alle werden staunen, wenn wir\nmit dem zurückkommen!", italian="Rimarranno tutti a bocca aperta\nquando torneremo con questa!", spanish="¡Todos se van a llevar\nuna sorpresa si volvemos con esto!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:MoveToPosition(partner, 252, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- SetAnimation(67) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] tried to grab\n[CN]the giant gem.", french="[CN][partner] essaie de prendre\n[CN]la gemme géante.", german="[CN][partner] versucht,\n[CN]den riesigen Edelstein zu nehmen.", italian="[CN][partner] prova a prendere\n[CN]la gemma gigante.", spanish="[CN][partner] intentó coger\n[CN]la gema gigante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(67) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urrrrgh! Urrrrgh![K] Ugh...", french=" Aaargh! Aaaaargh![K] Pff...", german=" Urrrrgh! Urrrrgh![K] Uff...", italian=" Urrrrgh! Urrrrgh![K] Ugh...", spanish=" ¡Aaah! ¡Uuuf![K] ¡Uf...!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urrrrgh! Urrrrgh![K] Ugh...", french=" Aaargh! Aaaaargh![K] Pff...", german=" Urrrrgh! Urrrrgh![K] Uff...", italian=" Urrrrgh! Urrrrgh![K] Ugh...", spanish=" ¡Aaah! ¡Uuuf![K] ¡Uf...!"})
  else
  SkySceneKit.say({english=" Urrrrgh! Urrrrgh![K] Ugh...", french=" Aaargh! Aaaaargh![K] Pff...", german=" Urrrrgh! Urrrrgh![K] Uff...", italian=" Urrrrgh! Urrrrgh![K] Ugh...", spanish=" ¡Aaah! ¡Uuuf![K] ¡Uf...!"})
  end
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Nope, it's not budging...", french="Non, elle ne bouge pas d'un\npouce...", german=" Er rührt sich kein Stück.", italian=" No, non si muove...", spanish=" No se ha movido ni un milímetro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Nope, it's not budging...", french="Non, elle ne bouge pas d'un\npouce...", german=" Er rührt sich kein Stück.", italian=" No, non si muove...", spanish=" No, esto no cede."})
  else
  SkySceneKit.say({english=" Nope, it's not budging...", french="Non, elle ne bouge pas d'un\npouce...", german=" Er rührt sich kein Stück.", italian=" No, non si muove...", spanish=" Es imposible moverla."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's really stuck tight.", french=" Elle est complètement coincée.", german=" Er steckt wirklich fest.", italian=" È proprio incastrata.", spanish=" Realmente está bien sujeta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's really stuck tight.", french=" Elle est complètement coincée.", german=" Er steckt wirklich fest.", italian=" È proprio incastrata.", spanish=" Realmente está bien sujeta."})
  else
  SkySceneKit.say({english=" It's really stuck tight.", french=" Elle est complètement coincée.", german=" Er steckt wirklich fest.", italian=" È proprio incastrata.", spanish=" Realmente está bien sujeta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Can you give it a try,\n[hero]?", french="Tu veux essayer,\n[hero]?", german="Kannst du es mal versuchen,\n[hero]?", italian="Puoi provare tu,\n[hero]?", spanish="¿Por qué no pruebas tú,\n[hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Can you give it a try,\n[hero]?", french="Tu veux essayer,\n[hero]?", german="Kannst du es mal versuchen,\n[hero]?", italian="Puoi provare tu,\n[hero]?", spanish="¿Por qué no pruebas tú,\n[hero]?"})
  else
  SkySceneKit.say({english="Can you give it a try,\n[hero]?", french="Tu veux essayer,\n[hero]?", german="Kannst du es mal versuchen,\n[hero]?", italian="Puoi provare tu,\n[hero]?", spanish="¿Por qué no pruebas tú,\n[hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-40), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 252, 164, false, 2)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] took over and tried\n[CN]to pull out the gigantic gem.", french="[CN][hero] s'approche et essaie\n[CN]de sortir la gemme géante.", german="[CN][hero] übernimmt und versucht,\n[CN]den riesigen Edelstein herauszureißen.", italian="[CN][hero] si avvicina e prova a\n[CN]smuovere la gemma gigante.", spanish="[CN][hero] intentó arrancar\n[CN]la gigantesca gema."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(67) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(67) [anim idle native]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Whoa!)", french="(Pfiou!)", german="(Wow!)", italian="(Whoa!)", spanish="(¡Uf!)"})
  else
  SkySceneKit.say({english="(Whoa!)", french="(Pfiou!)", german="(Wow!)", italian="(Whoa!)", spanish="(¡Uf!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This is really stuck!)", french="(Elle est bel et bien coincée!)", german="(Der steckt wirklich bombenfest!)", italian="(È completamente incastrata!)", spanish="(¡Está bien sujeta!)"})
  else
  SkySceneKit.say({english="(This is really stuck!)", french="(Elle est bel et bien coincée!)", german="(Der steckt wirklich bombenfest!)", italian="(È completamente incastrata!)", spanish="(¡Está bien sujeta!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It won't budge!)", french="(Impossible de la faire bouger!)", german="(Er rührt sich nicht!)", italian="(Non si sposta di un millimetro!)", spanish="(¡No hay quien la suelte!)"})
  else
  SkySceneKit.say({english="(It won't budge!)", french="(Impossible de la faire bouger!)", german="(Er rührt sich nicht!)", italian="(Non si sposta di un millimetro!)", spanish="(¡No hay quien la suelte!)"})
  end
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Urrrrgh...ugh...[K] Nope, no good...)", french="(Aaargh... Argh...[K] Non, rien à faire...)", german="(Urrrrgh... Uff...[K] Nein, es bringt nichts.)", italian="(Urrrrgh... Ugh...[K] No, niente da fare...)", spanish="(Aaah... uf...[K] No, no hay manera.)"})
  else
  SkySceneKit.say({english="(Urrrrgh...ugh...[K] Nope, no good...)", french="(Aaargh... Argh...[K] Non, rien à faire...)", german="(Urrrrgh... Uff...[K] Nein, es bringt nichts.)", italian="(Urrrrgh... Ugh...[K] No, niente da fare...)", spanish="(Aaah... uf...[K] No, no hay forma.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So you couldn't move it either,\n[hero]...", french="Tu n'y arrives pas non plus,\n[hero]...", german="Du kannst ihn also auch nicht\nbewegen, [hero].", italian="Quindi non riesci a spostarla\nneanche tu, [hero]...", spanish="Así que tú tampoco has podido\nmoverla, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So you couldn't move it either,\n[hero]...", french="Tu n'y arrives pas non plus,\n[hero]...", german="Du kannst ihn also auch nicht\nbewegen, [hero].", italian="Quindi non riesci a spostarla\nneanche tu, [hero]...", spanish="Así que tú tampoco has podido\nmoverla, [hero]."})
  else
  SkySceneKit.say({english="So you couldn't move it either,\n[hero]...", french="Tu n'y arrives pas non plus,\n[hero]...", german="Du kannst ihn also auch nicht\nbewegen, [hero].", italian="Quindi non riesci a spostarla\nneanche tu, [hero]...", spanish="Así que tú tampoco has podido\nmoverla, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But we can't just give up.", french=" On ne peut pas laisser tomber.", german="Aber wir können nicht einfach\naufgeben.", italian="Ma non possiamo\narrenderci così.", spanish=" Pero no podemos rendirnos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But we can't just give up.", french=" On ne peut pas laisser tomber.", german="Aber wir können nicht einfach\naufgeben.", italian="Ma non possiamo\narrenderci così.", spanish=" Pero no podemos rendirnos."})
  else
  SkySceneKit.say({english=" But we can't just give up.", french=" On ne peut pas laisser tomber.", german="Aber wir können nicht einfach\naufgeben.", italian="Ma non possiamo\narrenderci così.", spanish=" Pero no podemos rendirnos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we try hard enough, we'll\nprobably get some kind of result!", french="On va bien finir par y arriver\nen persévérant un peu!", german="Wenn wir uns genug anstrengen,\nmuss es doch irgendetwas bringen!", italian="Probabilmente, se ce la mettiamo\ntutta, possiamo farcela!", spanish="¡Si seguimos intentándolo,\nal final conseguiremos algo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we try hard enough, we'll\nprobably get some kind of result!", french="On va bien finir par y arriver\nen persévérant un peu!", german="Wenn wir uns genug anstrengen,\nmuss es doch irgendetwas bringen!", italian="Probabilmente, se ce la mettiamo\ntutta, riusciremo a ottenere qualche risultato!", spanish="¡Si seguimos intentándolo,\nal final conseguiremos algo!"})
  else
  SkySceneKit.say({english="If we try hard enough, we'll\nprobably get some kind of result!", french="On va bien finir par y arriver\nen persévérant un peu!", german="Wenn wir uns genug anstrengen,\nmuss es doch irgendetwas bringen!", italian="Probabilmente, se ce la mettiamo\ntutta, possiamo riuscire a smuoverla.", spanish="¡Si seguimos intentándolo,\nal final conseguiremos algo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm going to give it another go,\n[hero]!", french="J'essaie encore une fois,\n[hero]!", german="Ich versuche es noch einmal,\n[hero]!", italian="Voglio provarci un'altra volta,\n[hero]!", spanish="¡Yo voy a intentarlo otra vez,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm going to give it another go,\n[hero]!", french="J'essaie encore une fois,\n[hero]!", german="Ich versuche es noch einmal,\n[hero]!", italian="Voglio provarci un'altra volta,\n[hero]!", spanish="¡Yo voy a intentarlo otra vez,\n[hero]!"})
  else
  SkySceneKit.say({english="I'm going to give it another go,\n[hero]!", french="J'essaie encore une fois,\n[hero]!", german="Ich versuche es noch einmal,\n[hero]!", italian="Voglio provarci un'altra volta,\n[hero]!", spanish="¡Yo voy a intentarlo otra vez,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(40), p.Y+(24), false, 2) end
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 252, 164, false, 2)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] tried to pull out\n[CN]the gigantic gem again.", french="[CN][partner] essaie encore une fois\n[CN]de sortir la gemme géante.", german="[CN][partner] versucht noch einmal,\n[CN]den riesigen Edelstein herauszuziehen.", italian="[CN][partner] prova ancora a spostare la\n[CN]gemma enorme.", spanish="[CN][partner] intentó arrancar\n[CN]otra vez la gema gigantesca."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(67) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  else
  SkySceneKit.say({english=" Urrrrrrgh![K] Urrrrrrgh!", french=" Aaargh! [K]Aaaaargh!", german=" Urrrrrrgh![K] Urrrrrrgh!", italian=" Urrrrrrgh![K] Urrrrrrgh!", spanish=" ¡Aaah![K] ¡Uuuuf!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Hmm...)", french="(Hum...)", german="(Hmm...)", italian="(Mmm...)", spanish="(Hum...)"})
  else
  SkySceneKit.say({english="(Hmm...)", french="(Hum...)", german="(Hmm...)", italian="(Mmm...)", spanish="(Hum...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's not budging one bit...)", french="(Elle n'a pas bougé d'un millimètre...)", german="(Er lässt sich keinen Millimeter bewegen.)", italian="(Non si sposta di un millimetro...)", spanish="(No está cediendo lo más mínimo...)"})
  else
  SkySceneKit.say({english="(It's not budging one bit...)", french="(Elle n'a pas bougé d'un millimètre...)", german="(Er lässt sich keinen Millimeter bewegen.)", italian="(Non si sposta di un millimetro...)", spanish="(No está cediendo lo más mínimo...)"})
  end
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Huh?[K] Oh no...)", french="(Hein?[K] Oh non...)", german="(Huch?[K] Oh nein...)", italian="(Eh?[K] Oh, no...)", spanish="(¿Eh?[K] Oh, no...)"})
  else
  SkySceneKit.say({english="(Huh?[K] Oh no...)", french="(Hein?[K] Oh non...)", german="(Huch?[K] Oh nein...)", italian="(Eh?[K] Oh, no...)", spanish="(¿Eh?[K] Oh, no...)"})
  end
  -- message_Close
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's happening again...)", french="(Ça recommence...)", german="(Es passiert schon wieder.)", italian="(Sta succedendo ancora...)", spanish="(Otra vez me está pasando...)"})
  else
  SkySceneKit.say({english="(It's happening again...)", french="(Ça recommence...)", german="(Es passiert schon wieder.)", italian="(Sta succedendo ancora...)", spanish="(Otra vez me está pasando...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's...)", french="(C'est...)", german="(Es ist...)", italian="(È...)", spanish="(Es...)"})
  else
  SkySceneKit.say({english="(It's...)", french="(C'est...)", german="(Es ist...)", italian="(È...)", spanish="(Es...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 5)
end
