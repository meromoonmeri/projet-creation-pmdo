-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99E/s21p0203.ssb (ROM sha256 1fa39d35…).
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
  SkySceneKit.say({english="I didn't give up when we were\ntrying to escape from the future.", french="Je n'ai pas baissé les bras quand\nnous avons essayé de nous échapper du futur.", german="Ich habe nicht aufgegeben, als\nwir versuchten, aus der Zukunft zu fliehen.", italian="Non mi sono arreso quando\nstavamo cercando di scappare dal futuro.", spanish="No desistí cuando estábamos\nintentando escapar del futuro."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I didn't give up when we were\ntrying to escape from the future.", french="Je n'ai pas baissé les bras quand\nnous avons essayé de nous échapper du futur.", german="Ich habe nicht aufgegeben, als\nwir versuchten, aus der Zukunft zu fliehen.", italian="Non mi sono arreso quando\nstavamo cercando di scappare dal futuro.", spanish="No desistí cuando estábamos\nintentando escapar del futuro."})
  else
  SkySceneKit.say({english="I didn't give up when we were\ntrying to escape from the future.", french="Je n'ai pas baissé les bras quand\nnous avons essayé de nous échapper du futur.", german="Ich habe nicht aufgegeben, als\nwir versuchten, aus der Zukunft zu fliehen.", italian="Non mi sono arresa quando\nstavamo cercando di scappare dal futuro.", spanish="No desistí cuando estábamos\nintentando escapar del futuro."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess [CS:N]Grovyle[CR] thought that\nwas strange.", french=" [CS:N]Massko[CR] a trouvé ça étrange.", german="[CS:N]Reptain[CR] fand das vermutlich\nseltsam.", italian="Immagino che [CS:N]Grovyle[CR] abbia\npensato che fosse strano.", spanish="Supongo que a [CS:N]Grovyle[CR] le\npareció extraño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I guess that struck [CS:N]Grovyle[CR] as\nbeing strange.", french=" [CS:N]Massko[CR] a trouvé ça étrange.", german="Das muss [CS:N]Reptain[CR] als seltsam\nerachtet haben.", italian="Immagino che [CS:N]Grovyle[CR] abbia\npensato che fosse strano.", spanish="Supongo que a [CS:N]Grovyle[CR] le\nextrañó."})
  else
  SkySceneKit.say({english="I guess [CS:N]Grovyle[CR] thought that\nwas strange.", french=" [CS:N]Massko[CR] a trouvé ça étrange.", german="[CS:N]Reptain[CR] fand das vermutlich\nseltsam.", italian="Immagino che [CS:N]Grovyle[CR] abbia\npensato che fosse strano.", spanish="Supongo que a [CS:N]Grovyle[CR] le\npareció extraño."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's why [CS:N]Grovyle[CR] asked me\nwhy I wouldn't give up...", french="C'est pour ça qu'il m'a demandé\npourquoi je ne baissais pas les bras...", german="Darum fragte mich [CS:N]Reptain[CR] wohl,\nwarum ich nicht aufgeben wollte...", italian="È per questo che [CS:N]Grovyle[CR] mi\nha chiesto perché non ho ceduto.", spanish="Y por eso me preguntó por qué\nme negué a rendirme..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's why [CS:N]Grovyle[CR] asked me\nwhy I refused to give up...", french="C'est pour ça qu'il m'a demandé\npourquoi je ne baissais pas les bras...", german="Darum fragte mich [CS:N]Reptain[CR] wohl,\nwarum ich mich weigerte aufzugeben...", italian="È per questo che [CS:N]Grovyle[CR] mi\nha chiesto perché non ho ceduto.", spanish="Y por eso me preguntó por qué\nme negué a rendirme..."})
  else
  SkySceneKit.say({english="That's why [CS:N]Grovyle[CR] asked me\nwhy I wouldn't give up...", french="C'est pour ça qu'il m'a demandé\npourquoi je ne baissais pas les bras...", german="Darum fragte mich [CS:N]Reptain[CR] wohl,\nwarum ich nicht aufgeben wollte...", italian="È per questo che [CS:N]Grovyle[CR] mi\nha chiesto perché non ho ceduto.", spanish="Y por eso me preguntó por qué\nme negué a rendirme..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I didn't have an answer.\nI didn't know why I was brave then.", french="Mais je n'avais pas de réponse.\nJe ne savais pas pourquoi.", german="Aber ich hatte keine Antwort.\nIch wusste nicht, warum ich damals so tapfer\nwar.", italian="Ma non sapevo cosa rispondere.\nNon so come ho fatto ad essere così\ncoraggioso.", spanish="Pero no supe responderle.\nNo sabía por qué fui tan valiente."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I didn't know how to answer.\nI didn't know why I was brave then.", french="Mais je n'avais pas de réponse.\nJe ne savais pas pourquoi.", german="Aber ich hatte keine Antwort.\nIch wusste nicht, warum ich damals so mutig\nwar.", italian="Ma non sapevo cosa rispondere.\nNon so come ho fatto ad essere così\ncoraggioso.", spanish="Pero no supe responderle.\nNo sabía por qué fui tan valiente."})
  else
  SkySceneKit.say({english="But I didn't know how to answer.\nI didn't know how I managed to stay brave.", french="Mais je n'avais pas de réponse.\nJe ne savais pas pourquoi.", german="Aber ich hatte keine Antwort.\nIch wusste nicht, warum ich damals so tapfer\nbleiben konnte.", italian="Ma non sapevo cosa rispondere.\nNon so come ho fatto ad essere così\ncoraggiosa.", spanish="Pero no supe responderle.\nNo sabía por qué fui tan valiente."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I thought about it, and I\nbegan to understand something...", french="J'y ai réfléchi et j'ai commencé\nà comprendre quelque chose...", german="Aber ich habe darüber\nnachgedacht und begann zu verstehen...", italian="Ma pensandoci, ho iniziato\na capire qualcosa...", spanish="Pero, al pensar en ello, empecé\na comprender..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I thought about it, and I\nbegan to realize something...", french="J'y ai réfléchi et j'ai commencé\nà comprendre quelque chose...", german="Aber ich habe darüber\nnachgedacht und begann zu verstehen...", italian="Ma pensandoci, ho iniziato\na capire qualcosa...", spanish="Pero, al pensar en ello, empecé\na comprender..."})
  else
  SkySceneKit.say({english="But I thought about it, and I\nbegan to realize something...", french="J'y ai réfléchi et j'ai commencé\nà comprendre quelque chose...", german="Aber ich habe darüber\nnachgedacht und begann zu verstehen...", italian="Ma pensandoci, ho iniziato\na capire qualcosa...", spanish="Pero, al pensar en ello, empecé\na comprender..."})
  end
  -- message_Close
  -- bgm2_ChangeVolume(140, 0) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
