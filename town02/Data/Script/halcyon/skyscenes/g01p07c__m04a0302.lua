-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m04a0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 80, 184, Direction.Right, "NPC_DOGOOMU")
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "angry", 1) end)
  -- SetAnimation(9) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Grrr...", french=" Grrr...", german=" Grrr...", italian=" Grrr...", spanish=" Grrr..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Will you let it go already?", french=" Tu veux bien arrêter?", german=" Lass es endlich gut sein!", italian=" La vuoi smettere?", spanish=" ¿Quieres dejarlo ya?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you stop that already?", french=" Tu veux bien arrêter?", german="Kannst du endlich damit\naufhören?", italian=" La vuoi smettere?", spanish=" ¿Quieres parar de una vez?"})
  else
  SkySceneKit.say({english=" Can you let it go, please?", french=" Tu veux bien arrêter?", german="Kannst du bitte endlich damit\naufhören?", italian=" La vuoi smettere, per favore?", spanish=" ¿Quieres dejarlo ya?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We're going to bed too...", french="Nous aussi, allons nous\ncoucher...", german=" Wir gehen auch ins Bett.", italian=" Andiamo anche noi a letto...", spanish="Pues también nos vamos\na la cama."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We're going to bed too...", french="Nous aussi, allons nous\ncoucher...", german=" Wir gehen auch ins Bett.", italian=" Andiamo anche noi a letto...", spanish="Pues también nos vamos\na la cama."})
  else
  SkySceneKit.say({english=" We're going to bed too...", french="Nous aussi, allons nous\ncoucher...", german=" Wir gehen auch ins Bett.", italian=" Andiamo anche noi a letto...", spanish="Pues también nos vamos\na la cama."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I mean, I can understand how\nyou'd be steamed at us, but...", french="Oui, tu as le droit d'être en\ncolère contre nous, mais bon...", german="Ich meine, ich kann verstehen,\ndass du sauer auf uns bist, aber...", italian="Insomma, posso capire che tu\nsia arrabbiato con noi, ma...", spanish="Entiendo que tengas motivos\npara estar enfadado, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, you have the right to be\nangry with us, but...", french="Oui, tu as le droit d'être en\ncolère contre nous, mais bon...", german="Ja, du hast das Recht, wütend\nauf uns zu sein, aber...", italian="Insomma, posso capire che tu\nsia arrabbiato con noi, ma...", spanish="Tienes motivos para\nestar enfadado, pero..."})
  else
  SkySceneKit.say({english="Yes, you have the right to be\nangry with us, but...", french="Oui, tu as le droit d'être en\ncolère contre nous, mais bon...", german="Ja, du hast das Recht, wütend\nauf uns zu sein, aber...", italian="Insomma, posso capire che tu\nsia arrabbiato con noi, ma...", spanish="Comprendo que estés\nenfadado, pero..."})
  end
  -- message_Close
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
