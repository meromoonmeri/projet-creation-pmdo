-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m11d0512.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  GAME:FadeOut(true, 0) -- screen_WhiteOutAll
  GAME:WaitFrames(1)
  GAME:FadeIn(0)
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- back_SetWeather(9) [météo visuelle ground NDS - documenté]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(15)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]And at one point, I met\n[CN]Team [team:].", french="[CN]C'est alors que j'ai fait la connaissance\n[CN]de l'Equipe [team:].", german="[CN]Und irgendwann traf ich dann\n[CN]Team [team:].", italian="[CN]E a un certo punto, incontrai\n[CN]il Team [team:].", spanish="[CN]Y, en un momento dado,\n[CN]conocí al [CS:X]Equipo[CR] [team:]."})
  -- message_Close
  -- back_SetBackEffect(5) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 320, 200, Direction.Up, "NPC_YONOWAARU")
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_yonowaaru, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Hello there! You're from the\nguild, if I'm not mistaken?", french="Bonjour à vous! Vous êtes de\nla Guilde, si je ne m'abuse?", german="Hallo! Ihr seid von der Gilde,\nwenn ich mich nicht irre.", italian="Buongiorno a voi. Se non erro\nfate parte della Gilda.", spanish="¡Hola! Sois miembros del\n[CS:N]Pokégremio[CR], ¿verdad?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Jep. Wir sind\nTeam [team:].", italian="Già. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Ja. Wir sind\nTeam [team:].", italian="È proprio così. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  else
  SkySceneKit.say({english=" Yes. We're Team [team:].", french="Oui, on est l'Equipe\n[team:].", german="Ja. Wir sind\nTeam [team:].", italian="È proprio così. Noi siamo il\nTeam [team:].", spanish="Sí. Somos el [CS:X]Equipo[CR]\n[team:]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We work at the guild.[K] Great to\nmeet you!", french="On travaille à la Guilde.[K]\nEnchantés de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nWie toll, dich zu treffen!", italian=" Piacere di conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We work at the guild.[K]\nIt's great to meet you!", french="On travaille à la Guilde.[K]\nEnchantés de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nFreut uns sehr, dich zu treffen!", italian=" È un onore per noi conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  else
  SkySceneKit.say({english="We work at the guild.[K]\nWe're pleased to meet you!", french="On travaille à la Guilde.[K]\nQuel honneur de vous connaître!", german="Wir arbeiten für die Gilde.[K]\nEs freut uns sehr, dich zu treffen!", italian=" È un onore per noi conoscerla!", spanish="Trabajamos en el [CS:N]Pokégremio[CR].[K]\n¡Es un placer conocerte!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- back_SetBackEffect(4) [état de lecture des palettes animées NDS: autotiles PMDO animés en boucle - documenté]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]But at that point,\n[CN]I suspected nothing...", french="[CN]Mais à ce moment-là,\n[CN]je ne me suis douté de rien...", german="[CN]Aber zu diesem Zeitpunkt\n[CN]ahnte ich noch nichts...", italian="[CN]Ma a quel punto,\n[CN]non avvertii nulla...", spanish="[CN]En aquel instante\n[CN]no sospeché nada."})
  -- message_Close
  GAME:FadeOut(true, 30) -- screen_WhiteOutAll
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeOut(true, 0) -- screen_WhiteOut
  GAME:FadeIn(0)
  SkySceneKit.cleanup_npcs()
end
