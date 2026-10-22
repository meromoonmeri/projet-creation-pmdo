-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0107.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:FadeIn(30)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 640, 216, Direction.Right, "NPC_BIPPA")
  GROUND:MoveToPosition(npc_npc_bippa, 320, 212, false, 2)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(hero, 384, 196, false, 2)
  GROUND:MoveToPosition(partner, 384, 220, false, 2)
  GAME:WaitFrames(120)
  pcall(function() GAME:MoveCamera(352, 212, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_bippa, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="This is the main square\nfor the local Pokémon...", french="Ici, c'est la place principale,\noù vivent plusieurs Pokémon...", german="Für die ortsansässigen Pokémon\nist dies der Hauptplatz der Stadt.", italian="Qui ci troviamo nella piazza\ndella città.", spanish="Aquí es donde se concentra toda\nla actividad."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" It's called Treasure Town.", french=" Ça s'appelle Bourg-Trésor.", german=" Wir befinden uns in Schatzstadt.", italian="Questa città si chiama Borgo\nTesoro.", spanish=" Es Aldea Tesoro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, I can tell you about Treasure\nTown too.", french="Oh, moi aussi, je peux te parler\nde Bourg-Trésor.", german="Oh, über Schatzstadt kann ich\ndir auch etwas erzählen.", italian="Anch'io posso parlarti di Borgo\nTesoro!", spanish="¡Yo también conozco bien\nAldea Tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, I can tell you about Treasure\nTown too.", french="Oh, moi aussi, je peux te parler\nde Bourg-Trésor.", german="Oh, über Schatzstadt kann ich\ndir auch etwas erzählen.", italian="Anch'io posso parlarti di Borgo\nTesoro!", spanish="Ah, yo puedo contarte cosas\nde Aldea Tesoro."})
  else
  SkySceneKit.say({english="Oh, I can tell you about Treasure\nTown too.", french="Oh, moi aussi, je peux te parler\nde Bourg-Trésor.", german="Oh, über Schatzstadt kann ich\ndir auch etwas erzählen.", italian="Anch'io posso parlarti di Borgo\nTesoro!", spanish="Ah, yo también sé cosas\nde Aldea Tesoro."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.UpRight)
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That place is [CS:K]Duskull[CR] Bank.", french="Là-bas, c'est la [CS:K]Banque\nSkelénox[CR].", german=" Das ist die [CS:K]Zwirrlicht-Bank[CR].", italian=" Quella è la Banca [CS:K]Duskull[CR].", spanish=" Ese sitio es el [CS:K]Banco Duskull[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That over there is [CS:K]Duskull[CR] Bank.", french="Là-bas, c'est la [CS:K]Banque\nSkelénox[CR].", german=" Das ist die [CS:K]Zwirrlicht-Bank[CR].", italian=" Quella è la Banca [CS:K]Duskull[CR].", spanish=" Eso de ahí es el [CS:K]Banco Duskull[CR]."})
  else
  SkySceneKit.say({english=" That over there is [CS:K]Duskull[CR] Bank.", french="Là-bas, c'est la [CS:K]Banque\nSkelénox[CR].", german=" Das ist die [CS:K]Zwirrlicht-Bank[CR].", italian=" Quella è la Banca [CS:K]Duskull[CR].", spanish="Ese sitio de ahí es\nel [CS:K]Banco Duskull[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We can save our money there.", french="C'est là qu'on peut entreposer\nnotre argent.", german="Dort können wir unser Geld\nlagern.", italian=" Possiamo depositarci i soldi.", spanish="Allí podremos guardar\nnuestro dinero."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We can save our money there.", french="C'est là qu'on peut entreposer\nnotre argent.", german="Dort können wir unser Geld\nlagern.", italian=" Possiamo depositarci i soldi.", spanish="Allí podremos guardar\nnuestro dinero."})
  else
  SkySceneKit.say({english=" We can save our money there.", french="C'est là qu'on peut entreposer\nnotre argent.", german="Dort können wir unser Geld\nlagern.", italian=" Possiamo depositarci i soldi.", spanish="Allí podremos guardar\nnuestro dinero."})
  end
  -- message_Close
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And that over there is the\n[CS:K]Electivire[CR] Link Shop.", french="Et là-bas, c'est le [CS:K]Stand Chaîne\nElekable[CR].", german=" Und da ist [CS:K]Elevoltek-Link[CR].", italian="E laggiù c'è la Combiteca\n[CS:K]Electivire[CR].", spanish="Y eso de allí es\n[CS:K]Enlaces Electivire[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And that over there is the\n[CS:K]Electivire[CR] Link Shop.", french="Et là-bas, c'est le [CS:K]Stand Chaîne\nElekable[CR].", german=" Und da ist [CS:K]Elevoltek-Link[CR].", italian="E laggiù c'è la Combiteca\n[CS:K]Electivire[CR].", spanish="Y eso de allí es\n[CS:K]Enlaces Electivire[CR]."})
  else
  SkySceneKit.say({english="And that over there is the\n[CS:K]Electivire[CR] Link Shop.", french="Et là-bas, c'est le [CS:K]Stand Chaîne\nElekable[CR].", german=" Und da ist [CS:K]Elevoltek-Link[CR].", italian="E laggiù c'è la Combiteca\n[CS:K]Electivire[CR].", spanish="Y eso de allí es\n[CS:K]Enlaces Electivire[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's where you can do things\nlike link moves together, but...", french="C'est l'endroit où on peut lier\ndes capacités, mais...", german="Dort kannst du zum Beispiel\nAttacken kombinieren lassen.", italian="Lì si possono combinare le\nmosse e fare altre cose, ma...", spanish="Allí se pueden enlazar distintos\nmovimientos, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's where you can do things\nlike link moves together, but...", french="C'est l'endroit où on peut lier\ndes capacités, mais...", german="Dort kannst du zum Beispiel\nAttacken kombinieren lassen.", italian="Lì si possono combinare le\nmosse e fare altre cose, ma...", spanish="Allí se pueden enlazar distintos\nmovimientos, pero..."})
  else
  SkySceneKit.say({english="That's where you can do things\nlike link moves together, but...", french="C'est l'endroit où on peut lier\ndes capacités, mais...", german="Dort kannst du zum Beispiel\nAttacken kombinieren lassen.", italian="Lì si possono combinare le\nmosse e fare altre cose, ma...", spanish="Allí se pueden enlazar distintos\nmovimientos, pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess [CS:N]Electivire[CR] isn't\naround today.", french="... on dirait que [CS:N]Elekable[CR] n'est\npas là aujourd'hui.", german="Aber [CS:N]Elevoltek[CR] scheint heute\nnicht da zu sein.", italian="... sembra che oggi [CS:N]Electivire[CR]\nnon ci sia.", spanish="Supongo que [CS:N]Electivire[CR]\nno está hoy por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks as if [CS:N]Electivire[CR] isn't\nhere today.", french="... on dirait que [CS:N]Elekable[CR] n'est\npas là aujourd'hui.", german="Aber [CS:N]Elevoltek[CR] scheint heute\nnicht da zu sein.", italian="... sembra che oggi [CS:N]Electivire[CR]\nnon ci sia.", spanish="[CS:N]Electivire[CR] no parece\nestar hoy por aquí."})
  else
  SkySceneKit.say({english="It looks as if [CS:N]Electivire[CR] isn't\naround today.", french="... on dirait que [CS:N]Elekable[CR] n'est\npas là aujourd'hui.", german="Aber [CS:N]Elevoltek[CR] scheint heute\nnicht da zu sein.", italian="... sembra che oggi [CS:N]Electivire[CR]\nnon ci sia.", spanish="Parece que [CS:N]Electivire[CR] no está\nhoy."})
  end
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-100), g.ViewCenter.Y+(0), 100, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(15)
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
