-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/n01a2801.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] It's too tough...", french=" Snif...[K] C'est trop balaise...", german="Schnief...[K]\nDas ist härter als erwartet...", italian=" Sniff...[K] È così difficile...", spanish=" Ay...[K] Es demasiado difícil..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'll have to try again...", french=" Y va falloir que j'réessaye...", german="Ich werde es noch\neinmal versuchen...", italian=" Ma devo riprovarci...", spanish=" Tendré que volver a intentarlo..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D42P21A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(27) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DEEP_STAR_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K] [CS:N]Jirachi[CR] attacks in\nhis sleep...", french="Snif...[K] [CS:N]Jirachi[CR] attaque dans\nson sommeil...", german="Schnüff...[K] [CS:N]Jirachi[CR] greift\nwährend seines Schlafes an...", italian="Sniff...[K] [CS:N]Jirachi[CR] attacca mentre\ndorme...", spanish="Jo...[K] Resulta que [CS:N]Jirachi[CR] ataca\nmientras duerme..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" However...", french=" C'est vrai...", german=" Wie dem auch sei...", italian=" E poi...", spanish=" Pero, según él..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="He said he tosses and turns in\nhis sleep...[K] Sniff...", french="Il a dit qu'y s'agitait beaucoup\ndans son sommeil...[K] Snif...", german="Es schläft also unruhig...[K]\nSagt es... Schnüff...", italian="... ha detto che durante il sonno\nsi rigira da una parte all'altra...[K] Sniff...", spanish="Por lo visto se mueve mucho\nmientras duerme...[K] Buaa..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" But anyway![K] I've found him!", french=" Mais peu importe![K] J'l'ai trouvé!", german="Aber was soll's![K]\nIch habe es gefunden!", italian="Ma non importa![K] Almeno l'ho\ntrovato!", spanish="En fin...[K] ¡Al menos\nlo he encontrado!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I should go find [CS:N]Jirachi[CR] again!", french="Y faut que j'retourne\nvoir [CS:N]Jirachi[CR]!", german="Ich sollte [CS:N]Jirachi[CR] noch\neinmal aufsuchen!", italian="Devo raggiungere [CS:N]Jirachi[CR]\nun'altra volta!", spanish="¡Debería ir a buscar a [CS:N]Jirachi[CR]\notra vez!"})
  -- message_Close
end
