-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0205.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_HANDS_OF_FATE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V21P02B) [décor sub chargé: Sub_v21p02b]
  -- back_SetGround(LEVEL_H01P99E) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 20, 18.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- bgm2_ChangeVolume(140, 190) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("v21p02b", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That was it...", french=" C'était bien ça...", german=" Das war es...", italian=" È andata così.", spanish=" Así es..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That was it...", french=" C'était bien ça...", german=" Das war es...", italian=" È andata così.", spanish=" Así es..."})
  else
  SkySceneKit.say({english=" That was it...", french=" C'était bien ça...", german=" Das war es...", italian=" È andata così.", spanish=" Así es..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I could be brave because you\nwere always with me, [hero]...", french="Si j'ai réussi à faire preuve de\ncourage, c'est parce que tu étais toujours\nà mes côtés, [hero]...", german="Ich konnte tapfer sein, weil du\nimmer bei mir warst, [hero]...", italian="Sono riuscito ad essere\ncoraggioso perché tu eri sempre al mio fianco,\n[hero]...", spanish="Fui valiente porque tú siempre\nestuviste a mi lado, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I managed to be brave because\nyou were always with me, [hero]...", french="Si j'ai réussi à faire preuve de\ncourage, c'est parce que tu étais toujours\nà mes côtés, [hero]...", german="Ich schaffte es, tapfer zu\nbleiben, weil du immer bei mir warst,\n[hero]...", italian="Sono riuscito ad essere\ncoraggioso perché tu eri sempre al mio fianco,\n[hero]...", spanish="Fui valiente porque tú siempre\nestuviste a mi lado, [hero]..."})
  else
  SkySceneKit.say({english="I managed to be brave because\nyou were always with me, [hero]...", french="Si j'ai réussi à faire preuve de\ncourage, c'est parce que tu étais toujours\nà mes côtés, [hero]...", german="Ich schaffte es, tapfer zu\nbleiben, weil du immer bei mir warst,\n[hero]...", italian="Sono riuscita ad essere\ncoraggiosa perché tu eri sempre al mio fianco,\n[hero]...", spanish="Fui valiente porque tú siempre\nestuviste a mi lado, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That was when I finally\nunderstood that.", french="C'est à ce moment-là que j'ai\nfini par comprendre.", german="Das habe ich dann endgültig\nverstanden.", italian="È stato allora che l'ho\nfinalmente capito.", spanish="Fue entonces cuando por fin lo\ncomprendí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That was when I finally\nrealized that.", french="C'est à ce moment-là que j'ai\nfini par comprendre.", german="Das wurde mir dann endgültig\nklar.", italian="È stato allora che l'ho\nfinalmente capito.", spanish="Fue entonces cuando por fin lo\ncomprendí."})
  else
  SkySceneKit.say({english="That was when I finally\nrealized that.", french="C'est à ce moment-là que j'ai\nfini par comprendre.", german="Das wurde mir dann endgültig\nklar.", italian="È stato allora che l'ho\nfinalmente capito.", spanish="Fue entonces cuando por fin lo\ncomprendí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And that's what I told [CS:N]Grovyle[CR].", french="C'est ce que j'ai répondu\nà [CS:N]Massko[CR].", german=" Und das habe ich [CS:N]Reptain[CR] gesagt.", italian="Ed è quello che ho detto a\n[CS:N]Grovyle[CR].", spanish="Y eso fue lo que le dije a\n[CS:N]Grovyle[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And that's what I told [CS:N]Grovyle[CR].", french="C'est ce que j'ai répondu\nà [CS:N]Massko[CR].", german=" Und das habe ich [CS:N]Reptain[CR] gesagt.", italian="Ed è quello che ho detto a\n[CS:N]Grovyle[CR].", spanish="Y eso fue lo que le dije a\n[CS:N]Grovyle[CR]."})
  else
  SkySceneKit.say({english=" And that's what I told [CS:N]Grovyle[CR].", french="C'est ce que j'ai répondu\nà [CS:N]Massko[CR].", german=" Und das habe ich [CS:N]Reptain[CR] gesagt.", italian="Ed è quello che ho detto a\n[CS:N]Grovyle[CR].", spanish="Y eso fue lo que le dije a\n[CS:N]Grovyle[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 176, 132, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- message_FacePositionOffset(-1, -1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Just before we lost [CS:N]Grovyle[CR] in\nthe [CS:P]Hidden Land[CR]...", french="Juste avant qu'il ne disparaisse\ndans les [CS:P]Terres Illusoires[CR]...", german="Kurz bevor wir [CS:N]Reptain[CR] im\n[CS:P]Verborgenen Land[CR] verloren haben...", italian="Poco prima di perdere [CS:N]Grovyle[CR]\nnella [CS:P]Terra Nascosta[CR]...", spanish="Sí, justo antes de que nos\nseparáramos de él en la [CS:P]Tierra Oculta[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Just before we lost [CS:N]Grovyle[CR] in\nthe [CS:P]Hidden Land[CR]...", french="Juste avant qu'il ne disparaisse\ndans les [CS:P]Terres Illusoires[CR]...", german="Kurz bevor wir [CS:N]Reptain[CR] im\n[CS:P]Verborgenen Land[CR] verloren haben...", italian="Poco prima di perdere [CS:N]Grovyle[CR]\nnella [CS:P]Terra Nascosta[CR]...", spanish="Sí, justo antes de que nos\nseparáramos de él en la [CS:P]Tierra Oculta[CR]..."})
  else
  SkySceneKit.say({english="Just before we lost [CS:N]Grovyle[CR] in\nthe [CS:P]Hidden Land[CR]...", french="Juste avant qu'il ne disparaisse\ndans les [CS:P]Terres Illusoires[CR]...", german="Kurz bevor wir [CS:N]Reptain[CR] im\n[CS:P]Verborgenen Land[CR] verloren haben...", italian="Poco prima di perdere [CS:N]Grovyle[CR]\nnella [CS:P]Terra Nascosta[CR]...", spanish="Sí, justo antes de que nos\nseparáramos de él en la [CS:P]Tierra Oculta[CR]..."})
  end
  -- message_Close
  -- bgm2_ChangeVolume(140, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
