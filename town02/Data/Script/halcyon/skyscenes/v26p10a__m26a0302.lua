-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V26P10A/m26a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_V26P10A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P10A1_351) [routine d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This place...[K] It's [CS:P]Treeshroud\nForest[CR].", french="Cet endroit...[K] c'est la [CS:P]Forêt\nLinceul[CR].", german="Dieser Ort...[K] Es ist das\n[CS:P]Schemengehölz[CR].", italian="Questo posto...[K] è la [CS:P]Foresta[CR]\n[CS:P]Arcana[CR].", spanish="Este lugar...[K] es el [CS:P]Bosque[CR]\n[CS:P]Enraizado[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="This...[K] It must be [CS:P]Treeshroud\nForest[CR].", french="Cet endroit...[K] c'est la [CS:P]Forêt\nLinceul[CR].", german="Dieser Ort...[K] Das muss das\n[CS:P]Schemengehölz[CR] sein.", italian="Questo posto...[K] è la [CS:P]Foresta[CR]\n[CS:P]Arcana[CR].", spanish="Este lugar...[K] es el [CS:P]Bosque[CR]\n[CS:P]Enraizado[CR]."})
  else
  SkySceneKit.say({english="This...[K] It must be [CS:P]Treeshroud\nForest[CR].", french="Cet endroit...[K] c'est la [CS:P]Forêt\nLinceul[CR].", german="Dieser Ort...[K] Das muss das\n[CS:P]Schemengehölz[CR] sein.", italian="Questo posto...[K] è la [CS:P]Foresta[CR]\n[CS:P]Arcana[CR].", spanish="Este lugar...[K] es el [CS:P]Bosque[CR]\n[CS:P]Enraizado[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(17) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V26P10A1_351) [routine d'objet NDS non simulée - documenté]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But it's different![K] When we\nwere in [CS:P]Treeshroud Forest[CR], time was stopped!", french="Mais elle a l'air différente![K]\nLa dernière fois qu'on s'y trouvait, le temps\ns'était arrêté!", german="Aber etwas ist anders![K] Als wir\nim [CS:P]Schemengehölz[CR] waren, stand die Zeit still!", italian="Ma è diversa![K] Quando eravamo\nnella [CS:P]Foresta Arcana[CR], il tempo era fermo!", spanish="Pero, ¡ha cambiado!...[K] Cuando\nestuvimos en el [CS:P]Bosque Enraizado[CR], el tiempo\nse había detenido."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But it's not the same![K] When we\nwere in [CS:P]Treeshroud Forest[CR], time was stopped!", french="Mais elle a l'air différente![K]\nLa dernière fois qu'on s'y trouvait, le temps\ns'était arrêté!", german="Aber es ist nicht das Gleiche![K]\nAls wir im [CS:P]Schemengehölz[CR] waren, stand die\nZeit still!", italian="Ma è diversa![K] Quando eravamo\nnella [CS:P]Foresta Arcana[CR], il tempo era fermo!", spanish="Pero, ¡ha cambiado!...[K] Cuando\nestuvimos en el [CS:P]Bosque Enraizado[CR], el tiempo\nse había detenido."})
  else
  SkySceneKit.say({english="But it's not the same![K] When we\nwere in [CS:P]Treeshroud Forest[CR], time was stopped!", french="Mais elle a l'air différente![K]\nLa dernière fois qu'on s'y trouvait, le temps\ns'était arrêté!", german="Aber es ist nicht das Gleiche![K]\nAls wir im [CS:P]Schemengehölz[CR] waren, stand die\nZeit still!", italian="Ma è diversa![K] Quando eravamo\nnella [CS:P]Foresta Arcana[CR], il tempo era fermo!", spanish="Pero, ¡ha cambiado!...[K] Cuando\nestuvimos en el [CS:P]Bosque Enraizado[CR], el tiempo\nse había detenido."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Time is...[K] Time is moving again!", french="Le temps...[K] le temps a repris\nson cours!", german="Die Zeit...[K] Sie geht wieder ihren\nnormalen Gang!", italian="Il tempo...[K] è tornato a\nscorrere!", spanish="El tiempo...[K] ¡El tiempo ha vuelto\na fluir!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Time is...[K] Time is moving again!", french="Le temps...[K] le temps a repris\nson cours!", german="Die Zeit...[K] Sie geht wieder ihren\nnormalen Gang!", italian="Il tempo...[K] è tornato a\nscorrere!", spanish="El tiempo...[K] ¡El tiempo ha vuelto\na fluir!"})
  else
  SkySceneKit.say({english=" Time is...[K] Time is moving again!", french="Le temps...[K] le temps a repris\nson cours!", german="Die Zeit...[K] Sie geht wieder ihren\nnormalen Gang!", italian="Il tempo...[K] è tornato a\nscorrere!", spanish="El tiempo...[K] ¡El tiempo ha vuelto\na fluir!"})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
end
