-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D48P11A/n08a1608.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Argh...[K] We didn't do so well...", french=" Argh...[K] Un échec retentissant...", german="Argh...[K]\nDas war wohl nicht gut genug...", italian=" Argh...[K] Ci è andata male...", spanish=" Ay...[K] No nos ha ido muy bien..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We should turn back for now.", french="Nous devrions faire demi-tour\npour l'instant.", german="Wir sollten wohl noch\neinmal von vorne anfangen.", italian=" Meglio tornare sui nostri passi.", spanish="Deberíamos dar la vuelta\npor ahora."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D48P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 320, 288, Direction.Up, "NPC_YONOWAARU_N8")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Temporal Tower.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="... (I'm concerned about a great\nmany things.)", french=" ... (Tant de doutes m'assaillent.)", german="...(So langsam mache ich mir\ndoch einige Gedanken.)", italian="... (Ci sono molte cose che\nmi preoccupano.)", spanish="Uf... (Me preocupan muchísimas\ncosas.)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(The new, resourceful henchman\nwho took over for [CS:N]Dusknoir[CR]...)", french="(Le nouveau bras droit aux\nmultiples talents qui a remplacé [CS:N]Noctunoir[CR]...)", german="(Dieser neue, einfallsreiche\nGehilfe, der [CS:N]Zwirrfinst[CR] ersetzt hat...)", italian="(Il nuovo e potente servitore\nche ha preso il posto di [CS:N]Dusknoir[CR]...)", spanish="(El misterioso y competente\nsustituto de [CS:N]Dusknoir[CR]...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(And using him as a\nfinal agent...)", french=" (Le dernier agent...)", german=" (Jener letzte Zeitreisende...)", italian=" (... e la sua missione...)", spanish="(Y el hecho de que planeen\nutilizarlo como último recurso...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(I know they're planning on\nsending him back to the past...)", french="(Je sais bien qu'ils vont\nl'envoyer dans le passé...)", german="(Ganz sicher haben sie vor,\nihn in die Vergangenheit zu schicken...)", italian="(So che hanno intenzione\ndi rispedirlo nel passato...)", spanish=" (Y enviarlo al pasado...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(In any case, I have to\nkeep going...)", french="(Quoi qu'il arrive, je dois\ncontinuer...)", german="(Ich muss mich\nauf jeden Fall sputen...)", italian="(In ogni caso, devo continuare\nad andare avanti...)", spanish="(En cualquier caso, yo tengo\nque seguir avanzando...)"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="(To the place where [CS:N]Dialga[CR] is...[K]\nthe pinnacle of [CS:P]Temporal Tower[CR]!)", french="(... jusqu'au repaire de [CS:N]Dialga[CR]...[K]\nLe pinacle de la [CS:P]Tour du Temps[CR]!)", german="(Mein Ziel ist der Aufenthaltsort\nvon [CS:N]Dialga[CR],[K] die Spitze des [CS:P]Zeitturms[CR]!)", italian="(... e raggiungere il luogo dove\nsi trova [CS:N]Dialga[CR]...[K] La vetta della [CS:P]Torre[CR]\n[CS:P]del Tempo[CR]!)", spanish="(Seguir hacia el lugar donde está\n[CS:N]Dialga[CR]...[K] ¡La cima de la [CS:P]Torre del Tiempo[CR]!)"})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
