-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P02A/m03a0108.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P02A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P02A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(336, 164, 60, false) end) -- performer/caméra
  GAME:FadeIn(30)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="This is [CS:K]Kecleon[CR] Market.[K] You\ncan buy and sell items here.", french="Voilà le [CS:K]Marché Kecleon[CR],\noù on peut acheter et vendre des objets.", german="Dies ist der [CS:K]Kecleon-Markt[CR].[K] Hier\nkannst du Items kaufen und verkaufen.", italian="Quello è il [CS:K]Kecleon[CR] Market.[K]\nLì si possono comprare e vendere\ngli strumenti.", spanish="Este es el [CS:K]Bazar Kecleon[CR].[K]\nAquí se pueden comprar y vender objetos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Here we have [CS:K]Kecleon[CR] Market.\nYou can buy and sell items here.", french="Voilà le [CS:K]Marché Kecleon[CR],\noù on peut acheter et vendre des objets.", german="Hier haben wir den\n[CS:K]Kecleon-Markt[CR]. Hier kannst du Items kaufen\nund verkaufen.", italian="Quello è il [CS:K]Kecleon[CR] Market. Lì\nsi possono comprare e vendere gli strumenti.", spanish="Esto de aquí es el [CS:K]Bazar Kecleon[CR].\nAquí se pueden comprar y vender objetos."})
  else
  SkySceneKit.say({english="This is [CS:K]Kecleon[CR] Market. You\ncan buy and sell items here.", french="Voilà le [CS:K]Marché Kecleon[CR],\noù on peut acheter et vendre des objets.", german="Dies ist der [CS:K]Kecleon-Markt[CR]. Hier\nkannst du Items kaufen und verkaufen.", italian="Quello è il [CS:K]Kecleon[CR] Market. Lì\nsi possono comprare e vendere gli strumenti.", spanish="Esto de aquí es el [CS:K]Bazar Kecleon[CR].\nAquí se pueden comprar y vender objetos."})
  end
  -- message_Close
  -- Move2PositionMark 0 [cible sans placement SSA zone: mouvement non joué]
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And there's [CS:K]Kangaskhan[CR] Storage.\nItems stored here will never be lost.", french="Et voici la [CS:K]Réserve Kangourex[CR].\nLes objets que tu déposes ici ne seront\njamais perdus.", german="Und dort ist das [CS:K]Kangama-Lager[CR].\nItems, die dort gelagert werden, gehen niemals\nverloren.", italian="E lì c'è il Deposito [CS:K]Kangaskhan[CR].\nGli strumenti conservati lì non spariscono mai.", spanish="Y luego esa de ahí es la\n[CS:K]Consigna Kangaskhan[CR]. Los objetos\nque guardemos aquí no se perderán."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And there's [CS:K]Kangaskhan[CR] Storage.\nItems stored here will never be lost.", french="Et voici la [CS:K]Réserve Kangourex[CR].\nLes objets que tu déposes ici ne seront\njamais perdus.", german="Und dort ist das [CS:K]Kangama-Lager[CR].\nItems, die dort gelagert werden, gehen niemals\nverloren.", italian="E lì c'è il Deposito [CS:K]Kangaskhan[CR].\nGli strumenti conservati lì non spariscono mai.", spanish="Y luego esa de ahí es la\n[CS:K]Consigna Kangaskhan[CR]. Los objetos\nque guardemos aquí no se perderán."})
  else
  SkySceneKit.say({english="And there's [CS:K]Kangaskhan[CR] Storage.\nItems stored here will never be lost.", french="Et voici la [CS:K]Réserve Kangourex[CR].\nLes objets que tu déposes ici ne seront\njamais perdus.", german="Und dort ist das [CS:K]Kangama-Lager[CR].\nItems, die dort gelagert werden, gehen niemals\nverloren.", italian="E lì c'è il Deposito [CS:K]Kangaskhan[CR].\nGli strumenti conservati lì non spariscono mai.", spanish="Y luego esa de ahí es la\n[CS:K]Consigna Kangaskhan[CR]. Los objetos\nque guardemos aquí no se perderán."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you have precious items that\nyou can't afford to lose, store them here\nbefore you go on an adventure.", french="Tu peux y déposer tes\nobjets précieux avant de partir à\nl'aventure afin de ne pas les perdre.", german="Wenn du kostbare Items hast,\ndie du nicht verlieren willst, lagere sie hier,\nbevor du zu einem Abenteuer aufbrichst.", italian="Prima di partire per un dungeon,\nè meglio depositare lì gli strumenti preziosi\nper non rischiare di perderli.", spanish="Si encontramos algún objeto muy\nvalioso que no queramos perder, habrá que\nguardarlo aquí antes de salir de aventuras."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you have precious items that\nyou can't afford to lose, store them here\nbefore you go on an adventure.", french="Tu peux y déposer tes\nobjets précieux avant de partir à\nl'aventure afin de ne pas les perdre.", german="Wenn du kostbare Items hast,\ndie du nicht verlieren willst, lagere sie hier,\nbevor du zu einem Abenteuer aufbrichst.", italian="Prima di partire per un dungeon,\nè meglio depositare lì gli strumenti preziosi\nper non rischiare di perderli.", spanish="Si encontramos algún objeto muy\nvalioso que no queramos perder, habrá que\nguardarlo aquí antes de salir de aventuras."})
  else
  SkySceneKit.say({english="If you have precious items that\nyou can't afford to lose, store them here\nbefore you go on an adventure.", french="Tu peux y déposer tes\nobjets précieux avant de partir à\nl'aventure afin de ne pas les perdre.", german="Wenn du kostbare Items hast,\ndie du nicht verlieren willst, lagere sie hier,\nbevor du zu einem Abenteuer aufbrichst.", italian="Prima di partire per un dungeon,\nè meglio depositare lì gli strumenti preziosi\nper non rischiare di perderli.", spanish="Si encontramos algún objeto muy\nvalioso que no queramos perder, habrá que\nguardarlo aquí antes de salir de aventuras."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And those are the basics for\nexploration teams.", french="Ce sont tous des endroits\ntrès importants pour les équipes\nd'exploration.", german="Das sind die wichtigsten Orte,\ndie ein Erkundungsteam kennen sollte.", italian="Questi sono i posti fondamentali\nper le squadre d'esplorazione.", spanish="Esos son los lugares básicos\nque debe visitar un explorador."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And those are the basic places\nthat exploration teams visit.", french="Ce sont tous des endroits\ntrès importants pour les équipes\nd'exploration.", german="Das sind die wichtigsten Orte,\ndie ein Erkundungsteam kennen sollte.", italian="Questi sono i posti fondamentali\nper le squadre d'esplorazione.", spanish="Esos son los lugares básicos\nque debe visitar un explorador."})
  else
  SkySceneKit.say({english="And those are the basic places\nthat exploration teams visit.", french="Ce sont tous des endroits\ntrès importants pour les équipes\nd'exploration.", german="Das sind die wichtigsten Orte,\ndie ein Erkundungsteam kennen sollte.", italian="Questi sono i posti fondamentali\nper le squadre d'esplorazione.", spanish="Esos son los lugares básicos\nque debe visitar un explorador."})
  end
  -- message_Close
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
end
