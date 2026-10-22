-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m22a0901.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetBanner2(LEVEL_V22P01A, 0, 160, 72, 18,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03C) [décor sub chargé: Sub_v01p03c]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(432, 180, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 532, 196, false, 2)
  GROUND:MoveToPosition(hero, 532, 196, false, 2)
  SkySubScreen.Show("v01p03c", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(partner, 412, 172, false, 2)
  GROUND:MoveToPosition(hero, 456, 196, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I was hoping that [CS:N]Grovyle[CR] would\nbe here.", french="J'espérais tant que [CS:N]Massko[CR]\nserait là.", german="Ich hatte gehofft, [CS:N]Reptain[CR] wäre\nhier.", italian=" Speravo che [CS:N]Grovyle[CR] fosse qui.", spanish="Esperaba que [CS:N]Grovyle[CR] estuviese\naquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I was hoping to see [CS:N]Grovyle[CR]\nhere.", french="J'espérais tant que [CS:N]Massko[CR]\nserait là.", german="Ich hatte gehofft, [CS:N]Reptain[CR] hier\nzu treffen.", italian="Speravo di incontrare [CS:N]Grovyle[CR]\nqui.", spanish="Tenía la esperanza de que\n[CS:N]Grovyle[CR] estuviera aquí."})
  else
  SkySceneKit.say({english="I was hoping to see [CS:N]Grovyle[CR]\nhere.", french="J'espérais tant que [CS:N]Massko[CR]\nserait là.", german="Ich hatte gehofft, [CS:N]Reptain[CR] hier\nzu treffen.", italian="Speravo di incontrare [CS:N]Grovyle[CR]\nqui.", spanish="Tenía la esperanza de que\n[CS:N]Grovyle[CR] estuviera aquí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It doesn't look like he's here.", french=" On dirait que ce n'est pas le cas.", german="Sieht nicht so aus, als wäre er\nhier.", italian=" Non sembra che sia qui.", spanish=" Pero supongo que no está."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" No, he's not here after all.", french=" On dirait que ce n'est pas le cas.", german=" Nein, er ist doch nicht hier.", italian=" No, non è qui.", spanish=" Pero supongo que no está."})
  else
  SkySceneKit.say({english=" I guess he's not here after all...", french=" On dirait que ce n'est pas le cas.", german="Ich denke, er ist doch nicht\nhier.", italian=" Non mi sembra che sia qui.", spanish=" Pero supongo que no está..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Speaking of not being here...[K]\nThe [CS:N]Krabby[CR] aren't here, either.", french="En parlant d'absents...[K]\nLes [CS:N]Krabby[CR] ne sont pas là, eux non plus.", german="Wo wir gerade beim\nNichthiersein sind...[K]\nDie [CS:N]Krabby[CR] sind auch nicht hier.", italian="A proposito...[K] Non ci sono\nneanche i [CS:N]Krabby[CR].", spanish="Y hablando de ausencias...[K]\nLos [CS:N]Krabby[CR] tampoco están por aquí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Speaking of not being here...[K]\nThe [CS:N]Krabby[CR] aren't here, either.", french="En parlant d'absents...[K]\nLes [CS:N]Krabby[CR] ne sont pas là, eux non plus.", german="Wo wir gerade beim\nNichthiersein sind...[K]\nDie [CS:N]Krabby[CR] sind auch nicht hier.", italian="A proposito...[K] Non ci sono\nneanche i [CS:N]Krabby[CR].", spanish="Y hablando de ausencias...[K]\nLos [CS:N]Krabby[CR] tampoco están por aquí."})
  else
  SkySceneKit.say({english="Speaking of not being here...[K]\nThe [CS:N]Krabby[CR] aren't here, either.", french="En parlant d'absents...[K]\nLes [CS:N]Krabby[CR] ne sont pas là, eux non plus.", german="Wo wir gerade beim\nNichthiersein sind...[K]\nDie [CS:N]Krabby[CR] sind auch nicht hier.", italian="A proposito...[K] Non ci sono\nneanche i [CS:N]Krabby[CR].", spanish="Y hablando de ausencias...[K]\nLos [CS:N]Krabby[CR] tampoco están por aquí."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="They're always out in the\nevening blowing bubbles.", french="D'habitude, ils sont toujours là\nle soir, à faire des bulles.", german="Die sind abends immer hier und\nlassen ihre Blasen entstehen.", italian="Di sera sono sempre in giro a\nfare le bolle.", spanish="Antes del anochecer siempre\nsalen a soplar pompitas."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="They always come out here in\nthe evening to blow bubbles.", french="D'habitude, ils sont toujours là\nle soir, à faire des bulles.", german="Die kommen abends immer\nhierher, um Blasen in die Luft zu pusten.", italian="Di sera sono sempre qui intorno\na fare le bolle.", spanish="Antes del anochecer siempre\nsalen a soplar pompitas."})
  else
  SkySceneKit.say({english="They always come out to blow\nbubbles here in the evening.", french="D'habitude, ils sont toujours là\nle soir, à faire des bulles.", german="Die kommen abends immer\nhierher, um Blasen in die Luft zu pusten.", italian="Di sera sono sempre qui intorno\na fare le bolle.", spanish="Antes del anochecer siempre\nsalen a soplar pompitas."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I love seeing their bubbles go\nfloating off.", french="J'adore regarder leurs bulles\nemportées par le vent.", german="Ich liebe es, ihre Blasen\ndavonschweben zu sehen.", italian="Adoro guardare le loro bolle\nche volano.", spanish="Me encanta ver cómo cambian\nde color con los rayos del sol."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I love seeing their bubbles go\nfloating away in the evening sky.", french="J'adore regarder leurs bulles\nemportées par le vent.", german="Ich liebe es, wie ihre Blasen\nin den Abendhimmel davonschweben.", italian="Adoro guardare le loro bolle\nvolare al tramonto.", spanish="Me encanta ver cómo cambian\nde color con los rayos del sol."})
  else
  SkySceneKit.say({english="I love seeing their bubbles go\nfloating away in the evening sky.", french="J'adore regarder leurs bulles\nemportées par le vent.", german="Ich liebe es, wie ihre Blasen\nin den Abendhimmel davonschweben.", italian="Adoro guardare le loro bolle\nvolare al tramonto.", spanish="Me encanta ver cómo cambian\nde color con los rayos del sol."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Well, that's too bad.[K] It's a\nletdown, but...", french="Ah, c'est vraiment dommage.[K]\nJe suis déçu, mais...", german="Wirklich schade.[K] Es ist eine\nEnttäuschung, aber...", italian="Beh, che peccato.[K] È una\ndelusione, ma...", spanish="Vaya, qué pena.[K]\nEs una decepción, pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Well, that's too bad.[K] It's a\nletdown, but...", french="Ah, c'est vraiment dommage.[K]\nJe suis déçu, mais...", german="Wirklich schade.[K] Es ist eine\nEnttäuschung, aber...", italian="Beh, che peccato.[K] È una\ndelusione, ma...", spanish="Vaya, qué pena.[K]\nEs una decepción, pero..."})
  else
  SkySceneKit.say({english="Well, that's too bad.[K] It's a\nletdown, but...", french="Ah, c'est vraiment dommage.[K]\nJe suis déçue, mais...", german="Wirklich schade.[K] Es ist eine\nEnttäuschung, aber...", italian="Beh, che peccato.[K] È una\ndelusione, ma...", spanish="Vaya, qué pena.[K]\nEs una decepción, pero..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...Look, [hero]...", french=" ... Regarde, [hero]...", german=" Sieh nur, [hero]...", italian=" Guarda, [hero]...", spanish=" Mira, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...Look, [hero]...", french=" ... Regarde, [hero]...", german=" Sieh nur, [hero]...", italian=" Guarda, [hero]...", spanish=" Mira, [hero]..."})
  else
  SkySceneKit.say({english=" ...Look, [hero]...", french=" ... Regarde, [hero]...", german=" Sieh nur, [hero]...", italian=" Guarda, [hero]...", spanish=" Mira, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The sunset is sure pretty, just\nlike it always is.", french="Le coucher de soleil est\nmagnifique, comme d'habitude.", german="Der Sonnenuntergang ist so\nschön wie immer.", italian="Il tramonto è bello lo stesso,\ncome sempre.", spanish="El atardecer es impresionante,\nigual que siempre."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The sunset's beautiful, like it\nalways is.", french="Le coucher de soleil est\nmagnifique, comme d'habitude.", german="Der Sonnenuntergang ist so\nschön wie immer.", italian="Il tramonto è bellissimo, come\nsempre.", spanish="El atardecer es impresionante,\nigual que siempre."})
  else
  SkySceneKit.say({english=" The sunset is sure pretty.", french="Le coucher de soleil est\nmagnifique, comme d'habitude.", german="Der Sonnenuntergang ist wirklich\nhübsch.", italian=" Il tramonto è così bello...", spanish="La puesta de sol sigue siendo\npreciosa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes una cosa...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes una cosa...?"})
  else
  SkySceneKit.say({english=" You know...", french=" Tu sais...", german=" Weißt du...", italian=" Sai...", spanish=" ¿Sabes una cosa...?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(6410) — id SE NDS sans portage PMDO identifié
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetOutputAttribute(2) [neutre/état moteur]
  GAME:WaitFrames(15)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was my dream to solve the\nsecret of my Relic Fragment.", french="C'était mon rêve de découvrir\nle secret de mon Fragment de Relique.", german="Es war mein Traum, das Rätsel\nmeines Reliktfragments zu lösen.", italian="Risolvere il segreto del\nFrammento Antico era il mio sogno.", spanish="Soñaba con desvelar el secreto\nde mi Reliquia de Piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was my dream to solve the\nsecret of my Relic Fragment.", french="C'était mon rêve de découvrir\nle secret de mon Fragment de Relique.", german="Es war mein Traum, das Rätsel\nmeines Reliktfragments zu lösen.", italian="Risolvere il segreto del\nFrammento Antico era il mio sogno.", spanish="Soñaba con desvelar el secreto\nde mi Reliquia de Piedra."})
  else
  SkySceneKit.say({english="It was my dream to solve the\nsecret of my Relic Fragment.", french="C'était mon rêve de découvrir\nle secret de mon Fragment de Relique.", german="Es war mein Traum, das Rätsel\nmeines Reliktfragments zu lösen.", italian="Risolvere il segreto del\nFrammento Antico era il mio sogno.", spanish="Soñaba con desvelar el secreto\nde mi Reliquia de Piedra."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But I would have never guessed\nthat the Relic Fragment was connected to the\n[CS:P]Hidden Land[CR].", french="Mais je n'aurais jamais deviné\nqu'il était lié aux [CS:P]Terres Illusoires[CR].", german="Aber ich hätte niemals gedacht,\ndass das Reliktfragment mit dem\n[CS:P]Verborgenen Land[CR] in Verbindung steht.", italian="Ma non avrei mai pensato che\nil Frammento Antico fosse collegato alla\n[CS:P]Terra Nascosta[CR].", spanish="Pero nunca habría imaginado que\ntuviera relación alguna con la [CS:P]Tierra Oculta[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But I would have never guessed\nthat the Relic Fragment was connected to the\n[CS:P]Hidden Land[CR].", french="Mais je n'aurais jamais deviné\nqu'il était lié aux [CS:P]Terres Illusoires[CR].", german="Aber ich hätte niemals gedacht,\ndass das Reliktfragment mit dem\n[CS:P]Verborgenen Land[CR] in Verbindung steht.", italian="Ma non avrei mai pensato che\nil Frammento Antico fosse collegato alla\n[CS:P]Terra Nascosta[CR].", spanish="Pero nunca habría imaginado que\ntuviera relación alguna con la [CS:P]Tierra Oculta[CR]."})
  else
  SkySceneKit.say({english="But I would have never guessed\nthat the Relic Fragment was connected to the\n[CS:P]Hidden Land[CR].", french="Mais je n'aurais jamais deviné\nqu'il était lié aux [CS:P]Terres Illusoires[CR].", german="Aber ich hätte niemals gedacht,\ndass das Reliktfragment mit dem\n[CS:P]Verborgenen Land[CR] in Verbindung steht.", italian="Ma non avrei mai pensato che\nil Frammento Antico fosse collegato alla\n[CS:P]Terra Nascosta[CR].", spanish="Pero nunca habría imaginado que\ntuviera relación alguna con la [CS:P]Tierra Oculta[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That reminds me...", french=" Ça me rappelle...", german=" Das erinnert mich daran...", italian=" Mi torna in mente una cosa...", spanish=" Eso me recuerda que..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That reminds me...", french=" Ça me rappelle...", german=" Das erinnert mich daran...", italian=" Mi torna in mente una cosa...", spanish=" Eso me recuerda que..."})
  else
  SkySceneKit.say({english=" That reminds me...", french=" Ça me rappelle...", german=" Das erinnert mich daran...", italian=" Mi torna in mente una cosa...", spanish=" Eso me recuerda que..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It was here that [CS:N]Koffing[CR] and\nhis sidekick stole my Relic Fragment.", french="C'est ici que [CS:N]Smogo[CR] et\nson acolyte m'ont volé mon Fragment\nde Relique.", german="Es war hier, wo [CS:N]Smogon[CR] und\nsein Handlanger mein Reliktfragment gestohlen\nhaben.", italian="È qui che [CS:N]Koffing[CR] e il suo\nscagnozzo mi hanno rubato il Frammento\nAntico.", spanish="Fue aquí donde [CS:N]Koffing[CR] y su\ncompinche me robaron la Reliquia de Piedra."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It was here, wasn't it? Where\n[CS:N]Koffing[CR] and his sidekick stole my Relic\nFragment?", french="C'est ici que [CS:N]Smogo[CR] et\nson acolyte m'ont volé mon Fragment\nde Relique.", german="Es war hier, wo [CS:N]Smogon[CR] und\nsein Handlanger mein Reliktfragment gestohlen\nhaben.", italian="È qui, vero? Che [CS:N]Koffing[CR] e il\nsuo scagnozzo mi hanno rubato il Frammento\nAntico?", spanish="Fue aquí donde [CS:N]Koffing[CR] y su\ncompinche me robaron la Reliquia de Piedra."})
  else
  SkySceneKit.say({english="It was here, wasn't it? Where\n[CS:N]Koffing[CR] and his sidekick stole my Relic\nFragment?", french="C'est ici que [CS:N]Smogo[CR] et\nson acolyte m'ont volé mon Fragment\nde Relique.", german="Es war hier, wo [CS:N]Smogon[CR] und\nsein Handlanger mein Reliktfragment gestohlen\nhaben.", italian="È qui che [CS:N]Koffing[CR] e il suo\nscagnozzo mi hanno rubato il Frammento\nAntico.", spanish="Fue aquí donde [CS:N]Koffing[CR] y su\ncompinche me robaron la Reliquia de Piedra."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(60) end)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
