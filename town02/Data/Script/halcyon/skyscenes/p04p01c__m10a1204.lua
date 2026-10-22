-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P04P01C/m10a1204.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_TIME_GEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P04P01C) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Unbelievable!", french=" Je n'en crois pas mes yeux!", german=" Unglaublich!", italian=" Incredibile!", spanish=" ¡Increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's incredible!", french=" Je n'en crois pas mes yeux!", german=" Das ist unglaublich!", italian=" È fantastico!", spanish=" ¡Es increíble!"})
  else
  SkySceneKit.say({english=" It's so very incredible!", french=" Je n'en crois pas mes yeux!", german=" Das ist einfach unglaublich!", italian=" È davvero fantastico!", spanish=" ¡Resulta increíble!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Such a big lake! Who'd ever\nexpect it way up here on this plateau!", french="Qui aurait pu penser qu'un\nsi grand lac puisse se trouver à une telle\naltitude?", german="Was für ein großer See! Wer\nhätte so etwas hier oben erwartet?", italian="Che lago enorme! Chi l'avrebbe\nmai detto, così in alto...", spanish="¡Qué lago tan grande!\n¿Quién se lo iba a esperar aquí arriba,\nen esta especie de meseta?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Who'd expect to see such a big\nlake on a plateau so high up?", french="Qui aurait pu penser qu'un\nsi grand lac puisse se trouver à une telle\naltitude?", german="Wer würde so hoch oben\neinen so großen See erwarten?", italian="Chi avrebbe mai immaginato che\nci potesse essere un lago così immenso\nquassù?", spanish="¿Quién se iba a esperar ver un\nlago tan grande aquí arriba, en esta meseta?"})
  else
  SkySceneKit.say({english="Who would have guessed that a\nbig lake could be high up on this plateau!", french="Qui aurait pu penser qu'un\nsi grand lac puisse se trouver à une telle\naltitude?", german="Wer hätte gedacht, dass es so\nhoch oben einen so großen See gibt!", italian="Chi avrebbe mai immaginato che\nci potesse essere un lago così immenso\nquassù?", spanish="¿Quién iba a suponer que un lago\ntan grande podía estar aquí arriba, en esta\nespecie de meseta?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And look! Those [CS:N]Volbeat[CR] and\n[CS:N]Illumise[CR] flying around...", french="Et regarde tous ces [CS:N]Muciole[CR]\net ces [CS:N]Lumivole[CR] un peu partout dans le ciel...", german="Und sieh mal! Diese\numherfliegenden [CS:N]Volbeat[CR] und [CS:N]Illumise[CR]...", italian="E guarda! Tutti quei [CS:N]Volbeat[CR] e\nquegli [CS:N]Illumise[CR] che volano...", spanish="¡Y mira cómo revolotean por\naquí esos [CS:N]Illumise[CR] y [CS:N]Volbeat[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And those floating [CS:N]Volbeat[CR] and\n[CS:N]Illumise[CR]...", french="Et regarde tous ces [CS:N]Muciole[CR]\net ces [CS:N]Lumivole[CR] un peu partout dans le ciel...", german="Und diese umherschwebenden\n[CS:N]Volbeat[CR] und [CS:N]Illumise[CR]...", italian="E tutti quei [CS:N]Volbeat[CR] e gli\n[CS:N]Illumise[CR] che volano...", spanish="¡Y mira cómo revolotean por\naquí esos [CS:N]Illumise[CR] y [CS:N]Volbeat[CR]!"})
  else
  SkySceneKit.say({english="And just look at those fluttering\n[CS:N]Volbeat[CR] and [CS:N]Illumise[CR]...", french="Et regarde tous ces [CS:N]Muciole[CR]\net ces [CS:N]Lumivole[CR] un peu partout dans le ciel...", german="Und sieh dir nur mal diese\numherschwirrenden [CS:N]Volbeat[CR] und [CS:N]Illumise[CR] an...", italian="E tutti quei [CS:N]Volbeat[CR] e gli\n[CS:N]Illumise[CR] che volano...", spanish="¡Y mira cómo revolotean por\naquí esos [CS:N]Illumise[CR] y [CS:N]Volbeat[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Amazing!", french=" Quel spectacle éblouissant!", german=" Großartig!", italian=" Davvero incredibile!", spanish=" ¡Increíble!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So beautiful!", french=" Quel spectacle éblouissant!", german=" Wunderschön!", italian=" È bellissimo!", spanish=" ¡Esto es fascinante!"})
  else
  SkySceneKit.say({english=" This couldn't be more dazzling!", french=" Quel spectacle éblouissant!", german=" Das ist einfach umwerfend!", italian=" È bellissimo!", spanish=" ¡Qué hermoso!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_yukushii = SkySceneKit.spawn_npc("uxie", 160, 352, Direction.Up, "NPC_YUKUSHII")
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Water constantly wells up from\nfar below this place.", french="Un puits d'eau très profond\nalimente constamment le lac.", german="Unter diesem Ort quillt\nunablässig Wasser nach oben.", italian="L'acqua sgorga incessantemente\ndalle profondità di questo luogo...", spanish="El agua brota con fuerza bajo\neste lugar."})
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="It flows up so heavily that it\nhas long formed this enormous lake.", french="La source est si abondante\nqu'elle a fini par créer un lac immense.", german="Sein Strom ist so stark, dass es\nschon vor langer Zeit diesen riesigen See\nbildete.", italian="... creando il lago che state\nosservando.", spanish="Brota de forma ininterrumpida,\npor lo que hace mucho tiempo se formó\neste enorme lago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yukushii, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english="Now cast your eyes to the\nglowing area at the lake's center.", french="Maintenant, tournez votre\nregard vers le point lumineux en son centre.", german="Nun richtet euren Blick auf die\nleuchtende Stelle in der Mitte des Sees.", italian="Adesso, vi prego di volgere il\nvostro sguardo alla luce che si trova al centro.", spanish="Ahora mirad con atención\nel resplandor del centro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yep, I see it!", french=" Oui, je le vois!", german=" Okay, ich sehe sie!", italian=" Ok! La vedo!", spanish=" ¡Sí, ya lo veo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes, I see it!", french=" Oui, je le vois!", german=" Ja, ich sehe sie!", italian=" Sì, la vedo!", spanish=" ¡Sí, ya lo veo!"})
  else
  SkySceneKit.say({english=" Sure, I can see it!", french=" Oui, je le vois!", german=" Oh ja, ich sehe sie!", italian=" Sì, la vedo!", spanish=" ¡Sí, ya lo veo!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's coming from below!", french="La lumière provient du fond\ndu lac!", german=" Es kommt von unten!", italian=" Viene da sotto!", spanish=" ¡Sale del fondo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's radiating from below!", french="La lumière provient du fond\ndu lac!", german=" Das Leuchten kommt von unten!", italian=" Proviene dal fondo del lago!", spanish=" ¡La luz sale del fondo!"})
  else
  SkySceneKit.say({english="It's shining up from beneath\nthe waves!", french="La lumière provient du fond\ndu lac!", german="Es leuchtet zwischen den Wellen\nnach oben!", italian=" Proviene dal fondo del lago!", spanish=" ¡Algo brilla por debajo del agua!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That sorta blue, sorta green\nlight, right?", french="C'est cette lumière bleu-vert,\nc'est ça?", german="Dieses halb grünliche, halb\nbläuliche Licht, oder?", italian="È quella luce un po' blu e un po'\nverdina, no?", spanish="Te refieres a esa especie\nde resplandor azul verdoso, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That blue green radiance, right?", french="C'est cette lumière bleu-vert,\nc'est ça?", german=" Dieses grünblaue Strahlen, oder?", italian="Quella luce tra il blu e il\nverde, giusto?", spanish="Te refieres a esa especie\nde resplandor azul verdoso, ¿no?"})
  else
  SkySceneKit.say({english=" The bluish green radiance, right?", french="C'est cette lumière bleu-vert,\nc'est ça?", german="Das bläulich grüne Strahlen,\noder?", italian="Quella luce tra il blu e il\nverde, giusto?", spanish="Te refieres a esa especie\nde resplandor azul verdoso, ¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukushii) end)
  SkySceneKit.say({english=" Step forward for a closer look.", french="Approchez-vous pour la voir\nde plus près.", german="Geht näher heran und seht\ngenauer hin.", italian=" Avvicinatevi.", spanish="Dad un paso al frente para poder\nverlo mejor."})
  -- message_Close
  GROUND:EntTurn(npc_npc_yukushii, Direction.Up)
  GROUND:MoveToPosition(partner, 136, 368, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 176, 368, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
