-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P05P01A/m19a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_P05P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  -- SetAnimation(9) [anim idle native]
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 208, 232, Direction.Up, "NPC_YONOWAARU")
  -- SetOutputAttribute(8) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
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
  SkySceneKit.say({english=" Master [CS:N]Dialga[CR].", french=" Maître [CS:N]Dialga[CR].", german=" Meister [CS:N]Dialga[CR].", italian=" Grande [CS:N]Dialga[CR].", spanish=" Poderoso [CS:N]Dialga[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The stage has been set for the\ncapture of the traitors.", french="Tout est fin prêt pour la capture\ndes scélérats.", german="Das Feld wurde für die\nErgreifung der Verräter vorbereitet.", italian="È tutto pronto per la cattura\ndei traditori.", spanish="Todo está preparado para\nla captura de los traidores."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" When the time comes...", french=" Lorsque viendra l'heure...", german=" Wenn die Zeit gekommen ist...", italian=" Quando verrà il momento...", spanish=" Cuando llegue el momento..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It may be necessary for us to\nbeg your help, Master [CS:N]Dialga[CR]...", french="... il se peut que nous soyons\namenés à solliciter votre aide, Maître [CS:N]Dialga[CR]...", german="Dann werden wir vielleicht um\ndeine Hilfe bitten müssen, Meister [CS:N]Dialga[CR]...", italian="... può darsi che dovremo\nchiedere il tuo aiuto, Grande [CS:N]Dialga[CR]...", spanish="Puede que sea necesario que\nle roguemos su ayuda, poderoso [CS:N]Dialga[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.say({english="GRRRRRRRRR...", french="GRRRRRRRRR...", german="GRRRRRRRRR...", italian="GRRRRRRRRR...", spanish="GRRRRRRRRR..."}) -- message_ImitationSound (onomatopée)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ...[K]As you wish.", french="... [K]Il en sera fait selon vos\ndésirs.", german=" ...[K]Wie du wünschst.", italian=" ...[K] Come desideri.", spanish=" Pues...[K] Como desee."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" By your leave, we shall proceed.", french="Avec votre permission,\nnous allons poursuivre l'opération.", german="Mit deiner Erlaubnis werden\nwir fortschreiten.", italian="Col tuo permesso, possiamo\nprocedere.", spanish="Si tenemos su beneplácito,\nseguiremos adelante con el plan."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- se_FadeOut(7186, 60) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  -- SetAnimation(21) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_P05P01A1_134) [routine d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:FadeOutBGM(180) end)
  GAME:WaitFrames(45)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(90)
  SkySceneKit.cleanup_npcs()
end
