-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P03P02A/m09a0606.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_P03P02A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- bgm2_PlayFadeIn(BGM_RAIN2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  SkySubScreen.Show("v24p08a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 424, 544, Direction.Down, "NPC_HEIGANI")
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! The fog is gone!", french="Eh dis donc! Le brouillard\na disparu!", german=" Hey, hey! Der Nebel ist weg!", italian=" Ehi, ehi! La nebbia è sparita!", spanish="¡Oye, oye! ¡La niebla ha\ndesaparecido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The sky cleared...", french=" Le ciel est dégagé...", german=" Der Himmel hat aufgeklart...", italian=" Il cielo, si vede il cielo...!", spanish=" El cielo se ha despejado."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The sky cleared...", french=" Le ciel est dégagé...", german=" Der Himmel hat aufgeklart...", italian=" Il cielo, si vede il cielo...!", spanish=" El cielo se ha despejado."})
  else
  SkySceneKit.say({english=" The sky cleared...", french=" Le ciel est dégagé...", german=" Der Himmel hat aufgeklart...", italian=" Il cielo, si vede il cielo...!", spanish=" El cielo se ha despejado."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The sunlight's harsh!", french=" Le soleil brille fort!", german=" Das Sonnenlicht blendet richtig!", italian=" La luce del sole è abbagliante!", spanish=" El sol brilla con fuerza."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The sunlight's harsh!", french=" Le soleil brille fort!", german=" Das Sonnenlicht blendet richtig!", italian=" La luce del sole è abbagliante!", spanish=" El sol brilla con fuerza."})
  else
  SkySceneKit.say({english=" The sunlight's harsh!", french=" Le soleil brille fort!", german=" Das Sonnenlicht blendet richtig!", italian=" La luce del sole è abbagliante!", spanish=" El sol brilla con fuerza."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(73) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(45)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! Look!", french=" Hé! Regardez!", german=" Hey! Sieh nur!", italian=" Ehi! Guardate!", spanish=" ¡Vaya! ¡Mirad!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! Look!", french=" Hé! Regardez!", german=" Hey! Sieh nur!", italian=" Ehi! Guardate!", spanish=" ¡Vaya! ¡Mirad!"})
  else
  SkySceneKit.say({english=" Hey! Look!", french=" Hé! Regardez!", german=" Hey! Sieh nur!", italian=" Ehi! Guardate!", spanish=" ¡Vaya! ¡Mirad!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.UpRight)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(30)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" B-both of you![K] Up! Look up!", french="Vous deux![K] En l'air! Regardez\nen l'air!", german=" I-ihr beide![K] Da oben! Seht!", italian="Voi due![K] In alto!\nGuardate in alto!", spanish=" ¡Los dos![K] ¡Mirad allí arriba!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" B-both of you![K] Up! Look up!", french="Vous deux![K] En l'air! Regardez\nen l'air!", german=" I-ihr beide![K] Da oben! Seht!", italian="Voi due![K] In alto!\nGuardate in alto!", spanish=" ¡Los dos![K] ¡Mirad allí arriba!"})
  else
  SkySceneKit.say({english=" B-both of you![K] Up! Look up!", french="Vous deux![K] En l'air! Regardez\nen l'air!", german=" I-ihr beide![K] Da oben! Seht!", italian="Voi due![K] In alto!\nGuardate in alto!", spanish=" ¡Los dos![K] ¡Mirad allí arriba!"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(5)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(5)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! What is that?!", french="Eh dis donc! Qu'est-ce que\nc'est?!", german=" Hey, hey! Was ist das?!?", italian=" Ehi, ehi! Cos'è?!", spanish=" ¡Oye, oye! ¡¿Qué es eso?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(15)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That's what the fog was hiding.", french="Voilà, c'était donc ça que\ncachait le brouillard.", german="Das ist, was der Nebel\nverborgen hat.", italian=" Ecco cosa nascondeva la nebbia.", spanish=" Eso es lo que ocultaba la niebla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That's what the fog was hiding.", french="Voilà, c'était donc ça que\ncachait le brouillard.", german="Das ist, was der Nebel\nverborgen hat.", italian=" Ecco cosa nascondeva la nebbia.", spanish=" Eso es lo que ocultaba la niebla."})
  else
  SkySceneKit.say({english=" That's what the fog was hiding.", french="Voilà, c'était donc ça que\ncachait le brouillard.", german="Das ist, was der Nebel\nverborgen hat.", italian=" Ecco cosa nascondeva la nebbia.", spanish=" Eso es lo que ocultaba la niebla."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No wonder no one could ever\nfind [CS:P]Fogbound Lake[CR].", french="Pas étonnant que personne n'ait\njamais découvert le [CS:P]Lac des Brumes[CR].", german="Kein Wunder, dass den [CS:P]Nebelsee[CR]\nniemand finden konnte.", italian="Ecco perché nessuno era mai\nriuscito a trovare il [CS:P]Lago Foschia[CR].", spanish="No me extraña que nadie pudiera\nencontrar el [CS:P]Lago Velado[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's no wonder [CS:P]Fogbound Lake[CR]\nevaded discovery for all this time.", french="Pas étonnant que personne n'ait\njamais découvert le [CS:P]Lac des Brumes[CR].", german="Kein Wunder, dass der [CS:P]Nebelsee[CR]\nbis jetzt unentdeckt geblieben ist.", italian="Ecco perché nessuno era mai\nriuscito a trovare il [CS:P]Lago Foschia[CR].", spanish="No me extraña que nadie pudiera\nencontrar el [CS:P]Lago Velado[CR]."})
  else
  SkySceneKit.say({english="It's no wonder that no one ever\ndiscovered [CS:P]Fogbound Lake[CR].", french="Pas étonnant que personne n'ait\njamais découvert le [CS:P]Lac des Brumes[CR].", german="Kein Wunder, dass den [CS:P]Nebelsee[CR]\nniemand entdeckt hat.", italian="Ecco perché nessuno era mai\nriuscito a trovare il [CS:P]Lago Foschia[CR].", spanish="No me extraña que nadie pudiera\nencontrar el [CS:P]Lago Velado[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We were just wandering around\nin circles ourselves.", french="Même nous, nous avons tourné\nen rond pendant pas mal de temps.", german="Wir sind selbst gerade die ganze\nZeit im Kreis gelaufen.", italian="Anche noi ci stavamo\ngirando attorno.", spanish="No hemos hecho otra cosa que\nandar en círculo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We were just wandering around\nin circles too.", french="Même nous, nous avons tourné\nen rond pendant pas mal de temps.", german="Wir sind selbst auch die ganze\nZeit im Kreis gelaufen.", italian="Anche noi ci stavamo\ngirando attorno.", spanish="No hemos hecho otra cosa que\nandar en círculo."})
  else
  SkySceneKit.say({english="We were just wandering around\nin circles ourselves.", french="Même nous, nous avons tourné\nen rond pendant pas mal de temps.", german="Wir sind selbst gerade die ganze\nZeit im Kreis gelaufen.", italian="Anche noi ci stavamo\ngirando attorno.", spanish="No hemos hecho otra cosa que\nandar en círculo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey! So you're saying...", french="Eh dis donc! Tu es en train\nde nous dire...", german=" Hey, hey! Du meinst also...", italian=" Ehi, ehi! Quindi stai dicendo...", spanish=" ¡Oye, oye! ¿Quieres decir que...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="You're saying [CS:P]Fogbound Lake[CR] is\nup there? Hey, hey, hey?!", french="... que le [CS:P]Lac des Brumes[CR]\nest là-haut? Dis donc!", german="Du meinst, dass der [CS:P]Nebelsee[CR]\nda oben ist? Hey, hey, hey?!?", italian="Stai dicendo che quello lassù\nè il [CS:P]Lago Foschia[CR]?\nEhi, ehi, ehi?!", spanish="¿Estás diciendo que el [CS:P]Lago[CR]\n[CS:P]Velado[CR] está allí arriba?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yes, that's what I think.", french=" Oui, c'est ce que je pense.", german=" Ja, das meine ich.", italian=" Sì, penso proprio di sì.", spanish=" Sí, eso es lo que creo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Yes. That's what I think.", french=" Oui, c'est ce que je pense.", german=" Ja, das meine ich.", italian=" Sì, penso proprio di sì.", spanish=" Sí, eso es lo que creo."})
  else
  SkySceneKit.say({english=" Yes. That's what I think.", french=" Oui, c'est ce que je pense.", german=" Ja, das meine ich.", italian=" Sì, penso proprio di sì.", spanish=" Sí, eso es lo que creo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:P]Fogbound Lake[CR] has to be\nup there!", french="Le [CS:P]Lac des Brumes[CR] doit être\nlà-haut!", german=" Der [CS:P]Nebelsee[CR] muss da oben sein!", italian="Il [CS:P]Lago Foschia[CR] dev'essere\nlassù!", spanish="¡El [CS:P]Lago Velado[CR] tiene que estar\nallí arriba!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:P]Fogbound Lake[CR] has to be\nup there!", french="Le [CS:P]Lac des Brumes[CR] doit être\nlà-haut!", german=" Der [CS:P]Nebelsee[CR] muss da oben sein!", italian="Il [CS:P]Lago Foschia[CR] dev'essere\nlassù!", spanish="¡El [CS:P]Lago Velado[CR] tiene que estar\nallí arriba!"})
  else
  SkySceneKit.say({english="[CS:P]Fogbound Lake[CR] has to be\nup there!", french="Le [CS:P]Lac des Brumes[CR] doit être\nlà-haut!", german=" Der [CS:P]Nebelsee[CR] muss da oben sein!", italian="Il [CS:P]Lago Foschia[CR] dev'essere\nlassù!", spanish="¡El [CS:P]Lago Velado[CR] tiene que estar\nallí arriba!"})
  end
  -- message_Close
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-180), 51, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(20)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
