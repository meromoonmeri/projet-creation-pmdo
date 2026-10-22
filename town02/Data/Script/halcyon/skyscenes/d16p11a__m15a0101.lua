-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P11A/m15a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(16, 1) -- $SCENARIO_MAIN = scn[16,1] (ROM)
  -- back_SetGround(LEVEL_D16P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Crystal Cave.ogg", true) end)
  GROUND:MoveToPosition(hero, 316, 140, false, 2)
  GROUND:MoveToPosition(partner, 284, 140, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So this is [CS:P]Crystal Cave[CR]!", french=" Voici donc la [CS:P]Caverne Cristal[CR]!", german=" Das ist also die [CS:P]Kristallhöhle[CR]!", italian="E così è questa la [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR], eh?", spanish=" Así que esta es la [CS:P]Cueva Cristal[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So this is [CS:P]Crystal Cave[CR]!", french=" Voici donc la [CS:P]Caverne Cristal[CR]!", german=" Das ist also die [CS:P]Kristallhöhle[CR]!", italian="E così, questa è la [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR]!", spanish=" Así que esta es la [CS:P]Cueva Cristal[CR]."})
  else
  SkySceneKit.say({english=" So this is [CS:P]Crystal Cave[CR]!", french=" Voici donc la [CS:P]Caverne Cristal[CR]!", german=" Das ist also die [CS:P]Kristallhöhle[CR]!", italian="E così, questa è la [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR]!", spanish=" Así que esta es la [CS:P]Cueva Cristal[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(10)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Somewhere in this cave...", french="Quelque part dans cette\ncaverne...", german=" Irgendwo in dieser Höhle...", italian=" Da qualche parte, qui...", spanish=" En alguna parte de esta cueva..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Somewhere inside this cave...", french="Quelque part dans cette\ncaverne...", german=" Irgendwo in dieser Höhle...", italian=" Da qualche parte, qui...", spanish=" En alguna parte de esta cueva..."})
  else
  SkySceneKit.say({english=" Somewhere inside this cave...", french="Quelque part dans cette\ncaverne...", german=" Irgendwo in dieser Höhle...", italian=" Da qualche parte, qui...", spanish=" En alguna parte de esta cueva..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There should be a passageway\nthat will take us to [CS:N]Azelf[CR]'s lake.", french="On devrait trouver un passage\nqui nous mènera directement au lac\nde [CS:N]Créfadet[CR].", german="Irgendwo müsste es einen\nDurchgang geben, der uns zum See von [CS:N]Tobutz[CR]\nführt.", italian="... potrebbe esserci un passaggio\nche ci porterà da questo [CS:N]Azelf[CR].", spanish="Tiene que haber algún pasaje\nque nos lleve al lago de [CS:N]Azelf[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There should be a passageway\nthat leads to [CS:N]Azelf[CR]'s lake.", french="On devrait trouver un passage\nqui nous mènera directement au lac\nde [CS:N]Créfadet[CR].", german="Irgendwo müsste es einen\nDurchgang geben, der uns zum See von [CS:N]Tobutz[CR]\nführt.", italian="... potrebbe esserci un passaggio\nche conduce al lago di [CS:N]Azelf[CR].", spanish="Tiene que haber algún pasaje\nque nos lleve al lago de [CS:N]Azelf[CR]."})
  else
  SkySceneKit.say({english="There should be a passageway\nthat goes to [CS:N]Azelf[CR]'s lake.", french="On devrait trouver un passage\nqui nous mènera directement au lac\nde [CS:N]Créfadet[CR].", german="Irgendwo müsste es einen\nDurchgang geben, der uns zum See von [CS:N]Tobutz[CR]\nführt.", italian="... potrebbe esserci un passaggio\nche conduce al lago di [CS:N]Azelf[CR].", spanish="Tiene que haber algún pasaje\nque nos lleve al lago de [CS:N]Azelf[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it will take us forever if we\nsearch every step of the way!", french="Mais ça va prendre des lustres\nsi on doit chercher partout!", german="Aber wenn wir jeden Winkel\ndurchsuchen, wird es ewig dauern!", italian="Ma ci vorrà una vita se ci\nmettiamo a cercare dappertutto!", spanish="Pero nos llevará siglos si nos\nparamos a buscar en cada etapa del recorrido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it will take us forever if we\nsearch every step of the way!", french="Mais ça va prendre des lustres\nsi on doit chercher partout!", german="Aber wenn wir jeden Winkel\ndurchsuchen, wird es ewig dauern!", italian="Ma se cerchiamo dappertutto, ci\nvorrà un'infinità di tempo!", spanish="Pero nos llevará siglos si nos\nparamos a buscar en cada etapa del recorrido."})
  else
  SkySceneKit.say({english="But it will take us forever if we\nsearch every step of the way!", french="Mais ça va prendre des lustres\nsi on doit chercher partout!", german="Aber wenn wir jeden Winkel\ndurchsuchen, wird es ewig dauern!", italian="Ma se cerchiamo dappertutto, ci\nvorrà un'infinità di tempo!", spanish="Pero nos llevará siglos si nos\nparamos a buscar en cada etapa del recorrido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="For starters, let's go as deep as\nwe can.", french="Pour commencer, descendons\naussi profond que possible.", german="Gehen wir als Erstes einfach so\nweit wie möglich hinein.", italian="Beh, per cominciare, vediamo\nfino a dove riusciamo ad arrivare!", spanish="Para empezar, vayamos tan lejos\ncomo podamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="For starters, let's go as deep as\nwe can.", french="Pour commencer, descendons\naussi profond que possible.", german="Gehen wir als Erstes einfach so\nweit wie möglich hinein.", italian="Per cominciare, direi di\ninoltrarci il più possibile!", spanish="Para empezar, vayamos tan lejos\ncomo podamos."})
  else
  SkySceneKit.say({english="For starters, let's go as deep as\nwe can.", french="Pour commencer, descendons\naussi profond que possible.", german="Gehen wir als Erstes einfach so\nweit wie möglich hinein.", italian="Per cominciare, direi di\ninoltrarci il più possibile!", spanish="Para empezar, vayamos tan lejos\ncomo podamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's give it our best,\n[hero]!", french="Faisons de notre mieux,\n[hero]!", german="Geben wir unser Bestes,\n[hero]!", italian=" Diamoci dentro, [hero]!", spanish=" ¡Venga, vamos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's do our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Lass uns unser Bestes geben,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish=" ¡Venga, vamos, [hero]!"})
  else
  SkySceneKit.say({english=" Let's try our best, [hero]!", french="Faisons de notre mieux,\n[hero]!", german="Strengen wir uns an,\n[hero]!", italian="Facciamo del nostro meglio,\n[hero]!", spanish=" ¡Venga, vamos, [hero]!"})
  end
  -- message_Close
  GROUND:MoveToPosition(partner, 284, 76, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(hero, 316, 76, false, 2)
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  -- main_EnterDungeon(24, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 0) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
end
