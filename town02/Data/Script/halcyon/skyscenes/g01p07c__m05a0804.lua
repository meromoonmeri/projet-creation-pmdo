-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m05a0804.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm the biggest chicken around,\nand even I managed to work up the courage!", french="Comme poule mouillée, on peut\ndire que j'ai fait mes preuves... Et même moi,\nj'ai réussi à être courageux!", german="Ich bin der größte Angsthase,\nund trotzdem habe ich es geschafft, meinen\nMut zusammenzunehmen!", italian="Sono un gran fifone, ma persino\nio sono riuscito a trovare il coraggio!", spanish="¡Aunque soy el explorador más\ncobardica que hay, pude armarme de valor\npara esta aventura!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm the biggest chicken around,\nand even I managed to work up the courage!", french="Comme poule mouillée, on peut\ndire que j'ai fait mes preuves... Et même moi,\nj'ai réussi à être courageux!", german="Ich bin der größte Angsthase,\nund trotzdem habe ich es geschafft, meinen\nMut zusammenzunehmen!", italian="Sono un gran fifone, eppure\nsono riuscito a trovare il coraggio!", spanish="¡Aunque soy el explorador más\ncobardica que hay, pude armarme de valor\npara esta aventura!"})
  else
  SkySceneKit.say({english="I'm the biggest chicken around,\nand even I managed to work up the courage!", french="Comme poule mouillée, on peut\ndire que j'ai fait mes preuves... Et même moi,\nj'ai réussi à être courageuse!", german="Ich bin der größte Angsthase,\nund trotzdem habe ich es geschafft, meinen\nMut zusammenzunehmen!", italian="Fifona come sono, ho trovato il\ncoraggio anch'io!", spanish="¡Aunque soy la exploradora más\ncobardica que hay, pude armarme de valor\npara esta aventura!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And it was all because you were\nwith me, [hero].", french="Et tout ça parce que tu étais à\nmes côtés, [hero].", german="Und das alles nur, weil du dabei\nwarst, [hero].", italian="Ed è stato grazie al fatto che tu\neri con me, [hero].", spanish="Y eso es porque estabas\nconmigo, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And it was all because you were\nwith me, [hero].", french="Et tout ça parce que tu étais à\nmes côtés, [hero].", german="Und das alles nur, weil du dabei\nwarst, [hero].", italian="Ed è stato grazie al fatto che tu\neri con me, [hero].", spanish="Y todo se debe a que estabas\nconmigo, [hero]."})
  else
  SkySceneKit.say({english="And it was all because you were\nwith me, [hero].", french="Et tout ça parce que tu étais à\nmes côtés, [hero].", german="Und das alles nur, weil du dabei\nwarst, [hero].", italian="Ed è stato grazie al fatto che tu\neri con me, [hero].", spanish="Y eso es porque estabas\nconmigo, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Seriously, [hero], thanks!", french="Je te remercie de tout cœur,\n[hero]!", german=" Wirklich, [hero], danke!", italian=" Grazie davvero, [hero]!", spanish="De verdad, [hero].\n¡Muchas gracias!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Seriously, [hero], thanks!", french="Je te remercie de tout cœur,\n[hero]!", german=" Wirklich, [hero], danke!", italian=" Grazie davvero, [hero]!", spanish="De verdad, [hero].\n¡Muchas gracias!"})
  else
  SkySceneKit.say({english=" Seriously, [hero], thanks!", french="Je te remercie de tout cœur,\n[hero]!", german=" Wirklich, [hero], danke!", italian=" Grazie davvero, [hero]!", spanish="De verdad, [hero].\n¡Muchas gracias!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:WaitFrames(60)
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Oh yeah!", french=" ... Ah, au fait!", german=" ...Oh ja!", italian=" ... Oh sì!", spanish=" ¡Ah! Se me olvidaba algo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Oh yeah!", french=" ... Ah, au fait!", german=" ...Oh ja!", italian=" ... Oh sì!", spanish=" ¡Ah! Se me olvidaba algo."})
  else
  SkySceneKit.say({english=" ...Oh yeah!", french=" ... Ah, au fait!", german=" ...Oh ja!", italian=" ... Oh sì!", spanish=" ¡Ah! Se me olvidaba algo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You know, I was thinking...", french=" J'ai réfléchi à tout ça...", german=" Weißt du, ich habe nachgedacht.", italian=" Sai, stavo pensando...", spanish=" He estado dándole vueltas..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You know, I was thinking...", french=" J'ai réfléchi à tout ça...", german=" Weißt du, ich habe nachgedacht.", italian=" Sai, stavo pensando...", spanish=" He estado pensando..."})
  else
  SkySceneKit.say({english=" You know, I was thinking...", french=" J'ai réfléchi à tout ça...", german=" Weißt du, ich habe nachgedacht.", italian=" Sai, stavo pensando...", spanish=" He estado pensando..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I noticed something about your\ndizzy spells, [hero].", french="... et j'ai remarqué quelque\nchose à propos de tes vertiges, [hero].", german="Mir ist etwas an deinen\nSchwindelanfällen aufgefallen, [hero].", italian="Ho notato una cosa riguardo ai\ntuoi capogiri, [hero].", spanish="Me he dado cuenta de una cosa\ncuando te mareas, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I noticed something about your\ndizzy spells, [hero].", french="... et j'ai remarqué quelque\nchose à propos de tes vertiges, [hero].", german="Mir ist etwas an deinen\nSchwindelanfällen aufgefallen, [hero].", italian="Ho notato una cosa riguardo ai\ntuoi capogiri, [hero].", spanish="He notado algo sobre tus mareos,\n[hero]."})
  else
  SkySceneKit.say({english="I noticed something about your\ndizzy spells, [hero].", french="... et j'ai remarqué quelque\nchose à propos de tes vertiges, [hero].", german="Mir ist etwas an deinen\nSchwindelanfällen aufgefallen, [hero].", italian="Ho notato una cosa riguardo ai\ntuoi capogiri, [hero].", spanish="He notado algo sobre tus mareos,\n[hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You always seem to be touching\nsomething when they happen.", french="On dirait qu'ils se produisent\ntoujours quand tu touches quelque chose.", german="Anscheinend berührst du immer\ngerade irgendetwas, wenn sie kommen.", italian="Si sono verificati sempre quando\nhai toccato qualcosa.", spanish="Parece que siempre se producen\ncuando tocas algo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You always seem to be touching\nsomething when they happen.", french="On dirait qu'ils se produisent\ntoujours quand tu touches quelque chose.", german="Anscheinend berührst du immer\ngerade irgendetwas, wenn sie kommen.", italian="Quando ne hai avuto uno,\nstavi sempre toccando qualcosa.", spanish="Parece que siempre se producen\ncuando tocas algo."})
  else
  SkySceneKit.say({english="They always seem to happen\nwhen you're touching something.", french="On dirait qu'ils se produisent\ntoujours quand tu touches quelque chose.", german="Anscheinend berührst du immer\ngerade irgendetwas, wenn sie kommen.", italian="Mi pare che si siano verificati\nsempre mentre toccavi qualcosa.", spanish="Parece que siempre se producen\ncuando tocas algo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Come to think of it, [partner]'s right!)", french="(Mais c'est vrai, ça! [partner] a raison!)", german="(Das stimmt! [partner] hat recht!)", italian="(A pensarci, [partner] ha ragione!)", spanish="(Ahora que lo pienso, ¡[partner] tiene\nrazón!)"})
  else
  SkySceneKit.say({english="(Come to think of it, [partner]'s right!)", french="(Mais c'est vrai, ça! [partner] a raison!)", german="(Das stimmt! [partner] hat recht!)", italian="(A pensarci, [partner] ha ragione!)", spanish="(Ahora que lo pienso, ¡[partner] tiene\nrazón!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(When I heard [CS:N]Azurill[CR]'s scream...)", french="(Quand j'ai entendu crier [CS:N]Azurill[CR]...)", german="(Als ich [CS:N]Azurill[CR] schreien hörte...)", italian="(Quando ho sentito [CS:N]Azurill[CR] gridare...)", spanish="(Cuando escuché el grito de [CS:N]Azurill[CR]...)"})
  else
  SkySceneKit.say({english="(When I heard [CS:N]Azurill[CR]'s scream...)", french="(Quand j'ai entendu crier [CS:N]Azurill[CR]...)", german="(Als ich [CS:N]Azurill[CR] schreien hörte...)", italian="(Quando ho sentito [CS:N]Azurill[CR] gridare...)", spanish="(Cuando escuché el grito de [CS:N]Azurill[CR]...)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
