-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D06P11A/m08a0701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(9, 3) -- $SCENARIO_MAIN = scn[9,3] (ROM)
  -- back_SetGround(LEVEL_D06P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Craggy Coast.ogg", true) end)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 368, 268, false, 2)
  GAME:WaitFrames(50)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 368, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 344, 252, false, 2)
  -- supervision_Acting(3) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 368, 184, Direction.Down, "NPC_BIPPA")
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bippa, 368, 228, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(npc_npc_bippa, 392, 252, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? This place again?!", french=" Quoi? Encore cet endroit?!", german=" Huch? Wir sind wieder hier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? This place again?!", french=" Quoi? Encore cet endroit?!", german=" Was? Wir sind wieder hier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
  else
  SkySceneKit.say({english=" What? This place again?!", french=" Quoi? Encore cet endroit?!", german=" Was? Wir sind wieder hier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Seems to me that we're back out\nwhere we came from. Yup yup!", french="Sapristi! On est rev'nus\nlà où on était tout à l'heure!", german="Wie es aussieht, sind wir\nwieder dort angelangt, von wo aus wir unsere\nReise begonnen haben. Jawollja!", italian="Mi sembra che siamo tornati\nindietro. Già, già!", spanish="Parece que hemos vuelto\nal mismo sitio de antes. ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_bippa, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like that path brought us\nright back where we started.", french="C'est comme si le chemin nous\navait ramenés à notre point de départ.", german="Anscheinend hat der Weg uns\nwieder zum Anfangspunkt gebracht.", italian="Mi sa che quel sentiero ci ha\nriportati nel luogo da dove siamo partiti.", spanish="Me temo que esa ruta\nnos ha hecho dar una vuelta tonta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like that path loops back\nright to where we started.", french="C'est comme si le chemin nous\navait ramenés à notre point de départ.", german="Anscheinend hat der Weg uns\nim Kreis geführt.", italian="Mi sa che quel sentiero ci ha\nriportati nel luogo da dove siamo partiti.", spanish="Me temo que esa ruta\nnos ha hecho dar una vuelta en redondo."})
  else
  SkySceneKit.say({english="I guess that path looped us right\nback to where we started.", french="C'est comme si le chemin nous\navait ramenés à notre point de départ.", german="Ich glaube, der Weg hat uns\nim Kreis geführt.", italian="Mi sa che quel sentiero ci ha\nriportati nel luogo da dove siamo partiti.", spanish="Es evidente que esa ruta\nnos ha hecho dar una vuelta en redondo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="If we aim to move on, I reckon\nwe ought to choose [CS:P]Craggy Coast[CR].", french="Du coup, j'propose qu'on passe\npar la [CS:P]Côte Escarpée[CR].", german="Wenn wir weitergehen wollen,\nsollten wir wohl über die [CS:P]Schroffküste[CR] gehen.", italian="Se vogliamo proseguire, penso\nche dovremmo andare verso il\n[CS:P]Dirupo Costiero[CR].", spanish="Si queremos seguir avanzando,\ntendremos que ir por la [CS:P]Costa Escarpada[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="All right. We'll take another\nshot at this.[K] Let's get it done!", french="D'accord. On va essayer.[K]\nAllons-y!", german="In Ordnung. Versuchen wir es\nnoch mal.[K] Wir schaffen das!", italian="Va bene. Ci proviamo di nuovo.[K]\nMettiamocela tutta!", spanish="Bueno, vamos a intentarlo\notra vez.[K] ¡Vamos a explorar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="All right. We'll take another\nshot at this.[K] Let's get it done!", french="D'accord. On va essayer.[K]\nAllons-y!", german="In Ordnung. Versuchen wir es\nnoch mal.[K] Wir schaffen das!", italian="Va bene. Ci proviamo di nuovo.[K]\nMettiamocela tutta!", spanish="Bueno, vamos a intentarlo\notra vez.[K] ¡Vamos allá!"})
  else
  SkySceneKit.say({english="All right. We'll take another\nshot at this.[K] Let's get it done!", french="D'accord. On va essayer.[K]\nAllons-y!", german="In Ordnung. Versuchen wir es\nnoch mal.[K] Wir schaffen das!", italian="Va bene. Ci proviamo di nuovo.[K]\nMettiamocela tutta!", spanish="Bueno, vamos a intentarlo\notra vez.[K] ¡Adelante!"})
  end
  -- message_Close
  -- supervision_LoadStation(LEVEL_D06P11A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  SkySceneKit.cleanup_npcs()
end
