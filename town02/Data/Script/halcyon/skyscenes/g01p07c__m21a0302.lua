-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m21a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  GAME:WaitFrames(60)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's been a while since we've\nbeen in this room.", french="Ça faisait longtemps qu'on\nn'était pas venus dans cette chambre.", german="Wir waren lange nicht mehr in\ndiesem Zimmer.", italian="È passato molto tempo\ndall'ultima volta che abbiamo dormito in\nquesta stanza.", spanish="Hacía mucho tiempo que no\nestábamos en esta habitación."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's been so long since we've\nbeen in this room.", french="Ça faisait longtemps qu'on\nn'était pas venus dans cette chambre.", german="Es ist so lange her, dass wir in\ndiesem Zimmer waren.", italian="È passato molto tempo\ndall'ultima volta che abbiamo dormito in\nquesta stanza.", spanish="Hacía mucho tiempo que no\nestábamos en esta habitación."})
  else
  SkySceneKit.say({english="It's been a while since we've\nbeen in this room.", french="Ça faisait longtemps qu'on\nn'avait pas dormi dans cette chambre.", german="Wir waren lange nicht mehr in\ndiesem Zimmer.", italian="È passato molto tempo\ndall'ultima volta che abbiamo dormito in\nquesta stanza.", spanish="Hacía mucho tiempo que no\nestábamos en esta habitación."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It feels like I'm finally home.", french="J'ai l'impression d'être enfin\nchez moi.", german="Ich habe endlich das Gefühl, zu\nHause angekommen zu sein.", italian=" Finalmente mi sento a casa.", spanish=" Por fin me siento en casa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It feels as though I'm\nfinally home.", french="J'ai l'impression d'être enfin\nchez moi.", german="Ich habe endlich das Gefühl, zu\nHause angekommen zu sein.", italian=" Finalmente mi sento a casa.", spanish=" Por fin me siento en casa."})
  else
  SkySceneKit.say({english="It feels as though I'm\nfinally home.", french="J'ai l'impression d'être enfin\nchez moi.", german="Ich habe endlich das Gefühl, zu\nHause angekommen zu sein.", italian=" Finalmente mi sento a casa.", spanish=" Por fin me siento en casa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know...[K] I'm glad everyone\nbelieved our story.", french="Tu sais...[K] je suis soulagé que\ntout le monde nous ait crus.", german="Weißt du...[K] Ich bin froh, dass\nalle unsere Geschichte geglaubt haben.", italian="Sai,[K] sono contento che abbiano\ncreduto tutti alla nostra storia.", spanish="¿Sabes...?[K] Me alegro muchísimo\nde que todos hayan creído nuestra historia."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know...[K] I'm glad everyone\ncame to believe our story.", french="Tu sais...[K] je suis soulagé que\ntout le monde nous ait crus.", german="Weißt du...[K] Ich bin froh, dass\nalle unsere Geschichte glauben konnten.", italian="Sai,[K] sono contento che abbiano\ncreduto tutti alla nostra storia.", spanish="¿Sabes...?[K] Me alegro muchísimo\nde que todos hayan creído nuestra historia."})
  else
  SkySceneKit.say({english="You know...[K] I'm glad everyone\nbelieved our story.", french="Tu sais...[K] je suis soulagée que\ntout le monde ait fini par nous croire.", german="Weißt du...[K] Ich bin froh, dass\nalle unsere Geschichte geglaubt haben.", italian="Sai,[K] sono contenta che abbiano\ncreduto tutti alla nostra storia.", spanish="¿Sabes...?[K] Me alegro muchísimo\nde que todos hayan creído nuestra historia."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I got a little choked up!", french=" J'en avais les larmes aux yeux!", german="Ich hatte einen kleinen Kloß im\nHals!", italian=" Mi sono emozionato!", spanish=" ¡La verdad es que me emocioné!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It made me a little choked up!", french=" J'en avais les larmes aux yeux!", german="Ich hatte einen kleinen Kloß im\nHals!", italian=" Mi ha fatto un po' emozionare!", spanish=" ¡La verdad es que me emocioné!"})
  else
  SkySceneKit.say({english=" I got a little emotional over it!", french=" J'en avais les larmes aux yeux!", german="Ich bin fast ein bisschen\nsentimental geworden!", italian=" Mi sono un po' emozionata!", spanish=" ¡La verdad es que me emocioné!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We'll go meet [CS:N]Torkoal[CR] tomorrow\nand get some information.", french="Demain, on ira voir [CS:N]Chartor[CR]\npour en savoir plus.", german="Wir gehen morgen zu [CS:N]Qurtel[CR] und\nholen uns ein paar Informationen.", italian="Dobbiamo andare da [CS:N]Torkoal[CR]\nper ricevere qualche informazione.", spanish="Mañana iremos a ver a [CS:N]Torkoal[CR]\na ver si conseguimos información."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go meet [CS:N]Torkoal[CR] tomorrow\nand talk with him.", french="Demain, on ira voir [CS:N]Chartor[CR]\npour en savoir plus.", german="Lass uns morgen zu [CS:N]Qurtel[CR] gehen\nund ein paar Informationen von ihm besorgen.", italian="Dobbiamo andare da [CS:N]Torkoal[CR]\nper ricevere qualche informazione.", spanish="Mañana iremos a ver a [CS:N]Torkoal[CR]\na ver si conseguimos información."})
  else
  SkySceneKit.say({english="Let's go meet [CS:N]Torkoal[CR] tomorrow\nand talk with him.", french="Demain, on ira voir [CS:N]Chartor[CR]\npour en savoir plus.", german="Lass uns morgen zu [CS:N]Qurtel[CR] gehen\nund ein paar Informationen von ihm besorgen.", italian="Dobbiamo andare da [CS:N]Torkoal[CR]\nper ricevere qualche informazione.", spanish="Mañana iremos a ver a [CS:N]Torkoal[CR]\na ver si conseguimos información."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get back at it tomorrow,\n[hero]!", french="Demain, on s'y remet,\n[hero]!", german="Machen wir morgen weiter,\n[hero]!", italian="Ma ci penseremo domani,\n[hero]!", spanish="¡Volvamos mañana,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's get back at it tomorrow,\n[hero]!", french="Demain, on s'y remet,\n[hero]!", german="Machen wir morgen weiter,\n[hero]!", italian="Ma ci penseremo domani,\n[hero]!", spanish="Será mejor que volvamos\nmañana, [hero]."})
  else
  SkySceneKit.say({english="Let's get back at it tomorrow,\n[hero]!", french="Demain, on s'y remet,\n[hero]!", german="Machen wir morgen weiter,\n[hero]!", italian="Ma ci penseremo domani,\n[hero]!", spanish="Mejor será que volvamos\nmañana, [hero]."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  GAME:WaitFrames(30)
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
