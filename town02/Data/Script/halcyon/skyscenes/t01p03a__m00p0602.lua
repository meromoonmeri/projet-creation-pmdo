-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/m00p0602.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P03A) [neutre/état moteur]
  -- back_ChangeGround(LEVEL_T01P03A2) [décor déjà chargé par EnterZone PMDO]
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_garagara = SkySceneKit.spawn_npc("marowak", 256, 192, Direction.UpLeft, "NPC_GARAGARA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 268, 220, false, 2)
  GROUND:MoveToPosition(partner, 236, 220, false, 2)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! Check out that giant hole!", french="Waouh! Tu as vu? Il y a\nun gigantesque trou!", german="Boah! Sieh dir das gigantische\nLoch an!", italian=" Wow! Guarda quel buco gigante!", spanish="¡Atiza! ¡Fíjate en ese agujero\ngigante!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whoa! Look at that huge hole!", french="Waouh! Tu as vu? Il y a\nun gigantesque trou!", german="Boah! Sieh dir das riesige\nLoch an!", italian=" Wow! Guarda quel buco gigante!", spanish="¡Hala! ¡Mira ese agujero\ngigante!"})
  else
  SkySceneKit.say({english=" Wow! A giant hole opened up!", french="Waouh! Tu as vu? Il y a\nun gigantesque trou!", german="Wow! Ein riesiges Loch hat sich\ngeöffnet!", italian="Wow! Si è aperto un\nbuco gigante!", spanish="¡Vaya! ¡Se ha abierto un agujero\ngigante!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What's going on here?", french=" Mais qu'est-ce qu'il se passe ici?", german=" Was geht hier vor?", italian=" Cos'è successo?", spanish=" ¿Qué ha pasado aquí?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What just happened here?", french=" Mais qu'est-ce qu'il se passe ici?", german=" Was geschieht hier?", italian=" Cosa è successo?", spanish=" ¿Qué ha ocurrido aquí?"})
  else
  SkySceneKit.say({english=" What happened?", french=" Mais qu'est-ce qu'il se passe ici?", german=" Was ist geschehen?", italian=" Cosa è successo?", spanish=" ¿Qué ha ocurrido?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_garagara, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" The wall just gave way!", french=" Le mur vient de céder!", german=" Die Wand hat nachgegeben!", italian=" Il muro ha ceduto!", spanish=" ¡La pared acaba de desplomarse!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_garagara, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="And that big hole appeared\nwhere it was.", french="Et ce grand trou est apparu\nà la place.", german="Und an ihrer Stelle ist dieses\ngroße Loch entstanden.", italian="E quel grosso buco si è aperto\nproprio dove prima c'era il muro.", spanish="Y este gran agujero ha aparecido\nen el sitio donde estaba."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Come to think of it...[K] My grandpa\nmentioned this a long time ago...", french="En y repensant...[K] Il y a\nlongtemps, mon grand-père m'avait dit...", german="Mir fällt etwas ein...[K] Mein Opa\nhat diese Sache vor langer Zeit erwähnt...", italian="A pensarci bene...[K] mio nonno\nme ne aveva parlato tanto tempo fa...", spanish="Ahora que lo pienso...[K] Mi abuelo\nmencionó esto hace muchísimo tiempo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Your grandpa?", french=" Ton grand-père?", german=" Dein Opa?", italian=" Tuo nonno?", spanish=" ¿Tu abuelo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Your grandpa?", french=" Ton grand-père?", german=" Dein Opa?", italian=" Tuo nonno?", spanish=" ¿Tu abuelo?"})
  else
  SkySceneKit.say({english=" Your grandfather?", french=" Ton grand-père?", german=" Dein Großvater?", italian=" Tuo nonno?", spanish=" ¿Tu abuelo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_garagara, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Yeah.[K] You see, my grandpa built\nthis dojo originally.", french="Ouais.[K] Vous savez, à l'origine,\nc'est mon grand-père qui a construit ce dojo.", german="Ja.[K] Wisst ihr, mein Opa hat\ndieses Dojo ursprünglich erbaut.", italian="Sì.[K] È stato lui a costruire\nil dojo.", spanish="Sí.[K] Mi abuelo fue quien\nconstruyó este dojo."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="And that same grandpa told me\nthere was a very dangerous cave here.", french="Et c'est aussi lui qui m'a dit\nqu'il y avait une grotte très dangereuse ici.", german="Und eben jener Opa erzählte mir\nvon einer sehr gefährlichen Höhle, die es hier\ngeben soll.", italian="Ed è stato lui a dirmi che qui si\ntrova una caverna molto pericolosa.", spanish="Y fue él quien me dijo que\naquí había una cueva muy peligrosa."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="It was so dangerous...[K]he had\nthe hole sealed up so no one could get in.\nI remember that now.", french="C'était tellement dangereux...[K]\nqu'il a condamné ce trou pour que personne ne\npuisse y entrer. Je m'en souviens maintenant!", german="So gefährlich, dass man das\nLoch versiegeln ließ, damit niemand hinein\nkonnte. [K]Ich erinnere mich jetzt wieder.", italian="Talmente pericolosa...[K] che ha\nfatto sigillare il buco in modo che nessuno\npotesse entrarci. Adesso me lo ricordo.", spanish="Era tan peligrosa...[K] que decidió\ntapiar el agujero para que nadie pudiera\nentrar. Sí, ahora lo recuerdo."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Back then, my grandpa used to\ntell me about that hole. And he'd never once\nfail to scare me silly...", french="Mon grand-père me parlait\nsouvent de ce trou. Et à chaque fois, mes os\ntremblaient de terreur...", german="Damals erzählte mir mein Opa\nimmer von diesem Loch. Er schaffte es\njedes Mal, mir damit Angst zu machen...", italian="All'epoca, mio nonno mi parlava\nspesso di quel buco. E ogni volta riusciva a\nspaventarmi...", spanish="Mi abuelo solía hablarme del\nagujero a menudo. Y ni una vez dejó\nde asustarme con la historia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_garagara, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english=" ...![K] Y-you two... You're not...", french="...![K] Vous deux... non, ce n'est pas\npossible...", german=" I-ihr[K]... Ihr wollt doch nicht...", italian=" V-Voi due...[K] non vorrete...", spanish=" Oye...[K] ¿No estaréis pensando...?"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="You're not seriously considering\ngoing into that hole, are you?", french="Vous plaisantez, j'espère? Vous\nvoulez vraiment entrer dans cette grotte?", german="Ihr wollt doch nicht etwa in\ndieses Loch steigen, oder?", italian="Non vorrete davvero entrare\nin quel buco, vero?", spanish="No estaréis pensando seriamente\nen entrar en ese agujero, ¿verdad?"})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="Don't do it.[K] Don't even think\nabout it.", french="Ne faites pas ça.[K] N'y pensez\nmême pas!", german="Tut es nicht.[K] Denkt nicht mal\ndaran.", italian="Non fatelo.[K] Non pensateci\nnemmeno.", spanish=" No lo hagáis.[K] Ni se os ocurra."})
  pcall(function() UI:SetSpeaker(npc_npc_garagara) end)
  SkySceneKit.say({english="I... I can't guarantee that you'll\never come out of there...", french="Je... je ne peux même pas vous\ngarantir que vous en reviendrez...", german="Ich... Ich kann euch nicht\ngarantieren, dass ihr da je wieder rauskommt.", italian="Non... non posso garantirvi che\nriuscirete a uscire da lì...", spanish="Yo... no puedo garantizar que\nconsigáis salir de allí de una pieza."})
  do local p=npc_npc_garagara.Position; GROUND:MoveToPosition(npc_npc_garagara, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_garagara.Position; GROUND:MoveToPosition(npc_npc_garagara, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_garagara.Position; GROUND:MoveToPosition(npc_npc_garagara, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_garagara.Position; GROUND:MoveToPosition(npc_npc_garagara, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  -- message_Close
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  SkySceneKit.cleanup_npcs()
end
