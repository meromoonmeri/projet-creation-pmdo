-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D07P11A/m08a1101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(9, 6) -- $SCENARIO_MAIN = scn[9,6] (ROM)
  -- back_SetGround(LEVEL_D07P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  -- supervision_LoadStation(LEVEL_D07P11A, 'UM08') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Mt. Horn.ogg", true) end)
  -- supervision_Acting(2) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(partner, 312, 180, false, 2)
  GAME:WaitFrames(50)
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(hero, 360, 180, false, 2)
  GAME:WaitFrames(50)
  -- supervision_Station(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 360, 136, Direction.UpLeft, "NPC_BIPPA")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GROUND:MoveToPosition(npc_npc_bippa, 328, 156, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? This place again?!", french=" Hein? Encore cet endroit?!", german="Huch? Wir sind schon wieder\nhier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? This place again?!", french=" Hein? Encore cet endroit?!", german="Huch? Wir sind schon wieder\nhier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
  else
  SkySceneKit.say({english=" Huh? This place again?!", french=" Hein? Encore cet endroit?!", german="Huch? Wir sind schon wieder\nhier?!?", italian=" Eh? Di nuovo questo posto?!", spanish="¿Cómo? ¡¿Qué hacemos aquí\notra vez?!"})
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
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Seems to me that we're back\nwhere we came from.", french="Sapristi! On est rev'nus\nlà où on était tout à l'heure!", german="Wie es aussieht, sind wir\nwieder dort angelangt, von wo aus wir unsere\nReise begonnen haben. Jawollja!", italian="Mi sa che siamo tornati\nnel posto da cui siamo partiti.", spanish="Parece que hemos vuelto\nal mismo sitio de antes."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like taking that [CS:P]Rock\nPath[CR] brings us right back where we started.", french="On dirait que le [CS:P]Chemin Rocheux[CR]\nnous a ramenés à notre point de départ.", german="Anscheinend hat dieser [CS:P]Felspfad[CR]\nuns im Kreis geführt.", italian="Sembra che percorrere quella\n[CS:P]Pista Rocciosa[CR] ci riporti indietro.", spanish="Parece que ir por el [CS:P]Paso Rocoso[CR]\nnos ha devuelto al punto de partida."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like taking that [CS:P]Rock\nPath[CR] brings us right back where we started.", french="On dirait que le [CS:P]Chemin Rocheux[CR]\nnous a ramenés à notre point de départ.", german="Anscheinend hat dieser [CS:P]Felspfad[CR]\nuns im Kreis geführt.", italian="Sembra che percorrere quella\n[CS:P]Pista Rocciosa[CR] ci riporti indietro.", spanish="Parece que ir por el [CS:P]Paso Rocoso[CR]\nnos ha devuelto al punto de partida."})
  else
  SkySceneKit.say({english="It looks like taking that [CS:P]Rock\nPath[CR] brings us right back where we started.", french="On dirait que le [CS:P]Chemin Rocheux[CR]\nnous a ramenés à notre point de départ.", german="Anscheinend hat dieser [CS:P]Felspfad[CR]\nuns im Kreis geführt.", italian="Sembra che percorrere quella\n[CS:P]Pista Rocciosa[CR] ci riporti indietro.", spanish="Parece que ir por el [CS:P]Paso Rocoso[CR]\nnos ha devuelto al punto de partida."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(2, 1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="If we aim to get across,\nI reckon we ought to choose [CS:P]Mt. Horn[CR].", french="Si on veut y arriver, j'pense\nqu'on doit passer par le [CS:P]Mt Corne[CR].", german="Wenn wir auf die andere Seite\nwollen, sollten wir über den [CS:P]Hornberg[CR] gehen.", italian="Se vogliamo proseguire,\ndobbiamo andare verso il [CS:P]Monte Aguzzo[CR].", spanish="Si queremos seguir avanzando,\ntendremos que ir por el [CS:P]Monte Cuerno[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We're close to the base\ncamp now.", french="On n'est plus très loin du camp\nde base.", german="Wir sind jetzt nahe am\nBasislager.", italian="Adesso siamo vicini al Campo\nBase.", spanish="Ya estamos cerca del\ncampamento base."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We're close to the base\ncamp now.", french="On n'est plus très loin du camp\nde base.", german="Wir sind jetzt nahe am\nBasislager.", italian="Adesso siamo vicini al Campo\nBase.", spanish="Ya estamos cerca del\ncampamento base."})
  else
  SkySceneKit.say({english="We're close to the base\ncamp now.", french="On n'est plus très loin du camp\nde base.", german="Wir sind jetzt nahe am\nBasislager.", italian="Adesso siamo vicini al Campo\nBase.", spanish="Ya estamos cerca del\ncampamento base."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's get it done, [hero]!", french=" Finissons-en, [hero]!", german=" Packen wir es an, [hero]!", italian=" Forza, [hero]!", spanish=" ¡Venga, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's get it done, [hero]!", french=" Finissons-en, [hero]!", german=" Packen wir es an, [hero]!", italian=" Forza, [hero]!", spanish=" ¡Venga, [hero]!"})
  else
  SkySceneKit.say({english=" Let's get it done, [hero]!", french=" Finissons-en, [hero]!", german=" Packen wir es an, [hero]!", italian=" Forza, [hero]!", spanish=" ¡Venga, [hero]!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
