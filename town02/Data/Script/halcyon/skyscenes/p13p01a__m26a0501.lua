-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P13P01A/m26a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_HAVE_TO_GET_HOME non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P13P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(512) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(480), g.ViewCenter.Y+(0), 120, false) end) -- back_SetBackScrollSpeed(4.0,0.0) px/frame -> caméra continue (pilote scroll)
  GAME:FadeIn(60)
  GAME:WaitFrames(120)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...I have to live...[K] I have to get\nhome alive...", french="... La vie continue...[K] Je dois\nrentrer chez nous, je dois rester en vie...", german="Ich muss leben...[K] Ich muss es\nlebendig nach Hause schaffen...", italian="Io devo sopravvivere...[K] Devo\ntornare a casa...", spanish="Tengo que seguir adelante...[K]\nDebo llegar a casa sano y salvo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...I have to live...[K] I have to get\nhome alive...", french="... La vie continue...[K] Je dois\nrentrer chez nous, je dois rester en vie...", german="Ich muss leben...[K] Ich muss es\nlebendig nach Hause schaffen...", italian="Io devo sopravvivere...[K] Devo\ntornare a casa...", spanish="Tengo que seguir adelante...[K]\nDebo llegar a casa sano y salvo."})
  else
  SkySceneKit.say({english="...I have to live...[K] I have to get\nhome alive...", french="... La vie continue...[K] Je dois\nrentrer chez nous, je dois rester en vie...", german="Ich muss leben...[K] Ich muss es\nlebendig nach Hause schaffen...", italian="Io devo sopravvivere...[K] Devo\ntornare a casa...", spanish="Tengo que seguir adelante...[K]\nDebo llegar a casa sana y salva."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="...Get home...[K]and tell everyone\nabout what happened.", french="... Rentrer... chez nous...[K] et\nraconter à tout le monde ce qui s'est passé.", german="Nach Hause...[K] Und allen erzählen,\nwas geschehen ist.", italian="Tornare a casa...[K] e raccontare\na tutti cos'è successo.", spanish="Tengo que volver a casa...[K] y\ncontarles a todos lo ocurrido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="...Get home...[K]and tell everyone\nabout what happened.", french="... Rentrer... chez nous...[K] et\nraconter à tout le monde ce qui s'est passé.", german="Nach Hause...[K] Und allen erzählen,\nwas geschehen ist.", italian="Tornare a casa...[K] e raccontare\na tutti cos'è successo.", spanish="Tengo que volver a casa...[K] y\ncontarles a todos lo ocurrido."})
  else
  SkySceneKit.say({english="...Get home...[K]and tell everyone\nabout what happened.", french="... Rentrer... chez nous...[K] et\nraconter à tout le monde ce qui s'est passé.", german="Nach Hause...[K] Und allen erzählen,\nwas geschehen ist.", italian="Tornare a casa...[K] e raccontare\na tutti cos'è successo.", spanish="Tengo que volver a casa...[K] y\ncontarles a todos lo ocurrido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Because it's...[K] [hero]'s...", french="Parce que c'est...[K] ce que\n[hero]...", german="Es war der Wunsch von...[K]\n[hero]...", italian=" Perché è...[K] l'ultimo desiderio...", spanish="Porque eso fue lo que...[K] lo que\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Because it's...[K] [hero]'s...", french="Parce que c'est...[K] ce que\n[hero]...", german="Es war der Wunsch von...[K]\n[hero]...", italian=" Perché è...[K] l'ultimo desiderio...", spanish="Porque eso fue lo que...[K] lo que\n[hero]..."})
  else
  SkySceneKit.say({english=" Because it's...[K] [hero]'s...", french="Parce que c'est...[K] ce que\n[hero]...", german="Es war der Wunsch von...[K]\n[hero]...", italian=" Perché è...[K] l'ultimo desiderio...", spanish="Porque eso fue lo que...[K] lo que\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's [hero]'s...[K]last wish...", french="C'est la dernière volonté...[K]\nde [hero]...", german="Es war der letzte Wunsch\nvon...[K] [hero]...", italian="Perché è l'ultimo...[K] desiderio di\n[hero]...", spanish="Lo que [hero]...[K] me pidió\nque hiciera."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's [hero]'s...[K]last wish...", french="C'est la dernière volonté...[K]\nde [hero]...", german="Es war der letzte Wunsch\nvon...[K] [hero]...", italian="Perché è l'ultimo...[K] desiderio di\n[hero]...", spanish="Lo que [hero]...[K] me pidió\nque hiciera."})
  else
  SkySceneKit.say({english=" It's [hero]'s...[K]last wish...", french="C'est la dernière volonté...[K]\nde [hero]...", german="Es war der letzte Wunsch\nvon...[K] [hero]...", italian="Perché è l'ultimo...[K] desiderio di\n[hero]...", spanish="Lo que [hero]...[K] me pidió\nque hiciera."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(160)
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:WaitFrames(140)
  -- GAP: BGM BGM_FARTHER_AWAY non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetBackScrollSpeed(0,0): arrêt du défilement
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  -- message_SetWaitMode(160, 90) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Th-there's...", french=" C'est...", german=" D-da ist...", italian=" E-Ecco...", spanish=" Allí está..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Th-there's...", french=" C'est...", german=" D-da ist...", italian=" E-Ecco...", spanish=" Allí está..."})
  else
  SkySceneKit.say({english=" Th-there's...", french=" C'est...", german=" D-da ist...", italian=" E-Ecco...", spanish=" Allí está..."})
  end
  -- message_KeyWait
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" There's the Rainbow Stoneship...", french=" C'est le Vaisseau Arc-en-Ciel...", german="Da ist das\nRegenbogen-Steinschiff...", italian=" Ecco il Vascello Arcobaleno...", spanish=" La Barca Arcoiris..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" There's the Rainbow Stoneship...", french=" C'est le Vaisseau Arc-en-Ciel...", german="Da ist das\nRegenbogen-Steinschiff...", italian=" Ecco il Vascello Arcobaleno...", spanish=" La Barca Arcoiris..."})
  else
  SkySceneKit.say({english=" There's the Rainbow Stoneship...", french=" C'est le Vaisseau Arc-en-Ciel...", german="Da ist das\nRegenbogen-Steinschiff...", italian=" Ecco il Vascello Arcobaleno...", spanish=" La Barca Arcoiris..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  -- SetAnimation(768) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(8), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(32), p.Y+(-8), false, 1) end -- Move2PositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(5)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(8), false, 2) end -- Move2PositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(80), p.Y+(4), false, 2) end -- Move2PositionOffset
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(30)
end
