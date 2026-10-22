-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P01A/m09a0601.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_P03P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(300), g.ViewCenter.Y+(0), 600, false) end) -- MovePositionOffset performer/caméra
  -- GAP: BGM BGM_RAIN2 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(180)
  GAME:WaitFrames(180)
  GAME:WaitFrames(90)
  GAME:FadeOut(false,  60)
  pcall(function() GAME:MoveCamera(376, 716, 1, false) end) -- SetPositionMark performer/caméra
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 356, 716, false, 2)
  GROUND:MoveToPosition(hero, 396, 716, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Awesome! The water's coming\ndown in waterfalls all over the place!", french="C'est incroyable! Il y a des\ncascades partout!", german="Toll! Dieser Ort besteht aus\nlauter Wasserfällen!", italian="Fantastico! Questo posto è\npieno di cascate!", spanish="¡Increíble! ¡Hay cascadas\npor todas partes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's incredible! The water's\ncoming down in waterfalls all over the place!", french="C'est incroyable! Il y a des\ncascades partout!", german="Unglaublich! Dieser Ort besteht\naus lauter Wasserfällen!", italian="Fantastico! Questo posto è\npieno di cascate!", spanish="¡Increíble! ¡Hay cascadas\npor todas partes!"})
  else
  SkySceneKit.say({english="It's incredible! The water's\ncoming down in waterfalls all over the place!", french="C'est incroyable! Il y a des\ncascades partout!", german="Unglaublich! Dieser Ort besteht\naus lauter Wasserfällen!", italian="Fantastico! Questo posto è\npieno di cascate!", spanish="¡Increíble! ¡Hay cascadas\npor todas partes!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But... Where are we?", french=" Mais... où sommes-nous?", german=" Aber... Wo sind wir?", italian=" Ma... dove siamo?", spanish=" Pero... ¿dónde estamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But... Where are we?", french=" Mais... où sommes-nous?", german=" Aber... Wo sind wir?", italian=" Ma... dove siamo?", spanish=" Pero... ¿dónde estamos?"})
  else
  SkySceneKit.say({english=" But... Where are we?", french=" Mais... où sommes-nous?", german=" Aber... Wo sind wir?", italian=" Ma... dove siamo?", spanish=" Pero... ¿dónde estamos?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Is this the deepest part of\nthe forest?", french=" Au cœur de la forêt?", german="Ist das der tiefste Teil des\nWaldes?", italian="Sarà questo il cuore della\nforesta?", spanish="¿Estamos en el corazón del\nbosque?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Is this the deepest part of\nthe forest?", french=" Au cœur de la forêt?", german="Ist das der tiefste Teil des\nWaldes?", italian="Sarà questo il cuore della\nforesta?", spanish="¿Estamos en el corazón del\nbosque?"})
  else
  SkySceneKit.say({english="Is this the deepest part of\nthe forest?", french=" Au cœur de la forêt?", german="Ist das der tiefste Teil des\nWaldes?", italian="Sarà questo il cuore della\nforesta?", spanish="¿Estamos en el corazón del\nbosque?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm... The fog is so thick, I\ncan't tell which way we can go.", french="Hmm... Le brouillard est si épais\nque je ne sais pas du tout où nous allons.", german="Hmm... Der Nebel ist so dicht,\ndass ich nicht weiß, welchen Weg wir nehmen\nsollen.", italian="Mmm... La nebbia è così fitta\nche non riesco a capire da che parte dobbiamo\nandare.", spanish="Hum. La niebla es tan espesa\nque no sé por dónde podemos ir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm... The fog is so thick, I\ncan't tell which way we can go.", french="Hmm... Le brouillard est si épais\nque je ne sais pas du tout où nous allons.", german="Hmm... Der Nebel ist so dicht,\ndass ich nicht weiß, welchen Weg wir nehmen\nsollen.", italian="Mmm... La nebbia è così fitta\nche non riesco a capire da che parte dobbiamo\nandare.", spanish="Hum. La niebla es tan espesa\nque no sé por dónde podemos ir."})
  else
  SkySceneKit.say({english="Hmm... The fog is so thick, I\ncan't tell which way we can go.", french="Hmm... Le brouillard est si épais\nque je ne sais pas du tout où nous allons.", german="Hmm... Der Nebel ist so dicht,\ndass ich nicht weiß, welchen Weg wir nehmen\nsollen.", italian="Mmm... La nebbia è così fitta\nche non riesco a capire da che parte dobbiamo\nandare.", spanish="Hum. La niebla es tan espesa\nque no sé por dónde podemos ir."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oyeeee!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Look, it's [CS:N]Corphish[CR]!", french=" Regarde, c'est [CS:N]Ecrapince[CR]!", german=" Sieh, da ist [CS:N]Krebscorps[CR]!", italian=" Ehi, è [CS:N]Corphish[CR]!", spanish=" Vaya, ¡si es [CS:N]Corphish[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Look, it's [CS:N]Corphish[CR]!", french=" Regarde, c'est [CS:N]Ecrapince[CR]!", german=" Sieh, da ist [CS:N]Krebscorps[CR]!", italian=" Ehi, è [CS:N]Corphish[CR]!", spanish=" Vaya, ¡si es [CS:N]Corphish[CR]!"})
  else
  SkySceneKit.say({english=" Look, it's [CS:N]Corphish[CR]!", french=" Regarde, c'est [CS:N]Ecrapince[CR]!", german=" Sieh, da ist [CS:N]Krebscorps[CR]!", italian=" Ehi, è [CS:N]Corphish[CR]!", spanish=" Vaya, ¡si es [CS:N]Corphish[CR]!"})
  end
  -- message_Close
  pcall(function() GAME:MoveCamera(376, 604, 60, false) end) -- performer/caméra
  GAME:WaitFrames(45)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 376, 568, Direction.Down, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:MoveToPosition(hero, 396, 604, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(partner, 356, 604, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! You two find\nany clues?", french="Hé! Vous avez trouvé\ndes indices?", german="Hey, hey! Habt ihr schon etwas\ngefunden?", italian="Ehi, ehi! Avete trovato qualche\nindizio?", spanish="¡Oye, oyeee! ¿Habéis encontrado\nalguna pista?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No, nothing yet...", french=" Non, pas encore...", german=" Nein, noch nichts...", italian=" No, ancora niente...", spanish=" No, aún no."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, nothing yet...", french=" Non, pas encore...", german=" Nein, noch nichts...", italian=" No, ancora niente...", spanish=" No, aún no."})
  else
  SkySceneKit.say({english=" No, nothing yet...", french=" Non, pas encore...", german=" Nein, noch nichts...", italian=" No, ancora niente...", spanish=" No, aún no."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What about you, [CS:N]Corphish[CR]?", french=" Et toi, [CS:N]Ecrapince[CR]?", german=" Und du, [CS:N]Krebscorps[CR]?", italian=" E tu, [CS:N]Corphish[CR]?", spanish=" ¿Y tú, [CS:N]Corphish[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" How about you, [CS:N]Corphish[CR]?", french=" Et toi, [CS:N]Ecrapince[CR]?", german=" Und du, [CS:N]Krebscorps[CR]?", italian=" E tu, [CS:N]Corphish[CR]?", spanish=" ¿Y tú, [CS:N]Corphish[CR]?"})
  else
  SkySceneKit.say({english="How about you, [CS:N]Corphish[CR]?\nAny luck?", french=" Et toi, [CS:N]Ecrapince[CR]?", german="Und du, [CS:N]Krebscorps[CR]?\nHattest du schon Glück?", italian="E tu, [CS:N]Corphish[CR]? Hai avuto\nfortuna?", spanish=" ¿Y tú, [CS:N]Corphish[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I've got nothing here, either.\nDon't let it get you down.", french="J'ai rien trouvé non plus.\nMais ne vous laissez pas abattre.", german="Ich habe auch nichts gefunden.\nLasst euch nicht entmutigen.", italian="Non ho trovato niente neppure\nio. Non sentitevi giù.", spanish="No sois los únicos con las manos\nvacías. Yo tampoco encontré gran cosa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="But... There is something here\nthat's kind of interesting.", french="Il y a tout de même quelque\nchose d'intéressant ici.", german="Aber es gibt da etwas,\ndas irgendwie interessant ist.", italian="Ma... qui c'è qualcosa di\nabbastanza interessante.", spanish="Aunque he encontrado algo que\npuede ser interesante."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Interesting?", french=" Intéressant?", german=" Interessant?", italian=" Interessante?", spanish=" ¿Y eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Interesting?", french=" Intéressant?", german=" Interessant?", italian=" Interessante?", spanish=" ¿Algo interesante?"})
  else
  SkySceneKit.say({english=" Interesting?", french=" Intéressant?", german=" Interessant?", italian=" Interessante?", spanish=" ¿Algo interesante?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" There. Have a look for yourself.", french=" Ici. Regarde par toi-même.", german=" Da. Seht es euch selbst an.", italian="Ecco, date un'occhiata anche\nvoi.", spanish="Allí está. Podéis verlo con\nvuestros propios ojos."})
  -- message_Close
  pcall(function() GAME:MoveCamera(376, 484, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(45)
  GROUND:MoveToPosition(npc_npc_heigani, 376, 484, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 396, 500, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 356, 500, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Wh-what?! What is this?!", french=" Qu'est-ce que c'est?!", german=" W-was?!? Was ist das?!?", italian=" C-Cosa?! E questa cos'è?!", spanish=" Pero... ¿qué es esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wh-what?! What is this?!", french=" Qu'est-ce que c'est?!", german=" W-was?!? Was ist das?!?", italian=" C-Cosa?! E questa cos'è?!", spanish=" Pero... ¿qué es esto?"})
  else
  SkySceneKit.say({english=" Wh-what?! What is this?!", french=" Qu'est-ce que c'est?!", german=" W-was?!? Was ist das?!?", italian=" C-Cosa?! E questa cos'è?!", spanish=" Pero... ¿qué es esto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" I don't know.", french=" Je ne sais pas.", german=" Ich weiß es nicht.", italian=" Non lo so.", spanish=" Ni idea."})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="It seems to be a statue of\na Pokémon.", french="Dis donc! On dirait une statue de\nPokémon.", german="Es scheint eine Statue von\neinem Pokémon zu sein.", italian="Sembrerebbe la statua di un\nPokémon.", spanish="Parece la estatua de un\nPokémon."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But what kind of Pokémon\nis that?", french=" Mais c'est quel Pokémon?", german="Aber was ist das für ein\nPokémon?", italian=" Ma che Pokémon è quello?", spanish="¿Pero de qué tipo de Pokémon\nse trata?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But what kind of Pokémon\nis that?", french=" Mais c'est quel Pokémon?", german="Aber was ist das für ein\nPokémon?", italian=" Ma che Pokémon è quello?", spanish="¿Pero de qué tipo de Pokémon\nse trata?"})
  else
  SkySceneKit.say({english="But what kind of Pokémon\nis that?", french=" Mais c'est quel Pokémon?", german="Aber was ist das für ein\nPokémon?", italian=" Ma che Pokémon è quello?", spanish="¿Pero de qué tipo de Pokémon\nse trata?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="I've never seen a Pokémon like\nthat before.", french="Je n'avais jamais vu de Pokémon\nde ce genre.", german="So ein Pokémon habe ich noch\nnie gesehen.", italian="È la prima volta che vedo un\nPokémon del genere.", spanish="Nunca antes había visto un\nPokémon como ese."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-32), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(60)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(56), p.Y+(0), false, 2) end
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(partner, 424, 436, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(hero, Direction.UpRight)
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Is this an inscription here?", french="Tiens? On dirait qu'il y a une\ninscription, là!", german=" Hey, ist das eine Inschrift?", italian=" Eh? Questa è una scritta?", spanish="¡Mira! Aquí parece que hay una\ninscripción."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh? Is something inscribed\nhere?", french="Tiens? On dirait qu'il y a une\ninscription, là!", german=" Oh, ist das eine Inschrift?", italian=" Eh? Questa è una scritta?", spanish="¡Mira! Aquí parece que hay una\ninscripción."})
  else
  SkySceneKit.say({english=" Huh? Is this an inscription here?", french="Tiens? On dirait qu'il y a une\ninscription, là!", german=" Hey, ist das eine Inschrift?", italian=" Eh? Questa è una scritta?", spanish="¡Mira! Aquí parece que hay una\ninscripción."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(376, 456, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 432, 452, false, 2)
  GAME:WaitFrames(15)
  GROUND:MoveToPosition(npc_npc_heigani, 416, 468, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- screen2_FadeOut [sub déjà caché]
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V09P01A) [décor sub chargé: Sub_v09p01a]
  -- camera2_SetPositionMark(Position<'m14', 20, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v09p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's in footprint runes. Let me\nread it...", french="Ce sont des runes en forme\nd'empreintes. Laisse-moi lire...", german="Das sind Fußabdruckrunen.\nLass es mich lesen...", italian="È in Pokéroglifici. Fatemi dare\nun'occhiata...", spanish="Son inscripciones rúnicas.\nDéjame leerlas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's in footprint runes. Let me\nread it...", french="Ce sont des runes en forme\nd'empreintes. Laisse-moi lire...", german="Das sind Fußabdruckrunen.\nLass es mich lesen...", italian="È in Pokéroglifici. Fatemi dare\nun'occhiata...", spanish="Son inscripciones rúnicas.\nDéjame leerlas..."})
  else
  SkySceneKit.say({english="It's in footprint runes. Let me\nread it...", french="Ce sont des runes en forme\nd'empreintes. Laisse-moi lire...", german="Das sind Fußabdruckrunen.\nLass es mich lesen...", italian="È in Pokéroglifici. Fatemi dare\nun'occhiata...", spanish="Son inscripciones rúnicas.\nDéjame leerlas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähhh...", italian=" Uhm...", spanish=" Hum."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähhh...", italian=" Uhm...", spanish=" Hum."})
  else
  SkySceneKit.say({english=" Umm...", french=" Hmm...", german=" Ähhh...", italian=" Uhm...", spanish=" Hum."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"Reignite the life that burned\nwithin Groudon...\"", french="\"Ranimez la flamme de la vie\nqui brûlait jadis en Groudon...", german="[F:S2]Entfache wieder das in Groudon\nerloschene Leben...[F:E2]", italian="\"Riaccendete la vita che\npulsava dentro Groudon...\"", spanish="\"Prende de nuevo la vida que\nardía dentro de Groudon...\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"Reignite the life that burned\nwithin Groudon...\"", french="\"Ranimez la flamme de la vie\nqui brûlait jadis en Groudon...", german="[F:S2]Entfache wieder das in Groudon\nerloschene Leben...[F:E2]", italian="\"Riaccendete la vita che\npulsava dentro Groudon...\"", spanish="\"Prende de nuevo la vida que\nardía dentro de Groudon...\""})
  else
  SkySceneKit.say({english="\"Reignite the life that burned\nwithin Groudon...\"", french="\"Ranimez la flamme de la vie\nqui brûlait jadis en Groudon...", german="[F:S2]Entfache wieder das in Groudon\nerloschene Leben...[F:E2]", italian="\"Riaccendete la vita che\npulsava dentro Groudon...\"", spanish="\"Prende de nuevo la vida que\nardía dentro de Groudon...\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"Then the sky shall blaze with\nthe sun's heat...\"", french="Le ciel s'embrasera alors de la\nchaleur du soleil...", german="[F:S2]Dann wird die Hitze der Sonne\nden Himmel entflammen...[F:E2]", italian="\"... poi il calore del sole\ninfiammerà il cielo...\"", spanish="\"Y el cielo se encenderá con el\ncalor del sol.\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"Then the sky shall blaze with\nthe sun's heat...\"", french="Le ciel s'embrasera alors de la\nchaleur du soleil...", german="[F:S2]Dann wird die Hitze der Sonne\nden Himmel entflammen...[F:E2]", italian="\"... poi il calore del sole\ninfiammerà il cielo...\"", spanish="\"Y el cielo se encenderá con el\ncalor del sol.\""})
  else
  SkySceneKit.say({english="\"Then the sky shall blaze with\nthe sun's heat...\"", french="Le ciel s'embrasera alors de la\nchaleur du soleil...", german="[F:S2]Dann wird die Hitze der Sonne\nden Himmel entflammen...[F:E2]", italian="\"... poi il calore del sole\ninfiammerà il cielo...\"", spanish="\"Y el cielo se encenderá con el\ncalor del sol.\""})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"", french="Le chemin qui mène au trésor\nsera révélé.\"", german="[F:S2]Und der Pfad zum Schatz wird\nenthüllt.[F:E2]", italian="\"... e il sentiero che conduce\nal tesoro sarà svelato.\"", spanish="\"Así se mostrará el camino al\ntesoro.\""})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"", french="Le chemin qui mène au trésor\nsera révélé.\"", german="[F:S2]Und der Pfad zum Schatz wird\nenthüllt.[F:E2]", italian="\"... e il sentiero che conduce\nal tesoro sarà svelato.\"", spanish="\"Así se mostrará el camino al\ntesoro.\""})
  else
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"", french="Le chemin qui mène au trésor\nsera révélé.\"", german="[F:S2]Und der Pfad zum Schatz wird\nenthüllt.[F:E2]", italian="\"... e il sentiero che conduce\nal tesoro sarà svelato.\"", spanish="\"Así se mostrará el camino al\ntesoro.\""})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"The path to treasure\"? That's\nincredible!", french="\"Le chemin qui mène au trésor\"?\nC'est incroyable!", german="[F:S2]Der Pfad zum Schatz[F:E2]? Das ist\nja unglaublich!", italian="\"Il sentiero che conduce al\ntesoro\"? È incredibile!", spanish="¿El camino al tesoro?\n¡Es increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"The path to treasure\"? That's\nincredible!", french="\"Le chemin qui mène au trésor\"?\nC'est incroyable!", german="[F:S2]Der Pfad zum Schatz[F:E2]? Das ist\nja unglaublich!", italian="\"Il sentiero che conduce al\ntesoro\"? È incredibile!", spanish="¿El camino al tesoro?\n¡Es increíble!"})
  else
  SkySceneKit.say({english="\"The path to treasure\"? That's\nincredible!", french="\"Le chemin qui mène au trésor\"?\nC'est incroyable!", german="[F:S2]Der Pfad zum Schatz[F:E2]? Das ist\nja unglaublich!", italian="\"Il sentiero che conduce al\ntesoro\"? È incredibile!", spanish="¿El camino al tesoro?\n¡Es increíble!"})
  end
  -- message_Close
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡Vaya, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Treasure?! Could this mean the\ntreasure of [CS:P]Fogbound Lake[CR]?!", french="Un trésor?! C'est le fameux\ntrésor du [CS:P]Lac des Brumes[CR]?!", german="Schatz?!? Ist damit vielleicht\nder Schatz vom [CS:P]Nebelsee[CR] gemeint?!?", italian="Tesoro?! Potrebbe essere il\ntesoro del [CS:P]Lago Foschia[CR]?!", spanish="¡Un tesoro! ¡¿Se referirá al\ntesoro del [CS:P]Lago Velado[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Treasure?! Could this mean the\ntreasure of [CS:P]Fogbound Lake[CR]?!", french="Un trésor?! C'est le fameux\ntrésor du [CS:P]Lac des Brumes[CR]?!", german="Schatz?!? Ist damit vielleicht\nder Schatz vom [CS:P]Nebelsee[CR] gemeint?!?", italian="Tesoro?! Potrebbe essere il\ntesoro del [CS:P]Lago Foschia[CR]?!", spanish="¡Un tesoro! ¡¿Se referirá al\ntesoro del [CS:P]Lago Velado[CR]?!"})
  else
  SkySceneKit.say({english="Treasure?! Could this mean the\ntreasure of [CS:P]Fogbound Lake[CR]?!", french="Un trésor?! C'est le fameux\ntrésor du [CS:P]Lac des Brumes[CR]?!", german="Schatz?!? Ist damit vielleicht\nder Schatz vom [CS:P]Nebelsee[CR] gemeint?!?", italian="Tesoro?! Potrebbe essere il\ntesoro del [CS:P]Lago Foschia[CR]?!", spanish="¡Un tesoro! ¡¿Se referirá al\ntesoro del [CS:P]Lago Velado[CR]?!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"[K] So this means...", french="\"Le chemin qui mène au trésor\nsera révélé.\"[K] Cela signifie...", german="[F:S2]Der Pfad zum Schatz wird\nenthüllt.[F:E2][K] Das heißt also...", italian="\"Il sentiero che conduce al\ntesoro sarà svelato.\"[K] Allora...", spanish="\"Así se mostrará el camino al\ntesoro.\"[K] Eso significa que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"[K] So this means...", french="\"Le chemin qui mène au trésor\nsera révélé.\"[K] Cela signifie...", german="[F:S2]Der Pfad zum Schatz wird\nenthüllt.[F:E2][K] Das heißt also...", italian="\"Il sentiero che conduce al\ntesoro sarà svelato.\"[K] Allora...", spanish="\"Así se mostrará el camino al\ntesoro.\"[K] Eso significa que..."})
  else
  SkySceneKit.say({english="\"The path to treasure shall be\nrevealed.\"[K] So this means...", french="\"Le chemin qui mène au trésor\nsera révélé.\"[K] Cela signifie...", german="[F:S2]Der Pfad zum Schatz wird\nenthüllt.[F:E2][K] Das heißt also...", italian="\"Il sentiero che conduce al\ntesoro sarà svelato.\"[K] Allora...", spanish="\"Así se mostrará el camino al\ntesoro.\"[K] Eso significa que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The secret to finding [CS:P]Fogbound\nLake[CR] could be hidden right here!", french="... que le secret pour trouver\nle [CS:P]Lac des Brumes[CR] serait caché ici?", german="Der Schlüssel zum [CS:P]Nebelsee[CR]\nliegt vielleicht genau hier versteckt!", italian="Significa che il segreto per\ntrovare il [CS:P]Lago Foschia[CR] potrebbe essere\nnascosto proprio qui!", spanish="¡La clave para encontrar el\n[CS:P]Lago Velado[CR] podría estar aquí mismo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The secret to finding [CS:P]Fogbound\nLake[CR] could be hidden right here!", french="... que le secret pour trouver\nle [CS:P]Lac des Brumes[CR] serait caché ici?", german="Der Schlüssel zum [CS:P]Nebelsee[CR]\nliegt vielleicht genau hier versteckt!", italian="Significa che il segreto per\ntrovare il [CS:P]Lago Foschia[CR] potrebbe essere\nnascosto proprio qui!", spanish="¡La clave para encontrar el\n[CS:P]Lago Velado[CR] podría estar aquí mismo!"})
  else
  SkySceneKit.say({english="The secret to finding [CS:P]Fogbound\nLake[CR] could be hidden right here!", french="... que le secret pour trouver\nle [CS:P]Lac des Brumes[CR] serait caché ici?", german="Der Schlüssel zum [CS:P]Nebelsee[CR]\nliegt vielleicht genau hier versteckt!", italian="Significa che il segreto per\ntrovare il [CS:P]Lago Foschia[CR] potrebbe essere\nnascosto proprio qui!", spanish="¡La clave para encontrar el\n[CS:P]Lago Velado[CR] podría estar aquí mismo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey! Y-you think so?", french=" Ah bon? Tu crois?", german=" Hey, hey, hey! G-glaubst du?", italian="Ehi, ehi, ehi! Credi davvero\nche sia così?", spanish=" ¡Oye, oye! ¿Eso crees?"})
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! Now that's a mystery\nwe've got to solve!", french="Eh dis donc! C'est un mystère\nqu'on doit élucider!", german="Hey, hey! Wir sollten dieses\nRätsel lösen!", italian="Ehi, ehi! Questo è un mistero che\ndobbiamo risolvere!", spanish="¡Oye! ¡Tenemos que resolver\nese misterio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This part of the footprint\nrunes...", french="Cette partie des\nrunes-empreintes...", german="Dieser Teil der\nFußabdruckrunen...", italian=" Questa parte dei Pokéroglifici...", spanish="Esta parte de las inscripciones\nrúnicas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This part of the footprint\nrunes...", french="Cette partie des\nrunes-empreintes...", german="Dieser Teil der\nFußabdruckrunen...", italian=" Questa parte dei Pokéroglifici...", spanish="Esta parte de las inscripciones\nrúnicas..."})
  else
  SkySceneKit.say({english="This part of the footprint\nrunes...", french="Cette partie des\nrunes-empreintes...", german="Dieser Teil der\nFußabdruckrunen...", italian=" Questa parte dei Pokéroglifici...", spanish="Esta parte de las inscripciones\nrúnicas..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This part about \"life that burned\nwithin Groudon.\" What's this about?", french="... \"la vie qui brûlait jadis en\nGroudon\"... Qu'est-ce que ça veut dire?", german="[F:S2]Das in Groudon erloschene\nLeben...[F:E2] Was heißt das?", italian="\"La vita che pulsava dentro\nGroudon.\" A cosa si riferirà?", spanish="Donde habla de la \"vida que ardía\ndentro de Groudon.\" ¿A qué se referirá?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This part about \"life that burned\nwithin Groudon.\" What's this about?", french="... \"la vie qui brûlait jadis en\nGroudon\"... Qu'est-ce que ça veut dire?", german="[F:S2]Das in Groudon erloschene\nLeben...[F:E2] Was heißt das?", italian="\"La vita che pulsava dentro\nGroudon.\" A cosa si riferirà?", spanish="Donde habla de la \"vida que ardía\ndentro de Groudon.\" ¿A qué se referirá?"})
  else
  SkySceneKit.say({english="This part about \"life that burned\nwithin Groudon.\" What's this about?", french="... \"la vie qui brûlait jadis en\nGroudon\"... Qu'est-ce que ça veut dire?", german="[F:S2]Das in Groudon erloschene\nLeben...[F:E2] Was heißt das?", italian="\"La vita che pulsava dentro\nGroudon.\" A cosa si riferirà?", spanish="Donde habla de la \"vida que ardía\ndentro de Groudon.\" ¿A qué se referirá?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So this \"Groudon,\" is it\nthis statue?", french="Ce \"Groudon\", ce serait cette\nstatue?", german=" Groudon ist also diese Statue?", italian="Questo \"Groudon\" sarà il\nPokémon raffigurato dalla statua?", spanish="Ese \"Groudon\"... ¿será esta\nestatua?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So this \"Groudon,\" is it\nthis statue?", french="Ce \"Groudon\", ce serait cette\nstatue?", german=" Groudon ist also diese Statue?", italian="Questo \"Groudon\" sarà il\nPokémon raffigurato dalla statua?", spanish="Ese \"Groudon\"... ¿será esta\nestatua?"})
  else
  SkySceneKit.say({english="So this \"Groudon,\" is it\nthis statue?", french="Ce \"Groudon\", ce serait cette\nstatue?", german=" Groudon ist also diese Statue?", italian="Questo \"Groudon\" sarà il\nPokémon raffigurato dalla statua?", spanish="Ese \"Groudon\"... ¿será esta\nestatua?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 4) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So we're supposed\nto what, ignite the life that was in\nthis statue?", french="Qu'est-ce que nous sommes\ncensés faire, dis donc? Ranimer la flamme\nde la vie dans cette statue?", german="Hey, hey! Was sollen wir jetzt\ntun? Das Leben wiederentfachen, das in dieser\nStatue war?", italian="Ehi, ehi! Quindi dobbiamo\nriaccendere la vita che pulsava in questa\nstatua?", spanish="¡Oye, oye! ¿Entonces tendríamos\nque encender el fuego de la vida que había\nen esta estatua?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  GROUND:EntTurn(hero, Direction.DownLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, but ignite the life? How do\nwe do that?", french=" Oui, mais comment on fait ça?", german="Ja, aber das Leben entfachen...\nWie machen wir das?", italian="Sì, ma come si farà a\nriaccendere la vita?", spanish="¿Y cómo se le prende fuego\na la vida? ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yeah, but ignite the life? How do\nwe do that?", french=" Oui, mais comment on fait ça?", german="Ja, aber das Leben entfachen...\nWie machen wir das?", italian="Sì, ma come si farà a\nriaccendere la vita?", spanish="¿Y cómo se le prende fuego\na la vida? ¿Eh?"})
  else
  SkySceneKit.say({english="Yeah, but ignite the life? How do\nwe do that?", french=" Oui, mais comment on fait ça?", german="Ja, aber das Leben entfachen...\nWie machen wir das?", italian="Sì, ma come si farà a\nriaccendere la vita?", spanish="¿Y cómo se le prende fuego\na la vida? ¿Eh?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmm...", french=" Hmm...", german=" Hmm...", italian=" Mmm...", spanish=" Hum..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Wait a second!", french=" Ah![K] Mais oui!", german=" Oh![K] Moment mal!", italian=" Eh?[K] Aspetta un secondo!", spanish=" Espera.[K] ¡Un momento!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh?[K] Wait a second!", french=" Ah![K] Mais oui!", german=" Oh![K] Moment mal!", italian=" Eh?[K] Aspetta un secondo!", spanish=" Espera.[K] ¡Un momento!"})
  else
  SkySceneKit.say({english=" Huh?[K] Wait!", french=" Ah![K] Mais oui!", german=" Oh![K] Wartet mal!", italian=" Eh?[K] Aspetta un secondo!", spanish=" ¿Eh?[K] ¡Esperad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I know![K] Touch this statue,\n[hero]!", french="Je sais![K] Touche cette statue,\n[hero]!", german="Ich weiß es![K] Berühre die\nStatue, [hero]!", italian="Ho capito![K] Tocca la statua,\n[hero]!", spanish="¡Ya sé![K] ¡[hero], toca la\nestatua!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I know![K] Touch this statue,\n[hero]!", french="Je sais![K] Touche cette statue,\n[hero]!", german="Ich weiß es![K] Berühre die\nStatue, [hero]!", italian="Ho capito![K] Tocca la statua,\n[hero]!", spanish="¡Ya sé![K] ¡[hero], toca la\nestatua!"})
  else
  SkySceneKit.say({english="I know![K] Touch this statue,\n[hero]!", french="Je sais![K] Touche cette statue,\n[hero]!", german="Ich weiß es![K] Berühre die\nStatue, [hero]!", italian="Ho capito![K] Tocca la statua,\n[hero]!", spanish="¡Ya sé![K] ¡[hero], toca la\nestatua!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Maybe you'll see something,\n[hero]!", french=" Tu auras peut-être une vision!", german="Vielleicht siehst du etwas,\n[hero]!", italian="Forse vedrai qualcosa,\n[hero]!", spanish="¡Tal vez veas algo,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe you'll see something,\n[hero]!", french=" Tu auras peut-être une vision!", german="Vielleicht siehst du etwas,\n[hero]!", italian="Forse vedrai qualcosa,\n[hero]!", spanish="¡Tal vez veas algo,\n[hero]!"})
  else
  SkySceneKit.say({english="Maybe you'll see something,\n[hero]!", french=" Tu auras peut-être une vision!", german="Vielleicht siehst du etwas,\n[hero]!", italian="Forse vedrai qualcosa,\n[hero]!", spanish="¡Tal vez veas algo,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I was thinking that too.)", french="(Je pensais à la même chose.)", german="(Das dachte ich auch gerade.)", italian="(Stavo pensando la stessa cosa.)", spanish="(Era lo que estaba pensando.)"})
  else
  SkySceneKit.say({english="(I was thinking that too.)", french="(Je pensais à la même chose.)", german="(Das dachte ich auch gerade.)", italian="(Stavo pensando la stessa cosa.)", spanish="(Era lo que estaba pensando.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If it means finding the path to [CS:P]Fogbound\nLake[CR]...)", french="(Si cela nous permet de trouver le chemin qui\nmène au [CS:P]Lac des Brumes[CR]...)", german="(Wenn ich so den Weg zum [CS:P]Nebelsee[CR] finde...)", italian="(Per trovare il sentiero che conduce al\n[CS:P]Lago Foschia[CR]...)", spanish="(Puede que así logremos encontrar el camino\nal [CS:P]Lago Velado[CR]...)"})
  else
  SkySceneKit.say({english="(If it means finding the path to [CS:P]Fogbound\nLake[CR]...)", french="(Si cela nous permet de trouver le chemin qui\nmène au [CS:P]Lac des Brumes[CR]...)", german="(Wenn ich so den Weg zum [CS:P]Nebelsee[CR] finde...)", italian="(Per trovare il sentiero che conduce al\n[CS:P]Lago Foschia[CR]...)", spanish="(Puede que así logremos encontrar el camino\nal [CS:P]Lago Velado[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If it means finding the key to my own past...)", french="(Si cela nous permet de découvrir la clé de\nmon passé...)", german="(Wenn ich so den Schlüssel zu meiner\neigenen Vergangenheit finde...)", italian="(Per trovare la chiave del mio\npassato...)", spanish="(Y la clave de mi pasado...)"})
  else
  SkySceneKit.say({english="(If it means finding the key to my own past...)", french="(Si cela nous permet de découvrir la clé de\nmon passé...)", german="(Wenn ich so den Schlüssel zu meiner\neigenen Vergangenheit finde...)", italian="(Per trovare la chiave del mio\npassato...)", spanish="(Y la clave de mi pasado...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If the answers are held by this statue...)", french="(Si cette statue détient les réponses...)", german="(Wenn die Antworten in dieser Statue liegen...)", italian="(Se le risposte sono custodite da\nquesta statua...)", spanish="(Tal vez las respuestas están en esta estatua.)"})
  else
  SkySceneKit.say({english="(If the answers are held by this statue...)", french="(Si cette statue détient les réponses...)", german="(Wenn die Antworten in dieser Statue liegen...)", italian="(Se le risposte sono custodite da\nquesta statua...)", spanish="(Tal vez las respuestas están en esta estatua.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You're going to do it!", french=" Vas-y!", german=" Tu es!", italian=" Lo farai!", spanish=" ¡Venga, hazlo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You're going to do it!", french=" Vas-y!", german=" Tu es!", italian=" Lo farai!", spanish=" ¡Venga, toca la estatua!"})
  else
  SkySceneKit.say({english=" You'll do it for us!", french=" Vas-y!", german=" Tu es für uns!", italian=" Lo farai!", spanish=" ¡Hazlo por nosotros!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 440, 420, false, 2)
  GROUND:EntTurn(partner, Direction.DownLeft)
  GROUND:MoveToPosition(hero, 416, 440, false, 2)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][hero] touched the\n[CN]statue of Groudon.", french="[CN][hero] touche la\n[CN]statue de Groudon.", german="[CN][hero] berührt\n[CN]die Statue von Groudon.", italian="[CN][hero] tocca la\n[CN]statua di Groudon.", spanish="[CN][hero] tocó\n[CN]la estatua de Groudon."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Getting anything, [hero]?", french=" Alors, [hero]?", german=" Merkst du etwas, [hero]?", italian="Stai vedendo qualcosa,\n[hero]?", spanish=" ¿Notas algo, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Feeling anything, [hero]?", french=" Alors, [hero]?", german=" Spürst du etwas, [hero]?", italian="Stai vedendo qualcosa,\n[hero]?", spanish=" ¿Sientes algo, [hero]?"})
  else
  SkySceneKit.say({english=" Sensing anything, [hero]?", french=" Alors, [hero]?", german=" Fühlst du etwas, [hero]?", italian="Stai vedendo qualcosa,\n[hero]?", spanish=" ¿Sientes algo, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(30) end)
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(It's coming...)", french="(Ça vient...)", german="(Es kommt...)", italian="(Sta per iniziare...)", spanish="(Ahí viene.)"})
  else
  SkySceneKit.say({english="(It's coming...)", french="(Ça vient...)", german="(Es kommt...)", italian="(Sta per iniziare...)", spanish="(Ahí viene.)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeOut(false, 64) -- screen_FlushOut
  GAME:FadeIn(64) -- screen_FlushIn
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That dizzy feeling...)", french="(Cette sensation de vertige...)", german="(Dieses Schwindelgefühl...)", italian="(Quel capogiro...)", spanish="(Esa sensación de mareo.)"})
  else
  SkySceneKit.say({english="(That dizzy feeling...)", french="(Cette sensation de vertige...)", german="(Dieses Schwindelgefühl...)", italian="(Quel capogiro...)", spanish="(Esa sensación de mareo.)"})
  end
  -- message_Close
  GAME:FadeOut(false,  5)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
