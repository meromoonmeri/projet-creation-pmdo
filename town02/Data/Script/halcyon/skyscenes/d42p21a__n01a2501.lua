-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/n01a2501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] It's too tough...", french=" Snif...[K] C'est trop balaise...", german="Schnief...[K]\nDas ist härter als erwartet...", italian=" Sniff...[K] È così difficile...", spanish=" Ay...[K] Es demasiado difícil..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'll have to try again...", french=" Y va falloir que j'réessaye...", german="Ich werde es noch\neinmal versuchen...", italian=" Dovrò riprovarci...", spanish=" Tendré que volver a intentarlo..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_D42P21A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
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
  GAME:WaitFrames(20)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Sniff...[K]\nIt's too tough...[K] But...", french="Snif...[K]\nC'est vachement dur...[K] Mais...", german="Schnüff...[K] Das ist so hart...[K]\nAber...", italian="Sniff...[K]\nÈ così difficile...[K] ma...", spanish="Buaa...[K]\nEs demasiado difícil...[K] Pero..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="This is my chance! Everyone\nworked so hard for me!", french="... j'peux pas laisser passer\ncette occasion! Les gars ont tout fait pour\nqu'j'y arrive!", german="Das ist meine Gelegenheit! Alle\nhaben sich solch eine Mühe für mich gegeben!", italian="... questa è la mia occasione!\nLo devo fare per tutti i miei amici che\nsi sono impegnati così tanto per me!", spanish="¡Esta es mi oportunidad! Todos\nse han esforzado mucho por mí."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I can't just give up here! Nope!", french=" J'peux pas abandonner ici! Non!", german="Ich kann hier nicht aufgeben!\nAuf gar keinen Fall!", italian="Non posso mollare adesso!\nNossignore!", spanish=" ¡No puedo rendirme ahora!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'll just have to gather up my\ncourage and try again!", french="Y faut que j'rassemble mon\ncourage et que j'm'y remette!", german="Ich muss nur die Zähne\nzusammenbeißen und es noch einmal versuchen!", italian="Devo farmi coraggio\ne riprovare!", spanish="Voy a tener que armarme de\nvalor e intentarlo de nuevo."})
  -- message_Close
end
