-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D37P41A/s22p0302.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_WELCOME_TO_THE_WORLD_OF_POKEMON non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- back_SetGround(LEVEL_D37P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 232, 216, Direction.Down, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I cannot fathom how you've\ncome here, but...", french="J'ignore comment vous avez\nréussi à arriver ici mais...", german="Ich kann mir nicht erklären, wie\nihr hierhergekommen seid, aber...", italian="Non capisco come abbiate fatto\nad arrivare qui.", spanish="No logro entender cómo\nhabéis llegado hasta aquí, pero..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I find your visit ever so\nconvenient!", french="Je trouve que votre visite\ntombe à point nommé!", german="Ich finde euren Besuch äußerst\npraktisch!", italian="Però la vostra visita capita\nal momento giusto!", spanish="¡Vuestra visita es de lo más\noportuna!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" I've longed to meet both of you!", french="Cela fait longtemps que je\nsouhaite vous rencontrer!", german="Ich wollte euch beide schon\nlange mal treffen!", italian="È da tempo che\nvolevo incontrarvi!", spanish=" ¡Estaba deseando encontraros!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That time I wasn't dreaming, so I guess\nit never occurred to me...)", french="(Cette fois-là, je n'étais pas en train de\nrêver, mais ça ne m'avait pas frappé...)", german="(Zu dieser Zeit habe ich nicht geträumt, also\nist es mir nie richtig bewusst geworden...)", italian="(Quella volta non stavo sognando, quindi non\nci avevo mai pensato.)", spanish="(En aquella ocasión no estaba soñando, así\nque no até los cabos...)"})
  else
  SkySceneKit.say({english="(That time I wasn't dreaming, so I guess\nit never occurred to me...)", french="(Cette fois-là, je n'étais pas en train de\nrêver, mais ça ne m'avait pas frappée...)", german="(Zu dieser Zeit habe ich nicht geträumt, also\nist es mir nie richtig bewusst geworden...)", italian="(Quella volta non stavo sognando, quindi non\nci avevo mai pensato.)", spanish="(En aquella ocasión no estaba soñando, así\nque no até los cabos...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But I realize that was in [CS:N]Azurill[CR]'s nightmare.)", french="(... en y repensant, c'est vrai que nous étions\ndans le cauchemar d'[CS:N]Azurill[CR].)", german="(Aber jetzt wird mir klar, dass es in dem\nAlbtraum von [CS:N]Azurill[CR] war.)", italian="(Ma ero nell'incubo di [CS:N]Azurill[CR].)", spanish="(Pero ahora me doy cuenta de que estaba en\nla pesadilla de [CS:N]Azurill[CR].)"})
  else
  SkySceneKit.say({english="(But I realize that was in [CS:N]Azurill[CR]'s nightmare.)", french="(... en y repensant, c'est vrai que nous étions\ndans le cauchemar d'[CS:N]Azurill[CR].)", german="(Aber jetzt wird mir klar, dass es in dem\nAlbtraum von [CS:N]Azurill[CR] war.)", italian="(Ma ero nell'incubo di [CS:N]Azurill[CR].)", spanish="(Pero ahora me doy cuenta de que estaba en\nla pesadilla de [CS:N]Azurill[CR].)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(In other words, it was still in a dream.)", french="(Autrement dit, c'était quand même dans\nun rêve.)", german="(Mit anderen Worten, ich war dennoch in\neinem Traum.)", italian="(In altre parole, mi trovavo\ncomunque in un sogno.)", spanish="(En otras palabras, que también era un sueño.)"})
  else
  SkySceneKit.say({english="(In other words, it was still in a dream.)", french="(Autrement dit, c'était quand même dans\nun rêve.)", german="(Mit anderen Worten, ich war dennoch in\neinem Traum.)", italian="(In altre parole, mi trovavo\ncomunque in un sogno.)", spanish="(En otras palabras, que también era un sueño.)"})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
