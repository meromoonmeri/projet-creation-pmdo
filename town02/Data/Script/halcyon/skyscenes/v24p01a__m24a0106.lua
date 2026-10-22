-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V24P01A/m24a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V24P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 208, 176, Direction.UpLeft, "NPC_JUPUTORU")
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, I see...", french=" Oh, je vois...", german=" Oh, ich verstehe...", italian=" Oh, capisco...", spanish=" Ah, ya entiendo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, I see...", french=" Oh, je vois...", german=" Oh, ich verstehe...", italian=" Oh, capisco...", spanish=" Ah, ya entiendo..."})
  else
  SkySceneKit.say({english=" Oh, I see...", french=" Oh, je vois...", german=" Oh, ich verstehe...", italian=" Oh, capisco...", spanish=" Ah, ya entiendo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That's how you met [CS:N]Wigglytuff[CR],\n[CS:N]Lapras[CR]?", french="C'est comme ça que tu as connu\n[CS:N]Grodoudou[CR], [CS:N]Lokhlass[CR]?", german="So hast du also [CS:N]Knuddeluff[CR]\nkennengelernt, [CS:N]Lapras[CR]?", italian="È così che hai conosciuto\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?", spanish="¿Así es como conociste a\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That's how you met [CS:N]Wigglytuff[CR],\n[CS:N]Lapras[CR]?", french="C'est comme ça que tu as connu\n[CS:N]Grodoudou[CR], [CS:N]Lokhlass[CR]?", german="So hast du also [CS:N]Knuddeluff[CR]\nkennengelernt, [CS:N]Lapras[CR]?", italian="È così che hai conosciuto\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?", spanish="¿Así es como conociste a\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?"})
  else
  SkySceneKit.say({english="That's how you met [CS:N]Wigglytuff[CR],\n[CS:N]Lapras[CR]?", french="C'est comme ça que tu as connu\n[CS:N]Grodoudou[CR], [CS:N]Lokhlass[CR]?", german="So hast du also [CS:N]Knuddeluff[CR]\nkennengelernt, [CS:N]Lapras[CR]?", italian="È così che hai conosciuto\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?", spanish="¿Así es como conociste a\n[CS:N]Wigglytuff[CR], [CS:N]Lapras[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Yes.[K] I didn't intend to reveal\nmyself at all...", french="C'est bien ça.[K] Au début,\nje n'avais pas du tout prévu de me montrer...", german="Ja.[K] Ich hatte überhaupt nicht\nvorgehabt, mich zu erkennen zu geben.", italian="Sì.[K] Non avevo nessuna\nintenzione di mostrarmi...", spanish="Así es.[K] No pensaba dejarme\nver..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="But I changed my mind the\ninstant I saw [CS:N]Chatot[CR] on the ground.", french="Mais j'ai changé d'avis dès que\nj'ai vu [CS:N]Pijako[CR] à terre.", german="Aber ich änderte meine Meinung\nin der Sekunde, als ich [CS:N]Plaudagei[CR] auf dem\nBoden liegen sah.", italian="Ma appena ho visto [CS:N]Chatot[CR] a\nterra ho cambiato idea.", spanish="Pero cambié de opinión en\ncuanto vi a [CS:N]Chatot[CR] en el suelo."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" I simply had to help.", french=" Il fallait que j'intervienne.", german=" Ich musste einfach helfen.", italian=" Dovevo aiutarlo.", spanish=" Tenía que ayudarles."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Afterward...", french=" Par la suite...", german=" Später...", italian=" In seguito...", spanish=" Después de eso..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="I made [CS:N]Wigglytuff[CR] promise me\nsomething.", french="... j'ai conclu un pacte avec\n[CS:N]Grodoudou[CR].", german="Später rang ich [CS:N]Knuddeluff[CR] ein\nVersprechen ab.", italian="... ho stretto un patto con\n[CS:N]Wigglytuff[CR].", spanish="Le pedí a [CS:N]Wigglytuff[CR] que me\nhiciera una promesa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A promise?", french=" Un pacte?", german=" Ein Versprechen?", italian=" Un patto?", spanish=" ¿Una promesa?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A promise?", french=" Un pacte?", german=" Ein Versprechen?", italian=" Un patto?", spanish=" ¿Una promesa?"})
  else
  SkySceneKit.say({english=" A promise?", french=" Un pacte?", german=" Ein Versprechen?", italian=" Un patto?", spanish=" ¿Una promesa?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Lapras", true, "lapras", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_RAPURASU) voix hors champ (espèce ROM)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Yes.", french=" Oui.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  SkySceneKit.cleanup_npcs()
end
