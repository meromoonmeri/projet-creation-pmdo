-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/n01a1701.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D42P21A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  local npc_npc_yukikaburi = SkySceneKit.spawn_npc("snover", 248, 288, Direction.Right, "NPC_YUKIKABURI")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Sniff...[K] It's too tough...", french=" Snif...[K] C'est trop balaise...", german="Schnief...[K]\nDas ist härter als erwartet...", italian=" Sniff...[K] È troppo difficile...", spanish=" Ay...[K] Es demasiado difícil..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" We'll head on back for now...", french="On va d'voir laisser tomber,\npour l'instant...", german="Machen wir uns fürs Erste auf\nden Rückweg...", italian="Per il momento non ci resta\nche tornare indietro...", spanish=" Por ahora mejor nos volvemos..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- SetAnimation(27) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DEEP_STAR_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(6)
  -- SetAnimation(28) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_HEAD_SHAKE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_yukikaburi, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Hmm...[K] I couldn't really do\nwell... By golly...", french="Mmh...[K] J'ai pas franchement fait\ndes étincelles, pardi!", german="Hmm...[K] Ich war nicht gut\ngenug... Donnerwetter...", italian="Uhm...[K] Forse non ce l'ho messa\nproprio tutta... Ohibò...", spanish="Hum...[K] No se me ha dado nada\nbien... Caramba..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yukikaburi, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Sniff...[K] I was so scared...", french=" Snif...[K] J'ai eu tellement peur...", german="Schnief...[K]\nIch hatte so eine Angst...", italian=" Sniff...[K] Ho avuto tanta paura...", spanish=" Jo...[K] Qué miedo he pasado..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's all right![K] I'm with you,\nyup yup!", french=" T'en fais pas![K] J'suis là, pardi!", german="Ist schon okay![K] Ich bin bei dir,\njawollja!", italian="Non preoccuparti![K] Ci sono io\ncon te, già, già!", spanish="¡No te preocupes![K] Yo estoy\ncontigo, ¡sí, señor!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="We've come all this way.\nWe just have to try a little harder!", french="On a déjà fait tout ce ch'min.\nFaut juste qu'on s'applique un chouïa plus.", german="Wir haben es schon bis hierhin\ngeschafft! Nur noch ein bisschen mehr Einsatz!", italian="Siamo stati bravi ad arrivare\nfin qui. Dobbiamo solo impegnarci un\npo' di più!", spanish="Hemos llegado hasta aquí.\n¡Solo falta el último esfuerzo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yukikaburi) end)
  SkySceneKit.say({english=" Y-yeah!", french=" Heu... ouais!", german=" G-genau!", italian=" G-Giusto!", spanish=" Ti... tienes razón."})
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
