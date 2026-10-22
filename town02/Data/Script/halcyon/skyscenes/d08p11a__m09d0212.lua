-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09d0212.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  else
  SkySceneKit.say({english=" Huh? What is this?", french=" Hein? Qu'est-ce que c'est?", german=" Huch? Was ist das?", italian=" Eh? E questa cos'è?", spanish=" ¿Eh? ¿Qué es esto?"})
  end
  -- message_Close
  GROUND:EntTurn(partner, Direction.Left)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GAME:MoveCamera(300, 132, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(hero, 300, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish=" Parece algún tipo de piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish=" Parece algún tipo de piedra."})
  else
  SkySceneKit.say({english="It looks like some kind of stone,\nI guess.", french=" On dirait une sorte de pierre.", german="Sieht aus wie eine Art Stein,\nwürde ich sagen.", italian=" Sembra una pietra.", spanish="Supongo que es algún tipo de\npiedra."})
  end
  -- message_KeyWait
  GROUND:EntTurn(hero, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  else
  SkySceneKit.say({english="It's red and pretty. It's kind of\nlike a gem, actually.", french="Elle est rouge, et plutôt jolie\navec ça. En fait, c'est une sorte de gemme.", german="Er ist rot und wunderschön.\nEs ist eher eine Art Edelstein.", italian="È rossa e graziosa. Assomiglia\npiù a una gemma.", spanish="Es roja y hermosa. Más bien\ndebe de ser una piedra preciosa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] picked\n[CN]up the red stone.", french="[CN][partner] ramasse\n[CN]la pierre rouge.", german="[CN][partner] hebt\n[CN]den roten Stein auf.", italian="[CN][partner] raccoglie\n[CN]la pietra rossa.", spanish="[CN][partner] cogió\n[CN]la piedra roja."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! This stone feels warm!", french=" Hé! Cette pierre est chaude!", german=" Hey! Der Stein ist ganz warm!", italian=" Ehi! Questa pietra è calda!", spanish=" ¡Oye! ¡Esta piedra está caliente!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wow! This stone feels warm!", french=" Hé! Cette pierre est chaude!", german=" Wow! Der Stein ist ganz warm!", italian=" Ehi! Questa pietra è calda!", spanish="¡Vaya! ¡Esta piedra está caliente\nal tacto!"})
  else
  SkySceneKit.say({english=" Wow! It feels warm!", french=" Hé! Cette pierre est chaude!", german=" Wow! Er fühlt sich warm an!", italian=" Ehi! Questa pietra è calda!", spanish=" ¡Vaya! ¡Está caliente!"})
  end
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
end
