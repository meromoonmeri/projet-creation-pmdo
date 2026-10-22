-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D28P33A/m25a0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D28P33A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  GROUND:MoveToPosition(partner, 368, 200, false, 2) -- Slide2PositionMark (glissement)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(partner, 328, 200, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Here it is.[K] It's this hollow spot.", french=" La voilà.[K] La cavité.", german="Hier ist es.[K] Hier ist die hohle\nStelle.", italian=" Ci sono.[K] È la cavità.", spanish=" Aquí está.[K] Este es el hueco."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Here it is.[K] It's this hollow spot.", french=" La voilà.[K] La cavité.", german="Hier ist es.[K] Hier ist die hohle\nStelle.", italian=" Ci sono.[K] È la cavità.", spanish=" Aquí está.[K] Este es el hueco."})
  else
  SkySceneKit.say({english=" Here it is.[K] It's this hollow spot.", french=" La voilà.[K] La cavité.", german="Hier ist es.[K] Hier ist die hohle\nStelle.", italian=" Ci sono.[K] È la cavità.", spanish=" Aquí está.[K] Este es el hueco."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The Relic Fragment is supposed\nto go into this spot.", french="On est censé placer le\nFragment de Relique dans le creux.", german="Das Reliktfragment gehört an\ndiese Stelle.", italian="Il Frammento Antico deve\nessere inserito nell'incavatura.", spanish="La Reliquia de Piedra tiene que\nencajar aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The Relic Fragment is supposed\nto go into this spot.", french="On est censé placer le\nFragment de Relique dans le creux.", german="Das Reliktfragment gehört an\ndiese Stelle.", italian="Il Frammento Antico deve\nessere inserito nell'incavatura.", spanish="La Reliquia de Piedra tiene que\nencajar aquí."})
  else
  SkySceneKit.say({english="The Relic Fragment is supposed\nto go into this spot.", french="On est censé placer le\nFragment de Relique dans le creux.", german="Das Reliktfragment gehört an\ndiese Stelle.", italian="Il Frammento Antico deve\nessere inserito nell'incavatura.", spanish="La Reliquia de Piedra tiene que\nencajar aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That'll activate the Rainbow\nStoneship, [CS:N]Grovyle[CR] said...[K] Might as well try it.", french="D'après [CS:N]Massko[CR], ça activera\nle Vaisseau Arc-en-Ciel...[K] Ça vaut le coup\nd'essayer.", german="Das wird das\nRegenbogen-Steinschiff starten, wie [CS:N]Reptain[CR] es\nsagte...[K] Ich probiere es einfach mal.", italian="Come ha detto [CS:N]Grovyle[CR], questo\ndovrebbe attivare il Vascello Arcobaleno...[K]\nPotrei fare una prova.", spanish="Según [CS:N]Grovyle[CR], eso activará\nla Barca Arcoiris...[K] Veamos si es verdad."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That will activate the Rainbow\nStoneship, [CS:N]Grovyle[CR] said...[K] It's worth a try.", french="D'après [CS:N]Massko[CR], ça activera\nle Vaisseau Arc-en-Ciel...[K] Ça vaut le coup\nd'essayer.", german="Das wird das\nRegenbogen-Steinschiff starten, wie [CS:N]Reptain[CR] es\nsagte...[K] Ein Versuch kann nicht schaden.", italian="Come ha detto [CS:N]Grovyle[CR], questo\ndovrebbe attivare il Vascello Arcobaleno...[K]\nVale la pena di fare un tentativo.", spanish="Según [CS:N]Grovyle[CR], eso activará\nla Barca Arcoiris...[K] Habrá que comprobarlo."})
  else
  SkySceneKit.say({english="That will activate the Rainbow\nStoneship, [CS:N]Grovyle[CR] said...[K] Let's try it.", french="D'après [CS:N]Massko[CR], ça activera\nle Vaisseau Arc-en-Ciel...[K] Ça vaut le coup\nd'essayer.", german="Das wird das\nRegenbogen-Steinschiff starten, wie [CS:N]Reptain[CR] es\nsagte...[K] Ein Versuch kann nicht schaden.", italian="Come ha detto [CS:N]Grovyle[CR], questo\ndovrebbe attivare il Vascello Arcobaleno...[K]\nVale la pena di fare un tentativo.", spanish="Según [CS:N]Grovyle[CR], eso activará\nla Barca Arcoiris...[K] A ver si es verdad."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-16), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(6671) — id SE NDS sans portage PMDO identifié
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN][partner] placed the Relic\n[CN]Fragment in the hollow spot.", french="[CN][partner] place le Fragment\n[CN]de Relique dans la cavité.", german="[CN][partner] setzt das Reliktfragment\n[CN]in die hohle Stelle ein.", italian="[CN][partner] posiziona il Frammento\n[CN]Antico nell'incavatura.", spanish="[CN][partner] colocó en el hueco\n[CN]la Reliquia de Piedra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7445) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(60)
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:WaitFrames(60)
  GAME:FadeIn(15)
  -- GAP: BGM BGM_ANOTHER_GLOWING_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(16), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! It moved![K] It moved!", french=" Ouah! Ça a bougé![K] Ça a bougé!", german="Huah! Es hat sich bewegt![K] Es hat\nsich bewegt!", italian=" Wow! Si è mosso![K] Si è mosso!", spanish="¡Vaya! ¡Se ha movido![K]\n¡Se ha movido!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah! It moved![K] It moved!", french=" Ouah! Ça a bougé![K] Ça a bougé!", german="Waah! Es hat sich bewegt![K] Es\nhat sich bewegt!", italian=" Aaah! Si è mosso![K] Si è mosso!", spanish="¡Vaya! ¡Se ha movido![K]\n¡Se ha movido!"})
  else
  SkySceneKit.say({english=" Waah! It moved![K] It moved!", french=" Ouah! Ça a bougé![K] Ça a bougé!", german="Waah! Es hat sich bewegt![K] Es\nhat sich bewegt!", italian=" Aaah! Si è mosso![K] Si è mosso!", spanish="¡Vaya! ¡Se ha movido![K]\n¡Se ha movido!"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
