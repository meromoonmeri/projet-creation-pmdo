-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/n01a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" N-nope...[K]not this way.", french=" Heu, non...[K] c'est pas par là.", german=" N-nein...[K] Nicht hier entlang.", italian=" N-No...[K] Non da questa parte.", spanish=" Hum... No...[K] No es por aquí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:K]Kecleon[CR] Market is that way.", french="Le [CS:K]Marché Kecleon[CR] est\nde ce côté.", german="Zum [CS:K]Kecleon-Markt[CR]\ngeht es da lang.", italian="Il [CS:K]Kecleon[CR] Market è\nda quella parte.", spanish=" El [CS:K]Bazar Kecleon[CR] está por allí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Lately a lot of troubling things\nhave happened. Maybe I've been a bit strange,\nyup yup...", french="Dernièrement, y'a de drôles de\ntrucs qui sont arrivés. J'me suis p'tête\ncomporté bizarrement, ouaip ouaip...", german="In letzter Zeit sind ein paar\nbeängstigende Dinge passiert. Vielleicht\nwar ich ein wenig eigenartig, jawollja...", italian="Ultimamente sono successe\nun sacco di cose strane. Ma forse è solo\nla mia immaginazione, già, già...", spanish="Últimamente están pasando\nmuchas cosas inquietantes... Fijo que me han\nafectado y yo también actúo de un modo raro..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I should hurry to\n[CS:K]Kecleon[CR] Market.", french="J'ferais bien de m'dépêcher\nd'aller au [CS:K]Marché Kecleon[CR].", german="Ich sollte so schnell wie möglich\nzum [CS:K]Kecleon-Markt[CR] gehen.", italian="Devo sbrigarmi a raggiungere\nil [CS:K]Kecleon[CR] Market.", spanish="Debería ir ya al\n[CS:K]Bazar Kecleon[CR]."})
  -- message_Close
end
