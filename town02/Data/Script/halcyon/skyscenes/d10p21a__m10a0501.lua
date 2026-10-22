-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P21A/m10a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(11, 3) -- $SCENARIO_MAIN = scn[11,3] (ROM)
  -- back_SetGround(LEVEL_D10P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Upper Steam Cave.ogg", true) end)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 212, 284, false, 2)
  GROUND:MoveToPosition(hero, 244, 284, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've climbed way up high!", french=" On tient le bon bout!", german="Wir sind ganz schön weit\naufgestiegen!", italian="Abbiamo fatto un bel po' di\nstrada, eh?", spanish=" Hemos subido bastante."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We've made it pretty high up!", french=" On tient le bon bout!", german="Wir haben es ziemlich weit nach\noben geschafft!", italian="Abbiamo fatto un bel pezzo di\nstrada, non credi?", spanish=" Hemos subido bastante."})
  else
  SkySceneKit.say({english=" We've climbed a long way up!", french=" On tient le bon bout!", german="Wir sind ziemlich weit nach\noben gestiegen!", italian="Abbiamo fatto un bel pezzo di\nstrada, non credi?", spanish=" Hemos subido bastante."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Can't be too much farther to\nthe top!", french="Le sommet ne peut plus être loin\nmaintenant!", german="Der Gipfel kann nicht mehr weit\nsein!", italian=" Dovremmo esserci, ormai!", spanish="Ya no puede quedar mucho para\nllegar a la cima."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We must be getting close to\nthe top!", french="Le sommet ne peut plus être loin\nmaintenant!", german="Wir müssten schon nahe am\nGipfel sein!", italian="Dovremmo essere vicini alla\nvetta, ormai.", spanish="Debemos de estar cerca\nde la cima."})
  else
  SkySceneKit.say({english=" We're getting closer to the top!", french="Le sommet ne peut plus être loin\nmaintenant!", german=" Wir sind schon nahe am Gipfel!", italian="Dovremmo essere nei pressi\ndella vetta, ormai.", spanish="Nos estamos acercando\na la cima."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] What was that?!", french=" Hein?[K] C'était quoi, ça?!", german=" Huch?[K] Was war das?!?", italian=" Uh?[K] Ma cos'è stato?", spanish=" ¿Eh?[K] ¿Qué ha sido eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey![K] What was that?", french=" Hein?[K] C'était quoi, ça?!", german=" Hey![K] Was war das?", italian=" Ehi![K] Cos'è stato?", spanish=" ¿Eh?[K] ¿Qué ha sido eso?"})
  else
  SkySceneKit.say({english=" Hey![K] What was that?", french=" Hein?[K] C'était quoi, ça?!", german=" Hey![K] Was war das?", italian=" Ehi![K] Cos'è stato?", spanish=" ¿Eh?[K] ¿Qué ha sido eso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  -- GAP: se_Play(6934) — id SE NDS sans portage PMDO identifié
  SkySceneKit.say({english="GRROOOOOOH...!", french="GRROOOOOOH...!", german="GRROOOOOOH!", italian="GRROOOOOOH...!", spanish="¡GRRRRRRRR!"}) -- message_ImitationSound (onomatopée)
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That![K] Did you hear that?!", french=" Ce bruit-là![K] Tu as entendu ça?!", german=" Das![K] Hast du das gehört?!?", italian=" Quello![K] L'hai sentito?", spanish=" ¡Eso![K] ¿Lo has oído?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Just now...[K] Did you hear that?", french=" Ce bruit-là![K] Tu as entendu ça?!", german="Gerade eben...[K] Hast du das\ngehört?", italian="Quel suono...[K] L'hai sentito anche\ntu?", spanish=" Ese ruido...[K] ¿lo has oído?"})
  else
  SkySceneKit.say({english=" Just now...[K] Did you hear that?", french=" Ce bruit-là![K] Tu as entendu ça?!", german="Gerade eben...[K] Hast du das\ngehört?", italian="Quel suono...[K] L'hai sentito anche\ntu?", spanish=" En serio...[K] ¿tú lo has oído?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Was that for real?[K] Or not?", french=" Est-ce que c'était réel?[K] Ou pas?", german="War das wirklich da?[K]\nOder nicht?", italian=" Me lo sono inventato?[K] O cosa?", spanish=" Ha sido de verdad...[K] ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Did I just imagine that...[K]or not?", french=" Est-ce que c'était réel?[K] Ou pas?", german="Hab ich mir das eingebildet?[K]\nOder nicht?", italian="Non me lo sono immaginato...[K]\nVero?", spanish=" Me lo he imaginado...[K] ¿no?"})
  else
  SkySceneKit.say({english=" Was it all in my head?[K] Or not?", french=" Est-ce que c'était réel?[K] Ou pas?", german="War das nur in meinem Kopf?[K]\nOder nicht?", italian="Non me lo sono immaginato...[K]\nVero?", spanish="Serán imaginaciones mías...[K]\n¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, whatever![K] It's not far to\nthe top now. Let's keep going!", french="Peu importe, continuons![K]\nOn se rapproche du sommet. Courage!", german="Na ja, egal![K] Es ist jetzt nicht\nmehr weit bis zum Gipfel. Gehen wir weiter!", italian="Boh? È lo stesso![K] Non manca\nmolto ormai. Diamoci dentro!", spanish="¡Qué más da![K]\nYa no queda mucho para la cima. ¡Sigamos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, anyway...[K] We're almost\nthere, so let's keep going.", french="Peu importe, continuons![K]\nOn se rapproche du sommet. Courage!", german="Na ja, egal...[K] Wir sind bald da,\nalso lass uns weitergehen.", italian="Mmm, vabbè...[K] Ormai ci siamo!\nMettiamocela tutta!", spanish="No importa...[K] Ya casi estamos en\nla cima, así que sigamos."})
  else
  SkySceneKit.say({english="Anyway...[K]let's keep going! Not\nfar to go now!", french="Peu importe, continuons![K]\nOn se rapproche du sommet. Courage!", german="Egal...[K] Lass uns weitergehen!\nEs ist nicht mehr weit!", italian="Comunque...[K] Andiamo avanti!\nManca poco ormai!", spanish="No importa...[K] ¡Sigamos! ¡Ya no\nqueda mucho!"})
  end
  -- message_Close
end
