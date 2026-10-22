-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P01A/m17a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_P05P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(9) [anim idle native]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 208, 232, Direction.Up, "NPC_YONOWAARU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I am sorry to have kept you\nwaiting, Master [CS:N]Dialga[CR]...", french="Navré de vous avoir fait\nattendre, Maître [CS:N]Dialga[CR]...", german="Verzeihung, dass ich dich\nwarten ließ, Meister [CS:N]Dialga[CR]...", italian="Spiacente di averti fatto\nattendere, Grande [CS:N]Dialga[CR]...", spanish="Siento haberle hecho esperar,\npoderoso [CS:N]Dialga[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="While I encountered more\ndifficulty than anticipated...", french="Bien qu'ayant rencontré\ndavantage de difficultés que je ne l'avais\nescompté...", german="Ich hatte zwar mit mehr\nSchwierigkeiten als erwartet zu kämpfen...", italian="È vero, ho trovato maggiori\ndifficoltà rispetto a quello che avevo\nprevisto...", spanish="Aunque me he encontrado\ncon más problemas de los esperados..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I finally succeeded...[K] In the\ncapture, yes.", french="... j'ai néanmoins fini par\nréussir...[K] à capturer le traître.", german="Doch letztendlich gelang es\nmir,[K] sie zu fassen, ja.", italian="Tuttavia, la caccia...[K] ha\nfinalmente dato i suoi frutti.", spanish="He cumplido la misión.[K]\nLa captura ha sido un éxito."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7186) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(3) [anim idle native]
  SkySceneKit.say({english="GRRRRRRRRR...", french="GRRRRRRRRR...", german="GRRRRRRRRR...", italian="GRRRRRRRRR...", spanish="GRRRRRRRRR..."}) -- message_ImitationSound (onomatopée)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="...[K]I fully understand what must\nbe done.", french="...[K] Je comprends tout à fait\nce qu'il faut faire.", german="...[K]Mir ist völlig klar, was getan\nwerden muss.", italian=" ...[K] Capisco perfettamente.", spanish="Entiendo...[K] Comprendo lo que\ndebemos hacer ahora."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Those who seek to alter the\ncourse of history...[K]must be removed from\nhistory.", french="Ceux qui cherchent à altérer\nle cours de l'histoire...[K] doivent être supprimés\nde l'histoire.", german="Wer den Verlauf der Geschichte\nverändern will,[K] muss aus der Geschichte\ngetilgt werden.", italian="Coloro che cercano di cambiare\nil corso della storia...[K] devono essere\ncancellati dalla storia.", spanish="Aquellos que buscan alterar\nel curso de la historia...[K] deben ser eliminados."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I will see to the elimination\nimmediately.", french="Je m'en vais procéder\nà l'exécution.", german="Ich werde das sofort in Angriff\nnehmen.", italian="Mi occuperò di questo\nimmediatamente.", spanish="Me haré cargo de ello\ninmediatamente."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="GRRRRRRRRR...", french="GRRRRRRRRR...", german="GRRRRRRRRR...", italian="GRRRRRRRRR...", spanish="GRRRRRRRRR..."}) -- message_ImitationSound (onomatopée)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...I understand.[K] As you wish.", french="... J'entends bien.[K] Il en sera\nfait selon votre souhait.", german="...Ich verstehe.[K] Wie du\nwünschst.", italian=" D'accordo.[K] Come desideri.", spanish=" Entiendo.[K] Como desee."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I take my leave.", french="Avec votre permission, je prends\ncongé.", german=" Entschuldige mich.", italian=" Vado.", spanish=" Ahora me retiro."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7186, 120) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(120)
  SkySceneKit.cleanup_npcs()
end
