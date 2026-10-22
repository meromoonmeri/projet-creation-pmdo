-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P06A/m03a1313.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  -- bgm2_PlayFadeIn(BGM_STORM) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  -- back_SetGround(LEVEL_V03P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 344, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(1024) [anim idle native]
  -- GAP: SetEffect EFFECT_VERY_HEAVY_RAIN — VFX sans émote PMDO équivalente
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(15) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GROUND:MoveToPosition(npc_npc_juputoru, 204, 204, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(60)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:FadeIn(0) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But my guess is that if a Time\nGear is removed from a region...", french="Mais j'imagine que si une\nrégion n'a plus son Rouage du Temps...", german="Aber ich vermute, wenn ein\nZahnrad der Zeit aus einer Region\nentfernt wird...", italian="Ma penso che se un Ingranaggio\ndel Tempo venisse rimosso...", spanish="Pero supongo que si se quitase\nel Engranaje del Tiempo de una región..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But my guess is that if a Time\nGear is removed from a region...", french="Mais j'imagine que si une\nrégion n'a plus son Rouage du Temps...", german="Aber ich vermute, wenn ein\nZahnrad der Zeit aus einer Region\nentfernt wird...", italian="Ma penso che se un Ingranaggio\ndel Tempo venisse rimosso...", spanish="Pero supongo que si se extrajera\nel Engranaje del Tiempo de una región..."})
  else
  SkySceneKit.say({english="But my guess is that if a Time\nGear is removed from a region...", french="Mais j'imagine que si une\nrégion n'a plus son Rouage du Temps...", german="Aber ich vermute, wenn ein\nZahnrad der Zeit aus einer Region\nentfernt wird...", italian="Ma penso che se un Ingranaggio\ndel Tempo venisse rimosso...", spanish="Pero supongo que si se quitase\nel Engranaje del Tiempo de una región..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The flow of time in that region\nwill probably stop too.", french="... le temps cesse de s'y écouler\nnormalement.", german="Dann wird der Fluss der Zeit\nin dieser Region wahrscheinlich aufhören.", italian="... probabilmente il flusso\ndel tempo in quella regione si arresterebbe.", spanish="El tiempo dejaría de fluir en esa\nzona."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The flow of time in that region\nwill probably stop too.", french="... le temps cesse de s'y écouler\nnormalement.", german="Dann wird der Fluss der Zeit\nin dieser Region wahrscheinlich aufhören.", italian="... probabilmente il flusso\ndel tempo in quella regione si arresterebbe.", spanish="El tiempo dejaría de fluir en esa\nzona."})
  else
  SkySceneKit.say({english="The flow of time in that region\nwill probably stop too.", french="... le temps cesse de s'y écouler\nnormalement.", german="Dann wird der Fluss der Zeit\nin dieser Region wahrscheinlich aufhören.", italian="... probabilmente il flusso\ndel tempo in quella regione si arresterebbe.", spanish="El tiempo dejaría de fluir en esa\nzona."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(42) [anim idle native]
  -- SetAnimation(768) [anim idle native]
  do local p=npc_npc_juputoru.Position; GROUND:MoveToPosition(npc_npc_juputoru, p.X+(0), p.Y+(-40), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(256) [anim idle native]
  GAME:WaitFrames(30)
  -- GAP: se_Play(6401) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(3)
  GAME:FadeIn(2)
  GAME:FadeIn(0) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why everyone makes sure\nnever to disturb the Time Gears.", french="C'est pour ça qu'il faut veiller\nà ce que les Rouages du Temps ne soient\npas déplacés.", german="Darum achtet jeder darauf, die\nZahnräder der Zeit nicht zu stören.", italian="È per questo che gli Ingranaggi\ndel Tempo vengono lasciati in pace.", spanish="Por eso, nadie se atreve a tocar\nlos Engranajes del Tiempo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why everyone makes sure\nnever to disturb the Time Gears.", french="C'est pour ça qu'il faut veiller\nà ce que les Rouages du Temps ne soient\npas déplacés.", german="Darum achtet jeder darauf, die\nZahnräder der Zeit nicht zu stören.", italian="È per questo che gli Ingranaggi\ndel Tempo vengono lasciati in pace.", spanish="Por eso, nadie se atreve a tocar\nlos Engranajes del Tiempo."})
  else
  SkySceneKit.say({english="That's why everyone makes sure\nnever to disturb the Time Gears.", french="C'est pour ça qu'il faut veiller\nà ce que les Rouages du Temps ne soient\npas déplacés.", german="Darum achtet jeder darauf, die\nZahnräder der Zeit nicht zu stören.", italian="È per questo che gli Ingranaggi\ndel Tempo vengono lasciati in pace.", spanish="Por eso, nadie se atreve a tocar\nlos Engranajes del Tiempo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Everyone has long been certain\nthat some kind of disaster would strike.", french="A ce qu'on raconte, cela\nprovoquerait un désastre sans précédent.", german="Alle sind sich seit Langem\nsicher, dass es zu einer Katastrophe\nführen würde.", italian="Tutti i Pokémon sono consape-\nvoli del fatto che rimuoverli sarebbe\ndisastroso.", spanish="Todos sabemos que algo así\nprovocaría un desastre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Everyone has long been certain\nthat some kind of disaster would strike.", french="A ce qu'on raconte, cela\nprovoquerait un désastre sans précédent.", german="Alle sind sich seit Langem\nsicher, dass es zu einer Katastrophe\nführen würde.", italian="Tutti i Pokémon sono consape-\nvoli del fatto che rimuoverli sarebbe\ndisastroso.", spanish="Todos sabemos que algo así\nprovocaría un desastre."})
  else
  SkySceneKit.say({english="Everyone has long been certain\nthat some kind of disaster would strike.", french="A ce qu'on raconte, cela\nprovoquerait un désastre sans précédent.", german="Alle sind sich seit Langem\nsicher, dass es zu einer Katastrophe\nführen würde.", italian="Tutti i Pokémon sono consape-\nvoli del fatto che rimuoverli sarebbe\ndisastroso.", spanish="Todos sabemos que algo así\nprovocaría un desastre."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So everyone stays away from\nthe Time Gears and doesn't tamper with them.", french="C'est pour ça que personne n'ose\ntoucher aux Rouages du Temps.", german="Also halten sich alle davon fern\nund lassen die Finger von ihnen.", italian="Quindi si tengono tutti alla larga\ndagli Ingranaggi del Tempo ed evitano di\nmanometterli.", spanish="A nadie se le pasaría por la\ncabeza acercarse a ninguno de ellos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So everyone stays away from\nthe Time Gears and doesn't tamper with them.", french="C'est pour ça que personne n'ose\ntoucher aux Rouages du Temps.", german="Also halten sich alle davon fern\nund lassen die Finger von ihnen.", italian="Quindi si tengono tutti alla larga\ndagli Ingranaggi del Tempo ed evitano di\nmanometterli.", spanish="A nadie se le pasaría por la\ncabeza acercarse a ninguno de ellos."})
  else
  SkySceneKit.say({english="So everyone stays away from\nthe Time Gears and doesn't tamper with them.", french="C'est pour ça que personne n'ose\ntoucher aux Rouages du Temps.", german="Also halten sich alle davon fern\nund lassen die Finger von ihnen.", italian="Quindi si tengono tutti alla larga\ndagli Ingranaggi del Tempo ed evitano di\nmanometterli.", spanish="A nadie se le pasaría por la\ncabeza acercarse a ninguno de ellos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Even the most hardened criminal\nPokémon know to avoid messing with them.", french="Même les criminels les plus\nendurcis ne s'y trompent pas: ils savent\nqu'on ne plaisante pas avec ça.", german="Selbst skrupellose Verbrecher\nmachen sich lieber nicht an ihnen zu schaffen.", italian="Persino il più incallito dei\ncriminali sa che è meglio lasciarli stare.", spanish="Ni el malhechor más desalmado\nse atrevería a tocarlos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Even the most hardened criminal\nPokémon know to avoid messing with them.", french="Même les criminels les plus\nendurcis ne s'y trompent pas: ils savent\nqu'on ne plaisante pas avec ça.", german="Selbst skrupellose Verbrecher\nmachen sich lieber nicht an ihnen zu schaffen.", italian="Persino il più incallito dei\ncriminali sa che è meglio lasciarli stare.", spanish="Ni el malhechor más desalmado\nse atrevería a tocarlos."})
  else
  SkySceneKit.say({english="Even the most hardened criminal\nPokémon know to avoid messing with them.", french="Même les criminels les plus\nendurcis ne s'y trompent pas: ils savent\nqu'on ne plaisante pas avec ça.", german="Selbst skrupellose Verbrecher\nmachen sich lieber nicht an ihnen zu schaffen.", italian="Persino il più incallito dei\ncriminali sa che è meglio lasciarli stare.", spanish="Ni el malhechor más desalmado\nse atrevería a tocarlos."})
  end
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
