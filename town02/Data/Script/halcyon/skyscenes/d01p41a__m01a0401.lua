-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P41A/m01a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:WaitShowTitle(GAME:GetCurrentGround().Name:ToLocal(), 30) end) -- back_SetDungeonBanner(2, 0)
  GAME:FadeIn(16)
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 16)
  GAME:WaitFrames(15)
  SkyProg.set(2, 3) -- $SCENARIO_MAIN = scn[2,3] (ROM)
  -- back_SetGround(LEVEL_D01P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GROUND:MoveToPosition(partner, 212, 204, false, 2)
  GROUND:MoveToPosition(hero, 244, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...[K] Hey!", french=" Euh...[K] Hé!", german=" Äh...[K] Hey!", italian=" Eh...[K] Ehi!", spanish=" Esto...[K] ¡Eh!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh...[K] Hey!", french=" Euh...[K] Hé!", german=" Äh...[K] Hey!", italian=" Eh...[K] Ehi!", spanish=" Esto...[K] ¡Eh!"})
  else
  SkySceneKit.say({english=" Um...[K] Hey!", french=" Euh...[K] Hé!", german=" Ähem...[K] Hey!", italian=" Ehm...[K] Ehi!", spanish=" Esto...[K] ¡Eh!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 216, 160, Direction.Up, "NPC_DOGAASU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "exclaim", 1) end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 248, 160, Direction.Up, "NPC_ZUBATTO")
  pcall(function() GROUND:CharSetEmote(npc_npc_zubatto, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Well, well...", french=" Tiens donc, voyez-vous ça...", german=" Na so was...", italian=" Bene, bene...", spanish=" Bueno, bueno..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="If it isn't our old friend, the\nbig chicken.", french="Mais c'est notre vieille\nconnaissance, la poule mouillée, si je\nne m'abuse!", german="Wenn das nicht unser alter\nFreund, die Memme, ist.", italian="Guarda un po'! È quella schiappa\ndi prima...", spanish="¡Si tenemos aquí a nuestra\ngallinita!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  else
  SkySceneKit.say({english=" Urk!", french=" Argh!", german=" Urks!", italian=" Urk!", spanish=" ¡Huy!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-8), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Give me...[K] Give me back what\nyou stole from me!", french="Rendez-moi...[K] rendez-moi ce\nque vous m'avez volé!", german="Gebt mir...[K] Gebt mir zurück,\nwas ihr gestohlen habt!", italian="Ridatemi...[K] Ridatemi quel che\nmi avete rubato!", spanish="Dadme...[K] ¡Dadme lo que me\nhabéis quitado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Give me...[K] Give me back what\nyou stole from me!", french="Rendez-moi...[K] rendez-moi ce\nque vous m'avez volé!", german="Gebt mir...[K] Gebt mir zurück,\nwas ihr gestohlen habt!", italian="Ridatemi...[K] Ridatemi quel che\nmi avete rubato!", spanish="Dadme...[K] ¡Dadme lo que me\nhabéis quitado!"})
  else
  SkySceneKit.say({english="Give me...[K] Give me back what\nyou stole from me!", french="Rendez-moi...[K] rendez-moi ce\nque vous m'avez volé!", german="Gebt mir...[K] Gebt mir zurück,\nwas ihr gestohlen habt!", italian="Ridatemi...[K] Ridatemi quel che\nmi avete rubato!", spanish="Dadme...[K] ¡Dadme lo que me\nhabéis quitado!"})
  end
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's my personal treasure!\nIt means everything to me!", french="C'est mon trésor! Il représente\ntout pour moi!", german="Das ist mein Schatz!\nEr bedeutet mir alles!", italian="È il mio tesoro! Significa tutto\nper me!", spanish="¡Se trata de mi talismán! ¡Mi\ntesoro! ¡Significa mucho para mí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's my personal treasure!\nIt means everything to me!", french="C'est mon trésor! Il représente\ntout pour moi!", german="Das ist mein Schatz!\nEr bedeutet mir alles!", italian="È il mio tesoro! Significa tutto\nper me!", spanish="¡Se trata de mi talismán! ¡Mi\ntesoro! ¡Significa mucho para mí!"})
  else
  SkySceneKit.say({english="That's my personal treasure!\nIt means everything to me!", french="C'est mon trésor! Il représente\ntout pour moi!", german="Das ist mein Schatz!\nEr bedeutet mir alles!", italian="È il mio tesoro! Significa tutto\nper me!", spanish="¡Se trata de mi talismán! ¡Mi\ntesoro! ¡Significa mucho para mí!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Treasure, you say?[K] So that\nthing really is valuable, huh?", french="Ton trésor, dis-tu?[K] Alors\nce truc aurait vraiment de la valeur, hein?", german="Schatz, sagst du?[K] Dieses Ding\nist also wirklich wertvoll, was?", italian="Tesoro, eh?[K] Quindi deve\nvalere un bel po', no?", spanish="¿Un tesoro, has dicho?[K] Así que\neste chisme es realmente valioso, ¿eh?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="It could be worth more than\nwe'd hoped for, I'd say.", french="Si ça se trouve, il vaut encore\nplus que ce qu'on pensait.", german="Ich würde sagen, das Ding\nkönnte mehr wert sein, als wir gehofft haben.", italian="Ehi, potrebbe valere più di\nquanto pensiamo.", spanish="Al menos, es mucho más valioso\nde lo que pensábamos."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="We ought to try selling it.\nWho knows? It might get a good price.", french="On peut toujours essayer de\nle vendre. Qui sait, peut-être qu'on en tirera\nun bon prix.", german="Wir sollten versuchen, es zu\nverkaufen. Wer weiß? Vielleicht kriegen wir\neinen guten Preis.", italian="Dovremmo provare a venderlo.\nChissà... potremmo ricavarne un bel gruzzolo.", spanish="Tendríamos que intentar venderlo.\n¿Quién sabe? A lo mejor sacamos un buen pico."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] All the more\nreason not to give it back!", french="Mouarf mouarf mouarf![K] Raison\nde plus pour pas te le rendre!", german="Whoahoho![K] Noch ein Grund,\nes nicht zurückzugeben!", italian="Ah ah![K] Un motivo in più\nper tenercelo!", spanish="¡Jo, jo, jo![K] ¡Nos acabas de dar\nmuchos más motivos para no devolvértelo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, "happy", 1) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whaaaat?!", french=" Non! Vous n'avez pas le droit!", german=" Waaaas?!?", italian=" Cosaaaaaa?!", spanish=" ¡¿Quéeee?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whaaaat?!", french=" Non! Vous n'avez pas le droit!", german=" Waaaas?!?", italian=" Cosaaaaaa?!", spanish=" ¡¿Quéeee?!"})
  else
  SkySceneKit.say({english=" You can't!", french=" Non! Vous n'avez pas le droit!", german=" Das könnt ihr nicht machen!", italian=" Non potete!", spanish=" ¡No podéis hacer eso!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dogaasu, nil, 0) end) -- EFFECT_NONE
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="If you want it back that\nbadly...[K] Come and get it! Heh-heh-heh!", french="Si tu y tiens tant que ça...[K]\nviens donc le chercher! Hin hin hin!", german="Wenn du es unbedingt zurück\nwillst...[K] Komm und hol es dir! Hehehe!", italian="Se ci tieni così tanto...[K]\nVieni a prenderlo! Eh-eh-eh!", spanish="Si tanto quieres recuperarlo...[K]\n¡Ven a por él! ¡Jue, jue, jue!"})
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(2, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
