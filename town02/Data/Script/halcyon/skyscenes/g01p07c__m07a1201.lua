-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m07a1201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sigh... [CS:N]Skuntank[CR] and his\nsidekicks really stuck it to us again...", french="Pff... [CS:N]Moufflair[CR] et ses acolytes\nse sont bien amusés... et encore une fois\nà nos dépens...", german="Seufz... [CS:N]Skuntank[CR] und seine\nAnhängsel haben uns wieder schlecht aussehen\nlassen.", italian="Sigh... [CS:N]Skuntank[CR] e i suoi\nscagnozzi ce l'hanno fatta di nuovo.", spanish="Vaya... [CS:N]Skuntank[CR] y sus\ncompinches nos la han vuelto a jugar..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sigh... [CS:N]Skuntank[CR]'s team showed\nus up over and over again...", french="Pff... [CS:N]Moufflair[CR] et ses acolytes\nse sont bien amusés... et encore une fois\nà nos dépens...", german="Seufz... [CS:N]Skuntank[CR] und sein Team\nhaben uns mal wieder reingelegt.", italian="Sigh... [CS:N]Skuntank[CR] e i suoi\nscagnozzi ce l'hanno fatta di nuovo.", spanish="Vaya... El equipo de [CS:N]Skuntank[CR]\nnos la ha vuelto a jugar..."})
  else
  SkySceneKit.say({english="Sigh... [CS:N]Skuntank[CR]'s team bested us\nagain, didn't they...", french="Pff... [CS:N]Moufflair[CR] et ses acolytes\nse sont bien amusés... et encore une fois\nà nos dépens...", german="Seufz... [CS:N]Skuntank[CR] und sein Team\nhaben uns mal wieder übers Ohr gehauen.", italian="Sigh... [CS:N]Skuntank[CR] e i suoi\nscagnozzi ce l'hanno fatta di nuovo.", spanish="Vaya... El equipo de [CS:N]Skuntank[CR]\nnos la ha vuelto a jugar..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're lucky that [CS:N]Wigglytuff[CR]\ndidn't blow up at us.", french="Quelle chance que [CS:N]Grodoudou[CR]\nn'ait pas explosé devant nous.", german="Zum Glück hat [CS:N]Knuddeluff[CR] uns\nnicht die Leviten gelesen.", italian="Meno male che [CS:N]Wigglytuff[CR]\nnon ci è scoppiato addosso.", spanish="Ha sido una suerte que\n[CS:N]Wigglytuff[CR] no acabase estallando."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's great that [CS:N]Wigglytuff[CR] didn't\nblow up at us.", french="Quelle chance que [CS:N]Grodoudou[CR]\nn'ait pas explosé devant nous.", german="Zum Glück hat [CS:N]Knuddeluff[CR] uns\nnicht die Leviten gelesen.", italian="Meno male che [CS:N]Wigglytuff[CR]\nnon se l'è presa con noi.", spanish="Ha sido una suerte que\n[CS:N]Wigglytuff[CR] no acabase estallando."})
  else
  SkySceneKit.say({english="It's good that [CS:N]Wigglytuff[CR] didn't\nblow up at us.", french="Quelle chance que [CS:N]Grodoudou[CR]\nn'ait pas explosé devant nous.", german="Zum Glück hat [CS:N]Knuddeluff[CR] uns\nnicht die Leviten gelesen.", italian="Meno male che [CS:N]Wigglytuff[CR]\nnon se l'è presa con noi.", spanish="Ha sido una suerte que\n[CS:N]Wigglytuff[CR] no acabase estallando."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Urf... But we didn't get to eat\ndinner after all...", french="Arf... Mais on n'a même pas\neu le droit de dîner ce soir...", german="Urf... Aber wir haben trotzdem\nkein Abendessen bekommen...", italian="Urf... Ma in ogni caso abbiamo\nsaltato la cena...", spanish="Uf... Pero, al final, no hemos\ncenado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Urf... But we didn't get to eat\ndinner after all...", french="Arf... Mais on n'a même pas\neu le droit de dîner ce soir...", german="Urf... Aber wir haben trotzdem\nkein Abendessen bekommen...", italian="Urf... Ma in ogni caso abbiamo\nsaltato la cena...", spanish="Uf... Pero, al final, no hemos\ncenado."})
  else
  SkySceneKit.say({english="Urf... But we didn't get to eat\ndinner after all...", french="Arf... Mais on n'a même pas\neu le droit de dîner ce soir...", german="Urf... Aber wir haben trotzdem\nkein Abendessen bekommen...", italian="Urf... Ma in ogni caso abbiamo\nsaltato la cena...", spanish="Uf... Pero, al final, no hemos\ncenado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm just starving now...", french=" Je meurs de faim...", german=" Ich bin am Verhungern.", italian=" Adesso ho proprio fame...", spanish=" Me estoy muriendo de hambre..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I feel horribly hungry...", french=" Je meurs de faim...", german=" Ich habe fürchterlichen Hunger.", italian=" Adesso sono proprio affamato...", spanish=" Estoy hambriento..."})
  else
  SkySceneKit.say({english=" I'm famished...", french=" Je meurs de faim...", german=" Ich verhungere...", italian=" Adesso sono proprio affamata...", spanish=" Estoy muerta de hambre..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Sorry, I know you're hungry too,\n[hero].", french="Pardon, je sais que toi aussi tu\nas faim, [hero].", german="Tut mir leid, ich weiß, du hast\nauch Hunger, [hero].", italian="Scusa, so che anche tu hai fame,\n[hero].", spanish="Perdona... Ya sé que tú también\ntienes hambre, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Sorry, I know you're hungry too,\n[hero].", french="Pardon, je sais que toi aussi tu\nas faim, [hero].", german="Tut mir leid, ich weiß, du hast\nauch Hunger, [hero].", italian="Scusa, so che anche tu hai fame,\n[hero].", spanish="Perdona... Ya sé que tú también\ntienes hambre, [hero]."})
  else
  SkySceneKit.say({english="Sorry, I know you're hungry too,\n[hero].", french="Pardon, je sais que toi aussi tu\nas faim, [hero].", german="Tut mir leid, ich weiß, du hast\nauch Hunger, [hero].", italian="Scusa, so che anche tu hai fame,\n[hero].", spanish="Perdona... Ya sé que tú también\ntienes hambre, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Staying up doesn't make it\nbetter. Let's get some sleep.", french="Rester debout ne va pas\narranger les choses. Allons nous coucher.", german="Es wird nicht besser, wenn wir\nwach bleiben. Lass uns schlafen.", italian="Stare in piedi non migliorerà le\ncose. Andiamo a dormire.", spanish="Quedarnos despiertos no va\na solucionar nada. Durmamos un poco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Staying awake like this doesn't\nmake it better. Let's get some sleep.", french="Rester debout ne va pas\narranger les choses. Allons nous coucher.", german="Wenn wir wach bleiben, wird es\nauch nicht besser. Lass uns schlafen.", italian="Stare in piedi non migliorerà le\ncose. Andiamo a dormire.", spanish="Quedarnos despiertos no va\na solucionar nada. Durmamos un poco."})
  else
  SkySceneKit.say({english="Staying awake doesn't help.\nLet's get some sleep.", french="Rester debout ne va pas\narranger les choses. Allons nous coucher.", german="Es bringt auch nichts, wenn wir\nwach bleiben. Lass uns schlafen.", italian="Stare in piedi non migliorerà le\ncose. Andiamo a dormire.", spanish="Quedarnos sin dormir no va\na solucionar nada. Descansemos mejor."})
  end
  -- message_Close
  GAME:WaitFrames(45)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  else
  SkySceneKit.say({english=" Good night, [hero].", french=" Bonne nuit, [hero].", german=" Gute Nacht, [hero].", italian=" Buonanotte, [hero].", spanish=" Buenas noches, [hero]."})
  end
  -- message_Close
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(50)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's keep at it tomorrow.", french=" Nous ferons mieux demain.", german=" Morgen geht es weiter.", italian="Continuiamo a fare del nostro\nmeglio, domani.", spanish=" Mañana más."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's keep at it tomorrow.", french=" Nous ferons mieux demain.", german=" Morgen geht es weiter.", italian="Continuiamo a fare del nostro\nmeglio, domani.", spanish=" Mañana más."})
  else
  SkySceneKit.say({english=" Let's keep at it tomorrow.", french=" Nous ferons mieux demain.", german=" Morgen geht es weiter.", italian="Continuiamo a fare del nostro\nmeglio, domani.", spanish=" Mañana más."})
  end
  -- message_Close
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(120)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
end
