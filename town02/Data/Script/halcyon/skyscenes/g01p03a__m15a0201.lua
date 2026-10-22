-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m15a0201.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Ugh, we didn't do so good,\ndid we?", french="Argh, ce n'était pas brillant,\nn'est-ce pas?", german=" Uff, das war wohl nichts, was?", italian="Ugh, non è andata troppo bene,\neh?", spanish="¡Ay! No hemos estado muy\nbrillantes, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Ugh, we didn't do so well,\ndid we?", french="Argh, ce n'était pas brillant,\nn'est-ce pas?", german=" Uff, das war wohl nichts, was?", italian=" Ohi ohi, che fiasco!", spanish="¡Ay! Esto no ha ido demasiado\nbien."})
  else
  SkySceneKit.say({english="Ugh, we didn't do so well,\ndid we?", french="Argh, ce n'était pas brillant,\nn'est-ce pas?", german=" Uff, das war wohl nichts, was?", italian=" Ohi ohi, che buco nell'acqua.", spanish=" ¡Ay! No lo hemos hecho bien."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is pretty tough. Let's go\nhome and regroup.", french="Ce n'est pas une mince affaire.\nRentrons nous reposer.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="Questa è proprio tosta. Torniamo\na casa e rimettiamoci in sesto.", spanish="Esto ha sido muy duro.\nVolvamos a casa a recuperar fuerzas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This is tougher than expected.\nLet's go home and regroup.", french="Ce n'est pas une mince affaire.\nRentrons nous reposer.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="È più difficile di quel che\npensassimo. Andiamo a casa, per adesso.", spanish="Es más duro de lo que esperaba.\nVolvamos a casa a recuperar fuerzas."})
  else
  SkySceneKit.say({english="This is tougher than I'd\nexpected. Let's go home and regroup.", french="Ce n'est pas une mince affaire.\nRentrons nous reposer.", german="Das ist ziemlich schwer. Gehen\nwir heim zu den anderen.", italian="È più difficile di quel che\npensassimo. Andiamo a casa, per adesso.", spanish="¡Qué difícil ha resultado!\nVolvamos a casa a recuperar fuerzas."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_LoadStation(LEVEL_G01P03A, 'UM15') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 344, 248, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Everyone else is still out at\n[CS:P]Crystal Cave[CR].", french="Tous les autres sont encore à\nla [CS:P]Caverne Cristal[CR].", german="Alle anderen sind noch in der\n[CS:P]Kristallhöhle[CR].", italian="Sono tutti ancora alla [CS:P]Grotta di[CR]\n[CS:P]Cristallo[CR].", spanish="Todos los demás siguen en\nla [CS:P]Cueva Cristal[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They're doing their best to\nsearch the place.", french="Ils ratissent la caverne jusque\ndans ses moindres recoins.", german="Sie geben ihr Bestes, um den\nDurchgang zu finden.", italian=" Stanno cercando dappertutto.", spanish="Están haciendo lo posible para\nregistrar ese sitio de arriba a abajo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You two should get moving and\njoin them.", french=" Vous devriez aller les rejoindre.", german="Ihr zwei solltet zurückgehen\nund ihnen helfen.", italian="Voi due dovreste andare laggiù a\ndare una mano.", spanish="Deberíais ir ahora mismo a\nayudarles."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll go as soon as we\nget ready.", french="On y retourne dès que\nnos préparatifs sont finis.", german="Wir gehen, sobald wir fertig\nsind.", italian="Appena siamo pronti, dovremmo\nandare.", spanish="Iremos en cuanto lo tengamos\ntodo listo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go as soon as we\nget ready.", french="On y retourne dès que\nnos préparatifs sont finis.", german="Wir sollten gehen, sobald wir\nfertig sind.", italian="Appena siamo pronti, dovremmo\nandare.", spanish="Deberíamos salir en cuanto lo\ntengamos todo listo."})
  else
  SkySceneKit.say({english="We'd better go as soon as\nwe're ready.", french="On y retourne dès que\nnos préparatifs sont finis.", german="Wir sollten besser gehen, sobald\nwir fertig sind.", italian="Non appena è tutto pronto,\ndovremmo andare.", spanish="Será mejor que vayamos cuando\nlo tengamos todo listo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Off to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Si va alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Off to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Si va alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  else
  SkySceneKit.say({english=" Off to [CS:P]Crystal Cave[CR]!", french="En route pour la [CS:P]Caverne\nCristal[CR]!", german=" Auf zur [CS:P]Kristallhöhle[CR]!", italian=" Si va alla [CS:P]Grotta di Cristallo[CR]!", spanish=" ¡Vamos a la [CS:P]Cueva Cristal[CR]!"})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  -- Destroy() [neutre/état moteur]
  GROUND:TeleportTo(hero, 356, 228, Direction.Down)
  GROUND:TeleportTo(partner, 332, 228, Direction.Down)
  GROUND:EntTurn(hero, Direction.Down)
  GROUND:EntTurn(partner, Direction.Down)
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  GAME:WaitFrames(30)
  GAME:FadeIn(30)
  SkySceneKit.cleanup_npcs()
end
